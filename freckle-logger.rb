require 'freckle'
require 'date'
require_relative 'calendar'

class FreckleLogger

  # def initialize(token, hours, client_name, days)
  #   @token = token
  #   @hours = hours
  #   @client_name = client_name
  #   @days = days
  # end

  # attr_reader :token, :hours, :client_name, :days

  def log_hours
    dates.each do |date|
      valid_date = date.strftime('%F')
      client.create_entry(attributes(valid_date))
    end
    puts "Successfully logged hours"
  end

  private
  def client
    Freckle::Client.new(token: token)
  end

  def read_dates
    holiday_dates = []
    File.readlines('dates.txt').each do |line|
      holiday_dates << line
    end
    holiday_dates
  end

  # def holiday_dates
  #  FreckleHolidays.new.holidays 
  # end

  def dates
    valid = ( (Date.today - days)..(Date.today) ).select {|d| (1..5).include?(d.wday) }
    read_dates.each do |holiday|
      puts "holiday", holiday
      if valid.include?(holiday)
        valid.delete(holiday)
      end
    end
    valid
  end

  def project_id
    params = {name: client_name.to_s}
    projects = client.get_projects(params)

    projects[0].id
  end

  def attributes(date)
    {
      "date": date,
      "minutes": hours.to_i * 60,
      "description": "#clientEngagement, #partnerEngagement",
      "project_id": project_id
    }
  end
end
