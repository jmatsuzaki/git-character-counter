#!/bin/bash

# Create help (-h | --help)
function usage {
  cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h          Display help
  -a VALUE    A explanation for arg called a
  -b VALUE    A explanation for arg called b
  -c VALUE    A explanation for arg called c
  -d VALUE    A explanation for arg called d
EOM

  exit 2
}

# 引数別の処理定義
while getopts ":a:b:c:d:h" optKey; do
  case "$optKey" in
    a)
      echo "-a = ${OPTARG}"
      ;;
    b)
      echo "-b = ${OPTARG}"
      ;;
    c)
      echo "-c = ${OPTARG}"
      ;;
    d)
      echo "-d = ${OPTARG}"
      ;;
    '-h'|'--help'|* )
      usage
      ;;
  esac
done

# Function of count characters of words
character-count () {
  git diff -p -b -w --cached --diff-filter=AM --ignore-cr-at-eol --ignore-space-at-eol --ignore-blank-lines --ignore-matching-lines="^(---|uid|title|aliases|date|update|tags|draft)" | grep ^+ | grep -v ^+++ | sed s/^+// | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | wc -m
}

# Total number of additional characters for files in the working tree
characterCount=`character-count`
echo $characterCount
