library(tidyverse)
diamonds2 <- readRDS("00_data/diamonds2.rds")

diamonds2 %>% head(n = 5)

diamonds3 <- readRDS("00_data/diamonds3.rds")

diamonds3 %>% head(n = 5)

diamonds4 <- readRDS("00_data/diamonds4.rds")
diamonds4 %>% 
  separate(col = dim,
           into = c("x", "y", "z"),
           sep = "/",
           convert = T)
