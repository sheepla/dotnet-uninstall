SHELL := bash
SH_SOURCES := $(wildcard *.sh)

all: fmt lint

fmt:
	shfmt -i 4 -ci -sr -w $(SH_SOURCES)

lint:
	shellcheck -s $(SHELL) $(SH_SOURCES)


