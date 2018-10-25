#!/bin/csh -f

source 00.source.txt

cd  ${main}/running.scripts

foreach sample ("`cat sample.list`")

cat <<EOM > "${sample}.bowtie.run.sh"

#fastqc
fastqc -o ${main}/02.fqc -f fastq --noextract ${main}/fastqs/${sample}.fastq.gz  > ${main}/01.log/${sample}.fastqc.log

#bowtie
bowtie --chunkmbs 320 -m 1 --best -p $cpu_num ${main}/ht38/ht38 -q ${main}/fastqs/${sample}.fastq.gz -S 2> ${main}/00.log/${sample}.bowtie.log \
| samblaster --removeDups \
| samtools view -Sb -F 4 - \
| samtools sort -m 2G -@ 5 -T ${main}/03.aln/${sample}.sorted.bam.tmp -o ${main}/03.aln/${sample}.sorted.bam 2> ${main}/00.log/${sample}.markdup.log

#index
samtools index ${main}/03.aln/${sample}.sorted.bam 2> ${main}/00.log/${sample}.index.log

#flagstat_bam
samtools flagstat ${main}/03.aln/${sample}.sorted.bam > ${main}/03.aln/${sample}.sorted.bam.flagstat 2> ${main}/00.log/${sample}.flagstat.log

#
Rscript  ${main}/running.scripts/phantompeakqualtools/run_spp_nodups.R -c=${main}/03.aln/{sample}.sorted.bam ${main}/03.aln/{sample}.sorted.bam.bai \
-savp -rf -p=4 -odir=05phantompeakqual  -out=${main}/05.phantompeakqual/{sample}_phantom.txt -tmpdir=${main}/05.phantompeakqual 2> ${main}/00.log/${sample}.phantompeakqual.log


#######new

EOM

#bash $i.bowtie.run.sh
end


rule phantom_peak_qual:
    input: "03aln/{sample}.sorted.bam", "03aln/{sample}.sorted.bam.bai"
    output: "05phantompeakqual/{sample}_phantom.txt"
    log: "00log/{sample}_phantompeakqual.log"
    threads: 4
    params: jobname = "{sample}"
    message: "phantompeakqual for {input}"
    shell:
        """
	source activate root
        Rscript  /scratch/genomic_med/apps/phantompeak/phantompeakqualtools/run_spp_nodups.R -c={input[0]} -savp -rf -p=4 -odir=05phantompeakqual  -out={output} -tmpdir=05phantompeakqual 2> {log}

        """

