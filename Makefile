
OUTPUTFORMAT = xhtml
XSLTFILE     = system-xhtml11.xsl

# generate list of output files from all existing .xml files
OUTPUTFILES  = $(foreach file, $(basename $(wildcard *.xml)), $(file).$(OUTPUTFORMAT))

all: $(OUTPUTFILES)

%.$(OUTPUTFORMAT): %.xml
	@printf "Create $@ ... "
	@xsltproc -o $@ $(XSLTFILE) $?
	@echo "Done"
	@sed -i -e 's/\.xml/\.$(OUTPUTFORMAT)/g' $@

validate:
	@xmlstarlet val --well-formed menu.xml
	@xmlstarlet val --embed       menu.xml
	@xmlstarlet val --well-formed $(XSLTFILE)
	for f in $(OUTPUTFILES); do \
		xmlstarlet val --well-formed $$f; \
		xmlstarlet val --embed $$f; \
	done

clean:
	rm -f *.$(OUTPUTFORMAT)
