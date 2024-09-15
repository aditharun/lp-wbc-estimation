library(tidyverse)

set.seed(123)

############

args <- commandArgs(trailingOnly = TRUE)

# Initialize a list to hold named arguments
arg_list <- list()

# Parse named arguments (assuming --name=value format)
for (arg in args) {
  split_arg <- strsplit(arg, "=")[[1]]
  arg_name <- gsub("--", "", split_arg[1])
  arg_value <- split_arg[2]
  
  # Add the named argument to the list
  arg_list[[arg_name]] <- arg_value
}


b_r <- arg_list$br %>% as.numeric()
b_w <- arg_list$bw %>% as.numeric()
z_r <- arg_list$zr %>% as.numeric()
z_w <- arg_list$zw %>% as.numeric()
outfile <- arg_list$outfile

############

resultsdir <- "results"
if (!dir.exists(resultsdir)){
	dir.create(resultsdir)
}

a <- 1
b <- 100

n.samples <- 10000

sample_yr <- function(a, b, z_r){
	theta <- rbeta(n = 1, shape1 = a, shape2 = b)
	y_r <- theta*z_r
	return(y_r)
}

estimate_p <- function(b_r, z_r, y_r){
	p <- (z_r - y_r) / (b_r - y_r)
	return(p)
}

estimate_yw <- function(p, z_w, b_w){
	yw <- (z_w - p*b_w) / (1 - p)
	return(yw)
}

assess_SB <- function(y_w, b_w, p){
	sb <- (y_w / b_w) >= (p / (1-p))
	return(sb)
}


runMC <- function(a, b, b_r, b_w, z_r, z_w, idx){
	y_r <- sample_yr(a = a, b = b, z_r = z_r)
	phat <- estimate_p(b_r = b_r, z_r = z_r, y_r = y_r)
	y_w <- estimate_yw(p = phat, z_w = z_w, b_w = b_w)
	sbstatus <- assess_SB(y_w = y_w, b_w = b_w, p = phat)

	return(data.frame(y_r = y_r, p = phat, y_w = y_w, sb = sbstatus, idx = idx))
}

results <- lapply(1:n.samples, function(x) runMC(a = a, b = b, b_r = b_r, b_w = b_w, z_r = z_r, z_w = z_w, idx = x))

df <- results %>% do.call(rbind, .) %>% as_tibble()

saveRDS(df, file.path(resultsdir, outfile))



