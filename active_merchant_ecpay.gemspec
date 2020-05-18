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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
# rubocop:enable Layout/ExtraSpacing,Layout/SpaceAroundOperators
