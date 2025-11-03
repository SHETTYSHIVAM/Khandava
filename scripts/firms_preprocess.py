from pyproj import datadir, CRS
import os
import geopandas as gpd

# Set PROJ data path
proj_path = r"C:\Users\Shivam\miniconda3\envs\myenv\Library\share\proj"
datadir.set_data_dir(proj_path)
os.environ["PROJ_LIB"] = proj_path
os.environ["PROJ_DATA"] = proj_path

print("Using PROJ data from:", datadir.get_data_dir())
print("CRS check:", CRS.from_epsg(4326))

# Paths
RAW_FIRMS_SHP_PATH = r"../data/raw/DL_FIRE_SV-C2_677758/fire_archive_SV-C2_677758.shp"
OUT_FIRMS_CSV_PATH = r"../data/preprocessed/firms/fires_viirs_2016_2019.csv"

# Load shapefile
fires = gpd.read_file(RAW_FIRMS_SHP_PATH)

print(fires.head())
print(fires.columns)
print(f"Total fire records: {len(fires)}")

# ✅ Convert all column names to lowercase
fires.columns = fires.columns.str.lower()

# Save to CSV
fires.to_csv(OUT_FIRMS_CSV_PATH, index=False)
print(f"Saved preprocessed fires data to {OUT_FIRMS_CSV_PATH}")
