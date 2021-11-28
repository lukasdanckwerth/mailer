#!/bin/bash
set -u
set -e

ML_GIT_REPO="https://github.com/lukasdanckwerth/mailer.git"
ML_DIR="/etc/mailer"
ML_VERSION="${ML_DIR}/.version"

log() {
  echo "[install-mailer.sh]  ${*}"
}

emph() {
  echo "\033[1m${*}\033[0m"
}

random_string() {
  echo $RANDOM | md5sum | head -c 32
}

die() {
  log "${*}" && exit 0
}

remote_version() {
  git ls-remote "${ML_GIT_REPO}" HEAD | awk '{ print $1}'
}

local_version() {
  if [[ -f "${ML_VERSION}" ]]; then echo "$(cat "${ML_VERSION}")"; else echo ""; fi
}

log "checking preconditions..."

IM_REMOTE_VER="$(remote_version)"
IM_LOCAL_VER="$(local_version)"

[[ "$(whoami)" == "root" ]] || die "$(emph "update") must be run as root"
[[ "$(which git)" == "" ]] && die "$(emph "git") not found"
[[ "${IM_REMOTE_VER}" == "${IM_LOCAL_VER}" && ! "$*" == *--force* ]] && die "already up to date"

log "new version available" && log ""
log "current version: ${IM_LOCAL_VER}"
log "NEW version: ${IM_REMOTE_VER}"

read -r -p "Do you want to install the update (y/n)? " IM_INSTALL_CONTROL
[[ "${IM_INSTALL_CONTROL}" == "y" ]] || die "user aborted"

UP_TMP_TARGET="/tmp/mailer-$(random_string)"
log "temp repo directory: ${UP_TMP_TARGET}"

log "clone repo..."
git clone --quiet "${ML_GIT_REPO}" "${UP_TMP_TARGET}"
pushd "${UP_TMP_TARGET}" >/dev/null
echo $(git rev-parse HEAD) >"${ML_VERSION}"

log "install..."
sudo make install
popd >/dev/null

log "clean up..."
rm -rf "${UP_TMP_TARGET}"
