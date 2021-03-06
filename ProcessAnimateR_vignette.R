# Libraries ---------------------------------------------------------------

library(dplyr) ##pipes
library(tidyr) ##tidy data
library(lubridate) ##date time
library(bupaR) ##buisness process analytics
library(processanimateR) ##animates process


# Create performance time flags ------------------------------------------------

my_flags <- data.frame(value = c(0,2,4,8,16)) %>% 
  mutate(day = days(value))


# Create timestamps of flags ----------------------------------------------

my_timeflags <- patients %>% 
  cases %>%
  crossing(my_flags) %>% 
  mutate(time = start_timestamp + day) %>% 
  filter(time <= complete_timestamp) %>% 
  select("case" = patient,time,value) ##must be case, time, value


# Animate process ---------------------------------------------------------

patients %>%
  animate_process(mode ="absolute",
                  jitter=10,
                  legend = "color", 
                  mapping = token_aes(
                    color = token_scale(my_timeflags
                                        , scale = "ordinal"
                                        , domain = my_flags$value
                                        , range = rev(RColorBrewer::brewer.pal(5,"Spectral"))
                    )))