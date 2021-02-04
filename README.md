Trends In Prokaryote Genomics
===============================

R script for identifying trends in bacterial and archaeal genomics through number of genome sequencing projects submitted to ncbi per year.

## Dependencies
* _ggplot2_
* _stringr_
* _tidyr_
* _tidyverse_
* _data.table_

### Installing dependencies 

    install.packages(c("stringr,ggplot2,tidyr,tidyverse,data.table"))

## Steps
* Data gathering from the ncbi repository <ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt>

* Data formatting: leave only genera and years

* Function (subsetting and plotting)

## Example outputs

### Human pathogens
    genomic_trends("Escherichia|Pseudomonas|Vibrio|Campylobacter|Salmonella|Brucella", 3)

### Some archaea
    genomic_trends("Methanosarcina|Ignicoccus|Pyrococcus|Sulfolobus", 2)
