# Archgen Hiring Assignment – RTL-to-GDSII Implementation of Ariane133

> **Submitted by:** Kiran Kumar Siripurapu

---

## Introduction

This repository presents my implementation of the Archgen Hiring Assignment. The objective was to implement the **Ariane133** processor from the ChiPBench benchmark using the **OpenROAD** open-source ASIC physical design flow on the **Nangate45** technology.

The project involved building and configuring the complete RTL-to-GDSII implementation flow using open-source EDA tools, starting from the provided RTL and timing constraints.

## Project Objectives

- Implement the provided Ariane133 RTL using the OpenROAD physical design flow.
- Configure the design for the Nangate45 / FreePDK45 technology.
- Apply the required timing constraints for a target operating frequency of **450 MHz**.
- Perform synthesis, floorplanning, placement, clock tree synthesis, global routing, detailed routing, and final layout generation.
- Analyze the implementation results and document the issues encountered and solutions applied.

## Development Environment & Toolchain

The complete physical design flow was implemented on **Ubuntu 24.04 (WSL2)** using the **Nix development environment**, which provides all required EDA tools.

### Toolchain

| Tool | Purpose |
|------|---------|
| OpenROAD | Physical Design Flow |
| OpenROAD-flow-scripts | Complete RTL-to-GDSII Automation |
| Yosys | RTL Synthesis |
| OpenSTA | Static Timing Analysis |
| TritonRoute / FastRoute | Routing |
| KLayout | GDSII Visualization |
| Nangate45 / FreePDK45 | Technology Library |

## Project Structure

```text
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
│   ├── designs/nangate45/archgen/
│   │   ├── config.mk             # OpenROAD design configuration
│   │   └── ariane_450mhz.sdc
│
├── results/                      # Generated implementation databases
├── reports/                      # Timing and implementation reports
└── logs/                         # Flow logs
```

## Design Constraints

The implementation used the provided timing and physical constraints as a starting point.

| Parameter | Value |
|-----------|------:|
| Top Module | `ariane` |
| Target Frequency | **450 MHz** |
| Clock Period | **2.222 ns** |
| Input / Output Delay | **0.444 ns** (20%) |
| Technology | Nangate45 / FreePDK45 |
| SRAM Macro | `fakeram45_256x16` |
| Initial Die Area | `0 0 1500 1500` |
| Initial Core Area | `10 12 1448 1448` |

## Physical Design Flow

```mermaid
flowchart TD
    A[RTL] --> B[Yosys]
    B --> C[Gate Netlist]
    C --> D[OpenROAD]
    D --> E[Floorplan]
    E --> F[Macro Placement]
    F --> G[PDN]
    G --> H[Placement]
    H --> I[CTS]
    I --> J[Global Routing]
    J --> K[Detailed Routing]
    K --> L[Fill]
    L --> M[GDSII]
```

---

### RTL Synthesis

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk synth
```

Synthesis converted the provided Ariane133 RTL into a technology-mapped gate-level netlist using the Nangate45 standard cell library. The RTL inspection revealed that the SRAM wrapper definitions were in `macros.v`. Including `macros.v` during synthesis successfully resolved the missing module references for `SyncSpRamBeNx64`.

---

### OpenROAD Design Initialization

Before floorplanning, the timing libraries, physical libraries (LEF), and timing constraints were loaded. The original SDC file `ariane_450mhz.sdc` had a syntax issue (`[expr]` inside `{}`) which was corrected so OpenSTA could evaluate it properly.

---

### Floorplanning

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk floorplan
```

The die area and core area were initialized as per the physical constraints. Tap cells were inserted throughout the floorplan to prevent latch-up and provide well/substrate connections.

---

### Macro Placement

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk gui_2_2_floorplan_macro
```

The SRAM macros required legal placement aligned to the manufacturing grid before routing. Using the OpenROAD RTL Macro Placer with the required halo and channel spacing constraints ensured all macros were positioned correctly. 

![Macro Placement](Macro_Placement.png)

---

### Power Distribution Network (PDN) Generation

The PDN was generated to distribute the power (`VDD`) and ground (`VSS`) supplies to all standard cells and SRAM macros, ensuring stable operation.

---

### Placement

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk place
```

IO pins were placed using the exclusion constraints from `io.tcl`. Afterward, global and detailed placement populated the core area with logic cells, legalizing their positions and minimizing wirelength.

![Standard Cell Placement](placement.png)

---

### Clock Tree Synthesis (CTS)

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk cts
```

CTS built a balanced clock distribution network. Wire RC parameters were sourced from the Nangate45 platform files to ensure accurate timing analysis during tree construction.

![Clock Tree Synthesis](clock_tree_synthesis.png)

---

### Global Routing

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk grt
```

Global routing generated routing guides for all signal nets. Congestion relaxation (`-allow_congestion`) was enabled to handle the routing density of Ariane133.

![Global Routing](Global_Routing.png)

---

### Detailed Routing

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk route
```

TritonRoute generated the final legal physical metal wires and vias, adhering to the Nangate45 technology design rules.

![Detailed Routing](Detailed_Routing.png)

---

### Filler Cell Insertion & Density Fill

**Command Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk finish
```

Filler cells were inserted into gaps between standard cells to ensure continuity of the well and power rails. Metal density fill was then added to meet manufacturing density rules.

---

### Final Report & GDSII Generation

**Commands Used:**
```bash
make DESIGN_CONFIG=designs/nangate45/archgen/config.mk gui_final
klayout results/nangate45/archgen/base/6_final.gds
```

The fully routed OpenDB database was exported to a standard GDSII layout file.

**Final Layout – OpenROAD GUI:**
![Final Layout](final_layout.png)

**Final GDS – KLayout:**
![Final GDS](final_gds.png)
![Final GDS Zoom](gds%20ariane.png)

---

## Implementation Results

| Metric | Value |
|--------|-------|
| Target Frequency | 450 MHz |
| Clock Period | 2.222 ns |
| Runtime | 4515 s |
| Peak Memory | 8075 MB |
| Final Design Area | 739,979 µm² |
| Final Utilization | 36% |
| Filler Cells | 376,371 |
| Antenna Violations | 0 |
| Final GDSII Generated | ✅ Yes |
| Final DEF Generated | ✅ Yes |

---

## Challenges Encountered & Resolutions

| Issue | Root Cause | Resolution |
|-------|-----------|------------|
| `YOSYS_EXE not found` | ORFS defaulted to built-in path instead of Nix shell | Exported `OPENROAD_EXE` and `YOSYS_EXE` manually |
| `STA-0371: Invalid clock waveform` | OpenSTA failed to parse Tcl `[expr]` inside `{}` | Rewrote SDC to use `set clk_half_period` and `list` |
| `GPL-0326: Top-level IO port not placed` | Global placement ran before IO pins were placed | Called `place_pins` explicitly before global placement |
| `DRT-0416: Off-grid SRAM pin shape` | SRAM macros not placed legally before routing | Added explicit macro placement stage using `rtl_macro_placer` |
| `Invalid move type: vt_swap reroute` | `vt_swap` not supported in current OpenROAD build | Modified global route script to skip `vt_swap` |
| `remove_from_collection` | Tcl API mismatch during timing reporting | Commented out incompatible reporting functions in scripts |
| **WSL OOM** | 8GB WSL default memory was insufficient for detailed routing | Increased WSL memory limit to 11GB in `~/.wslconfig` |

---

## Conclusion

The Ariane133 RTL-to-GDSII implementation was successfully completed using the OpenROAD toolchain on the Nangate45 technology node. By configuring the environment, resolving syntax and API mismatches, fixing macro placement grid issues, and tuning the WSL memory allocation, the design successfully routed with zero antenna violations, producing a final GDSII layout and satisfying the assignment requirements.

---

## Deliverables File Tree

```text
results/
│
├── 6_final.gds
├── 6_final.def.zip       # Compressed to meet GitHub 100MB limit
├── 6_final.odb
├── 6_final.v
├── 6_final.sdc
└── 6_final.spef
```

---

## References

- [OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD)
- [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
- [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA)
- [Yosys](https://github.com/YosysHQ/yosys)
- [ChiPBench](https://github.com/MIRALab-USTC/ChiPBench)
- [Nangate45](https://si2.org/open-cell-library)
