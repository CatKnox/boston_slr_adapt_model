[![DOI](https://zenodo.org/badge/983206603.svg)](https://doi.org/10.5281/zenodo.15546584)

# Authors
The model and coding files uploaded to this repo are authored by Catherine Knox, with code contributions from Jonathan Lamontagne and Abigail Birnbaum. This repository provides all software to run the Boston Sea Level Rise Adaptation Model and to analyze output data. This repository accompanies the paper written by Catherine Knox, Paul Kirshen, Jonathan Lamontagne, and Shafiqul Islam at Tufts University. All four authors were involved in model design and development.  

# Purpose
The model was designed to quantify the trade-offs of three adaptation regimes in Boston Harbor: no cooperation, voluntary cooperation, or a regional authority. The model contains options for expliclty incorporating numerous levers in coastal, behavioral, legislative, and financial systems.

# Repository Overview
The repo contains files necessary to run the SLR model and analyze the outputs, contained in the relevant files. All data used for the paper, "More Than the Climate: Governance and Coordination Trade-offs for Sea Level Rise Adaptation in Boston", are stored in a separate zenodo repository: 10.5281/zenodo.15477516.

# To run the model:
Running the model requires a user to have both NetLogo 6.4 and python installed. The python version used for model development is 3.12 but other versions of python may be sufficient. All files supporting the NetLogo model must be installed in the same folder. Experiments can be run through NetLogo's Behvarior Space and saved as outputs to the user's computer. All of the following files can be found in the folder labeled 'model.'
| File Name  | Use |
| ------------- | ------------- |
| slr_adapt_model.nlogo  | The model itself built in NetLogo 6.4 (Wilensky, U (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.)  |
| total_harbor files  | GIS files to generate the proper shapes within the NetLogo model.  |
| boston_logan_maybe files  | GIS files used for Boston Logan airport location  |
| storm_surge_pattern_slr_0.csv, storm_surge_pattern_slr_1.csv, storm_surge_pattern_slr_3.csv, storm_surge_pattern_slr_5.csv  | Pre-generated patterns of storm surges to use in experiments.  |
| weight_factors_calcs.csv | Used to calculate the values of equity weighting included in the Model |
|model_documentation.doc | Provides all detail and overview of the model. |

# To analyze outputs:
The raw NetLogo outputs are stored on a zenodo repository: 10.5281/zenodo.15477516.
The following files can be found in the data folder and are used to process the output data.
| File Name  | Use |
| ------------- | ------------- |
| figure_generation_and_data_processing.ipynb   | The majority of the analysis is within this notebook. This was used to process outputs and generate the majority of figures used in paper submission.  |
| cart_gini_cases.R  | Used for the CART analysis in section 4.4.2 to generate trees based on the Gini Index outcomes |
| anova_Error_contribution.R | This code is used to calculate the error contribution from each lever over time to toal model error |
| base_cart_setup.R | This code represents the format and layout for the CART trees generated across the ensemble.  |
| cart_by_agent_comp_to_nc | More specific than the code above, this code created CART trees for the comparison of cooperative to non-cooperative approaches. |


