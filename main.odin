package main

import server "./server"

main :: proc() {
	PORT := 8080
	app := server.CreateApp(PORT)

	server.ListenApp(app)

	defer server.DestroyApp(app)
}
