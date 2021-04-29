# ------------------------------------------------------------------------------------
# Paths 
# ------------------------------------------------------------------------------------
# define if you run this script outsite X-Code
ifndef SRCROOT
SRCROOT:=$(shell pwd)
endif

SOURCE_DIRS= $(foreach folder,${SRC_DIRS},$(dir $(wildcard $(SRCROOT)/$(folder)/)))
#$(info $(SOURCE_DIRS))
TEXFILES= $(foreach x,${SOURCE_DIRS},$(wildcard $x*.tex))
PDFFILES=$(patsubst %.tex,%.pdf,$(TEXFILES))
ifeq ($(DEBUG),1)
$(info PDFFILES=$(PDFFILES))
endif

# Convert the spaces to colons.  This trick is from the make info file.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
# classpath:= $(subst $(SPACE),:,$(classpath))

# TODO
#INPUT_DIRS=$(subst $(SPACE),:,$(sort $(dir $(wildcard $(SRCROOT)/source/*/input/*/))))

# include all style directories
STYLE_DIRS=$(subst $(SPACE),:,$(sort $(dir $(wildcard $(SRCROOT)/Latex/styles/*/)))):$(SRCROOT)/Latex/styles/
STEXINPUTS=$(subst $(SPACE),:,$(SOURCE_DIRS))
#$(info $(STYLE_DIRS))

TMPDIR=${DIR_BUILD}/tmp
#SRCDIR=${SRCROOT}/Latex
#RESDIR=${SRCROOT}/Result

# ------------------------------------------------------------------------------------
# Environment 
#	TEXINPUTS
#	BSTINPUTS
#
#	we set the global TEXINPUTS so we have not to call
#		TEXINPUTS="$(DIR_SOURCE):...:" $(LATEX) -output-directory=$(DIR_BUILD) $< 
#
#	--include-directory dos not work in the x-code environment.
#	@$(LATEX) -output-directory=$(DIR_BUILD)/ --include-directory=$(DIR_SOURCE)/ $<
# ------------------------------------------------------------------------------------

TEXINPUTS:=${STYLE_DIRS}:${TEXINPUTS}:${STEXINPUTS}::://

BSTINPUTS:=${STYLE_DIRS}:${BSTINPUTS}
export TEXINPUTS BSTINPUTS

#texmf.cnf
# increase max_print_line for x-code marker
export max_print_line = 1048576	
#sed -e :a -e '$!N;s/\(\/.*\/.*\.tex\):\([0-9][0-9]\)\n:/\1:\2:/;ta'		
#error_line = 79
#half_error_line = 50


# does not work in x-code environment :(
PATH := $(PATH):/usr/texbin:/usr/texbin
export PATH

ifeq ($(DEBUG),1)
$(info TEXINPUTS=$(TEXINPUTS))
$(info BSTINPUTS=$(BSTINPUTS))
$(info PATH=$(PATH))
endif

# ------------------------------------------------------------------------------------
# Create necessary directories		
# ------------------------------------------------------------------------------------
init: $(DIR_BUILD)

$(TMPDIR):
	@-if [ ! -e $@ ]; then mkdir $@; fi;


MSG_INIT					:= Creating Directory _DIRECTORY_

$(DIR_BUILD):$(TMPDIR)
	@echo --- $(subst _DIRECTORY_,$(DIR_BUILD),$(MSG_INIT))
	@-if [ ! -e $(DIR_BUILD) ]; then mkdir $(DIR_BUILD); fi;