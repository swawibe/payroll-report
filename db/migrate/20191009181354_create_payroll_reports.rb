class CreatePayrollReports < ActiveRecord::Migration[5.2]
  def change
    create_table :payroll_reports do |t|
      t.string :employee_id, index: true
      t.string  :pay_period
      t.float	:amount_paid
      t.string :report_id
      t.timestamps
    end
  end
end
