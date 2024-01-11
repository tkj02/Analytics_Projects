## Electric Vehicle Sales Analysis

#### Motivation

A relative of mine is considering buying a new vehicle in the next few years. Naturally, there has been a lot of discussion on which make and model would be the best for her needs. These discussions happened to overlap with the purchase of an electric car made by another one of my relatives. It made me wonder how popular electric cars are these days, and with further consideration, I was curious about which car makes and models are succeeding the most.

#### Data

I got my data from Mathurin Aché on Kaggle under ["Electric Car Sales by Model in USA"](https://www.kaggle.com/datasets/mathurinache/electriccarsalesbymodelinusa/data). This data contains 57 unique entries by electric car make and model as well as the number of sales made in each month between 2012 and 2019.

#### Limitations

This dataset does not contain information about car prices or special features specific to each model, which are key factors that directly affect sales numbers. Without this information, we can not accurately compare the models to each other, and in turn, we can not identify potential reasons for differences in sales.

Furthermore, this data is specific to the United States, so it does not allow us to make globally applicable conclusions.

#### Technology

I conducted the majority of my data cleaning through Excel and my analysis in PostgreSQL through DBeaver. A visualization of my findings is available on [Tableau](https://public.tableau.com/views/ElectricVehicleSales_17044364227720/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link).

#### Skills

- Data Cleaning (converted data types, removed unnecessary data, etc.)
- Joins
- CTEs
- Aggregate Functions
- Grouping
- Ordering

#### Findings

Over 47 million electric cars were purchased between 2012 and 2019 in the United States alone. Tesla, Chevrolet, and Nissan are the best-selling makes, contributing to nearly half (more specifically, 48%) of the total sales.

While the top three makes sold less in 2019 than in 2018, they are expected to continue selling more in the future according to trend lines in my visualization. The next seven best-selling makes also have a positive trend, but the rate of change is not as sizeable for brands such as Fiat and Audi. Several factors could contribute to these differences, such as prices, extra features, product availability, popularity, and more.

There seems to be an exponential growth in sales regardless of brand. We can expect to see higher yearly electric car sales in 2020 onwards.

#### Future

I believe looking into the demographics of the customers and exploring any correlations that may come up would be very useful. Potential areas for consideration are customer income, gender, age category, race/ethnicity, and geographic location (including beyond the United States). Understanding customers and focusing on their needs and interests can improve future sales.

Comparing electric sales to that of non-electric and hybrid cars from the same makes would also provide valuable insights. Doing this would give us a better understanding of the true popularity of electric cars.
