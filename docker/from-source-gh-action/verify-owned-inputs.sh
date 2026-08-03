#! /bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -euo pipefail

CORE_ASSETS="${CORE_ASSETS:-https://github.com/GusRz/azentro-collabora-build-assets/releases/download/for-code-assets/core-co-25.04-assets.tar.gz}"
CORE_REPO="${CORE_REPO:-https://github.com/GusRz/azentro-collabora-core-mirror.git}"
CORE_BRANCH="${CORE_BRANCH:-distro/collabora/co-25.04}"
COLLABORA_ONLINE_REPO="${COLLABORA_ONLINE_REPO:-https://github.com/GusRz/azentro-collabora-online-mirror.git}"
COLLABORA_ONLINE_BRANCH="${COLLABORA_ONLINE_BRANCH:-azentro-online-co-25.04-56429c4}"
POCO_URL="${POCO_URL:-https://github.com/GusRz/azentro-collabora-build-assets/raw/main/poco-1.12.5p2-all.tar.gz}"
IMAGE_REPOSITORY="${IMAGE_REPOSITORY:-ghcr.io/gusrz/azentro-collabora-online}"

failures=0

check_url() {
  local label="$1"
  local url="$2"

  if curl -fsIL --retry 2 --retry-delay 1 "$url" >/dev/null; then
    echo "OK   $label -> $url"
  else
    echo "FAIL $label -> $url"
    failures=$((failures + 1))
  fi
}

check_git_ref() {
  local label="$1"
  local repo="$2"
  local ref="$3"

  if git ls-remote --heads "$repo" "$ref" | grep -q "$ref"; then
    echo "OK   $label -> $repo $ref"
  else
    echo "FAIL $label -> $repo $ref"
    failures=$((failures + 1))
  fi
}

check_git_tag() {
  local label="$1"
  local repo="$2"
  local ref="$3"

  if git ls-remote --tags "$repo" "$ref" | grep -q "refs/tags/$ref"; then
    echo "OK   $label -> $repo $ref"
  else
    echo "FAIL $label -> $repo $ref"
    failures=$((failures + 1))
  fi
}

echo "Validating owned build inputs for docker/from-source-gh-action"
check_url "CORE_ASSETS" "$CORE_ASSETS"
check_url "POCO_URL" "$POCO_URL"
check_git_ref "CORE_REPO" "$CORE_REPO" "$CORE_BRANCH"
check_git_tag "COLLABORA_ONLINE_REPO" "$COLLABORA_ONLINE_REPO" "$COLLABORA_ONLINE_BRANCH"

echo "Expected GHCR target: $IMAGE_REPOSITORY"
echo "Required GitHub Actions secrets: GHCR_USERNAME, GHCR_TOKEN"

if [ "$failures" -ne 0 ]; then
  echo
  echo "Owned input validation failed with $failures issue(s)."
  exit 1
fi

echo
echo "All owned inputs resolved successfully."
