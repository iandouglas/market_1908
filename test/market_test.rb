require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'
require './lib/market'

class MarketTest < Minitest::Test
  def setup
    @market = Market.new("South Pearl Street Farmers Market")

    @vendor_1 = Vendor.new("Rocky Mountain Fresh")
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)

    @vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)

    @vendor_3 = Vendor.new("Palisade Peach Shack")
    @vendor_3.stock("Peaches", 65)
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_initialize
    assert_equal "South Pearl Street Farmers Market", @market.name
    assert_equal [], @market.vendors
  end

  def test_add_vendor
    @market.add_vendor(@vendor_2)
    @market.add_vendor(@vendor_1)
    @market.add_vendor(@vendor_3)

    assert_equal [@vendor_2, @vendor_1, @vendor_3], @market.vendors
  end

  def test_vendor_names
    add_vendors

    assert_equal [@vendor_1.name, @vendor_2.name, @vendor_3.name], @market.vendor_names
  end

  def test_vendors_that_sell_item
    add_vendors

    assert_equal [@vendor_1, @vendor_3], @market.vendors_that_sell("Peaches")
    assert_equal [@vendor_2], @market.vendors_that_sell("Banana Nice Cream")
    assert_equal [], @market.vendors_that_sell("Poutine")
  end

  def test_sorted_item_list
    add_vendors

    expected = ["Banana Nice Cream", "Peach-Raspberry Nice Cream", "Peaches", "Tomatoes"]
    assert_equal expected, @market.sorted_item_list
  end

  def test_total_inventory
    add_vendors

    expected = {"Peaches"=>100, "Tomatoes"=>7, "Banana Nice Cream"=>50, "Peach-Raspberry Nice Cream"=>25}
    assert_equal expected, @market.total_inventory
  end

  def test_cannot_sell_items
    add_vendors

    assert_equal false, @market.sell("Peaches", 200)
    assert_equal false, @market.sell("Onions", 1)
  end

  def test_can_sell_items_successfully
    add_vendors

    assert_equal 50, @vendor_2.check_stock("Banana Nice Cream")
    assert_equal true, @market.sell("Banana Nice Cream", 5)
    assert_equal 45, @vendor_2.check_stock("Banana Nice Cream")

    @market.sell("Peaches", 50)
    expected = {"Peaches"=>50, "Tomatoes"=>7, "Banana Nice Cream"=>45, "Peach-Raspberry Nice Cream"=>25}
    assert_equal expected, @market.total_inventory
    assert_equal 0, @vendor_1.check_stock("Peaches")
    assert_equal 50, @vendor_3.check_stock("Peaches")
  end


  # --- helpers ---
  def add_vendors
    @market.add_vendor(@vendor_1)
    @market.add_vendor(@vendor_2)
    @market.add_vendor(@vendor_3)
  end
end
