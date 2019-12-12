REPORT	=	paper
LATEX		= pdflatex
BIBTEX	= bibtex -min-crossrefs=100
REF 		=	ref

TEX 	= $(wildcard *.tex)
SRCS 	= $(TEX)
FMT 	= cmds.tex hdr.tex fmt.tex
REFS 	= macro.bib $(REF).bib
OPTS 	= -interation=nonstopmode -quiet -halt-on-error
UNAME	=	$(shell uname -s)
QUITE = false

ifeq ($(UNAME), Linux)
	VIEWER	=	evince
endif 
ifeq ($(UNAME), Darwin)
	VIEWER	=	open
endif
ifeq ($(OS),Windows_NT)
	VIEWER	=	$(shell echo "Yolo does not support stupid Windows ^.^  >> file: ")
endif

ifeq ($(QUITE), true)
	SUFFIX = 1>/dev/null
else
	SUFFIX = ""
endif

ifneq ("$(wildcard $(REPORT).bbl)","")
all: fast	
else
all: loud
endif

.PHONY: fast loud quite bib spell 

fast: $(SRCS) $(REFS)
	@echo ================== YOLO: running fast build ==================
	@TEXINPUTS="sty:" $(LATEX) $(OPTS) $(REPORT) $(SUFFIX) 
	rm -f *~ *.dvi *.log *.blg $(REPORT).ps *.out *.bcf *.soc

loud: $(SRCS) $(REFS)
	@echo ================== YOLO: running full build ==================
	@TEXINPUTS="sty:" $(LATEX) $(OPTS) $(REPORT) $(SUFFIX) 
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl
	@TEXINPUTS="sty:" $(LATEX) $(OPTS) $(REPORT) $(SUFFIX) 
	@TEXINPUTS="sty:" $(LATEX) $(OPTS) $(REPORT) $(SUFFIX) 

quite: $(SRCS) $(REFS)
	@echo ================== YOLO: running full build quitely ==================
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) 1>/dev/null
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) 1>/dev/null
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) 1>/dev/null

spell:
	make clean
	for i in $(filter-out $(FMT), $(SRCS)); do ispell $$i; done

bib: $(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl

l: loud

full: loud

pdf: loud

q: quite

tidy:
	rm -f *~ *.dvi *.aux *.log *.blg *.bbl $(REPORT).ps *.out *.bcf *.soc

clean: tidy
	rm -f $(REPORT).pdf

view: all
	$(VIEWER) $(REPORT).pdf
