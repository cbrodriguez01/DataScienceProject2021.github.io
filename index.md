
### Emma Crenshaw, Carmen Rodriguez, Aiza Malik, Ligia Flores



## Project Overview

It can be hard to judge the quality of online recipes without trying them as a home chef, and it can be hard as a content creator to determine how to best market your recipes. We want to determine if we can predict the popularity of online recipes with just the easily quantifiable information provided with most recipes, such as number of ingredients, cook time, and number of recipe steps. This could allow users to better identify aspects of a recipe that may make it a better choice and could help content-creators finetune their recipe creation.

## Objective

Determine how well we can predict the popularity of a recipe (i.e., number of reviews) based on the easily ‘seen’ aspects of a recipe (i.e., number of ingredients, time it takes to make, etc) and create an algorithm to help recipe creators predict whether a recipe will be popular.

##  Data and Approach

We conducted web scrapping  from [RecipetinEats](https://www.recipetineats.com/).
After performing quality checks of the data and data cleaning, we conducted exploratory analysis to examine which recipe features were associated with recipe popularity defined as number of ratings.  We fitted a Random Forest regression to predict recipe popularity (number of ratings) of the recipe based on all other features on the dataset. 

**ADD OTHER ANALYSES**


## Analysis

### Exploratory Analysis 

Using the training set we made some plots to help assess the relationship between recipe popularity  `n_ratings`, and each of the other features of interest in the data set. 

# ![](scatter.png)

Looking at the scatterplots we do not see any relationship patterns between recipe popularity and any of features. Through further assessment using correlations, we confirmed that none of the features had adequate correlation with recipe popularity `n_ratings`.



### Decision Tree Results




###  Random Forest Results

-  Error rate of the full model stabilized with around 200 trees but continues to decrease slowly until around 300 or so trees.

-  Model did not perform well in the test set. This is because predictors were uncorrelated with recipe popularity `n_ratings`. Therefore, the random forest algorithm  was forced to choose amongst only "noise" variables at many of its splits leading to poor performance.

- The two most predictive variables as determined by their Gini coefficient were: cook time and number of ingredients. Reducing the model to only include important variables decreased the mean square error from  6098 to 5517.






### MAP 



### SCREENCAST VIDEO LINK









