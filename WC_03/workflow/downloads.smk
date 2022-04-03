import os
from snakemake.remote.NCBI import RemoteProvider as NCBIRemoteProvider

url = "https://bioinf.nl/~fennaf/snakemake/test.txt"
NCBI = NCBIRemoteProvider(email="j.baron@st.hanze.nl")

rule all:
    input:
        "test.txt"

rule download:
    output:
        "test.txt"
    shell:
        "wget {url}{output}"