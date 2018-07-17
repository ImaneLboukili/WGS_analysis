 # Post alignement # 

![Image PostAlign](https://github.com/ImaneLboukili/WGS_analysis/blob/master/PostAlign/PostAlign.png)

## Description ##

Perform a post alignement on aligned reads files.

## Dependencies ## 
1. This pipeline is based on [nextflow](https://www.nextflow.io). As we have several nextflow pipelines, we have centralized the common information in the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository. Please read it carefully as it contains essential information for the installation, basic usage and configuration of nextflow and our pipelines.
2. samtools: see official installation [here](http://www.htslib.org). You can avoid installing all the external software by only installing Docker (not available yet). See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)
3. sambamba : see official installation [here](http://lomereiter.github.io/sambamba/). You can avoid installing all the external software by only installing Docker (not available yet). See the[IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)
4. bwakit : see official installation [here](https://github.com/lh3/bwa/tree/master/bwakit). You can avoid installing all the external software by only installing Docker (not available yet). See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)

## Input ##

**Name**         | **Description**
---------------  | ---------------
--input_folder   | Folder containing Fasta files
--output_folder  | Path to output folder

## Parameters ##

### Optional ###

**Name**          | **Example value** | **Description**
------------------| ------------------| ------------------
samtools          | /usr/bin/samtools | Path to samtools installation directory
sambamba          | /usr/bin/sambamba | Path to sambamba installation directory
bwakit            | /usr/bin/bwakit   | Path to bwakit installation directory

### Flags ###

Flags are special parameters without value.

**Name**      | **Description**
------------- | -------------
--help        | Display help

## Download test data set ###

`git clone blablabla`

## Usage ##

`nextflow run WGS_analysis/PostAlign.nf --samtools /path/to/samtools --sambamba /path/to/sambamba --bwait /path/to/bwakit --input_folder path/to/input   --output_folder /path/to/output `

## Output ## 

**Name**         | **Description**
---------------- | -------------
Headers(*.HEAD)  |  First lines of the returned BAM file
BAMS(*.bam)      |  Improved alignment 


