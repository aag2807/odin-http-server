package repositories

import "../entities"
import "core:fmt"

todolist := make([dynamic]entities.TodoItem, 0, 50)


AddTodoItem :: proc(item: entities.TodoItem) 
{
  append_elem(&todolist, item)
}

Removeitem :: proc(id: i32)
{
  for i:= 0; i < len(todolist); i += 1 
  {
    if todolist[i].id == id 
    {
      ordered_remove(&todolist, i) // remove the item from the list
      break
    }
  }
}

UpdateTodoItem :: proc(item: entities.TodoItem)
{
  assert(item.id != 0, "Item to update cannot have 0 value ID")

  for i:= 0; i < len(todolist); i += 1
  {
    if todolist[i].id == item.id 
    {
      todolist[i].title = item.title 
      todolist[i].completed = item.completed
      break
    }
  }
}

GetItemById :: proc(id: i32) -> ^entities.TodoItem
{
  for i:= 0; i < len(todolist); i += 1
  {
    if todolist[i].id == id
    {
      return &todolist[i] // return the item by reference
    }
  }

  return nil
}
