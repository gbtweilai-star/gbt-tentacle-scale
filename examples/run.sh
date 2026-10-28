#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_tentacle_scale info
PYTHONPATH=src python -m gbt_tentacle_scale check --payload '{}'
PYTHONPATH=src python -m gbt_tentacle_scale run   --payload '{}'
