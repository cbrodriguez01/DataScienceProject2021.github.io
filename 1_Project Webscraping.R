###################################################################################################################
# BST260 Project Webscraping
#
# Programmer: Emma Crenshaw
# Date:       11/28/2021
#
# Purpose:    This program scrapes recipe data from https://www.recipetineats.com/ for use in the BST260
#             final project
#
###################################################################################################################


library(tidyverse)
library(rvest)
library(stringr)
library(xml2)


############################################
#   Get the recipe URLS
############################################

page_links = data.frame()

# Get the recipe links from the website recipe index
for (i in 1:62){
  url <- ifelse(i==1,"https://www.recipetineats.com/recipes/", paste0("https://www.recipetineats.com/recipes/?fwp_paged=",i))
  page_source <- read_html(url) 
  
  # this gets the list of recipe indices (removes links that are obviously not recipes, particularly
  # recipe collections)
  page_links_add <- data.frame(links=html_attr(html_nodes(page_source, "a"), "href")) %>%
    filter(str_detect(links, "https://www.recipetineats.com/") & 
             !str_detect(links, "category") & 
             !str_detect(links, "contact") & 
             !str_detect(links, "disclosure") &
             !str_detect(links, "policy") &
             !str_detect(links, "book") &
             !str_detect(links, "nagi") &
             !str_detect(links, "categories") &
             !str_detect(links, "8 ways") &
             !str_detect(links, "shopping-list") &
             !str_detect(links, "pressing-pause-feels-like-failing") &
             !str_detect(links, "dozer-the-golden-retriever-dog") &
             !str_detect(links, "chef-wanted-to-cook-with-me") &
             !str_detect(links, "how-to-tell-how-fresh-your-egg-is-baking-tip") &
             !str_detect(links, "baking-basics-how-to-check-your-baking-powder-is-still-active") &
             !str_detect(links, "talk-to-me") &
             !str_detect(links, "interview") &
             !str_detect(links, "30-recipes") &
             !str_detect(links, "selfie") &
             !str_detect(links, "christmas-recipes") &
             !str_detect(links, "my-favourite-kitchen-knives") &
             !str_detect(links, "thanksgiving-2020-smaller-but-not-duller") &
             !str_detect(links, "ask-me-anything") &
             !str_detect(links, "10-mothers-day-breakfasts") &
             !str_detect(links, "what-food-to-stock-up-on") &
             !str_detect(links, "10-best") &
             !str_detect(links, "recipes") &
             !str_detect(links, "travel-guide") &
             !str_detect(links, "recipe-round-up") &
             !str_detect(links, "giveaway") &
             !str_detect(links, "5-great-prawn-dipping-sauces") &
             !str_detect(links, "feast") &
             !str_detect(links, "menu") &
             !str_detect(links, "20-asian-meals") &
             !str_detect(links, "20-essential") &
             !str_detect(links, "10-classic-chinese-dishes") &
             !str_detect(links, "guide") &
             !str_detect(links, "versions") )
  page_links <- rbind(page_links,page_links_add)
  
}

# Clean the link list
recipe_list = distinct(page_links,links) %>% filter(links != "https://www.recipetineats.com/" & links !="https://www.recipetineats.com/recipes/")
final_links <- c(recipe_list$links) 

# 1184 unique links 



############################################
#   Get the recipe data
############################################

# Function that scrapes the data from each URL
get_recipe <- function(url_list,n=length(url_list)){
  
  # Initialize the data frame
  recipe_data = data.frame(recipe=rep(NA,n), cook_time=rep(NA,n), prep_time=rep(NA,n), course=rep(NA,n), cuisine=rep(NA,n),
                           rating=rep(NA,n), n_ratings=rep(NA,n), servings=rep(NA,n), ingredients=rep(NA,n), n_ingredients=rep(NA,n), n_steps=rep(NA,n),
                           calories=rep(NA,n), carbs=rep(NA,n), protein=rep(NA,n), fat=rep(NA,n), sat_fat=rep(NA,n), poly_fat=rep(NA,n), 
                           mono_fat=rep(NA,n), sodium=rep(NA,n), potassium=rep(NA,n), fiber=rep(NA,n), sugar=rep(NA,n), 
                           vitamin_c=rep(NA,n), vitamin_a=rep(NA,n), calcium=rep(NA,n), iron=rep(NA,n))
  
  # Loop through each URL
  for (k in 1:n){
    h <- read_html(url_list[k])
    
    # Get the data
    recipe_data$recipe[k]      <- h %>% html_node(".wprm-recipe-name") %>% html_text()
    recipe_data$cook_time[k]   <- ifelse(str_detect(html_text(html_node(h,".wprm-recipe-cook-time-container")),"hr"),
                                         as.numeric(word(html_text(html_node(h,".wprm-recipe-cook-time-container")),3))*60,
                                         as.numeric(word(html_text(html_node(h,".wprm-recipe-cook-time-container")),3)))
                                         
    recipe_data$prep_time[k] <- h %>% html_node(".wprm-recipe-prep_time-minutes") %>% html_text()
    recipe_data$course[k] <- h %>% html_node(".wprm-recipe-course") %>% html_text()
    recipe_data$cuisine[k] <- h %>% html_node(".wprm-recipe-cuisine") %>% html_text()
    recipe_data$rating[k] <- h %>% html_node(".wprm-recipe-rating-average") %>% html_text()
    recipe_data$servings[k] <- h %>% html_node(".wprm-recipe-servings-adjustable-tooltip") %>% html_text()
    recipe_data$ingredients[k] <- paste(html_text(html_nodes(h, ".wprm-recipe-ingredient-name")),
                                        sep="", collapse="; ")
    recipe_data$n_ingredients[k] <- length(html_text(html_nodes(h, ".wprm-recipe-ingredient-name")))
    recipe_data$n_steps[k] <- length(html_text(html_nodes(h,".wprm-recipe-instruction-text")))
    recipe_data$n_ratings[k] <- h %>% html_node(".wprm-recipe-rating-count") %>% html_text()
    
    # Get nutrition data, node depends on whether the data includes serving size or not
    recipe_data$calories[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Calories:\\s*\\d*") %>% word(2)
    recipe_data$carbs[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Carbohydrates:\\s*\\d*") %>% word(2)
    recipe_data$protein[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Protein:\\s*\\d*") %>% word(2)
    recipe_data$fat[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Fat:\\s*\\d*") %>% word(2)
    recipe_data$sat_fat[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Saturated Fat:\\s*\\d*") %>% word(3)
    recipe_data$poly_fat[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Polyunsaturated Fat:\\s*\\d*") %>% word(3)
    recipe_data$mono_fat[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Monounsaturated Fat:\\s*\\d*") %>% word(3)
    recipe_data$sodium[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Sodium:\\s*\\d*") %>% word(2)
    recipe_data$potassium[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Potassium:\\s*\\d*") %>% word(2)
    recipe_data$fiber[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Fiber:\\s*\\d*") %>% word(2)
    recipe_data$sugar[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Sugar:\\s*\\d*") %>% word(2)
    recipe_data$vitamin_a[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Vitamin A:\\s*\\d*") %>% word(3)
    recipe_data$vitamin_c[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Vitamin C:\\s*\\d*") %>% word(3)
    recipe_data$calcium[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Calcium:\\s*\\d*") %>% word(2)
    recipe_data$iron[k] <- h %>% html_node(".wprm-nutrition-label-container-simple") %>% html_text() %>% str_extract("Iron:\\s*\\d*") %>% word(2)
     
  }
  return(recipe_data)
}

# Scrape the data
data <- get_recipe(final_links)

# Restrict to data that came from a recipe link
data_final <- data[!is.na(data$recipe),]

# Remove a few final links that look like recipes but aren't or contain more than one recipe on a single page
data_final <- data_final %>% filter(!str_detect(recipe,"Pizza toppings") & !str_detect(recipe,"Hot Cross Buns recipe") &
                                      !str_detect(recipe,"Crostini - 8 delicious ways!") & !str_detect(recipe,"8 simple Italian Pasta Recipes") &
                                      !str_detect(recipe,"CLASSIC Blueberry Cheesecake Bars") & !str_detect(recipe,"Lobster Recipes - for cooked lobster or crayfish") &
                                      !str_detect(recipe,"Healthier Creamy Yogurt Salad Dressings"))

# Set numeric columns to numeric
data_final[,c(2,3,6:8,10,11,13:26)] <- sapply(data_final[,c(2,3,6:8,10,11,13:26)], as.numeric)

# Set servings given as a size (as in, mL) to NA
data_final$servings[data_final$servings>60] <- NA

# Save the data
save(data_final,file="C:\\Users\\emmcr\\Documents\\BST260\\BST260_project_data.RDa")


