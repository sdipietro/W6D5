# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ApplicationRecord
    VALIDATIONS = ["PENDING", "APPROVED", "DENIED"]

    def self.validations
        VALIDATIONS
    end

    validates :status, :cat_id, :start_date, :end_date, presence: true
    validates :status, inclusion: { in: CatRentalRequest.validations, message: "Not a valid status."}

    belongs_to :cat,
        class_name: :Cat,
        primary_key: :id,
        foreign_key: :cat_id

    def overlapping_requests
        requests = CatRentalRequests.select(*).where("cat_id = self.cat_id AND #{self.start_date} < start_date")
    end

end
