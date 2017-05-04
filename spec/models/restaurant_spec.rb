require 'rails_helper'



RSpec.describe Restaurant, type: :model do

  before do
    User.create(email: 'freddy@gmail.lol', password: 'password', password_confirmation: 'password')
  end

  it 'is not valid with a name of less than three characters' do
    user = User.first
    restaurant = user.restaurants.new(name: "kf")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    user = User.first
    user.restaurants.create(name: "Moe's Tavern")
    restaurant = user.restaurants.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

end
