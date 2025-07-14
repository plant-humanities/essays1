#!/bin/bash

# Usage: ./compress_pdfs.sh /path/to/root

set -euo pipefail

ROOT_DIR="${1:-.}"

if ! command -v gs &> /dev/null; then
  echo "Error: Ghostscript (gs) is not installed." >&2
  exit 1
fi

find "$ROOT_DIR" -type f -iname '*.pdf' | while IFS= read -r pdf; do
  tmp_pdf="$(dirname "$pdf")/tmp_$$.pdf"

  echo "Compressing: $pdf"
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
     -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH \
     -sOutputFile="$tmp_pdf" "$pdf"

  if [ -s "$tmp_pdf" ]; then
    mv "$tmp_pdf" "$pdf"
  else
    echo "Warning: Failed to compress $pdf, leaving original intact."
    rm -f "$tmp_pdf"
  fi
done
