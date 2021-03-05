#!/usr/bin/env bash

selector=${BASH_SOURCE[0]%.*}
selector=${selector##*.}

TeXFileName=$selector
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $SCRIPT_DIR

# Erzeugung des DVI-Files
latex $TeXFileName
latex $TeXFileName
latex $TeXFileName
# (Ggf. mehrmals, Berücksichtigung anderer Tools wie BibTeX)
# Erzeugen der Postscript-Datei
dvips -Ppdf ${TeXFileName}.dvi
# Anordnen der Seiten zum Druck eines Buches
psbook ${TeXFileName}{,A4}.ps 
# Verkleinerung, so dass mehrere Seiten auf einer gedruckt werden können
psnup -2 -pA4 -q ${TeXFileName}A4.ps ${TeXFileName}BookA5.ps
# Optional: Erzeugung eines PDF-Files
ps2pdf -sPAPERSIZE=a4 -dAutoRotatePages=/All -dPDFsettings=/prepress ${TeXFileName}BookA5.ps ${TeXFileName}BookA5.pdf
