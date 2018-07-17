# Structural variant calling #

![Image SvABA](https://github.com/ImaneLboukili/WGS_analysis/blob/master/SvABA/SvABA.png)

## Description ##

Perform structural variant calling with SvABA.

## Dependencies ## 

1. This pipeline is based on [nextflow](https://www.nextflow.io). As we have several nextflow pipelines, we have centralized the common information in the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository. Please read it carefully as it contains essential information for the installation, basic usage and configuration of nextflow and our pipelines.
2. SvABA: see official installation [here](https://github.com/walaj/svaba). 
## Input ## 

**Name**        | **Description**
--------------- | ---------------
--input_folder  |  Folder containing BAM files
--ref_file      |  Path to reference fasta file. It should be indexed
--dbsnp_file    |  DbSNP file, available here
--output_folder |  Path to output folder

## Parameters ## 

### Optional ###
**Name**          | **Example value** | **Description**
------------------| ------------------| ------------------
--svaba           | /usr/bin/svaba    | Path to SvABA installation directory

### Flags ###

Flags are special parameters without value.

**Name**      | **Description**
------------- | -------------
--help        | Display help

## Download test data set ##

`git clone blablabla`

## Usage ##

`nextflow run SvABA.nf  --input_folder  path/to/input/ --svaba path/to/svaba/ --ref_file path/to/ref/ --dbsnp_file path/to/dbsnp_indel.vcf --output_folder /path/to/output` 

## Output ##

**Name**                    | **Description**
--------------------------  | --------------------------
txts (*.bps.txt.gz)         |  Raw, unfiltered variants
BAMs (*.contigs.bam)        |  Unsorted assembly contigs as aligned to the reference with BWA-MEM
Logs (*.log)                |  Run-time information
txts (*.discordants.txt.gz) |  Discordant reads identified with 2+ reads
VCFs (*.vcf )               |  VCF of rearrangements and indels

