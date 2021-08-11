# ---------------------------------------------------------------
# Author.... Merritt Khaipho-Burch
# Contact... mbb262@cornell.edu
# Date...... 2021-08-11 
#
# Description 
#   - Determining with replicated trials what the best Lean Cusine
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
rankings <- read.csv("~/git_projects/lean_rankings/data/rankings.csv")
rankings <- read.csv("C:/Users/merri/git_projects/")

# Do some genneric formatting
rankings$trial_round <- as.factor(rankings$trial_round)

