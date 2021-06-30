# Global variable
LANGUAGE=python


# Plot count
PLOT_SRC=bin/create_png.py
PLOT_EXE=$(LANGUAGE) $(PLOT_SRC)
# I know you can use a config file for the var but I don't want to upload multiple files on canvas to keep it simple so I comment the config file import and use the copy of the config above
#include config.mk

# File handling var
PATH_PFAM=data/proteins_w_domains.txt
TMP_DIR=junk/
WEB_LINK="https://stringdb-static.org/download/protein.links.v11.0/9606.protein.links.v11.0.txt.gz"
PROTLINK_READY=tmp/9096.prot.links.over500.txt
# calling modules

## all         : Generate Zipf summary table and plots of word counts.
.PHONY : all
all : download png

## download : Download and setup the protein links file.
download : $(TMP_DIR)
	wget https://stringdb-static.org/download/protein.links.v11.0/9606.protein.links.v11.0.txt.gz -P $(TMP_DIR)
	gunzip $(TMP_DIR)9606.protein.links.v11.0.txt.gz && awk -F" " '$3 + 0 >= 500' $(TMP_DIR)9606.protein.links.v11.0.txt | cut -d" " -f1,2 | sed -e 's/9606.//g' >$(TMP_DIR)9096.prot.links.over500.txt


## png        : Use the python script in /bin to generate a png
.PHONY : png
png : $(PLOT_SRC)
	$(PLOT_EXE)


# sys management

## clean       : Remove temporary files.
.PHONY : clean
clean :
	rm -f $(TMP_DIR)9606*


## help        : Print the target of this Makefile
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<

