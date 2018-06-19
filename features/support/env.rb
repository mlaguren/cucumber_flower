require 'csv'
require 'colorize'
require 'cucumber'
require 'rspec'
require 'faraday'
require 'capybara/cucumber'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'webdriver-highlighter'
require 'require_all'
require 'selenium-webdriver'
require 'yaml'
require 'logging'
require 'json'
require 'faker'
require 'i18n'
require 'uri'
require 'net/https'
require 'net/http/post/multipart'
require 'date'
require 'rspec/expectations'
require 'rake'
require 'geckodriver/helper'
require 'socket'
require 'capybara-screenshot/cucumber'
require_all 'lib'
Encoding.default_external = Encoding::UTF_8

Capybara.register_driver :selenium do |app|
  $hostname.eql?("cucumber_flower") ? (desired_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false, acceptSslCerts: true))
      : (desired_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(marionette: true, acceptInsecureCerts: true))
  Capybara::Selenium::Driver.new(app, browser: :firefox, listener: WebDriverHighlighter.new, desired_capabilities: desired_capabilities)
end


Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :selenium
  config.run_server = false
  config.default_selector = :css
  config.app_host = "http://the-internet.herokuapp.com/"
  config.default_max_wait_time = 15
end

if $hostname.eql?("cucumber_flower")
  require 'headless'

  $headless = Headless.new
  $headless.start
  puts "headless"
  at_exit do
    $headless.destroy
  end
end

