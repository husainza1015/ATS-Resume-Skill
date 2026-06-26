#!/usr/bin/env bash
# Build an ATS resume PDF from a RenderCV YAML — PDF only.
#
# Usage:
#   bash build_cv.sh <input.yaml> [output_basename]
#     output_basename defaults to "resume_<YYYY-MM>"
#
# Renders the YAML, copies the PDF to <output_basename>.pdf next to where you
# run it, and removes the regenerable non-PDF render intermediates.

set -euo pipefail

YAML="${1:?Usage: build_cv.sh <input.yaml> [output_basename]}"
BASE="${2:-resume_$(date +%Y-%m)}"

export PYTHONIOENCODING=utf-8
python -m rendercv render "$YAML" >/dev/null

# RenderCV writes the PDF into ./rendercv_output/<Name>_CV.pdf
PDF="$(ls -t rendercv_output/*.pdf 2>/dev/null | head -1 || true)"
if [ -z "$PDF" ]; then
  echo "ERROR: no PDF was produced. Check the YAML — and make sure it has no 'render_command:' block (that silently breaks RenderCV)." >&2
  exit 1
fi

cp "$PDF" "${BASE}.pdf"

# PDF only: drop the regenerable non-PDF outputs in the tool's own output dir
find rendercv_output -type f ! -name '*.pdf' -delete 2>/dev/null || true

echo "Built: ${BASE}.pdf"
