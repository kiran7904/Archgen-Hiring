export DESIGN_NAME = ariane
export DESIGN_NICKNAME = archgen_opt5
export PLATFORM = nangate45

export SYNTH_HIERARCHICAL = 1

# Force hierarchy preservation for all multi-cycle modules so SDC wildcards can target them
# These modules get flattened without this, making MCP constraints miss entirely
export SYNTH_KEEP_MODULES = \
  scoreboard_00000008_00000004 \
  issue_stage_NR_ENTRIES8_NR_WB_PORTS4 \
  csr_regfile_0000000000000000_1 \
  miss_handler_NR_PORTS3 \
  frontend_0000000000000000 \
  multiplier \
  ex_stage

export VERILOG_FILES = \
$(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/ariane.sv2v.v \
$(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v \
$(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_256x16.v

export SDC_FILE = \
$(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/ariane_450mhz.sdc

export ADDITIONAL_LEFS = \
$(PLATFORM_DIR)/lef/fakeram45_256x16.lef

export ADDITIONAL_LIBS = \
$(PLATFORM_DIR)/lib/fakeram45_256x16.lib

#export CORE_UTILIZATION = 50
#export CORE_ASPECT_RATIO = 1
#export CORE_MARGIN = 5
export DIE_AREA = 0 0 1500 1500
export CORE_AREA = 10 12 1448 1448

export MACRO_PLACE_HALO = 8 8
export MACRO_PLACE_CHANNEL = 20 20
export IO_CONSTRAINTS = \
$(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/io.tcl


# SKIP_GATE_CLONING set below in timing repair section

export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

# --- Aggressive Logic Retiming ---
export SYNTH_RETIME_MODULES = scoreboard_00000008_00000004

# --- Maximum Timing Over-Repair ---
# SETUP_SLACK_MARGIN=-0.1 pushes resizer to keep optimizing past 0 slack
export SETUP_SLACK_MARGIN = -0.1
# Gate cloning enabled: allows replication of high-fanout cells (critical for issue_req signal)
export SKIP_GATE_CLONING = 0
export GPL_KEEP_RESIZER_BELOW_OVERFLOW = 1
export ENABLE_PLACE_REPAIR_TIMING = 1
# 15 iterations gives resizer more budget to close remaining ~2000 violations post-scoreboard fix
export MAX_REPAIR_TIMING_ITER = 15
export SKIP_CTS_REPAIR_TIMING = 0
export GPL_ROUTABILITY_DRIVEN = 0
# 0.45 density gives router more free space for buffers around macro placement
export PLACE_DENSITY = 0.45
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 0
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 0
# DELAY 4: pushes Yosys hardest for minimum logic depth at cost of more area
export SYNTH_STRATEGY = DELAY 4
export PRE_DETAIL_PLACE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/restructure.tcl
