targets: install init build

init: env.example
	./scripts/init.sh

build: .env
	./scripts/build.sh

install:
	./scripts/install.sh

up: .env auth/*.password
	./scripts/up.sh

test: .env
	./scripts/test.sh

down: .env
	./scripts/down.sh

clean: .env
	./scripts/cleanup.sh
