
# nocov start
# This is setup code and all fails if we do not do it and use the units
# in the list, so there are no explicit tests for this, thus the nocov

.read_ud_db_symbols <- function(dir, filename) {
  database <- xml2::read_xml(file(paste(dir, filename, sep = "/")))
  symbols <- xml2::xml_find_all(database, ".//symbol[not(@*)]")
  unlist(Map(function(node) as.character(xml2::xml_contents(node)), symbols))
}

.read_ud_db_scales <- function(dir, filename) {
  database <- xml2::read_xml(file(paste(dir, filename, sep = "/")))
  symbols <- xml2::xml_find_all(database, ".//value")
  symbols
  unlist(Map(function(node) as.numeric(as.character(xml2::xml_contents(node))), symbols))
}

.get_ud_symbols <- function() {
  udunits2_dir <- dirname(Sys.getenv("UDUNITS2_XML_PATH"))
  symbols <- c(.read_ud_db_symbols(udunits2_dir, "udunits2-base.xml"),
               .read_ud_db_symbols(udunits2_dir, "udunits2-derived.xml"),
               .read_ud_db_symbols(udunits2_dir, "udunits2-accepted.xml"),
               .read_ud_db_symbols(udunits2_dir, "udunits2-common.xml"))
  symbols
  symbols[symbols == make.names(symbols)]
}

.get_ud_prefixes <- function() {
  udunits2_dir <- dirname(Sys.getenv("UDUNITS2_XML_PATH"))
  .read_ud_db_symbols(udunits2_dir, "udunits2-prefixes.xml")
}

.construct_ud_units <- function(){
  ud_prefixes <- .get_ud_prefixes()
  ud_symbols <- .get_ud_symbols()
  expand_with_prefixes <- function(symbol) paste(ud_prefixes, symbol, sep = "")
  symbols <- c(ud_symbols, 
               unlist(Map(expand_with_prefixes, ud_symbols), use.names = FALSE))
  ud_units <- Map(make_unit, symbols)
  names(ud_units) <- symbols
  ud_units
}

# Use this to generate the data -- to avoid Travis problems the result
# is stored as package data
#ud_units <- .construct_ud_units()
#devtools::use_data(ud_units)

#' List containing pre-defined units from the udunits2 package.
#' 
#' Load it in using data(ud_units)
#' 
#' @export
ud_units <- NULL

# nocov end