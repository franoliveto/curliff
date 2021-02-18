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


void curliff(FILE *fp, bool reverse)
{
    int c;

    while ((c = getc(fp)) != EOF) {
        if (reverse && c == '\n') {
            putchar('\r');
            putchar('\n');
            continue;
        } else if (c == '\r')
            continue;
        putchar(c);
    }
}

int main(int argc, char *argv[])
{
    int opt;
    struct stat st;
    FILE *fp;
    bool reverse = false; /* by default, strip carriage returns */
    
    while ((opt = getopt(argc, argv, "r")) != -1) {
        switch (opt) {
        case 'r':
            reverse = true;
            break;
        default:
            fprintf(stderr, "Usage: %s [-r] file(s)\n", argv[0]);
            exit(EXIT_FAILURE);
        }
    }

    if (argc == optind)
        curliff(stdin, reverse);
    else {
        for (; optind < argc; optind++) {
            errno = 0;
            if (stat(argv[optind], &st) == -1)
                fprintf(stderr, "error: %s\n", strerror(errno));
            else if (!S_ISREG(st.st_mode))
                fprintf(stderr, "%s is a directory or special file.\n",
                        argv[optind]);
            else if ((fp = fopen(argv[optind], "r")) == NULL)
                fprintf(stderr, "Can't open file '%s': %s.\n",
                        argv[optind], strerror(errno));
            else {
                curliff(fp, reverse);
                fclose(fp);
            }
        }
    }
    return EXIT_SUCCESS;
}
