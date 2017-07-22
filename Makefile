# make Datei fuer LaTeX
# Time-stamp: <2009-02-14 11:57:27 ewi>
# Aufruf: make macht das, was hinter all: steht, bei Bedarf anpassen.
#         make all Erzeugt das blanke pdf aus den tex-files
#         make release Erzeugt pdfs mit cover fertig für druck/online-release
#         make clean loescht alles, was neu erzeugt werden kann.
# ganz wichtig: die Befehlszeilen muessen mit einem TAB beginnen!!!


LATEX = pdflatex --synctex=1

# Find all dependencies (this is overly broad but works)
IMAGES = $(shell find bilder | sed 's/ /\\ /g')
DEPS = $(shell find header texte -type f -name '*.tex' | sed 's/ /\\ /g') 1-te.tex
GENERATED_LATEX = texte/nuetzliches/lernraeume_iz.tex texte/nuetzliches/lernraeume_andere.tex

all: 1-te.pdf

release: 1-te.pdf 1-te_online.pdf 1-te_booklet.pdf

1-te_online.pdf: 1-te.pdf
	pdfjam --outfile 1-te_online.pdf bilder/Erste_Cover/vorne.pdf 1-te.pdf bilder/Erste_Cover/hinten.pdf

1-te_booklet.pdf: 1-te.pdf
	pdfbook --outfile 1-te_booklet_coverless.pdf 1-te.pdf
	pdfjam --landscape --outfile 1-te_booklet.pdf bilder/Erste_Cover/cover.pdf bilder/Empty.pdf 1-te_booklet_coverless.pdf

1-te.pdf: $(IMAGES) $(DEPS) $(GENERATED_LATEX) 
	$(LATEX) 1-te.tex
	$(LATEX) 1-te.tex
	$(LATEX) 1-te.tex
	$(LATEX) 1-te.tex

%.tex: %.dokuwiki
	echo '% WARNING! This file is autogenerated, do not change it by hand! Change $^ instead!' > $@
	echo '\\begin{tabular}{|p{4cm}|p{5cm}|p{3.6cm}|p{4cm}|}' >> $@
	awk 'BEGIN { FS="[|^]"} {gsub("\\[\\[", "\\url{"); gsub("]]", "}"); print "\\hline" $$2 "&" $$3 "&" $$4 "&" $$5 "\\\\"}' $^ >> $@
	echo '\\hline' >> $@
	echo '\\end{tabular}' >> $@

clean: distclean
	rm -f 1-te.{dvi,ps,pdf}

distclean:
	rm -f *.{aux,log,toc,out,tdo,synctex.gz}
	rm -f *~
	rm -f $(GENERATED_LATEX)
