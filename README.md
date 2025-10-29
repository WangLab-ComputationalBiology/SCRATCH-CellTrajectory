# SCRATCH-CellTrajectory

## Introduction
SCRATCH-CellTrajectory infers differentiation trajectories and developmental pseudotime from annotated single-cell datasets.
It integrates CytoTRACE2, Slingshot, and Monocle3 within a unified, containerized pipeline — enabling robust, reproducible trajectory inference across tumor and immune cell populations.

This module is a key component of the SCRATCH single-cell analysis ecosystem, fully orchestrated through Nextflow + Quarto (QMD) and supporting both Docker and Singularity execution.

## Prerequisites

Nextflow ≥ 21.04.0
Java ≥ 8
Docker or Singularity/Apptainer
Git

### R packages (via container):
Seurat, monocle3, slingshot, tradeSeq, CytoTRACE2, ggplot2, patchwork, Matrix, dplyr, WGCNA

## Installation
git clone https://github.com/WangLab-ComputationalBiology/SCRATCH-CellTrajectory.git
cd SCRATCH-CellTrajectory

main.nf — primary entrypoint

modules/local/main.nf — executes QMD notebooks

subworkflows/local/SCRATCH_CellTrajectory.nf — orchestrates integration across methods

nextflow.config — defines default resources and container paths

## Quick Start

### Minimal example (Docker)
nextflow run main.nf -profile docker \
  --input_seurat_object project_Azimuth_annotation_object.RDS \
  --subset_col azimuth_labels \
  --subset_value Epithelial \
  --project_name CellTrajectoryDemo \
  -resume
  
### Minimal example (Singularity)
nextflow run main.nf -profile singularity \
  --input_seurat_object project_Azimuth_annotation_object.RDS \
  --subset_col azimuth_labels \
  --subset_value Epithelial \
  --project_name CellTrajectoryDemo \
  -resume


## Typical Workflow Execution

CytoTRACE2 estimates differentiation potential.

Slingshot infers lineages and pseudotime trajectories.

Monocle3 reconstructs the principal graph and refines pseudotime ordering.

Results are merged, correlated, and visualized to provide consistent developmental trajectories.

## Key Parameters

--input_seurat_object	Input Seurat .RDS file
--subset_col, --subset_value	Metadata-based subset (e.g., epithelial only)
--project_name	Project label
--outdir	Output directory
--n_threads	Number of CPU threads
--use_ct2	Use CytoTRACE2 if available (default: true)
--species	Species model (“human” or “mouse”)
--seed	Random seed

## Outputs
SCRATCH-CellTrajectory_output/
├── rds/
│   ├── cytotrace_scores.rds
│   ├── slingshot_lineages.rds
│   ├── monocle3_cds.rds
│   └── integrated_pseudotime_table.csv
├── figures/
│   ├── CytoTRACE_UMAP.png
│   ├── Slingshot_UMAP.png
│   ├── Monocle3_UMAP.png
│   └── Correlation_CytoTRACE_vs_Monocle3.png
└── report/
    └── CellTrajectory.html


## Deliverables:

Pseudotime trajectories from three independent algorithms
Integrated comparison plots
Annotated Seurat and Monocle3 objects for downstream analysis

## Example Full Run
nextflow run main.nf -profile singularity \
  --input_seurat_object project_Azimuth_annotation_object.RDS \
  --subset_col azimuth_labels \
  --subset_value Epithelial \
  --project_name Lung_Trajectory \
  --use_ct2 true \
  --n_threads 16 \
  -resume

## Documentation

All QMD notebooks include annotated code and figures demonstrating key steps in CytoTRACE, Slingshot, and Monocle3 pseudotime reconstruction.

## License

Licensed under the GNU General Public License v3.0 (GPLv3).

## Developers:
sazaidi@mdanderson.org

lwang22@mdanderson.org
