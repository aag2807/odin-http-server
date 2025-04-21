package server

import "core:fmt"
import "core:net"
import "core:strings"
import "core:thread"
import "core:time"

HTTP_RESPONSE :: "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n<html><body><h1>Hello from Odin HTTP Server!</h1></body></html>"

App :: struct {
	socket:   ^net.TCP_Socket,
	endpoint: net.Endpoint,
}

CreateApp :: proc(PORT: int) -> ^App {
	app := new(App)

	address := net.IP4_Address{0, 0, 0, 0}
	endpoint := net.Endpoint {
		address = address,
		port    = PORT,
	}

	socket, _ := net.listen_tcp(endpoint)

	net.set_option(socket, .Reuse_Address, true)
	app.endpoint = endpoint
	app.socket = new_clone(socket)

	return app
}

ListenApp :: proc(app: ^App) {
	app_ref := app^
	fmt.printf("listening on http://localhost:%v \n", app_ref.endpoint.port)

	for {
		client, source, error := net.accept_tcp(app_ref.socket^)
		fmt.printf("client connected: %v \n", app_ref.endpoint.address)
		thread.create_and_start_with_poly_data(client, HandleClient)
	}
}

DestroyApp :: proc(app: ^App) {
	if app == nil {
		return
	}

	net.close(app.socket^)
	free(app)
}

@(private)
HandleClient :: proc(socket: net.TCP_Socket) {
	defer net.close(socket)

	buffer := make([]byte, 4096)
	defer delete(buffer)

	bytes_read, read_error := net.recv_tcp(socket, buffer)
	if bytes_read <= 0 {
		return
	}

	response := transmute([]byte)string(HTTP_RESPONSE)
	bytes_sent, send_error := net.send_tcp(socket, response)

	fmt.println("bytes sent: %d", bytes_sent)
}
