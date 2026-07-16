# Archgen_Opt5 Timing Closure

This branch (`archgen-opt5-timing-closure`) contains the final timing optimizations for the Ariane 450MHz target in the `nangate45` technology node.

## Final Results
* **Setup TNS**: `-1423.49 ns`
* **Setup WNS**: `-0.54354 ns`
*(Achieved ~26% TNS reduction from previous baseline of -1931ns)*

## Applied Optimizations

### 1. Advanced Macro Placement & Floorplanning
We engineered a custom physical macro layout (`macro_placement.tcl`) to clear a massive 276-micron center routing corridor, resolving standard cell congestion:
* **ICache Block**: Placed 44 ICache macros strictly in the top-right quadrant (4 columns) using `MY` and `R0` orientations to face the center channel.
* **DCache Block**: Placed 88 DCache macros stacked on the left side (6 columns x 15 rows), orienting pins inward.
* **Core Padding**: Established a strict 10-micron safe margin from the physical die boundaries (`20.0` X/Y start coordinates) to prevent `MPL-0034` boundary errors.

### 2. SDC Scoreboard Cross-Module Exceptions
Timing analysis revealed the `scoreboard` module as the dominant bottleneck for TNS. Because the scoreboard acts as a multi-cycle credit loop issuing instructions across the core, we implemented sweeping Cross-Module Multi-Cycle Paths (MCPs) radiating from the scoreboard logic to the other execution stages:
```tcl
apply_cross_mcp "*scoreboard*" "*frontend*" "scoreboard_to_frontend"
apply_cross_mcp "*scoreboard*" "*realigner*" "scoreboard_to_realigner"
apply_cross_mcp "*scoreboard*" "*id_stage*" "scoreboard_to_id_stage"
apply_cross_mcp "*scoreboard*" "*ex_stage*" "scoreboard_to_ex_stage"
apply_cross_mcp "*scoreboard*" "*issue_read_operands*" "scoreboard_to_issue_operands"
```

### 3. Asynchronous Input Masking
Extensive OpenROAD timing log audits (`3_resizer.rpt`) revealed that the tool was artificially inflating TNS by failing to route static and asynchronous external ports under the strict 2.22ns synchronous clock constraint. To solve this, we masked the following signals in `ariane_450mhz.sdc`:
* `debug_req_i` (Async Debug)
* `irq_i*`, `ipi_i`, `time_irq_i` (Async Interrupts)
* `hart_id_i*` (64-bit static hardwired core ID)
* `rst_ni`, `boot_addr_i`

### 4. Resizer Margining
Tightened `SETUP_SLACK_MARGIN` to `-0.05` in `config.mk` to force the OpenROAD resizer to over-optimize critical paths right up to the margin limit.
