# -----------------------------------------------------------------------------------
# 
# Copyright (c) 2011, Dirk Messetat $(echo 'yngrk@zrffrgng.qr'|tr a-zA-Z n-za-mN-ZA-M)
#
# All rights reserved.
#
#	Redistribution and use in source and binary forms, with or without
#	modification, are permitted provided that the following conditions are met:
#
#	1.	Redistributions of source code must retain the above copyright notice, this
#		list of conditions and the following disclaimer.
#	2.	Redistributions in binary form must reproduce the above copyright notice,
#		this list of conditions and the following disclaimer in the documentation
#		and/or other materials provided with the distribution.
#	3.	The name(s) of the copyright holder(s) may not be used to endorse or
#		promote products derived from this software without specific prior written
#		permission.
#
#	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#	DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
#	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# ------------------------------------------------------------------------------------
# 
# TODO:
#	x pusd für includes in der TEX datei 
#	x graphiken einbinden
#	- synctex
#	- tex2html (natures)
#	- SCM anbindung howto für xcode
#	x BIBTEX
#	x langspec im Project für x-code -- geht nicht
#	- .PHONY überarbeiten
#	- wrapper zum rendern von teildokumenten, bzw. hauptdoc neu machen
#	x sourcefilefolder in default config
#	x filter error
#	- leerzeichen im pfad über "" absichern
#	x Pdf dateien löschen wenn .tex file in subdir neuer
#	- convert ressources e.g. to pdf or smaller size ....
#	- natures bz. profiles
#	- define OPEN_PREVIEW jenachdem ob Skim vorhanden ist, sonst Preview verwenden
#	
# NOTES:
# 
# http://www.ijon.de/comp/tutorials/makefile.html
# 
#MSGMERGE = @MSGMERGE@ --no-wrap

# ------------------------------------------------------------------------------------
#
# $Id: $

# ------------------------------------------------------------------------------------
# Phony (avoid problems with local files)
# http://makepp.sourceforge.net/1.18/t_phony.html
# ------------------------------------------------------------------------------------

PROGRAMS	:= clean test _start _end
.PHONY: all $(PROGRAMS)
$(phony all): $(PROGRAMS)

# ------------------------------------------------------------------------------------
# the default target
# ------------------------------------------------------------------------------------

default: all

# ------------------------------------------------------------------------------------
# Includes
# ------------------------------------------------------------------------------------

# Includes the configuration file
-include makefile-config.mk
# If makefile-config.mk not exists use default-config.mk
ifndef CONFIG_OVERRIDE
include src/make/defaults.mk
endif

include src/make/extensions.mk
include src/make/init.mk
include src/make/external-tools.mk

# ------------------------------------------------------------------------------------
# Target All
# ------------------------------------------------------------------------------------

#THEFILES = $(wildcard *)
#print_files:
#	$(foreach files, $(THEFILES), @echo $(files))
	
ifdef open
all: init _start $(PDFFILES) _end
	echo $(_TARGET_FILES)
else
all: init _start $(PDFFILES) _end	 
endif


MSG_START := Beginning - GNU Make _MAKE_VERSION_

# ------------------------------------------------------------------------------------
# Targets
# ------------------------------------------------------------------------------------
KEYWORDS=TODO.*|FIXME.*|\?\?\?:.*|\!\!\!:.*
KEYWORDS_MRK=TODO|FIXME|\?\?\?:|\!\!\!:

#IFS=$'\n';


# removes all pdf files that contains newer tex files in subdirs 
_removepdfs2refresh:
	@for pdf in $(PDFFILES) ; \
	do \
	[ -f $$pdf ] \
	&& [ $$(find $$(dirname $$pdf) -cnewer $$(dirname $$pdf) -type f -name *.tex -not -path '*/.svn/*' 2>/dev/null|wc -l) -ne 0 ] && rm $$pdf \
	|| true;\
	done

_start: _removepdfs2refresh
	@echo \######################################################
	@echo \# $(subst _MAKE_VERSION_,$(MAKE_VERSION),$(MSG_START))
	@echo \##^####################################################
	 

_end:
	@echo \######################################################
	@echo \# Tasks
	@echo \######################################################
	@find ${SRCROOT} \( -name "*.tex" -or -name "*.m" \) -print0 | \
    xargs -0 egrep --with-filename --line-number --only-matching "$(KEYWORDS)" | \
    perl -p -e "s/($(KEYWORDS_MRK))(.*)/TODO\2/"

# Cleans up the objects, .d files and executables.
clean:
	@echo Making clean.
	@cd $(DIR_BUILD);$(RM) *.pdf *.synctex.gz
	@echo $(DIR_BUILD) clean.


#	-cd $(dir $<);$(PDFLATEX) --draftmode --output-directory $(dir $<) $< $(FILTER_ERROR);	\
#	-cd $(dir $<);[ -f $*$(EXT_DDL) ] || $(BIBTEX) $* ;	\

%.pdf: %.tex
	@echo \# $(PDFLATEX) --output-directory $(dir $<) $(CREATE_SYNCTEX) -interaction=batchmode $<
	@if(grep 'begin{document}' $< > /dev/null); \
	then	\
		$(PDFLATEX)  --output-directory $(dir $<) -interaction=batchmode $< $(QUIET) ;	\
		$(PDFLATEX)  --output-directory $(dir $<) $(CREATE_SYNCTEX) -interaction=batchmode $< $(QUIET) ; \
		find $(dir $<) -name *.aux |xargs rm ;	\
		cd $(dir $<);$(RM) *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
                *.inx *.ps *.dvi *.toc *.out *.lof *.lot *.lol *~ *.nav *.snm;	\
	fi

%.tex:
