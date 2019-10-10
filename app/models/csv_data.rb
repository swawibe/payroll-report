require 'csv'

class CsvData < ApplicationRecord
  # ----------------------------------------------------------------------
  # == Include Modules == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Constants == #
  # ----------------------------------------------------------------------

  # If CSV header names needs to be changed, then we can modify here to adapt the change

  DATE = 'date'
  HOURS_WORKED = 'hours worked'
  EMPLOYEE_ID = 'employee id'
  JOB_GROUP = 'job group'
  REPORT_ID = 'report id'

  # paying_period is needed if we want to group CsvData bi weekly
  enum paying_period: { first_half: 0, last_half: 1 }

  # ----------------------------------------------------------------------
  # == Attributes == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == File Uploader == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Associations and Nested Attributes == #
  # ----------------------------------------------------------------------


  # ----------------------------------------------------------------------
  # == Validations == #
  # ----------------------------------------------------------------------


  # ----------------------------------------------------------------------
  # == Callbacks == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Scopes and Other macros == #
  # ----------------------------------------------------------------------

  scope :unreported, -> { where(reported: false) }

  # ----------------------------------------------------------------------
  # == Instance methods == #
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # == Class methods == #
  # ----------------------------------------------------------------------

  def self.store_csv_data_in_table(uploaded_file)
    temporary_csv_data = []
    csv_report_id = ''

    # Going to the end of a CSV file to fetch the report id
    # Besides generating a temporary array from CSV
    # We need to find out the report id to detect if there is already a report
    CSV.foreach(uploaded_file, headers: true) do |row|
      if row[0] == REPORT_ID
        csv_report_id = row[1]
      else
        temporary_csv_data.append(row.to_hash)
      end
    end

    # Returning false if already there is a report
    # Otherwise storing CSV data in CsvData table
    if CsvData.find_by report_id: csv_report_id
      return false
    else
      begin
        temporary_csv_data.each do |row|
          # Storing the payroll periods in a table. It will help to generate payroll reports using a SQL query
          pay_period = Date.parse(row[DATE]).day < 16 ? CsvData.paying_periods[:first_half] : CsvData.paying_periods[:last_half]

          CsvData.create(date: row[DATE], hours_worked: row[HOURS_WORKED],
                         employee_id: row[EMPLOYEE_ID], job_group: row[JOB_GROUP],
                         report_id: csv_report_id, paying_period: pay_period)
        end
      rescue => e
        Rails.logger.error "Could not generate CSV Data in #{e.class.name} : #{e.message}"
      end

    end
  end
end