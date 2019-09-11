class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.find_all { |vendor| vendor.check_stock(item) > 0 }
  end

  def sorted_item_list
    @vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten.uniq.sort
  end

  def total_inventory
    market_inventory = Hash.new(0)
    @vendors.each do |vendor|
      market_inventory.merge!(vendor.inventory) do |key, oldval, newval|
        newval + oldval
      end
    end
    market_inventory
  end

  def sell(item, quantity)
    return false if total_inventory[item] < quantity

    vendors_that_sell(item).each do |vendor|
      new_quantity = [vendor.check_stock(item), quantity].min
      vendor.stock(item, new_quantity * -1)
      quantity -= new_quantity
      if quantity == 0
        break
      end
    end
    true
  end
end
