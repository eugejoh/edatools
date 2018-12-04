length_unique <- function(x,...) {
  tot_row <- nrow(x)
  obj_name <- deparse(substitute(x))
  len_uni <- map_dfc(x, .f = ~length(unique(.x))) %>% 
    gather(key=Variable,value=`Counts`) %>% 
    mutate(`Percentage of Total Rows` = round(100*Counts/tot_row,2)) %>% 
    add_kable(caption = paste0("Number of Unique Values in '", obj_name, "'"))
  
  return(len_uni) 
}
