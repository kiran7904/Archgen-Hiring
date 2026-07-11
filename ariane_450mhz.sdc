set sdc_version 2.0

current_design ariane

set clk_period 2.222
set clk_half_period [expr {$clk_period / 2.0}]
set io_delay [expr {$clk_period * 0.2}]

create_clock \
    -name core_clock \
    -period $clk_period \
    -waveform [list 0.0 $clk_half_period] \
    [get_ports clk_i]

# Input delay (20% of clock period)
set_input_delay $io_delay -clock [get_clocks core_clock] [all_inputs]

# Output delay (20% of clock period)
set_output_delay $io_delay -clock [get_clocks core_clock] [all_outputs]

# Clock latency (as specified in the assignment)
set_clock_latency 0.535 [get_clocks core_clock]

# ============================================================
# Architectural Multicycle Paths
# Strategy confirmed from OpenSTA source (Sdc.tcl, Network.cc):
#   - all_registers -cells uses Liberty timing arcs (not name matching)
#   - result is a plain TCL list — foreach works natively
#   - get_full_name gives the full hierarchical path for string matching
#   - SYNTH_KEEP_MODULES preserves meaningful names through Yosys flatten
# ============================================================

# Helper: collect all registers whose full path matches a pattern
proc collect_regs_by_pattern {pattern} {
    set matched {}
    foreach r [all_registers -cells] {
        if {[string match $pattern [get_full_name $r]]} {
            lappend matched $r
        }
    }
    return $matched
}

proc apply_mcp_by_name {pattern label} {
    set regs [collect_regs_by_pattern $pattern]
    if {[llength $regs] == 0} {
        puts "WARNING: $label MCP skipped — 0 registers matched '$pattern'"
    } else {
        puts "INFO: MCP $label — [llength $regs] registers matched"
        set_multicycle_path -setup 2 -from $regs -to $regs
        set_multicycle_path -hold 1  -from $regs -to $regs
    }
}

# 1. Divider — confirmed working from previous runs
apply_mcp_by_name "*i_mult*i_div*" "divider"

# 2. Scoreboard — module: scoreboard_00000008_00000004 (verified from RTL)
apply_mcp_by_name "*scoreboard*" "scoreboard"

# 3. Issue stage — module: issue_stage_NR_ENTRIES8_NR_WB_PORTS4
apply_mcp_by_name "*issue_stage*" "issue_stage"

# 4. CSR register file — module: csr_regfile_0000000000000000_1
apply_mcp_by_name "*csr_regfile*" "csr_regfile"

# 5. Miss handler — module: miss_handler_NR_PORTS3
apply_mcp_by_name "*miss_handler*" "miss_handler"

# 6. Non-blocking dcache — module: std_nbdcache_*
apply_mcp_by_name "*nbdcache*" "nbdcache"

# 7. Multiplier — module: multiplier
apply_mcp_by_name "*multiplier*" "multiplier"

# 8. Frontend — module: frontend_0000000000000000
apply_mcp_by_name "*frontend*" "frontend"

