
configfile: "config/config.yaml"

rule install_refgen:
    output:
        "data/refgen/genome.fasta"
    log:
        "logs/get_refgen.log"
    params:
        species=config["ref"]["species"],
        datatype="dna",
        build=config["ref"]["build"],
        release=config["ref"]["release"]
    cache: True
    wrapper:
        "v1.3.2/bio/reference/ensembl-sequence"

rule index_refgen:
    input:
        "data/refgen/genome.fasta"
    output:
        multiext("data/refgen/genome.fasta", ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/bwa_index.log"
    shell:
        "bwa index -a bwtsw {input} >{log} 2>&1"

rule fia_refgen:
    input:
        "data/refgen/genome.fasta"
    output:
        "data/refgen/genome.fasta.fai"
    log:
        "logs/fiadx.log"
    shell:
        "samtools faidx {input} >{log} 2>&1"

