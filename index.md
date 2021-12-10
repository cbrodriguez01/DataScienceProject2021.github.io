# Predicting Popularity of Recipes from Recipetin Eats


### Emma Crenshaw, Carmen Rodriguez, Aiza Malik, Ligia Flores



## Project Overview

It can be hard to judge the quality of online recipes without trying them as a home chef, and it can be hard as a content creator to determine how to best market your recipes. We want to determine if we can predict the popularity of online recipes with just the easily quantifiable information provided with most recipes, such as number of ingredients, cook time, and number of recipe steps. This could allow users to better identify aspects of a recipe that may make it a better choice and could help content-creators finetune their recipe creation.

## Objective

Determine how well we can predict the popularity of a recipe (i.e., number of reviews) based on the easily ‘seen’ aspects of a recipe (i.e., number of ingredients, time it takes to make, etc) and create an algorithm to help recipe creators predict whether a recipe will be popular.

##  Data and Approach

We conducted web scraping  from [RecipetinEats](https://www.recipetineats.com/), taking data from every recipe on the website.
After performing quality checks of the data and data cleaning, we conducted exploratory analysis to examine which recipe features were associated with recipe popularity defined as number of ratings.  We fitted a Random Forest regression to predict recipe popularity (number of ratings) of the recipe based on all other features on the dataset, a decision tree regression and one visualization to see which recipes were most popular based on cuisine.

The variables available are described below:

  - **recipe**: Name of the recipe
  - **cook_time**: Amount of time the recipe takes to actively cook (minutes)
  - **prep_time**: Amount of preparation time the recipe takes (minutes)
  - **course**: Course of the recipe (ex: main)
  - **cuisine**: Type of cuisine. This could be a single string or a list
  - **rating**: The average rating of the recipe from 1-5
  - **n_ratings**: The number of ratings the recipe has
  - **servings**: Number of servings the recipe yields
  - **ingredients**: List of ingredients used in the recipe, separated by a semicolon
  - **n_ingredients**: Number of ingredients
  - **n_steps**: Number of steps in the recipe
  - **calories**: Number of calories per serving in the recipe
  - **carbs**: Number of grams of carbohydrates per serving 
  - **protein**: Grams of protein per serving
  - **fat**: Grams of total fat per serving
  - **sat_fat**: Grams of saturated fat per serving
  - **poly_fat**: Grams of polyunsaturated fat per serving
  - **mono_fat**: Grams of monounsaturated fat per serving
  - **sodium**: mg of sodium per serving
  - **potassium**: mg of potassium per serving
  - **fiber**: Grams of fiber per serving
  - **sugar**: Grams of sugar per serving
  - **vitamin_c**: mg of vitamin A per serving
  - **vitamin_a**: international units (IU) of vitamin A per serving
  - **calcium**: mg of calcium per serving
  - **iron**: mg of iron per serving


**ADD OTHER ANALYSES**


## Analysis

### Exploratory Analysis 

Using the training set we made some plots to help assess the relationship between recipe popularity  `n_ratings`, and each of the other features of interest in the data set. 

![](scatter.png)

Looking at the scatterplots we do not see any relationship patterns between recipe popularity and any of features. Through further assessment using correlations, we confirmed that none of the features had adequate correlation with recipe popularity `n_ratings`.







###  Random Forest Results

-  Error rate of the full model stabilized with around 200 trees but continues to decrease slowly until around 300 or so trees.

-  Model did not perform well in the test set. This is because predictors were uncorrelated with recipe popularity `n_ratings`. Therefore, the random forest algorithm  was forced to choose amongst only "noise" variables at many of its splits leading to poor performance.

- The two most predictive variables as determined by their Gini coefficient were: cook time and number of ingredients. Reducing the model to only include important variables decreased the mean square error from  6098 to 5517.


### Decision Tree Results

Continuing the section of machine learning, let us predict recipe popularity by fitting decision tree model.
For the purpose of the project, predictors of interest would be in terms of convenience (this means including prep time, cook time, number of steps, number of ingredients, servings).

Before fitting a decision tree model, we first fitted a linear regression model with lm that predicts number of ratings using cook time,prep time,servings, number of ingredients, and number of steps in the training data.
The linear regression model summary showed that only the coefficient for cook time is significant at a 0.05 threshold.

Now fitting a decision tree model that predicts `n_ratings` using cook time,prep time,servings, number of ingredients, and number of steps in the training data, we get the following decision tree:

![](decisiontree1.png)

The tree suggests that the recipes with higher cook time corresponds to lower total number of ratings and includes the variable that we identified as being significant in the linear model (`n_rating`), plus number of steps and number of ingredients.

##Exploring Cuisine Categories as Potential Predictor For Decision Tree Model

In the RecipeTin Eats website, there are  9 cuisine categories (Asian,French,Greek,Indian,Italian,Mediterranean,Mexican,Middle Eastern, and South America). Yet, it turns out there is actually 178 different type of cuisine categories in this website after webscraping, making it difficult to have cuisine as a predictor. We do wonder in that if the type of cuisine plays any role in popularity of a recipe and wanted to create a world map of the different types of cuisines (which is shown later on). We all experienced at some point random cravings of certain types of food. With that said, let us explore the relationship between number of ratings and different types of cuisines. In order to see the correlation and include the `cuisine` predictor in the decision tree model, we regrouped the 178 different types of cuisines from this website into 12 categories (similar to the cuisine category displayed on recipetin eats website). The categories are: 1) European/Western, 2) Americanized_cultural_food,3) Asian, 4) Australian,5) French,6) Indian,7) Italian,8)Mediterranean,9) Mexican, 10) Middle Eastern, 11) South American/Caribbean, and 12) Other which includes categories of dog food, holidays, and categories not in particular to regions.

![](cuisine_cat_barplot.png)

Here we see there is a significance between the different types of cuisines and number of ratings but it is not enough for us to say the category/type of cuisine is a predictor for popularity of recipe. We explore more by fitting a decision tree and linear regression model including the cuisine type variable now. In terms of the most popular cuisine category, the European/Western category has the most total number of ratings than all the other cuisine categories. This however is not enough to imply that the type of cuisine plays a factor in predicting popularity in recipes given that the way the website identified the cuisine type of a recipe as Western was general. The type of cuisine categories breakdown is explained on the README file. Let us now explore the type of cuisine variable as a potential predictor.

We first fitted a linear regression model with lm that predicts number of ratings using cook time,prep time,servings, number of ingredients,number of steps, and now cuisine type in the training data.
The linear regression model summary again showed that only the coefficient for cook time is significant at a 0.05 threshold.

Now fitting a decision tree model that predicts `n_ratings` using cook time,prep time,servings, number of ingredients, number of steps, and now cuisine type in the training data, we get the following decision tree:

![](decisiontree2.png)


Here we can also see that although we added the new predictor variable `cuisine`, the significant predictor is still cook time and the variables included in the decision tree has not changed. 

Exploring still on the cuisine categories, we will now look at a world map/heat map of the different cuisines we have here.


### MAP 



### SCREENCAST VIDEO LINK









