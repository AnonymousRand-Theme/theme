#!/usr/bin/env bash

set -euo pipefail
set -x

# SYNC!
configs_output_dir=./configs/

# SYNC: paths!
mkdir -p "$configs_output_dir"

nix_store_output_dir="$(nix build .?submodules=1 --print-out-paths --no-link)"
cp -r "$nix_store_output_dir"/* "$configs_output_dir"
# as nix store has them read-only, but they need to be writable to be overridden
# (and the directories also need to be executable to recursively chown)
chmod u=rwX,g=rX,o=rX -R "$configs_output_dir"

if [[ "$#" -gt 0 && "$1" == "--git-push" ]]; then
    git submodule foreach \
        "git add -A && git commit -m '[autocommit] update outputs' || true && git push"
fi
