# CLAUDE.md - AI Assistant Guide for active_merchant_ecpay

## Project Overview

**active_merchant_ecpay** is a Ruby gem that provides ECPay payment gateway integration for Active Merchant. ECPay is a payment service provider popular in Taiwan.

- **Version**: 0.1.0
- **Author**: Shi-Ken Don
- **Repository**: https://github.com/denpaio/active_merchant_ecpay
- **Purpose**: Extend Active Merchant with ECPay offsite payment integration

## Codebase Structure

```
active_merchant_ecpay/
├── lib/
│   ├── active_merchant_ecpay.rb          # Main entry point
│   ├── active_merchant_ecpay/
│   │   └── version.rb                    # Version constant (0.1.0)
│   └── offsite_payments/
│       └── integrations/
│           └── ecpay/
│               ├── ecpay.rb              # Core module with configuration
│               ├── helper.rb             # Payment form helper
│               ├── notification.rb       # Payment notification handler
│               └── concern/
│                   └── has_trade_info.rb # Shared trade info & validation
├── bin/
│   ├── console                           # IRB console for development
│   └── setup                            # Setup script (bundle install)
├── active_merchant_ecpay.gemspec        # Gem specification
├── Gemfile                              # Bundler dependencies
├── Rakefile                             # Rake tasks
└── README.md                            # Project documentation

```

## Key Components

### 1. Main Module (`lib/active_merchant_ecpay.rb`)
- Entry point that requires version and ECPay integration
- Defines `ActiveMerchantEcpay::Error` exception class

**Location**: `/home/user/active_merchant_ecpay/lib/active_merchant_ecpay.rb:1`

### 2. ECPay Module (`lib/offsite_payments/integrations/ecpay.rb`)

Core module providing:
- **Configuration**: `merchant_id`, `hash_key`, `hash_iv` via `mattr_accessor`
- **Service URLs**: Different endpoints for production vs staging/test environments
- **Support Keys**: List of 65+ ECPay API parameters
- **Setup Method**: Block-based configuration interface

**Key Methods**:
- `service_url` - Returns appropriate ECPay endpoint based on mode (line 11-21)
- `notification(post, options)` - Creates notification object (line 23-25)
- `support_keys` - Lists all supported ECPay parameters (line 27-66)

**Environment Handling**:
- Production: `https://payment.ecpay.com.tw/Cashier/AioCheckOut/V5`
- Development/Staging/Test: `https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5`

### 3. Helper Class (`lib/offsite_payments/integrations/ecpay/helper.rb`)

Handles payment form generation:
- **Purpose**: Build and sign payment request data
- **Key Method**: `generate_signature` - Creates SHA256 checksum (line 32-39)
- **Form Fields**: Auto-generates fields with CheckMacValue signature (line 18-24)

**Signature Algorithm** (line 32-39):
1. Set default `MerchantID` and `EncryptType`
2. Create sorted messages including `HashKey` and `HashIV`
3. Build query string
4. URL encode and lowercase
5. Generate SHA256 hash and uppercase

### 4. Notification Class (`lib/offsite_payments/integrations/ecpay/notification.rb`)

Handles payment response callbacks:
- **Purpose**: Process and validate ECPay payment notifications
- **Includes**: `HasTradeInfo` module for validation
- **Key Methods**:
  - `valid?` - Verifies MAC signature (line 20-22)
  - `succeed?` - Checks if payment succeeded (`RtnCode == 1`) (line 24-26)
  - `order_id` - Returns `MerchantTradeNo` (line 32-34)
  - `gross` - Returns `TradeAmt` (line 36-38)
  - `trade_message` - Returns `RtnMsg` (line 40-42)

### 5. HasTradeInfo Concern (`lib/offsite_payments/integrations/ecpay/concern/has_trade_info.rb`)

Shared validation logic:
- **Purpose**: MAC signature generation and verification
- **Key Methods**:
  - `verify_mac(trade_info)` - Validates CheckMacValue (line 14-19)
  - `make_mac(trade_info)` - Generates CheckMacValue (line 21-26)

**MAC Generation Algorithm** (line 21-26):
1. Sort trade info by key (case-insensitive)
2. Build key=value pairs
3. Prepend `HashKey` and append `HashIV`
4. URL encode and lowercase
5. SHA256 hash and uppercase

## Code Conventions

### Ruby Style
1. **Frozen String Literals**: All files use `# frozen_string_literal: true`
2. **Rubocop**: Project uses Rubocop for linting (disabled in gemspec for spacing)
3. **Indentation**: 2 spaces (standard Ruby)
4. **Method Naming**: snake_case
5. **Module Organization**: Nested modules match directory structure

### Naming Patterns
- **Classes**: PascalCase (e.g., `Helper`, `Notification`)
- **Modules**: PascalCase (e.g., `Ecpay`, `HasTradeInfo`)
- **Methods**: snake_case (e.g., `generate_signature`, `verify_mac`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `VERSION`)

### TODO Comments
The codebase has TODO items for future improvements:
- `helper.rb:12` - Implement pure Ruby version of `underscore` method
- `notification.rb:14` - Implement pure Ruby version of `underscore` method

Currently relies on ActiveSupport's `underscore` method.

## Development Workflows

### Setup
```bash
bin/setup              # Install dependencies via bundle install
```

### Console
```bash
bin/console            # Launch IRB with gem loaded
```

### Common Tasks
```bash
bundle exec rake       # Run specs (default task)
bundle exec rake install  # Install gem locally
bundle exec rake release  # Release new version (tag + push)
```

### Testing
- Default rake task runs specs
- No test files currently present in repository (excluded via gemspec line 27)

## Git Workflow

### Branch Strategy
- **Main Branch**: Not explicitly specified in git status
- **Feature Branches**: Use descriptive names (e.g., `refactor-ecpay-and-implement-validation-methods`)
- **AI Branches**: Claude Code uses branches prefixed with `claude/` (e.g., `claude/claude-md-mi16wsjarcbap3dn-01DLFXpEL5i3iNQndRFpGH54`)

### Recent Development History
1. Implemented validation methods for notifications
2. Refactored Ecpay module into separate Helper and Notification files
3. Added trade message and amount methods
4. Updated rake dependency to ~> 13.0
5. Initial ECPay integration implementation

### Commit Message Style
Based on git history, use descriptive commit messages with:
- Action-oriented language (Add, Update, Refactor, Implement)
- Bullet points for multiple changes (using `*`)
- Clear descriptions of what changed and why

Example:
```
* Refactor Ecpay and separate module Helper and Notification from Ecpay
  into two files
* Implement validation methods for notifications
```

## Dependencies

### Runtime Dependencies
- None explicitly declared (relies on Active Merchant/OffsitePayments being present)

### Development Dependencies
- `bundler ~> 2.0`
- `rake ~> 13.0`

### Implicit Dependencies
- Active Merchant framework
- OffsitePayments integration
- ActiveSupport (for `underscore` method)
- Ruby standard library: `digest/sha2`, `cgi`, `json`

## Security Considerations

### Signature Validation
1. **Always verify signatures**: Use `Notification#valid?` before processing payments
2. **MAC Algorithm**: SHA256 hash with HashKey/HashIV padding
3. **URL Encoding**: Proper CGI.escape usage in signature generation
4. **Case Sensitivity**: Consistent lowercase for encoding, uppercase for final hash

### Configuration Security
- **Never commit**: `hash_key`, `hash_iv`, `merchant_id` credentials
- **Environment Variables**: Store credentials securely
- **Setup Pattern**:
  ```ruby
  OffsitePayments::Integrations::Ecpay.setup do |ecpay|
    ecpay.merchant_id = ENV['ECPAY_MERCHANT_ID']
    ecpay.hash_key = ENV['ECPAY_HASH_KEY']
    ecpay.hash_iv = ENV['ECPAY_HASH_IV']
  end
  ```

### Payment Validation
- Check `succeed?` method (verifies `RtnCode == 1`)
- Validate `merchant_id` matches expected value
- Verify `order_id` corresponds to expected order
- Check `gross` amount matches expected payment amount

## ECPay Integration Specifics

### Supported Payment Parameters
The gem supports 65+ ECPay parameters including:
- **Core**: `MerchantID`, `MerchantTradeNo`, `TotalAmount`, `TradeDesc`
- **Payment**: `ChoosePayment`, `ChooseSubPayment`, `PaymentType`
- **URLs**: `ReturnURL`, `ClientBackURL`, `OrderResultURL`, `PaymentInfoURL`
- **Custom**: `CustomField1-4`, `Remark`
- **Device**: `DeviceSource`, `Language`
- **Dates**: `ExpireDate`, `StoreExpireDate`, `MerchantTradeDate`
- **Invoice**: `InvoiceMark`

See `ecpay.rb:27-66` for complete list.

### Payment Flow
1. **Initiate Payment**: Create `Helper` instance with order details
2. **Generate Form**: Call `form_fields` to get signed parameters
3. **Submit to ECPay**: POST to `service_url`
4. **Receive Callback**: ECPay posts to your `ReturnURL`
5. **Validate Response**: Create `Notification`, verify with `valid?`
6. **Check Status**: Use `succeed?` to confirm payment
7. **Process Order**: Access `order_id`, `gross`, `trade_message`

## Common Patterns for AI Assistants

### When Adding New Features
1. **Read existing code first**: Understand current patterns before modifying
2. **Follow module structure**: Keep Helper/Notification separation
3. **Maintain signature compatibility**: Don't break MAC generation
4. **Use frozen string literals**: Add to all new files
5. **Match naming conventions**: Use snake_case for methods, PascalCase for classes

### When Fixing Bugs
1. **Check signature generation**: Most payment issues relate to MAC validation
2. **Verify parameter mappings**: Ensure ECPay parameter names match exactly
3. **Test both environments**: Production and staging URLs differ
4. **Validate encoding**: URL encoding must be lowercase before hashing

### When Refactoring
1. **Keep concerns separate**: Helper for requests, Notification for responses
2. **Extract shared logic**: Use concerns like `HasTradeInfo`
3. **Maintain backwards compatibility**: Public API should remain stable
4. **Update both Helper and Notification**: Payment parameters appear in both

### When Writing Tests
1. **Test signature generation**: Critical for payment security
2. **Mock ECPay responses**: Don't call live endpoints
3. **Verify all support_keys**: Ensure parameter mappings work
4. **Test validation logic**: Both `valid?` and `succeed?` methods

## File Modification Guidelines

### Never Modify Directly
- `.gitignore` - Only add new patterns if necessary
- `Gemfile.lock` - Managed by Bundler
- `bin/` scripts - Standard gem structure

### Modify with Caution
- `version.rb` - Only bump versions intentionally
- `gemspec` - Changes affect gem packaging
- `support_keys` - Must match ECPay API exactly

### Safe to Extend
- Helper methods - Add new payment parameter helpers
- Notification methods - Add new response accessors
- HasTradeInfo - Add validation utilities
- Documentation files

## API Reference Quick Links

### Configuration
```ruby
# lib/offsite_payments/integrations/ecpay.rb:72-74
OffsitePayments::Integrations::Ecpay.setup do |ecpay|
  ecpay.merchant_id = 'your_merchant_id'
  ecpay.hash_key = 'your_hash_key'
  ecpay.hash_iv = 'your_hash_iv'
end
```

### Creating Payment Form
```ruby
# lib/offsite_payments/integrations/ecpay/helper.rb:6-9
helper = OffsitePayments::Integrations::Ecpay::Helper.new(order_id, account, options)
helper.amount = 1000
helper.merchant_trade_no = 'ORDER123'
helper.form_fields # Returns signed parameters
```

### Processing Notifications
```ruby
# lib/offsite_payments/integrations/ecpay/notification.rb:9-11
notification = OffsitePayments::Integrations::Ecpay.notification(post_params)
if notification.valid? && notification.succeed?
  # Process successful payment
  order_id = notification.order_id
  amount = notification.gross
end
```

## Publishing and Release

### Gem Metadata
- **Push Host**: `https://gems.denpa.io` (custom gem server)
- **Homepage**: https://github.com/denpaio/active_merchant_ecpay
- **Source Code**: https://github.com/denpaio/active_merchant_ecpay
- **Changelog**: https://github.com/denpaio/active_merchant_ecpay/commits/master

### Release Process
1. Update `version.rb` with new version number
2. Run `bundle exec rake release`
3. Creates git tag for version
4. Pushes commits and tags to GitHub
5. Pushes `.gem` file to gems.denpa.io

## Questions to Ask Before Making Changes

1. **Does this change affect signature generation?** → Test thoroughly
2. **Are you adding new ECPay parameters?** → Add to `support_keys`
3. **Does this need to work in both Helper and Notification?** → Update both
4. **Is this a breaking change?** → Requires version bump
5. **Does this affect security?** → Review validation logic carefully
6. **Are you adding dependencies?** → Update gemspec
7. **Does this match ECPay's API documentation?** → Verify parameter names

## Resources

- **ECPay API Documentation**: Refer to ECPay's official API docs for parameter specifications
- **Active Merchant**: https://github.com/activemerchant/active_merchant
- **OffsitePayments**: Active Merchant's offsite payment integration framework

---

**Last Updated**: 2025-11-16
**For**: Claude Code and AI Assistants
**Maintainer**: Generated by AI assistant analysis
