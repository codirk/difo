# ------------------------------------------------------------------------------------
# 
# NOTES:
#	DO NOT MODIFY
#	Copy this file to ../makefile-config.mk and put your modifications there.
# 
# ------------------------------------------------------------------------------------
SRC_DIRS	=	src/latex/*.tex \
				src/latex/sections/*/*.standalone.tex

# Flag to mark this file as included
CONFIG_OVERRIDE		:= 1

# ------------------------------------------------------------------------------------
# Natures
# ------------------------------------------------------------------------------------
nature                = latex

# ------------------------------------------------------------------------------------
# Always Open pdf's
# TODO
# ------------------------------------------------------------------------------------
PDFs := doc1.pdf doc2.pdf

# ------------------------------------------------------------------------------------
# Display options
# ------------------------------------------------------------------------------------
DEBUG				= 0
CREATE_SYNCTEX		= --synctex=0

#DO_OPEN_PDF			:= 1

