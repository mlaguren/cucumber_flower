Given(/^I am on the internet page$/) do
  @browser = Internet::MainPage.new
end

When(/^I select my passowrd$/) do
  @browser.select_topic("Forgot Password") 
  @browser = Internet::ForgotPassword.new
  @browser.enter_email "melvin.laguren@mbww.com"

  sleep 5
pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I am able to do something$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
