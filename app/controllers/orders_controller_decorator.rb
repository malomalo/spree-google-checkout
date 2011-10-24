OrdersController.class_eval do
  helper :google_checkout
  include GoogleCheckout::ControllerExtender
  before_filter :clear_session, :only => [:show]
  
  def edit
    @order = current_order(true)
    @frontend = get_google_checkout_frontend 
    if @frontend     
      checkout_command = @frontend.create_checkout_command
      # Adding an item to shopping cart
      @order.line_items.each do |l|
        checkout_command.shopping_cart.create_item do |item|  
          item.name = l.product.name
          item.description = l.product.description
          item.unit_price = Money.new(100 * l.price, Billing::GoogleCheckout.current[:currency])    
          item.quantity = l.quantity
        end
      end
      checkout_command.shopping_cart.private_data = { 'order_number' => @order.id } 
      checkout_command.edit_cart_url = edit_order_url(@order)
      checkout_command.continue_shopping_url = order_url(@order, :checkout_complete => true)
   
      @response = checkout_command.to_xml #send_to_google_checkout

      # puts "===========#{request.raw_post}"
    end
  end
 
  private
  def clear_session
   session[:order_id] = nil
  end
end


