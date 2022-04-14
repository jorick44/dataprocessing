
configfile: "../config/config.yaml"

rule sortbam:
    input:
        "data/mapped/bam.bam"
    output:
        "data/sorted/bam.bam"
    log:
        "logs/sort_bam.log"
    shell:
        "samtools sort  {input} -o {output}"

rule indexbam:
    input:
        "data/sorted/bam.bam"
    output:
        "data/indexed/bam.bam.bai"
    log:
        "logs/index_bam.log"
    shell:
        "samtools index {input}"

rule bcftools:
    input:
        refgen="data/refgen/genome.fasta",
        bam="data/sorted/bam.bam",
        bai="data/indexed/bam.bam.bai"
    output:
        "calls/all.vcf"
    log:
        "logs/calling.log"
    shell:
        "samtools mpileup -g -f {input.refgen} {input.bam} | "
        "bcftools call -mv - > {output}"