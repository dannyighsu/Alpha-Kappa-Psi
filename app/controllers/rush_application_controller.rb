class RushApplicationController < ApplicationController

  def index
    @rush_events = RushEvent.all
  end

  def create
    @rushee = Rushee.find(params[:rush_application][:rushee_id])
    @rush_application = find_rush_application(@rushee)

    #No Previous Rush Application
    if @rush_application.nil?
      @rush_application = @rushee.build_rush_application(application_params(params[:rush_application]))
      if @rush_application.save
        flash.now[:success] = "Your application has been successfully submitted."
        render 'submitted'
        return
      else
        render 'new'
        return
      end
    #Updating Previous Rush Application
    else
      if @rush_application.update_attributes(application_params(params[:rush_application]))
        flash.now[:success] = "Your application has been successfully updated."
        render 'submitted'
        return
      else
        render 'new'
        return
      end
    end
  end

  def submitted

  end

  def print
     @rush_application = RushApplication.find(params[:id])
     @rushee = Rushee.find(@rush_application.rushee_id)
     if @rushee.password_digest != params[:confirmation]
       flash[:error] = 'You do not have sufficient privileges to access this page."'
       redirect_to root_url
     end
  end

  def new
    if !(params[:email].present? && params[:password].present?)
      flash.now[:notice] = 'Please enter both credentials to access the rush application.'
      render 'index'
      return
    end

    @rushee = Rushee.find_by(email: params[:email])
    if @rushee.nil?
      flash.now[:notice] = "This email has not yet been registered by a rushee. Please register at #{new_rushee_url}."
      render 'index'
    else
      if @rushee.authenticate(params[:password])
        @new_application = false
        @rush_application = find_rush_application(@rushee)
        if @rush_application.nil?
          @new_application = true
          @rush_application = @rushee.build_rush_application
          @rush_application.email = @rushee.email
          @rush_application.name = @rushee.name
          @rush_application.first_major = @rushee.major
          @rush_application.grade = @rushee.grade
        end
        return
      else
        flash.now[:notice] = "The password you have entered is incorrect. Please try again."
        render 'index'
      end
    end
  end

  def application_params(params)
    params.permit(:email, :phone_number, :address, :city, :state, :country, :zip_code, :grade,
                                             :first_major, :first_major_gpa, :second_major, :second_major_gpa, :third_major,
                                             :third_major_gpa, :cumulative_gpa, :intended_haas,
                                             :academic_schedule, :extracurricular_info, :name,
                                             :cover_letter, :resume, :transcript, :additional_transcript, :photograph)
  end

  def find_rush_application(rushee)
    return RushApplication.find_by(rushee_id: rushee.id)
  rescue
    nil
  end

end