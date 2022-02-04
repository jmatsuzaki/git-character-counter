#!/bin/bash

character-count () {
  git diff -p -b -w --cached --diff-filter=AM --ignore-cr-at-eol --ignore-space-at-eol --ignore-blank-lines --ignore-matching-lines="^(---|uid|title|aliases|date|update|tags|draft)" | grep ^+ | grep -v ^+++ | sed s/^+// | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | wc -m
}

character-count
