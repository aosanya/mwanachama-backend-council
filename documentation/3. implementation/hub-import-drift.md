# Hub import drift

What stood between `mwanachama-backend-council` and the hub's in-tree copy (`projects/hub-steward/code/wakala-api/modules/council`) before the hub imports this module and deletes the copy.

## What the hub's council module holds

The module is one Go package, `mwanachamacouncil`, with three sub-packages, 31 files in all (25 that are not tests, about 1,170 lines of Go, and 6 test files).

| Part | What it holds |
|---|---|
| Root package | `CouncilManager` and its constructors `NewCouncilManager` and `NewCouncilManagerWithClock`; `SpecFor`, `SpecForMount`, `LoadSpec`, `ParseSpec`, `Blueprint`, `Operations`; `Provision`; the sentinel errors; the date pattern; the clock; the per-object files `meeting.go`, `agenda.go`, `minutes.go`, `resolution.go`, `bylaw.go` and `update.go` |
| Declarations | `council.blueprint.json` (five objects: bylaw, meeting, agenda, minutes, resolution), `council.operations.json` (16 addresses) and `council.wakala.json` (the domain mapping of the objects to tables) |
| `models/` | The five plain carrier types the store reads and writes |
| `routes/` | The route table built from the operations file, and the MCP tool list built from the same table |
| `mcp/` | `RegisterTools`, which registers those tools on an MCP server |

It depends on `wakalaserver/modules/shared` for `spec`, `specstore`, `dispatch`, `httpwire` and `versioncheck`, and on nothing else of the hub.

## Method

The module has no `scripts/hub-copy-diff.sh`, so the comparison was made by hand with the same idea the other sibling modules use: every file of the hub copy, with `wakalaserver/modules/council` rewritten to `github.com/aosanya/mwanachama-backend-council` and `wakalaserver/modules/shared` rewritten to `github.com/aosanya/mwanachama-backend-shared`, compared byte for byte (`cmp`) with the file of the same path here.

Run on 2026-11-19 against the working tree of the hub's `dev` branch at `0e5822b7`. The module folder has no uncommitted change there; its last commit is `9ce3bdb6` (an agenda or minutes save made on an old version is refused). This repository has no commit yet.

## Result of the run

Every one of the 31 files of the hub copy, the 25 non-test files and the 6 test files, is identical to this repository's file of the same path once the two import prefixes are rewritten. The hub copy carries no behaviour this repository lacks, and this repository carries no behaviour the hub copy lacks.

`go vet ./...` and `go test -count=1 ./...` pass here on the in-memory SQLite backend: 46 tests, all in `routes/`, 77.6% statement coverage of that package.

## Only in the hub

Nothing inside the module folder.

## Only in this repository

| Item | Disposition |
|---|---|
| `go.mod`, `go.sum` | Keep. The module requires `mwanachama-backend-shared` through a local `replace` to `../mwanachama-backend-shared`, the way the other sibling modules do until a tag exists. |
| `README.md`, `CLAUDE.md`, `Makefile`, `LICENSE`, `.gitignore`, `documentation/` | Keep. Repository files, outside the module. |

## Differing beyond the import path

None. No operation behaves differently on the two sides, so there is nothing to put to the owner as a question.

## Hub-only wiring outside the module

These stay in the hub and are not moved. When the hub imports this module they keep working by changing only their import path.

| Where in the hub | What it does |
|---|---|
| `cmd/server/main.go` | Builds the one council manager at start: `SpecFor("app")`, `Provision`, `NewCouncilManager` |
| `internal/api/http/deps.go` | Holds the manager as `Deps.Council` |
| `internal/api/http/mcp_tools_council.go` | Registers the council MCP tools and guards each tools/call: the caller must be admitted to the agency, the council module must be mounted for it, and unless the caller is the owner the role must hold `council.view` or `council.manage` for the tool's action |
| `internal/api/http/mcp.go`, `internal/api/http/mcp_tool_actions.go` | Call the registration and list the tool-to-action map |
| `internal/api/http/council_tools_mcp_test.go`, `internal/api/http/council_update_mcp_test.go` | Pin the guard and the tools over the hub's MCP endpoint; they name the tools by string and import nothing from the module |
| `internal/api/http/step_runs_harness_test.go` | Builds a council manager for the hub's step-run tests |
| `modules/agency/models/permissions_catalog.json` | The `council.view` and `council.manage` permissions and the `council.*` actions they grant |

The hub mounts no HTTP route table for the council; only the MCP tools are served.

## What the hub import has to settle

`routes.Tools` returns `dispatch.Tool` from `mwanachama-backend-shared/dispatch`. The hub's `mcp_tool_actions.go` takes `dispatch.Tool` from its in-tree `wakalaserver/modules/shared/dispatch`. Go treats these as two different types, so the council tools cannot be passed to `addToolActions` until that file imports the shared repository's `dispatch`. The same holds for any hub file that hands the module's `spec`, `specstore` or `httpwire` types to hub code. The hub does not import `mwanachama-backend-shared` anywhere yet, so the shared import and the council import have to land together.

## Pinned counts

Nothing was merged beyond the move, so no pinned count changed.
