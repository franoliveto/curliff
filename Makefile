# Makefile for the curliff tool

VERSION = 1.0

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

test: curliff
	./tests.sh

install: test
	cp curliff /usr/bin
	cp curliff.1 /usr/share/man/man1/curliff.1

uninstall:
	rm -f /usr/bin/curliff /usr/share/man/man1/curliff.1

.PHONY: clean
clean:
	rm -f $(OFILES) curliff
	rm -f curliff-*.tar.gz curliff.1

SOURCES = Makefile curliff.c tests.sh
DOCS = COPYING NEWS README.adoc curliff.adoc
ALL = $(DOCS) $(SOURCES)

curliff-$(VERSION).tar.gz: $(SOURCES)
	tar --transform='s:^:curliff-$(VERSION)/:' --show-transformed-names -cvzf curliff-$(VERSION).tar.gz $(ALL)

dist: curliff-$(VERSION).tar.gz
