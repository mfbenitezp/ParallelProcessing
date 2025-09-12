library(parallel)
library(ggplot2)

# Detect cores
num_cores <- detectCores()

square_function <- function(x) {
  Sys.sleep(0.5) # simulate work
  x^2
}

numbers <- 1:10

# --- Sequential execution ---
start_seq <- Sys.time()
seq_result <- lapply(numbers, square_function)
end_seq <- Sys.time()
seq_time <- as.numeric(difftime(end_seq, start_seq, units = "secs"))  # convert to numeric seconds

# --- Parallel execution ---
start_par <- Sys.time()
par_result <- mclapply(numbers, square_function, mc.cores = num_cores)
end_par <- Sys.time()
par_time <- as.numeric(difftime(end_par, start_par, units = "secs"))  # convert to numeric seconds

# --- Print Results ---
cat("Sequential result:", unlist(seq_result), "\n")
cat("Parallel result:  ", unlist(par_result), "\n")
cat("Sequential time:", seq_time, "seconds\n")
cat("Parallel time:  ", par_time, "seconds\n")
cat("Speedup factor: ", round(seq_time / par_time, 2), "x faster\n")

# --- Plot ---
df <- data.frame(
  Method = c("Sequential", "Parallel"),
  Time = c(seq_time, par_time)
)

ggplot(df, aes(x = Method, y = Time, fill = Method)) +
  geom_bar(stat = "identity", width = 0.5) +
  labs(title = "Sequential vs Parallel Execution Time",
       y = "Execution Time (seconds)") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")


-----

library(parallel)
library(ggplot2)

# Detect number of available cores
num_cores <- detectCores()

square_function <- function(x) {
  Sys.sleep(0.5) # simulate work
  x^2
}

numbers <- 1:10

# Function to benchmark given number of cores
benchmark_cores <- function(cores) {
  start <- Sys.time()
  result <- mclapply(numbers, square_function, mc.cores = cores)
  end <- Sys.time()
  elapsed <- as.numeric(difftime(end, start, units = "secs"))
  return(elapsed)
}

# Sequential time (as baseline)
seq_start <- Sys.time()
seq_result <- lapply(numbers, square_function)
seq_end <- Sys.time()
seq_time <- as.numeric(difftime(seq_end, seq_start, units = "secs"))

# Benchmark parallel runs for 1, 2, ..., num_cores
cores_to_test <- 1:num_cores
times <- sapply(cores_to_test, benchmark_cores)

# Build dataframe
df <- data.frame(
  Cores = cores_to_test,
  Time = times
)

# Calculate speedup relative to sequential
df$Speedup <- seq_time / df$Time

# --- Plot Execution Time ---
p1 <- ggplot(df, aes(x = Cores, y = Time)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "steelblue", size = 3) +
  labs(title = "Execution Time vs. Number of Cores",
       x = "Number of Cores",
       y = "Execution Time (seconds)") +
  theme_minimal(base_size = 14)

# --- Plot Speedup Curve ---
p2 <- ggplot(df, aes(x = Cores, y = Speedup)) +
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "darkgreen", size = 3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Speedup vs. Number of Cores",
       x = "Number of Cores",
       y = "Speedup (Relative to Sequential)") +
  theme_minimal(base_size = 14)

print(p1)
print(p2)



