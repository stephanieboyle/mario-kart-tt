# A small TidyTuesday exploration of Mario Kart record times.
library(tidyverse)
library(tidytext)

records <- readr::read_csv("data/records.csv", show_col_types = FALSE)
dir.create("final_plots", showWarnings = FALSE)

my_theme <- theme_minimal(base_size = 12, base_family = "sans") +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 21, face = "bold"),
        plot.subtitle = element_text(colour = "#52666C"),
        plot.title.position = "plot",
        legend.position = "bottom",
        plot.margin = margin(16, 20, 16, 16))
palette <- c("#5B0893", "#078C84")

tracks_plot <- records %>%
  group_by(track, type) %>%
  summarise(median_minutes = median(time, na.rm = TRUE) / 60, .groups = "drop") %>%
  mutate(type = as.factor(type),
         track = reorder_within(track, median_minutes, type)) %>%
  ggplot(aes(x = track, y = median_minutes, fill = type)) +
  geom_col(show.legend = FALSE, width = 0.75) +
  facet_wrap(~type, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  scale_fill_manual(values = palette) +
  labs(title = "Which tracks take the most time?",
       subtitle = "Median record time by track, split by record type",
       x = NULL, y = "Median time (minutes)",
       caption = "Source: TidyTuesday, 25 May 2021. Longer times do not establish greater difficulty.") +
  my_theme

shortcuts_plot <- records %>%
  group_by(track, shortcut) %>%
  summarise(median_minutes = median(time, na.rm = TRUE) / 60, .groups = "drop") %>%
  ggplot(aes(x = shortcut, y = median_minutes, fill = shortcut)) +
  geom_col(width = 0.7) +
  facet_wrap(~track) +
  scale_fill_manual(values = palette) +
  labs(title = "How do shortcut record times compare?",
       subtitle = "Median recorded times in the bundled historical snapshot",
       x = NULL, y = "Median time (minutes)", fill = "Shortcut",
       caption = "Observational comparison: player, record type and date may also affect the times.") +
  my_theme +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("final_plots/mario_kart_tracks.png", tracks_plot,
       width = 11, height = 8, dpi = 160, bg = "white")
ggsave("final_plots/short_cuts.png", shortcuts_plot,
       width = 12, height = 10, dpi = 160, bg = "white")
