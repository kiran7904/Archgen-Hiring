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
