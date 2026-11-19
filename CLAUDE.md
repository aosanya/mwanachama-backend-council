# CLAUDE.md

Guidance for Claude Code working in this repository.

## Project: mwanachama-backend-council

Keeps a council's meetings, the agenda and minutes of each meeting, its
resolutions and its bylaws. Module path
`github.com/aosanya/mwanachama-backend-council`, Go package
`mwanachamacouncil`. Created 2026-11-19 by moving the council module out of the
hub's in-tree copy.

**A declared domain.** The objects come from `council.blueprint.json` and the
route table from `council.operations.json`; storage is
`mwanachama-backend-shared/specstore` and the routes are built by
`mwanachama-backend-shared/dispatch`. The row types in `models/` are plain
carriers for the store; there is no `AutoMigrate`.

**Standalone library, no server of its own**, and **no auth model**: the
mounting host resolves the caller and the role permissions
(`council.view`, `council.manage`) and passes them in through `routes.Mount`.

## Conventions

- Four-phase `documentation/` layout, see
  [documentation/README.md](documentation/README.md).
- `go vet ./...` and `go test -count=1 ./...` (sqlite through
  `glebarez/sqlite`, in memory) verify a change.
- **Adding a field means editing `council.blueprint.json` and the Go type in
  `models/` together.**
- An address is an entry in `council.operations.json`; the field docs MCP
  tools need for non-blueprint inputs are in `routes/tools.go`.
- Every read is narrowed to one `instance_id`, so one agency never reads
  another's meetings, bylaws or resolutions.
- A save of an agenda or of minutes made on an old version is refused as stale
  (`versioncheck`); a save with no version is accepted.

## Code comments

Write code with no comments. Not one-liners above a function, not section
banners, not doc comments on exported symbols, not "why" notes next to a
tricky line. A name, a type, or a smaller function carries it instead.

Anything that genuinely needs explaining goes in this repo's `documentation/`
folder, under the phase it belongs to (`1. requirements`, `2. design`,
`3. implementation`, `4. qa`) — never inline.

**Why:** inline prose drifts out of sync with the code, duplicates what
`documentation/` already owns, and buries the explanation where nobody
looking for it will search.

**How to apply:**

- New code ships without comments. If a line seems to need one, rename or
  split until it doesn't.
- Touching code that already has comments: strip the ones in the code you are
  changing. Do not sweep untouched files unless asked.
- If the reasoning matters, add or update the matching `documentation/` page
  in the same change and leave nothing behind in the source.
- Machine-read directives are not comments and stay: build tags, `//go:embed`,
  `//go:generate`, linter pragmas (`//nolint`, `// eslint-disable-next-line`,
  `// ignore:`), license headers, codegen "do not edit" banners, and generated
  files as a whole.
- Commit messages, PR descriptions, and test names carry the narration that
  used to go in comments.

This rule is repeated verbatim in every mwanachama repo's `CLAUDE.md` so that
it reaches sessions that do not load this machine's user-level config —
scheduled cloud routines, other machines, and other agent harnesses.
