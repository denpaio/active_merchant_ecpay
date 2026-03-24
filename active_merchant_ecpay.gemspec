# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_merchant_ecpay/version'

# rubocop:disable Layout/ExtraSpacing,Layout/SpaceAroundOperators
Gem::Specification.new do |spec|
  spec.name          = 'active_merchant_ecpay'
  spec.version       = ActiveMerchantEcpay::VERSION
  spec.authors       = ['Shi-Ken Don']
  spec.email         = ['shiken.don@gmail.com']

  spec.summary       = 'Active Merchant ECPay Integration'
  spec.description   = 'Add ECPay payment gateway to Active Merchant'
  spec.homepage      = 'https://github.com/denpaio/active_merchant_ecpay'

  spec.metadata['allowed_push_host'] = 'https://gems.denpa.io'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/denpaio/active_merchant_ecpay'
  spec.metadata['changelog_uri'] = 'https://github.com/denpaio/active_merchant_ecpay/commits/master'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob("{lib,exe}/**/*").select { |f| File.file?(f) } +
      %w[active_merchant_ecpay.gemspec Gemfile LICENSE README.md Rakefile]
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
# rubocop:enable Layout/ExtraSpacing,Layout/SpaceAroundOperators
