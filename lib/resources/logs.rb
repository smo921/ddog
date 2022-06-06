# frozen_string_literal: true

# Datadog Logs
module Logs
  def self.help
    <<~HELP
      Logs:
        log indexes: Fetch all log index names
    HELP
  end

  def log_indexes
    logapi = DatadogAPIClient::V1::LogsIndexesAPI.new
    logapi.list_log_indexes.indexes.map { |i| i.name.to_s }
  end
end
