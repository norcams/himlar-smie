#!/usr/bin/env bash
set -o nounset
set -o errexit
#set -x

# where are we?
smie_dir="${BASH_SOURCE[0]%/*}"

project_file=
project_name=
project_version=

# autoload the project file?
do_autoload=0

# default is to not do anything
do_compile=0
do_validate=0
do_build=0

# Load util functions
source "${smie_dir}/functions.sh"

#
# Sets a global variable 'project' to the full path of the first file with a
# .json extension in the current directory
#
# Returns 0 on success, 1 if it fails
#
smie_autoload() {
  # Match json files in the given directory
  local files=("${PWD}"/*.json)

  case ${#files[*]} in
    1)
      # We found a single file, set 'project_file' to its path
      project_file="${files[0]}"
      return 0
      ;;
    0)
      echo "No project file found in current directory."
      return 1
      ;;
    *)
      echo "More than one project file found in current directory, specify which one to use."
      return 1
      ;;
  esac
}

#
smie_compile() {
  local data=$(mktemp /tmp/smie.compile.XXXXXXXX)
  local basedir="${project_file%/*}"

  echo debug: project_file=$project_file basedir=$basedir data=$data
  # load main project file
  load_project_file "${project_file}" "${data}"
  # get project metadata
  project_name=$(get_variable "project_name" "${data}")
  project_version=$(get_variable "project_version" "${data}")
  # load packer data if present in project
  if [[ -d "${basedir}/${project_name}/packer" ]]; then
    for file in "${basedir}/${project_name}"/packer/*.json; do
      load_project_file "${file}" "${data}"
    done
  fi

  # load 


  echo builders=$(get_variable "builders" "${data}")
}

