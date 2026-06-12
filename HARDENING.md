<!-- markdownlint-disable -->

# Hardening Report: appleboy--scp-action/v1.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **appleboy--scp-action/v1.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In the 'Set GitHub Path' step of action.yml, the env var $GITHUB_ACTION_PATH (set from ${{ github.action_path }}, a github.* context value) is written directly to $GITHUB_PATH without the required sanitization step (`printf '%s' "$VAR" | tr -d '\n\r'`). A calling workflow could theoretically supply a path containing newline characters, allowing injection of additional entries into $GITHUB_PATH. The fix is: `safe=$(printf '%s' "$GITHUB_ACTION_PATH" | tr -d '\n\r'); echo "$safe" >> "$GITHUB_PATH"`.

Locations:

- `action.yml:88`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed the 'Set GitHub Path' step in action.yml (line 88) by sanitizing the GITHUB_ACTION_PATH value before writing to $GITHUB_PATH. The run script now uses `safe=$(printf '%s' "$GITHUB_ACTION_PATH" | tr -d '\n\r')` followed by `echo "$safe" >> "$GITHUB_PATH"` to strip any embedded newline characters that could allow injection of additional entries into $GITHUB_PATH.

