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
params.input_folder  		 = "./"
params.svaba        		= null
params.config         		= null
params.cpu            		= "4"
params.mem           		 = "2"
params.output_folder  		= "svaba_output"
params.mode           		= "svaba"

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
    log.info "nextflow run iarcbioinfo/SvABA.nf  --tumor_folder path/to/tumor/ --normal_folder path/to/normal/ --svaba path/to/svaba/ --ref_file path/to/ref/fasta"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--svaba                PATH                SvABA installation dir"
    log.info "--tumor_folder         FOLDER              Folder containing tumor bam files"
    log.info "--normal_folder        FOLDER              Folder containing associated normal bam files"
    log.info "--ref_file             PATH                Path to  reference fasta file, the reference file should be indexed "
    log.info "--dbsnp_file           FILE                DbSNP file https://data.broadinstitute.org/snowman/dbsnp_indel.vcf"
    log.info ""
    log.info "Optional arguments:"
    log.info "--cpu                  INTEGER              Number of cpu to use (default=4)"
    log.info "--config               FILE                 Use custom configuration file"
    log.info ""
    log.info "Flags:"
    log.info "--help                                      Display this message"
    log.info ""
    exit 1
} 

files = Channel.fromPath( params.tumor_folder+'/*.bam' )
              .ifEmpty { error "Cannot find any bam file in: ${params.tumor_folder}" }
              .map {  path -> [ path.name.replace(".bam",""), path ] }
              
              

process svaba {
		cpus params.cpu
        memory params.mem_QC+'GB'    
        tag { file_tag }
        
        input:
        set val(file_tag), file("${file_tag}*val*.bam"), file("${file_tag}*val*.normal.bam")
        file ref 
        file dbsnp
	
        output:
	publishDir "${./}", mode: 'copy', pattern: '{*.bps.txt.gz,*.contigs.bam,*.discordants.txt.gz,*.log,*.alignments.txt.gz,*.vcf}' 

	shell:
        file_tag = files[0].baseName
        '''
	svaba run -t !{file_tag}.bam -n !{file_tag}.normal.bam -p !{task.cpus} -D $DBSNP -a somatic_run -G !{ref_file} 
        '''
}

