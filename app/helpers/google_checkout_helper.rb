module GoogleCheckoutHelper

  def google_checkout_button(merchant_id)    
    image_submit_tag(google_checkout_image_url, 
        :name => "Google Checkout", 
        :alt => "Fast checkout through Google",
        :height => 46, :width => 180 )
  end

  def google_checkout_image_url()
    img_src = Billing::GoogleCheckout.current[:use_sandbox] ?
      "http://sandbox.google.com/checkout/buttons/checkout.gif" :
      "https://checkout.google.com/buttons/checkout.gif"
    params_hash = {:merchant_id => merchant_id,  
              :w => 180, :h => 46, :style => "white",
              :variant => "text", :loc => "en_US" }
    params_str = params_hash.to_a.inject([]){|arr, p| arr << p.join('=')}.join('&')
    [img_src, params_str].join('?')
  end

  def google_checkout_image(options)
    image_tag(google_checkout_image_url, {:alt => 'Fast Checkout through Google', :height => 46, :width => 180}.merge(options))
  end

end
