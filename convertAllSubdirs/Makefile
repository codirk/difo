


# TEXFILES=$(wildcard **/*.png)
INPUTS=$(wildcard */*.png */*/*.png */*/*/*.png)
#TEXFILES=$(wildcard images/biums/wumr/*.png)
TARGETS=$(patsubst %.png,%.eps,$(INPUTS))

GOALS = $(TARGETS)

all: $(GOALS)
	@echo $(GOALS) test

%.eps: %.png
	@echo $< $@
	convert $< $@