# ---------------------------------------------------------------
# Author.... Merritt Khaipho-Burch
# Contact... mbb262@cornell.edu
# Date...... 2021-06-23 
#
# Description 
#   - Determining with replicated trials what the best Lean Cusine
#   - flavor is because why not use statistics for something dumb
# ---------------------------------------------------------------

# ----------------------------------
# Data formatting and package import
# ----------------------------------

# Get helpful packages
library(dplyr)
library(ggplot2)
library(lme4)

# Load in data
rankings <- read.csv("~/git_projects/lean_rankings/data/rankings.csv")

# Do some genneric formatting
rankings$trial_round <- as.factor(rankings$trial_round)


# -----------------
# Plot raw data
# -----------------

# Calculate some basic statistics
stats_rankings <- Rmisc::summarySE(rankings, measurevar="ranking", groupvars=c("flavor"))

# Order from lower mean ranking to higher
stats_rankings$flavor <- factor(stats_rankings$flavor, 
                                levels = stats_rankings$flavor[order(stats_rankings$ranking)])

# Plot rankings
ggplot(stats_rankings, aes(x = flavor, y = ranking)) +
  geom_point() +
  geom_errorbar(aes(ymin = ranking-se, ymax = ranking+se), 
                width=.2, position = position_dodge(0.05)) +
  coord_flip() +
  xlab("Lean Cusine Meal Name") +
  ylab("Mean Ranking (smaller number = best relative taste)")


# -------------
# Run models
# -------------

# Run a random effect model using block as a random effect
# Doesn't work yet because experiment isn't finished
model1 <- lme4::lmer(formula = ranking ~ flavor +  1|trial_round, 
                     data = rankings)

