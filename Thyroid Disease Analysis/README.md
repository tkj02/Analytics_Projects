## Thyroid Disease Analysis

#### Motivation

I was motivated to learn more about thyroid diseases after a recent diagnosis of hyperthyroidism. I wanted to explore which groups of people are most affected by both hypothyroidism and hyperthyroidism as well as which treatment options are common in each group.

#### Data

I got my data from Emmanuel F. Werr on Kaggle under ["Thyroid Disease Data."](https://www.kaggle.com/datasets/emmanuelfwerr/thyroid-disease-data) This data originates from the [UCI Machine Learning Repository](10.24432/C5D010) thanks to Ross Quinlan's contribution in 1987. To understand this data's background and intended application, I highly recommend [this article](https://ieeexplore.ieee.org/document/9002284) from the Institute of Electrical and Electronics Engineers (IEEE).

#### Limitations

This dataset contains a variety of patients, and not all of them actually have a thyroid disease. This data was intended for machine learning development, specifically for identifying which patients have normal thyroid function and which do not. For my purposes, I needed to find and remove these normal patients in order to focus on my intended population. I did this by removing patients who had a target value of "-," which indicates normal function. Doing this reduced the size of my data by nearly 70%, and further categorization by age and sex as well as the removal of outliers left few patients in each group of interest. Ultimately, the insights I drew from this data are not as accurate as they could be.

Furthermore, some data contained errors, likely from inputting. For instance, I came across a few entries with ages over 65000. Other entries had unbelievably extreme TSH, T3, and FTI values. I opted to remove such data by placing bounds on related fields. More specifically, I placed an age limit of 130 and excluded patients whose hormone levels were considered outliers based on the (average value +- 2 standard deviations) for their age and sex. I believe using 2 standard deviations will remove true outliers without being too constricting.

#### Technology

I conducted my analysis in PostgreSQL through DBeaver and made a visualization on [Tableau](https://public.tableau.com/app/profile/tjoseph/viz/Thyroid_Analysis/Dashboard1).

#### Skills

- Data Cleaning (converted data, removed incorrect entries/outliers, etc.)
- Joins
- CTEs
- Aggregate Functions
- Grouping
- Ordering
- Case Expressions

#### Findings

Overall, women of at least 18 years old are most affected by thyroid diseases. Men of the same age categories tend to be affected roughly half as often on average. The only exception is during childhood in which men are seen to be most affected. However, given the few number of patients in the "Child" and "Teenager" categories (15 and 19 individuals respectively), I believe this exception is not significant.

Regarding FTI, children generally have higher values, especially male children. This is not necessarily a cause for concern since FTIs are expected to be higher during infancy, which could skew values. It is also relatively high in teenagers and young adults, which could be an indicator of hyperthyroidism. Concerning TSH, teenage men have the lowest values on average while teenage women have the highest. Middle-aged adults and elders regardless of sex also tend to have relatively high TSH values.

Across all patients receiving treatment, medication is the most common method. More women receive treatment than the other sexes, which makes sense as women are most affected by thyroid disease in general. Only one minor had thyroid surgery, and no minors underwent radiotherapy. Minors may be diagnosed infrequently due to difficulty in communicating with young children and changes during puberty that may mask thyroid problems in teenagers, hence the low number of patients receiving treatment in these categories. The social/mental maturity and hormonal stability that is associated with reaching adulthood can be expected to help identify diagnosing thyroid conditions, which may be a reason why there are more patients receiving treatment as adults and elders.

#### Future

There are some fields that I have not explored yet, such as the presence of goiters and tumors and how they relate to other fields. I also did not factor in T4U and TBG in my calculations since they did not seem as vital as TSH, T3, and FTI. For a future project, I would love to expand on these fields and see how prevalent they are by age and sex. I would also consider redefining my age categories to be more equally divided and see how different groupings affect my results.

I am also interested in attempting a machine-learning model of this data, as it was intended to be used. This may take a while to develop due to my busy schedule and other obligations, but I believe such a model would be a great supplement to this project!
