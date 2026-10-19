#!/usr/bin/env bash

set -euo pipefail
set -x

# SYNC: paths!
mkdir -p ./files/

nix_store_output_dir="$(nix build --print-out-paths --no-link)"
cp -r "$nix_store_output_dir" ./files/
