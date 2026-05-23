#!/usr/bin/env bash
# Lightweight environment check for XLSX skill.
# Exit 0 = all OK, exit 1 = missing dependencies.
QUIET=false; [ "${1:-}" = "--quiet" ] && QUIET=true
FAIL=0
check() { local desc="$1"; shift; if ! "$@" &>/dev/null; then $QUIET || echo "MISSING: $desc"; FAIL=1; fi; }

check "python3"     command -v python3
check "openpyxl"    python3 -c "import openpyxl"
check "xlsxwriter"  python3 -c "import xlsxwriter"

# Font check
if command -v fc-list &>/dev/null; then
    fc-list :lang=zh 2>/dev/null | grep -qi "noto\|simhei\|wenquanyi" || { $QUIET || echo "MISSING: CJK fonts"; FAIL=1; }
fi

exit $FAIL
