require 'spec_helper'

describe "Editing todo items" do
  let!(:todo_list) { TodoList.create(title: "Groceries", description: "Grocery list.") }
  let!(:todo_item) { todo_list.todo_items.create(content: "Milk") }

  def visit_todo_list(list)
    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "List items"
    end
  end

  it "is succcessful with valid content" do
    visit_todo_list(todo_list)

    within "#todo_item_#{todo_item.id}" do
      click_link "Edit"
    end

    fill_in "Content", with: "Lots of Milk"
    click_button "Save"

    expect(page).to have_content("Saved todo list item.")
    todo_item.reload

    expect(todo_item.content).to eq("Lots of Milk")
  end

  it "displays an error with no content" do
    visit_todo_list(todo_list)

    within "#todo_item_#{todo_item.id}" do
      click_link "Edit"
    end

    fill_in "Content", with: ""
    click_button "Save"

    expect(page).to_not have_content("Saved todo list item.")
    expect(page).to have_content("Content can't be blank")
    expect(page).to have_content("That todo item could not be saved.")

    todo_item.reload
    expect(todo_item.content).to eq("Milk")
  end

  it "displays an error with not enough content" do
    visit_todo_list(todo_list)

    within "#todo_item_#{todo_item.id}" do
      click_link "Edit"
    end

    fill_in "Content", with: "1"
    click_button "Save"

    expect(page).to_not have_content("Saved todo list item.")
    expect(page).to have_content("Content is too short")
    expect(page).to have_content("That todo item could not be saved.")

    todo_item.reload
    expect(todo_item.content).to eq("Milk")
  end

end
