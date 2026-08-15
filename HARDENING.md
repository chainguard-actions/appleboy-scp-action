<!-- markdownlint-disable -->

# Hardening Report: appleboy--scp-action/v0.1.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **appleboy--scp-action/v0.1.6** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The workflow file .github/workflows/ci.yml references several GitHub Actions using mutable version tags instead of full 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the tag is moved to a different commit. Unpinned references found:
- actions/checkout@v4 (used in jobs: testing, deploy, changes, target, multipleHost)
- actions/upload-artifact@v4 (used in job: deploy)
- actions/download-artifact@v4 (used in job: deploy)
- tj-actions/changed-files@v41 (used in job: changes)
All should be pinned to their full SHA digest, e.g. actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4

Locations:

- `.github/workflows/ci.yml:8`
- `.github/workflows/ci.yml:65`
- `.github/workflows/ci.yml:68`
- `.github/workflows/ci.yml:72`
- `.github/workflows/ci.yml:84`
- `.github/workflows/ci.yml:87`
- `.github/workflows/ci.yml:100`
- `.github/workflows/ci.yml:120`

### missing-permissions (severity: medium)

The workflow file .github/workflows/ci.yml has no top-level 'permissions:' key and none of its jobs (testing, deploy, changes, target, multipleHost) define job-level 'permissions:' blocks. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (write access to contents, packages, etc.). A minimal permissions block such as 'permissions: {}' or specific scopes (e.g. 'contents: read') should be added.

Locations:

- `.github/workflows/ci.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Updated .github/workflows/ci.yml with: (1) Top-level 'permissions: contents: read' block added to restrict the GITHUB_TOKEN to the minimum needed scope. (2) All mutable action tags pinned to full 40-character commit SHAs: actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262, actions/upload-artifact@v4 → @ea165f8d65b6e75b540449e92b4886f43607fa02, actions/download-artifact@v4 → @d3f86a106a0bac45b974a628896c90dbdf5c8093, tj-actions/changed-files@v41 → @716b1e13042866565e00e85fd4ec490e186c4a2f. Original version tags preserved as inline comments for readability.

