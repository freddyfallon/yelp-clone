require 'rails_helper'

feature 'restaurants' do
  before do
    User.create(email: 'freddy@gmail.lol', password: 'password', password_confirmation: 'password')
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: 'freddy@gmail.lol'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
    end
  end

  context 'restaurants have been added' do
    before do
      user = User.first
      user.restaurants.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then dsipalys the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
   end

  context 'viewing restaurants' do
    before do
      user = User.first
      user.restaurants.create(name: 'KFC', description: 'deep fried chillvibes')
    end

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{Restaurant.last.id}"
    end
  end

  context 'editing restaurants' do

    before do
      user = User.first
      user.restaurants.create(name: 'KFC', description: 'Deep fried goodness')
    end

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      click_link 'Kentucky Fried Chicken'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq "/restaurants/#{Restaurant.last.id}"
    end

    scenario "does not let a user edit a restaurant that they don't own" do
      visit '/restaurants'
      click_link 'Sign out'
      click_link 'Sign up'
      fill_in 'Email', with: 'otheruser@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_button 'Sign up'
      expect(page).not_to have_link 'Edit KFC'
    end
  end

  context 'deleting restaurants' do

    before do
      user = User.first
      user.restaurants.create(name: 'KFC')
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario "does not let a user delete a restaurant that they don't own" do
      visit '/restaurants'
      click_link 'Sign out'
      click_link 'Sign up'
      fill_in 'Email', with: 'otheruser@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_button 'Sign up'
      expect(page).not_to have_link 'Delete KFC'
    end
  end

end
