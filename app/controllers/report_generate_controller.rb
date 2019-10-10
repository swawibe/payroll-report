class ReportGenerateController < ApplicationController
  def index
    # Fetch all CSV files data
    @csv_data = CsvData.all

    # Fetch all calculated payroll reports. The payroll reports are at first, sorted by employee_id then by period data
    @reports = PayrollReport.all
  end

  def upload_csv
    uploaded_file = params[:file]

    # We could use Paperclip to check if the file is really CSV
    # However, for this small project we are just checking if the file with correct extension and not blank
    if uploaded_file.blank? || (File.extname(uploaded_file.path).upcase != '.CSV')
      flash[:error] = 'Could not find your CSV file'
      redirect_to report_generate_index_path and return
    end

    # Before generating a report and store data to a table,
    # we need to check if there exists data with the same report id
    unless CsvData.store_csv_data_in_table(uploaded_file.path)
      flash[:error] = 'Already you have data with the same report id'
      redirect_to report_generate_index_path and return
    end

    # If CSV file is stored successfully, then generate report
    PayrollReport.generate_report
    redirect_to report_generate_index_path

  end
end
