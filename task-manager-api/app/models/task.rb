class Task < ApplicationRecord
  belongs_to :category, optional: true

  PRIORITIES = %w[high medium low].freeze
  STATUSES = %w[todo in_progress done].freeze

  validates :title, presence: true
  validates :priority, inclusion: { in: PRIORITIES }
  validates :status, inclusion: { in: STATUSES }
end
