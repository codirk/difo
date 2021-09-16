TEXFILES=$(wildcard *.standalone.tex)
TARGETS=$(patsubst %.tex,%.pdf,$(TEXFILES))

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"

# include init.mk

QUIET= &>/dev/null

GOALS = $(TARGETS)

all: $(GOALS) tasks

display: $(OUTPUT)
	open $<

%.pdf: %.tex
	pdflatex $<
	egrep -c $(RERUNBIB) $*.log && (bibtex $*;pdflatex $<); true
	egrep $(RERUN) $*.log && (pdflatex $<) ; true
	egrep $(RERUN) $*.log && (pdflatex $<) ; true
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
        	*.inx *.ps *.dvi *.toc *.out

clean:
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
	*.inx *.ps *.dvi *.pdf *.toc *.out