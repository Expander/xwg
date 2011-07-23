# XWG Copyright (C) 2011 Alexander Voigt
#
# This file is part of XWG.
#
# XWG is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# XWG is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with XWG.  If not, see
# <http://www.gnu.org/licenses/>.

# This makefile creates transforms all XML files into static web sites
# of XHTML of HTML format.  The use has to specify
#
# 1.)  the XSLT file to use for the transformation
# 2.)  the file name extension for the output files
# 3.)  the XSLT processor (default is xsltproc)

# file name extension for the output files, e.g. xhtml or html
OUTPUTFORMAT = xhtml

# the XSLT file to use for the transformation
XSLTFILE     = system-xhtml11.xsl

# generate list of output files from all existing .xml files
OUTPUTFILES  = $(foreach file, $(basename $(wildcard *.xml)), $(file).$(OUTPUTFORMAT))

all: $(OUTPUTFILES)

%.$(OUTPUTFORMAT): %.xml
	@printf "Create $@ ... "
	@xsltproc -o $@ $(XSLTFILE) $?
	@echo "Done"
	@sed -i -e 's/\.xml/\.$(OUTPUTFORMAT)/g' $@

.PHONY: validate clean

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
