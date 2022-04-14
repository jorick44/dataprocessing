import os

configfile: "../config/config.yaml"


rule demultiplex:
    input:
        barcode="data/barcode/" + config["fastq"]["barcodefile"] + ".fasta",
        r1="data/fastqs/" + config["fastq"]["r1"] + config["fastq"]["fastq_ext"],
        r2="data/fastqs/" + config["fastq"]["r2"] + config["fastq"]["fastq_ext"]
    output:
        r1="data/demultiplexed/" +config["fastq"]["r1"] + config["fastq"]["fastq_ext"],
        r2="data/demultiplexed/" +config["fastq"]["r2"] + config["fastq"]["fastq_ext"]
    log:
        "logs/demultiplex.log"
    run:
        if config["fastq"]["r2"] != "":
            os.system(f"cutadapt -e 0.15 --no-indels -g {input.barcode} -o {output.r1} -p {output.r2} {input.r1} {input.r2}")
        else:
            os.system(f"cutadapt -e 0.15 --no-indels -g {input.barcode} -o {output.r1} {input.r1}")

rule cutadapt:
    input:
        r1="data/demultiplexed/" +config["fastq"]["r1"] + config["fastq"]["fastq_ext"],
        r2="data/demultiplexed/" +config["fastq"]["r2"] + config["fastq"]["fastq_ext"]
    output:
        r1="data/cut/" +config["fastq"]["r1"] + config["fastq"]["fastq_ext"],
        r2="data/cut/" +config["fastq"]["r2"] + config["fastq"]["fastq_ext"]
    log:
        "logs/cut.log"
    run:
        if config["fastq"]["r2"] != "":
            os.system(f"cutadapt -a " + config["fastq"]["adapter_r1"] + " -A " + config["fastq"]["adapter_r2"]
                      + f"-o {output.r1} -p {output.r2} {input.r1} {input.r2}")
        else:
            os.system(f"cutadapt -a " + config["fastq"]["adapter_r1"] + f" -o {output} {input.r1}")

rule alignment:
    input:
        ref="data/refgen/genome.fasta",
        r1="data/cut/" +config["fastq"]["r1"] + config["fastq"]["fastq_ext"],
        r2="data/cut/" +config["fastq"]["r2"] + config["fastq"]["fastq_ext"]
    output:
        r1="data/mapped/bam.bam"
    log:
        "logs/align.log"
    run:
        if config["fastq"]["r2"] != "":
            os.system(f"bwa mem {input.ref} {input.r1} | samtools view -Sb - > {output}")
        else:
            os.system(f"bwa mem -p {input.ref} {input.r1} {input.r2} | samtools view -Sb - > {output}")

