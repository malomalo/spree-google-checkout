require 'google4r/checkout'
require 'hmac-sha1'
require 'spree_core'

module SpreeGoogleCheckout
  class Engine < Rails::Engine
    engine_name 'spree_google_checkout'
    
    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end
    
    initializer "spree_google_checkout.register.payment_methods" do |app|
      app.config.spree.payment_methods << Billing::GoogleCheckout
    end

    config.to_prepare &method(:activate).to_proc
  end
end
