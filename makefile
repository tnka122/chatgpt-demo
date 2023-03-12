.PHOENY: start
start:
	export $(shell cat .env | grep -v '^\s*#') && mix phx.server
