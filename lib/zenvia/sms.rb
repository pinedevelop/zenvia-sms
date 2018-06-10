require 'rest-client'
require 'zenvia/configuration'
require 'zenvia/sms/detail_code'
require 'zenvia/sms/error'
require 'zenvia/sms/status_code'
require 'zenvia/sms/version'

module Zenvia
  class SMS
    BASE_URL = 'https://api-rest.zenvia.com/services'.freeze

    def initialize(from: nil, to:, message:, callback: nil, id: nil, aggregate_id: nil)
      @from = from
      @to = to
      @message = message
      @callback = callback
      @id = id
      @aggregate_id = aggregate_id
    end

    def deliver
      send
    end

    def schedule(time)
      send(schedule_for: time)
    end

    def cancel
      SMS.cancel(@id)
    end

    private

    def send(schedule_for: nil)
      schedule = schedule_for.strftime('%FT%T') if schedule_for

      data = {
        sendSmsRequest: {
          from: @from,
          to: @to,
          schedule: schedule,
          msg: @message,
          callbackOption: @callback,
          id: @id,
          aggregateId: @aggregate_id
        }
      }

      SMS.to_zenvia('send-sms', data.to_json)
    end

    class << self

      def cancel(id)
        SMS.to_zenvia("cancel-sms/#{id}", nil, :blocked)
      end

      def to_zenvia(endpoint, json_data, expected_status = :ok)
        json_response = RestClient.post "#{BASE_URL}/#{endpoint}", json_data, default_headers
        response = JSON.parse(json_response).values.first

        status_code = StatusCode[response['statusCode']]
        detail_code = DetailCode[response['detailCode']]

        raise Error.new(status_code, detail_code, response['detailDescription']) unless status_code == expected_status

        response
      end

      def default_headers
        {
          content_type: 'application/json',
          authorization: "Basic #{Zenvia.config.authorization}",
          accept: 'application/json'
        }
      end
    end
  end
end
