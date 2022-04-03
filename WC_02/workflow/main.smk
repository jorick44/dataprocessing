SAMPLES = ["A", "B", "C", "D"]

rule all:
    input:
        "out.html"

rule bowtie_build:
    input:
        "/commons/Themas/Thema11/Dataprocessing/WC02/data/genome.fa"
    output:
        "bowtie/genome.btindex"
    shell:
        "bowtie2-build {input} {output}"

rule bwa_map:
    input:
        bt = "bowtie/genome.btindex",
        fasta = "/commons/Themas/Thema11/Dataprocessing/WC02/data/samples/{sample}.fastq"
    benchmark:
        "benchmarks/{sample}.bowtie2.benchmark.txt"
    output:
        "mapped_reads/{sample}.bam"
    message: "executing bwa mem on {input} to build {output}"
    shell:

        "bowtie2 -x {input.bt} -U {input.fasta} | "
        "samtools view -Sb - > {output}"

rule samtools_sort:
    input:
        "mapped_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam"
    message: "sorting mapped_read{input} into bamfile {output} using samtools sort -T"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"

rule samtools_index:
    input:
        "sorted_reads/{sample}.bam"
    output:
        "sorted_reads/{sample}.bam.bai"
    message: "sorting the read alignment in {input} to {output}"
    shell:
        "samtools index {input}"

rule bcftools_call:
    input:
        fa="data/genome.fa",
        bam=expand("sorted_reads/{sample}.bam", sample=SAMPLES),
        bai=expand("sorted_reads/{sample}.bam.bai", sample=SAMPLES)
    output:
        "calls/all.vcf"
    message: "aggregating mapped read {input} all togheter in {output}"
    shell:
        "samtools mpileup -g -f {input.fa} {input.bam} | "
        "bcftools call -mv - > {output}"

rule report:
    input:
        "calls/all.vcf"
    output:
        "out.html"
    message: "Generating a report [{output}] from {input}"
    run:
        import snakemake.utils
        with open(input[0]) as f:
            n_calls = sum(1 for line in f if not line.startswith("#"))

        snakemake.utils.report("""
        An example workflow
        ==============================
        
        Reads were mapped to the Yeast reference genome
        and variants were called jointly with
        SAMtools/BCFtools.
        
        This resulted in {n_calls} variants (see Table T1_).
        """, output[0], metadata="Author: Jorick", T1=input[0])