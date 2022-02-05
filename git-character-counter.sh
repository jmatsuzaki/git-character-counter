#!/bin/bash

### Definition
fm="^(---|uid|title|aliases|date|update|tags|draft)" #Ignore Front Matter
wcOpt="-m"
target="--cached"

### Create help (-h | --help)
function usage {
  cat <<EOM
Description:
  This is a shell script to count the number of additional characters from the git diff results

Usage:
  $(basename "$0") [OPTION]...

Options:
  -h          Display this help
  -w          Count words instead of characters
  -L          Target the last commit instead of the staging file
EOM

  exit 1
}

### Process definition by argument
while getopts ":wLh" optKey; do
  case "$optKey" in
    w)
      wcOpt="-w"
      ;;
    L)
      target="HEAD^"
      ;;
    h)
      usage
      ;;
    *)
      echo "[ERROR] Undefined options."
      echo "  Please check the Usage"
      echo ""
      usage
      ;;
  esac
done

### Function of count characters of words
character-count () {
  git diff -p -b -w $target --diff-filter=AM --ignore-cr-at-eol --ignore-space-at-eol --ignore-blank-lines --ignore-matching-lines=$fm | grep ^+ | grep -v ^+++ | sed s/^+// | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | wc $wcOpt
}

### Main
characterCount=`character-count`
echo $characterCount
