# mdr-tb-burden-resistance-analysis
Hypothesis-driven analysis of global MDR/RR-TB burden, resistance intensity, and control timelines using WHO surveillance data.
# Global Analysis of MDR/RR-TB Burden and Resistance

## Abstract

Multidrug-resistant and rifampicin-resistant tuberculosis (MDR/RR-TB) remains a major obstacle to global tuberculosis control. While extensively drug-resistant tuberculosis (XDR-TB) represents the most severe clinical form, MDR/RR-TB affects a substantially larger population and constitutes the reservoir from which further resistance can emerge.  

In this project, publicly available World Health Organization (WHO) MDR/RR-TB surveillance data were analysed using a hypothesis-driven framework to examine global patterns of drug-resistant TB, resistance intensity, temporal trends, and control timelines. The analysis highlights fundamental differences between high-burden and high-resistance settings and underscores the importance of prioritising MDR/RR-TB control to prevent future escalation of drug resistance.

---

## Data Source

World Health Organization (WHO)  
Global Tuberculosis Programme – MDR/RR-TB burden estimates  

Raw data are publicly available from WHO and are not redistributed in this repository.

---

## Research Questions and Hypotheses

1. Rifampicin resistance is higher among previously treated TB cases than among new TB cases.
2. A small number of countries contribute disproportionately to the global MDR/RR-TB burden.
3. Rifampicin resistance among new TB cases varies across WHO regions.
4. Countries with the highest MDR/RR-TB burden are not necessarily those with the highest resistance intensity.
5. MDR/RR-TB poses a greater immediate public-health challenge than XDR-TB due to its higher prevalence and its role as the reservoir for future resistance.
6. Countries with high resistance intensity require longer timelines to substantially reduce MDR/RR-TB burden compared to high-burden settings.

---

## Methods

- Country-level analysis of WHO MDR/RR-TB surveillance data  
- Data cleaning and manipulation using `dplyr` and `tidyr`  
- Visualisation using `ggplot2`  
- Non-parametric statistical testing (Wilcoxon, Kruskal–Wallis)  
- Trend-based estimation of time required to reduce MDR/RR-TB burden by 50%  
- Construction of a resistance-risk proxy combining absolute MDR/RR-TB burden and rifampicin resistance among new TB cases  

All analyses were conducted in R with a focus on transparency and reproducibility.

---

## Results (Summary)

- Previously treated TB cases consistently showed higher rifampicin resistance than new TB cases.
- Global MDR/RR-TB burden was concentrated in a small number of countries.
- Resistance levels varied substantially across WHO regions.
- Absolute MDR/RR-TB burden and resistance intensity were not strongly correlated.
- The Russian Federation emerged as the setting with the highest combined MDR/RR-TB burden and resistance intensity, indicating a major reservoir for potential XDR-TB emergence.
- India contributed the largest absolute number of MDR/RR-TB cases but exhibited lower resistance intensity among new TB cases.
- Trend-based analysis revealed distinct control dynamics between high-burden and high-resistance settings.

---

## Discussion

This analysis demonstrates that drug-resistant tuberculosis epidemics are shaped by two distinct but interacting forces: disease burden and resistance intensity.  

High-burden countries face a challenge of scale. Even modest resistance proportions can translate into large numbers of MDR/RR-TB cases due to extensive TB transmission. In such settings, the primary challenge is to halt growth and prevent further amplification of resistance.  

High-resistance settings, in contrast, face a challenge of time. Once resistant strains dominate transmission, recovery becomes slower even when absolute case numbers decline. Trend-based estimates suggest that such settings require prolonged, sustained intervention to achieve substantial reductions in MDR/RR-TB burden.  

Importantly, the findings support the conclusion that MDR/RR-TB represents a greater population-level public-health threat than XDR-TB. While XDR-TB is more severe at the individual level, it emerges from the far larger MDR/RR-TB reservoir. Consequently, controlling MDR/RR-TB remains the most effective strategy for preventing future escalation of drug resistance.

---

## Limitations

1. XDR-TB cases were not explicitly reported in the dataset. Risk of XDR emergence was therefore assessed indirectly using a transparent resistance-risk proxy.
2. Analyses were conducted at the country level and do not capture within-country heterogeneity or individual-level risk factors.
3. Estimates of time required to reduce MDR/RR-TB burden are trend-based and should be interpreted as rough planning timeframes rather than predictions.
4. WHO surveillance estimates include uncertainty intervals that were not explicitly modelled in all analyses.

---

## Conclusion

MDR/RR-TB poses a greater immediate public-health challenge than XDR-TB due to its substantially higher prevalence and its role as the evolutionary precursor to further resistance. While high-burden countries face challenges of scale, high-resistance countries face prolonged control timelines. Prioritising MDR/RR-TB control is therefore essential to prevent future escalation to XDR-TB.

---

## Reproducibility

All analyses can be reproduced by running scripts in numerical order from the `scripts/` directory.  
Session details are provided in `session_info.txt`.

---

## Tools

- R  
- tidyverse  
- ggplot2  

---

## Key Takeaway

> Burden determines how large the problem is; resistance intensity determines how long it will last.
