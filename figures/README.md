############################################################
# TB MDR/RR-TB FIGURE GENERATION SCRIPT
# Figures saved to existing "figures/" directory
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
# 1. LOAD DATA
############################

# Choose WHO MDR/RR-TB CSV file when prompted
tb <- read_csv(file.choose(), show_col_types = FALSE)

# Safety checks
if (!"year" %in% colnames(tb)) {
  stop("ERROR: Wrong file selected (no 'year' column).")
}

if (!"e_inc_rr_num" %in% colnames(tb)) {
  stop("ERROR: MDR/RR-TB burden column not found.")
}

############################
# 2. PREPARE DATA
############################

latest_year <- max(tb$year, na.rm = TRUE)

tb_latest <- tb %>%
  filter(year == latest_year)

############################
# FIGURE 1
# RR-TB by treatment history
############################

tb_h1 <- tb_latest %>%
  select(country, e_rr_pct_new, e_rr_pct_ret) %>%
  filter(!is.na(e_rr_pct_new), !is.na(e_rr_pct_ret)) %>%
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

p1 <- ggplot(tb_h1, aes(x = case_type, y = rr_percent)) +
  geom_boxplot(fill = "grey80") +
  theme_minimal(base_size = 12) +
  labs(
    title = paste("Rifampicin Resistance by Treatment History (", latest_year, ")", sep = ""),
    x = "",
    y = "Rifampicin resistance (%)"
  )

ggsave("figures/fig1_rr_tb_treatment_history.png",
       p1, width = 6, height = 5)
     <img width="1074" height="888" alt="Figure 1 TB analysis" src="https://github.com/user-attachments/assets/f0633416-5803-4a4a-ad84-202c708a9533" />


############################
# FIGURE 2
# Top 15 countries by RR-TB among new cases
############################

top_rr <- tb_latest %>%
  select(country, e_rr_pct_new) %>%
  filter(!is.na(e_rr_pct_new)) %>%
  arrange(desc(e_rr_pct_new)) %>%
  slice(1:15)

p2 <- ggplot(top_rr,
             aes(x = reorder(country, e_rr_pct_new),
                 y = e_rr_pct_new)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  theme_minimal(base_size = 12) +
  labs(
    title = paste("Top 15 Countries by RR-TB among New TB Cases (", latest_year, ")", sep = ""),
    x = "Country",
    y = "RR-TB (%)"
  )

ggsave("figures/fig2_top15_rr_tb_new_cases.png",
       p2, width = 7, height = 5)
<img width="1074" height="888" alt="Figure 2 TB analysis" src="https://github.com/user-attachments/assets/1679e7d0-6227-4527-ae76-fffdb358f2f1" />


############################
# FIGURE 3
# Burden vs resistance intensity
############################

tb_burden_res <- tb_latest %>%
  filter(!is.na(e_inc_rr_num), !is.na(e_rr_pct_new))

p3 <- ggplot(tb_burden_res,
             aes(x = e_inc_rr_num, y = e_rr_pct_new)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  scale_x_log10() +
  theme_minimal(base_size = 12) +
  labs(
    title = "MDR/RR-TB Burden vs Resistance Intensity",
    x = "Estimated MDR/RR-TB cases (log scale)",
    y = "RR-TB among new cases (%)"
  )

ggsave("figures/fig3_burden_vs_resistance.png",
       p3, width = 7, height = 5)
 <img width="1074" height="888" alt="Figure 3 TB analysis" src="https://github.com/user-attachments/assets/fd62987d-544d-4033-8dfe-d99d549d039e" />


############################
# FIGURE 4
# MDR/RR-TB trend in the highest-risk country
############################

tb_risk <- tb_latest %>%
  filter(!is.na(e_inc_rr_num), !is.na(e_rr_pct_new)) %>%
  mutate(xdr_risk_proxy = e_inc_rr_num * e_rr_pct_new) %>%
  arrange(desc(xdr_risk_proxy))

top_country <- tb_risk %>%
  slice(1) %>%
  pull(country)

tb_country <- tb %>%
  filter(country == top_country,
         !is.na(e_rr_pct_new)) %>%
  arrange(year)

p4 <- ggplot(tb_country,
             aes(x = year, y = e_rr_pct_new)) +
  geom_line(color = "firebrick", linewidth = 1) +
  geom_point(size = 2) +
  theme_minimal(base_size = 12) +
  labs(
    title = paste("MDR/RR-TB Trend in", top_country),
    x = "Year",
    y = "RR-TB among new cases (%)"
  )

ggsave("figures/fig4_rr_tb_trend_top_risk_country.png",
       p4, width = 7, height = 5)
     <img width="1074" height="888" alt="Figure 4 TB analysis" src="https://github.com/user-attachments/assets/c5fc3ed7-4ab3-410f-af05-6ac9b9defa26" />



# High-burden vs high-resistance comparison

countries_focus <- c("India", "Russian Federation")

tb_focus <- tb %>%
  filter(country %in% countries_focus, !is.na(e_inc_rr_num)) %>%
  arrange(country, year)

ggplot(tb_focus,
       aes(x = year, y = e_inc_rr_num, color = country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  theme_minimal(base_size = 12) +
  labs(
    title = "MDR/RR-TB Burden Trends: High Burden vs High Resistance",
    x = "Year",
    y = "Estimated MDR/RR-TB cases",
    color = "Country"
  )
<img width="1074" height="888" alt="High burden and high resistance" src="https://github.com/user-attachments/assets/8fad9b3c-3c42-4869-a156-0167a542765f" />
