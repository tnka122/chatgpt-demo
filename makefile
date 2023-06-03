.PHOENY: start
start:
	@$(shell cat .env | grep -v '^\s*#') mix phx.server
