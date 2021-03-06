#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadTennessee <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('47') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/tn/RptSixMonthSumJune2016.csv", col_names=paste0('X', 1:7), col_types=paste0(rep('c', 7), collapse="")) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", X3, X4) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA, CountyName=X1, N=X3+X4) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
