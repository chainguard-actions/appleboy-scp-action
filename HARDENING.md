<!-- markdownlint-disable -->

# Hardening Report: appleboy--scp-action/v1.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **appleboy--scp-action/v1.0.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In action.yml, the 'Set GitHub Path' step sets env var GITHUB_ACTION_PATH from the github.action_path context value (${{ github.action_path }}) and then writes it directly to $GITHUB_PATH via `echo "$GITHUB_ACTION_PATH" >> $GITHUB_PATH` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A calling workflow could theoretically influence the path value, and the missing sanitization means newline injection into $GITHUB_PATH is possible.

Locations:

- `action.yml:80`

### unpinned-uses (severity: high)

Multiple workflow steps use mutable tag-based refs instead of pinned 40-character SHA digests, making them vulnerable to supply-chain attacks if the referenced tag is moved or the upstream repo is compromised.

In .github/workflows/goreleaser.yml:
- `uses: actions/checkout@v4` (line 15)
- `uses: actions/setup-go@v5` (line 20)
- `uses: goreleaser/goreleaser-action@v6` (line 24)

In .github/workflows/testing.yml:
- `uses: actions/checkout@v4` (lines 8, 62, 84, 103, 113)
- `uses: actions/upload-artifact@v4` (line 67)
- `uses: actions/download-artifact@v4` (line 72)
- `uses: tj-actions/changed-files@v45` (line 89)

Locations:

- `.github/workflows/goreleaser.yml:15`
- `.github/workflows/goreleaser.yml:20`
- `.github/workflows/goreleaser.yml:24`
- `.github/workflows/testing.yml:8`
- `.github/workflows/testing.yml:62`
- `.github/workflows/testing.yml:67`
- `.github/workflows/testing.yml:72`
- `.github/workflows/testing.yml:84`
- `.github/workflows/testing.yml:89`
- `.github/workflows/testing.yml:103`
- `.github/workflows/testing.yml:113`

### missing-permissions (severity: medium)

The workflow file testing.yml has no top-level `permissions:` key, and none of its jobs (testing, deploy, changes, target, multipleHost) define job-level `permissions:` blocks. This means the workflow runs with the default (potentially broad) GitHub Actions token permissions.

Locations:

- `.github/workflows/testing.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, unpinned-uses, missing-permissions

**Notes:**

1. action.yml 'Set GitHub Path' step: Added sanitization using `printf '%s' "$GITHUB_ACTION_PATH" | tr -d '\n\r'` before writing to $GITHUB_PATH to prevent newline injection. 2. goreleaser.yml: Pinned actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262, actions/setup-go@v5 → @40f1582b2485089dde7abd97c1529aa768e1baff, goreleaser/goreleaser-action@v6 → @e435ccd777264be153ace6237001ef4d979d3a7a. 3. testing.yml: Pinned all 5 actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262, actions/upload-artifact@v4 → @ea165f8d65b6e75b540449e92b4886f43607fa02, actions/download-artifact@v4 → @d3f86a106a0bac45b974a628896c90dbdf5c8093, tj-actions/changed-files@v45 → @48d8f15b2aaa3d255ca5af3eba4870f807ce6b3c. 4. testing.yml: Added top-level `permissions: {}` to restrict default token permissions.

