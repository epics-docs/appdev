# requires:
# latex2html and pdflatex
# asciidoc, dia

TEXD=tex
PDFD=pdf
EPSD=eps
CADIAD=ca_protocol/dia
CADOTD=ca_protocol/dot

PDFS = \
$(PDFD)/overview_1.pdf \
$(PDFD)/overview_6.pdf \
$(PDFD)/accessSecurity_1.pdf \
$(PDFD)/lockScanProcess_26.pdf  \
$(PDFD)/lockScanProcess_6.pdf  \
$(PDFD)/lockScanProcess_34.pdf \
$(PDFD)/lockScanProcess_9.pdf \
$(PDFD)/lockScanProcess_16.pdf \
$(PDFD)/lockScanProcess_37.pdf \
$(PDFD)/lockScanProcess_1.pdf \
$(PDFD)/lockScanProcess_40.pdf \
$(PDFD)/scanning_1.pdf \
$(PDFD)/scanning_12.pdf \
$(PDFD)/scanning_19.pdf \
$(PDFD)/databaseStructures_1.pdf

TEXS = \
$(TEXD)/titlepage.tex \
$(TEXD)/introduction.tex \
$(TEXD)/gettingStarted.tex \
$(TEXD)/overview.tex \
$(TEXD)/epicsBuildFacility.tex \
$(TEXD)/lockScanProcess.tex \
$(TEXD)/databaseDefinition.tex \
$(TEXD)/iocInit.tex \
$(TEXD)/accessSecurity.tex \
$(TEXD)/test.tex \
$(TEXD)/errorLogging.tex \
$(TEXD)/recordSupport.tex \
$(TEXD)/deviceSupport.tex \
$(TEXD)/driverSupport.tex \
$(TEXD)/staticDatabaseAccess.tex \
$(TEXD)/runtimeDatabaseAccess.tex \
$(TEXD)/generalPurposeTasks.tex \
$(TEXD)/scanning.tex \
$(TEXD)/iocsh.tex \
$(TEXD)/libCom.tex \
$(TEXD)/libComOsi.tex \
$(TEXD)/registry.tex \
$(TEXD)/databaseStructures.tex

DIAS = \
$(CADIAD)/connection-states.dia \
$(CADIAD)/repeater.dia \

DOTS = \
$(CADOTD)/camessage.dot

GENPNG = $(DIAS:$(CADIAD)/%.dia=ca_protocol/%.png)
GENPNG += $(DOTS:$(CADOTD)/%.dot=ca_protocol/%.png)

# Options for latex2html:
L2H_OPTS += -split +1
L2H_OPTS += -link 2
L2H_OPTS += -toc_depth 3
L2H_OPTS += -show_section_numbers
L2H_OPTS += -local_icons
L2H_OPTS += -info 0


all: pdf html

pdf: AppDevGuide.pdf
html: AppDevGuide ca_protocol/index.html

AppDevGuide.pdf: AppDevGuide.tex $(TEXS) $(PDFS)
	pdflatex $(basename $@)
	makeindex $(basename $@).idx
	pdflatex $(basename $@)
	pdflatex $(basename $@)

AppDevGuide: AppDevGuide.tex $(TEXS) Makefile
	latex2html $< $(L2H_OPTS)

$(PDFD)/%.pdf: $(EPSD)/%.eps
	mkdir -p $(PDFD)
	epstopdf $< -o=$@

ca_protocol/%.png: $(CADIAD)/%.dia
	dia -t png -e $@ $<

ca_protocol/%.png: $(CADOTD)/%.dot
	dot -T png -o $@ $<

ca_protocol/index.html: ca_protocol/ca_protocol.txt $(GENPNG)
	asciidoc -n -b html5 -o $@ $<

clean: cleanidx
	rm -rf AppDevGuide
	rm -rf pdf
	rm -f ca_protocol/index.html
	rm -f $(GENPNG)

cleanidx:
	rm -f *.idx *.ind *.ilg *.log *.out *.pdf *.toc *.aux
	rm -f *.backup *~ tex/*.backup tex/*~

.PHONY: pdf html
.PHONY: clean cleanidx
