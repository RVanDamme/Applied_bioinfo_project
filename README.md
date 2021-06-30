# Are well-connected proteins more multi-faceted than others?

## Renaud Van Damme


### History

```bash
# get data and make it ready for the script
wget https://stringdb-static.org/download/protein.links.v11.0/9606.protein.links.v11.0.txt.gz
gunzip 9606.protein.links.v11.0.txt.gz 
awk -F" " '$3 + 0 >= 500' tmp/9606.protein.links.v11.0.txt | cut -d" " -f1,2 | sed -e 's/9606.//g' >tmp/9096.prot.links.over500.txt 
## we could do it in many otherways (and more optimised ways) 
## including in the python script but I wanted to show some awk and cut/sed
python bin/create_network.py 

```

### Why store the PFAM file?
I use the PFAM file stored in the data dir because you cannot wget the link given in the instructions.
I also do not download the file directly from Ensembl Biomart because I do not have the exact file and version and do not want to download the wrong one.

### Why Makefile is not working?
For a reason I do not understand the Makefile is not working, more specifically the awk part of the download step is not writing into the file.

### Why nextflow is better?
Because I do not have the issue :-)
On a more serious note I find nextflow more easy to handle the files, it allows automatic intermediary files and also you can reuse code in a really simple manner.