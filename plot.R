library(tidyverse)

args <- commandArgs(trailingOnly = TRUE)

filepath <- args[1]

df <- readRDS(file.path("results", filepath))

if (!dir.exists("fig")){
	dir.create("fig")
}

(cowplot::plot_grid(df %>% ggplot(aes(x=y_r)) + geom_density(color = "grey60", fill = "grey40", alpha = 0.5) + theme_minimal() + xlab(expression(y[r])) + ylab("Density")  + theme(axis.text.y = element_blank()) + theme(panel.grid = element_blank(), panel.background = element_rect(color = "black"), axis.ticks.x = element_line(color = "black")) + ylim(0, 0.06) + scale_x_continuous(breaks = scales::pretty_breaks(n = 5)) + theme(axis.text.x = element_text(size = 9), axis.title = element_text(size = 11)), df %>% ggplot(aes(x=p)) + geom_density(color = "grey60", fill = "grey40", alpha = 0.5) + theme_minimal() + xlab(expression("Estimate for p")) + ylab("Density")  + scale_x_continuous(limits = c(4e-4, 6e-4),breaks = scales::pretty_breaks(n = 5)) + theme(axis.text.y = element_blank()) + theme(panel.grid = element_blank(), panel.background = element_rect(color = "black"), axis.ticks.x = element_line(color = "black")) + theme(axis.text.x = element_text(size = 9), axis.title = element_text(size = 11)),df %>% ggplot(aes(x=y_w)) + geom_density(color = "grey60", fill = "grey40", alpha = 0.5) + theme_minimal() + xlab(expression(paste("Estimate for ", y[w]))) + ylab("Density") + scale_x_continuous(limits = c(36, 39),breaks = scales::pretty_breaks(n = 5)) + theme(axis.text.y = element_blank()) + theme(panel.grid = element_blank(), panel.background = element_rect(color = "black"), axis.ticks.x = element_line(color = "black")) + theme(axis.text.x = element_text(size = 9), axis.title = element_text(size = 11)), nrow = 1, labels = c("A", "B", "C"), label_size = 15)) %>% ggsave(plot = ., filename = "fig/fig1.pdf", device = cairo_pdf, units = "in", height = 3, width = 9)