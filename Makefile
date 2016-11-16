# Makefile to build and install the Application Developers Guide
# Requires:
#       latex2html and pdflatex

# Target installation directory
INSTALL_DIR = /net/epics/Public/epics/base/R3-14/12-docs

# Source directories

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
EPS_SRCS += $(EPS_DIR)/scanning_1.eps
EPS_SRCS += $(EPS_DIR)/scanning_12.eps
EPS_SRCS += $(EPS_DIR)/scanning_19.eps
EPS_SRCS += $(EPS_DIR)/databaseStructures_1.eps

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

# Options for latex2html:
L2H_OPTS += -split +1
L2H_OPTS += -link 2
L2H_OPTS += -toc_depth 3
L2H_OPTS += -show_section_numbers
L2H_OPTS += -local_icons
L2H_OPTS += -info 0

# Build targets
TARGET_PDF  += AppDevGuide.pdf
TARGET_HTML += AppDevGuide/index.html
TARGETS = $(TARGET_PDF) $(TARGET_HTML)

# Installation targets
INSTALL_PDF  = $(addprefix $(INSTALL_DIR)/, $(TARGET_PDF))
INSTALL_HTML = $(addprefix $(INSTALL_DIR)/, $(TARGET_HTML))
INSTALL_TARGETS = $(INSTALL_PDF) $(INSTALL_HTML)

# Converted Diagrams
DIAGS_DIR = diags
DIAGS = $(patsubst $(EPS_DIR)/%.eps,$(DIAGS_DIR)/%.pdf,$(EPS_SRCS))

all: $(TARGETS)
pdf: $(TARGET_PDF)
html: $(TARGET_HTML)
install: $(INSTALL_TARGETS)

$(INSTALL_DIR)/%.pdf: %.pdf
	rsync -av $< $(INSTALL_DIR)

$(INSTALL_DIR)/%.html: %.html
	rsync -av $(<D) $(INSTALL_DIR)

AppDevGuide.pdf: $(TEX_SRCS) $(DIAGS)
	@rm -f pdflatex*.out
	pdflatex --interaction=nonstopmode $(basename $@) > pdflatex-1.out
	makeindex $(basename $@).idx
	pdflatex --interaction=nonstopmode $(basename $@) > pdflatex-2.out
	makeindex $(basename $@).idx
	pdflatex --interaction=nonstopmode $(basename $@) > pdflatex-3.out

AppDevGuide/index.html: $(TEX_SRCS) $(EPS_SRCS)
	@rm -f latex2html*.out
	latex2html $< $(L2H_OPTS) > latex2html.out
	@echo '.'

$(DIAGS_DIR)/%.pdf: $(EPS_DIR)/%.eps $(DIAGS_DIR)
	epstopdf $< -o=$@

$(DIAGS_DIR):
	mkdir -p $@

clean: cleanidx
	rm -rf AppDevGuide
	rm -rf $(DIAGS_DIR)

cleanidx:
	rm -f *.idx *.ind *.ilg *.log *.out *.pdf *.toc *.aux
	rm -f *.backup *~ tex/*.backup tex/*~

.PHONY: all pdf html install
.PHONY: clean cleanidx
