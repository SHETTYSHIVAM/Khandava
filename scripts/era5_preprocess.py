import numpy as np
import xarray as xr
import os
import pandas as pd


ERA_DS_RAW_PATH = "../data/raw/era5-datasets"
ERA_DS_OUTPUT_PATH = "../data/preprocessed/era5-datasets"


def read_era_raw_file(path, year):
    return xr.open_dataset(os.path.join(ERA_DS_RAW_PATH, f"{year}/data_stream-oper_stepType-instant.nc"))


def kelvin_to_celsius(kelvin):
    return kelvin - 273.15


def wind_speed_uv(ds):
    return np.sqrt(ds['u10'] ** 2 + ds['v10'] ** 2)


def saturation_vapor_pressure(t):
    return 6.112 * np.exp((17.67 * t) / (t + 243.5))


def actual_vapor_pressure(td):
    return 6.112 * np.exp((17.67 * td) / (td + 243.5))


def relative_humidity(temp, dew_temp):
    return (actual_vapor_pressure(dew_temp) / saturation_vapor_pressure(temp)) * 100


def vapor_pressure_deficit(temp, dew_temp):
    return saturation_vapor_pressure(temp) - actual_vapor_pressure(dew_temp)


def preprocess_era5(year):
    ds = read_era_raw_file(ERA_DS_RAW_PATH, year)

    ds["t2m"] = kelvin_to_celsius(ds["t2m"])
    ds["d2m"] = kelvin_to_celsius(ds["d2m"])

    ds["wind_speed"] = wind_speed_uv(ds)

    ds["rh"] = relative_humidity(ds["t2m"], ds["d2m"])

    ds["vpd"] = vapor_pressure_deficit(ds["t2m"], ds["d2m"])

    final_vars = [
        "u10", "v10",
        "d2m", "t2m",
        "lai_hv", "lai_lv",
        "wind_speed", "rh", "vpd"
    ]
    ds_final = ds[final_vars]

    os.makedirs(os.path.join(ERA_DS_OUTPUT_PATH, str(year)), exist_ok=True)
    out_path = os.path.join(ERA_DS_OUTPUT_PATH, str(year), "era5_processed.nc")

    ds_final.to_netcdf(out_path)

    return ds_final

def create_merged_dataset():
    years = [2016, 2017, 2018]
    all_dfs = []

    for year in years:
        ds = preprocess_era5(year)
        df = ds.to_dataframe().reset_index()
        df["year"] = year
        all_dfs.append(df)

    merged_df = pd.concat(all_dfs, axis=0)

    os.makedirs(ERA_DS_OUTPUT_PATH, exist_ok=True)

    out_path = os.path.join(ERA_DS_OUTPUT_PATH, "era5_merged.csv")
    merged_df.to_csv(out_path, index=False)

    print(f"Merged dataset saved to: {out_path}")


if __name__ == "__main__":
    create_merged_dataset()


