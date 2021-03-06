# Inside the group generic functions we do have .Generic even if the diagnostics
# think we do not.
# !diagnostics suppress=.Generic

#' @export
Summary.units = function(..., na.rm = FALSE) {
  OK <- switch(.Generic, "sum" = , "min" = , "max" = , "range" = TRUE, FALSE)
  if (!OK)
    stop(paste("Summary operation", .Generic, "not allowed"))
  
  args = list(...)
  u = units(args[[1]])
  if (length(args) > 1) {
    for (i in 2:length(args)) {
      if (!inherits(args[[i]], "units"))
        stop(paste("argument", i, "is not of class units"))
      if (!ud_are_convertible(units(args[[i]]), u))
        stop(paste("argument", i, 
                   "has units that are not convertible to that of the first argument"))
      args[[i]] = set_units(args[[i]], u, mode = "standard") # convert to first unit
    }
  }
  args = lapply(args, unclass)
  # as_units(do.call(.Generic, args), u)
  as_units(do.call(.Generic, c(args, na.rm = na.rm)), u)
}

#' @export
print.units = function (x, ...) { # nocov start
  if (is.array(x) || length(x) > 1L) {
    cat("Units: ", as.character(attr(x, "units")), "\n", sep = "")
    x <- drop_units(x)
    NextMethod()
  } else {
    cat(format(x, ...), "\n", sep="")
    invisible(x)
  }
} # nocov end

#' @export
mean.units = function(x, ...) {
  .as.units(NextMethod(), units(x))
}

#' @export
weighted.mean.units = mean.units

#' @export
median.units = mean.units

#' @export
quantile.units = function(x, ...) {
  .as.units(quantile(unclass(x), ...), units(x))
}

#' @export
format.units = function(x, ...) {
  setNames(paste(NextMethod(), units(x)), names(x))
}

#' @export
summary.units = function(object, ...) { 
  summary(unclass(object), ...)
}
