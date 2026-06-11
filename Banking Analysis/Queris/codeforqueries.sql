#1.Year wise loan amount Stats
SELECT
    emp_length,
    COUNT(id)                                         AS total_loans,
    SUM(loan_amnt)                                    AS total_loan_amount,
    ROUND(AVG(loan_amnt), 2)                          AS avg_loan_amount,
    MIN(loan_amnt)                                    AS min_loan_amount,
    MAX(loan_amnt)                                    AS max_loan_amount,
    ROUND(AVG(annual_inc), 2)                         AS avg_annual_income,
    ROUND(AVG(dti), 2)                                AS avg_dti,
    ROUND(
        SUM(loan_amnt) * 100.0
        / SUM(SUM(loan_amnt)) OVER (
            PARTITION BY YEAR(STR_TO_DATE(issue_d, '%b-%y'))
          ),
    2)                                                AS pct_within_year

FROM finance_1
WHERE emp_length IS NOT NULL

GROUP BY
    YEAR(STR_TO_DATE(issue_d, '%b-%y')),
    emp_length

ORDER BY
    emp_length,
    emp_length;
DESC FINANCE_1;
SELECT * FROM FINANCE_1;
SELECT * FROM FINANCE_2;
#2.Grade and sub grade wise revol_bal

SELECT F1.grade,F1.sub_grade,SUM(F2.revol_bal) AS TOTAL_BALANCE FROM FINANCE_1 AS F1 JOIN FINANCE_2 AS F2
ON F1.ID=F2.ID GROUP BY F1.GRADE,F1.SUB_GRADE;

# 3.Total Payment for Verified Status Vs Total Payment for Non Verified Status
WITH a1 AS (
    SELECT SUM(F2.total_pymnt) AS total_payment
    FROM finance_1 AS F1
    JOIN finance_2  AS F2 ON F1.id = F2.id
    WHERE F1.verification_status = 'Verified'
),
a2 AS (
    SELECT SUM(F2.total_pymnt) AS total_payment
    FROM finance_1 AS F1
    JOIN finance_2  AS F2 ON F1.id = F2.id
    WHERE F1.verification_status = 'Not Verified'
)
SELECT
    a1.total_payment    AS total_pymnt_verified,
    a2.total_payment    AS total_pymnt_not_verified
FROM a1, a2;
 
 # 4.State wise and last_credit_pull_d wise loan status
    
SELECT
    F1.addr_state,
    YEAR(F2.last_credit_pull_d)                            AS credit_pull_year,
    F1.loan_status,

    COUNT(F1.id)                                           AS total_loans,
    ROUND(SUM(F1.loan_amnt), 2)                            AS total_loan_amount,
    ROUND(AVG(F1.loan_amnt), 2)                            AS avg_loan_amount,
    ROUND(SUM(F2.total_pymnt), 2)                          AS total_payment_received,
    ROUND(AVG(F1.dti), 2)                                  AS avg_dti,
    ROUND(AVG(F1.annual_inc), 2)                           AS avg_annual_income,

    -- % share within state + year
    ROUND(
        COUNT(F1.id) * 100.0
        / SUM(COUNT(F1.id)) OVER (
            PARTITION BY F1.addr_state,
            YEAR(F2.last_credit_pull_d)
          ),
    2)                                                     AS pct_within_state_year

FROM finance_1 AS F1
JOIN finance_2  AS F2
    ON F1.id = F2.id

WHERE F2.last_credit_pull_d IS NOT NULL

GROUP BY
    F1.addr_state,
    YEAR(F2.last_credit_pull_d),
    F1.loan_status

ORDER BY
    F1.addr_state,
    credit_pull_year,
    total_loans DESC;
    
    DESC FINANCE_1;
    DESC FINANCE_2;
    
   SELECT
    F1.addr_state,
    F2.last_credit_pull_d,
    F1.loan_status,
    COUNT(F1.id)                AS total_loans

FROM finance_1 AS F1
JOIN finance_2  AS F2
    ON F1.id = F2.id

WHERE F2.last_credit_pull_d IS NOT NULL

GROUP BY
    F1.addr_state,
    F2.last_credit_pull_d,
    F1.loan_status

ORDER BY
    F1.addr_state,
    F2.last_credit_pull_d,
    F1.loan_status;
    
    #5 Home ownership Vs last payment date stats

    
    
    SELECT
    F1.home_ownership,

    COUNT(F1.id)                                      AS total_loans,
    ROUND(SUM(F1.loan_amnt), 2)                       AS total_loan_amount,
    ROUND(AVG(F1.loan_amnt), 2)                       AS avg_loan_amount,
    MIN(F2.last_pymnt_d)                              AS earliest_last_payment,
    MAX(F2.last_pymnt_d)                              AS latest_last_payment,
    ROUND(SUM(F2.last_pymnt_amnt), 2)                 AS total_last_payment,
    ROUND(AVG(F2.last_pymnt_amnt), 2)                 AS avg_last_payment,
    ROUND(SUM(F2.total_pymnt), 2)                     AS total_payment_received,
    ROUND(AVG(F2.total_pymnt), 2)                     AS avg_total_payment,
    ROUND(AVG(F1.annual_inc), 2)                      AS avg_annual_income,
    ROUND(AVG(F1.dti), 2)                             AS avg_dti,

    ROUND(
        COUNT(F1.id) * 100.0
        / SUM(COUNT(F1.id)) OVER (),
    2)                                                AS pct_of_total

FROM finance_1 AS F1
JOIN finance_2  AS F2
    ON F1.id = F2.id

WHERE F2.last_pymnt_d IS NOT NULL

GROUP BY
    F1.home_ownership

ORDER BY
    total_loans DESC;

