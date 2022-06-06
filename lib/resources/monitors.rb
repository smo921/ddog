# frozen_string_literal: true

# Datadog Monitor resources
module Monitors
  def self.help
    <<~HELP
      Monitors
        get monitor <id>: fetch the monitor from Datadog
    HELP
  end

  def monitor_api
    @monitor_api ||= DatadogAPIClient::V1::MonitorsAPI.new
  end

  def monitors
    monitor_api.list_monitors
  end

  def get_monitor(id)
    monitor_api.get_monitor(id)
  rescue DatadogAPIClient::V1::APIError => e
    warn "Problem with monitor: #{id}"
    warn e if @options[:verbose]
    {}
  end
end
