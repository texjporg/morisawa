STRIPTARGET = morisawa.sty
DOCTARGET = morisawa
PDFTARGET = $(addsuffix .pdf,$(DOCTARGET))
DVITARGET = $(addsuffix .dvi,$(DOCTARGET))
KANJI = -kanji=utf8
FONTMAP = -f ipaex.map -f ptex-ipaex.map
TEXMF = $(shell kpsewhich -var-value=TEXMFHOME)

default: $(STRIPTARGET) $(DVITARGET)
strip: $(STRIPTARGET)
all: $(STRIPTARGET) $(PDFTARGET)

# `make fonts' will fail due to lack of kpathsea of sources,
# but shown here for information purpose.
# if you want to make these, put sources in the current dir.
fonts:
	for fnt in Ryumin-Light FutoMinA101-Bold ; do \
		cp min10.tfm $$fnt-H.tfm ; \
		cp tmin10.tfm $$fnt-V.tfm ; \
		cp jis.tfm $$fnt-J.tfm ; \
	done
	for fnt in GothicBBB-Medium FutoGoB101-Bold Jun101-Light ; do \
		cp goth10.tfm $$fnt-H.tfm ; \
		cp tgoth10.tfm $$fnt-V.tfm ; \
		cp jisg.tfm $$fnt-J.tfm ; \
	done
	for VAR in J H ; do \
		makejvf Ryumin-Light-$$VAR ryumin-l ; \
		makejvf FutoMinA101-Bold-$$VAR futomin-b ; \
		makejvf GothicBBB-Medium-$$VAR gtbbb-m ; \
		makejvf FutoGoB101-Bold-$$VAR futogo-b ; \
		makejvf Jun101-Light-$$VAR jun101-l ; \
	done
	for VAR in V ; do \
		makejvf Ryumin-Light-$$VAR ryumin-l-v ; \
		makejvf FutoMinA101-Bold-$$VAR futomin-b-v ; \
		makejvf GothicBBB-Medium-$$VAR gtbbb-m-v ; \
		makejvf FutoGoB101-Bold-$$VAR futogo-b-v ; \
		makejvf Jun101-Light-$$VAR jun101-l-v ; \
	done
	rm -f min10.tfm tmin10.tfm jis.tfm
	rm -f goth10.tfm tgoth10.tfm jisg.tfm
	mv *.tfm tfm/
	mv *.vf vf/

# for generating files, we use pdflatex incidentally.
# current packages contain ASCII characters only, safe enough
morisawa.sty: morisawa.dtx
	rm -f morisawa
	pdflatex morisawa.ins
	rm morisawa.log

.SUFFIXES: .dtx .dvi .pdf
.dtx.dvi:
	platex $(KANJI) $<
	platex $(KANJI) $<
	rm -f *.aux *.log *.toc
.dvi.pdf:
	dvipdfmx $(FONTMAP) $<

.PHONY: install clean cleanstrip cleanall cleandoc
install:
	mkdir -p ${TEXMF}/doc/platex/morisawa
	cp ./LICENSE ${TEXMF}/doc/platex/morisawa/
	cp ./README.md ${TEXMF}/doc/platex/morisawa/
	cp ./*.pdf ${TEXMF}/doc/platex/morisawa/
	mkdir -p ${TEXMF}/fonts/map/dvipdfmx/morisawa/
	cp ./map/* ${TEXMF}/fonts/map/dvipdfmx/morisawa/
	mkdir -p ${TEXMF}/fonts/tfm/public/morisawa
	cp ./tfm/futo* ${TEXMF}/fonts/tfm/public/morisawa/
	cp ./tfm/gtb* ${TEXMF}/fonts/tfm/public/morisawa/
	cp ./tfm/jun* ${TEXMF}/fonts/tfm/public/morisawa/
	cp ./tfm/ryumin* ${TEXMF}/fonts/tfm/public/morisawa/
	mkdir -p ${TEXMF}/fonts/tfm/public/morisawa
	cp ./tfm/Futo* ${TEXMF}/fonts/tfm/public/morisawa/
	cp ./tfm/Gothic* ${TEXMF}/fonts/tfm/public/morisawa/
	cp ./tfm/Jun* ${TEXMF}/fonts/tfm/public/morisawa/
	cp ./tfm/Ryumin* ${TEXMF}/fonts/tfm/public/morisawa/
	mkdir -p ${TEXMF}/fonts/vf/public/morisawa
	cp ./vf/Futo* ${TEXMF}/fonts/vf/public/morisawa/
	cp ./vf/Gothic* ${TEXMF}/fonts/vf/public/morisawa/
	cp ./vf/Jun* ${TEXMF}/fonts/vf/public/morisawa/
	cp ./vf/Ryumin* ${TEXMF}/fonts/vf/public/morisawa/
	mkdir -p ${TEXMF}/source/platex/morisawa
	cp ./Makefile ${TEXMF}/source/platex/morisawa/
	cp ./*.dtx ${TEXMF}/source/platex/morisawa/
	cp ./*.ins ${TEXMF}/source/platex/morisawa/
	mkdir -p ${TEXMF}/tex/platex/morisawa
	cp ./*.sty ${TEXMF}/tex/platex/morisawa/
clean:
	rm -f $(STRIPTARGET) $(DVITARGET)
cleanstrip:
	rm -f $(STRIPTARGET)
cleanall:
	rm -f $(STRIPTARGET) $(DVITARGET) $(PDFTARGET)
cleandoc:
	rm -f $(DVITARGET) $(PDFTARGET)
