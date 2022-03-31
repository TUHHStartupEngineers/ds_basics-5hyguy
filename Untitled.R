library(readxl)
bikes <- read_excel("00_data/bikes.xlsx")
bikeshops <- read_excel("00_data/bikeshops.xlsx")
orderlines <- read_excel("00_data/orderlines.xlsx")

write_rds(bikes,file="00_data/bikes.rds")

