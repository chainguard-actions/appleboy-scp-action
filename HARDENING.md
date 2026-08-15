<!-- markdownlint-disable -->

# Hardening Report: appleboy--scp-action/v0.1.7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **appleboy--scp-action/v0.1.7** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The workflow file .github/workflows/ci.yml references several GitHub Actions using mutable tag refs instead of pinned 40-character SHA commit digests. This exposes the workflow to supply-chain attacks if any of these tags are moved or the upstream repository is compromised. Unpinned references found:
- `actions/checkout@v4` (lines ~8, ~75, ~100, ~118, ~136)
- `actions/upload-artifact@v4` (line ~82)
- `actions/download-artifact@v4` (line ~88)
- `tj-actions/changed-files@v41` (line ~103)

All should be replaced with their full 40-character SHA, e.g. `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `.github/workflows/ci.yml:8`
- `.github/workflows/ci.yml:75`
- `.github/workflows/ci.yml:82`
- `.github/workflows/ci.yml:88`
- `.github/workflows/ci.yml:100`
- `.github/workflows/ci.yml:103`
- `.github/workflows/ci.yml:118`
- `.github/workflows/ci.yml:136`

### missing-permissions (severity: medium)

The workflow file .github/workflows/ci.yml has no top-level `permissions:` key and none of its five jobs (`testing`, `deploy`, `changes`, `target`, `multipleHost`) define a job-level `permissions:` block. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (write access to contents, packages, etc.). A minimal permissions block such as `permissions: {}` or specific scopes (e.g. `contents: read`) should be added at the top level or on each job.

Locations:

- `.github/workflows/ci.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed .github/workflows/ci.yml:
1. Pinned all action references to full 40-character SHA digests with tag comments:
   - actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262 # v4 (5 occurrences)
   - actions/upload-artifact@v4 → @ea165f8d65b6e75b540449e92b4886f43607fa02 # v4
   - actions/download-artifact@v4 → @d3f86a106a0bac45b974a628896c90dbdf5c8093 # v4
   - tj-actions/changed-files@v41 → @716b1e13042866565e00e85fd4ec490e186c4a2f # v41
2. Added top-level `permissions: {}` to enforce least-privilege token access across all jobs.

