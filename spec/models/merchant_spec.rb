require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it {should have_many :items}
    it {should have_many(:order_items).through(:items)}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user_1 = User.create!(email: "123@gmail.com", password: "password", name: "Sebastian MikNijes", address: "456 Main St.", city: "Denver", state: "CO", zip: 80220, role: 1)
      @user_2 = User.create!(email: "789@gmail.com", password: "password", name: "Sebastian MikNijes", address: "456 Main St.", city: "LA", state: "CA", zip: 80220, role: 1)
      @order_1 = @user_1.orders.create!
      @order_2 = @user_2.orders.create!
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @giant, price: @giant.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @user_1.orders << @order_1
    end

    it '.item_count' do
      expect(@megan.item_count).to eq(2)
      expect(@brian.item_count).to eq(1)
      expect(@sal.item_count).to eq(0)
    end

    it '.average_item_price' do
      expect(@megan.average_item_price.round(2)).to eq(35.13)
      expect(@brian.average_item_price.round(2)).to eq(50.00)
    end

    it '.distinct_cities' do
      expect(@megan.distinct_cities).to eq(['Denver, CO', 'LA, CA'])
    end

    it '.item_quantity(order)' do
      expect(@megan.item_quantity(@order_1)).to eq(2)
      expect(@brian.item_quantity(@order_1)).to eq(3)
    end

    it '.item_total(order)' do
      expect(@megan.item_total(@order_1)).to eq(20.25)
    end

    it '.all_orders' do
      expect(@megan.all_orders).to eq([@order_1.id, @order_2.id]).or([@order_2.id, @order_1.id])
    end
  end
end
