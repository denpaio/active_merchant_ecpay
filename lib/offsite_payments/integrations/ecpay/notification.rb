# frozen_string_literal: true

module OffsitePayments
  module Integrations
    module Ecpay
      class Notification < OffsitePayments::Notification
        include HasTradeInfo

        def initialize(post, options = {})
          super
        end

        Ecpay.support_keys.each do |parameter|
          # TODO: Use pure Ruby to implement #underscore
          define_method(parameter.underscore) do
            params[parameter]
          end
        end

        def valid?
          verify_mac trade_info
        end

        def succeed?
          @params['RtnCode'].to_i == 1
        end

        def merchant_id
          @params['MerchantID']
        end

        def order_id
          @params['MerchantTradeNo']
        end

        def gross
          @params['TradeAmt']
        end

        def trade_message
          @params['RtnMsg']
        end
      end
    end
  end
end
