# Create categories
categories = ["Work", "Personal", "Shopping", "Health", "Learning"].map do |name|
  Category.find_or_create_by!(name: name)
end

puts "Created #{Category.count} categories"

# Create sample tasks
tasks_data = [
  {
    title: "Complete project proposal",
    description: "Write and submit the Q1 project proposal document",
    priority: "high",
    status: "in_progress",
    due_date: Date.today + 3.days,
    category: categories[0]
  },
  {
    title: "Buy groceries",
    description: "Milk, eggs, bread, vegetables",
    priority: "medium",
    status: "todo",
    due_date: Date.today + 1.day,
    category: categories[2]
  },
  {
    title: "Schedule dentist appointment",
    description: "Annual checkup",
    priority: "low",
    status: "todo",
    due_date: Date.today + 14.days,
    category: categories[3]
  },
  {
    title: "Learn TypeScript basics",
    description: "Complete online course modules 1-5",
    priority: "medium",
    status: "in_progress",
    due_date: Date.today + 7.days,
    category: categories[4]
  },
  {
    title: "Review pull requests",
    description: "Review pending PRs from team members",
    priority: "high",
    status: "done",
    due_date: Date.today - 1.day,
    category: categories[0]
  },
  {
    title: "Call mom",
    description: "Weekly catch-up call",
    priority: "medium",
    status: "todo",
    due_date: Date.today,
    category: categories[1]
  }
]

tasks_data.each do |task_attrs|
  Task.find_or_create_by!(title: task_attrs[:title]) do |task|
    task.description = task_attrs[:description]
    task.priority = task_attrs[:priority]
    task.status = task_attrs[:status]
    task.due_date = task_attrs[:due_date]
    task.category = task_attrs[:category]
  end
end

puts "Created #{Task.count} tasks"
