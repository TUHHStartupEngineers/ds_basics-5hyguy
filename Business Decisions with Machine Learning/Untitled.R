
sp_500_prices_tbl <- read_rds("/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/Business Decisions with Machine Learning/sp_500_prices_tbl.rds")
sp_500_prices_tbl
sp_500_index_tbl <- read_rds("/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/Business Decisions with Machine Learning/sp_500_index_tbl.rds")
sp_500_index_tbl

sp_500_prices_tbl %>% glimpse()

sp_500_daily_returns_tbl  <- sp_500_prices_tbl %>%
  select(symbol, date, adjusted) %>%
  filter(year(date) > 2017) %>% mutate(pct_return = lag(adjusted))

sp_500_daily_returns_tbl  <- sp_500_daily_returns_tbl%>%
  select(-contains("NA"))




