targets: init build

init: env.example
	./scripts/init.sh

build: .env
	./scripts/build.sh

install: init build up

up: .env
	./scripts/up.sh

test: .env
	./scripts/test.sh

down: .env
	./scripts/down.sh

clean: .env
	./scripts/cleanup.sh
