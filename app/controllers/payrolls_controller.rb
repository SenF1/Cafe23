class PayrollsController < ApplicationController
  before_action :check_login

  def store_form
    authorize! :store_form, :payrolls_controller
    render :store_form
  end

  def employee_form
    authorize! :employee_form, :payrolls_controller
    render :employee_form
  end

  def store_payroll
    @store = current_user.current_assignment.store if current_user.manager_role?
    @store ||= Store.find(params[:store_id])
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    date_range = DateRange.new(@start_date, @end_date)
    calculator = PayrollCalculator.new(date_range)
    @store_payroll = calculator.create_payrolls_for(@store)
    render :store_payroll
  end

  def employee_payroll
    # puts params.inspect
    # payroll_report_params = params.require(:employee_payroll).permit(:employee_id, :start_date, :end_date)
    @employee = Employee.find(params[:employee_id])
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    date_range = DateRange.new(@start_date, @end_date)
    calculator = PayrollCalculator.new(date_range)
    @employee_payroll = calculator.create_payroll_record_for(@employee)
    render :employee_payroll
  end

end