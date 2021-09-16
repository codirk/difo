LATEX = latex
BIBTEX = bibtex
L2H = latex2html
PS2PDF = ps2pdf
PSBOOK = psbook
DVIPS = dvips

COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi
RM = rm -f

TEX_INPUTS=$(wildcard *.tex)
TEX_TARGETS=$(patsubst %.tex,%.pdf,$(TEX_INPUTS))
#TARGETS=$(patsubst %.tex,%.ps,$(TEXFILES)) $(patsubst %.tex,%.pdf,$(TEXFILES))

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"


PNG_INPUTS=$(wildcard */*.png */*/*.png */*/*/*.png)
PNG_TARGETS=$(patsubst %.png,%.eps,$(INPUTS))

GOALS = $(TEX_TARGETS)

all: $(GOALS)
	@echo $(GOALS) test

%.eps: %.pdf
	@echo $< $@
	convert $< $@

GOALS = $(TARGETS)

all: $(GOALS)

all-recursive:
	for dir in $(wildcard *); do if [ -d $$dir ] && [ -f $$dir/Makefile ]; then cd $$dir; $(MAKE) all; cd ..; fi; done


display: $(OUTPUT)
	open $<

%.dvi: %.tex
	($(COPY);$(LATEX) $<)
	egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
	cmp -s $*.toc $*.toc.bak || $(LATEX) $<
	$(RM) $*.toc.bak
	# Display relevant warnings
	egrep -i "(Reference|Citation).*undefined" $*.log ; true

%.ps: %.dvi
	dvips $< -o $@


%.pdf: %.ps
	$(PS2PDF) $<
	@echo $(PSBOOK) $(basename $<){,.A4}.ps
	$(PSBOOK) $(basename $<){,.A4}.ps
	psnup -2 -pA4 -q $(basename $<).A4.ps $(basename $<)BookA5.ps
	ps2pdf -sPAPERSIZE=a4 -dAutoRotatePages=/All -dPDFsettings=/prepress $(basename $<)BookA5.ps $(basename $<)BookA5.pdf
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
            	*.inx *.ps *.dvi *.toc *.out

clean:
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
	*.inx *.ps *.dvi *.pdf *.toc *.out