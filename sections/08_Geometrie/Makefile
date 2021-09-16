TEXFILES=$(wildcard *.standalone.tex)
TARGETS=$(patsubst %.tex,%.eps,$(TEXFILES))

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"

# include init.mk

QUIET= &>/dev/null

GOALS = $(TARGETS)

all: $(GOALS) tasks

display: $(OUTPUT)
	open $<

%.dvi: %.tex
	latex $<


#%.eps: %.dvi
#	dvips -E* $< -o $@

%.ps: %.dvi
	dvips $< -o $@

%.eps: %.ps
	ps2eps $<

%.pdf: %.ps
	ps2pdf $<

#%.pdf: %.tex
#	pdflatex $<
#	egrep -c $(RERUNBIB) $*.log && (bibtex $*;pdflatex $<); true
#	egrep $(RERUN) $*.log && (pdflatex $<) ; true
#	egrep $(RERUN) $*.log && (pdflatex $<) ; true
#	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
        	*.inx *.ps *.dvi *.toc *.out

%.eps: %.pdf
	@echo $< $@
#	convert $< $@

# dvips -E* -o foo.eps pythagoras.standalone.dvi

clean:
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
	*.inx *.ps *.dvi *.pdf *.toc *.out *.eps