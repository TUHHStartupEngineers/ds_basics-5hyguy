library(tidyverse)
library(vroom)

# Data Table
library(data.table)

# Counter
library(tictoc)


col_type_patent <- list(
  id = col_character(),
  date = col_date("%Y-%m-%d"),
  num_claims = col_character()
)

patent_tbl <- vroom(
  file       = "/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/patent/patent.tsv", 
  delim      = "\t", 
  col_types  = col_type_patent,
  na         = c("", "NA", "NULL")
)
patent_tbl %>% glimpse()

col_type_assignee <- list(
  id = col_character(),
  type = col_character(),
  organization = col_character()
 
)

assignee_tbl <- vroom(
  file       = "/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/patent/assignee.tsv", 
  delim      = "\t", 
  col_types  = col_type_assignee,
  na         = c("", "NA", "NULL")
)
assignee_tbl %>% glimpse()


col_type_patent_assignee <- list(
  patent_id = col_character(),
  assignee_id = col_character()
  
)

patent_assignee_tbl <- vroom(
  file       = "/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/patent/patent_assignee.tsv", 
  delim      = "\t", 
  col_types  = col_type_patent_assignee,
  na         = c("", "NA", "NULL")
)
patent_assignee_tbl %>% glimpse()


col_type_uspc <- list(
  patent_id = col_character(),
  mainclass_id = col_character(),
  sequence = col_character()
  
)

uspc_tbl <- vroom(
  file       = "/Users/famakinolawole/Documents/dataanalytics/Untitled/ds_basics-5hyguy/patent/uspc.tsv", 
  delim      = "\t", 
  col_types  = col_type_uspc,
  na         = c("", "NA", "NULL")
)
uspc_tbl %>% glimpse()


tic()
combined_data <- merge(x = patent_tbl, y = assignee_tbl, 
                       by    = "id", 
                       all.x = TRUE, 
                       all.y = TRUE)
toc()

combined_data %>% glimpse()

