SAMPLES = ['Sample1', 'Sample2', 'Sample3']

rule all:
    input:
        'results/test.txt'

rule quantify_genes:
    input:
        genome = 'resources/genome.fa',
        r1 = 'resources/{sample}.R1.fastq.gz',
        r2 = 'resources/{sample}.R2.fastq.gz',
        r3 = 'resources/{sample}.R3.fastq.gz'
    output:
        'results/{sample}.txt'
    shell:
        'echo {input.genome} {input.r1} {input.r2} {input.r3} > {output}'

rule clean:
    shell:
        'rm results/*.txt'

rule collate_outputs:
    input:
        expand('results/{sample}.txt',sample=SAMPLES)
    output:
        'results/test.txt'
    run:
        with open(output[0],'w') as out:
            for i in input[:-1]:
                out.write(i.split("/")[1] + " ")
            out.write("and " + input[-1].split("/")[1] + " are successfully processed")