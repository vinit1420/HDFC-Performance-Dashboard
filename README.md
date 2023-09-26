# HDFC: Business Analyst - RBI Card Performance Dashboard

This project is a part of the Micro-experience program that I completed with bluetick.ai. They have come up with this industry use case in partnership with HDFC Bank to simulate the kind of work a business analyst would be doing at HDFC. The aim of this project was to help the management at HDFC Bank by creating a dashboard to compare their performance in the debit and credit cards segment with the rest of the industry in-turn playing a key role in strategic planning and decision making.

## Tech Stack Used : 

1. Python: Web-Scraping
2. Excel: Data Cleaning 
3. Power BI: Analysis and Visualisation

### Step 1 : Web Scraping -

- The data has been scraped from rbi's official website : https://www.rbi.org.in/Scripts/ATMView.aspx
- The website generates dynamic content through Javascript, hence selenium was used to navigate to the desired content and scrape the excel files from the webpage.
- The excel files from Apr-2022 to Mar-2023 were scraped from the website.
- The code for the same has been posted in this repository.

### Step 2 : Data Cleaning -

- Each excel file had to be converted to the desired format.
- The following rules were followed to create the required excel file:
    1. Delete columns that are not related to credit or debit cards.
    2. Unmerge merged cells.
    3. Aggregate "Volume" and "Value" for all the transaction modes (PoS, Online, Others.) "Value" should be in ₹ and NOT in ₹ '000s.
    4. Do not consider "Cash Withdrawal."Remove "Payment" and "Small Finance" banks.
    5. Tag the remaining banks as "Public, Private, and Foreign."
    6. Delete any empty rows or columns.
- Since there were a total of 12 files to be cleaned, a macro was created to perform these tasks and used to clean the rest of the files.

### Step 3 : Analysis and Visualisation -

- The cleaned excel files for each month were then loaded into power bi and combined together to form one big master-data.
- Then data was validated by making sure each column has the appropriate data type and all null and missing values are dealt with accordingly.
- The required columns were created using DAX expressions to get spend_per_card, transactions_per_card and spend_per_transaction for debit and credit cards.
- Then advanced editor was used to create custom columns to get last month's data for the above fields.
- The first page of the dashboard contained the high-level view with latest numbers for both market share and KPIs and month-over-month growth of these metrics.
- This was acheived using KPI visuals and configuring trend as months and trend axis as last_months_data for the different fields.
- The page also contained slicers for dynamically choosing the month and bank_name for which the visuals had to be created.
- The second page of the dashboard showed the market share analysis of a selected bank with the rest of the industry in terms of revenue, transactions, volume of cards and spend_per_card.
- This page also offered a slicer for choosing the card type and dynamic measures were created to change the visuals according to the selected card_type.
- It also contained a visual showing the top 10 banks by card revenue.
- The .pbix file for the dashboard has been posted in this repository.
  


