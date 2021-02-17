# Makefile for the curliff tool

VERS = 0.1

# Use -g to compile the program for debugging.
DEBUG = -O2
#DEBUG = -g
CFLAGS = $(DEBUG) -Wall -Werror

OFILES = curliff.o

curliff: $(OFILES)
	$(CC) $(CFLAGS) -o curliff $(OFILES)

curliff.o:

install:
	cp curliff /usr/bin

uninstall:
	rm -f /usr/bin/curliff

.PHONY: clean
clean:
	rm -f $(OFILES) curliff
	rm -f curliff-*.tar.gz MANIFEST

SOURCES = COPYING Makefile NEWS README.adoc curliff.c

curliff-$(VERS).tar.gz: $(SOURCES)
	@ls $(SOURCES) | sed s:^:curliff-$(VERS)/: >MANIFEST
	@cd .. && ln -s curliff curliff-$(VERS)
	cd .. && tar -czf curliff/curliff-$(VERS).tar.gz `cat curliff/MANIFEST`
	@cd .. && rm curliff-$(VERS)

dist: curliff-$(VERS).tar.gz
