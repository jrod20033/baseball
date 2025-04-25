# test_script.R

# Load required package
if (!require("baseballr")) install.packages("baseballr", repos = "http://cran.us.r-project.org")
library(baseballr)

# Get today's date
today <- Sys.Date() - 1  # Yesterday's date

# Pull Statcast data for today (batted balls only)
message("Pulling Statcast data for: ", today)

data <- statcast_search(
  start_date = today,
  end_date = today,
  player_type = "batter"
)

# Check if data is returned
if (nrow(data) == 0) {
  cat("No batted ball data available for today yet.\n")
} else {
  # Get top 10 exit velocities
  top_ev <- data[order(-data$launch_speed), c("player_name", "launch_speed", "events", "game_date")]
  top_ev <- na.omit(top_ev)
  top10 <- head(top_ev, 10)

  cat("Top 10 Exit Velocities for", today, ":\n")
  print(top10, row.names = FALSE)
}
