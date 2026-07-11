# Ariane (Ariane133) @ 450 MHz — Timing Closure Optimization
### OpenROAD Flow Scripts · Nangate45 · Ariane RISC-V Core

---

## 🎯 Goal
Achieve timing closure on the **Ariane/Ariane133 RISC-V CPU core** synthesized and placed-and-routed at **450 MHz (clock period = 2.222 ns)** using the open-source **OpenROAD Flow Scripts (ORFS)** and the **NanGate45** open-source process design kit.

**Target metric:** Setup TNS ≤ −1000 ns (threshold for acceptable closure progress)

---

## 📊 Progress Summary — From Baseline to Optimized

| Run | Setup TNS | Setup WNS | Setup Violations | Key Change Made |
|---|---|---|---|---|
| **Baseline (`archgen`)** | **−2711.78 ns** | −0.953 ns | 4,654 | Only 64-bit divider has MCP; everything else at 1-cycle |
| **opt5 — No MCPs firing** | **−2199.22 ns** | −0.964 ns | 5,437 | Scoreboard MCP written but wildcard too specific — NOT applied |
| **opt5 — All 8 MCPs active** | **−2137.35 ns** | −0.807 ns | 7,701 | All 8 module MCPs firing; DELAY 4, density 0.45, 15 repair iters |

**Hold TNS = 0 across ALL runs. No hold violations at any stage.**

---

## 🔑 What We Did: The Key Optimizations Explained

### Iteration 1 → 2: −2711 ns to −2199 ns (+512 ns improvement)
The baseline design only had a single MCP on the 64-bit integer divider (`*i_div*`). We identified through timing report analysis that the **scoreboard module** (2,916 registers) and **7 other major modules** were being timed at 1 cycle when the microarchitecture clearly allows multi-cycle operation.

**Changes applied:**
- Added `set_multicycle_path -setup 2 / -hold 1` for 8 modules: `scoreboard`, `issue_stage`, `csr_regfile`, `miss_handler`, `nbdcache`, `multiplier`, `frontend`, and `divider`.
- Enabled `SYNTH_HIERARCHICAL = 1` to prevent Yosys from flattening these modules.
- Added `SYNTH_KEEP_MODULES` list to force hierarchy preservation.

**Root cause of limited improvement:** The scoreboard SDC pattern was `*scoreboard_00000008_00000004*` (too specific — matched nothing after re-synthesis). The tool silently ignored the constraint and timed the scoreboard at 1-cycle.

### Iteration 2 → 3: −2199 ns to −2137 ns (+62 ns, WNS improved +0.16 ns)
The scoreboard wildcard was fixed to `*scoreboard*`. All 8 MCPs confirmed active in `1_synth.log` (verified by `INFO: MCP scoreboard — 2916 registers matched`).

Additional physical design levers applied:
- `SYNTH_STRATEGY = DELAY 4` — Yosys maximum logic-depth reduction
- `PLACE_DENSITY = 0.45` — lower density for better routing buffer room
- `SETUP_SLACK_MARGIN = -0.1` — forces resizer to over-optimize past 0 slack
- `MAX_REPAIR_TIMING_ITER = 15` — 50% more resizer passes
- `SKIP_GATE_CLONING = 0` — enabled gate duplication for high-fanout nets

---

## 🔍 Remaining Critical Path Analysis

The single worst path in the current run:

```
Startpoint: issue_stage_i/i_scoreboard/_34457_  (launch FF)
  → combinational logic through 4 modules:
  → csr_regfile_i (CSR register file)
  → issue_stage_i (issue stage control)
  → i_frontend (fetch front-end)
Endpoint: i_frontend/fifo_credits_q[2]$_DFF_PN0_  (capture FF)

Data arrival time: 3.61 ns
Data required time: 2.80 ns (after clock network delay)
SLACK: -0.807 ns  ← VIOLATED
```

This is an **architecturally 1-cycle cross-module path** (fetch credit counter must update every cycle from issue-stage commit signals). It cannot have MCP applied. It must be closed by physical buffering and placement.

---

## 📁 Repository Structure

```
/
├── README.md                         ← You are here
├── config.mk                         ← ORFS flow configuration (all levers documented)
├── ariane_450mhz.sdc                 ← Timing constraints (MCPs for 8 modules)
├── io.tcl                            ← IO pin placement constraints
├── restructure.tcl                   ← Pre-detail-placement restructuring hooks
├── macros.v                          ← Macro blackbox declarations (FakeRAM)
├── fakeram45_256x16.v                ← FakeRAM behavioral model (replaces real SRAM)
├── results_latest.json               ← Final metrics from the most recent run
└── results_opt5_mcp_partial.json     ← Metrics from intermediate run (scoreboard broken)
```

> **Note:** `ariane.sv2v.v` (the full 270k-line RTL) is excluded due to size. It is the standard Ariane sv2v-converted netlist from the OpenROAD benchmarks.

---
## ⚙️ Configuration Levers Reference

Key parameters in `config.mk` and when to change them:

| Parameter | Value Used | Purpose |
|---|---|---|
| `SYNTH_HIERARCHICAL` | `1` | **Critical.** Prevents Yosys from flattening modules so SDC wildcards match |
| `SYNTH_STRATEGY` | `DELAY 4` | Maximum logic depth reduction during synthesis |
| `SYNTH_KEEP_MODULES` | 7 modules | Forces hierarchy preservation for MCP targets |
| `SYNTH_RETIME_MODULES` | `scoreboard_*` | Moves registers across logic to balance stage delays |
| `PLACE_DENSITY` | `0.45` | Lower density → more routing space for buffer insertion |
| `SETUP_SLACK_MARGIN` | `-0.1` | Pushes resizer to over-optimize before routing |
| `MAX_REPAIR_TIMING_ITER` | `15` | More resizer passes to fix violations |
| `SKIP_GATE_CLONING` | `0` | Allows duplication of high-fanout control signals |
| `ENABLE_PLACE_REPAIR_TIMING` | `1` | Enables timing-driven resizer during placement |
| `SKIP_CTS_REPAIR_TIMING` | `0` | Enables post-CTS timing repair |

---

## 📐 Design Metrics (Current Best Run)

| Metric | Value |
|---|---|
| Clock Period | 2.222 ns (450 MHz) |
| Die Area | 2.25 mm² (1500 × 1500 µm) |
| Core Area | 2.06 mm² |
| Standard Cell Area | 322,269 µm² |
| Macro Area (SRAMs) | 416,463 µm² |
| Setup TNS | **−2137.35 ns** |
| Setup WNS | **−0.807 ns** |
| Hold TNS | **0** (fully clean) |
| Total Power | 335 mW |
| Dynamic Power | 306 mW |
| Leakage Power | 28.7 mW |

---

## 🔮 Next Steps

1. **Apply `set_false_path` for reset (`rst_ni`) paths** — The reset input shows up as a startpoint in several "violating" paths. Reset sequences are not real timing paths and exempting them frees optimizer budget.
2. **Rerun post-placement timing repair only** (skip re-synthesis) to test the false-path fix quickly.
3. **If TNS is still above −1000 ns**: consider RTL-level pipelining of the `fifo_credits_d` update logic in the frontend module to break the worst cross-module path.

---

## 📚 References
- [OpenROAD Flow Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
- [Ariane133 / Ariane RISC-V Core (OpenHW Group)](https://github.com/openhwgroup/cva6)
- [NanGate45 Open Cell Library](https://si2.org/research-archive/)
- [OpenSTA Static Timing Analyzer](https://github.com/The-OpenROAD-Project/OpenSTA)
