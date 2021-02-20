# frozen_string_literal: true

module OffsitePayments
  module Integrations
    module Ecpay
      module HasTradeInfo
        # The shared module for return notification object
        def trade_info
          @trade_info ||= JSON.parse(params.to_json)
        rescue JSON::ParserError, TypeError
          {}
        end

        def verify_mac(trade_info = {})
          stringify_info = trade_info.stringify_keys
          check_mac_value = stringify_info.delete('CheckMacValue')

          make_mac(stringify_info) == check_mac_value
        end

        def make_mac(trade_info = {})
          raw = trade_info.sort_by { |k, _v| k.downcase }.map! { |k, v| "#{k}=#{v}" }.join('&')
          padded = "HashKey=#{Ecpay.hash_key}&#{raw}&HashIV=#{Ecpay.hash_iv}"
          url_encoded = CGI.escape(padded).downcase!
          Digest::SHA256.hexdigest(url_encoded).upcase!
        end
      end
    end
  end
end
