class PayrollReport < ApplicationRecord

  # ----------------------------------------------------------------------
  # == Class methods == #
  # ----------------------------------------------------------------------

  def self.generate_report
    # Fetching all job groups from a table and making a hash from them
    job_groups = JobGroup.pluck(:group_name, :paying_rate).to_h

    # processed_data contains array of [[report_id, employee_id, job_group, year, month, paying_period"], hours_worked]
    # This Active record query is much faster than processing individual row from CsvData
    processed_data = CsvData.unreported
                            .group(:report_id, :employee_id, :job_group)
                            .order(:employee_id, :date)
                            .group("strftime('%Y', date)", "strftime('%m', date)")
                            .group(:paying_period)
                            .sum(:hours_worked)

    processed_data.each do |data, hours_worked|
      job_group = data[2]

      # Calculate amount_paid from job groups and total worked hours
      amount_paid = PayrollReport.calculate_amount(job_groups[job_group], hours_worked)

      # Build date range string of pay period
      pay_period = PayrollReport.build_paying_period(data[3], data[4], data[5])

      PayrollReport.create(report_id: data[0], employee_id: data[1],
                           pay_period: pay_period, amount_paid: amount_paid)

      # Updating all CSV data as reported, so that, in the future we don't have to do these calculation again
      CsvData.update_all reported: true
    end
  end

  # Calculate amount_paid from job group's paying rate and total worked hours
  def self.calculate_amount(paying_rate, hours_worked)
    paying_rate.to_f * hours_worked.to_f
  end

  # Generates Paying period string from year, month, and paying period
  def self.build_paying_period(year, month, paying_period)
    if paying_period == 'first_half'
      "1/#{month}/#{year} - 15/#{month}/#{year}"
    else
      last_day_of_month = Date.new(year.to_i, month.to_i, -1).day
      "16/#{month}/#{year} - #{last_day_of_month}/#{month}/#{year}"
    end
  end


end
