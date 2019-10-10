# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_09_181354) do

  create_table "csv_data", force: :cascade do |t|
    t.date "date"
    t.float "hours_worked"
    t.string "job_group"
    t.string "employee_id"
    t.string "report_id"
    t.integer "paying_period"
    t.boolean "reported", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_csv_data_on_employee_id"
    t.index ["report_id"], name: "index_csv_data_on_report_id"
  end

  create_table "job_groups", force: :cascade do |t|
    t.string "group_name"
    t.float "paying_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payroll_reports", force: :cascade do |t|
    t.string "employee_id"
    t.string "pay_period"
    t.float "amount_paid"
    t.string "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_payroll_reports_on_employee_id"
  end

end
