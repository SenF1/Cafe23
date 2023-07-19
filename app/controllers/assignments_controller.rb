class AssignmentsController < ApplicationController
    before_action :set_assignment, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource

    def index
        if current_user.employee_role?
            @current_assignments = Assignment.current.for_employee(current_user).chronological.paginate(page: params[:page]).per_page(10)
            @past_assignments = Assignment.past.for_employee(current_user).chronological.paginate(page: params[:page]).per_page(10)
        elsif current_user.manager_role?
            @store = current_user.current_assignment.store
            @current_assignments = Assignment.current.for_store(@store).chronological.paginate(page: params[:page]).per_page(10)
            @past_assignments = Assignment.past.for_store(@store).chronological.paginate(page: params[:page]).per_page(10)
        else
            @current_assignments = Assignment.current.chronological.paginate(page: params[:page]).per_page(10)
            @past_assignments = Assignment.past.chronological.paginate(page: params[:page]).per_page(10)
        end
    end

    def show
    end

    def new
        @assignment = Assignment.new
    end

    def create
        @assignment = Assignment.new(assignment_params)
        if @assignment.save
        flash[:notice] = "Successfully added the assignment."
        redirect_to assignments_path
        else
        render action: "new"
        end
    end

    def edit
    end

    def update
        if @assignment.update(assignment_params)
        flash[:notice] = "Updated assignment information."
        redirect_to assignments_path
        else
        render action: "edit"
        end
    end

    def destroy
        if @assignment.destroy
          flash[:notice] = "Removed assignment from the system."
          redirect_to assignments_path
        else
          render action: "show"
        end
    end

    private

    def set_assignment
        @assignment = Assignment.find(params[:id])
    end

    def assignment_params
        params.require(:assignment).permit(:store_id, :employee_id, :start_date, :end_date, :pay_grade_id)
    end
end
