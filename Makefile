REPORT=paper
LATEX=pdflatex
BIBTEX=bibtex -min-crossrefs=100
REF1=ref
REF2=rfc

TEX = $(wildcard *.tex)
SRCS = $(TEX)
REFS=$(REF1).bib

all: pdf

############################################################

spell:
	make clean
	for i in *.tex; do ispell $$i; done


pdf: $(SRCS) #$(REFS)
	$(LATEX) $(REPORT)
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)


tidy:
	rm -f *.dvi *.aux *.log *.blg *.bbl

clean:
	rm -f *~ *.dvi *.aux *.log *.blg *.bbl $(REPORT).ps *.md5 *.auxlock *.out


#$(REPORT).ps: $(REPORT).dvi
#	dvips -t letter -G0 -P cmz $(REPORT).dvi -o $(REPORT).ps
#view: $(REPORT).dvi
#	xdvi $(REPORT).dvi
#print: $(REPORT).dvi
#	dvips $(REPORT).dvi
#pdf: $(REPORT).ps
#	ps2pdf14 -dPDFSETTINGS=/prepress -dSubsetFonts=true -dEmbedAllFonts=true $<
#	ps2pdf $< $(REPORT).pdf
#printer: $(REPORT).ps
#	lpr $(REPORT).ps
