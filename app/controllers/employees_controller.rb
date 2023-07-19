class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    # finding all the active owners and paginating that list (will_paginate)
    @employees = Employee.all.paginate(page: params[:page]).per_page(15)
    
    if current_user.manager_role?
        @active_employees = Employee.active.alphabetical.joins(:assignments).where(assignments: { store_id: current_user.current_assignment.store_id }).paginate(page: params[:page]).per_page(15)
        @inactive_employees = Employee.inactive.alphabetical.joins(:assignments).where(assignments: { store_id: current_user.current_assignment.store_id }).paginate(page: params[:page]).per_page(15)
    else
        @active_employees = Employee.active.alphabetical.paginate(page: params[:page]).per_page(15)
        @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(15)
    end

  end

  def show
    @current_assignment = @employee.current_assignment
    @other_assignments = @employee.assignments.chronological.to_a - [@current_assignment]
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash[:notice] = "Successfully added #{@employee.proper_name} as an employee."
      redirect_to employee_path(@employee)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      flash[:notice] = "Updated #{@employee.proper_name}'s information."
      redirect_to employee_path(@employee)
    else
      render action: 'edit'
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: "Successfully removed #{@employee.proper_name} from the system."
    else
      flash[:error] = "This employee has worked shifts and cannot be deleted."
      render action: 'show'
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :phone, :date_of_birth, :role, :username, :password, :password_confirmation, :active)
  end
end