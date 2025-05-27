# At the beginning of the main tex file type:
#
# \providecommand\classopts{}
# \expandafter\documentclass\expandafter[\classopts]{<some_class>}
#
# instead of:
#
# \documentclass{<some_class>}

# Default shell. Compatible with bash only
SHELL = /bin/bash

# -------------------------------- File Names -------------------------------- #

# You can change this parameters if nessesary
# Name of main tex file
TEX_SOURCE = main
# Name of bibliography data base .bib
BIB_SOURCE = BibDB
# Name of produced pdf file in final mode
FINAL_FILE_NAME = $(TEX_SOURCE)
# Name of produced pdf file in monochrome mode
MONO_FILE_NAME = $(TEX_SOURCE)_mono
# Name of produced pdf file in build mode
BUILD_FILE_NAME = build
# Name of produced pdf file in fast build mode
FASTBUILD_FILE_NAME = fastbuild
# Name of produced pdf file in draft mode
DRAFT_FILE_NAME = draft
# Name of produced pdf file in fast drft mode
FASTDRAFT_FILE_NAME = fastdraft

# Name of directory for auxulary files (useful only for MiKTeX)
AUX_DIR = tmplatex

# --------------------------------- Settings --------------------------------- #

# Don't change the code below if you don't realize what it is!
# xelatex params for final file
FINALPARAM = -halt-on-error -file-line-error -interaction=nonstopmode \
-jobname=$(FINAL_FILE_NAME) "\def\classopts{final}\input{$(TEX_SOURCE).tex}"
# xelatex params for final file
MONOPARAM = -halt-on-error -file-line-error -interaction=nonstopmode \
-jobname=$(MONO_FILE_NAME) "\def\classopts{monochrome}\input{$(TEX_SOURCE).tex}"
# xelatex params for build file
BUILDPARAM = -halt-on-error -file-line-error -interaction=nonstopmode \
-jobname=$(BUILD_FILE_NAME) "\def\classopts{build}\input{$(TEX_SOURCE).tex}"
# xelatex params for fastbuild file
FASTBUILDPARAM = -halt-on-error -file-line-error -interaction=nonstopmode \
-jobname=$(FASTBUILD_FILE_NAME) "\def\classopts{build}\input{$(TEX_SOURCE).tex}"
# xelatex params for draft file
DRAFTPARAM = -halt-on-error -file-line-error -interaction=nonstopmode \
-jobname=$(DRAFT_FILE_NAME) "\def\classopts{draft}\input{$(TEX_SOURCE).tex}"
# xelatex params for fastdraft file
FASTDRAFTPARAM = -halt-on-error -file-line-error -interaction=nonstopmode \
-jobname=$(FASTDRAFT_FILE_NAME) "\def\classopts{draft}\input{$(TEX_SOURCE).tex}"

# grep params for parse xelatex errors
GREPPARAM_TEX = -m 1 -A 1 -E "[.]tex:[0-9]+:|^!|WARN|Package fontspec Error:"
# grep params for parse biber errors
GREPPARAM_BIBER_WARN = -E " WARN "
# grep params for parse biber warnings
GREPPARAM_BIBER_ERR = -E " ERROR "

# texlogsieve params
TEXLOGSIEVEPARAM = --only-summary --color --summary-detail --repetitions \
	--no-heartbeat
# --no-box-detail - if you want disable details about bad box warnings 

# Extentions of temp files
TEMP_FILES = *.aux *.bbl *.bcf *.blg *.log *.out *.run.xml *.toc *.xdv

TRASH = /dev/null

# Search for tex files in subfolders
SOURCE_FILES := $(wildcard */*.tex) $(wildcard */*/*.tex) \
$(wildcard */*/*/*.tex)

# ------------------------------ Major Targets ------------------------------- #

.PHONY: help fastdraft draft fastbuild build final monochrome cleanfinal \
cleanmono cleantmp clean cleanall
.SILENT: help fastdraft draft fastbuild build final monochrome cleanfinal \
cleanmono cleantmp clean cleanall

help: helpmsg

# Further commands have such structure:
# is MiKTeX ? 
# true\
# commands for MiKTeX
# false\
# commands for TeX Live
	
fastdraft: $(FASTDRAFT_FILE_NAME).pdf
	make -s $(FASTDRAFT_FILE_NAME).log
	printf "\e[1;31m"
	test -e $(AUX_DIR)/miktex && \
	\
	(grep $(GREPPARAM_TEX) $(AUX_DIR)/fastdraft/$(FASTDRAFT_FILE_NAME).log || \
	printf "\e[1;32m Fast draft file done! \e[0m") || \
	\
	(grep $(GREPPARAM_TEX) $(FASTDRAFT_FILE_NAME).log || \
	printf "\e[1;32m Fast draft file done! \e[0m")
	printf "\e[0m"

draft:  $(DRAFT_FILE_NAME).pdf
	make -s $(DRAFT_FILE_NAME).log 
	make -s $(DRAFT_FILE_NAME).blg
	printf "\e[1;31m"
	test -e $(AUX_DIR)/miktex && \
	\
	(grep $(GREPPARAM_TEX) $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(AUX_DIR)/draft/$(DRAFT_FILE_NAME).blg | cut -d ">" -f2; printf "\e[0m \n"\
	| grep $(GREPPARAM_TEX) $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) \
	$(AUX_DIR)/draft/$(DRAFT_FILE_NAME).log \
	&& printf "\e[1;32m Draft file done! \e[0m\n")))) || \
	\
	(grep $(GREPPARAM_TEX) $(DRAFT_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(DRAFT_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(DRAFT_FILE_NAME).blg | cut -d ">" -f2; printf "\e[0m \n"\
	| grep $(GREPPARAM_TEX) $(DRAFT_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) $(DRAFT_FILE_NAME).log \
	&& printf "\e[1;32m Draft file done! \e[0m\n"))))
	printf "\e[0m"

fastbuild: $(FASTBUILD_FILE_NAME).pdf
	make -s $(FASTBUILD_FILE_NAME).log
	printf "\e[1;31m"
	test -e $(AUX_DIR)/miktex && \
	\
	(grep $(GREPPARAM_TEX) $(AUX_DIR)/fastbuild/$(FASTBUILD_FILE_NAME).log || \
	printf "\e[1;32m Fast build file done! \e[0m") || \
	\
	(grep $(GREPPARAM_TEX) $(FASTBUILD_FILE_NAME).log || \
	printf "\e[1;32m Fast build file done! \e[0m")
	printf "\e[0m"


build: $(BUILD_FILE_NAME).pdf
	make -s $(BUILD_FILE_NAME).log 
	make -s $(BUILD_FILE_NAME).blg
	printf "\e[1;31m"
	test -e $(AUX_DIR)/miktex && \
	\
	(grep $(GREPPARAM_TEX) $(AUX_DIR)/build/$(BUILD_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(AUX_DIR)/build/$(BUILD_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(AUX_DIR)/build/$(BUILD_FILE_NAME).blg | \
	cut -d ">" -f2; printf "\e[0m \n"\ | \
	grep $(GREPPARAM_TEX) $(AUX_DIR)/build/$(BUILD_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) \
	$(AUX_DIR)/build/$(BUILD_FILE_NAME).log \
	&& printf "\e[1;32m Build file done! \e[0m\n")))) || \
	\
	(grep $(GREPPARAM_TEX) $(BUILD_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(BUILD_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(BUILD_FILE_NAME).blg | cut -d ">" -f2; printf "\e[0m \n"\ | \
	grep $(GREPPARAM_TEX) $(BUILD_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) $(BUILD_FILE_NAME).log \
	&& printf "\e[1;32m Build file done! \e[0m\n"))))
	printf "\e[0m"
 
final: cleanfinal $(FINAL_FILE_NAME).pdf
	make -s $(FINAL_FILE_NAME).log 
	make -s $(FINAL_FILE_NAME).blg
	printf "\e[1;31m"
	test -e $(AUX_DIR)/miktex && \
	\
	(grep $(GREPPARAM_TEX) $(AUX_DIR)/final/$(FINAL_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(AUX_DIR)/final/$(FINAL_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(AUX_DIR)/final/$(FINAL_FILE_NAME).blg | \
	cut -d ">" -f2; printf "\e[0m \n" | \
	grep $(GREPPARAM_TEX) $(AUX_DIR)/final/$(FINAL_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) \
	$(AUX_DIR)/final/$(FINAL_FILE_NAME).log \
	&& printf "\e[1;32m Final file done! \e[0m\n")))) || \
	\
	(grep $(GREPPARAM_TEX) $(FINAL_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(FINAL_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(FINAL_FILE_NAME).blg | cut -d ">" -f2; printf "\e[0m \n" | \
	grep $(GREPPARAM_TEX) $(FINAL_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) $(FINAL_FILE_NAME).log \
	&& printf "\e[1;32m Final file done! \e[0m\n"))))
	printf "\e[0m"

monochrome: cleanmono $(MONO_FILE_NAME).pdf
	make -s $(MONO_FILE_NAME).log 
	make -s $(MONO_FILE_NAME).blg
	printf "\e[1;31m"
	test -e $(AUX_DIR)/miktex && \
	\
	(grep $(GREPPARAM_TEX) $(AUX_DIR)/mono/$(MONO_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(AUX_DIR)/mono/$(MONO_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(AUX_DIR)/mono/$(MONO_FILE_NAME).blg | \
	cut -d ">" -f2; printf "\e[0m \n" | \
	grep $(GREPPARAM_TEX) $(AUX_DIR)/mono/$(MONO_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) \
	$(AUX_DIR)/mono/$(MONO_FILE_NAME).log \
	&& printf "\e[1;32m Monochrome file done! \e[0m\n")))) || \
	\
	(grep $(GREPPARAM_TEX) $(MONO_FILE_NAME).log || \
	(grep $(GREPPARAM_BIBER_ERR) $(MONO_FILE_NAME).blg || \
	(printf "\e[1;33m" && grep $(GREPPARAM_BIBER_WARN) \
	$(MONO_FILE_NAME).blg | cut -d ">" -f2; printf "\e[0m \n" | \
	grep $(GREPPARAM_TEX) $(MONO_FILE_NAME).log || \
	(printf "\e[0m" && texlogsieve $(TEXLOGSIEVEPARAM) $(MONO_FILE_NAME).log \
	&& printf "\e[1;32m Mono file done! \e[0m\n"))))
	printf "\e[0m"

cleanfinal: vertest
	test -e $(AUX_DIR)/miktex && \
	rm -rf $(AUX_DIR)/final || \
	\
	make -s cleantmp >$(TRASH)
	rm -f $(FINAL_FILE_NAME).pdf 
	printf "\e[1;32m Final file and aux files deleted! \e[0m\n"

cleanmono: vertest
	test -e $(AUX_DIR)/miktex && \
	rm -rf $(AUX_DIR)/mono || \
	\
	make -s cleantmp >$(TRASH)
	rm -f $(MONO_FILE_NAME).pdf 
	printf "\e[1;32m Monochrome file and aux files deleted! \e[0m\n"

cleantmp: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	rm -rf $(AUX_DIR) || \
	\
	(for tmpfile in $(TEMP_FILES) ; do \
			find . -name $${tmpfile} -type f -delete ;\
	done;\
	find . -name "auto" -type d -exec rm -r {} +;\
	for tmpfile in $(TEMP_FILES) ; do \
			find ./sourcefiles -name $${tmpfile} -type f -delete ;\
	done;\
	find . -name "auto" -type d -exec rm -r {} +)
	printf "\e[1;32m Tmp files deleted! \e[0m\n" 

clean: 
	make -s cleantmp >$(TRASH)
	rm -f $(BUILD_FILE_NAME).pdf
	rm -f $(FASTBUILD_FILE_NAME).pdf
	rm -f $(DRAFT_FILE_NAME).pdf
	rm -f $(FASTDRAFT_FILE_NAME).pdf
	printf "\e[1;32m Clean done! \e[0m\n"

cleanall:
	make -s cleanmono >$(TRASH)
	make -s cleanfinal >$(TRASH)
	make -s clean >$(TRASH)
	printf "\e[1;32m Cleanall done! \e[0m\n"

# ------------------ Service Targets for Files Compilation ------------------- #

.SILENT: $(FASTDRAFT_FILE_NAME).pdf $(DRAFT_FILE_NAME).pdf \
$(FASTBUILD_FILE_NAME).pdf $(BUILD_FILE_NAME).pdf $(FINAL_FILE_NAME).pdf \
$(MONO_FILE_NAME).pdf vertest

# Check LaTeX distributive
vertest:
	which xelatex &>$(TRASH) &&\
	(test -e $(AUX_DIR)/miktex || \
	(xelatex --version | grep -m 1 -E "MiKTeX" >$(TRASH) && \
	mkdir -p $(AUX_DIR) && touch $(AUX_DIR)/miktex || true)) || \
	printf "\e[1;31mNo xelatex in search PATH!\e[0m"
	which texlogsieve &>$(TRASH) || \
	printf "\e[1;31mNo texlogsieve in search PATH!\e[0m"

# Fast draft file compilation
$(FASTDRAFT_FILE_NAME).pdf: $(TEX_SOURCE).tex $(SOURCE_FILES)
	make -s vertest >$(TRASH)
	test -e $(AUX_DIR)/miktex && \
	\
	(xelatex -aux-directory=$(AUX_DIR)/fastdraft $(FASTDRAFTPARAM)>$(TRASH) \
	|| true) || \
	\
	(xelatex $(FASTDRAFTPARAM)>$(TRASH) || true)

# Draft file compilation
$(DRAFT_FILE_NAME).pdf: $(TEX_SOURCE).tex $(SOURCE_FILES)
	make -s vertest >$(TRASH)
	test -e $(AUX_DIR)/miktex && \
	\
	(xelatex --no-pdf -aux-directory=$(AUX_DIR)/draft $(DRAFTPARAM)>$(TRASH) &&\
	(test -s $(BIB_SOURCE).bib && \
	biber --output_directory=$(AUX_DIR)/draft $(DRAFT_FILE_NAME)>$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(AUX_DIR)/draft/$(DRAFT_FILE_NAME).blg) && \
	xelatex --no-pdf -aux-directory=$(AUX_DIR)/draft $(DRAFTPARAM)>$(TRASH) && \
	xelatex -aux-directory=$(AUX_DIR)/draft $(DRAFTPARAM)>$(TRASH) || true) || \
	\
	(xelatex --no-pdf $(DRAFTPARAM)>$(TRASH) && \
	(test -s $(BIB_SOURCE).bib && biber $(DRAFT_FILE_NAME)>$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(DRAFT_FILE_NAME).blg) && \
	xelatex --no-pdf $(DRAFTPARAM)>$(TRASH) && \
	xelatex $(DRAFTPARAM)>$(TRASH) || true)

# Fast build file compilation
$(FASTBUILD_FILE_NAME).pdf: $(TEX_SOURCE).tex $(SOURCE_FILES)
	make -s vertest >$(TRASH)
	test -e $(AUX_DIR)/miktex && \
	\
	(xelatex -aux-directory=$(AUX_DIR)/fastbuild $(FASTBUILDPARAM) \
	>$(TRASH) || true) || \
	\
	(xelatex $(FASTBUILDPARAM) >$(TRASH) || true)

# Build file compilation
$(BUILD_FILE_NAME).pdf: $(TEX_SOURCE).tex $(SOURCE_FILES)
	make -s vertest >$(TRASH)
	test -e $(AUX_DIR)/miktex && \
	\
	(xelatex --no-pdf -aux-directory=$(AUX_DIR)/build $(BUILDPARAM)>$(TRASH) &&\
	(test -s $(BIB_SOURCE).bib && \
	biber --output_directory=$(AUX_DIR)/build $(BUILD_FILE_NAME)>$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(AUX_DIR)/build/$(BUILD_FILE_NAME).blg) && \
	xelatex --no-pdf -aux-directory=$(AUX_DIR)/build $(BUILDPARAM)>$(TRASH) && \
	xelatex -aux-directory=$(AUX_DIR)/build $(BUILDPARAM)>$(TRASH) || true) || \
	\
	(xelatex --no-pdf $(BUILDPARAM)>$(TRASH) && \
	(test -s $(BIB_SOURCE).bib && biber $(BUILD_FILE_NAME)>$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(BUILD_FILE_NAME).blg) && \
	xelatex --no-pdf $(BUILDPARAM)>$(TRASH) && \
	xelatex $(BUILDPARAM)>$(TRASH) || true)

# Final file compilation
$(FINAL_FILE_NAME).pdf: $(TEX_SOURCE).tex $(SOURCE_FILES)
	make -s vertest >$(TRASH)
	test -e $(AUX_DIR)/miktex && \
	\
	(xelatex --no-pdf -aux-directory=$(AUX_DIR)/final $(FINALPARAM)>$(TRASH) &&\
	(test -s $(BIB_SOURCE).bib && \
	biber --output_directory=$(AUX_DIR)/final $(FINAL_FILE_NAME)>$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(AUX_DIR)/final/$(FINAL_FILE_NAME).blg) && \
	xelatex --no-pdf -aux-directory=$(AUX_DIR)/final $(FINALPARAM)>$(TRASH) && \
	xelatex -aux-directory=$(AUX_DIR)/final $(FINALPARAM)>$(TRASH) || true) || \
	\
	(xelatex --no-pdf $(FINALPARAM)>$(TRASH) && \
	(test -s $(BIB_SOURCE).bib && biber $(FINAL_FILE_NAME) >$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(FINAL_FILE_NAME).blg) && \
	xelatex --no-pdf $(FINALPARAM)>$(TRASH) && \
	xelatex $(FINALPARAM)>$(TRASH) || true)

# Monochrome file compilation
$(MONO_FILE_NAME).pdf: $(TEX_SOURCE).tex $(SOURCE_FILES)
	make -s vertest >$(TRASH)
	test -e $(AUX_DIR)/miktex && \
	\
	(xelatex --no-pdf -aux-directory=$(AUX_DIR)/mono $(MONOPARAM)>$(TRASH) &&\
	(test -s $(BIB_SOURCE).bib && \
	biber --output_directory=$(AUX_DIR)/mono $(MONO_FILE_NAME)>$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(AUX_DIR)/mono/$(MONO_FILE_NAME).blg) && \
	xelatex --no-pdf -aux-directory=$(AUX_DIR)/mono $(MONOPARAM)>$(TRASH) && \
	xelatex -aux-directory=$(AUX_DIR)/mono $(MONOPARAM)>$(TRASH) || true) || \
	\
	(xelatex --no-pdf $(MONOPARAM)>$(TRASH) && \
	(test -s $(BIB_SOURCE).bib && biber $(MONO_FILE_NAME) >$(TRASH) || \
	printf " WARN - File $(BIB_SOURCE).bib doesn't exist!" >> \
	$(MONO_FILE_NAME).blg) && \
	xelatex --no-pdf $(MONOPARAM)>$(TRASH) && \
	xelatex $(MONOPARAM)>$(TRASH) || true)

# ------------------ Service Targets for Log Files Creation ------------------ #

.SILENT: $(FASTDRAFT_FILE_NAME).log $(DRAFT_FILE_NAME).log \
$(DRAFT_FILE_NAME).blg $(FASTBUILD_FILE_NAME).log $(BUILD_FILE_NAME).log \
$(BUILD_FILE_NAME).blg $(FINAL_FILE_NAME).log $(FINAL_FILE_NAME).blg \
$(MONO_FILE_NAME).log $(MONO_FILE_NAME).blg

# Creation of fastdraft log file if it doesn't exist
$(FASTDRAFT_FILE_NAME).log: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/fastdraft/$(FASTDRAFT_FILE_NAME).log || \
	mkdir -p $(AUX_DIR)/fastdraft && \
	touch $(AUX_DIR)/fastdraft/$(FASTDRAFT_FILE_NAME).log) || \
	\
	(test -s $(FASTDRAFT_FILE_NAME).log || touch $(FASTDRAFT_FILE_NAME).log)

# Creation of draft log file if it doesn't exist
$(DRAFT_FILE_NAME).log: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).log || \
	mkdir -p $(AUX_DIR)/draft && \
	touch $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).log) || \
	\
	(test -s $(DRAFT_FILE_NAME).log || touch $(DRAFT_FILE_NAME).log)

# Creation of draft bib log file if it doesn't exist
$(DRAFT_FILE_NAME).blg: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).blg || \
	mkdir -p $(AUX_DIR)/draft && \
	touch $(AUX_DIR)/draft/$(DRAFT_FILE_NAME).blg) || \
	\
	(test -s $(DRAFT_FILE_NAME).blg || touch $(DRAFT_FILE_NAME).blg)

# Creation of fast build log file if it doesn't exist
$(FASTBUILD_FILE_NAME).log: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/fastbuild/$(FASTBUILD_FILE_NAME).log || \
	mkdir -p $(AUX_DIR)/fastbuild && \
	touch $(AUX_DIR)/fastbuild/$(FASTBUILD_FILE_NAME).log) || \
	\
	(test -s $(FASTBUILD_FILE_NAME).log || touch $(FASTBUILD_FILE_NAME).log)

# Creation of build log file if it doesn't exist
$(BUILD_FILE_NAME).log: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/build/$(BUILD_FILE_NAME).log || \
	mkdir -p $(AUX_DIR)/build && \
	touch $(AUX_DIR)/build/$(BUILD_FILE_NAME).log) || \
	\
	(test -s $(BUILD_FILE_NAME).log || touch $(BUILD_FILE_NAME).log)

# Creation of build bib log file if it doesn't exist
$(BUILD_FILE_NAME).blg: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/build/$(BUILD_FILE_NAME).blg || \
	mkdir -p $(AUX_DIR)/build && \
	touch $(AUX_DIR)/build/$(BUILD_FILE_NAME).blg) || \
	\
	(test -s $(BUILD_FILE_NAME).blg || touch $(BUILD_FILE_NAME).blg)

# Creation of final log file if it doesn't exist
$(FINAL_FILE_NAME).log: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/final/$(FINAL_FILE_NAME).log || \
	mkdir -p $(AUX_DIR)/final && \
	touch $(AUX_DIR)/final/$(FINAL_FILE_NAME).log) || \
	\
	(test -s $(FINAL_FILE_NAME).log || touch $(FINAL_FILE_NAME).log)

# Creation of bib log file if it doesn't exist
$(FINAL_FILE_NAME).blg: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/final/$(FINAL_FILE_NAME).blg || \
	mkdir -p $(AUX_DIR)/final && \
	touch $(AUX_DIR)/final/$(FINAL_FILE_NAME).blg) || \
	\
	(test -s $(FINAL_FILE_NAME).blg || touch $(FINAL_FILE_NAME).blg)

# Creation of monochrome log file if it doesn't exist
$(MONO_FILE_NAME).log: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/mono/$(MONO_FILE_NAME).log || \
	mkdir -p $(AUX_DIR)/mono && \
	touch $(AUX_DIR)/mono/$(MONO_FILE_NAME).log) || \
	\
	(test -s $(MONO_FILE_NAME).log || touch $(MONO_FILE_NAME).log)

# Creation of bib log file if it doesn't exist
$(MONO_FILE_NAME).blg: vertest
	test -e $(AUX_DIR)/miktex && \
	\
	(test -s $(AUX_DIR)/mono/$(MONO_FILE_NAME).blg || \
	mkdir -p $(AUX_DIR)/mono && \
	touch $(AUX_DIR)/mono/$(MONO_FILE_NAME).blg) || \
	\
	(test -s $(MONO_FILE_NAME).blg || touch $(MONO_FILE_NAME).blg)

# ---------------------------- Help Message Body ----------------------------- #

.SILENT: helpmsg 

helpmsg:
	printf "\e[1;97mSYNOPSIS\n\
	\tmake\e[0m [command]\n\
	\n\
	\e[1;97mCOMMANDS\e[0m\n\
	\tThis version of Makefile understands the following commands.\n\
	\n\
	\t\e[1;97mbuild\e[0m\tFull compilation of \e[4m$(TEX_SOURCE).tex\e[0m in \
	build mode. It may take a long\n\
	\t\ttime.\n\
	\n\
	\t\e[1;97mclean\e[0m\tDelete all xelatex temporary files (including \
	\e[4maux\e[0m and \e[4mlog\e[0m files)\n\
	\t\tand produced \e[4mpdf\e[0m files excluding \
	\e[4m$(FINAL_FILE_NAME).pdf\e[0m.\n\
	\n\
	\t\e[1;97mcleanall\e[0m\n\
	\t\tDelete all xelatex temporary and produced \e[4mpdf\e[0m files.\n\
	\n\
	\t\e[1;97mcleanfinal\e[0m\n\
	\t\tDelete xelatex temporary files for final target and produced\n\
	\t\t\e[4m$(FINAL_FILE_NAME).pdf\e[0m file.\n\
	\n\
	\t\e[1;97mcleantmp\e[0m\n\
	\t\tDelete all xelatex temporary files.\n\
	\n\
	\t\e[1;97mdraft\e[0m\tFull compilation of \e[4m$(TEX_SOURCE).tex\e[0m in\
	 draft mode (the fastmode).\n\
	\n\
	\t\e[1;97mfastbuild\e[0m\n\
	\t\tOne time compilation of \e[4m$(TEX_SOURCE).tex\e[0m in build mode.\n\
	\n\
	\t\e[1;97mfastdraft\e[0m\n\
	\t\tOne time compilation of \e[4m$(TEX_SOURCE).tex\e[0m in draft mode \
	(the fastest\n\
	\t\tmode).\n\
	\n\
	\t\e[1;97mfinal\e[0m\tFull compilation of \e[4m$(TEX_SOURCE).tex\e[0m in\
	 final mode. It may take a long\n\
	\t\ttime.\n\
	\n\
	\t\e[1;97mhelp\e[0m\tPrint this help message. Also can be printed with \
	single command\n\
	\t\t\e[1;97mmake\e[0m without any arguments.\n\
	\n\
	\t\e[1;97mmonochrome\e[0m\n\
	\t\tFull compilation of \e[4m$(TEX_SOURCE).tex\e[0m in monochrome mode. It may take a\n\
	\t\tlong time.\n\
	\n\
	\e[1;97mFILES\e[0m\n\
	\tNow given commands produce the following files:\n\
	\n\
	\t\t\e[1;97mfastdraft\e[0m:\t\e[4m$(TEX_SOURCE).tex\e[0m\t -->  \
	\e[4m$(FASTDRAFT_FILE_NAME).pdf\e[0m\n\
	\t\t\e[1;97mdraft\e[0m:\t\t\e[4m$(TEX_SOURCE).tex\e[0m\t -->  \
	\e[4m$(DRAFT_FILE_NAME).pdf\e[0m\n\
	\t\t\e[1;97mfastbuild\e[0m:\t\e[4m$(TEX_SOURCE).tex\e[0m\t -->  \
	\e[4m$(FASTBUILD_FILE_NAME).pdf\e[0m\n\
	\t\t\e[1;97mbuild\e[0m:\t\t\e[4m$(TEX_SOURCE).tex\e[0m\t -->  \
	\e[4m$(BUILD_FILE_NAME).pdf\e[0m\n\
	\t\t\e[1;97mfinal\e[0m:\t\t\e[4m$(TEX_SOURCE).tex\e[0m\t -->  \
	\e[4m$(FINAL_FILE_NAME).pdf\e[0m\n\
	\t\t\e[1;97mmonochrome\e[0m:\t\e[4m$(TEX_SOURCE).tex\e[0m\t -->  \
	\e[4m$(MONO_FILE_NAME).pdf\e[0m\n\
	\n\
	\tYou can change it in \e[4mMakefile\e[0m if necessary.\n\
	\n\
	\e[1;97mREQUIREMENTS\e[0m\n\
	\t\e[4mMakefile\e[0m compatible with \e[1;97mMiKTeX\e[0m and \
	\e[1;97mTeX Live\e[0m.\n\
	\tCorrect operation is guaranteed if installed:\n\
	\n\
	\t\tcut\n\
	\t\tgrep\n\
	\t\tmake\n\
	\t\tmkdir\n\
	\t\tprintf\n\
	\t\trm\n\
	\t\ttest\n\
	\t\ttexlogseive (LaTeX package)\n\
	\t\ttouch\n\
	\t\txelatex\n\
	\n\
	30 September 2024\n"