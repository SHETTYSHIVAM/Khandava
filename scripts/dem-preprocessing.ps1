# ==========================================================
# DEM Processing Workflow: Reproject → Slope → Aspect → Reproject Back
# Author: Shivam Shetty
# Description: Converts DEM to UTM, computes slope and aspect,
#              then reprojects them back to WGS84.
# ==========================================================

$ErrorActionPreference = "Stop"

# ==== Paths Relative to Script ====
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RAW_DATA_ROOT = Join-Path $ScriptDir "..\data\raw\P5_PAN_CD_N30_000_E078_000_30m"
$OUT_DATA_ROOT = Join-Path $ScriptDir "..\data\preprocessed\DEM"

# Create output directory if missing
if (!(Test-Path $OUT_DATA_ROOT)) {
    New-Item -ItemType Directory -Force -Path $OUT_DATA_ROOT | Out-Null
}

# ==== Input DEM ====
$INPUT_DEM = Join-Path $RAW_DATA_ROOT "P5_PAN_CD_N30_000_E078_000_DEM_30m.tif"

if (!(Test-Path $INPUT_DEM)) {
    Write-Host "❌ Input DEM not found: $INPUT_DEM"
    exit 1
}

# ==== Output Filenames ====
$DEM_UTM = Join-Path $OUT_DATA_ROOT "dem_utm.tif"
$SLOPE_UTM = Join-Path $OUT_DATA_ROOT "slope_utm.tif"
$ASPECT_UTM = Join-Path $OUT_DATA_ROOT "aspect_utm.tif"
$SLOPE_WGS84 = Join-Path $OUT_DATA_ROOT "slope_wgs84.tif"
$ASPECT_WGS84 = Join-Path $OUT_DATA_ROOT "aspect_wgs84.tif"

# ==== Target Coordinate Systems ====
$UTM_CRS = "EPSG:32644"   # UTM Zone 44N (WGS84)
$WGS84_CRS = "EPSG:4326"  # Geographic Lat/Lon (WGS84)

# ==== Logging Function ====
function Log-Step {
    param([string]$message)
    Write-Host ""
    Write-Host "------------------------------------------"
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $message"
    Write-Host "------------------------------------------"
}

# ==== GDAL Execution Helper ====
function Run-GDAL {
    param(
        [string]$cmd
    )

    # $args is PowerShell's automatic variable for all unspecified arguments
    Write-Host "Running: $cmd $($args -join ' ')"

    $process = Start-Process -FilePath $cmd -ArgumentList $args `
                -NoNewWindow -Wait -PassThru `
                -RedirectStandardOutput (Join-Path $OUT_DATA_ROOT "gdal_output.log") `
                -RedirectStandardError (Join-Path $OUT_DATA_ROOT "gdal_error.log")

    if ($process.ExitCode -ne 0) {
        Write-Host "❌ Command failed: $cmd $($args -join ' ')"
        Write-Host "Check logs: $(Join-Path $OUT_DATA_ROOT "gdal_error.log")"
        exit $process.ExitCode
    }
}

# ==== Pipeline ====
Log-Step "Step 1: Reprojecting DEM to UTM ($UTM_CRS)"
Run-GDAL "gdalwarp" "-t_srs" $UTM_CRS "-overwrite" $INPUT_DEM $DEM_UTM

Log-Step "Step 2: Computing Slope (degrees)"
Run-GDAL "gdaldem" "slope" $DEM_UTM $SLOPE_UTM "-compute_edges"

Log-Step "Step 3: Computing Aspect (degrees)"
Run-GDAL "gdaldem" "aspect" $DEM_UTM $ASPECT_UTM "-compute_edges"

Log-Step "Step 4: Reprojecting Slope to WGS84 ($WGS84_CRS)"
Run-GDAL "gdalwarp" "-t_srs" $WGS84_CRS "-overwrite" $SLOPE_UTM $SLOPE_WGS84

Log-Step "Step 5: Reprojecting Aspect to WGS84 ($WGS84_CRS)"
Run-GDAL "gdalwarp" "-t_srs" $WGS84_CRS "-overwrite" $ASPECT_UTM $ASPECT_WGS84

Log-Step "✅ All processing steps completed successfully!"
Write-Host "Output files generated:"
Write-Host " - $DEM_UTM"
Write-Host " - $SLOPE_UTM"
Write-Host " - $ASPECT_UTM"
Write-Host " - $SLOPE_WGS84"
Write-Host " - $ASPECT_WGS84"
Write-Host "Logs saved at $(Join-Path $OUT_DATA_ROOT 'gdal_output.log') and $(Join-Path $OUT_DATA_ROOT 'gdal_error.log')"