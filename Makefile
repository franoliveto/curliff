# Makefile for the curliff tool

VERS = 0.1

# Use -g to compile the program for debugging.
DEBUG = -O2
#DEBUG = -g
CFLAGS = $(DEBUG) -Wall -Werror

OFILES = curliff.o

all: curliff curliff.1

curliff: $(OFILES)
	$(CC) $(CFLAGS) -o curliff $(OFILES)

curliff.o:

curliff.1: curliff.adoc
	asciidoctor -b manpage $<

install:
	cp curliff /usr/bin
	cp curliff.1 /usr/share/man/man1/curliff.1

uninstall:
	rm -f /usr/bin/curliff /usr/share/man/man1/curliff.1

.PHONY: clean
clean:
	rm -f $(OFILES) curliff
	rm -f curliff-*.tar.gz curliff.1 MANIFEST

SOURCES = COPYING Makefile NEWS README.adoc curliff.c curliff.adoc

curliff-$(VERS).tar.gz: $(SOURCES)
	@ls $(SOURCES) | sed s:^:curliff-$(VERS)/: >MANIFEST
	@cd .. && ln -s curliff curliff-$(VERS)
	cd .. && tar -czf curliff/curliff-$(VERS).tar.gz `cat curliff/MANIFEST`
	@cd .. && rm curliff-$(VERS)

dist: curliff-$(VERS).tar.gz
