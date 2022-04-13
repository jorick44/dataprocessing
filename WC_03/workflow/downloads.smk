import os
from snakemake.remote.NCBI import RemoteProvider as NCBIRemoteProvider

url = "https://bioinf.nl/~fennaf/snakemake/"
NCBI = NCBIRemoteProvider(email="j.baron@st.hanze.nl")

rule all:
    input:
        "test.txt"

rule download_test:
    output:
        "test.txt"
    shell:
        "wget {url}{output}"

rule download_NCBI:
    input:
        NCBI.remote("KY785484.1.fasta", db="nuccore")
    run:
        outputName = os.path.basename("data/my_fasta.fasta")
        shell("mv {input} {outputName}")