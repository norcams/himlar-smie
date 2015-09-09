#!/bin/bash -eu
#
# Source scripts in a "waterfall"-based fashion
# The following environment variables are set by packer:
#
#   OS_NAME
#   OS_VERSION
#   PACKER_BUILDER_TYPE
#   PROJECT_NAME
#   PROJECT_VERSION
#   TAG
#
# The current configuration would run scripts in this example order:
#
#   pre-centos-7-virtualbox-iso.sh
#   pre-centos-7.sh
#   pre-centos-virtualbox-iso.sh
#   pre-centos.sh
#   pre-virtualbox-iso.sh
#   pre.sh
#
if [[ -d "/tmp/${PROJECT_NAME}/bin" ]]; then
  BINDIR="/tmp/${PROJECT_NAME}/bin"
else
  BINDIR="../../${PROJECT_NAME}/bin"
fi

include() {
  if [[ -s "$1" ]]; then
    echo "Running ${1}"
    # Enable traces for the sourced scripts
    set -x
    source "$1"
    set +x
  fi
}

include "${BINDIR}/${TAG}-${OS_NAME}-${OS_VERSION}-${PACKER_BUILDER_TYPE}.sh"
include "${BINDIR}/${TAG}-${OS_NAME}-${OS_VERSION}.sh"
include "${BINDIR}/${TAG}-${OS_NAME}-${PACKER_BUILDER_TYPE}.sh"
include "${BINDIR}/${TAG}-${OS_NAME}.sh"
include "${BINDIR}/${TAG}-${PACKER_BUILDER_TYPE}.sh"
include "${BINDIR}/${TAG}.sh"

# Exit successfully at this point
exit 0

