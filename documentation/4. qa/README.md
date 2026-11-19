# QA

| Suite | Runs with | Holds |
|---|---|---|
| `routes/bylaw_test.go` | `go test ./...` (sqlite, in memory) | Creating, listing and reading bylaws over the real route table |
| `routes/resolution_test.go` | `go test ./...` | Creating, listing and reading resolutions |
| `routes/agenda_minutes_test.go` | `go test ./...` | Setting and reading a meeting's agenda and minutes |
| `routes/update_test.go` | `go test ./...` | Correcting a meeting, a resolution and a bylaw; a resolution is not moved to another meeting |
| `routes/version_test.go` | `go test ./...` | An agenda or minutes save made on an old version is refused as stale |
| `routes/tools_test.go` | `go test ./...` | The MCP tools built from the table: names, schemas and calls |

`go vet ./...` runs clean. The root package and `mcp/` have no tests of their
own yet.
