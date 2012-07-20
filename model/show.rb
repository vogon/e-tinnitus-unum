require 'sequel'

def init_model(db = DB)
	db.create_table? :shows do
		column :date, :Date
		String :bill
		String :venue
		String :raw
	end
end

class Show < Sequel::Model
end
