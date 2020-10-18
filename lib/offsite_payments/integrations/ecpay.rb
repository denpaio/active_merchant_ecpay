# frozen_string_literal: true

# Reference: lib/offsite_payments/integrations/universal.rb
module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module Ecpay
      mattr_accessor :merchant_id
      mattr_accessor :hash_key
      mattr_accessor :hash_iv

      def self.service_url
        mode = OffsitePayments.mode
        case mode
        when :production
          'https://payment.ecpay.com.tw/Cashier/AioCheckOut/V5'
        when :development, :staging, :rc, :test
          'https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5'
        else
          raise StandardError, "Integration mode set to an invalid value: #{mode}"
        end
      end

      def self.notification(post, options = {})
        Notification.new(post, options)
      end

      def self.support_keys # rubocop:disable Metrics/MethodLength
        %w[
          MerchantID
          MerchantTradeNo
          StoreID
          MerchantTradeDate
          PaymentType
          TotalAmount
          TradeDesc
          ItemName
          ReturnURL
          ChoosePayment
          CheckMacValue
          ClientBackURL
          ItemURL
          Remark
          ChooseSubPayment
          OrderResultURL
          NeedExtraPaidInfo
          DeviceSource
          IgnorePayment
          PlatformID
          InvoiceMark
          CustomField1
          CustomField2
          CustomField3
          CustomField4
          EncryptType
          Language
          ExpireDate
          PaymentInfoURL
          ClientRedirectURL
          StoreExpireDate
          Desc_1
          Desc_2
          Desc_3
          Desc_4
          PaymentInfoURL
        ]
      end

      class Helper < OffsitePayments::Helper
        def initialize(order, account, options = {})
          super
        end

        Ecpay.support_keys.each do |parameter|
          # TODO: Use pure Ruby to implement #underscore
          mapping parameter.underscore.to_sym, parameter
        end

        mapping :amount, 'TotalAmount'

        def form_fields
          sign_fields
        end

        def sign_fields
          @fields.merge!('CheckMacValue' => generate_signature)
        end

        def messages
          @messages = @fields.slice(*Ecpay.support_keys).sort
          @messages.unshift(['HashKey', Ecpay.hash_key])
          @messages.push(['HashIV', Ecpay.hash_iv])
        end

        def generate_signature
          @fields['MerchantID'] ||= Ecpay.merchant_id
          @fields['EncryptType'] ||= 1

          query = messages.map { |key, value| [key, value].join('=') } * '&'
          encoded_url = CGI.escape(query).downcase
          Digest::SHA256.hexdigest(encoded_url).upcase
        end
      end

      class Notification < OffsitePayments::Notification
        def initialize(post, options = {})
          super
        end

        Ecpay.support_keys.each do |parameter|
          # TODO: Use pure Ruby to implement #underscore
          define_method(parameter.underscore) do
            params[parameter]
          end
        end

        def merchant_id
          @params['MerchantID']
        end
      end

      def self.setup
        yield(self)
      end
    end
  end
end
