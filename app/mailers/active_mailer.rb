#Acts like a controller and passes information on to its respective views
# Views are located in app/views/active_mailer/xxx_email
# Views are coded in HTML or TXT (plain text)
class ActiveMailer < ActionMailer::Base

  #Constants for email headers
  AKPSI_HEADER = '[Alpha Kappa Psi]'
  CONTACT_HEADER = '[Contact Request]'
  WATCHDOG_HEADER = '[AKPsi Watchdog]'

  default from: "rush@calakpsi.com"
  default to: "rush@calakpsi.com"

  #Welcome email instance variables, uses a user, root_url
  # uses to: to send it to specified email and subject: for subject line.
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "#{AKPSI_HEADER} #{user.name}, Welcome to Alpha Kappa Psi - Alpha Beta Chapter")
  end

  #Activation email instance variables
  def activation_email(user)
    @user = user
    mail(to: @user.email, subject: "#{AKPSI_HEADER} You've been approved as an active at Alpha Kappa Psi's Alpha Beta Chapter")
  end

  #Contact Request Email
  def contact_email(contact_request)
    @contact_request = contact_request
    mail(subject: "#{CONTACT_HEADER} - #{@contact_request.name} - #{@contact_request.subject}", from: @contact_request.email)
  end

  # Watchdog Email
  def watchdog_email(watchdog_entry)
    @watchdog_entry = watchdog_entry
    mail(subject: "#{WATCHDOG_HEADER} - #{@watchdog_entry.subject}", to: "calakpsiwatchdog@gmail.com")
  end

  #Rushee signup email
  def rushee_signup_email(rushee)
    @rushee = rushee
    @rush_events = RushEvent.all
    mail(to: @rushee.email, subject: "#{AKPSI_HEADER} You have been successfully enrolled into Alpha Kappa Psi's Rush Process")
  end

  #Rushee Application Submission Confirmation Email
  def app_confirmation_email(updated, rushee, rush_app)
    @rushee = rushee
    @rush_application = rush_app
    @subject = "#{AKPSI_HEADER} Rush Application Submission Confirmation"

    if updated
      @subject = "#{AKPSI_HEADER} Rush Application Update Confirmation"
    end

    #If Emails from rushee signup and rush application are different, send to both.
    if @rushee.email != @rush_application.email
      mail(to: @rush_application.email, subject: "#{@subject}")
    end

    mail(to: @rushee.email, subject: "#{@subject}")
  end

  def interview_confirmation_email(rushee, interview_slot)
    @rushee = rushee
    @scheduled_slot = interview_slot
    @subject = "#{AKPSI_HEADER} Professional Interview Confirmation"

    mail(to: @rushee.email, subject: "#{@subject}")
  end

  def rushee_email(email_to_rushee, rushee_email, rushee_name)
    @body = email_to_rushee.body.gsub '$FULL_NAME$', rushee_name
    @body.gsub! '$FIRST_NAME$', rushee_name.split[0]
    @body.gsub! '$LAST_NAME$', rushee_name.split[1..-1].join(' ')
    mail(to: rushee_email, subject: "#{email_to_rushee.subject}")
  end

end
