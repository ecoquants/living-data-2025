#!/usr/bin/env Rscript
# Living Data 2025 - Quick Start Script
# This script installs required packages and launches the Shiny app

cat("\n")
cat("=====================================================\n")
cat("  Living Data 2025 - Personal Schedule Builder\n")
cat("=====================================================\n\n")

# Check if running interactively
if (interactive()) {
  cat("Running in interactive mode...\n\n")
} else {
  cat("Running from command line...\n\n")
}

# List of required packages
required_packages <- c("shiny", "DT", "dplyr", "tidyr", "readr", 
                       "lubridate", "stringr", "bslib")

cat("Checking required packages...\n")

# Function to install missing packages
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  
  if(length(new_packages) > 0) {
    cat("\nInstalling missing packages:", paste(new_packages, collapse=", "), "\n")
    install.packages(new_packages, dependencies = TRUE, 
                    repos = "https://cloud.r-project.org")
    cat("Installation complete!\n\n")
  } else {
    cat("All required packages are already installed.\n\n")
  }
}

# Install missing packages
install_if_missing(required_packages)

# Load packages to verify
cat("Loading packages...\n")
invisible(lapply(required_packages, function(pkg) {
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  cat("  ✓", pkg, "\n")
}))

cat("\n")

# Check if schedule file exists
if (!file.exists("living_data_schedule.csv")) {
  cat("ERROR: living_data_schedule.csv not found!\n")
  cat("Please ensure the schedule CSV file is in the same directory as this script.\n\n")
  quit(status = 1)
}

# Load and show quick stats
cat("Loading schedule data...\n")
schedule <- read_csv("living_data_schedule.csv", show_col_types = FALSE)

cat("\n")
cat("Schedule Summary:\n")
cat("  Total events:", nrow(schedule), "\n")
cat("  Days:", paste(unique(schedule$day), collapse=", "), "\n")
cat("  Locations:", length(unique(schedule$location)), "\n")
cat("  Event types:", paste(unique(schedule$type), collapse=", "), "\n")

cat("\n")
cat("=====================================================\n")
cat("  Launching Shiny App...\n")
cat("  The app will open in your default web browser.\n")
cat("  Press Ctrl+C (or Cmd+C on Mac) to stop the app.\n")
cat("=====================================================\n\n")

# Small delay for dramatic effect
Sys.sleep(1)

# Launch the app
if (file.exists("app.R")) {
  shiny::runApp("app.R", launch.browser = TRUE)
} else {
  cat("ERROR: app.R not found!\n")
  cat("Please ensure app.R is in the same directory as this script.\n\n")
  quit(status = 1)
}
