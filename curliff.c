/*
 * curliff.c -- remove spurious carriage returns from a file.
 *
 * Copyright (c) 2020, Francisco Oliveto <franciscoliveto@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>

#include <sys/stat.h>
#include <sys/types.h>


int main(int argc, char *argv[])
{
    int opt;
    int c, c_prev;
    struct stat st;
    FILE *fpin, *fpout;
    int ret = EXIT_FAILURE;
    bool revert = false;
    char *filename;
    
    while ((opt = getopt(argc, argv, "r")) != -1) {
        switch (opt) {
        case 'r':
            revert = true;
            break;
        default: /* '?' */
            fprintf(stderr, "Usage: %s [-r] file\n", argv[0]);
            exit(EXIT_FAILURE);
        }
    }

    if (argc == optind) {
        fprintf(stderr, "A file is required.\n");
        exit(EXIT_FAILURE);
    }

    filename = argv[optind];

    if (stat(filename, &st) || !S_ISREG(st.st_mode)) {
        fprintf(stderr, "%s is a directory or special file.\n", filename);
        exit(EXIT_FAILURE);
    }
    
    errno = 0;
    if ((fpin = fopen(filename, "r")) == NULL)
        fprintf(stderr, "Can't open file '%s': %s.\n", filename, strerror(errno));
    else if ((fpout = fopen(".tmp", "w")) == NULL) {
        fprintf(stderr, "Can't open temporary file: %s.\n", strerror(errno));
        fclose(fpin);
    } else {
        if (revert) {
            /* Revert the convertion. Go from LF to CRLF */
            c_prev = ' ';
            while ((c = getc(fpin)) != EOF) {
                if (c_prev != '\r' && c == '\n')
                    putc('\r', fpout);
                putc(c, fpout);
                c_prev = c;
            }
        } else {
            /* Go from CRLF to LF */
            while ((c = getc(fpin)) != EOF)
                if (c != '\r')
                    putc(c, fpout);
        }

        fclose(fpin);
        errno = 0;
        if (fclose(fpout) == EOF) {
            fprintf(stderr, "Error: %s\n", strerror(errno));
            remove(".tmp");
        } else {
            rename(".tmp", filename);
            ret = EXIT_SUCCESS;
        }
    }
    
    return ret;
}
