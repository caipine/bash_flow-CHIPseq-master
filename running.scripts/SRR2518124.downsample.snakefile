
rule down_sample:
    input: "/home/exx/Documents/bash_flow-CHIPseq-master/03.aln/SRR2518124.sorted.bam", "/home/exx/Documents/bash_flow-CHIPseq-master/03.aln/SRR2518124.sorted.bam.bai", "/home/exx/Documents/bash_flow-CHIPseq-master/03.aln/SRR2518124.sorted.bam.flagstat"
    output: "/home/exx/Documents/bash_flow-CHIPseq-master/04.aln_downsample/SRR2518124-downsample.sorted.bam", "/home/exx/Documents/bash_flow-CHIPseq-master/04.aln_downsample/SRR2518124-downsample.sorted.bam.bai"
    log: "/home/exx/Documents/bash_flow-CHIPseq-master/00.log/SRR2518124_downsample.log"
    threads: 16
    params: jobname = "SRR2518124"
    message: "downsampling for {input}"
    run:
        import re
        import subprocess
        with open (input[2], "r") as f:
            # fifth line contains the number of mapped reads
            line = f.readlines()[4]
            match_number = re.match(r'(\d.+) \+.+', line)
            total_reads = int(match_number.group(1))

        target_reads = 15000000 # 15million reads  by default, set up in the config.yaml file
        if total_reads > target_reads:
            down_rate = target_reads/total_reads
        else:
            down_rate = 1

        shell("sambamba view -f bam -t 5 --subsampling-seed=3 -s {rate} {inbam} | samtools sort -m 2G -@ 5 -T {outbam}.tmp > {outbam} 2> {log}".format(rate = down_rate, inbam = input[0], outbam = output[0], log = log))

        shell("samtools index {outbam}".format(outbam = output[0]))

