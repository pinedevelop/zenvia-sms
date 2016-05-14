module Zenvia
  class SMS
    class Error < StandardError
      attr_reader :status_code, :detail_code, :message

      def initialize(status_code, detail_code, message)
        @status_code = status_code
        @detail_code = detail_code
        @message = message
      end
    end
  end
end
