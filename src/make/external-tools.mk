# ------------------------------------------------------------------------------------
# External tools
# ------------------------------------------------------------------------------------
RM_CMD						= rm
RM_ARGS						= -rf
RM							= $(RM_CMD) $(RM_ARGS)

TAR_CMD						= /bin/tar
TAR_ARGS					= zcf
TAR							= $(TAR_CMD) $(TAR_ARGS)


# ------------------------------------------------------------------------------------
# Tools
# ------------------------------------------------------------------------------------

define FILTER_ERROR
|egrep -B 3 -A 5 \./.*:[0-9]*:.*$
endef

QUIET= &>/dev/null

set errorformat=%f:%l:%c:%m

#LATEX_CMD					= /usr/texbin/latex
#-interaction=batchmode
#--src-specials
#--file-line-error
#-no-file-line-error
#-file-line-error-style
#--shell-escape --synctex=1
#--interaction batchmode
#-file-line-error
#--interaction batchmode --halt-on-error
LATEX_CMD					= latex
LATEX_ARGS					= -file-line-error --halt-on-error --shell-escape
LATEX						= $(LATEX_CMD) $(LATEX_ARGS)

#DVIPDF						= /usr/local/bin/dvipdf
DVIPDF						= dvipdf
#DVIPS_CMD					= /usr/texbin/dvips
DVIPS_CMD					= dvips
DVIPS_ARGS					= -D 600
DVIPS						= $(DVIPS_CMD) $(DVIPS_ARGS)


# PS2PDF						= /usr/local/bin/ps2pdf
PS2PDF						= ps2pdf

#FIX 4 BITEX
export openout_any = a
BIBTEX						= bibtex


PDFLATEX_CMD				= pdflatex
PDFLATEX_ARGS				= -file-line-error -halt-on-error
#-halt-on-error -file-line-error --shell-escape 
#--interaction batchmode
PDFLATEX					= $(PDFLATEX_CMD) $(PDFLATEX_ARGS)

CREATE_SYNCTEX		        = --synctex=0

# form textshop
# pdftex --file-line-error --shell-escape --synctex=1
# pdflatex --file-line-error --shell-escape --synctex=1
# simpdftex etex --maxpfb --extratexopts "-file-line-error -synctex=1"
# simpdftex latex --maxpfb --extratexopts "-file-line-error -synctex=1"
#SYNCTEX						= /usr/texbin/synctex
SYNCTEX						= synctex