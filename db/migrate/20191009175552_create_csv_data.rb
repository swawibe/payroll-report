class CreateCsvData < ActiveRecord::Migration[5.2]
  def change
    create_table :csv_data do |t|
      t.date :date
      t.float :hours_worked
      t.string :job_group
      t.string :employee_id, index: true
      t.string :report_id, index: true
      t.integer :paying_period
      t.boolean :reported, default: false
      t.timestamps
    end
  end
end
