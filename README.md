# ☀️ Solar Irradiance Forecasting using LSTM (IEEE TENSYMP 2022)

This repository contains the implementation of solar irradiance forecasting using LSTM neural networks, as described in the paper "Solar Irradiance Forecasting using Recurrent Neural Networks."

# Solar Irradiance Forecasting Project

This repository implements solar irradiance forecasting using LSTM neural networks, as described in the paper "Solar Irradiance Forecasting using Recurrent Neural Networks" ([read the full report](Solar_Irradiance_forecasting_using_Recurrent_Neural_Networks.pdf)).

---

## Process Flowchart

The following flowchart outlines the process of data normalization, LSTM modeling, and forecasting using irradiance, temperature, and time as inputs:

```mermaid
graph TD
    A[Start] --> B[Collect Data: Irradiance, Temperature, Time (5568 samples, 15-min intervals)]
    B --> C[Data Preprocessing]
    C --> C1[Moving Average Filter (Window = 10)]
    C1 --> C2[Convert Time to Real Number (HH + MM/60)]
    C --> D[Data Normalization]
    D --> D1[Min-Max Normalization (Irradiance)]
    D1 --> D2[Min-Max Normalization (Temperature)]
    D --> E[Feature Engineering]
    E --> E1[Create Sequences (Lag 1 time step)]
    E --> F[LSTM Model Design]
    F --> F1[Standalone LSTM: Temp(t-1), Time -> Temp(t)]
    F1 --> F2[Dual-Input LSTM: Irr(t-1), Temp(t), Time -> Irr(t)]
    F --> G[Model Training]
    G --> G1[Train LSTMs (90 Units, 0.01 LR, 200 Epochs)]
    G1 --> G2[Split Data: 80% Train, 10% Val, 10% Test]
    G --> H[Evaluate: RMSE, MAE, MAPE]
    H --> I[Predict Irradiance at t]
    I --> J[Denormalize Predictions (Reverse Min-Max)]
    J --> K[Output Results (Save/Visualize)]
    K --> L[End]
```

---

## 🧠 Project Overview

This repository contains the complete implementation of a **solar irradiance forecasting system** using **Long Short-Term Memory (LSTM)** neural networks in MATLAB.

We compare multiple input configurations — including **irradiance, temperature, and time of day** — to understand their contribution to prediction accuracy. Additionally, we propose an **ensemble model** where a separate LSTM first predicts temperature, which is then fed into a second LSTM that forecasts irradiance in a feedback loop.

📌 **Published at:**  
IEEE Region 10 Symposium (TENSYMP 2022), *IIT Bombay*  
🔗 [IEEE Xplore Link](https://ieeexplore.ieee.org/document/9864498)

---

## 📚 Abstract

The performance of LSTM models for time-series prediction of solar irradiance is heavily dependent on the input feature space. This project explores:
- One-step and multi-step prediction of **Direct Normal Irradiance (DNI)**
- **Feature engineering** using temperature and time
- An ensemble approach that first forecasts **temperature**, then uses it for **irradiance prediction**

Our experiments demonstrate that **expanded feature inputs improve LSTM learning** and reduce RMSE.

---

## 🔬 Methodology

### 📈 Dataset
- Format: Excel (`MonthData_2.xlsx`)
- Columns:
  - `Date`
  - `Time` (converted to decimal hour)
  - `Temperature (°C)`
  - `Irradiance (W/m²)`

### 🛠 Tools Used
- **MATLAB R2021a+**
- Deep Learning Toolbox
- Signal Processing Toolbox (optional)
- GPU-accelerated training

---

## 🗂️ Project Structure

```bash
solar-irradiance-lstm/
├── data/
│   └── MonthData_2.xlsx                  # Input data
├── src/
│   ├── datacreate.m                      # Baseline LSTM using only irradiance
│   ├── irrtemp.m                         # Uses irradiance + temperature
│   ├── irrandtemp.m                      # Uses irradiance + time
│   ├── irrtempnum.m                      # Full ensemble model (irradiance + temp + time)
│   ├── Tempforecast.m                    # Predict temperature
│   ├── Tempandtime.m                     # Temperature + time
├── report/
│   └── IEEE_IIT_Bombay_Symposium.pdf    # Published paper
├── images/
│   └── solar_forecast_architecture.png  # Flowchart (to be added)
├── README.md
├── README_MATLAB.txt
└── .gitignore
```

---

## 📊 Results

- ✔ Best RMSE achieved using **irradiance + time + temperature**
- ✔ Ensemble model shows **robust multi-step prediction**
- ✔ LSTM performs better with **feature expansion**

Sample plots and forecast visualizations are available in `/images`.

---

## 🚀 How to Run

1. Open MATLAB
2. Open any `.m` file in `/src`
   - e.g., `irrtempnum.m` for the ensemble model
3. Update dataset path if needed in the script
4. Run and observe:
   - Forecast vs ground truth plots
   - RMSE plots
   - Trained model performance

**Note:** LSTM training requires a recent version of MATLAB with GPU support enabled for best speed.

---

## 📦 Dependencies

- MATLAB (R2021a+)
- Deep Learning Toolbox
- Excel read/write support
- Optional: GPU support (for faster training)

---

## 📚 Citation

If you use this work in your research, please cite:

```bibtex
@inproceedings{shekar2022irradiance,
  title={Solar irradiance forecasting using feature-enhanced recurrent neural networks},
  author={Shekar, Dhanush D and others},
  booktitle={2022 IEEE Region 10 Symposium (TENSYMP)},
  year={2022},
  organization={IEEE}
}
```

---

## 👥 Contributors

- **Dhanush D. Shekar** – Ensemble modeling, codebase design, experimentation  

---

## 🙏 Acknowledgements

- Supported by NITK Surathkal  
- Presented at IEEE TENSYMP 2022  
- Data inspired by real-world solar irradiance and meteorological datasets

---

## 📝 License

This project is open-sourced under the [MIT License](LICENSE).
