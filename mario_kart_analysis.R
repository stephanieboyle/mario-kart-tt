# load in the libraries
library(tidyverse)
library(ggdark)

# create my theme options
my_theme <- theme_bw() + 
  theme(text = element_text(family="Fira Code", size = 12), 
        plot.title = element_text(size = 16, face = "bold")) + 
  theme(legend.position = "none")

# load in the data 
records <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/records.csv')

# have a look at the data 
glimpse(records)

# do shortcuts pay off?
records %>% 
  group_by(track, shortcut) %>%
  summarise(total_time = mean(time)/60) %>% 
  arrange(track, shortcut) %>%
  ggplot(aes(x = shortcut, y = total_time, fill = shortcut)) + 
  geom_col() + 
  facet_wrap( . ~ track) + 
  labs(title = "Does taking a shortcut pay off?", 
          subtitle = "From the data, it seems that every time a shortcut is taken, the average times are lower. Time saved probably offsets \nthe risks of shortcuts.\n ", 
       x = "\n Shortcut used?",
       y = "Average time (mins) \n") + 
  scale_fill_manual(values = c("#5B0893","#078C84")) + 
  my_theme


# average time of each track type
records %>%
  group_by(track) %>% 
  summarise(median_times = median(time)/60) %>%
  ggplot(aes(x = reorder(track,median_times), y = median_times, fill = track)) + 
  geom_col() + 
  coord_flip() + 
  labs(title = "Which tracks take the most time?", 
       subtitle = "Seems like Rainbow Road is NOT the most difficult track\n", 
       y = "Median time (mins)", 
       x = " ") + 
  my_theme


# test which tracks take the longest (type of lap maybe has an effect)
records %>% 
  group_by(track, type) %>% 
  summarise(median_times = median(time, na.rm = TRUE)/60) %>%
  ungroup() %>%
  mutate(type = as.factor(type),
         track = reorder_within(track, median_times, type)) %>%
  ggplot(aes(x = track, y = median_times, fill = type)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ type, scales="free_y") +
  coord_flip() +
  scale_x_reordered() + 
  scale_fill_manual(values = c("#5B0893","#078C84")) + 
  labs(title = "Which tracks take the most time?", 
       subtitle = "My childhood suspicions are correct, and Rainbow Road seems like the most time consuming (and therefore difficult?) track\n", 
       y = "Median time (mins)", 
       x = " ") + 
  my_theme


ggsave("mario_kart_tt.png")

