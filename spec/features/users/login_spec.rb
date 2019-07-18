require "rails_helper"

RSpec.describe "User Login" do
  describe "As a user" do

    it "When I visit the login path I see a field to enter my email address and password" do
      user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "123@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(user.role).to eq("registered_user")
      expect(current_path).to eq(user_profile_path(user))
      expect(page).to have_content("You are now Logged in #{user.name}")
    end

    it "If I am a merchant user, I am redirected to my merchant dashboard page" do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      merchant = megan.users.create!(email: "merchant@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "merchant@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")

      expect(merchant.role).to eq("registered_user")
      expect(current_path).to eq(merchant_dashboard_path)
      expect(page).to have_content("You are now Logged in #{merchant.name}")
    end

    it "If I am a admin user, I am redirected to my admin dashboard page" do
      admin = User.create!(email: "admin@gmail.com", password: "password", name: "Tom", role: 3, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

      visit login_path
      fill_in "email", with: "admin@gmail.com"
      fill_in "password", with: "password"

      click_button("Login")


      expect(admin.role).to eq("admin")
      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("You are now Logged in #{admin.name}")
    end

    it "When I visit the logout path, I am redirected to the root page of the site and I see that my cart has been emptied" do
      visit logout_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are now Logged out.")
      expect(page).to have_content("Cart: 0")
    end

    describe "As a registered user, merchant, or admin" do
      describe "When I visit the login path" do
        it "If I am a regular user, I am redirected to my profile page" do
          user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
          visit login_path
          fill_in "email", with: "123@gmail.com"
          fill_in "password", with: "password"

          click_button("Login")
          visit login_path

          expect(current_path).to eq(user_profile_path(user))
          expect(page).to have_content("You are already logged in")
        end

        it "If I am merchant user, I am redirected to my merchant dashboard page" do
          megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
          merchant = megan.users.create!(email: "merchant@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
          visit login_path

          fill_in "email", with: "merchant@gmail.com"
          fill_in "password", with: "password"
          click_button("Login")

          visit login_path
          expect(current_path).to eq(merchant_dashboard_path)
          expect(page).to have_content("You are already logged in")
        end

        it "If I am merchant admin user, I am redirected to my merchant dashboard page" do
          megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
          merchant = megan.users.create!(email: "merchant@gmail.com", password: "password", name: "Tom", role: 2, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)
          visit login_path

          fill_in "email", with: "merchant@gmail.com"
          fill_in "password", with: "password"
          click_button("Login")

          visit login_path
          expect(current_path).to eq(merchant_dashboard_path)
          expect(page).to have_content("You are already logged in")
        end
#

        it "If I am a admin user, I am redirected to my admin dashboard page" do
          admin = User.create!(email: "admin@gmail.com", password: "password", name: "Tom", role: 3, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

          visit login_path
          fill_in "email", with: "admin@gmail.com"
          fill_in "password", with: "password"

          click_button("Login")
          visit login_path
          expect(current_path).to eq(admin_dashboard_path)
          expect(page).to have_content("You are already logged in")
        end
      end

      describe "When I visit the login page and submit invalid info" do
        it "I am redirected to the login page and I see a flash message that tells me that my creds were incorrect" do
          user = User.create!(email: "123@gmail.com", password: "password", name: "Tom", role: 1, address: "123 Main St.", city: "Denver", state: "Colorado", zip: 80220)

          visit login_path
          fill_in "Email", with: "123@gmail.com"
          fill_in "Password", with: "passwork"
          click_button("Login")

          expect(current_path).to eq(login_path)
          expect(page).to have_content("Email/Password incorrect.")
        end
      end
    end
  end
end
