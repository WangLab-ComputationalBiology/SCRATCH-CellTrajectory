process CELLTRAJECTORY {

    tag "Performing Cell Trajectory analysis"
    label 'process_medium'
    // container 'syedsazaidi/scratch-celltrajectory:latest'
    container '/home/sazaidi/Softwares//SCRATCH_CellTrajectory/scratch-celltrajectory.sif'

  // publish everything under data/ and figures/ preserving structure,
  // and the HTML under report/
//   publishDir "${params.outdir}/${params.project_name}", mode: 'copy', overwrite: true
    // publishDir "${params.outdir}/${params.project_name}",
    //         mode: 'copy',
    //         overwrite: true
    publishDir "SCRATCH-CellTrajectory_output",
            mode: 'copy',
            overwrite: true

    cpus   params.n_threads ?: 16
    memory { params.n_memory ? "${params.n_memory} GB" : '250 GB' }
    errorStrategy 'terminate'

    input:
      path seurat_object
      path notebook
      path config

    // These are the only paths Nextflow will publish.
    output:
      path "report/${notebook.baseName}.html", emit: report,  optional: true
      path "figures/**",                     emit: figures, optional: true
      path "rds/**",                        emit: rds,    optional: true

    when:
      task.ext.when == null || task.ext.when

    /*
    * Build Quarto -P params safely (quote values!).
    */
    shell:
      """
      set -euo pipefail

      mkdir -p report figures rds

      # Hint: we pass the staged input path, not the original absolute path
      quarto render CellTrajectory.qmd --execute \
        -P seurat_object:"${seurat_object}" \
        -P project_name:"${params.project_name ?: 'project'}" \
        -P n_threads:${params.n_threads ?: 16} \
        -P n_memory:${params.n_memory ?: 250} \
        -P ct_species:"${params.ct_species ?: 'human'}" \
        -P work_directory:"${params.work_directory ?: '.'}"
      """
    // script:

    //   // helper to single-quote values and escape any single quotes inside
    //   def q = { v -> "'${v.toString().replace("'", "'\\''")}'" }

    //   // build flat "-P key:value" list with safe quoting for things containing commas/semicolons
    //   def parts = []
    //   parts << "-P seurat_object:${seurat_object}"
    //   parts << "-P project_name:${params.project_name}"
    //   parts << "-P n_threads:${params.n_threads}"
    //   parts << "-P n_memory:${params.n_memory}"
    //   parts << "-P ct_species:${params.ct_species}"
      
    //   // IMPORTANT: do NOT quote $PWD so the shell expands it
    //   parts << "-P work_directory:$PWD"

    //   def param_file = parts.join(' ')

    //   """
    //   set -euo pipefail

    //   # ensure these roots exist so the globs always match
    //   mkdir -p report figures data

    //   # render (options first, then params)
    //   quarto render --execute ${notebook} ${param_file}
    //   """
}

