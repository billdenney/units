context("Unit summaries")

test_that("we can compute summary functions on units", {
  x <- 1:4
  ux <- x * as_units("m")
  
  expect_equal(as.numeric(sum(ux)), sum(x))
  expect_equal(as.numeric(min(ux)), min(x))
  expect_equal(as.numeric(max(ux)), max(x))
  expect_equal(as.numeric(range(ux)), range(x))
  
  expect_equal(units(sum(ux)), units(ux))
  expect_equal(units(min(ux)), units(ux))
  expect_equal(units(max(ux)), units(ux))
  expect_equal(units(range(ux)), units(ux))
  
  expect_error(all(ux))
  expect_error(sum(ux, x))
  
  y <- 1:4
  uy <- y * as_units("km")
  expect_equal(as.numeric(sum(ux, uy)), sum(c(x, 1000*y)))
  expect_equal(as.numeric(min(ux, uy)), min(c(x, 1000*y)))
  expect_equal(as.numeric(max(ux, uy)), max(c(x, 1000*y)))
  expect_equal(as.numeric(range(ux, uy)), range(c(x, 1000*y)))
  z <- 1:4 * ud_units$s
  expect_error(sum(ux, z))
})

test_that("we can compute means and medians and quantiles", {
  x <- 1:4
  ux <- x * as_units("m")
  w <- x / 5:8
  
  expect_equal(as.numeric(mean(ux)), mean(x))
  expect_equal(as.numeric(median(ux)), median(x))
  expect_equivalent(as.numeric(quantile(ux)), quantile(x))
  expect_equal(as.numeric(weighted.mean(ux)), weighted.mean(x))
})

test_that("we can format units", {
  x <- 1:4
  ux <- x * as_units("m")
  
  expect_equal(format(ux), paste(x, units(ux)))
})
test_that("summary works with NA values", {
  x <- c(1, NA) * as_units("g")
  expect_equal(summary(x), summary(as.numeric(x)))
})
