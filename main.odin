package main

import entity "./entities"
import repo "./repositories"
import server "./server"
import "core:testing"

main :: proc() {
	PORT := 8080
	app := server.CreateApp(PORT)

	server.ListenApp(app)

	defer server.DestroyApp(app)
}
