import type { Task, TaskFormData, Category, CategoryFormData } from '../types';

const API_BASE_URL = 'http://localhost:3000/api/v1';

async function handleResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const error = await response.json().catch(() => ({ error: 'An error occurred' }));
    throw new Error(error.errors?.join(', ') || error.error || 'An error occurred');
  }
  if (response.status === 204) {
    return undefined as T;
  }
  return response.json();
}

export const taskApi = {
  async getAll(filters?: { status?: string; priority?: string; category_id?: number }): Promise<Task[]> {
    const params = new URLSearchParams();
    if (filters?.status) params.append('status', filters.status);
    if (filters?.priority) params.append('priority', filters.priority);
    if (filters?.category_id) params.append('category_id', filters.category_id.toString());

    const url = `${API_BASE_URL}/tasks${params.toString() ? `?${params}` : ''}`;
    const response = await fetch(url);
    return handleResponse<Task[]>(response);
  },

  async getById(id: number): Promise<Task> {
    const response = await fetch(`${API_BASE_URL}/tasks/${id}`);
    return handleResponse<Task>(response);
  },

  async create(task: TaskFormData): Promise<Task> {
    const response = await fetch(`${API_BASE_URL}/tasks`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ task }),
    });
    return handleResponse<Task>(response);
  },

  async update(id: number, task: Partial<TaskFormData>): Promise<Task> {
    const response = await fetch(`${API_BASE_URL}/tasks/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ task }),
    });
    return handleResponse<Task>(response);
  },

  async delete(id: number): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/tasks/${id}`, {
      method: 'DELETE',
    });
    return handleResponse<void>(response);
  },
};

export const categoryApi = {
  async getAll(): Promise<Category[]> {
    const response = await fetch(`${API_BASE_URL}/categories`);
    return handleResponse<Category[]>(response);
  },

  async create(category: CategoryFormData): Promise<Category> {
    const response = await fetch(`${API_BASE_URL}/categories`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ category }),
    });
    return handleResponse<Category>(response);
  },

  async delete(id: number): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/categories/${id}`, {
      method: 'DELETE',
    });
    return handleResponse<void>(response);
  },
};
