require 'freckle'
require 'date'

class FreckleLogger

  def initialize(token, hours, project_name, days)
    @token = token
    @hours = hours
    @project_name = project_name
    @days = days
  end

  attr_reader :token, :hours, :project_name, :days

  def client
    Freckle::Client.new(token: token)
  end

  def dates
    ( (Date.today - days)..(Date.today) ).select {|d| (1..5).include?(d.wday) }  
  end

  def project_id
    params = {name: project_name}
    projects = client.get_projects(params)

    projects[0].id
  end

  def attributes(date)
    {
      "date": date,
      "minutes": hours * 60,
      "description": "#clientEngagement, #partnerEngagement",
      "project_id": project_id
    }
  end

  def log_hours
    dates.each do |date|
      valid_date = date.strftime('%F')
      client.create_entry(attributes(valid_date))
    end
  end
end
