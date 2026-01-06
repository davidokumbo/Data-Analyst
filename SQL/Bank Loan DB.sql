CREATE DATABASE bank_loan_db;
SELECT * FROM financial_loan;

# CHANGING issue_date COLUMN INTO DATE DATA TYPE
UPDATE financial_loan
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE financial_loan
MODIFY COLUMN issue_date date;


# CHANGING last_credit_pull_date COLUMN INTO DATE DATA TYPE
UPDATE financial_loan
SET last_credit_pull_date = str_to_date(last_credit_pull_date, '%d-%m-%Y');

ALTER TABLE financial_loan
MODIFY COLUMN last_credit_pull_date date;


# CHANGING last_payment_date COLUMN INTO DATE DATA TYPE
UPDATE financial_loan
SET last_payment_date = str_to_date(last_payment_date, '%d-%m-%Y');

ALTER TABLE financial_loan
MODIFY COLUMN last_payment_date DATE;

# SQL QUERIES STARTS HERE
# Get all loan applications
SELECT COUNT(id) AS TOTAL_LOAN_APPLICATIONS
 FROM financial_loan;
 
 # Getting total loan applications for the month of december only MTD
 SELECT COUNT(id) AS MTD_TOTAL_LOAN_APPLICATIONS
 FROM financial_loan
 WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;
 
 # Getting total loan applications for the previous month which is November only PMTD
  SELECT COUNT(id) AS PMTD_TOTAL_LOAN_APPLICATIONS FROM financial_loan
  WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;
  
  
  #Month-on-Month Application Formulae for total loan applications = (PMTD-MTD)/PMTD
  WITH DIFFERENCE_CTE AS(
   SELECT COUNT(id)-( SELECT COUNT(id)
                     FROM financial_loan
                      WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021)
  AS PMTD_TOTAL_LOAN_APPLICATIONS FROM financial_loan
  WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
  ) 
  SELECT PMTD_TOTAL_LOAN_APPLICATIONS/( SELECT COUNT(id)
                     FROM financial_loan
					 WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021) AS MoM
					 FROM DIFFERENCE_CTE;
 
 # Total amount received
 SELECT SUM(total_payment) AS total_Amount_Received FROM financial_loan;

#Total Amount received for MTD
SELECT SUM(total_payment) AS MTD_total_Amount_Received FROM financial_loan
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;

#Total Amount received fo PMTD
SELECT SUM(total_payment) AS PMTD_total_Amount_Received FROM financial_loan
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021;

#Month-on-Month Application Formulae for total amount received = (PMTD-MTD)/PMTD
WITH DIFFERENCECTE AS(
SELECT SUM(total_payment)-(SELECT 
                             SUM(total_payment) AS MTD_total_Amount_Received 
                             FROM financial_loan
                             WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021) 
AS total_difference
FROM financial_loan
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021
  ) 
  SELECT total_difference/(SELECT SUM(total_payment) FROM financial_loan
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021) AS TOTAL_MoM FROM DIFFERENCECTE;


#Average Interest rate for MTD
SELECT round(AVG(int_rate), 5)*100 AS avg_interest_rate FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

#Average Interest rate for PMTD
SELECT round(AVG(int_rate), 5)*100 AS avg_interest_rate FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

# Date-to-Income Ratio (DTI)
SELECT ROUND(AVG(dti), 4)*100 AS Average_DTI  FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

# Date-to-Income Ratio (PDTI)
SELECT ROUND(AVG(dti), 4)*100 AS Average_PDTI  FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


#Percentage number of good loan applicants
SELECT 
(COUNT(
      CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END )*100
      )/COUNT(id) 
AS AVG_Good_Loan_Applicants FROM financial_loan;

# Total Good Loan Applicants
SELECT COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END ) 
AS Total_Good_Loans_Applications FROM financial_loan;
         # Another way to write it
SELECT COUNT(id) FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status='Current';

# Good loan Funded Amount
SELECT SUM(CASE WHEN loan_status = 'Fully Paid' OR loan_status='Current' THEN loan_amount END) AS Good_Loan_Funded_Amount FROM financial_loan;

# Good loan Received Amount
SELECT SUM(CASE WHEN loan_status = 'Fully Paid' OR loan_status='Current' THEN total_payment END) AS Good_Loan_Received_Amount FROM financial_loan;



#Percentage number of bad loan applicants
SELECT 
(COUNT(
      CASE WHEN loan_status='Charged Off' THEN id END )*100
      )/COUNT(id) 
AS AVG_Bad_Loan_Applicants FROM financial_loan;

# Total Bad Loan Applicants
SELECT COUNT(CASE WHEN loan_status='Charged Off' THEN id END ) 
AS Total_Bad_Loans_Applications FROM financial_loan;
         # Another way to write it
SELECT COUNT(id) AS Total_Bad_Loans_Applications FROM financial_loan
WHERE loan_status = 'Charged Off';

# Bad loan Funded Amount
SELECT SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amount END) AS Bad_Loan_Funded_Amount FROM financial_loan;

# Bad loan Received Amount
SELECT SUM(CASE WHEN loan_status = 'Charged Off' THEN total_payment END) AS Bad_Loan_Received_Amount FROM financial_loan;
