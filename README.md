# Archgen Hiring Assignment – RTL-to-GDSII Implementation of Ariane133

> **Submitted by:** Kiran Kumar Siripurapu

---

## Introduction

This repository presents my implementation of the Archgen Hiring Assignment, where the objective was to implement the **Ariane133** processor from the ChiPBench benchmark using the **OpenROAD** open-source ASIC physical design flow on the **Nangate45** technology.

The project involved building and configuring the complete RTL-to-GDSII implementation flow using open-source EDA tools, starting from the provided RTL and timing constraints. The implementation covers every major stage of the physical design flow, including synthesis, floorplanning, macro placement, power distribution network generation, placement optimization, clock tree synthesis, global routing, detailed routing, metal fill, static timing analysis, and final GDSII generation.

Throughout the implementation, I configured the OpenROAD flow, integrated the provided design constraints, resolved multiple toolchain and implementation issues, optimized the physical design flow, and successfully generated all required implementation artifacts, including the final routed database, reports, DEF, and GDSII layout.

This document describes the complete implementation process, the commands used at each stage, the issues encountered during the flow, the debugging and solutions applied, and the final implementation results obtained using the OpenROAD toolchain.

## Project Objectives

The primary objective of this assignment was to implement the provided **Ariane133** RTL design using the **OpenROAD** open-source ASIC implementation flow on the **Nangate45** technology node.

The implementation involved configuring the complete physical design flow, applying the provided timing and physical constraints, resolving implementation and toolchain issues, and generating the final physical design database and layout.

The main objectives of this project were:

- Implement the provided Ariane133 RTL using the OpenROAD physical design flow.
- Configure the design for the Nangate45 / FreePDK45 technology.
- Apply the required timing constraints for a target operating frequency of **450 MHz**.
- Perform synthesis, floorplanning, placement, clock tree synthesis, global routing, detailed routing, and final layout generation.
- Generate the required implementation artifacts, including ODB, DEF, GDSII, timing reports, routing reports, and implementation logs.
- Analyze the implementation results and document the complete physical design flow along with the issues encountered and the solutions applied during the implementation process.

## Design Specifications

The implementation was carried out using the **Ariane133** processor RTL provided as part of the Archgen Hiring Assignment. The design was implemented using the **Nangate45** open-source technology library and the complete physical implementation flow was executed using **OpenROAD**.

### Design Summary

| Parameter | Value |
|-----------|-------|
| Design Name | Ariane133 |
| Top Module | `ariane` |
| RTL Source | ChiPBench Benchmark |
| Technology | Nangate45 / FreePDK45 |
| Standard Cell Library | Nangate Open Cell Library |
| SRAM Macro | `fakeram45_256x16` |
| Physical Design Flow | OpenROAD-flow-scripts |
| Target Frequency | 450 MHz |
| Clock Period | 2.222 ns |
| Clock Port | `clk_i` |
| Clock Name | `core_clock` |

### Implementation Requirements

The physical design flow was implemented according to the assignment requirements. The complete RTL-to-GDSII implementation included the following stages:

1. RTL Synthesis
2. Floorplanning
3. Macro Placement
4. Power Distribution Network (PDN) Generation
5. Placement Optimization
6. Clock Tree Synthesis (CTS)
7. Global Routing
8. Detailed Routing
9. Metal Fill
10. Static Timing Analysis (STA)
11. Final GDSII Generation

The objective was to successfully implement the provided RTL while applying the required timing and physical constraints and generating all implementation artifacts required for physical verification and analysis.


## Development Environment & Toolchain

The complete physical design flow was implemented on **Ubuntu 24.04 running under Windows Subsystem for Linux (WSL2)**. The OpenROAD flow was executed using the **Nix development environment**, which provides all required EDA tools and their dependencies.

During the implementation, the WSL memory configuration was increased to support detailed routing of the Ariane133 design, as the default memory allocation was insufficient for TritonRoute.

### System Configuration

| Component | Configuration |
|-----------|---------------|
| Host Operating System | Windows 11 |
| Linux Environment | Ubuntu 24.04 (WSL2) |
| Development Environment | Nix Shell |
| Processor | Intel/AMD x86-64 |

### EDA Toolchain

| Tool | Purpose |
|------|---------|
| OpenROAD | Physical Design Flow |
| OpenROAD-flow-scripts | Complete RTL-to-GDSII Automation |
| Yosys | RTL Synthesis |
| OpenSTA | Static Timing Analysis |
| TritonRoute | Detailed Routing |
| FastRoute | Global Routing |
| KLayout | GDSII Visualization |
| Nangate45 / FreePDK45 | Technology Library |

### Technology Libraries

The implementation was performed using the **Nangate45 Open Cell Library** along with the provided SRAM macro library.

The following technology files were used throughout the implementation:

- Nangate45 Liberty (.lib)
- Nangate45 LEF (.lef)
- Nangate45 Technology LEF
- FakeRAM45 SRAM LEF
- FakeRAM45 Liberty Model
- FreePDK45 Technology Files

### Design Configuration

The OpenROAD flow was configured using the design configuration file:

```text
designs/nangate45/archgen/config.mk
```

The following design files were integrated into the flow:

- RTL Netlist (`ariane.sv2v.v`)
- SRAM Wrapper Modules (`macros.v`)
- Timing Constraints (`ariane_450mhz.sdc`)
- Physical Constraints (`physical_hints.tcl`)
- IO Placement Constraints (`io.tcl`)


## Project Directory Structure

The project was organized using the standard OpenROAD-flow-scripts directory structure. The RTL, constraints, configuration files, generated reports, logs, and implementation results were maintained in separate directories to simplify execution and debugging throughout the implementation flow.

```text
Archgen-Hiring/
├── rtl/
│   ├── ariane.sv2v.v
│   ├── macros.v
│   └── LICENSE
│
├── constraints/
│   ├── ariane_450mhz.sdc
│   ├── physical_hints.tcl
│   └── io.tcl
│
├── flow/
│   ├── designs/
│   │   └── nangate45/
│   │       └── archgen/
│   │           ├── config.mk
│   │           └── ariane_450mhz.sdc
│   │
│   ├── logs/
│   ├── reports/
│   ├── results/
│   └── objects/
│
└── README.md
```

### Directory Description

| Directory | Description |
|-----------|-------------|
| `rtl/` | Contains the provided Ariane133 RTL, SRAM wrapper modules, and associated license files. |
| `constraints/` | Contains the timing constraints, physical implementation hints, and IO placement constraints provided as part of the assignment. |
| `designs/nangate45/archgen/` | Contains the OpenROAD design configuration (`config.mk`) and the design-specific timing constraint file used by the implementation flow. |
| `logs/` | Stores execution logs generated for every stage of the physical design flow. These logs were used extensively for debugging implementation issues. |
| `reports/` | Contains timing reports, routing reports, congestion reports, placement reports, and final implementation metrics generated by OpenROAD. |
| `results/` | Stores all generated implementation databases and design outputs, including ODB, DEF, GDSII, and intermediate stage results. |
| `objects/` | Contains intermediate implementation databases and temporary files generated during execution of the OpenROAD flow. |


## Design Requirements

The objective of this assignment was to implement the provided **Ariane133** RISC-V processor using the OpenROAD physical design flow on the **Nangate45** technology node and generate a routed GDSII database.

The complete RTL-to-GDS flow performed for this project includes:

1. RTL Synthesis using Yosys
2. Floorplanning
3. Macro Placement
4. Power Distribution Network (PDN) generation
5. Global Placement
6. Detailed Placement
7. Clock Tree Synthesis (CTS)
8. Global Routing
9. Detailed Routing
10. Filler Cell Insertion
11. Metal Density Fill
12. Final Report Generation
13. GDSII Generation

The design was implemented using the provided timing and physical constraints.


# Project Structure

```
Archgen-Hiring/
├── constraints/
│   ├── ariane_450mhz.sdc          # Timing constraints
│   ├── io.tcl                     # IO placement constraints
│   └── physical_hints.tcl         # Physical design hints
│
├── rtl/
│   ├── ariane.sv2v.v             # Flattened Ariane133 RTL
│   ├── macros.v                  # SRAM wrapper modules
│   └── LICENSE
│
├── flow/
│   ├── designs/
│   │   └── nangate45/
│   │       └── archgen/
│   │           ├── config.mk
│   │           └── ariane_450mhz.sdc
│   │
│   ├── results/                  # Generated implementation databases
│   ├── reports/                  # Timing and implementation reports
│   ├── logs/                     # Flow logs
│   └── objects/                  # Intermediate flow objects
│
└── README.md
```

### Directory Description

| Directory | Description |
|----------|-------------|
| `rtl/` | Contains the Ariane133 RTL and SRAM wrapper modules used for synthesis. |
| `constraints/` | Contains the timing and physical constraints provided for the assignment. |
| `flow/designs/nangate45/archgen/` | Contains the OpenROAD design configuration and design-specific SDC used during implementation. |
| `results/` | Contains the generated implementation databases, DEF, GDSII, SPEF, SDC, and final gate-level netlist. |
| `reports/` | Contains timing, congestion, area, DRC, and other implementation reports generated during the flow. |
| `logs/` | Contains logs for each implementation stage, useful for debugging and analyzing the flow. |
| `objects/` | Stores intermediate objects generated by OpenROAD during the implementation flow. |


### Timing Constraints

| Parameter | Value |
|-----------|------:|
| Clock Name | `core_clock` |
| Clock Port | `clk_i` |
| Target Frequency | **450 MHz** |
| Clock Period | **2.222 ns** |
| Input Delay | **20% of clock period (0.444 ns)** |
| Output Delay | **20% of clock period (0.444 ns)** |
| Clock Latency | **0.535 ns** |

### Physical Constraints

| Parameter | Value |
|-----------|------:|
| Technology | Nangate45 / FreePDK45 |
| SRAM Macro | `fakeram45_256x16` |
| Initial Die Area | `0 0 1500 1500` |
| Initial Core Area | `10 12 1448 1448` |
| Macro Halo | `10 µm × 10 µm` |
| Macro Channel | `20 µm × 20 µm` |
| Routing Layers | Metal2 – Metal10 |

During implementation, the design successfully completed every stage of the physical design flow, including detailed routing, filler insertion, density fill, report generation, and GDSII generation.


## Toolchain and Environment

The physical design flow was executed on Ubuntu running under WSL2 using the OpenROAD open-source ASIC toolchain.

### Operating System

| Component | Version |
|-----------|---------|
| Host Operating System | Windows 11 |
| Linux Distribution | Ubuntu 24.04.4 LTS |
| Kernel | Linux 6.6.87.2-microsoft-standard-WSL2 |
| Python | 3.13.9 |
| Tcl | 8.6.16 |

### EDA Tools

| Tool | Version |
|------|---------|
| OpenROAD | Commit `dcf36133a369abc8f3c5e5738cd4d82e4903c0e0` |
| OpenROAD Source | Commit `f4e5e40f4755f135fea8e567c8c6822136b48729` |
| OpenROAD-flow-scripts | `master` branch |
| Yosys | 0.62 (Git SHA: `7326bb7d6641500ecb285c291a54a662cb1e76cf`) |
| OpenSTA | 2.7.0 |
| KLayout | 0.30.7 |

### Technology Libraries

The implementation was carried out using the Nangate45 technology platform provided with OpenROAD-flow-scripts.

- **Technology Node:** Nangate45 / FreePDK45
- **Standard Cell Library:** Nangate Open Cell Library
- **SRAM Macro Library:** `fakeram45_256x16`
- **LEF Files:** Nangate45 Technology LEF, Standard Cell LEF, FakeRAM45 LEF
- **Liberty Files:** Nangate45 Typical Liberty and FakeRAM45 Liberty

# Design Constraints

The Ariane133 design was implemented using the timing and physical constraints provided as part of the assignment. The timing constraints were defined in `ariane_450mhz.sdc`, while the physical implementation used the Nangate45 technology library and the recommended floorplanning parameters.

## Timing Constraints

| Parameter | Value |
|-----------|-------|
| Top Module | `ariane` |
| Clock Name | `core_clock` |
| Clock Port | `clk_i` |
| Target Frequency | **450 MHz** |
| Clock Period | **2.222 ns** |
| Input Delay | **20% of clock period (0.444 ns)** |
| Output Delay | **20% of clock period (0.444 ns)** |
| Clock Latency | **0.535 ns** |

The clock was created on the `clk_i` input port with a period of **2.222 ns**. Input and output delays were constrained to **20% of the clock period**, and a clock latency of **0.535 ns** was applied as specified in the assignment.

## Physical Constraints

| Parameter | Value |
|-----------|-------|
| Technology | Nangate45 / FreePDK45 |
| Standard Cell Library | Nangate Open Cell Library |
| SRAM Macro | `fakeram45_256x16` |
| Initial Die Area | `0 0 1500 1500` |
| Initial Core Area | `10 12 1448 1448` |
| Macro Halo | `10 µm × 10 µm` |
| Macro Channel | `20 µm × 20 µm` |
| Routing Layers | Metal2 – Metal10 |

These constraints served as the starting point for the complete RTL-to-GDSII implementation flow.

# Physical Design Flow

The Ariane133 RTL was implemented using the OpenROAD-flow-scripts framework on the Nangate45 technology node. The complete backend implementation followed the standard ASIC physical design flow, beginning with RTL synthesis and ending with GDSII generation.

The implementation was carried out through the following stages:

1. RTL Synthesis
2. Floorplanning
3. Macro Placement
4. Tap Cell Insertion
5. Power Distribution Network (PDN) Generation
6. Placement
7. Clock Tree Synthesis (CTS)
8. Global Routing
9. Detailed Routing
10. Filler Cell Insertion
11. Density Fill
12. Final Report Generation
13. GDSII Generation

2_1_floorplan.odb → Floorplan
2_2_floorplan_macro.odb → Macro Placement
2_3_floorplan_tapcell.odb → Tap Cell Insertion
2_4_floorplan_pdn.odb → PDN Generation
3_1...3_5 → Placement
4_1 → CTS
5_1 → Global Routing
5_2 → Detailed Routing
5_3 → Filler Cell Insertion
6_1_fill → Density Fill
6_report → Final Report
6_final.gds → GDSII Generation

Each stage generated intermediate databases, reports, and logs that were used as inputs for the subsequent implementation stages.

## 1. RTL Synthesis

### Objective

The first stage of the implementation flow was RTL synthesis. The objective of this stage was to convert the provided Ariane133 RTL into a technology-mapped gate-level netlist using the Nangate45 standard cell library while preserving the original functionality of the design.

---

### RTL Inspection

Before starting synthesis, the RTL was inspected to understand the design hierarchy and verify the source files provided with the assignment.

The following checks were performed:

- Examined the project directory structure.
- Verified the size of the RTL source files.
- Identified the top-level module.
- Inspected the hierarchy of the design.
- Investigated the SRAM macro instantiations used inside the design.
- Verified the wrapper modules provided in `macros.v`.

The following commands were used during this stage:

```bash
tree -L 2
ls -lh

head -40 ariane.sv2v.v
tail -40 ariane.sv2v.v

wc -l ariane.sv2v.v

grep "^module ariane" ariane.sv2v.v
grep "^module" macros.v

grep -n "SyncSpRamBeNx64" ariane.sv2v.v
grep -n "fakeram45_256x16" macros.v

sed -n '247020,247150p' ariane.sv2v.v
```

---

### Debugging

During hierarchy verification, the Ariane133 RTL was found to instantiate several SRAM modules (`SyncSpRamBeNx64`) that were not defined inside the main RTL source.

Further inspection showed that the required SRAM wrapper definitions were provided separately in `macros.v`. These wrapper modules represent the FakeRAM macros used during physical implementation and prevent the memories from being synthesized into standard logic.

Including `macros.v` during synthesis resolved the missing module references and allowed the RTL hierarchy to be elaborated successfully.

---

### Synthesis Flow

RTL synthesis was performed using **Yosys**, followed by technology mapping and logic optimization using **ABC**.

The following commands were used during synthesis:

```tcl
yosys

read_verilog *.v

hierarchy -top ariane
proc
opt
memory
techmap
hierarchy -check
synth -top ariane
dfflibmap -liberty /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib
abc -liberty /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib
clean
check
stat

write_verilog -noattr -noexpr ariane_mapped.v
```

The complete synthesis stage of the OpenROAD flow was then executed using:

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk synth
```

### Generated Outputs

During the manual Yosys exploration, the following technology-mapped netlist was generated:

```
ariane_mapped.v
```

The automated OpenROAD synthesis flow generated the following implementation artifacts:

```
results/nangate45/archgen/base/
├── 1_2_yosys.v
├── 1_2_yosys.sdc
├── 1_synth.odb
└── 1_synth.sdc
```

### Outcome

The RTL synthesis stage completed successfully, producing a technology-mapped gate-level netlist, synthesized timing constraints, and the synthesized OpenDB database. These outputs served as the input for the floorplanning stage of the physical design flow.


## 3. Macro Placement

### Objective

The Ariane133 design contains multiple SRAM instances that are implemented as hard macros rather than synthesized standard-cell logic. Before placement, these macros must be positioned legally within the floorplan while satisfying the required halo and channel spacing constraints.

Proper macro placement is essential because the remaining placement and routing stages assume that all macros have already been aligned to the manufacturing grid.

---

### Initial Issue

Initially, the implementation proceeded directly from floorplanning to standard-cell placement without performing explicit SRAM macro placement.

During detailed routing, OpenROAD reported the following error:

```
DRT-0416
Term w_mask_in[0] contains offgrid pin shape
```

The reported SRAM pin coordinates were not aligned to the manufacturing grid, preventing the detailed router from creating legal routing connections.

Investigation showed that the SRAM macros had not been legally placed before routing, causing their pin locations to remain off-grid.

---

### Resolution

The issue was resolved by introducing the macro placement stage before standard-cell placement.

The SRAM macros were automatically placed using the OpenROAD RTL Macro Placer while applying the recommended halo and spacing constraints.

```tcl
source make_tracks.tcl

rtl_macro_placer \
    -halo_width 10 \
    -halo_height 10 \
    -target_util 0.35
```

The macro placement stage detected and placed all SRAM macros before continuing with the remaining implementation stages.

---

### Generated Output

```
results/nangate45/archgen/base/

2_2_floorplan_macro.odb
```

---

### Layout Screenshot

![Macro Placement – SRAM macros positioned in the floorplan](Macro_Placement.png)

---

### Outcome

After macro placement, all SRAM macros were legally aligned within the floorplan. This eliminated the off-grid pin issue encountered during detailed routing and enabled the subsequent placement, CTS, and routing stages to execute successfully.


## 4. Tap Cell Insertion

### Objective

After macro placement, tap cells were inserted throughout the floorplan. Tap cells provide well and substrate connections required by the fabrication process, helping prevent latch-up and ensuring proper power distribution across the design.

This stage also reserves the required spacing for tap cells before standard-cell placement begins.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk floorplan
```

OpenROAD-flow-scripts automatically executes the tap cell insertion stage as part of the floorplanning flow.

---

### Implementation

During this stage, OpenROAD:

- Inserted tap cells across the floorplan.
- Maintained the required spacing between tap cells.
- Ensured compatibility with the Nangate45 technology rules.
- Updated the design database for subsequent PDN generation and placement.

---

### Generated Output

```
results/nangate45/archgen/base/

2_3_floorplan_tapcell.odb
```

---

### Outcome

Tap cell insertion completed successfully, producing a legal floorplan with the required well and substrate connections. The updated database was then used for Power Distribution Network (PDN) generation.


## 5. Power Distribution Network (PDN) Generation

### Objective

After tap cell insertion, the Power Distribution Network (PDN) was generated to provide a robust and reliable power delivery network across the entire design. The PDN distributes the power (`VDD`) and ground (`VSS`) supplies to all standard cells and SRAM macros while minimizing IR drop and ensuring stable operation.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk floorplan
```

The PDN generation stage is automatically executed as part of the OpenROAD floorplanning flow.

---

### Implementation

During this stage, OpenROAD performed the following operations:

- Generated the power grid for the design.
- Connected the standard cells to the power network.
- Connected the SRAM macros to the power grid.
- Created horizontal and vertical power straps.
- Built the complete VDD and VSS distribution network.
- Verified that the generated PDN satisfied the Nangate45 technology rules.

The generated PDN provides the required power connectivity before standard-cell placement begins.

---

### Generated Outputs

```
results/nangate45/archgen/base/

2_4_floorplan_pdn.odb
```

---

### Outcome

The PDN generation stage completed successfully, creating the power and ground distribution network for the entire design. The resulting OpenDB database was then used as the input for the placement stage.


# OpenROAD Design Initialization

Before executing the complete physical design flow, the synthesized design was manually loaded into OpenROAD to understand how the tool constructs the design database and prepares the design for physical implementation.

The OpenROAD shell was started using:

```bash
openroad
```
                OpenROAD
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
 Liberty Files   LEF Files   Netlist
 (Timing)       (Physical)  (ariane_mapped.v)
        │           │           │
        └───────────┼───────────┘
                    │
                    ▼
              link_design ariane
                    │
                    ▼
          read_sdc ariane_450mhz.sdc
                    │
                    ▼
         OpenROAD Design Database


### Loading the Timing Libraries

The Liberty timing models for the Nangate45 standard cell library and the FakeRAM SRAM macro were first loaded. These libraries provide timing, power, and functional information required for static timing analysis and optimization.

```tcl
read_liberty /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib

read_liberty /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lib/fakeram45_256x16.lib
```

### Loading the Physical Libraries

The LEF files describing the technology, standard cells, and SRAM macros were then loaded.

```tcl

read_lef /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lef/NangateOpenCellLibrary.tech.lef

read_lef /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lef/NangateOpenCellLibrary.macro.mod.lef

read_lef /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/lef/fakeram45_256x16.lef
```

These LEF files provide OpenROAD with:

- Manufacturing technology rules
- Metal and via definitions
- Routing layer information
- Standard cell physical dimensions
- SRAM macro geometry and pin locations

### Loading the Synthesized Design

The technology-mapped netlist generated during synthesis was imported into OpenROAD.

```tcl
read_verilog ariane_mapped.v
```

The top-level design was then linked.

```tcl
link_design ariane
```

Finally, the timing constraints were loaded.

```tcl
read_sdc ariane_450mhz.sdc
```

### Initial Verification

After successfully loading the design, several OpenROAD reports were generated to verify that the design database had been created correctly.

```tcl
report_units
report_clocks
report_checks
report_design_area
```

These reports confirmed that the design, timing libraries, physical libraries, and timing constraints were correctly loaded before beginning floorplanning.

## 6. Standard Cell Placement

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk place
```

### IO Pin Placement

Before global placement could begin, IO pins were placed using the constraints from `io.tcl`. The correct metal layers used by the ORFS flow were found by searching the generated logs:

```bash
grep -R "hor_layers" ~/OpenROAD-flow-scripts/flow
# Result: place_pins -hor_layers metal5 -ver_layers metal6
```

```tcl
place_pins \
    -hor_layers metal5 \
    -ver_layers metal6 \
    -exclude left:0-500 \
    -exclude left:1000-1500 \
    -exclude right:* \
    -exclude top:* \
    -exclude bottom:*
```

**Result:** 495 I/O pins placed across 893 available slots.

### Routing Track Setup

```tcl
source ~/OpenROAD-flow-scripts/flow/platforms/nangate45/make_tracks.tcl

report_layer_rc

set_routing_layers -signal metal2-metal10

set_global_routing_layer_adjustment metal2-metal10 1.0
```

### Placement Execution

```tcl
global_placement
detailed_placement
```

**Global placement results:**
```
Global placement finished at iteration 492
Placed Cell Area:     645,749.85 µm²
Available Free Area:  2,063,415.20 µm²
Density:              0.3200 (32%)
```

**Detailed placement results:**
```
total displacement     154,193.2 µm
average displacement       1.0 µm
max displacement           4.5 µm
original HPWL        4,128,273.9 µm
legalized HPWL       4,235,751.5 µm
```

### GUI Viewing Command

```bash
make \
  DESIGN_CONFIG=designs/nangate45/archgen/config.mk \
  OPENROAD_EXE=$(which openroad) \
  gui_3_5_place_dp
```

### Layout Screenshot

![Standard Cell Placement – core area fully populated with logic cells](placement.png)

---

## 7. Clock Tree Synthesis (CTS)

### Objective

Clock Tree Synthesis (CTS) constructs a balanced clock distribution network that delivers the clock signal from the source to every sequential element in the design. The primary goals of CTS are to minimize clock skew, reduce insertion delay, and prepare the design for timing closure.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk cts
```

> **Note on wire RC:** Before running CTS manually, wire resistance/capacitance values must be set. These were found by searching the platform files:
>
> ```bash
> grep -R "set_wire_rc" ~/OpenROAD-flow-scripts/flow/platforms/nangate45
> # Result: set_wire_rc -signal -layer metal3
> #         set_wire_rc -clock  -layer metal5
> source /home/kiran/OpenROAD-flow-scripts/flow/platforms/nangate45/setRC.tcl
> ```

---

### Implementation

During this stage, OpenROAD performed the following operations:

- Generated the clock tree for the `core_clock`.
- Inserted clock buffers and inverters where required.
- Balanced the clock paths to reduce skew.
- Optimized clock insertion delay.
- Updated the timing information after clock tree construction.

The CTS stage used the timing constraints defined in `ariane_450mhz.sdc`, including:

- Clock Period: **2.222 ns (450 MHz)**
- Input Delay: **20% of clock period**
- Output Delay: **20% of clock period**
- Clock Latency: **0.535 ns**

---

### Generated Outputs

The CTS stage generated the following implementation artifacts:

```
results/nangate45/archgen/base/

4_1_cts.odb
4_cts.odb
4_cts.sdc
```

### GUI Viewing Command

```bash
make \
  DESIGN_CONFIG=designs/nangate45/archgen/config.mk \
  OPENROAD_EXE=$(which openroad) \
  gui_4_1_cts
```

### Layout Screenshot

![Clock Tree Synthesis – clock buffers distributed across the design](clock_tree_synthesis.png)

---

### Outcome

Clock Tree Synthesis completed successfully, generating a balanced clock distribution network for the Ariane133 design. The updated timing database and clock tree were then used as inputs for the global routing stage.


## 8. Global Routing

### Objective

The purpose of the Global Routing stage is to determine an approximate routing path for every net in the design before detailed routing begins. Instead of generating the final metal wires, OpenROAD estimates routing paths, distributes routing demand across the available metal layers, and identifies congestion hotspots.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk grt
```

---

### Routing Configuration

Before executing global routing, the routing tracks defined for the Nangate45 technology were loaded.

```tcl
source ~/OpenROAD-flow-scripts/flow/platforms/nangate45/make_tracks.tcl
```

The `make_tracks.tcl` script defines the routing grid for each metal layer by specifying the routing pitch and offset. These tracks represent the legal locations where routing wires may be placed during the routing stages.

For example, the routing tracks for Metal2 are defined as:

```tcl
make_tracks metal2 \
    -x_offset 0.095 \
    -x_pitch 0.19
```

This creates routing tracks on Metal2 every **0.19 µm**, starting from an offset of **0.095 µm**.

The routing resistance and capacitance information for each routing layer was verified using:

```tcl
report_layer_rc
```

Signal routing was restricted to the recommended routing layers:

```tcl
set_routing_layers -signal metal2-metal10
```

To maximize routing flexibility, the routing layer adjustment was configured as:

```tcl
set_global_routing_layer_adjustment metal2-metal10 1.0
```

A routing adjustment of **1.0** makes the complete routing capacity of Metal2 through Metal10 available to the global router during congestion estimation.

---

### Global Routing Execution

Global routing was executed using:

```tcl
global_route {*}$global_route_args
```

During this stage, OpenROAD:

- Estimated routing paths for all signal nets.
- Distributed routing demand across Metal2 to Metal10.
- Performed congestion analysis.
- Generated routing guides for the detailed router.
- Estimated routing parasitics for timing analysis.

---

### Generated Outputs

The global routing stage generated the following implementation artifacts:

```
results/nangate45/archgen/base/

5_1_grt.odb
5_1_grt.sdc
route.guide
```

### GUI Viewing Command

```bash
make \
  DESIGN_CONFIG=designs/nangate45/archgen/config.mk \
  OPENROAD_EXE=$(which openroad) \
  gui_5_1_grt
```

### Layout Screenshot

![Global Routing – routing guides generated for all signal nets](Global_Routing.png)

---

### Outcome

Global routing completed successfully and produced routing guides for all signal nets. These guides were then used by the detailed routing stage to generate the final legal routing while adhering to the technology design rules.


## 9. Detailed Routing

### Objective

The detailed routing stage converts the routing guides generated during global routing into the final physical interconnect while satisfying all technology design rules. During this stage, OpenROAD creates the actual metal wires and vias, resolves routing conflicts, fixes design rule violations, and checks for antenna violations.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk route
```

---

### Detailed Routing Execution

The detailed router was executed using:

```tcl
detailed_route {*}$detailed_route_args
```

During this stage, OpenROAD performed the following operations:

- Converted global routing guides into detailed metal routing.
- Inserted vias between routing layers.
- Performed design rule checking (DRC) during routing.
- Optimized routing paths to resolve conflicts.
- Checked for antenna violations.
- Generated the routed design database.

---

### Debugging

During the initial routing attempts, the detailed routing stage terminated before completion.

Investigation of the routing logs and Linux kernel messages (`dmesg`) revealed that the OpenROAD process was terminated by the WSL Out-of-Memory (OOM) killer. At that time, the WSL environment was configured with only **8 GB RAM** and **2 GB swap**, which was insufficient for routing the Ariane133 design.

To resolve this issue, the WSL resource allocation was increased to:

- Memory: **11 GB**
- Swap: **8 GB**

After increasing the available memory and swap space, the detailed routing stage completed successfully.

---

### Routing Results

The detailed routing stage completed without antenna violations.

```
Antenna Net Violations : 0
Antenna Pin Violations : 0
```

---

### Generated Outputs

The detailed routing stage generated the following implementation artifacts:

```
results/nangate45/archgen/base/

5_2_route.odb
5_3_fillcell.odb
5_route.odb
5_route.sdc
```

### GUI Viewing Command

```bash
make \
  DESIGN_CONFIG=designs/nangate45/archgen/config.mk \
  OPENROAD_EXE=$(which openroad) \
  gui_5_2_route
```

### Layout Screenshot

![Detailed Routing – physical metal wires and vias inserted](Detailed_Routing.png)

---

### Outcome

Detailed routing completed successfully and generated the final routed OpenDB database. The resulting design satisfied the routing requirements and was used for filler insertion, density fill, timing analysis, and GDSII generation.


## 10. Filler Cell Insertion and Density Fill

### Objective

After detailed routing, filler cells were inserted to occupy the unused spaces between standard cells. These cells ensure continuity of the power rails and satisfy manufacturing requirements without affecting the functionality of the design.

Following filler insertion, density fill was performed to improve metal density uniformity across the chip. Maintaining a uniform metal density is important for achieving reliable fabrication and reducing process variations during manufacturing.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk finish
```

---

### Filler Cell Insertion

OpenROAD inserted filler cells into all available whitespace after routing.

The following filler cells from the Nangate45 library were used:

```
FILLCELL_X1
FILLCELL_X2
FILLCELL_X4
FILLCELL_X8
FILLCELL_X16
FILLCELL_X32
```

During implementation:

- **376,371 filler instances** were inserted.
- Final design utilization remained approximately **36%**.

---

### Density Fill

After filler insertion, the density fill stage generated the final layout by inserting dummy metal where required to satisfy the manufacturing density rules of the Nangate45 technology.

This stage prepared the design for final report generation and GDSII export.

---

### Generated Outputs

```
results/nangate45/archgen/base/

5_3_fillcell.odb
5_route.odb
6_1_fill.odb
6_1_fill.sdc
```

---

### Outcome

The filler insertion and density fill stages completed successfully. The final implementation database was prepared for report generation and GDSII export.

## 11. Final Report Generation and GDSII Generation

### Objective

After completing the implementation flow, OpenROAD generated the final implementation database, timing reports, parasitic extraction, gate-level netlist, DEF, and GDSII layout. These artifacts represent the completed backend implementation of the Ariane133 design and are the primary deliverables of the physical design flow.

---

### Command Used

```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk finish
```

---

### Implementation

During the final stage, OpenROAD performed the following tasks:

- Generated the final implementation reports.
- Performed parasitic extraction.
- Generated the final routed DEF.
- Exported the final OpenDB database.
- Generated the final gate-level Verilog netlist.
- Produced the final GDSII layout.
- Generated the final timing constraint file for the implemented design.

---

### Generated Outputs

The following implementation artifacts were generated:

```
results/nangate45/archgen/base/

6_final.odb
6_final.def
6_final.gds
6_1_merged.gds
6_final.v
6_final.sdc
6_final.spef
```

### GUI Viewing Commands

```bash
# View final layout in OpenROAD GUI
make \
  DESIGN_CONFIG=designs/nangate45/archgen/config.mk \
  OPENROAD_EXE=$(which openroad) \
  gui_final

# Open GDSII in KLayout
klayout results/nangate45/archgen/base/6_final.gds

# Verify output files
ls -lh results/nangate45/archgen/base/6_final.gds
ls -lh results/nangate45/archgen/base/6_final.def
```

### Layout Screenshots

**Final Layout – OpenROAD GUI (completed routed design):**

![Final Layout – OpenROAD GUI](final_layout.png)

**Final GDS – KLayout (full chip view):**

![Final GDS in KLayout – full chip view](final_gds.png)

**Final GDS – KLayout (zoomed in, Ariane133 routing detail):**

![Final GDS in KLayout – zoomed in routing detail](gds%20ariane.png)

---

### Outcome

The complete RTL-to-GDSII implementation flow completed successfully. All final implementation databases, reports, extracted parasitics, gate-level netlist, DEF, and GDSII layout were successfully generated and verified.

The generated GDSII file represents the final physical layout of the Ariane133 design implemented on the Nangate45 technology node.

# 12. Implementation Results

The complete RTL-to-GDSII physical implementation flow was successfully executed using the OpenROAD-flow-scripts framework on the Nangate45 technology node. The design progressed through synthesis, floorplanning, macro placement, tap cell insertion, PDN generation, placement, Clock Tree Synthesis (CTS), global routing, detailed routing, filler cell insertion, density fill, and final GDSII generation.

## Implementation Summary

| Parameter | Result |
|-----------|--------|
| Design | Ariane133 |
| Technology | Nangate45 / FreePDK45 |
| Target Frequency | **450 MHz** |
| Clock Period | **2.222 ns** |
| Final Design Area | **739,979 µm²** |
| Final Utilization | **36%** |
| Filler Cells Inserted | **376,371** |
| Antenna Net Violations | **0** |
| Antenna Pin Violations | **0** |
| Final GDSII Generated | ✅ Yes |
| Final DEF Generated | ✅ Yes |
| Final SPEF Generated | ✅ Yes |
| Final Gate-Level Netlist Generated | ✅ Yes |
| Final OpenDB Generated | ✅ Yes |

## Final Generated Deliverables

The following implementation artifacts were successfully generated:

```
6_final.odb
6_final.def
6_final.gds
6_1_merged.gds
6_final.v
6_final.sdc
6_final.spef
```

## Timing Summary

The implementation was performed using the timing constraints specified in the assignment:

- Clock Frequency: **450 MHz**
- Clock Period: **2.222 ns**
- Input Delay: **20% of the clock period**
- Output Delay: **20% of the clock period**
- Clock Latency: **0.535 ns**

The complete implementation flow was successfully executed using these constraints. The final timing analysis indicated that additional optimization would be required to achieve full timing closure at the target frequency.

# 13. Challenges Encountered and Solutions

During the implementation of the Ariane133 physical design flow, several issues were encountered while configuring the OpenROAD environment and executing the backend stages. Each issue was analyzed using the generated logs and resolved before proceeding to the next stage.

| Issue | Root Cause | Resolution |
|-------|------------|------------|
| **Unresolved SRAM module hierarchy during synthesis** | The Ariane133 RTL instantiated SRAM wrapper modules that were not present in the main RTL source. | Included the provided `macros.v` file containing the FakeRAM wrapper modules, allowing Yosys to resolve the hierarchy successfully. |
| **Invalid SDC waveform (STA-0371)** | The `create_clock` command contained an invalid waveform specification that OpenROAD could not parse. | Corrected the clock waveform definition and successfully reloaded the timing constraints. |
| **GPL-0326: Top-level IO port not placed** | Global placement was executed before IO pin placement. | Applied the IO placement constraints and executed the `place_pins` stage before global placement. |
| **DRT-0416: Off-grid SRAM pins** | SRAM macros were not legally aligned before routing. | Introduced the macro placement stage using the recommended placement constraints, ensuring all SRAM instances were aligned to the routing grid. |
## Key Learnings

Working through these issues provided a deeper understanding of the complete open-source ASIC implementation flow. In addition to executing the automated OpenROAD flow, the project involved manually inspecting the RTL hierarchy, debugging timing constraints, understanding SRAM macro integration, configuring placement constraints, diagnosing routing failures, and resolving environment-related resource limitations. These debugging steps were essential to successfully complete the RTL-to-GDSII implementation.

# 14. Conclusion

This project successfully implemented the Ariane133 processor using the OpenROAD open-source physical design flow on the Nangate45 technology node. The complete backend implementation was carried out from RTL synthesis through floorplanning, macro placement, tap cell insertion, PDN generation, placement, Clock Tree Synthesis (CTS), global routing, detailed routing, filler cell insertion, density fill, and final GDSII generation.

Throughout the implementation, several challenges were encountered, including SRAM macro integration, timing constraint compatibility, IO pin placement, macro alignment, and memory limitations during detailed routing. Each issue was analyzed using the generated logs and OpenROAD reports, and appropriate modifications were made to successfully continue the implementation flow.

The project resulted in the successful generation of all major implementation artifacts, including the synthesized database, routed database, DEF, SPEF, gate-level Verilog netlist, and final GDSII layout. In addition to executing the automated OpenROAD flow, the project provided practical experience with Yosys, OpenROAD, OpenSTA, physical design constraints, timing analysis, placement optimization, routing, and debugging large-scale ASIC implementations.

Overall, this assignment provided a comprehensive understanding of the complete RTL-to-GDSII implementation flow and the practical challenges involved in implementing a modern RISC-V processor using an open-source ASIC design methodology.


# Appendix

## Layout Screenshots Summary

| Stage | Screenshot |
|-------|------------|
| Macro Placement | ![](Macro_Placement.png) |
| Standard Cell Placement | ![](placement.png) |
| Clock Tree Synthesis | ![](clock_tree_synthesis.png) |
| Global Routing | ![](Global_Routing.png) |
| Detailed Routing | ![](Detailed_Routing.png) |
| Final Layout (OpenROAD) | ![](final_layout.png) |
| Final GDS – KLayout (chip view) | ![](final_gds.png) |
| Final GDS – KLayout (zoomed in) | ![](gds%20ariane.png) |

## Final Deliverables

- RTL Source
- Timing Constraints (SDC)
- OpenROAD Configuration
- Final GDSII Layout
- Final DEF
- Final ODB
- Final SPEF
- Final Gate-Level Verilog
- Implementation Reports
- Implementation Logs

## Repository
