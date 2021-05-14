DOCUMENTS = presentation.pdf
BUILD = build

all: $(DOCUMENTS) spellcheck

clean:
	rm -rf $(DOCUMENTS) $(BUILD)

spellcheck: spellcheck-presentation.tex.tmp spellcheck-README.md.tmp

spellcheck-%.tex.tmp: %.tex Makefile
	detex -w $*.tex | hunspell -d en_CA -L > $@

spellcheck-%.md.tmp: %.md Makefile
	hunspell -d en_CA -w $*.md > $@

%.pdf: %.tex Makefile
	mkdir -p $(BUILD)/$*/
	cp $^ $(BUILD)/$*/
	mv $(BUILD)/$*/$*.tex $(BUILD)/$*/root.tex
	touch $(BUILD)/$*/root.tex
	$(MAKE) -C $(BUILD)/$*/ root.pdf
	cp $(BUILD)/$*/root.pdf $@

root.pdf: root.tex
	texfot lualatex root.tex
	texfot lualatex root.tex

.PHONY: all clean spellcheck
