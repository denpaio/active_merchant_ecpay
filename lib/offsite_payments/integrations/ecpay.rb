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

      require 'offsite_payments/integrations/ecpay/concern/has_trade_info'
      require 'offsite_payments/integrations/ecpay/helper'
      require 'offsite_payments/integrations/ecpay/notification'

      def self.setup
        yield(self)
      end
    end
  end
end
