
#fastqc
fastqc -o /home/exx/Documents/bash_flow-CHIPseq-master/02.fqc -f fastq --noextract /home/exx/Documents/bash_flow-CHIPseq-master/fastqs/SRR2518123.fastq.gz  > /home/exx/Documents/bash_flow-CHIPseq-master/01l.og/SRR2518123.log

#bowtie
bowtie --chunkmbs 320 -m 1 --best -p 16 /home/exx/Documents/bash_flow-CHIPseq-master/ht38/ht38 -q /home/exx/Documents/bash_flow-CHIPseq-master/fastqs/SRR2518125.fastq.gz -S 2> /home/exx/Documents/bash_flow-CHIPseq-master/03aln/SRR2518125.bowtie.log \
| samblaster --removeDups \
| samtools view -Sb -F 4 - \
| samtools sort -m 2G -@ 5 -T /home/exx/Documents/bash_flow-CHIPseq-master/03aln/SRR2518125.sorted.bam.tmp -o /home/exx/Documents/bash_flow-CHIPseq-master/03aln/SRR2518125.sorted.bam 2> /home/exx/Documents/bash_flow-CHIPseq-master/03aln/SRR2518125.markdup.log

#index

