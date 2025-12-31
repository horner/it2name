#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IT2NAME="${SCRIPT_DIR}/it2name"

# Test counter
TESTS_RUN=0
TESTS_PASSED=0

run_test() {
  local test_name="$1"
  local expected_exit="$2"
  shift 2
  local cmd=("$@")
  
  TESTS_RUN=$((TESTS_RUN + 1))
  echo -n "Test ${TESTS_RUN}: ${test_name}... "
  
  if output=$("${cmd[@]}" 2>&1); then
    actual_exit=0
  else
    actual_exit=$?
  fi
  
  if [[ "$actual_exit" == "$expected_exit" ]]; then
    echo -e "${GREEN}PASSED${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    return 0
  else
    echo -e "${RED}FAILED${NC}"
    echo "  Expected exit code: $expected_exit"
    echo "  Actual exit code: $actual_exit"
    echo "  Output: $output"
    return 1
  fi
}

check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo -e "${RED}Error: $1 is not installed${NC}"
    echo "Please install it: brew install $2"
    exit 1
  fi
}

echo "=== it2name Test Suite ==="
echo

# Check dependencies
echo "Checking dependencies..."
check_command "magick" "imagemagick"
check_command "chafa" "chafa"
echo -e "${GREEN}✓ All dependencies found${NC}"
echo

# Set terminal size for consistent testing
export COLUMNS=80
export LINES=24

# Test 1: Version flag
run_test "Version flag" 0 "$IT2NAME" --version

# Test 2: Help flag
run_test "Help flag" 0 "$IT2NAME" --help

# Test 3: Missing text argument (should fail)
run_test "Missing text argument" 1 "$IT2NAME"

# Test 4: Unknown option (should fail)
run_test "Unknown option" 1 "$IT2NAME" --unknown-flag

# Test 5: Basic text rendering (success if no error)
run_test "Basic text rendering" 0 "$IT2NAME" "Test"

# Test 6: Current directory (.)
run_test "Current directory shortcut" 0 "$IT2NAME" "."

# Test 7: Custom foreground color
run_test "Custom foreground color" 0 "$IT2NAME" --fgcolor red "Red Text"

# Test 8: Custom background color
run_test "Custom background color" 0 "$IT2NAME" --bgcolor blue "Blue BG"

# Test 9: Both custom colors
run_test "Both custom colors" 0 "$IT2NAME" --fgcolor yellow --bgcolor black "Yellow on Black"

# Summary
echo
echo "=== Test Summary ==="
echo -e "Tests run: ${TESTS_RUN}"
echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests failed: ${RED}$((TESTS_RUN - TESTS_PASSED))${NC}"

if [[ "$TESTS_PASSED" == "$TESTS_RUN" ]]; then
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed${NC}"
  exit 1
fi
