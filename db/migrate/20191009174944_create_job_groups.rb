class CreateJobGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :job_groups do |t|
      t.string :group_name
      t.float :paying_rate
      t.timestamps
    end
  end
end
