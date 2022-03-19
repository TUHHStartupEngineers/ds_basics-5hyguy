library(readxl)
bikes_tbl <- read_excel("00_data/01_bike_sales/01_raw_data/bikes.xlsx") %>%
  
  # Separate product category name in main and sub
  separate(col    = category,
           into   = c("category.1", "category.2", "category.3"),
           sep    = " - ") %>%
  
  # Renaming columns
  set_names(names(.) %>% str_replace_all("\\.", "_"))

