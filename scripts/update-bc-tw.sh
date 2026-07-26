#!/usr/bin/env sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
URL="${BC_TW_YAML_URL:-https://gitlab.com/godfat/battle-cats-rolls/-/raw/master/build/bc-tw.yaml}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

curl --fail --silent --show-error --location --retry 3 \
  --proto '=https' --tlsv1.2 "$URL" -o "$TMP_DIR/bc-tw.yaml"

BC_TW_INPUT="$TMP_DIR/bc-tw.yaml" \
BC_TW_OUTPUT="$TMP_DIR/bc-tw-lite.json" \
  ruby "$ROOT/scripts/build-lite-data.rb"

BC_TW_INPUT="$TMP_DIR/bc-tw.yaml" \
BC_TW_OUTPUT="$TMP_DIR/bc-tw-lite.json" \
  ruby "$ROOT/scripts/validate-data.rb"

mv "$TMP_DIR/bc-tw.yaml" "$ROOT/data/bc-tw.yaml"
mv "$TMP_DIR/bc-tw-lite.json" "$ROOT/data/bc-tw-lite.json"
