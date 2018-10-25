
rule make_bigwigs:
    input : "/home/exx/Documents/bash_flow-CHIPseq-master/04.aln_downsample/SRR2518124-downsample.sorted.bam", "/home/exx/Documents/bash_flow-CHIPseq-master/04.aln_downsample/SRR2518124-downsample.sorted.bam.bai"
    output: "/home/exx/Documents/bash_flow-CHIPseq-master/07.bigwig/SRR2518124.bw"
    log: "/home/exx/Documents/bash_flow-CHIPseq-master/00.log/SRR2518124.makebw"
    threads: 5
    params: jobname = "SRR2518124"
    message: "making bigwig for {input}"
    shell:
        """
    source activate root
        bamCoverage -b {input[0]} --normalizeUsing RPKM --binSize 30 --smoothLength 300 -p 5 --extendReads 200 -o {output} 2> {log}
        """


