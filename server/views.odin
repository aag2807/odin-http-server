package server

import "core:fmt"
import "core:os"
import "core:strings"

HTMLView :: struct {
	content: string,
	header:  string,
}

@(private)
NewView :: proc(viewname: string) -> HTMLView {
	cwd := os.get_current_directory()
	file_path := fmt.aprintf("%v\\views\\%v", cwd, viewname)

	content, ok := os.read_entire_file(file_path, context.temp_allocator)
	if !ok {
		return HTMLView{"", ""}
	}

	defer delete(content, context.temp_allocator)

	return HTMLView{string(content), PrepareViewHeaders()}
}

@(private)
CreateHTMLFromView :: proc(view: HTMLView) -> string {
	sb: strings.Builder
	fmt.sbprintln(&sb, view.header)
	fmt.sbprintln(&sb, view.content)

	return fmt.sbprint(&sb)
}


@(private)
PrepareViewHeaders :: proc() -> string {
	sb := strings.Builder{}
	fmt.sbprintln(&sb, "HTTP/1.1 200 OK")
	fmt.sbprintln(&sb, "Content-Type: text/html")
	fmt.sbprintln(&sb, "Connection: close")

	return fmt.sbprint(&sb)
}
