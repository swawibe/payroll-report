## How to run this project:

#### Following things are prerequisites for this project:

- Ruby 2.6.3
- Rails 5.2.3
- Bundler
- NodeJS (In Ubuntu, you can install nodejs by following command: `sudo apt-get install nodejs`)

#### Installation steps:

1. Download this repository
1. Go inside the project directory. If you have bundler, then the bundler will automatically create a wrapper called `wave-challenge`
1. run `bundle install`
1. run `rake db:create`
1. run `rake db:migrate`
1. run `rake db:seed` (seed file will populate pre-defined job groups)
1. run `rails s` to start a server
1. Open your browser and go to http://localhost:3000. The homepage will be empty.
1. Click on the 'Choose File' and select a correct 'CSV' file (comma separated file). Then click on the 'Upload CSV' button.
1. Wait for a few seconds. The server will populate a Bi-weekly payroll report for you.

#### A few highlights of this project:

1. The main feature of this project is to generate a payroll report. To generate that report, we need to use a lot of conditions. If we implement those conditions in code, then the code might become complex (multiple condition checking). To solve this problem, we calculated most of the logic in SQL queries (ActiveRecord). Besides, SQL queries are much faster than code.
1. One of the most important features of this project was to ensure that, a user can't upload the same report multiple times. However, the `report_id` is at the end of the CSV file. Therefore, before storing the CSV file to the database, we have checked the report_id. We could do the check in multiple ways. One way is to read all rows of the CSV file until encountering the report_id. Then check the report_id already exists. If exists then return a message. Otherwise, read the CSV file again and store it in a table. However, file operation is not a fast operation. To solve these multiple times of file reading, we stored all CSV data in an array. Then, when checking of report_id is completed, we stored data from the array. Moreover, we stored `report_id` in the CSVData table for future reference.  
1. Used partial in the `application.html.erb` file to render a flash message. In the future, the partial can be rendered from any other pages.
1. Followed `Skinny Controllers, Fat Models` concept. Therefore, most of the logic is in the models.
1. Integrated Bootstrap-4 to show flash error messages (try to upload the same CSV file multiple times) and designing tables.


## Project Description

Imagine we are prototyping a new payroll system with an early partner. Our partner is going to use our web
app to determine how much each employee should be paid in each _pay period_, so
it is critical that we get our numbers right.

The partner in question only pays its employees by the hour (there are no
salaried employees.) Employees belong to one of two _job groups_ which
determine their wages; job group A is paid $20/hr, and job group B is paid
$30/hr. Each employee is identified by a string called an "employee id" that is
globally unique in their system.

Hours are tracked per employee, per day in comma-separated value files (CSV).
Each individual CSV file is known as a "time report", and will contain:

1. A header, denoting the columns in the sheet (`date`, `hours worked`,
   `employee id`, `job group`)
1. 0 or more data rows
1. A footer row where the first cell contains the string `report id`, and the
   second cell contains a unique identifier for this report.

Our partner has guaranteed that:

1. Columns will always be in that order.
1. There will always be data in each column.
1. There will always be a well-formed header line.
1. There will always be a well-formed footer line.

An example input file named `sample.csv` is included in this repo.

### What this application does:

We've agreed to build the following web-based prototype for our partner.

1. Our app accepts (via a form) a comma separated file with the schema
   described in the previous section.
1. Our app parse the given file, and store the timekeeping information in
   a relational database for archival reasons.
1. After upload, our application displays a _payroll report_. This
   report is also accessible to the user without them having to upload a
   file first.
1. If an attempt is made to upload two files with the same report id, the
   second upload should fail with an error message indicating that this is not
   allowed.

The payroll report should be structured as follows:

1. There should be 3 columns in the report: `Employee Id`, `Pay Period`,
   `Amount Paid`
1. A `Pay Period` is a date interval that is roughly biweekly. Each month has
   two pay periods; the _first half_ is from the 1st to the 15th inclusive, and
   the _second half_ is from the 16th to the end of the month, inclusive.
1. Each employee should have a single row in the report for each pay period
   that they have recorded hours worked. The `Amount Paid` should be reported
   as the sum of the hours worked in that pay period multiplied by the hourly
   rate for their job group.
1. If an employee was not paid in a specific pay period, there should not be a
   row for that employee + pay period combination in the report.
1. The report should be sorted in some sensical order (e.g. sorted by employee
   id and then pay period start.)
1. The report should be based on all _of the data_ across _all of the uploaded
   time reports_, for all time.

As an example, a sample file with the following data:

<table>
<tr>
  <th>
    date
  </th>
  <th>
    hours worked
  </th>
  <th>
    employee id
  </th>
  <th>
    job group
  </th>
</tr>
<tr>
  <td>
    4/11/2016
  </td>
  <td>
    10
  </td>
  <td>
    1
  </td>
  <td>
    A
  </td>
</tr>
<tr>
  <td>
    14/11/2016
  </td>
  <td>
    5
  </td>
  <td>
    1
  </td>
  <td>
    A
  </td>
</tr>
<tr>
  <td>
    20/11/2016
  </td>
  <td>
    3
  </td>
  <td>
    2
  </td>
  <td>
    B
  </td>
</tr>
</table>

should produce the following payroll report:

<table>
<tr>
  <th>
    Employee ID
  </th>
  <th>
    Pay Period
  </th>
  <th>
    Amount Paid
  </th>
</tr>
<tr>
  <td>
    1
  </td>
  <td>
    1/11/2016 - 15/11/2016
  </td>
  <td>
    $300.00
  </td>
</tr>
  <td>
    2
  </td>
  <td>
    16/11/2016 - 30/11/2016
  </td>
  <td>
    $90.00
  </td>
</tr>
</table>
