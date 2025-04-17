
# 📈 Forecasting Costco Stock Prices Using Time Series Models

A time series forecasting project focused on predicting the adjusted closing stock price of **Costco (COST)** using historical data from **January 2020 to December 2024**. This analysis compares the performance of **ARIMA** and **ETS** models and highlights the best approach for short-term stock price prediction.

## 👥 Team Members
- Yu-Lin SHAO – ETU20240200  
- Yi-Hsin TUNG – ETU20240215  
- Chiao-Jung TING – ETU20240499  
- Marcelo MARTINEZ JEZZINI – ETU20240477  
- Abhishek CHAUDHARY – ETU20232254  

---

## 🎯 Project Objectives
- **Forecast** future Costco stock prices using ARIMA and ETS models.
- **Evaluate** model performance using RMSE, MAE, MAPE, AIC, and BIC.
- **Visualize** forecasts versus actual stock prices.
- **Provide insights** for investment and strategic business decisions.

---

## 📊 Dataset
- **Source**: Yahoo Finance  
- **Content**: Monthly adjusted closing prices  
- **Period**: January 2020 – December 2024

---

## 🧪 Methodology

### 🔧 Data Preprocessing
- Retrieved data using `quantmod::getSymbols()`
- Converted to time series format (`ts`)
- Handled missing values and outliers (interpolation + `tsoutliers`)

### 🔍 Model Training & Testing
- Training Set: Jan 2020 – Jun 2024  
- Testing Set: Jul 2024 – Dec 2024  
- Compared:
  - ARIMA (auto-selected and optimized)
  - ETS (Exponential Smoothing)

### 📐 Evaluation Metrics
| Model | RMSE  | MAE   | MAPE (%) |
|-------|-------|-------|-----------|
| ARIMA | 32.65 | 26.60 | **~2.91** |
| ETS   | 57.41 | 47.35 | ~5.80     |

- ARIMA showed **superior predictive accuracy** and better model fit (lower AIC/BIC).

---

## 📈 Forecast Results

ARIMA(0,1,3) with drift was identified as the **best model**, showing a steady upward trend in forecasts from July to December 2024. Visualization includes:

- Historical vs Forecasted Prices  
- Forecast Error Analysis  

<p align="center">
  <img src="your_image_here.png" alt="Forecast Plot Example">
</p>

---

## 🧠 Business Implications
- **Short-term Investment Decisions**: High accuracy makes the model suitable for buy/sell/hold strategies.
- **Corporate Strategy**: Reliable for planning budgeting, inventory, and pricing aligned with forecasted performance.
- **Market Trend Insight**: Trend-driven without seasonality—ideal for near-term financial planning.

---

## 🛠️ Technologies Used
- `R` (RStudio)
- `quantmod`, `forecast`, `ggplot2`, `Metrics`, `dplyr`, `tidyr`

---

## 📁 File Overview
- `Costco.R`: Main script containing the entire analysis pipeline.
- `forecast_plot.png`: Output chart comparing actual vs predicted stock prices (optional).

---

## 📬 Contact
Feel free to reach out for questions or collaboration opportunities!
