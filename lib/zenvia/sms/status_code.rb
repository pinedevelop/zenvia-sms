module Zenvia
  StatusCode = {
    '00' => :ok,
    '01' => :scheduled,
    '02' => :sent,
    '03' => :delivered,
    '04' => :not_received,
    '05' => :blocked_no_coverage,
    '06' => :blocked_black_listed,
    '07' => :blocked_invalid_number,
    '08' => :blocked_content_not_allowed,
    '09' => :blocked_message_expired,
    '10' => :error
  }.freeze
end
