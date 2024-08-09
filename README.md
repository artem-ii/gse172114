UPD 20240809: improved reading raw featureCounts files

To-Do: Logistic regression on HLA typing data, created a branch 'feature_logistic_hla' for that 

Checked duplicates and decided against changing anything. Most analysis is done at the unique gene id level and this is good. Symbols appear only at the end of WGCNA and GSEA, which is I think fine.

UPD 20240807_1: added QC reports and logs from Trimmomatic, STAR and logs for Kallisto realized that I added them to .gitignore by mistake

UPD 20240807_2: added some more tool descriptions to Snakefile

## The main jupyter notebook is located in:
    downstream_analysis/bostongene_rnaseq.ipynb
## Commands calling the tools can be found in
    snakemake/Snakefile
## Package listings for virtual environments
1. Conda environment I used to do DESeq2 analysis on my mac:

    environments_requirements/mac_conda_spec-file.txt
2. Conda environment I used on ubuntu HPC for most CLI work (alignment, QC etc)

    environments_requirements/ubuntu_conda_spec-file.txt
3. venv environment I used with Jupyter Lab on HPC (WGCNA, deconvolution etc):

    environments_requirements/ubuntu_downstream_venv_requirements.txt
### Most of raw and processed data files were excluded from the commit to avoid the inflation of the repo
## Current pipeline uses:
- SRA Tools and entrez-direct - to get raw FASTQ files from NCBI >
- FastQC/MultiQC - for quality control >
- trimmomatic - for adapter trimming and excluding incomplete reads >
- STAR - for building index and alignment to GENCODE v29 reference (primary assembly) >
- featureCounts - to quantify the reads >
- pyDESEQ2 - for Differential expression >
- pyGSEA - for Gene Set Enrichment Analysis >
- pyWGCNA - for Weighted Gene Network Correlation Analysis >
- seq2HLA - for HLA-II genes typing >
- Kassandra - for Deconvolution analysis 
(for deconvolution analysis transcript abundances were calculated using Kallisto with a custom Toil/Xena project index file)

All the tools were chosen based on their high popularity and cited peer reviewed publications, giving the preference to python tools.

The pipeline was mostly run on a SLURM HPC via interactive shell to make it more transferrable to non-HPC machines.
(SLURM instructions may be found in cluster_setup_listing.sh in root folder)

Snakemake workflow manager was used to facilitate the robustness of the pipeline.

FASTQ files were downloaded from SRA repository by using a custom script
    get_raw_data.sh

This script is located in snakemake/shellScripts folder and requires SRA-Tools (was loaded via SLURM module manager: module load SRA-Toolkit), entrez-direct and parallel (were installed into conda environment).

get_raw_data.sh prompts user to enter GSE accession. After that the script converts GSE to SRR accessions, downloads SRA files, converts them to FASTQ and moves to an appropriate directory for further analysis.

Once the raw data are downloaded, the rest of the pipeline can be launched from snakemake folder by using
    snakemake -j <jobs> -c <cores> command

The pipeline was run on a 192 CPU 512GB partition of the HPC.

Quality control or raw data and other steps (with MultiQC) indicated reasonable data quality. The html reports can be found in corresponding folders depending on the tool.

The downstream analysis (in the 'downstream_analysis' directory) was mainly performed on a Jupyter Lab instance of the HPC with 8 CPU and 128GB memory.

Analysis was performed using conda or virtualenv environment. Specifications of the environment are in the 'environments_requirements' directory.

seq2HLA script was modified to only map HLAII genes, but not HLA I

Minor modifications were made to Kassandra core scripts to avoid encountered bugs/incompatibility issues 



## Conclusion
- Raw data from the GSE172114 dataset were processed nominally, the quality is normal, alignment went well with a mean of about 30M reads per sample
- Differential gene expression analysis showed 1111 changed genes with a strict cutoff of log2FC > 1 and adjusted P value of less than 0.05. Among the top transcripts up-regulated in the COVID-19 critical patients are some immunity related genes. Notably CD177 and MCEMP1 expressed on neutrophils, mast cells (MCEMP1), and monocytes.
- Gene set enrichment analysis corroborated these findings and displayed enrichment in inflammatory pathways such as neutrophil degranulation, interferon response, TNF alpha, STAT1 and STAT2 signalling correlating with the critical disease state.
- Weighted Gene Network Correlation analysis suggested 13 regulatory modules of genes correlating with COVID-19 status, although further pathway analysis did not bring any clearly conclusive findings and may need further investigation
- HLA-II genes haplotype analysis was carried out to complement the knowledge about the patients' immune status.
- Deconvolution analysis allowed to study the proportions of cells in peripheral blood of the patients. Congruent with the previous results, critical COVID-19 patients showed lymphopenia amidst strong evaluation of granulocyte level. Interestingly, we found a higher granulocyte/lymphocyte ratio in the critical patients, complementary to recent research showing a correlation of neutrophil to lymphocyte ratio with the disease severity. Neutrophils may make up to 70% of white blood cells, so granulocyte measure may be a good approximation.

To conclude, the patients with the critical form of COVID-19 display more intensive inflammatory processes in peripheral blood, which may be largely attributed to the activity of neutrophils, but also increased presence of monocytes and active inflammatory signaling. Further investigation of HLA-II haplotypes using multiple logistic regression, as well as deeper analysis of WGCNA results may shed light on more details differentiating critical from non-critical COVID-19 patients.
