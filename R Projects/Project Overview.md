# Title: Water Quality Assessment
[Link to Water Quality Assessment Report](http://rpubs.com/Anoop-S-Hari/1120063)
The dataset for this analysis was downloaded from the Kaggle website, it contained a single file named ‘water_potability.csv’. 

Goal: Assess and evaluate the quality of water bodies using various water quality metrics and determine their compliance with international standards and guidelines for potability.

About Dataset:

📚 Context

Access to safe drinking-water is essential to health, a basic human right and a component of effective policy for health protection. This is important as a health and development issue at a national, regional and local level. In some regions, it has been shown that investments in water supply and sanitation can yield a net economic benefit, since the reductions in adverse health effects and health care costs outweigh the costs of undertaking the interventions.

📝 Content

The water_potability.csv file contains water quality metrics for 3276 different water bodies.

1.	pH value:
PH is an important parameter in evaluating the acid–base balance of water. It is also the indicator of acidic or alkaline condition of water status. WHO has recommended maximum permissible limit of pH from 6.5 to 8.5. The current investigation ranges were 6.52–6.83 which are in the range of WHO standards.

2.	Hardness:
Hardness is mainly caused by calcium and magnesium salts. These salts are dissolved from geologic deposits through which water travels. The length of time water is in contact with hardness producing material helps determine how much hardness there is in raw water. Hardness was originally defined as the capacity of water to precipitate soap caused by Calcium and Magnesium.

3.	Solids (Total dissolved solids - TDS):
Water has the ability to dissolve a wide range of inorganic and some organic minerals or salts such as potassium, calcium, sodium, bicarbonates, chlorides, magnesium, sulfates etc. These minerals produced un-wanted taste and diluted color in appearance of water. This is the important parameter for the use of water. The water with high TDS value indicates that water is highly mineralized. Desirable limit for TDS is 500 mg/l and maximum limit is 1000 mg/l which prescribed for drinking purpose.

4.	Chloramines:
Chlorine and chloramine are the major disinfectants used in public water systems. Chloramines are most commonly formed when ammonia is added to chlorine to treat drinking water. Chlorine levels up to 4 milligrams per liter (mg/L or 4 parts per million (ppm)) are considered safe in drinking water.

5.	Sulfate:
Sulfates are naturally occurring substances that are found in minerals, soil, and rocks. They are present in ambient air, groundwater, plants, and food. The principal commercial use of sulfate is in the chemical industry. Sulfate concentration in seawater is about 2,700 milligrams per liter (mg/L). It ranges from 3 to 30 mg/L in most freshwater supplies, although much higher concentrations (1000 mg/L) are found in some geographic locations.

6.	Conductivity:
Pure water is not a good conductor of electric current rather a good insulator. Increase in ions concentration enhances the electrical conductivity of water. Generally, the amount of dissolved solids in water determines the electrical conductivity. Electrical conductivity (EC) actually measures the ionic process of a solution that enables it to transmit current. According to WHO standards, EC value should not exceed 400 μS/cm.

7.	Organic_carbon:
Total Organic Carbon (TOC) in source waters comes from decaying natural organic matter (NOM) as well as synthetic sources. TOC is a measure of the total amount of carbon in organic compounds in pure water. According to US EPA < 2 mg/L as TOC in treated / drinking water, and < 4 mg/Lit in source water which is use for treatment.

8.	Trihalomethanes:
THMs are chemicals which may be found in water treated with chlorine. The concentration of THMs in drinking water varies according to the level of organic material in the water, the amount of chlorine required to treat the water, and the temperature of the water that is being treated. THM levels up to 80 ppm is considered safe in drinking water.

9.	Turbidity:
The turbidity of water depends on the quantity of solid matter present in the suspended state. It is a measure of light emitting properties of water and the test is used to indicate the quality of waste discharge with respect to colloidal matter. The mean turbidity value obtained for Wondo Genet Campus (0.98 NTU) is lower than the WHO recommended value of 5.00 NTU.

10.	Potability:
Indicates if water is safe for human consumption where 1 means Potable and 0 means Not potable.


Steps Done:

1.	Package Installation and Loading:
Installed and loaded necessary R packages: tidyverse, dplyr, readr, tidyr for data manipulation and    visualization.
2.	Data Import and Exploration:
Imported the dataset 'water_potability.csv' using read.csv and then checked its structure using str() and summary statistics using summary().
3.	Handling Missing Values:
Identified missing values using colSums(is.na()) and imputed the missing values in columns 'ph', 'Sulfate', and 'Trihalomethanes' with mean values using mean() and ifelse() statements.
4.	Data Transformation:
Transformed the 'Potability' column from 0/1 to categorical 'Potable'/'Not Potable' using mutate() and ifelse().
5.	Data Summary and Visualization:

	Calculated and visualized the percentage of potable and non-potable water using group_by(), summarise(), and ggplot() for creating bar plots.
	Analyzed and visualized the pH scale distribution within and outside limits using mutate(), group_by(), and ggplot() for a bar plot.

6.	Calculations and Summary Statistics:
Calculated the mean pH value across all water bodies using mean() function.
Created boxplots to compare the distribution of hardness among potable and non-potable water using ggplot().
7.	Statistical Tests:

	Performed statistical tests such as t-tests (t.test()) to compare mean values of Chloramine levels and Conductivity between potable and non-potable water.
	Conducted correlation analysis (cor()) between Chloramines and Sulfate, and between Hardness and Sulfate.

8.	Further Data Exploration:
Explored relationships between variables by creating scatterplots (ggplot()) to visualize Chloramines vs. Sulfate, and Hardness vs. Sulfate for potable and non-potable water bodies separately.
9.	Variance Calculation:
Computed variances using var() to identify the variable with the highest variance among all features.
10.	Specific Queries:
Answered specific questions regarding the data, such as the percentage of water bodies with pH < 7, water bodies exceeding sulfate limits, etc., by filtering and performing calculations.

Each step involved data manipulation, visualization, statistical analysis, and deriving insights to explore relationships and characteristics within the dataset 'water_potability.csv'.


