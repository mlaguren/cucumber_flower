module Internet
  class MainPage
    include Capybara::DSL
    
    def initialize
      visit ''
    end
    
    def select_topic( link_name )
      click_link link_name
    end
  end
end
