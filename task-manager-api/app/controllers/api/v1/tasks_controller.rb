module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]

      def index
        @tasks = Task.includes(:category)
        @tasks = @tasks.where(status: params[:status]) if params[:status].present?
        @tasks = @tasks.where(priority: params[:priority]) if params[:priority].present?
        @tasks = @tasks.where(category_id: params[:category_id]) if params[:category_id].present?

        render json: @tasks, include: :category
      end

      def show
        render json: @task, include: :category
      end

      def create
        @task = Task.new(task_params)

        if @task.save
          render json: @task, include: :category, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render json: @task, include: :category
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :status, :due_date, :category_id)
      end
    end
  end
end
