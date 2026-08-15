#!/usr/bin/env bash
# Fake drone-scp binary for testing
# Reads INPUT_* env vars and copies files locally

set -euo pipefail

# Handle --version flag
if [[ "${1:-}" == "--version" ]]; then
  echo "drone-scp version fake-1.0.0"
  exit 0
fi

TARGET="${INPUT_TARGET:-/tmp/upload}"
SOURCE="${INPUT_SOURCE:-}"
STRIP="${INPUT_STRIP_COMPONENTS:-0}"
RM="${INPUT_RM:-false}"
DEBUG="${INPUT_DEBUG:-false}"

if [[ "$DEBUG" == "true" ]]; then
  echo "[DEBUG] fake-drone-scp: TARGET=$TARGET SOURCE=$SOURCE STRIP=$STRIP RM=$RM"
fi

# Remove target if rm=true
if [[ "$RM" == "true" ]]; then
  echo "Removing target directory: $TARGET"
  rm -rf "$TARGET"
fi

# Ensure target exists
mkdir -p "$TARGET"

# Process each source file
while IFS= read -r src; do
  src="$(echo "$src" | tr -d '[:space:]')"
  [[ -z "$src" ]] && continue

  if [[ "$DEBUG" == "true" ]]; then
    echo "[DEBUG] Processing source: $src"
  fi

  if [[ -f "$src" ]]; then
    # Strip leading path components
    dest_name="$src"
    if [[ "$STRIP" -gt 0 ]]; then
      # Remove leading slash and split by /
      stripped="${src#/}"
      for ((i=0; i<STRIP; i++)); do
        stripped="${stripped#*/}"
      done
      dest_name="$stripped"
    else
      dest_name="$(basename "$src")"
    fi

    dest_path="$TARGET/$dest_name"
    dest_dir="$(dirname "$dest_path")"
    mkdir -p "$dest_dir"

    if [[ "$DEBUG" == "true" ]]; then
      echo "[DEBUG] Copying $src -> $dest_path"
    fi
    cp "$src" "$dest_path"
    echo "Transferred: $src -> $dest_path"
  elif [[ -d "$src" ]]; then
    cp -r "$src" "$TARGET/"
    echo "Transferred directory: $src -> $TARGET/"
  else
    echo "WARNING: source not found: $src"
  fi
done <<< "$SOURCE"

echo "SCP transfer completed successfully"
