class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    if current_user.admin_role?
      @shifts = Shift.all.paginate(page: params[:page]).per_page(10)
      @completed_shifts = Shift.completed.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.upcoming.paginate(page: params[:page]).per_page(10)
    else
      @store = current_user.current_assignment.store
      @shifts = Shift.for_store(@store).paginate(page: params[:page]).per_page(10)
      @completed_shifts = Shift.completed.for_store(@store).paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.upcoming.for_store(@store).paginate(page: params[:page]).per_page(10)
    end
  end

  def show
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)

    if @shift.save
      redirect_to @shift, notice: "Shift was successfully created."
    else
      render :new
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to @shift, notice: "Shift was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @shift.date > Date.current && @shift.status == "pending"
      @shift.destroy
      redirect_to shifts_url, notice: "Shift was successfully destroyed."
    else
      flash[:alert] = "Cannot delete past or started shifts."
      render :show
    end
  end

  def time_clock
    @shift_today = current_user.shifts.find_by(date: Date.current)
    if @shift_today.nil?
      flash[:notice] = "You do not have any shifts today"
      redirect_to home_path
    end
  end

  def time_in
    @shift_today = current_user.shifts.find_by(date: Date.current)
    if @shift_today
      time_clock = TimeClock.new(@shift_today)
      time_clock.start_shift_at
      flash[:notice] = "Your shift has started."
    else
      flash[:notice] = "You do not have any shifts today"
    end
    redirect_to home_path
  end

  def time_out
    @shift_today = current_user.shifts.find_by(date: Date.current)
    if @shift_today
      time_clock = TimeClock.new(@shift_today)
      time_clock.end_shift_at
      # if @shift_today.start_time.strftime('%Y-%m-%d %H:%M') == @shift_today.end_time.strftime('%Y-%m-%d %H:%M')
      #   flash[:alert] = "Unable to end shift ( please wait at least 1 minute after shift started )"
      # else
      flash[:notice] = "Your shift has ended."
      # end
    else
      flash[:notice] = "You do not have any shifts today"
    end
    redirect_to home_path
  end
  
  private
 
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, :status)
  end
end