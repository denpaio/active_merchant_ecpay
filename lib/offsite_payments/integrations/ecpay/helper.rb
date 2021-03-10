# frozen_string_literal: true

module OffsitePayments
  module Integrations
    module Ecpay
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
    end
  end
end
