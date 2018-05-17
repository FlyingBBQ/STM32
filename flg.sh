#!/bin/sh

grep --include=\*.{c,h} -rnw . -e "$1"
