# Upregulation of Genetic Markers of Poor Prognosis following Chemotherapy in Acute Myeloid Leukemia Cells

Code repository for publication investigating the connection between chemotherapy induced genes over short time scales and their associations with poor prognosis in AML cohorts

---

## 📖 Overview

This repository contains python and R files used to generate results/figures in the publication, as well as some of the smaller data files

---

## 🔬 Workflow Summary

Download, clean, and normalize cohort data → Perform Cox Proportional Hazards analysis in each cohort (gene-wise) → Determine differentially expressed genes following in-vitro chemotherapy (in HL-60 cells) → Assess statistical enrichment between prognosis associated and differentially expressed genes using Fisher's Exact Test (for 3x3 tables) → Repeat Fisher's Exact Test (for 2x2 tables) for post-hoc analyses of specific categories (e.g. poor prognostic and upregulated) → transcription factor inference of poor prognostic and upregulated genes using chEA3 → further investigation of cell population shifts following vincristine treatment using scRNA-seq data and cell cluster reproducibility across experiments

### Steps

1. **Setup Conda Env**
   - .yaml file available in requirements folder

2. **Run 'poor_prog_upreg_analysis.ipynb'**
   - this wrangles cohort data, runs cox PH regression, determines DEG from in-vitro chemo data, and runs Fisher's Exact Tests (2x2) for post-hoc enrichment analysis
   - importantly this file generates 3x3 contingency tables (for initial enrichment analysis using Fisher's Exact Test for 3x3 tables), these tables are stored in 'intermediate file outputs' folder as '3x3_tables_for_R' and read into the R script 'fishers_exact_3x3_test'
   - Cox PH regression of all the cohorts takes several minutes (30 on a decent laptop), the cox_ph_fit_dict.pkl file storing results can be read in instead to avoid recomputing

3. **Run remaining analysis scripts in 'src' directory**
   - 'fishers_exact_3x3_tests' is contingent upon the previous step executing succesfully so that there are contingnecy tables to analyze
   - 'chea3.ipynb' and 'vinc_scrna' are not contingent upon other scripts having run succesfully

4. **Outputs for figures and tables are stored in the 'results' directory**
   - there is a log file for the 'poor_prog_upreg_analysis.ipynb' to indicate if any of the gene enrichment queries using 'Enrichr' API failed (happens periodically)

## 🛠 Requirements

- Python ≥ 3.12
- R
- Conda		# will use conda to install base packages, then pypi for remaining
- ≥ 16 GB RAM recommended

Exhaustive list of packages/ dependencies are stored in requirements folder, in .yaml files
RECOMMENDED TO USE POWERSHELL SCRIPT INSTEAD AS IT SPECIFIES ONLY MAJOR PACKAGES IN CONDA THEN BUILDS REMAINDER WITH PYPI

---

## 📂 Repository Structure

|   README.md
|
+---data 				#input files
|   |   Integrated_meanRank.tsv		#chEA3 output file (TF inference)
|   |   regev_lab_cell_cycle_genes.txt		#used for cell cycle scoring in scRNA-seq analysis
|   |
|   +---biomart_gene_annotations		#gene mappings (ENSGs, Probes, HUGO)
|   |       biomart_export.txt
|   |       u133a2_to_ensg.txt
|   |       u133b_to_ensg.txt
|   |       u133plus2_to_ensg.txt
|   |
|   +---cohort_data 			#each cohort has metadata, survival time. gene expression files are omitted due to large size
|   |   +---amlcg
|   |   |       GSE37642_family.soft
|   |   |       GSE37642_Survival_data.txt
|   |   |
|   |   +---beat
|   |   |   |   beataml_wv1to4_clinical.xlsx
|   |   |   |   gdc_sample_sheet.2024-05-28.tsv
|   |   |   |
|   |   |   \---Bulk
|   |   \---tcga
|   |       |   gdc_sample_sheet.2024-04-30.tsv
|   |       |   TCGA_clinical_data_from_gdc.cancer.gov.tsv
|   |       |   TCGA_NEJM_clinical(updated).xlsx
|   |       |
|   |       \---Bulk
|   |
|   \---in_vitro_chemo_rna_seq 		#experiment done in-vitro (bulk and single cell)
|           genelevel_DESeq_deg_CYT_unfiltered.csv
|           genelevel_DESeq_deg_VEN_unfiltered.csv
|           genelevel_DESeq_deg_VINC_unfiltered.csv
|           IR-DT-084.h5ad
|           IR004_kallisto_raw.h5ad
|
+---intermediate_file_outputs		
|   |   cox_ph_fit_dict.pkl			#intermediate file storing Cox PH regression results (for convenience, takes several minutes to compute)
|   |
|   \---3x3_tables_for_R			#input into R scripts in 'src'
|
+---requirements				#anaconda environment specifications
|       minimal_reqs_bpu_attempt1.txt
|
+---results				
|   |   marker_gene_overlaps_between_leiden_clusters.xlsx
|   |   poor_prog_upreg.log
|   |   prog_and_de_table.xlsx		#genes that show differential expression following treatment with at least one of the chemo drugs and prognosis association in at least one of the cohorts
|   |
|   +---figure_outputs_chea3
|   +---figure_outputs_fishers_exact_3x3_tests
|   +---figure_outputs_poor_prog_upreg

\---src
    |   chea3.ipynb				#shows top inferred TFs and their regulons
    |   fishers_exact_3x3_tests.R		#the initial enrichment analysis (this is for 3x3 tables, the 'poor_prog_upreg_analysis.ipynb' is just the post-hoc fisher's exact test for 2x2 tables)
    |   poor_prog_upreg_analysis.ipynb		#RUN THIS FIRST
    |   vinc_scrna.ipynb			#scrna seq experiments
