REPORT	=	paper
LATEX		= pdflatex
BIBTEX	= bibtex -min-crossrefs=100
REF 		=	ref

TEX 	= $(wildcard *.tex)
SRCS 	= $(TEX)
FMT 	= cmds.tex hdr.tex fmt.tex
REFS 	= macro.bib $(REF).bib
OPTS 	= -interation=batchmode 
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

abs: 
	@echo "\\\\begin{abstract}" > abs.tex
	@cat abs.txt >> abs.tex
	@echo "\end{abstract}" >> abs.tex
	@echo ================= building abstract.tex ===================

fast: abs $(SRCS) $(REFS)
	@echo ================== YOLO: running fast build ==================
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) $(SUFFIX)
	# rm abs.tex

loud: abs $(SRCS) $(REFS)
	@echo ================== YOLO: running full build ==================
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) $(SUFFIX)
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) $(SUFFIX)
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) $(SUFFIX)
	rm abs.tex

quite: abs $(SRCS) $(REFS)
	@echo ================== YOLO: running full build quitely ==================
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) 1>/dev/null
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" $(REPORT).bbl
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) 1>/dev/null
	@TEXINPUTS="sty:" $(LATEX) $(REPORT) $(OPTS) 1>/dev/null
	rm abs.tex

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
