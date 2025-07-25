# Render PCB as SVG
#
# Dependencies:
# - https://github.com/INTI-CMNB/KiBot
# - https://www.gnu.org/software/m4/
# - https://www.gnu.org/software/sed/

.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: all

all: \
	render/DALI-sch.svg \
	render/IO-sch.svg \
	render/Microcontroller-sch.svg \
	render/Power-sch.svg \
	render/Root-sch.svg \
	render/DALI-pcb.svg

build/dali-pcb-DALI.svg: dali.kicad_sch
build/dali-pcb-IO.svg: io.kicad_sch
build/dali-pcb-Microcontoller.svg: microcontroller.kicad_sch
build/dali-pcb-Power.svg: power.kicad_sch

render/DALI-sch.svg: build/dali-pcb-DALI.svg Makefile
	sed \
		-e 's:<title>[^<]*</title>::' \
		< $< > $@

render/IO-sch.svg: build/dali-pcb-IO.svg Makefile
	sed \
		-e 's:<title>[^<]*</title>::' \
		< $< > $@

render/Microcontroller-sch.svg: build/dali-pcb-Microcontroller.svg Makefile
	sed \
		-e 's:<title>[^<]*</title>::' \
		< $< > $@

render/Power-sch.svg: build/dali-pcb-Power.svg Makefile
	sed \
		-e 's:<title>[^<]*</title>::' \
		< $< > $@

render/Root-sch.svg: build/dali-pcb-schematic.svg Makefile
	sed \
		-e 's:<title>[^<]*</title>::' \
		< $< > $@

render/DALI-pcb.svg: dali-pcb.svg.in build/dali-pcb-top.bare-svg build/dali-pcb-bottom.bare-svg Makefile
	m4 < $< > $@

build/%-top.svg build/%-bottom.svg build/%-schematic.svg build/%-DALI.svg build/%-IO.svg build/%-Microcontroller.svg build/%-Power.svg: %.kicad_sch %.kicad_pcb default.kibot.yaml
	kibot -e $< -b $(word 2,$^)

build/%-top.rewrite-id-svg: build/%-top.svg Makefile
	sed -e 's: id=": id="t-:g' -e 's:url(#:url(#t-:g' < $< > $@

build/%-bottom.rewrite-id-svg: build/%-bottom.svg Makefile
	sed -e 's: id=": id="b-:g' -e 's:url(#:url(#b-:g' < $< > $@

build/%.bare-svg: build/%.rewrite-id-svg Makefile
	sed \
		-e 's:<!DOCTYPE [^>]\+>::' \
		-e 's:<svg \([^>]*\) width="[^"]*"\([^>]*\)>:<svg \1\2>:' \
		-e 's:<svg \([^>]*\) height="[^"]*"\([^>]*\)>:<svg \1\2>:' \
		-e 's:<title>[^<]*</title>::' \
		-e 's:<svg ::' \
		< $< > $@
