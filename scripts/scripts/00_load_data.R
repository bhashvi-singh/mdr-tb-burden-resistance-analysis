############################################################
# 00_load_data.R
# Safe data loading for WHO MDR/RR-TB analysis
############################################################

library(readr)

load_tb_data <- function() {

  message("Please select the WHO MDR/RR-TB CSV file")

  tb <- read_csv(file.choose(), show_col_types = FALSE)

  # Basic validation
  required_cols <- c("country", "year", "e_rr_pct_new", "e_inc_rr_num")

  missing <- setdiff(required_cols, colnames(tb))

  if (length(missing) > 0) {
    stop(
      "The selected file does not appear to be the WHO MDR/RR-TB dataset.\n",
      "Missing columns: ", paste(missing, collapse = ", ")
    )
  }

  message("✔ WHO MDR/RR-TB dataset loaded successfully")

  return(tb)
}
