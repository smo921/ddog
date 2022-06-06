# frozen_string_literal: true

# Datadog Dashboards
module Dashboards
  def self.help
    'get dashboard <id>: Fetch dashboard by id'
  end

  def dashboard_api
    @dashboard_api ||= DatadogAPIClient::V1::DashboardsAPI.new
  end

  def get_dashboard(id)
    dashboard_api.get_dashboard(id)
  rescue DatadogAPIClient::V1::APIError, ArgumentError => e
    warn "Problem with dashboard: #{id}"
    warn e if @options[:verbose]
    {}
  end
end
