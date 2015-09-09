#!/usr/bin/env bash

#
# Prints usage information for smie.
#
function usage()
{
  cat <<USAGE
usage: smie <command>

Available commands:
    compile    Pre-processes the current project JSON data
    validate   Validates the current project
    build      Builds the current project
USAGE
}

#
# Parses command-line options.
#
function parse_options()
{
  local argv=()

  if [[ $# -gt 0 ]]; then
    case $1 in
      compile)
        do_compile=1
        shift 1
        ;;
      validate)
        do_validate=1
        shift 1
        ;;
      build)
        do_build=1
        shift 1
        ;;
      help|--help|-h)
        usage
        exit
        ;;
      *)
        echo "${0##*/}: unrecognized command option $1" >&2
        return 1
        ;;
    esac
  else
    usage
    exit
  fi

  while [[ $# -gt 0 ]]; do
    case $1 in
      --)
        shift
        configure_opts=("$@")
        break
        ;;
      -*)
        echo "${0##*/}: unrecognized option $1" >&2
        return 1
        ;;
      *)
        argv+=($1)
        shift
        ;;
    esac
  done

  case ${#argv[*]} in
    1)
      project_json="${argv[0]}"
      return 0
      ;;
    0)
      # Command parsed OK, return success
      do_autoload=1
      return 0
      ;;
    *)
      echo "${0##*/}: too many arguments: ${argv[*]}" >&2
      usage 1>&2
      return 1
      ;;
  esac
}

