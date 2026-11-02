#!/usr/bin/env bash
# Point Formula/<NAME>.rb at the latest release of its repo (the formula's homepage), or TAG.
#
#   scripts/bump.sh NAME [TAG]
#
# Rewrites the formula's url + sha256 in place. Exits 0 without touching anything when the
# formula is already current, or when the repo has no release yet.
#
# Writes version=/changed= to $GITHUB_OUTPUT when run in Actions.
set -euo pipefail

name="${1:?usage: scripts/bump.sh NAME [TAG]}"
FORMULA="$(cd "$(dirname "$0")/.." && pwd)/Formula/${name}.rb"
REPO="$(sed -nE 's|^  homepage "https://github.com/([^"]+)"|\1|p' "${FORMULA}")"

output() {
  [[ -n "${GITHUB_OUTPUT:-}" ]] && echo "$1" >>"${GITHUB_OUTPUT}"
  return 0
}

tag="${2:-}"
if [[ -z "${tag}" ]] && ! tag="$(gh api "repos/${REPO}/releases/latest" --jq .tag_name 2>/dev/null)"
then
  echo "${name}: ${REPO} has no release yet"
  output "changed=false"
  exit 0
fi
version="${tag#v}"
current="$(sed -nE 's|.*/archive/refs/tags/v([^/]+)\.tar\.gz.*|\1|p' "${FORMULA}")"
output "version=${version}"

# A formula starts out with a placeholder checksum, so that counts as stale.
if [[ "${version}" == "${current}" ]] && ! grep -q 'sha256 "0\{64\}"' "${FORMULA}"
then
  echo "${name} already at ${current}"
  output "changed=false"
  exit 0
fi

url="https://github.com/${REPO}/archive/refs/tags/v${version}.tar.gz"
sha="$(curl -fsSL "${url}" | sha256sum | cut -d' ' -f1)"
sed -i -E \
  -e "s|^  url \".*\"|  url \"${url}\"|" \
  -e "s|^  sha256 \".*\"|  sha256 \"${sha}\"|" \
  "${FORMULA}"
echo "${name} ${current} -> ${version}"
output "changed=true"
