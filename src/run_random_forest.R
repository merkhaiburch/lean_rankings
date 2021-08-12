# ---------------------------------------------------------------
# Author.... Merritt Khaipho-Burch
# Contact... mbb262@cornell.edu
# Date...... 2021-08-11 
#
# Description 
#   - Determining with replicated trials what the best Lean Cuisine
#   - flavor is because why not use statistics for something dumb
#   - this time featuring random forest models
# ---------------------------------------------------------------

# ----------------------------------
# Data formatting and package import
# ----------------------------------

# Get helpful packages
library(dplyr)
library(ggplot2)
library(ranger)

# Load in data
rankings <- read.csv("data/rankings.csv",
                     na.strings = "NA")

# Do some generic formatting
rankings$trial_round <- as.factor(rankings$trial_round)

# remove ranking column for this analysis because the first trial round
# was missing the order_eaten
rankings <- rankings |> select(-"order_eaten")

# Check correlation of predictors
corrplot::corrplot(cor(rankings %>% select_if(is.numeric), method = "spearman"), 
                   type = "lower", method = "square")


# -------------------------------
# Set up random forest model
# -------------------------------

# Split training and testing
lean_sample <- caTools::sample.split(rankings$trial_round, SplitRatio = .70)
lean_train <- subset(rankings, lean_sample == TRUE)
lean_test <- subset(rankings, lean_sample == FALSE)
dim(lean_train)


# -------------------------------
#         Run model
# -------------------------------


lean_rf <- ranger::ranger(ranking ~ ., 
                          importance = 'impurity', 
                          data = lean_train, 
                          num.trees = 500)
lean_rf

# Plot importance
temp <- as.data.frame(lean_rf$variable.importance)
temp$type <- rownames(temp)
colnames(temp) <- c("Importance", "Variable_Type")
temp$Importance <- temp$Importance/max(temp$Importance)

temp %>% 
  dplyr::arrange(desc(Importance)) %>%
  ggplot(aes(x= reorder(Variable_Type, Importance), y = Importance)) +
  geom_col() +
  coord_flip() +
  ggtitle("Importance of Factors in Lean Cusine Rankings") +
  xlab("Variable Type") +
  ylab("Relative Importance")


# ----------------------
# Assess predictions
# ----------------------

# Make prediction
lean_pred <- predict(object = lean_rf, data = lean_test)
lean_test$lean_pred <- lean_pred$predictions

# Look at prediction relationship
cor(lean_test$ranking, lean_test$lean_pred)
summary(lm(ranking~lean_pred, lean_test))

# Plot relationship
ggplot(lean_test, aes(x = ranking, y = lean_pred)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs(x = "Actual Ranking", 
       y = "Predicted Ranking", 
       title = "Lean Cusine Ranking Random Forest Prediction") +
  geom_text(x = 19, y = 23.5, label = "R^2 = 0.045, p = 0.35")






