### Summary of systematic review findings

#Libraries
library(readxl)
library(tidyverse)
library(plyr)

#Read in data
summary<- read_xlsx("data/data-extraction-rob-analysis.xlsx", sheet = "DataExtrac")

summary$Outcome[which(summary$Outcome == "All-cause mortality")]<- "Patient survival"

#Custom breaks on facet
breaks_fun <- function(x) {
  if(max(x) > 50) {
    seq(from = 0, to = round_any(max(summary$Used_sample_size_k), 20, f=ceiling), by = 20)
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
ggsave("disc-by-sampsize.tiff", width = 180, height = 105, units = "mm",
       plot=summary %>%
  ggplot(aes(x = Used_sample_size_k, y = as.numeric(est))) +
  geom_point(aes(shape = as.factor(measure)), size = 3) +
  facet_wrap(~ Outcome, scales = "free_x") +
  scale_x_continuous(breaks = breaks_fun, limits = c(0,NA)) +
  scale_y_continuous(breaks = seq(0.4, 1.0, by = 0.05), limits = c(0.4,0.9)) +
  scale_shape_manual(labels = c("AUC", "C-statistic", "Harrell's C", "Optimism-corrected C-statistic", "Time-dependent AUC"), values = c(0, 1, 2, 15, 16))  +
  labs(x = "Sample size (x10^3)", y = "Discrimination metric", shape = "Measure of discrimination") +
  theme_bw() +
  theme(legend.position = "bottom", legend.direction = "vertical",
        axis.text = element_text(size=8)) +
  guides(shape=guide_legend(ncol=3))
)


#Boxplot of discrimination by predictor type
summary %>%
  filter(Model_type == "Development and validation") %>%
  ggplot(aes(x=Pred_type, y = as.numeric(est))) +
  geom_boxplot(width=5) +
  facet_wrap(~ Outcome, scales = "free_x") +
  scale_y_continuous(breaks = seq(0.5, 1.0, by = 0.05), limits = c(0.55,0.75)) +
  scale_x_discrete(labels = c("Donor only" = "Donor\nonly", "Donor/Recipient" = "Donor &\nRecipient", "Donor/Recipient/Tx" = "Donor,\nRecipient &\nTransplant", "Recipient only" = "Recpient\nonly")) +
  labs(x = "Predictor type", y = "Discrimination value") +
  theme_bw() +
  theme(axis.text = element_text(size=6), axis.title = element_text(size=10))


ggsave("disc-by-pred.tiff", width = 180, height = 105, units = "mm",
        plot=summary %>%
  filter(Model_type == "Development and validation") %>%
  ggplot(aes(x=Pred_type, y = as.numeric(est))) +
  geom_boxplot() +
  facet_wrap(~ Outcome, scales = "free_x") +
  scale_y_continuous(breaks = seq(0.5, 1.0, by = 0.05), limits = c(0.55,0.75)) +
  scale_x_discrete(labels = c("Donor only" = "Donor\nonly", "Donor/Recipient" = "Donor &\nRecipient", "Donor/Recipient/Tx" = "Donor,\nRecipient &\nTransplant", "Recipient only" = "Recpient\nonly")) +
  labs(x = "Predictor type", y = "Discrimination value") +
    theme_bw() +
    theme(axis.text = element_text(size=6), axis.title = element_text(size=10))
)
