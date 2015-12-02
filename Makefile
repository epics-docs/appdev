# Makefile to build and install the Application Developers Guide
# and the Channel Access Protocol Specification
# Requires:
#   AppDevGuide:
#       latex2html and pdflatex
#   CAproto:
#       asciidoc and dia

# Target installation directory

INSTALL_DIR = /net/epics/Public/epics/base/R3-15/3-docs


#### Application Developers Guide

ADG_DIR = AppDevGuide
ADG_PDF = AppDevGuide.pdf
TARGET_PDF  += $(ADG_PDF)
TARGET_HTML += $(ADG_DIR)/index.html

# Latex Sources
TEX_DIR = tex
TEX_SRCS = AppDevGuide.tex
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
CAP_PDF = ca_protocol.pdf
#TARGET_PDF  += $(CAP_PDF)
TARGET_HTML += $(CAP_DIR)/index.html

# Asciidoc source file
ASC_DIR = ca_protocol
ASC_SRC = $(ASC_DIR)/ca_protocol.txt

# Dia Sources
DIA_DIR = $(ASC_DIR)/dia
DIA_SRCS += $(DIA_DIR)/virtual-circuit.dia
DIA_SRCS += $(DIA_DIR)/connection-states.dia
DIA_SRCS += $(DIA_DIR)/repeater.dia

# Diagrams converted from dia
PNGS = $(patsubst $(DIA_DIR)/%.dia,$(CAP_DIR)/%.png,$(DIA_SRCS))


#### Generator options

# Options for latex2html:
L2H_OPTS += -split +1
L2H_OPTS += -link 2
L2H_OPTS += -toc_depth 3
L2H_OPTS += -show_section_numbers
L2H_OPTS += -local_icons
L2H_OPTS += -info 0

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
	@rm -f pdflatex*.out
	pdflatex $(basename $@) > pdflatex-1.out
	makeindex $(basename $@).idx
	pdflatex $(basename $@) > pdflatex-2.out
	makeindex $(basename $@).idx
	pdflatex $(basename $@) > pdflatex-3.out

$(ADG_DIR)/index.html: $(TEX_SRCS) $(EPS_SRCS)
	@rm -f latex2html*.out $(ADG_DIR)/img*.png
	latex2html $< $(L2H_OPTS) > latex2html.out
	@echo '.'

$(DIAGS_DIR)/%.pdf: $(EPS_DIR)/%.eps $(DIAGS_DIR)
	epstopdf $< -o=$@

$(DIAGS_DIR):
	mkdir -p $@


#### CAproto Rules

# PDF rule is broken on RHEL 6:
#$(CAP_PDF): $(ASC_SRC) $(PNGS)
#	a2x $(ASC_OPTS) --destination-dir=$(@D) --format=pdf $<

$(CAP_DIR)/index.html: $(ASC_SRC) $(PNGS)
	asciidoc $(ASC_OPTS) -o $@ $<

$(CAP_DIR)/%.png: $(DIA_DIR)/%.dia $(CAP_DIR)
	dia -t png -e $@ $<

$(CAP_DIR):
	mkdir -p $@


#### Clean Rules etc.

clean: cleanidx
	rm -rf $(ADG_DIR) $(DIAGS_DIR)
	rm -rf $(CAP_DIR)

cleanidx:
	rm -f *.idx *.ind *.ilg *.log *.out *.pdf *.toc *.aux
	rm -f *.backup *~ tex/*.backup tex/*~

.PHONY: all pdf html install
.PHONY: clean cleanidx
