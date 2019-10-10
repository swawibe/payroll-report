require 'rails_helper'

RSpec.describe ReportGenerateController, type: :controller do

  describe 'PayrollReport' do
    context '.calculate_amount' do
      it 'returns calculated amount when parameters are float' do
        expect(PayrollReport.calculate_amount(30.5, 12)).to eq(366.0)
      end

      it 'returns calculated amount when parameters are string' do
        expect(PayrollReport.calculate_amount('30', '10')).to eq(300)
      end
    end

    context '.build_paying_period' do
      it 'returns paying period when leap year' do
        expect(PayrollReport.build_paying_period(2016, 2, 'last_half')).to eq('16/2/2016 - 29/2/2016')
      end

      it 'returns paying period when paid at the first half' do
        expect(PayrollReport.build_paying_period(1999, 12, 'first_half')).to eq('1/12/1999 - 15/12/1999')
      end
    end
  end
end
