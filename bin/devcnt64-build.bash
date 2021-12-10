#!/bin/bash
#######################################
# Build containers in dev environment
#
# Author: X_AUTHOR_ALIAS_X (X_AUTHOR_GIT_URL_X)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: X_PROJECT_GIT_URL_X
# Version: X_APP_VERSION_X
#######################################

source './.env' || exit 1
source "${DEVCNT64_BIN}/bashlib64.bash" || exit 1

readonly DEVCNT64_BUILD_CMD_PODMAN='/usr/bin/podman'
export container64_build_X_EXPORT_X=''

function container64_build_podman_build() {

  local container="$1"
  local version="${2:-0.1.0}"
  local status=1
  local dockerfile="${DEVCNT64_SRC}/dockerfiles/${container}/Dockerfile"

  bl64_check_file "$dockerfile" || return 1

  cd "${DEVCNT64_SRC}/dockerfiles/${container}"
  "$DEVCNT64_BUILD_CMD_PODMAN" build -t "${container}:${version}" .
  status=$?

  return $status

}

function container64_build_check() {

  bl64_check_command "$DEVCNT64_BUILD_CMD_PODMAN"

}

function container64_build_help() {

  bl64_msg_show_usage \
    '-p -f DockerFile' \
    'Build containers in dev environment' \
    '
-p    : Build container with podman
    ' '' '
-c Container   : container name
-e Version     : container version
    '

}

#
# Main
#

declare container64_build_command=''
declare container64_build_container=''
declare container64_build_version=''
declare container64_build_option=''

(($# == 0)) && container64_build_help && exit 1
while getopts ':pc:e:h' container64_build_option; do
  case "$container64_build_option" in
  p) container64_build_command='build' ;;
  c) container64_build_container="$OPTARG" ;;
  e) container64_build_version="$OPTARG" ;;
  h) container64_build_help && exit ;;
  \?) container64_build_help && exit 1 ;;
  esac
done
[[ -z "$container64_build_command" ]] && container64_build_help && exit 1
container64_build_check || exit 1

case "$container64_build_command" in
'build') container64_build_podman_build "$container64_build_container" "$container64_build_version" ;;
esac
container64_build_status=$?

exit $container64_build_status
