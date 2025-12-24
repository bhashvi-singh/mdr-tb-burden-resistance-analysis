This directory contains all R scripts used for the analysis.
Scripts are numbered to reflect the order in which they should be run.

############################################################
# Global MDR/RR-TB Analysis using WHO Surveillance Data
# Author: Bhashvi Singh
# Description:
# Clean, reproducible analysis resolving all common R errors encountered during exploratory epidemiological analysis.
############################################################


############################
# 0. PACKAGE SETUP
############################

required_packages <- c("readr", "dplyr", "tidyr", "ggplot2")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}


############################
# 1. DATA LOADING & VALIDATION
############################

# Load WHO MDR/RR-TB dataset
tb <- read_csv(file.choose(), show_col_types = FALSE)

# Sanity checks to avoid loading wrong files
if (!"year" %in% colnames(tb)) {
  stop("ERROR: 'year' column not found. Wrong file selected.")
}

if (length(grep("rr", colnames(tb), value = TRUE)) == 0) {
  stop("ERROR: No MDR/RR-TB variables found. Wrong WHO dataset.")
}

# Inspect structure
glimpse(tb)


############################
# 2. BASIC CLEANING
############################

latest_year <- max(tb$year, na.rm = TRUE)

tb_latest <- tb %>%
  filter(year == latest_year)


############################
# 3. HYPOTHESIS 1
# RR-TB is higher in previously treated cases
############################

tb_h1 <- tb_latest %>%
  select(country, e_rr_pct_new, e_rr_pct_ret) %>%
  filter(!is.na(e_rr_pct_new), !is.na(e_rr_pct_ret))

tb_h1_long <- tb_h1 %>%
  pivot_longer(
    cols = c(e_rr_pct_new, e_rr_pct_ret),
    names_to = "case_type",
    values_to = "rr_percent"
  ) %>%
  mutate(
    case_type = recode(
      case_type,
      e_rr_pct_new = "New TB cases",
      e_rr_pct_ret = "Previously treated TB cases"
    )
  )

ggplot(tb_h1_long, aes(x = case_type, y = rr_percent)) +
  geom_boxplot(fill = "grey85") +
  theme_minimal() +
  labs(
    title = paste("Rifampicin-Resistant TB by Treatment History (", latest_year, ")", sep = ""),
    x = "",
    y = "Rifampicin resistance (%)"
  )

wilcox.test(tb_h1$e_rr_pct_ret, tb_h1$e_rr_pct_new, paired = TRUE)


############################
# 4. HYPOTHESIS 2
# Countries with highest RR-TB among new cases
############################

top_rr <- tb_latest %>%
  select(country, e_rr_pct_new) %>%
  filter(!is.na(e_rr_pct_new)) %>%
  arrange(desc(e_rr_pct_new)) %>%
  slice(1:15)

ggplot(top_rr,
       aes(x = reorder(country, e_rr_pct_new),
           y = e_rr_pct_new)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = paste("RR-TB among New Cases (", latest_year, ")", sep = ""),
    x = "Country",
    y = "RR-TB (%)"
  )

ggsave("figures/rr_tb_new_cases_top15.png", width = 7, height = 5)


############################
# 5. HYPOTHESIS 3
# MDR/RR-TB burden vs resistance intensity (XDR risk proxy)
############################

tb_risk <- tb_latest %>%
  filter(!is.na(e_inc_rr_num), !is.na(e_rr_pct_new)) %>%
  mutate(xdr_risk_proxy = e_inc_rr_num * e_rr_pct_new) %>%
  arrange(desc(xdr_risk_proxy))

head(tb_risk %>%
       select(country, e_inc_rr_num, e_rr_pct_new, xdr_risk_proxy), 10)


############################
# 6. COUNTRY-SPECIFIC TREND (Top risk country)
############################

top_country <- tb_risk %>% slice(1)
country_name <- top_country$country

tb_country <- tb %>%
  filter(country == country_name,
         !is.na(e_rr_pct_new)) %>%
  arrange(year)

ggplot(tb_country, aes(x = year, y = e_rr_pct_new)) +
  geom_line(color = "firebrick", linewidth = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    title = paste("MDR/RR-TB Trend in", country_name),
    x = "Year",
    y = "RR-TB among new cases (%)"
  )


############################
# 7. HYPOTHESIS 4
# ≤ 5% yearly increase in highest-burden country
############################

top_burden_country <- tb_latest %>%
  filter(!is.na(e_inc_rr_num)) %>%
  arrange(desc(e_inc_rr_num)) %>%
  slice(1) %>%
  pull(country)

tb_burden_country <- tb %>%
  filter(country == top_burden_country,
         !is.na(e_rr_pct_new)) %>%
  arrange(year) %>%
  mutate(yearly_change = e_rr_pct_new - lag(e_rr_pct_new))

latest_change <- tb_burden_country %>%
  filter(year == latest_year) %>%
  pull(yearly_change)

hypothesis_result <- if (!is.na(latest_change) && latest_change <= 5) {
  "Hypothesis supported: increase ≤ 5 percentage points."
} else {
  "Hypothesis not supported: increase > 5 percentage points."
}

hypothesis_result


############################
# 8. HYPOTHESIS 5
# Time to control MDR/RR-TB (Burden vs Resistance)
############################

countries_focus <- c("India", "Russian Federation")

tb_focus <- tb %>%
  filter(country %in% countries_focus,
         !is.na(e_inc_rr_num)) %>%
  arrange(country, year)

tb_recent <- tb_focus %>%
  filter(year >= latest_year - 9)

tb_trends <- tb_recent %>%
  group_by(country) %>%
  summarise(
    start_year = min(year),
    end_year = max(year),
    start_burden = first(e_inc_rr_num),
    end_burden = last(e_inc_rr_num),
    years_observed = end_year - start_year,
    annual_change = (end_burden - start_burden) / years_observed
  )

tb_projection <- tb_trends %>%
  mutate(
    target_burden = start_burden * 0.5,
    years_to_halve = case_when(
      annual_change < 0 ~ (target_burden - start_burden) / annual_change,
      TRUE ~ NA_real_
    )
  )

tb_projection

ggplot(tb_recent,
       aes(x = year, y = e_inc_rr_num, color = country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    title = "MDR/RR-TB Burden Trends: High Burden vs High Resistance",
    x = "Year",
    y = "Estimated MDR/RR-TB cases"
  )

ggsave("figures/mdr_time_to_control_projection.png", width = 7, height = 5)
