class Admin::MerchantsController < Admin::BaseController

  def enable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: true)
    redirect_to merchants_path
    flash[:enable] = "#{@merchant.name} has been enabled"
  end

  def disable
    @merchant = Merchant.find(params[:id])
    @merchant.update(enabled: false)
    redirect_to merchants_path
    flash[:disable] = "#{@merchant.name} has now been disabled"
  end
end
