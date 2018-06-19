require 'uri'
require 'net/https'

Before do |scenario|
  if $hostname.eql?("cucumber_flower")
    $headless.video.start_capture
  end
  Dir.mkdir('log') unless File.directory?'log'
  @file_path_str = "log/" + scenario.name + ".log"
  File.new(@file_path_str, "w") unless File.exists?(@file_path_str)
  #$logger = Logging.logger(@file_path_str)
  #$logger.level = :all
  #Selenium::WebDriver.logger.output = @file_path_str
  #Selenium::WebDriver.logger.level = :debug
  Capybara::Screenshot.autosave_on_failure = false
  Capybara::Screenshot.prune_strategy = :keep_last_run
end

After do |scenario|
  if scenario.failed?
    Dir.mkdir("results") unless File.directory?"results"
    env_file_path = File.join("results", "#{$ENV_NAME}")
    Dir.mkdir(env_file_path) unless File.directory?(env_file_path)
    results_file_path = File.join("results", "#{$ENV_NAME}", "#{scenario.name.gsub(',', ' ').squeeze(" ").gsub(' ', '_')}")
    Dir.mkdir(results_file_path) unless File.directory?(results_file_path)
    if $hostname.eql?("cucumber_flower")
      video_file_name = "video_" + Time.now.strftime("%Y-%m-%d-%I-%M-%S")
      $headless.video.stop_and_save("#{results_file_path}/#{video_file_name}.mov")
    end
    Capybara.save_path = "#{results_file_path}"
    Capybara::Screenshot.screenshot_and_save_page
    File.open("error.html", 'w') { | file | file.write(page.html) }
    puts page.current_url
  else
    if $hostname.eql?("cucumber_flower")
      if ENV['RECORD_VIDEO']
        Dir.mkdir("results") unless File.directory?"results"
        env_file_path = File.join("results", "#{$ENV_NAME}")
        Dir.mkdir(env_file_path) unless File.directory?(env_file_path)
        results_file_path = File.join("results", "#{$ENV_NAME}", "#{scenario.name.gsub(',', ' ').squeeze(" ").gsub(' ', '_')}")
        Dir.mkdir(results_file_path) unless File.directory?(results_file_path)
        video_file_name = "video_" + Time.now.strftime("%Y-%m-%d-%I-%M-%S")
        $headless.video.stop_and_save("#{results_file_path}/#{video_file_name}.mov")
      else
        $headless.video.stop_and_discard
      end
    end
  end
  #$logger.close
end

After('@manual') do | scenario|

  if scenario.failed?
    steps = Dir.glob("manual_steps_tmp/test-step*.txt")
    steps.each do | file |
      FileUtils.rm(file)
    end
  end

end

After('@available_task') do
  #Send internal job url to dashboard.
  dashboard_url = "https://requestb.in/120hn481?url="
  dashboard_url_str = dashboard_url + $url
  uri = URI(dashboard_url_str)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  req = Net::HTTP::Post.new(uri)
  res = https.request(req)
end
