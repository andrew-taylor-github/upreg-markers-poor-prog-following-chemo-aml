
library(gridExtra)
library(svglite)
library(grid)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# location of folder containing 3x3 tables
path <- "../intermediate_file_outputs/3x3_tables_for_R"

# get list of all CSV files in the folder
csv_files <- list.files(path = path, pattern = "\\.csv$", full.names = TRUE)

# initialize a list to store results
results <- list()

# loop through each filtered file
for (file in csv_files) {
  base_name <- basename(file)
  # regular expression to extract drug, cohort, and model type
  #   _drug( ... _cohort( ... )model_type.csv
  pattern <- "^[^_]*_([^_]+)_([^_]+)_([^_]+)\\.csv$"
  matches <- regmatches(base_name, regexec(pattern, base_name))[[1]]
  
  if (length(matches) == 4) {
    drug <- matches[2]
    cohort <- matches[3]
    model_type <- matches[4]
    cohort_drug <- paste(cohort, drug)
  }
    # read  CSV and convert to matrix if needed
    df <- read.csv(file, row.names = 1)
    if (!inherits(df, "matrix")) {
      df <- as.matrix(df)
    }
    
    # perform Fisher's exact test
    pval <- fisher.test(df, workspace = 2e8)$p.value
    
    # Store result
    results[[length(results) + 1]] <- data.frame(
      `cohort_and_drug` = cohort_drug,
      model_type = model_type,
      pval = pval
    )
  }


# Combine all results into one data frame
results_df <- do.call(rbind, results)
results_df <- as.data.frame(results_df)
results_df <- results_df[order(results_df$cohort_and_drug), ]


# Split results into Univariate and Multivariate data frames
univariate_df <- subset(results_df, model_type == "Univariate")
univariate_df <- univariate_df[order(as.character(univariate_df$cohort_and_drug)), ]
multivariate_df <- subset(results_df, model_type == "Multivariate")
multivariate_df <- multivariate_df[order(as.character(multivariate_df$cohort_and_drug)), ]

rownames(univariate_df) <- NULL
rownames(multivariate_df) <- NULL

print(univariate_df)
print(multivariate_df)
print(results_df)

table_grob <- tableGrob(univariate_df)
svglite("../results/figure_outputs_fishers_exact_3x3_tests/univariate_fisher_test_3x3_results.svg", width = 8, height = 6)
grid.draw(table_grob)
dev.off()

table_grob <- tableGrob(multivariate_df)
svglite("../results/figure_outputs_fishers_exact_3x3_tests/multivariate_fisher_test_3x3_results.svg", width = 8, height = 6)
grid.draw(table_grob)
dev.off()
