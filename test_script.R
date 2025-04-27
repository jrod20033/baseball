# test_script.R

# Log R version
cat("R version: ", R.version.string, "\n")

# Load required package with error handling
if (!require("baseballr", quietly = TRUE)) {
  cat("Installing baseballr...\n")
  install.packages("baseballr", repos = "https://cloud.r-project.org", dependencies = TRUE)
  library(baseballr)
}

# Get today's date
today <- Sys.Date() - 1  # Yesterday's date

# Log script start
cat("Script started at: ", as.character(Sys.time()), "\n")
cat("Querying Statcast data for date: ", as.character(today), "\n")

# Pull Statcast data for today (batted balls only)
message("Pulling Statcast data for: ", today)

data <- tryCatch({
  statcast_search(
    start_date = today,
    end_date = today,
    player_type = "batter"
  )
}, error = function(e) {
  cat("Error fetching Statcast data: ", conditionMessage(e), "\n")
  stop("Script failed due to data fetch error.")
})

# Check if data is returned
cat("Number of rows retrieved: ", nrow(data), "\n")
if (nrow(data) == 0) {
  cat("No batted ball data available for ", today, ". Trying a date range...\n")
  data <- statcast_search(
    start_date = today - 7,
    end_date = today,
    player_type = "batter"
  )
  cat("Number of rows retrieved (date range): ", nrow(data), "\n")
}

if (nrow(data) > 0) {
  cat("Columns in data: ", paste(colnames(data), collapse = ", "), "\n")
  # Get top 10 exit velocities
  top_ev <- data[order(-data$launch_speed), c("player_name", "launch_speed", "events", "game_date")]
  top_ev <- na.omit(top_ev)
  top10 <- head(top_ev, 10)

  cat("Top 10 Exit Velocities for ", today, ":\n")
  write.csv(top10, stdout(), row.names = FALSE)
} else {
  cat("No batted ball data available for the date range.\n")
}
