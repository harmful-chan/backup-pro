#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for dofile in "$BASE_DIR"/*/do.sh; do
    [ -f "$dofile" ] || continue

    project_dir="$(dirname "$dofile")"
    project_name="$(basename "$project_dir")"

    echo "========== $project_name =========="

    (
        cd "$project_dir"
        ./do.sh backup
    )

    rc=$?

    if [ $rc -ne 0 ]; then
        echo "FAILED: $project_name"
    fi
done
