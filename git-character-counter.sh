#!/bin/bash

### Definition
fm="^(---|uid|title|aliases|date|update|tags|draft)" #Ignore Front Matter
wcOpt="-m"
countUnit="Characters"
from="@"
to="--cached"

### Create help (-h | --help)
function usage {
  cat <<EOM
Description:
  This is a shell script to count the number of additional characters from the git diff results

Usage:
  $(basename "$0") [OPTION]...

Options:
  -f  [VALUE]   Starting point for comparison. [N] times before or by [DATE]. Default is HEAD.
  -t  [VALUE]   Endpoint point for comparison. [N] times before or by [DATE]. Default is Staging.
  -w            Count words instead of characters
  -h            Display this help
EOM

  exit 1
}

### Process definition by argument
while getopts ":f:t:wh" optKey; do
  case "$optKey" in
    f)
      # numeric checking
      if expr "$OPTARG" : "[0-9]*$" >&/dev/null; then
        from="@~${OPTARG}"
      else
        from="@{${OPTARG}}"
      fi
      echo "from: $from"
      ;;
    t)
      # numeric checking
      if expr "$OPTARG" : "[0-9]*$" >&/dev/null; then
        to="@~${OPTARG}"
      else
        to="@{${OPTARG}}"
      fi
      echo "to: $to"
      ;;
    w)
      wcOpt="-w"
      countUnit="Words"
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
  git diff -p -b -w "$to" "$from" --diff-filter=AM --ignore-cr-at-eol --ignore-space-at-eol --ignore-blank-lines --ignore-matching-lines=$fm | grep ^+ | grep -v ^+++ | sed s/^+// | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | wc $wcOpt
}

### Main
echo ""
echo "================================================="
echo "Welcome to git diff character counter"
echo "================================================="
echo ""
echo "The target files are as follows:"
echo `git diff -p -b -w --name-status "$to" "$from" --diff-filter=AM`
echo ""
echo "The number of $countUnit added is as follows:"
characterCount=`character-count`
echo "Total: $characterCount"
echo ""
