
XHTMLFILES = $(foreach file, $(basename $(wildcard *.xml)), $(file).xhtml)

XSLTFILE   = system-xhtml-nav.xsl

all: $(XHTMLFILES)

%.xhtml: %.xml
	@printf "Create $@ ... "
	@xsltproc -o $@ $(XSLTFILE) $?
	@echo "Done"
	@sed -i -e 's/\.xml/\.xhtml/g' $@

validate:
	@xmlstarlet val --well-formed menu.xml
	@xmlstarlet val --embed       menu.xml
	@xmlstarlet val --well-formed $(XSLTFILE)
	for f in $(XHTMLFILES); do \
		xmlstarlet val --well-formed $$f; \
		xmlstarlet val --embed $$f; \
	done

clean:
	rm -f *.xhtml
