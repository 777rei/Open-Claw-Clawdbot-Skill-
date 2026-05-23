#!/usr/bin/env bash
# Lightweight environment check for PDF skill.
# Exit 0 = all OK, exit 1 = missing dependencies.
# Usage: bash env_check.sh [--quiet]
QUIET=false; [ "${1:-}" = "--quiet" ] && QUIET=true
FAIL=0
check() { local desc="$1"; shift; if ! "$@" &>/dev/null; then $QUIET || echo "MISSING: $desc"; FAIL=1; fi; }

check "python3"    command -v python3
check "node"       command -v node
check "pikepdf"    python3 -c "import pikepdf"
check "pdfplumber" python3 -c "import pdfplumber"
check "pypdf"      python3 -c "import pypdf"
check "reportlab"  python3 -c "import reportlab"
check "PyMuPDF"    python3 -c "import fitz"
check "playwright" node -e "require('playwright')"

# LaTeX engine (tectonic) — needed for Academic pipeline
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [ -x "$SKILL_DIR/scripts/tectonic" ]; then
    : # bundled binary OK
elif command -v tectonic &>/dev/null; then
    : # system tectonic OK
else
    $QUIET || echo "MISSING: tectonic (needed for LaTeX/Academic PDFs)"
    FAIL=1
fi

# Font check: verify CJK fonts are available
if command -v fc-list &>/dev/null; then
    fc-list :lang=zh 2>/dev/null | grep -qi "noto\|simhei\|wenquanyi" || { $QUIET || echo "MISSING: CJK fonts"; FAIL=1; }
fi

exit $FAIL
