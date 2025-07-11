.DELETE_ON_ERROR:
.SECONDARY:
.PHONY: all

all: \
	dali-pcb.zip

dali-pcb.zip: $(wildcard dali-pcb-*)
	rm -f $@
	zip $@ $^
