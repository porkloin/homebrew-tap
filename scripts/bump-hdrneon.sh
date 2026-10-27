#!/usr/bin/env bash
# Point Formula/hdrneon.rb at the latest porkloin/hdrneon release (or TAG).
#
#   scripts/bump-hdrneon.sh [TAG]
#
# Rewrites the formula's url + sha256 in place. Exits 0 without touching
# anything when the formula is already current.
#
# Writes version=/changed= to $GITHUB_OUTPUT when run in Actions.
set -euo pipefail

REPO="porkloin/hdrneon"
FORMULA="$(cd "$(dirname "$0")/.." && pwd)/Formula/hdrneon.rb"

output() {
  [[ -n "${GITHUB_OUTPUT:-}" ]] && echo "$1" >>"${GITHUB_OUTPUT}"
  return 0
}

tag="${1:-}"
if [[ -z "${tag}" ]]
then
  tag="$(gh api "repos/${REPO}/releases/latest" --jq .tag_name)"
fi
version="${tag#v}"
current="$(sed -nE 's|.*/archive/refs/tags/v([^/]+)\.tar\.gz.*|\1|p' "${FORMULA}")"
output "version=${version}"

# The formula starts out with a placeholder checksum, so that counts as stale.
if [[ "${version}" == "${current}" ]] && ! grep -q 'sha256 "0\{64\}"' "${FORMULA}"
then
  echo "Formula already at ${current}"
  output "changed=false"
  exit 0
fi

url="https://github.com/${REPO}/archive/refs/tags/v${version}.tar.gz"
sha="$(curl -fsSL "${url}" | sha256sum | cut -d' ' -f1)"
sed -i -E \
  -e "s|^  url \".*\"|  url \"${url}\"|" \
  -e "s|^  sha256 \".*\"|  sha256 \"${sha}\"|" \
  "${FORMULA}"
echo "hdrneon ${current} -> ${version}"
output "changed=true"
