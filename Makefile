.PHONY: build test vet clean

build:
	go build ./...

test:
	go test ./...

vet:
	go vet ./...

clean:
	rm -rf bin/
