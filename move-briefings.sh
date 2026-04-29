#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="briefings"

if [ ! -d "$BASE_DIR" ]; then
  echo "briefings directory not found"
  exit 1
fi

find "$BASE_DIR" -maxdepth 1 -type f -name "????-??-??.md" | sort | while read -r file; do
  filename=$(basename "$file")        # 2026-01-12.md
  date_part="${filename%.md}"         # 2026-01-12

  year="${date_part:0:4}"             # 2026
  month="${date_part:5:2}"            # 01

  target_dir="$BASE_DIR/$year/$month"
  target_file="$target_dir/$filename"

  mkdir -p "$target_dir"

  if [ -f "$target_file" ]; then
    echo "SKIP already exists: $target_file"
  else
    git mv "$file" "$target_file"
    echo "MOVED $file -> $target_file"
  fi
done

echo "Done."