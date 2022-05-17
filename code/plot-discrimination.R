### Summary of systematic review findings

#Libraries
library(readxl)
library(tidyverse)
library(plyr)

#Read in data
summary<- read_xlsx("data/RoB_DataExtraction.xlsx", sheet = "DataExtrac")

#Organise data for use in plot
summary_tidy<- summary %>%
  drop_na(est) %>%
  filter(measure %in% c("AUC", "C-statistic", "Harrell's C", "Optimism-corrected C", "Time-dependent AUC")) %>%
  filter(Outcome != "Graft failure (No Def)") %>%
  mutate(Used_sample_size_k = Used_sample_size / 1000,
         Outcome = case_when(Outcome=="All-cause mortality" ~ "Patient survival",
                             TRUE ~ as.character(Outcome)))


#Custom breaks on facet
breaks_fun <- function(x) {
  if(max(x) > 50) {
    seq(from = 0, to = round_any(max(summary_tidy$Used_sample_size_k), 20, f=ceiling), by = 20)
  } else if(max(x)>15) {
    seq(from = 0, to = 50, by = 10)
  } else {
    seq(from = 0, to = 15, by = 5)
  }
}

#Scatter plot of discrimination against sample size
ggsave("figures/disc-by-sampsize.tiff", width = 180, height = 210, units = "mm",
       plot=summary_tidy %>%
         ggplot(aes(x = Used_sample_size_k, y = as.numeric(est))) +
         geom_point(aes(shape = as.factor(measure))) +
         facet_wrap(~ Outcome, scales = "free_x", ncol = 1) +
         scale_x_continuous(breaks = breaks_fun, limits = c(0,NA)) +
         scale_y_continuous(breaks = seq(0.4, 1.0, by = 0.05), limits = c(0.4,0.9)) +
         scale_shape_manual(labels = c("AUC", "C-statistic", "Harrell's C", "Optimism-corrected C-statistic", "Time-dependent AUC"), values = c(0, 1, 2, 15, 16))  +
         labs(x = "Sample size (in thousands)", y = "Discrimination metric", shape = "Measure of discrimination") +
         theme_bw() +
         theme(legend.position = "bottom", legend.direction = "vertical",
               axis.text = element_text(size=8)) +
         guides(shape=guide_legend(ncol=3))
)

