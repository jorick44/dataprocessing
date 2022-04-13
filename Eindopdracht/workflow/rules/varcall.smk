
configfile: "../config/config.yaml"

rule sortbam:
    input:
        "data/mapped/bam.bam"
    output:
        "data/sorted/bam.bam"
    shell:
        "samtools sort  {input} -o {output}"

rule indexbam:
    input:
        "data/sorted/bam.bam"
    output:
        "data/indexed/bam.bam.bai"
    shell:
        "samtools index {input}"

rule bcftools:
    input:
        refgen="data/refgen/genome.fasta",
        bam="data/sorted/bam.bam",
        bai="data/indexed/bam.bam.bai"
    output:
        "calls/all.vcf"
    shell:
        "samtools mpileup -g -f {input.refgen} {input.bam} | "
        "bcftools call -mv - > {output}"