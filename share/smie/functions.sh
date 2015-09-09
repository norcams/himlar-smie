#!/usr/bin/env bash

#
# Prints a log message.
#
function log()
{
  if [[ -t 1 ]]; then
    echo -e "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m$1\x1b[0m"
  else
    echo ">>> $1"
  fi
}

#
# Prints a warn message.
#
function warn()
{
  if [[ -t 1 ]]; then
    echo -e "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m$1\x1b[0m" >&2
  else
    echo "*** $1" >&2
  fi
}

#
# Prints an error message.
#
function error()
{
  if [[ -t 1 ]]; then
    echo -e "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m$1\x1b[0m" >&2
  else
    echo "!!! $1" >&2
  fi
}

#
# Prints an error message and exists with -1.
#
function fail()
{
  error "$@"
  exit -1
}

#
# Verifies and concatenates project files
#
# $1 - input file
# $2 - output file
#
load_project_file() {
  local input="${1}"
  local output="${2}"
  local tmp=$(mktemp /tmp/smie.load_project_file.XXXXXXXX)

  # Test if the input file is readable
  jq . "${input}" >/dev/null || fail "Error reading ${input}"

  # Merge it to the project
  jq -s 'def flatten: reduce .[] as $i([]; if $i | type == "array" then . + ($i | flatten) else . + [$i] end); [.[] | to_entries] | flatten | reduce .[] as $dot ({}; .[$dot.key] += $dot.value)' \
    "${input}" "${output}" > "${tmp}" || fail "Could not merge ${input} with ${output}"
  # Rewrite the output file with its new content
  mv -f "${tmp}" "${output}"
}

get_variable() {
  local var="${1}"
  local input="${2}"
  jq --raw-output '.variables | .'"${var}"'' "${input}"
}

