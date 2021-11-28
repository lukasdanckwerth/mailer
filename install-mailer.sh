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
[[ "$(whoami)" == "root" ]] || die "$(emph "update") must be run as root"
[[ "$(which git)" == "" ]] && die "$(emph "git") not found"
[[ "$(remote_version)" == "$(local_version)" && ! "$*" == *--force* ]] && die "already up to date"

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
