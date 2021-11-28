#!/bin/bash
set -u
set -e

ML_GIT_REPO="https://github.com/lukasdanckwerth/mailer.git"
ML_DIR="/etc/mailer"
ML_VERSION="${ML_DIR}/.version"

log() {
  echo "[mailer]  ${*}"
}

emph() {
  echo -e "\033[1m${*}\033[0m"
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

IM_REMOTE_VER="$(remote_version)"
IM_LOCAL_VER="$(local_version)"

[[ "$(whoami)" == "root" ]] || die "$(emph "update") must be run as root"
[[ "$(which git)" == "" ]] && die "$(emph "git") not found"
[[ "${IM_REMOTE_VER}" == "${IM_LOCAL_VER}" && ! "$*" == *--force* ]] && die "already up to date"

if [[ ! "${IM_LOCAL_VER}" == "" ]]; then
  log "" && log "$(emph "UPDATE AVAILABLE")" && log ""
  log "CURRENT:   $(emph "${IM_LOCAL_VER}")"
  log "NEW:       $(emph "${IM_REMOTE_VER}")" && log ""
  log "Do you want to install the update (y/n)?"
else
  log "Are you sure you want to insall mailer (y/n)?"
fi

read -r -p "" IM_INSTALL_CONTROL
[[ "${IM_INSTALL_CONTROL}" == "y" ]] || exit 0

UP_TMP_TARGET="/tmp/mailer-$(random_string)"
log "temp repo directory: ${UP_TMP_TARGET}"

log "Cloning repo ${ML_GIT_REPO} ..."
log "... into ${UP_TMP_TARGET}"
git clone --quiet "${ML_GIT_REPO}" "${UP_TMP_TARGET}"

pushd "${UP_TMP_TARGET}" >/dev/null

log "Install ..."
sudo make install

popd >/dev/null

log "Remove ${UP_TMP_TARGET}"
rm -rf "${UP_TMP_TARGET}"
