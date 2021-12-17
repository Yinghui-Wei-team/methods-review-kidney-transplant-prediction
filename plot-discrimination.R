### Summary of systematic review findings

#Libraries
library(readxl)
library(tidyverse)

#Read in data
summary<- read_xlsx("R_data_RoB.xlsx", sheet = "DataExtrac")

summary$Outcome[which(summary$Outcome == "All-cause mortality")]<- "Patient survival"

#Custom breaks on facet
breaks_fun <- function(x) {
  if(max(x) > 50) {
    seq(from = 0, to = max(summary$Used_sample_size_k), by = 20)
  } else if(max(x)>15) {
    seq(from = 0, to = 50, by = 10)
  } else {
    seq(from = 0, to = 15, by = 5)
  }
}

#Organise data for use in plot
summary<- summary %>%
  drop_na(est) %>%
  filter(measure %in% c("AUC", "C-statistic", "Harrell's C", "Optimism-corrected C", "Time-dependent AUC")) %>%
  filter(Outcome != "Graft failure (No Def)") %>%
  mutate(Used_sample_size_k = Used_sample_size / 1000)

#Scatter plot of discrimination against sample size
summary %>%
  ggplot(aes(x = Used_sample_size_k, y = as.numeric(est))) +
  geom_point(aes(shape = as.factor(measure)), size = 5) +
  facet_wrap(~ Outcome, scales = "free_x") +
  scale_x_continuous(breaks = breaks_fun, limits = c(0,NA)) +
  scale_y_continuous(breaks = seq(0.4, 1.0, by = 0.05), limits = c(0.4,0.9)) +
  scale_shape_manual(labels = c("AUC", "C-statistic", "Harrell's C", "Optimism corrected C-statistic", "Time-dependent AUC"), values = c(0, 1, 2, 15, 16))  +
  labs(x = "Sample size (x10^3)", y = "Discrimination value", shape = "Measure of discrimination") +
  theme(legend.title = element_text(10), legend.text = element_text(9))


#Boxplot of discrimination by predictor type
summary %>%
  filter(Model_type == "Development and validation") %>%
  ggplot(aes(x=Pred_type, y = as.numeric(est))) +
  geom_boxplot() +
  facet_wrap(~ Outcome, scales = "free_x") +
  scale_y_continuous(breaks = seq(0.5, 1.0, by = 0.05), limits = c(0.55,0.75)) +
  scale_x_discrete(labels = c("Donor only" = "Donor\nonly", "Donor/Recipient" = "Donor &\nRecipient", "Donor/Recipient/Tx" = "Donor,\nRecipient &\nTransplant", "Recipient only" = "Recpient\nonly")) +
  labs(x = "Predictor type", y = "Discrimination value")
