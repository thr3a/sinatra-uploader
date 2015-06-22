class CreatePhotos < ActiveRecord::Migration
	def change
		create_table(:photos) do |p|
			p.string :file
			p.string :comment
		end
	end
end
