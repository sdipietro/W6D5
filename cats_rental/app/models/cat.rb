# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  birthdate   :date             not null
#  color       :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'action_view'
require 'action_view/helpers'

class Cat < ApplicationRecord

    COLORS = ["black", "white", "calico", "tabby", "gray", "orange"]
    
    def self.colors
        COLORS
    end

    include ActionView::Helpers::DateHelper

    validates :name, :birthdate, :color, :sex, :description, presence: true
    validates :color, inclusion: { in: Cat.colors, message: "%{value} is not a valid color" }
    validates :sex, inclusion: { in: %w(M F), message: "We're not that progressive. Please include either M or F."}

    has_many :rental_requests,
        class_name: :CatRentalRequest,
        primary_key: :id,
        foreign_key: :cat_id,
        dependent: :destroy

    def age
        age = Date.today.year - self.birthdate.year
        age -= 1 if Date.today < self.birthdate + age.years
        return age
    end

end
