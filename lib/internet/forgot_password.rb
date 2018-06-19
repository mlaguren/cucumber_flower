module Internet
  class ForgotPassword 
    include Capybara::DSL
    
    def initialize
      has_current_path? '/forgot_password'
    end
    
    def enter_email ( email )
      fill_in("email", with:  email)
    end
  end
end
