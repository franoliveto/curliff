# Makefile for the curliff program

# Use -g to compile the program for debugging.
DEBUG = -O2
#DEBUG = -g
CFLAGS = $(DEBUG) -Wall -Werror

LIBS =


OFILES = curliff.o

curliff: $(OFILES)
	$(CC) $(CFLAGS) -o curliff $(OFILES) $(LIBS)

curliff.o:


.PHONY: clean
clean:
	rm -f $(OFILES) curliff
