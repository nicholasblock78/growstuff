require 'spec_helper'

describe OrderItemsController do

  login_member(:admin_member)

  before(:each) do
    @member = FactoryGirl.create(:member)
    sign_in @member
    @product = FactoryGirl.create(:product)
    @order = FactoryGirl.create(:order, :member => @member)
    @order_item = FactoryGirl.create(:order_item,
      :order => @order,
      :product => @product,
      :price => @product.min_price
    )
  end

  describe "POST create" do

    describe "with valid params" do
      it "creates a new OrderItem" do
        @order = FactoryGirl.create(:order, :member => @member)
        expect {
          post :create, {:order_item => {
            :order_id => @order.id,
            :product_id => @product.id,
            :price => @product.min_price
          }}
        }.to change(OrderItem, :count).by(1)
      end

      it "assigns a newly created order_item as @order_item" do
        @order = FactoryGirl.create(:order, :member => @member)
        post :create, {:order_item => {
          :order_id => @order.id,
          :product_id => @product.id,
          :price => @product.min_price
        }}
        assigns(:order_item).should be_a(OrderItem)
        assigns(:order_item).should be_persisted
      end

      it "redirects to order" do
        @order = FactoryGirl.create(:order, :member => @member)
        post :create, {:order_item => {
          :order_id => @order.id,
          :product_id => @product.id,
          :price => @product.min_price
        }}
        response.should redirect_to(OrderItem.last.order)
      end

      it 'creates an order for you' do
        @member = FactoryGirl.create(:member)
        sign_in @member
        @product = FactoryGirl.create(:product)
        expect {
          post :create, {:order_item => {
            :product_id => @product.id,
            :price => @product.min_price
          }}
        }.to change(Order, :count).by(1)
        OrderItem.last.order.should be_an_instance_of Order
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved order_item as @order_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        OrderItem.any_instance.stub(:save).and_return(false)
        post :create, {:order_item => { "order_id" => "invalid value" }}
        assigns(:order_item).should be_a_new(OrderItem)
      end

      it "sends you back to the shop" do
        # Trigger the behavior that occurs when invalid params are submitted
        OrderItem.any_instance.stub(:save).and_return(false)
        post :create, {:order_item => { "order_id" => "invalid value" }}
        response.should redirect_to(shop_path)
      end
    end
  end

  describe "PUT update" do

    # we've said nobody can update an OrderItem; in future, we might
    # want to delete all this code, but I wanted to wait just in case we
    # needed it.
    before(:each) { pending("we don't permit this (see app/model/ability.rb") }

    describe "with valid params" do

      it "updates the requested order_item" do
        OrderItem.any_instance.should_receive(:update_attributes).with({ "order_id" => "1" })
        put :update, {:id => @order_item.to_param, :order_item => { "order_id" => "1" }}
      end

      it "assigns the requested order_item as @order_item" do
        put :update, {:id => @order_item.to_param, :order_item => {
          :order_id => @order.id,
          :product_id => @product.id,
          :price => @product.min_price
        }}
        assigns(:order_item).should eq(@order_item)
      end

      it "redirects to the order_item" do
        put :update, {:id => @order_item.to_param, :order_item =>  {
          :order_id => @order.id,
          :product_id => @product.id,
          :price => @product.min_price
        }}
        response.should redirect_to(@order_item.order)
      end
    end

    describe "with invalid params" do
      it "assigns the order_item as @order_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        OrderItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => @order_item.to_param, :order_item => { "order_id" => "invalid value" }}
        assigns(:order_item).should eq(@order_item)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        OrderItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => @order_item.to_param, :order_item => { "order_id" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    # we've said nobody can update an OrderItem; in future, we might
    # want to delete all this code, but I wanted to wait just in case we
    # needed it.
    before(:each) { pending("we don't permit this (see app/model/ability.rb") }

    it "destroys the requested order_item" do
      expect {
        delete :destroy, {:id => @order_item.to_param}
      }.to change(OrderItem, :count).by(-1)
    end

    it "redirects to the order_items list" do
      delete :destroy, {:id => @order_item.to_param}
      response.should redirect_to(order_items_url)
    end
  end

end
