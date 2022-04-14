# GBS var finder
Description: using several common bioinformatics tools,
this pipeline aims to find variants (SNPs) based on a reference genome.  

##Tools: 
bwa, samtools, cutadapt and bcftools.

##Usage:  
- Fill out the reference genome ensembl data in the config file.
- Fill out file fastq names (no extension!!) in the config file.
- Place you fastq(.gz) in the data/fastq directory.
- Run snakemake.

## Example:
``snakemake -c all``

## visualisation 
See the images directory, the dag is missing because it doesn't work.

## steps:
- Installs the reference genome from ensembl.
- Indexes the reference genome.
- Demultiplexes given fastqs with te given barcode file.
- Cuts adapter sequences from fastqs using the given adapter.
- Aligns the fastqs making it inta bam file.
- Sorts and indexes the bam file makting a bam.bai.
- Calls variants using bcftools.

## Requrements:
Uses snakemake and the tools in the tool section.
make sure the barcode file is as follows:  

``` 
>barcodename01
^ATGAACTAA
>barcodename02
^TTGACAAA
```
