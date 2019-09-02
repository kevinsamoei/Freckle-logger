require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"

class FreckleHolidays
  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  APPLICATION_NAME = "Freckle".freeze
  CREDENTIALS_PATH = "credentials.json".freeze
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY


  def authorize
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
          "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  def holidays
    # Initialize the API
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    calendar_id = "en.ke#holiday@group.v.calendar.google.com"
    response = service.list_events(calendar_id,
                                  max_results:   1000,
                                  single_events: true,
                                  order_by:      "startTime",
                                  time_max:      DateTime.new(2021,1,1).rfc3339,
                                  time_min:      DateTime.new(2018,1,1).rfc3339)
    # puts "All holidays from 2018 till 2021"
    # puts "No events found" if response.items.empty?
    File.open('holidays.txt', 'w') do |f|
      response.items.each do |event|
        start = event.start.date || event.start.date_time
        f.puts(start)
        puts "- #{event.summary} (#{start})"
      end
    end
    # holiday_dates
  end
end
