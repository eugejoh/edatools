add_DT <- function(input, ...) {
  DT::datatable(data = input, extensions = 'Buttons', ..., 
                options = list(
                  width = 9,
                  pageLength = 20,
                  lengthMenu = c(5,10,20,50),
                  buttons = c("csv","excel")))
}
