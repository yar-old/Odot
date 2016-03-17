require 'spec_helper'

describe "Deleting todo items" do
  let!(:todo_list) { TodoList.create(title: "Groceries", description: "Grocery list.") }
  let!(:todo_item) { todo_list.todo_items.create(content: "Milk") }

  def visit_todo_list(list)
    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "List items"
    end
  end

  it "is successful" do
    visit_todo_list(todo_list)

    within "#todo_item_#{todo_item.id}" do
      click_link "Delete"
    end

    expect(page).to have_content("Todo item was deleted.")
    expect(page).to_not have_content("Todo item could not be deleted.")
    expect(page).to_not have_content(todo_item.content)
    expect(TodoItem.count).to eq(0)
  end
end
