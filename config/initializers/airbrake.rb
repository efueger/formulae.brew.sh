if ENV.include? 'AIRBRAKE_API_KEY'
  Airbrake.configure do |config|
    config.project_id = ENV['AIRBRAKE_PROJECT_ID']
    config.project_key = ENV['AIRBRAKE_API_KEY']
  end

  Airbrake.add_filter do |notice|
    if notice[:errors].any? { |error| error[:type] == 'ActionController::BadRequest' }
      notice.ignore!
    end
  end

  Airbrake.add_filter do |notice|
    begin
      route = Rails.application.routes.recognize_path notice[:params]['url']
      route[:action] == 'not_found' || route[:action] == 'forbidden'
    rescue ActionController::RoutingError
      notice.ignore!
    end
  end
end
