
library(tidyverse)
library(glue)


df <- readxl::read_excel('/Users/ajpelu/Dropbox (Personal)/_cv/datasets.xlsx')

df <- df |> 
  mutate(icon = case_when(
    repo == "FIGSHARE" ~ '[{{< ai figshare size=xl color="#416ba3" >}}]', 
    TRUE ~ '[{{< ai doi size=xl color="#416ba3" >}}]'
    )
  )


combined <- ""

for (i in sort(unique(df$year), decreasing = TRUE)) {
  
  glueyear <- glue::glue(
    '### {i}
    '
  )
  
  gluedataset <- df |> 
    filter(year == i) |>  
    glue::glue_data('
                    
      - {author}, *{title}*, 
      Repository: {repo}. [doi: {doi_repo}](https://doi.org/{doi_repo}). {icon}(https://doi.org/{doi_repo})
      
      ') %>%
    stringr::str_flatten()

  combined <- paste(combined, glueyear, gluedataset, sep = "\n")
  
}


full_combined <- glue::glue('
---
title: "Dataset"
page-layout: full
---

Data is one of the valuable products of science. Their preservation, accessibility and reuse in ecology is crucial, given the importance of data sets for understanding complex ecological questions and/or solving emerging environmental problems (see [here](https://doi.org/10.7818/ECOS.1838) for more info, in Spanish) 

I strongly believe in the importance of sharing well documented data allowing their re-using, and therefore to advance in the scientific knowledge. My litle contribution is to include here a list of the datasets (and also Data Paper) that we (others collaborators and me) are deposited and published in different institutional repositories. 

{combined}
  '
)

write(full_combined, "datasets.qmd", append = TRUE)
