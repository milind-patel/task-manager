class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.string :priority, default: 'medium'
      t.string :status, default: 'todo'
      t.date :due_date
      t.references :category, null: true, foreign_key: true

      t.timestamps
    end
  end
end
