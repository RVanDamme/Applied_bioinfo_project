#!/usr/bin/env nextflow
params.output="$baseDir"
params.pfam="$baseDir/data/proteins_w_domains.txt"
params.help = false

start_var = Channel.from("""
*********Start of project*********

--help if you want to have some help
Done by Renaud Van Damme (check my main pipeline to see a "better" nextflow code https://github.com/RVanDamme/MUFFIN )
**************************************
""")
start_var.view()

pfam_ch= Channel.fromPath(params.pfam)

if (params.help) { exit 0, helpMSG() }
def helpMSG() {
    log.info """
    *********Help about dat and png stuff*********
    --help if you want to have some help
    **************************************
    """
    }


process dll {
 
    input:
 
    output:
    path('9096.prot.links.over500.txt') into plot_chan

    shell:
    """
    wget https://stringdb-static.org/download/protein.links.v11.0/9606.protein.links.v11.0.txt.gz
    gunzip 9606.protein.links.v11.0.txt.gz 
    awk -F" " '\$3 + 0 >= 500' 9606.protein.links.v11.0.txt | cut -d" " -f1,2 | sed -e 's/9606.//g' >9096.prot.links.over500.txt
    """
}


process png {
    publishDir {params.output}
    input:
    path(linkfile) from plot_chan
    path(pfam) from pfam_ch
    output:
    path('protein_domains_vs_string_degree.png')

    script:
 
    """
    python $baseDir/bin/create_png_nextflow.py
    """
}
