#Load required libraries
library(rpart) #CART
library(rpart.plot) #plot CART
library(dplyr)
library(magrittr)

setwd("C:/Users/cknox/OneDrive/Documents/slr_sims_cornell/box_files_jan_exp_set")


#Load CSV of ANOVA data
metrics <- read.csv(file = 'total_costs_for_anova.csv')
metrics %>% filter(year==2025) -> df_filt

year_list <- list(2025, 2030,2035, 2040, 2045, 2050, 2055,2060, 2065, 2070, 2075, 2080, 2085, 2090, 2095,2100)
for (item in year_list) {
  metrics %>% filter(year==item) -> df_filt
  
  df_filt$Adaptation.Coordination=as.factor(df_filt$Adaptation.Coordination)
  df_filt$Sea.Level.Rise=as.factor(df_filt$Sea.Level.Rise)
  df_filt$Agents..Perceived.Sea.Level.Rise.Projection=as.factor(df_filt$Agents..Perceived.Sea.Level.Rise.Projection)
  df_filt$discount=as.factor(df_filt$discount)
  df_filt$external.financing.percent=as.factor(df_filt$external.financing.percent)
  df_filt$planning.horizon.delay=as.factor(df_filt$planning.horizon.delay)
  df_filt$permitting.delay=as.factor(df_filt$permitting.delay)
  df_filt$flood.pattern=as.factor(df_filt$flood.pattern)
  df_filt$reduction.funding.access=as.factor(df_filt$reduction.funding.access)
  df_filt$maintenance.fee=as.factor(df_filt$maintenance.fee)
  df_filt$permitting.cost.proportion=as.factor(df_filt$permitting.cost.proportion)
  
  
  anova_model <- aov(Total_Costs ~ Adaptation.Coordination + Sea.Level.Rise + Agents..Perceived.Sea.Level.Rise.Projection + discount +  external.financing.percent + planning.horizon.delay + permitting.delay + flood.pattern + reduction.funding.access + permitting.cost.proportion + maintenance.fee, data = df_filt)
  summary(anova_model)
  anova_summary <- summary(anova_model)[[1]]
  
  # Output the results
  cat(item)
  cat("     .....")
  cat(sum_squares_factors <- anova_summary$`Sum Sq`)
  
}
summary(anova_model)




