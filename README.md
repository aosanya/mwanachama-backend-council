# mwanachama-backend-council

The record a council keeps of itself. A **meeting** is one sitting of the
council or of one of its committees. Each meeting can carry an **agenda** and
its **minutes**. A **resolution** is a decision the council took, and a
**bylaw** is a local rule it made, with its title, year and text.

A Go library in the declared-domain shape: objects in
[council.blueprint.json](council.blueprint.json), the route table in
[council.operations.json](council.operations.json), storage through
`mwanachama-backend-shared/specstore`, routes and MCP tools through
`mwanachama-backend-shared/dispatch`. No server of its own.

```go
s, _ := mwanachamacouncil.SpecFor("app")
_ = mwanachamacouncil.Provision(db, s)
cm, _ := mwanachamacouncil.NewCouncilManager(db, s)
for _, rt := range routes.RoutesFor(cm, routes.Mount{Caller: callerID}) {
	mux.HandleFunc(rt.Pattern("/council-svc"), rt.Handler)
}
```

```sh
make test    # sqlite, no database needed
make vet
```

See [documentation/](documentation/).
