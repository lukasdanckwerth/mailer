#!/bin/bash
set -u
set -e

ML_GIT_REPO="https://github.com/lukasdanckwerth/bash-mailer.git"
ML_GIT_TEMPLATE_URL="https://raw.githubusercontent.com/lukasdanckwerth/bash-mailer/main/mail.html"
ML_TEMPLATE="/etc/mailer/mail.html"
ML_CONFIG="/etc/mailer/mailer.conf"
ML_VERSION="/etc/mailer/mailer.version"

emph() {
  echo "\033[1m${*}\033[0m"
}

random_string() {
  echo $RANDOM | md5sum | head -c 32
}

die() {
  echo -e "${*}" && exit 0
}

get_remote_version() {
  git ls-remote "${ML_GIT_REPO}" HEAD | awk '{ print $1}'
}

get_local_version() {
  if [[ -f "${ML_VERSION}" ]]; then echo "$(cat "${ML_VERSION}")"; else echo ""; fi
}

[[ "$(whoami)" == "root" ]] || die "$(emph "update") must be run as root"
[[ "$(which git)" == "" ]] && die "$(emph "git") not found"
[[ "$(get_remote_version)" == "$(get_local_version)" ]] && die "already up to date"
UP_TMP_TARGET="/tmp/mailer-$(random_string)"
git clone --quiet "${ML_GIT_REPO}" "${UP_TMP_TARGET}"
pushd "${UP_TMP_TARGET}" >/dev/null
echo $(git rev-parse HEAD) >"${ML_VERSION}"
make install
popd >/dev/null
rm -rf "${UP_TMP_TARGET}"
