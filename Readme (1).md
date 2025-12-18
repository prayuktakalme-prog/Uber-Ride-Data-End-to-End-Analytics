\# 🚖 Uber Operations & Growth Analytics (End-to-End SQL Project)

\## 📌 Executive Summary This project goes beyond basic reporting to
perform a \*\*deep-dive diagnostic analysis\*\* of Uber\'s ride data.
Using \*\*Advanced SQL\*\*, I analyzed \*\*100,000+ records\*\* to
uncover patterns in revenue leakage (cancellations), customer loyalty
(retention), and operational efficiency.

The insights are visualized using a \*\*Power BI Dashboard\*\* for
executive reporting.

\-\--

\## 🛠 Advanced SQL Techniques Used I didn\'t just use \`SELECT \*\`.
This project leverages: \* \*\*Window Functions (\`LAG\`, \`OVER\`):\*\*
To calculate Month-over-Month (MoM) revenue growth. \* \*\*CTEs (Common
Table Expressions):\*\* For breaking down complex logic like Customer
Segmentation. \* \*\*Case Statements (\`CASE WHEN\`):\*\* To create
dynamic buckets for Time (Morning/Evening) and Distance (Short/Long). \*
\*\*Statistical Aggregations:\*\* Calculating Revenue per KM and
Cancellation Rates.

\-\--

\## 🔍 Key Business Insights

\### 1. Revenue & Growth \* \*\*MoM Trends:\*\* Identified a 12% dip in
revenue during \[Specific Month\], correlated with high driver
cancellations. \* \*\*Distance Profitability:\*\* \"Long Trips
(\>30km)\" generate 40% of the revenue despite being only 20% of the
volume. \*Strategy: Incentivize long-distance drivers.\*

\### 2. Customer Behavior (RFM Proxy) \* \*\*Loyalty Gap:\*\* Only 20%
of users are \"Repeat Customers\", but they contribute to 60% of total
revenue. \* \*\*Retention Risk:\*\* 45% of first-time users drop off
after a \"Driver Cancelled\" experience.

\### 3. Operational Bottlenecks \* \*\*Peak Hour Failure:\*\* The
\"Evening Peak (5 PM - 9 PM)\" has the highest demand but also the
highest \'Driver Cancellation\' rate due to traffic congestion. \*
\*\*Driver Quality:\*\* Drivers with ratings below 3.0 have a 2x higher
cancellation rate than those with 4.5+ ratings.

\-\--

\## 📂 Repository Structure \* \`Uber_Advanced_Analytics.sql\`: The
complete SQL script with 5 analytical modules. \*
\`Uber_Dashboard.pbix\`: Power BI file with interactive slicers. \*
\`Screenshots/\`: Visual proofs of the insights.

\## 🚀 How to Run 1. Import the \`uber_data.csv\` into your SQL database
(MySQL/PostgreSQL). 2. Run the \`Uber_Advanced_Analytics.sql\` script
section by section. 3. Connect Power BI to the SQL database to refresh
the visuals.

\-\-- \*Author: Prayukta Kalme
