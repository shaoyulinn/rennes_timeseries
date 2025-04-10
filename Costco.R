######Team Member######
# Yu-Lin SHAO - ETU20240200 
# Yi-Hsin TUNG - ETU20240215 
# Chiao-Jung TING - ETU20240499 
# Marcelo MARTINEZ JEZZINI - ETU20240477 
# Abhishek CHAUDHARY - ETU20232254 
#######################

########## Data Description ###############################################################################
# 1. Problem Statement and Objective of the Analysis
# Problem Statement:
# The problem consists of forecasting the future behavior of Costco's adjusted closing stock price. 
# To achieve this, historical monthly price data from January 2020 to December 2024 is used, 
# addressing the challenges of modeling a time series that may include missing values and outliers. 
# The task involves comparing different time series models to determine which best captures the historical 
# dynamics and provides reliable forecasts for future periods.

# Objective of the Analysis:
# The primary goal of the analysis is to:
# Modeling and Forecasting: Develop and compare time series models—specifically ARIMA and ETS—to predict future stock prices.

# Model Evaluation: Use error metrics (RMSE, MAE, MAPE) together with model selection criteria (AIC and BIC) 
# to determine the model that offers the best forecast accuracy and fit.

# Optimization and Visualization: Optimize the chosen model (ARIMA, in this case, which has shown superior performance) 
# to project stock prices for the upcoming months, and visualize the comparison between forecasted values and actual data.
##########################################################################################################################

###################### Brief Project Proposal ######################################################################
## 2. Brief Project Proposal

# Project Title:
# Forecasting Costco Stock Prices Using Time Series Models

# Selected Dataset:
# Source and Period: Historical adjusted closing prices for Costco stock, downloaded from Yahoo Finance, 
# covering the period from January 2020 to December 2024.

# Characteristics: The dataset contains monthly data, enabling analysis of the overall trend 
# and the detection of relevant patterns in the price evolution.



# Methodology and Approach:
# 1. Data Preprocessing:
# Extraction and Conversion: Utilizing the getSymbols() function to obtain the data and converting it into a time series object.

# Handling Missing Values and Outliers: Applying interpolation techniques to manage missing values and identifying/replacing
# outliers using visual inspection and specific functions (e.g., tsoutliers).


# 2. Data Splitting:
# Training and Testing: Dividing the dataset into a training set (up to June 2024) and a testing set (from July to December 2024)
# to rigorously evaluate the predictive capability of the models.


# 3. Modeling and Evaluation:
# Models Compared:
# ARIMA Model: Captures trend and autocorrelation structures within the series.
# ETS Model: Although it models error, trend, and seasonality components, its performance is limited due to the absence of a clear seasonal pattern in the data.

# Comparison of Results: The evaluation is based on error metrics (RMSE, MAE, MAPE) and information criteria (AIC and BIC),
# with the ARIMA model showing superior results.

# Optimization: An additional optimization step is undertaken for the ARIMA model to enhance the overall fit, 
# and stock price projections are generated for a future period (e.g., the first months of 2025).


# 4. Visualization and Validation:
# Generating comparative graphs that display the historical series, model forecasts, and the deviation (error) relative to the test set.


# Expected Outcomes:
# Selection of the Best Model
# Reliable Forecasts
# Comprehensive Visual and Metric Report
######################################################################################################################################

# Load necessary libraries
library(quantmod)
library(forecast)
library(ggplot2)
library(Metrics)
library(dplyr)
library(quantmod)

# Get Costco stock data
getSymbols("COST", src = "yahoo", from = "2020-01-01", to = "2024-12-31", periodicity = "monthly")

# Extract Adjusted Close prices
cost_monthly <- to.monthly(COST, indexAt = "lastof", OHLC = FALSE)
cost_close <- Cl(cost_monthly)

# Convert to time series format
cost_ts <- ts(cost_close, start = c(2020, 1), frequency = 12)

# Handle missing values (NA)
sum(is.na(cost_ts))  # Check for NA
cost_ts <- na.interp(cost_ts)  # Interpolate missing values (linear)

# Handle outliers (visual inspection + replacement)
outlier_result <- tsoutliers(cost_ts)
print(outlier_result)

# Replace outliers with adjusted values
cost_ts[outlier_result$index] <- outlier_result$replacements

# Visualize
autoplot(cost_ts) + ggtitle("Costco Monthly Adjusted Closing Price (2020–2024)")


# Step 1: Split data
train_ts <- window(cost_ts, end = c(2024, 6))
test_ts  <- window(cost_ts, start = c(2024, 7), end = c(2024, 12))

# Step 2: Fit models
########### Model: ARIMA & ETS ###########
# The Costco stock data shows a clear upward trend over time,
# but but no obvious seasonality in the time series plot from 2020 to 2024. 
# Therefore, a model that captures trend but doesn't 
# rely on seasonality is more appropriate.
#
# ETS (Error, Trend, Seasonality) models use to 
# capture trend and seasonal components, but assume a specific
# error term structure and are often not flexible enough when the data 
# lacks a clear seasonal pattern.
#
# The goal of this step is to fit both models to the training data and predict
# the next six months, and then compare their predictive accuracy.
###########################################

# ARIMA 
arima_model <- auto.arima(train_ts)
arima_forecast <- forecast(arima_model, h = 6)
#ETS 
ets_model <- ets(train_ts)
ets_forecast <- forecast(ets_model, h = 6)

# Step 3: Extract predicted values
arima_pred <- as.numeric(arima_forecast$mean)
ets_pred   <- as.numeric(ets_forecast$mean)
actual     <- as.numeric(test_ts)

# Step 4: Compute error metrics
# ARIMA
arima_rmse <- rmse(actual, arima_pred)
arima_mae  <- mae(actual, arima_pred)
arima_mape <- mape(actual, arima_pred)
# ETS
ets_rmse <- rmse(actual, ets_pred)
ets_mae  <- mae(actual, ets_pred)
ets_mape <- mape(actual, ets_pred)

# Step 5: Combine and display results
############# Comparison: ARIMA vs ETS ########################
# Based on performance metrics (MAPE, RMSE, MAE), ARIMA significantly
# outperforms ETS:
#   - ARIMA MAPE: ~2.91%
#   - ETS   MAPE: ~5.80%
# This indicates that ARIMA provides better predictive accuracy.
#
# Also, ARIMA has lower AIC and BIC values than ETS, indicating
# a better model fit:
#   - ARIMA AIC: 528.19
#   - ETS   AIC: 594.57
#
# Strengths of ARIMA:
#   - Flexible in modeling trend and autocorrelation structures.
#   - Performs better with non-seasonal trending data.
#   - Lower forecast errors (quantitatively proven).
#
# Conclusion: ARIMA is a more appropriate and stronger model choice
# for forecasting Costco's monthly adjusted closing price.
###################################################################

results <- data.frame(
  Model = c("ARIMA", "ETS"),
  RMSE  = c(arima_rmse, ets_rmse),
  MAE   = c(arima_mae, ets_mae),
  MAPE  = c(arima_mape * 100, ets_mape * 100)  # in percentage
)
print(results)

# AIC & BIC comparison
AIC(arima_model) 
BIC(arima_model)  

AIC(ets_model)    
BIC(ets_model)    


# ARIMA model on full historical data
arima_model_default <- auto.arima(cost_ts, stepwise = TRUE, approximation = TRUE)
arima_model_full <- auto.arima(cost_ts)
# Check selected parameters
summary(arima_model_full)
# Forecast next 6 months
arima_forecast_future <- forecast(arima_model_full, h = 6)
# Plot
autoplot(arima_forecast_future) + ggtitle("ARIMA Forecast: Costco 2025")


# Optimize the model(ARIMA)
# Full grid search (slow but more accurate)
arima_model_opt <- auto.arima(
  cost_ts,
  stepwise = FALSE,
  approximation = FALSE,
  trace = TRUE
) 

# Best model: ARIMA(0,1,3)
############# Summary #############
# To find the ARIMA model that best fits the overall data, 
# we use auto.arima()
# ARIMA(0,1,3) with drift has the lowest AIC (590.26),
# which is better than the default model ARIMA(0,1,1) with an AIC (594.71)
###################################
summary(arima_model_opt)

# Compare AIC and BIC
data.frame(
  Model = c("ARIMA_Default", "ARIMA_Optimized"),
  AIC = c(AIC(arima_model_default), AIC(arima_model_opt)),
  BIC = c(BIC(arima_model_default), BIC(arima_model_opt))
) # After optimized it is better


# Visualize the comparison between "actual stock price" and "predicted stock price"
forecast_dates <- seq(as.Date("2024-07-01"), by = "month", length.out = 6)

plot_data <- data.frame(
  Date = forecast_dates,
  Actual = as.numeric(test_ts),
  ARIMA = as.numeric(arima_forecast$mean)
)

library(tidyr)
plot_long <- pivot_longer(plot_data, cols = c("Actual", "ARIMA"),
                          names_to = "Series", values_to = "Value")

ggplot(plot_long, aes(x = Date, y = Value, color = Series)) +
  geom_line(size = 1.1) +
  ggtitle("Costco Stock Price Forecast vs Actual (2024)") +
  ylab("Price (USD)") + xlab("Month") +
  theme_minimal()

###################### Business Implications ###########################################################

# 1. Model Selection & Forecast Accuracy: ARIMA(0,1,3) with drift outperformed ETS and baseline models, Lower AIC (590.26) and BIC (600.65),ㄩSuperior accuracy: RMSE (32.65), MAE (26.60), and MAPE (~5.1%)
#    Conclusion: Best for short-term forecasting due to stability and noise smoothing.
# 2. Trend Insights: Forecasts for July–December 2024 show stable/gradual upward trends (positive drift), Captures short-term volatility but lacks seasonality, indicating prices driven by recent trends.
# 3. Strategic Applications: The ARIMA model’s low MAPE/MAE makes it reliable for investors’ short-term decisions (buy/sell/hold) and for corporate planning, including budgeting, inventory management, pricing adjustments, and aligning financial strategies with forecasted performance.

#########################################################################################################

