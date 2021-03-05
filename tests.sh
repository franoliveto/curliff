#!/usr/bin/env bash

PROG=$(pwd)/curliff

set -e

echo -e 'line 1\nline 2\nline 3' >lfout
echo -e 'line 1\r\nline 2\r\nline 3\r' >crlfout

$PROG crlfout >out1
if ! cmp -s lfout out1
then
    echo 'BAD: CRLF to LF test failed'
fi

$PROG -r lfout >out2
if ! cmp -s crlfout out2
then
    echo 'BAD: LF to CRLF test failed'
fi

rm lfout crlfout out1 out2
