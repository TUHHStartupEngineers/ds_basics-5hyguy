# 1.1 COLLECT PRODUCT FAMILIES ----
library(httr)
url_home          <- "https://www.radon-bikes.de"
xopen(url_home) # Open links directly from RStudio to inspect them

# Read in the HTML for the entire webpage
html_home         <- read_html(url_home)

# Web scrape the ids for the families
bike_family_tbl <- html_home %>%
  
  # Get the nodes for the families ...
  html_nodes(css = ".js-menu , .cf2Lf6") %>%
  # ...and extract the information of the id attribute
  html_attr('id') %>%
  
  # Remove the product families Gear and Outlet and Woman 
  # (because the female bikes are also listed with the others)
  discard(.p = ~stringr::str_detect(.x,"EBIKE|WEAR")) %>%
  
  # Convert vector to tibble
  enframe(name = "position", value = "family_class") %>%
  
  # Add a hashtag so we can get nodes of the categories by id (#)
  mutate(
    family_id = str_glue("#{family_class}")
  )

bike_family_tbl
## # A tibble: 5 x 3
##   position family_class                  family_id                     
##                                                        
##         1 js-navigationList-ROAD        #js-navigationList-ROAD       
##         2 js-navigationList-MOUNTAIN    #js-navigationList-MOUNTAIN   
##         3 js-navigationList-EBIKES      #js-navigationList-EBIKES     
##         4 js-navigationList-HYBRID-CITY #js-navigationList-HYBRID-CITY
##         5 js-navigationList-YOUNGHEROES #js-navigationList-YOUNGHEROES

# The updated page has now also ids for CFR and GRAVEL. You can either include or remove them.