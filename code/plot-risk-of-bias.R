### Plot for risk of bias

#Libraries
library(readxl)
library(tidyverse)

#Read in data
data<- read_xlsx("data/RoB_DataExtraction.xlsx", sheet = "RoB")

#Rearrange in long format
data_long<- data %>%
  pivot_longer(c(Participants, Predictors, Outcome, Analysis, Overall), names_to = "Domain", values_to = "Risk")

#Summary plot of risk of bias in each domain 
ggsave("figures/rob.tiff", width = 210, height = 120, units = "mm",
       plot=data_long %>%
         group_by(Domain, Risk) %>%   #group to get number of each level of risk in each domain
         dplyr::summarise(n = n()) %>%
         ggplot(aes(x=factor(Domain, levels = c("Overall", "Analysis", "Outcome", "Predictors", "Participants")), y = n, fill=factor(Risk, levels = c("High", "Unclear", "Low")))) +
         geom_bar(stat = "identity") +
         coord_flip() +
         geom_text(aes(label= n), size = 4, position = position_stack(vjust = 0.5)) +   #add number in each category
         theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(),
               axis.title.y = element_blank(), axis.ticks.y = element_blank(),
               panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_blank(),
               legend.position = "bottom",
               axis.text.y = element_text(size = 12)) +
         scale_fill_grey("Risk of bias", start = 0.5, end = 0.9)
)


