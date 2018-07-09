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
params.cpu            		= "8"

log.info ""
log.info "----------------------------------------------------------------"
log.info "           Quality control with Qualimap  and MultiQC           "
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
    log.info "-------------------QC-------------------------------"
    log.info "" 
    log.info "nextflow run iarcbioinfo/Qualimap.nf   --qualimap /path/to/qualimap  --multiqc /path/to/multiqc --input_folder /path/to/bam  --output_folder /path/to/output"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--qualimap              PATH               Qualimap installation dir"
    log.info "--samptools              PATH              Samtools installation dir"
    log.info "--multiqc              PATH               MultiQC installation dir"
    log.info "--input_folder         FOLDER               Folder containing fasta files"
    log.info "--output_folder        PATH                 Output directory for html and zip files (default=fastqc_ouptut)" 
    log.info ""
    log.info "Optional arguments:"
    log.info "--cpu                  INTEGER              Number of cpu to use (default=2)"
    log.info "--config               FILE                 Use custom configuration file"
    log.info ""
    log.info "Flags:"
    log.info "--help                                      Display this message"
    log.info ""
    exit 1
} 

bams = Channel.fromPath( params.input_folder+'/*.bam' )
              .ifEmpty { error "Cannot find any bam file in: ${params.input_folder}" }

process qualimap{
	publishDir '${params.output_folder}', mode: 'copy'
        input:
		file baminput from bams
        output:
        publishDir '${params.output_folder}', mode: 'copy', pattern: '{*.html}'
	shell:
        '''
 !{params.samtools} sort $baminput -o ${bam.baseName}.sorted.bam
 !{params.qualimap} bamqc -nt !{params.cpu} -bam $baminput -outdir !{params.output_folder} -outformat html
 !{params.samtools} flagstat ${i} > ${params.output_folder}
'''
}

process multiqc{
            cpus '1'
             
            input:
	    	 file(filehtml)  from params.output_folder
	output :
	publishDir '${params.output_folder}', mode: 'copy', pattern: '{*.html}'
            shell:
            '''
	  !{params.multiqc} -d !{params.outputt_folder}/*.html
            '''
}
