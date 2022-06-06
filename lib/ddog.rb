# frozen_string_literal: true

require_relative 'resources'

# DDog main class
class DDog
  include Dashboards
  include Keys

  def initialize(options)
    @options = options
    @options[:eu] ? eu_conf : default_conf
  end

  def execute!(command, args)
    warn "calling #{command} with (#{args})" if @options[:verbose]
    args.empty? ? send(command.to_sym) : args.map { |a| send(command.to_sym, a).to_hash }
  rescue NoMethodError => e
    warn "Unknown command #{command}: #{e}"
  end

  def self.help
    [Dashboards.help, Keys.help].join("\n")
  end

  private

  def default_conf
    DatadogAPIClient::V1.configure do |config|
      config.api_key = ENV.fetch 'DD_API_KEY_US'
      config.application_key = ENV.fetch 'DD_APP_KEY_US'
      config.server_variables[:site] = 'datadoghq.com'
      # config.debugging = true
    rescue KeyError
      abort 'DD_API_KEY_US and DD_APP_KEY_US must be set.'
    end
  end

  def eu_conf
    DatadogAPIClient::V1.configure do |config|
      config.api_key = ENV.fetch 'DD_API_KEY_EU'
      config.application_key = ENV.fetch 'DD_APP_KEY_EU'
      config.server_variables[:site] = 'datadoghq.eu'
    rescue KeyError
      abort 'DD_API_KEY_EU and DD_APP_KEY_EU must be set.'
    end
  end

  def monitor_api
    @monitor_api ||= DatadogAPIClient::V1::MonitorsAPI.new
  end

  def log_indexes
    logapi = DatadogAPIClient::V1::LogsIndexesAPI.new
    logapi.list_log_indexes.indexes.map { |i| i.name.to_s }
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

  def get_user(name)
    DatadogAPIClient::V1::UsersAPI.new.get_user(name.first)
  end
end
