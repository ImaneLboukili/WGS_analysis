#!/usr/bin/env nextflow

// Copyright (C) 2017 IARC/WHO

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


params.help          		 = null
params.config         		= null
params.cpu            		= 8
params.mem           		 = 32


log.info ""
log.info "----------------------------------------------------------------"
log.info "        svaba/  : Structural variants calling with SvABA        "
log.info "----------------------------------------------------------------"
log.info "Copyright (C) IARC/WHO"
log.info "This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE"
log.info "This is free software, and you are welcome to redistribute it"
log.info "under certain conditions; see LICENSE for details."
log.info "--------------------------------------------------------"
if (params.help) {
    log.info "--------------------------------------------------------"
    log.info "                     USAGE                              "
    log.info "--------------------------------------------------------"
    log.info ""
    log.info "-------------------SvABA-------------------------------"
    log.info "" 
    log.info "nextflow run SvABA.nf  --input_folder  path/to/input/ --svaba path/to/svaba/ --ref_file path/to/ref/ --dbsnp_file path/to/dbsnp_indel.vcf --output_folder /path/to/output"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--svaba                PATH                SvABA installation dir"
    log.info "--input_folder         PATH              Folder containing  bam files"
    log.info "--correspondance       FILE              File containing correspondence between path to normal and path to tumor bams for each patient  "
    log.info "--ref_file             PATH                Path to  reference fasta file, the reference file should be indexed "
    log.info "--dbsnp_file           FILE                DbSNP file https://data.broadinstitute.org/snowman/dbsnp_indel.vcf"
    log.info "--output_folder				 PATH				 Path to output folder"
    log.info ""
    log.info "Optional arguments:"
    log.info "--cpu                  INTEGER              Number of cpu to use (default=4)"
    log.info "--config               FILE                 Use custom configuration file"
    log.info "--mem                  INTEGER              Size of memory used. Default 32Gb"
    log.info ""
    log.info "Flags:"
    log.info "--help                                      Display this message"
    log.info ""
    exit 1
} 

correspondance = file(params.correspondance)
bams= Channel.fromPath(correspondance).splitCsv(header: true, sep: '\t', strip: true)
		.map{row -> [ row.ID, file(params.input_folder + "/" +row.tumor),file(params.input_folder + "/" +row.normal )]}



process SVaBa {
		 cpus params.cpu
    

input :

   set val(sampleID),file(tumor),file(normal) from bams
   
   output:
	publishDir '${params.output_folder}', mode: 'copy', pattern: '{*.bps.txt.gz,*.contigs.bam,*.discordants.txt.gz,*.log,*.alignments.txt.gz,*.vcf}' 
shell :


     """ 
     cd ${params.input_folder}
    ${params.svaba} run -t $tumor -n $normal -p ${task.cpus} -D ${params.dbsnp_file} -a somatic_run -G ${params.ref_file} -M 40000

mv somatic_run.bps.txt.gz  ${params.output_folder}/${ID}.somatic.bps.txt.gz
mv somatic_run.contigs.bam  ${params.output_folder}/${ID}.somatic.contigs.bam
mv somatic_run.discordant.txt.gz ${params.output_folder}/${ID}.discordant.txt.gz
mv somatic_run.log ${params.output_folder}/${ID}.log
mv somatic_run.alignments.txt.gz ${params.output_folder}/${ID}.alignments.txt.gz

mv somatic_run.svaba.somatic.sv.vcf        ${params.output_folder}/${ID}.somatic.sv.vcf         
mv somatic_run.svaba.unfiltered.somatic.sv.vcf ${params.output_folder}/${ID}.unfiltered.somatic.sv.vcf
         
 
mv somatic_run.svaba.germline.indel.vcf  ${params.output_folder}/${ID}.germline.indel.vcf
mv somatic_run.svaba.unfiltered.germline.indel.vcf ${params.output_folder}/${ID}.unfiltered.germline.indel.vcf
     
               
mv somatic_run.svaba.germline.sv.vcf    ${params.output_folder}/${ID}.germline.sv.vcf
mv somatic_run.svaba.unfiltered.germline.sv.vcf ${params.output_folder}/${ID}.unfiltered.germline.sv.vcf
  
    
   
mv somatic_run.svaba.somatic.indel.vcf   ${params.output_folder}/${ID}.somatic.indel.vcf
mv somatic_run.svaba.unfiltered.somatic.indel.vcf ${params.output_folder}/${ID}.unfiltered.somatic.indel.vcf
    """
}
