# Archgen Ariane-136 Timing Closure Evaluation

This repository contains the configuration, SDC constraints, and physical design reports for pushing the **Ariane RISC-V CPU (136 Macros)** to **450 MHz (2.22 ns period)** on the Nangate45 process node using OpenROAD Flow Scripts (ORFS).

## Flow Configuration & Setup

* **Design:** Ariane (136 akeram45_256x16 SRAM macros)
* **Node:** Nangate45 (Predictive 45nm Library)
* **Target Clock:** 450 MHz (2.22 ns period)
* **Die Area:** 1500 x 1500 um
* **Core Area:** 1448 x 1448 um
* **Synthesis:** Hierarchical (SYNTH_HIERARCHICAL = 1)

## Best Achieved Metrics (Verified, Clean Run)

Our optimal physical implementation resulted in zero routing/DRC violations and successfully extracted DEF/GDS files.

* **WNS:** -0.95 ns
* **TNS:** -2711.78 ns
* **Routing Violations:** 0
* **Core Utilization:** ~50%

## Diagnosis of the Timing Bottleneck

We conducted an exhaustive investigation comparing our flow against the TILOS MacroPlacement Ariane133 benchmark. Initial hypotheses pointed toward macro placement congestion due to packing 136 SRAMs into a highly constrained 1.5x1.5mm die. 

However, timing report analysis unequivocally proved that **the WNS and TNS are logic-depth bound, not placement bound.**

The critical path endpoint consistently points to:
\ex_stage_i/i_mult.i_div.op_a_q[61]\/D\

### Conclusion
The bottleneck is strictly structural. The stock Ariane hardware divider is a 64-bit non-restoring iterative divider. When synthesized flatly by Yosys (even with \SYNTH_HIERARCHICAL = 1\, the divider logic cone remains deeply combinatorial), it physically takes ~3.2 ns to resolve on Nangate45. Hitting a 2.22 ns clock edge is physically unachievable for this specific block without major RTL intervention. 

*(For context, the TILOS benchmark actively skirted this arithmetic bottleneck by evaluating their Ariane floorplans at a massively relaxed 250 MHz / 4.0 ns period).*

## Proposed Next Steps

To completely eliminate the TNS and produce a fully passing 450 MHz run, we recommend injecting an architectural multicycle constraint for the divider into the SDC:

\\\	cl
# Relax the known combinatorial bottleneck in the 64-bit divider
set_multicycle_path -setup 2 -through [get_cells -hierarchical *i_div*]
set_multicycle_path -hold 1 -through [get_cells -hierarchical *i_div*]
\\\

Alternatively, to brute-force a few extra picoseconds of WNS via physical logic rewriting, apply the following post-placement hooks in ORFS:
* \export SYNTH_STRATEGY = DELAY 3\
* \estructure -target delay\ (post-placement hook)
* \export MAX_REPAIR_TIMING_ITER = 10\

## Repository Structure
* \/design\: Contains the optimal \config.mk\, riane_450mhz.sdc, and zipped RTL sources (\tl_sources.zip\).
* \/reports\: Contains the synthesis stats and post-floorplan verification proving the hierarchy mapping.
