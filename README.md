# Forest Fire Prediction

## Overview

This project focuses on predicting forest fire occurrences in **Uttarakhand, India**, by integrating **meteorological**, **terrain**, and **land-use** datasets with machine learning algorithms such as **Random Forest** and **XGBoost**.

**Note:**
The directories `data/raw/` and `data/processed/` are ignored by Git to prevent the inclusion of large and sensitive datasets.

---

## Datasets Used

The following datasets were utilized to train and validate the prediction models:

1. **ERA5 Reanalysis Data** – Provided by the *European Centre for Medium-Range Weather Forecasts (ECMWF)*.
   *Citation:*
   [1] H. Hersbach *et al.*, “The ERA5 Global Reanalysis,” *Quarterly Journal of the Royal Meteorological Society*, vol. 146, no. 730, pp. 1999–2049, 2020. [Online]. Available: [https://doi.org/10.1002/qj.3803](https://doi.org/10.1002/qj.3803)

2. **FIRMS (Fire Information for Resource Management System)** – Active fire data from the *NASA Earth Observing System Data and Information System (EOSDIS)*.
   *Citation:*
   [2] NASA FIRMS, “Fire Information for Resource Management System,” NASA EOSDIS, 2023. [Online]. Available: [https://firms.modaps.eosdis.nasa.gov/](https://firms.modaps.eosdis.nasa.gov/)

3. **Land Use Land Cover (LULC) Data** – Obtained from *Bhuvan*, the Indian geo-platform developed by *ISRO’s National Remote Sensing Centre (NRSC)*.
   *Citation:*
   [3] NRSC–ISRO, “Bhuvan: Indian Geo-Platform,” National Remote Sensing Centre, Hyderabad, India. [Online]. Available: [https://bhuvan.nrsc.gov.in/](https://bhuvan.nrsc.gov.in/)

4. **Digital Elevation Model (DEM) Data** – Acquired from *Bhoonidhi*, the data dissemination portal of the *Indian Space Research Organisation (ISRO)*.
   *Citation:*
   [4] ISRO, “Bhoonidhi: Earth Observation Data Hub,” Indian Space Research Organisation. [Online]. Available: [https://bhoonidhi.nrsc.gov.in/](https://bhoonidhi.nrsc.gov.in/)

---

## Study Area

The study area covers the Uttarakhand region of India, bounded by the coordinates:

* **Longitude**: 77.5°E – 81.2°E

* **Latitude**: 28.8°N – 31.3°N

## Methodology

1. **Data Preprocessing:**

   * Extracted relevant meteorological and topographic variables.
   * Aligned datasets to a uniform spatial grid.
   * Performed normalization and missing value imputation.

2. **Feature Engineering:**

   * Derived indices such as temperature anomaly, relative humidity, slope, and vegetation cover.
   * Mapped fire events with environmental variables to create labeled datasets.

3. **Modeling and Evaluation:**

   * Implemented Random Forest and XGBoost classifiers.
   * Evaluated models using metrics like Precision, Recall, and F1-score.
   * Produced probability-based fire risk maps.

---

## Future Work

* Incorporation of **deep learning architectures** such as CNNs and LSTMs for spatio-temporal prediction.
* Simulation of **fire spread** based on weather and terrain dynamics.

---