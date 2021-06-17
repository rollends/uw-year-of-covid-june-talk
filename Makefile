DOCUMENTS = presentation.pdf
BUILD = build

all: $(DOCUMENTS) spellcheck

clean:
	rm -rf $(DOCUMENTS) $(BUILD)

spellcheck: spellcheck-presentation.tex.tmp spellcheck-README.md.tmp spellcheck-Bio.md.tmp

spellcheck-%.tex.tmp: %.tex Makefile
	detex -w $*.tex | hunspell -d en_CA -L > $@

spellcheck-%.md.tmp: %.md Makefile
	egrep -o "\w+" $*.md | hunspell -d en_CA -l > $@
	wc -w $*.md >> $@

%.pdf: %.tex Makefile
	mkdir -p $(BUILD)/$*/
	cp $^ $(BUILD)/$*/
	mv $(BUILD)/$*/$*.tex $(BUILD)/$*/root.tex
	touch $(BUILD)/$*/root.tex
	$(MAKE) -C $(BUILD)/$*/ root.pdf
	cp $(BUILD)/$*/root.pdf $@

presentation.pdf: presentation.tex refs/references.bib gfx/InstrumentModelling.pdf gfx/ThoughtExperiment.pdf gfx/roveroverlook.jpg gfx/SpaceShuttle_Trans.png Makefile
	mkdir -p $(BUILD)/presentation/
	cp $^ $(BUILD)/presentation/
	mv $(BUILD)/presentation/presentation.tex $(BUILD)/presentation/root.tex
	touch $(BUILD)/presentation/root.tex
	$(MAKE) -C $(BUILD)/presentation/ root.pdf
	cp $(BUILD)/presentation/root.pdf $@

root.pdf: root.tex
	texfot lualatex root.tex
	texfot biber root
	texfot lualatex root.tex

.PHONY: all clean spellcheck
