# Makefile to build and install the Application Developers Guide
# and the Channel Access Protocol Specification
# Requires:
#   AppDevGuide:
#       TeX Live 2015 or later
#   CAproto:
#       asciidoc and dia

# Target installation directory

INSTALL_DIR = /net/epics-ops/web_roots/epics/docroot/base/R3-16/1-docs


# Where is TeXLive installed?
LATEX_DIR = /usr/local/texlive/2017
LATEX_BIN = $(LATEX_DIR)/bin/x86_64-linux
export PATH := $(PATH):$(LATEX_BIN)

#### Application Developers Guide

A = AppDevGuide
ADG_DIR = $A
ADG_PDF = $A.pdf
ADG_HTML = $(ADG_DIR)/$A.html
ADG_TARGETS = $(ADG_PDF) $(ADG_HTML)
TARGET_PDF  += $(ADG_PDF)
TARGET_HTML += $(ADG_HTML)

# Latex Sources
TEX_DIR = tex
TEX_SRCS = AppDevGuide.tex AppDevGuide.cfg
TEX_SRCS += $(TEX_DIR)/titlepage.tex
TEX_SRCS += $(TEX_DIR)/introduction.tex
TEX_SRCS += $(TEX_DIR)/gettingStarted.tex
TEX_SRCS += $(TEX_DIR)/overview.tex
TEX_SRCS += $(TEX_DIR)/epicsBuildFacility.tex
TEX_SRCS += $(TEX_DIR)/lockScanProcess.tex
TEX_SRCS += $(TEX_DIR)/databaseDefinition.tex
TEX_SRCS += $(TEX_DIR)/iocInit.tex
TEX_SRCS += $(TEX_DIR)/accessSecurity.tex
TEX_SRCS += $(TEX_DIR)/test.tex
TEX_SRCS += $(TEX_DIR)/errorLogging.tex
TEX_SRCS += $(TEX_DIR)/recordSupport.tex
TEX_SRCS += $(TEX_DIR)/deviceSupport.tex
TEX_SRCS += $(TEX_DIR)/driverSupport.tex
TEX_SRCS += $(TEX_DIR)/staticDatabaseAccess.tex
TEX_SRCS += $(TEX_DIR)/runtimeDatabaseAccess.tex
TEX_SRCS += $(TEX_DIR)/generalPurposeTasks.tex
TEX_SRCS += $(TEX_DIR)/scanning.tex
TEX_SRCS += $(TEX_DIR)/iocsh.tex
TEX_SRCS += $(TEX_DIR)/libCom.tex
TEX_SRCS += $(TEX_DIR)/libComOsi.tex
TEX_SRCS += $(TEX_DIR)/registry.tex
TEX_SRCS += $(TEX_DIR)/databaseStructures.tex

# Encapsulated PostScript Sources
EPS_DIR = eps
EPS_SRCS += $(EPS_DIR)/overview_1.eps
EPS_SRCS += $(EPS_DIR)/overview_6.eps
EPS_SRCS += $(EPS_DIR)/accessSecurity_1.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_26.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_6.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_34.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_9.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_16.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_37.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_1.eps
EPS_SRCS += $(EPS_DIR)/lockScanProcess_40.eps
EPS_SRCS += $(EPS_DIR)/databaseStructures_1.eps

# Diagrams converted from EPS
DIAGS_DIR = diags
DIAGS = $(patsubst $(EPS_DIR)/%.eps,$(DIAGS_DIR)/%.pdf,$(EPS_SRCS))


#### CA Protocol Specification

CAP_DIR = CAproto
CAP_PDF = CAproto.pdf
CAP_HTML = $(CAP_DIR)/index.html
CAP_TARGETS = $(CAP_HTML)
#TARGET_PDF  += $(CAP_PDF)
TARGET_HTML += $(CAP_HTML)

# Asciidoc source file
ASC_DIR = ca_protocol
ASC_SRC = $(ASC_DIR)/ca_protocol.txt

# Dia Sources
DIA_DIR = $(ASC_DIR)/dia
DIA_SRCS += $(DIA_DIR)/connection-states.dia
DIA_SRCS += $(DIA_DIR)/repeater.dia

# Dot Sources
DOT_DIR = $(ASC_DIR)/dot
DOT_SRCS += $(DOT_DIR)/camessage.dot

# Diagrams converted from dia or dot sources
PNGS += $(patsubst $(DIA_DIR)/%.dia,$(CAP_DIR)/%.png,$(DIA_SRCS))
PNGS += $(patsubst $(DOT_DIR)/%.dot,$(CAP_DIR)/%.png,$(DOT_SRCS))

#### Generator options

# Options for pdflatex
PDFL_OPTS = --interaction=nonstopmode

# Options for htlatex (see .cfg file for more):
HTL_OPTS1 = "AppDevGuide,2"
HTL_OPTS2 = " -cunihtf -utf8"
HTL_OPTS3 = "-cvalidate -d$(ADG_DIR)/"
HTL_OPTS4 = "--interaction=nonstopmode"
HTL_OPTS = $(HTL_OPTS1) $(HTL_OPTS2) $(HTL_OPTS3) $(HTL_OPTS4)

# Options for asciidoc
ASC_OPTS += -a numbered


# Build targets
TARGETS += $(TARGET_PDF)
TARGETS += $(TARGET_HTML)

# Installation targets
INSTALL_PDF  = $(addprefix $(INSTALL_DIR)/, $(TARGET_PDF))
INSTALL_HTML = $(addprefix $(INSTALL_DIR)/, $(TARGET_HTML))
INSTALL_TARGETS = $(INSTALL_PDF) $(INSTALL_HTML)

all: $(TARGETS)
pdf: $(TARGET_PDF)
html: $(TARGET_HTML)
adg: $(ADG_TARGETS)
cap: $(CAP_TARGETS)
install: $(INSTALL_TARGETS)


#### Install Rules

# rsync a single PDF file
$(INSTALL_DIR)/%.pdf: %.pdf
	rsync -av $< $(INSTALL_DIR)

# rsync the whole directory containing the target .html file
$(INSTALL_DIR)/%.html: %.html
	rsync -av $(<D) $(INSTALL_DIR)


#### AppDevGuide Rules

$(ADG_PDF): $(TEX_SRCS) $(DIAGS)
	@rm -f pdflatex-*.out $A.lg $A.tmp $A.xref
	@rm -f $A.idx $A.ind $A.ilg $A.log $A.toc $A.aux $A.css $A.dvi $A.idv
	@echo "*** Creating $@ ***"
	pdflatex $(PDFL_OPTS) $(basename $@) > pdflatex-1.out
	makeindex $(basename $@).idx
	pdflatex $(PDFL_OPTS) $(basename $@) > pdflatex-2.out
	makeindex $(basename $@).idx
	pdflatex $(PDFL_OPTS) $(basename $@) > pdflatex-3.out
	@echo "*** Created $@ ***"

$(ADG_DIR)/$A.html: $(TEX_SRCS) $(EPS_SRCS) | $(ADG_DIR)
	@rm -f htlatex-*.out $A.lg $A.tmp $A.xref $A.4*
	@rm -f $A.idx $A.ind $A.ilg $A.log $A.toc $A.aux $A.css $A.dvi $A.idv
	@echo "*** Creating $@ ***"
	htlatex $< $(HTL_OPTS) > htlatex-1.out
	tex '\def\filename{{AppDevGuide}{idx}{4dx}{ind}} \input idxmake.4ht'
	makeindex -o $A.ind $A.4dx
	htlatex $< $(HTL_OPTS) > htlatex-2.out
	@echo "*** Created $@ ***"

$(ADG_DIR):
	mkdir -p $@

$(DIAGS_DIR)/%.pdf: $(EPS_DIR)/%.eps | $(DIAGS_DIR)
	epstopdf $< -o=$@

$(DIAGS_DIR):
	mkdir -p $@


#### CAproto Rules

# PDF rule fails on RHEL (xmllint complains)
$(CAP_PDF): $(ASC_SRC) $(PNGS)
	a2x $(ASC_OPTS) --destination-dir=$(@D) --format=pdf $<

$(CAP_DIR)/index.html: $(ASC_SRC) $(PNGS)
	@echo "*** Creating $@ ***"
	asciidoc $(ASC_OPTS) -o $@ $<
	@echo "*** Created $@ ***"

$(CAP_DIR)/%.png: $(DIA_DIR)/%.dia | $(CAP_DIR)
	dia -t png -e $@ $<

$(CAP_DIR)/%.png: $(DOT_DIR)/%.dot | $(CAP_DIR)
	dot -T png -o $@ $<

$(CAP_DIR):
	mkdir -p $@


#### Clean Rules etc.

clean: cleanidx
	rm -rf $(TARGETS)
	rm -rf $(ADG_DIR) $(DIAGS_DIR) $(CAP_DIR)

cleanidx:
	rm -f $A.idx $A.ind $A.ilg $A.log $A.toc $A.aux $A.css $A.dvi $A.idv
	rm -f $A.lg $A.tmp $A.xref *.out *.pdf *.html *.4* idxmake.*
	rm -f *.backup *~ tex/*.backup tex/*~

.PHONY: all pdf html install
.PHONY: clean cleanidx
