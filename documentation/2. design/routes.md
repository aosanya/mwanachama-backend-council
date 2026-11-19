# The route table is declared

Every address is an entry in
[`council.operations.json`](../../council.operations.json).
`routes/routes.go` hands it, the sentinel map and the empty anonymous allowlist
to `dispatch.Dispatch`. `routes/tools.go` builds MCP tools from the same table,
and `mcp/mcp.go` registers them. One table, two surfaces.

| Method | Path | Call | Action | Status |
|---|---|---|---|---|
| POST | `/council/bylaws` | `CreateBylaw` | `council.bylaw.create` | 201 |
| GET | `/council/bylaws` | `ListBylaws` | `council.bylaw.list` | 200 |
| GET | `/council/bylaws/{bylawID}` | `GetBylaw` | `council.bylaw.read` | 200 |
| POST | `/council/meetings` | `CreateMeeting` | `council.meeting.create` | 201 |
| GET | `/council/meetings` | `ListMeetings` | `council.meeting.list` | 200 |
| GET | `/council/meetings/{meetingID}` | `GetMeeting` | `council.meeting.read` | 200 |
| PUT | `/council/meetings/{meetingID}/agenda` | `SetAgenda` | `council.agenda.set` | 200 |
| GET | `/council/meetings/{meetingID}/agenda` | `GetAgenda` | `council.agenda.read` | 200 |
| PUT | `/council/meetings/{meetingID}/minutes` | `SetMinutes` | `council.minutes.set` | 200 |
| POST | `/council/resolutions` | `CreateResolution` | `council.resolution.create` | 201 |
| GET | `/council/resolutions` | `ListResolutions` | `council.resolution.list` | 200 |
| GET | `/council/resolutions/{resolutionID}` | `GetResolution` | `council.resolution.read` | 200 |
| PATCH | `/council/meetings/{meetingID}` | `UpdateMeeting` | `council.meeting.update` | 200 |
| PATCH | `/council/resolutions/{resolutionID}` | `UpdateResolution` | `council.resolution.update` | 200 |
| PATCH | `/council/bylaws/{bylawID}` | `UpdateBylaw` | `council.bylaw.update` | 200 |
| GET | `/council/meetings/{meetingID}/minutes` | `GetMinutes` | `council.minutes.read` | 200 |

## Objects

| Object | Table role | Holds |
|---|---|---|
| bylaw | `council_bylaw` | title, year, text |
| meeting | `council_meeting` | name, date (YYYY-MM-DD), place, committee |
| agenda | `council_agenda` | one agenda per meeting |
| minutes | `council_minutes` | one set of minutes per meeting |
| resolution | `council_resolution` | a decision taken, tied to a meeting |

The full field list, with indexes, is in
[`council.blueprint.json`](../../council.blueprint.json); the instance's
domain mapping is [`council.wakala.json`](../../council.wakala.json).
