#!/bin/bash

echo ""
echo "================================================="
echo "Welcome to git character counter"
echo "================================================="
echo ""

### Definition
fm="^(---|uid|title|aliases|date|update|tags|draft)" # Ignore Front Matter
wcOpt="-m" # wc option
countUnit="Characters"
from="@" # HEAD
to="--cached" # Staging files

### Create help (-h | --help)
function usage {
  cat <<EOM
Description:
  This is a shell script to count the number of additional characters from the git diff results

Usage:
  $(basename "$0") [OPTION]...

Options:
  -f  [n|char|date]   Startpoint for comparison. n times before or hash (40|7 digit) or by date (date expression or ISO date). Default is HEAD.
  -t  [n|char|date]   Endpoint point for comparison. The format is the same as -f. Default is Staging.
  -w                  Count words instead of characters
  -h                  Display this help

Documentation can be found at https://github.com/jmatsuzaki/git-character-counter
EOM

  exit 1
}

### Process definition by argument
while getopts ":f:t:wh" optKey; do
  case "$optKey" in
    f)
      # hash checking
      if expr "$OPTARG" : "[a-f0-9]\{40\}$" >&/dev/null || expr "$OPTARG" : "[a-f0-9]\{7\}$" >&/dev/null; then
        from="${OPTARG}"
      # numeric checking
      elif expr "$OPTARG" : "[0-9]*$" >&/dev/null; then
        from="@~${OPTARG}"
      # date
      else
        from="@{${OPTARG}}"
      fi
      ;;
    t)
      # hash checking
      if expr "$OPTARG" : "[a-f0-9]\{40\}$" >&/dev/null || expr "$OPTARG" : "[a-f0-9]\{7\}$" >&/dev/null; then
        to="${OPTARG}"
      # numeric checking
      elif expr "$OPTARG" : "[0-9]*$" >&/dev/null; then
        to="@~${OPTARG}"
      # date
      else
        to="@{${OPTARG}}"
      fi
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

### Function of target files list
get-character-count-target () {
  git diff -p --name-status --diff-filter=AM "$from" "$to"
}

### Function of count characters
character-count () {
  git diff -p -b -w -U0 --diff-filter=AM --ignore-cr-at-eol --ignore-space-at-eol --ignore-blank-lines --ignore-matching-lines=$fm "$from" "$to" | grep ^+ | grep -v ^+++ | sed s/^+// | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | wc $wcOpt
}

### Main
echo "Target commits are as follows:"
echo "From:$from..To:$to"
echo ""
echo "The target files are as follows:"
countTarget=`get-character-count-target`
echo "$countTarget"
echo ""
echo "The number of $countUnit added is as follows:"
characterCount=`character-count`
echo "Total: $characterCount"
echo ""
