# Data Description

This project uses publicly available country-level tuberculosis surveillance data
from the World Health Organization (WHO).

## Data source

World Health Organization (WHO)  
Global Tuberculosis Programme

Dataset used:
- MDR/RR-TB burden estimates (country-level, multi-year)

The dataset includes variables describing:
- Rifampicin resistance among new TB cases
- Rifampicin resistance among previously treated TB cases
- Estimated incidence of MDR/RR-TB
- WHO region and country identifiers
- Year of observation

## Accessing the data

The raw data are publicly available from the WHO website and are not redistributed
in this repository.

To reproduce the analysis:
1. Download the WHO MDR/RR-TB burden estimates dataset (CSV format)
2. Place the file anywhere on your local machine
3. When running the analysis scripts, you will be prompted to select the file
   using `file.choose()`

## Notes

- No data cleaning or modification was performed outside R
- All filtering, transformation, and analysis steps are fully documented
  in the `scripts/` directory
