df_describe_p <- function(x, org, dat_name, ...) {
  obj_name <- deparse(substitute(x))
  
  p_out <- ggplot(data = x) +
    geom_bar(aes(x = forcats::fct_inorder(col_name), y = NA_percent, fill = data_type, colour = data_type), stat = 'identity') +
    coord_flip() +
    labs(title = paste0("Summary of Missing Values and Data Types in '", dat_name, "'"),
         caption = paste0("Number of Rows in Table: ", nrow(org)),
         y = "Percent Missing Values (%)", x = "Variables") +
    scale_fill_brewer(type = "qual", name = "Data Type") +
    scale_colour_brewer(type = "qual", name = "Data Type") +
    guides(colour=FALSE)
  
  return(p_out)
}
