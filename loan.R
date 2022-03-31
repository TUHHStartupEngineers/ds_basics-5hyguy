
library(tidyverse)
library(vroom)


## define columns
col_types_acq <- list(
  loan_id                            = col_factor(),
  original_channel                   = col_factor(NULL),
  seller_name                        = col_factor(NULL),
  original_interest_rate             = col_double(),
  original_upb                       = col_integer(),
  original_loan_term                 = col_integer(),
  original_date                      = col_date("%m/%Y"),
  first_pay_date                     = col_date("%m/%Y"),
  original_ltv                       = col_double(),
  original_cltv                      = col_double(),
  number_of_borrowers                = col_double(),
  original_dti                       = col_double(),
  original_borrower_credit_score     = col_double(),
  first_time_home_buyer              = col_factor(NULL),
  loan_purpose                       = col_factor(NULL),
  property_type                      = col_factor(NULL),
  number_of_units                    = col_integer(),
  occupancy_status                   = col_factor(NULL),
  property_state                     = col_factor(NULL),
  zip                                = col_integer(),
  primary_mortgage_insurance_percent = col_double(),
  product_type                       = col_factor(NULL),
  original_coborrower_credit_score   = col_double(),
  mortgage_insurance_type            = col_double(),
  relocation_mortgage_indicator      = col_factor(NULL))

## import
acquisition_data <- vroom(
  file       = "/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/data/loan_data/Acquisition_2019Q1.txt", 
  delim      = "|", 
  col_names  = names(col_types_acq),
  col_types  = col_types_acq,
  na         = c("", "NA", "NULL"))
acquisition_data %>% glimpse()


## define columns
col_types_perf = list(
  loan_id                                = col_factor(),
  monthly_reporting_period               = col_date("%m/%d/%Y"),
  servicer_name                          = col_factor(NULL),
  current_interest_rate                  = col_double(),
  current_upb                            = col_double(),
  loan_age                               = col_double(),
  remaining_months_to_legal_maturity     = col_double(),
  adj_remaining_months_to_maturity       = col_double(),
  maturity_date                          = col_date("%m/%Y"),
  msa                                    = col_double(),
  current_loan_delinquency_status        = col_double(),
  modification_flag                      = col_factor(NULL),
  zero_balance_code                      = col_factor(NULL),
  zero_balance_effective_date            = col_date("%m/%Y"),
  last_paid_installment_date             = col_date("%m/%d/%Y"),
  foreclosed_after                       = col_date("%m/%d/%Y"),
  disposition_date                       = col_date("%m/%d/%Y"),
  foreclosure_costs                      = col_double(),
  prop_preservation_and_repair_costs     = col_double(),
  asset_recovery_costs                   = col_double(),
  misc_holding_expenses                  = col_double(),
  holding_taxes                          = col_double(),
  net_sale_proceeds                      = col_double(),
  credit_enhancement_proceeds            = col_double(),
  repurchase_make_whole_proceeds         = col_double(),
  other_foreclosure_proceeds             = col_double(),
  non_interest_bearing_upb               = col_double(),
  principal_forgiveness_upb              = col_double(),
  repurchase_make_whole_proceeds_flag    = col_factor(NULL),
  foreclosure_principal_write_off_amount = col_double(),
  servicing_activity_indicator           = col_factor(NULL))


## import
performance_data <- vroom(
  file       = "/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/data/loan_data/Performance_2019Q1.txt", 
  delim      = "|", 
  col_names  = names(col_types_perf),
  col_types  = col_types_perf,
  na         = c("", "NA", "NULL"))
performance_data %>% glimpse()




## left join with acquisition_data
performance_data <- performance_data %>%
  left_join(acquisition_data, by = "loan_id")



## select columns
combined_data <- performance_data %>% select("loan_id",
                                             "monthly_reporting_period",
                                             "seller_name",
                                             "current_interest_rate",
                                             "current_upb",
                                             "loan_age",
                                             "remaining_months_to_legal_maturity",
                                             "adj_remaining_months_to_maturity",
                                             "current_loan_delinquency_status",
                                             "modification_flag",
                                             "zero_balance_code",
                                             "foreclosure_costs",
                                             "prop_preservation_and_repair_costs",
                                             "asset_recovery_costs",
                                             "misc_holding_expenses",
                                             "holding_taxes",
                                             "net_sale_proceeds",
                                             "credit_enhancement_proceeds",
                                             "repurchase_make_whole_proceeds",
                                             "other_foreclosure_proceeds",
                                             "non_interest_bearing_upb",
                                             "principal_forgiveness_upb",
                                             "repurchase_make_whole_proceeds_flag",
                                             "foreclosure_principal_write_off_amount",
                                             "servicing_activity_indicator",
                                             "original_channel",
                                             "original_interest_rate",
                                             "original_upb",
                                             "original_loan_term",
                                             "original_ltv",
                                             "original_cltv",
                                             "number_of_borrowers",
                                             "original_dti",
                                             "original_borrower_credit_score",
                                             "first_time_home_buyer",
                                             "loan_purpose",
                                             "property_type",
                                             "number_of_units",
                                             "property_state",
                                             "occupancy_status",
                                             "primary_mortgage_insurance_percent",
                                             "product_type",
                                             "original_coborrower_credit_score",
                                             "mortgage_insurance_type",
                                             "relocation_mortgage_indicator")


## work with current_loan_delinquency_status
combined_data %>% select(current_loan_delinquency_status) %>% table()


temp <- combined_data %>%
  group_by(loan_id) %>%
  mutate(gt_1mo_behind_in_3mo_dplyr = lead(current_loan_delinquency_status, n = 3) >= 1) %>%
  ungroup()  

combined_data %>% dim()
temp %>% dim()


## How many loans are in each month. We have to take a look at the column monthly_reporting_period. 
## Watch out for NA values.


combined_data %>%
  filter(!is.na(monthly_reporting_period)) %>%
  count(monthly_reporting_period) 


## Which loans have the most outstanding delinquencies?

combined_data %>%
  group_by(loan_id) %>%
  summarise(total_delinq = max(current_loan_delinquency_status)) %>%
  ungroup() %>%
  arrange(desc(total_delinq))

## What is the last unpaid balance value for delinquent loans

combined_data %>%
  filter(current_loan_delinquency_status >= 1) %>%
  filter(!is.na(current_upb)) %>%
  
  group_by(loan_id) %>%
  slice(n()) %>%
  ungroup() %>%
  
  arrange(desc(current_upb)) %>%
  select(loan_id, monthly_reporting_period, current_loan_delinquency_status, seller_name, current_upb)


## What are the Loan Companies with highest unpaid balance?

upb_by_company_tbl <- combined_data %>%
  
  filter(!is.na(current_upb)) %>%
  group_by(loan_id) %>%
  slice(n()) %>%
  ungroup() %>%
  
  group_by(seller_name) %>%
  summarise(
    sum_current_upb = sum(current_upb, na.rm = TRUE),
    cnt_current_upb = n()
  ) %>%
  ungroup() %>%
  
  arrange(desc(sum_current_upb))

