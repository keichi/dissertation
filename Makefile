MAIN=src/main.tex
SOURCES=$(wildcard ./src/*.tex)
IMAGE_OBJS=$(wildcard ./img/*.obj)
IMAGES=$(IMAGE_OBJS:.obj=.pdf)
REFERENCES=references.bib

.PHONY: all clean open watch

all: main.pdf

%.pdf-raw: %.obj
	tgif -color -print -pdf $<
	mv $(<:.obj=.pdf) $@

%.pdf-cropped: %.pdf-raw
	pdfcrop $< $@

%.pdf: %.pdf-cropped
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=$@ $<

main.pdf: $(MAIN) $(SOURCES) $(IMAGES) $(REFERENCES)
	latexmk -pdf $(MAIN)

clean:
	latexmk -C $(MAIN)

open: main.pdf
	latexmk -pdf -pv $(MAIN)

watch: main.pdf
	latexmk -pdf -pvc $(MAIN)

release: main.pdf
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/printer -sDEVICE=pdfwrite -dCompressFonts=true -dSubsetFonts=true -sOutputFile=dissertation-$(shell date +"%m%d").pdf main.pdf
