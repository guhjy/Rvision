#' @title Optical Flow Using Farneback's Algorithm
#'
#' @description Computes a dense optical flow using the Gunnar Farneback’s algorithm.
#'
#' @param image1 An \code{\link{Image}} object.
#'
#' @param image2 An \code{\link{Image}} object.
#'
#' @param pyr_scale Parameter, specifying the image scale (<1) to build pyramids
#'  for each image; pyr_scale = 0.5 means a classical pyramid, where each next
#'  layer is twice smaller than the previous one.
#'
#' @param levels Number of pyramid layers including the initial image; levels = 1
#'  means that no extra layers are created and only the original images are used.
#'
#' @param winsize Averaging window size; larger values increase the algorithm
#'  robustness to image noise and give more chances for fast motion detection,
#'  but yield more blurred motion field.
#'
#' @param iterations Number of iterations the algorithm does at each pyramid level.
#'
#' @param poly_n Size of the pixel neighborhood used to find polynomial expansion
#'  in each pixel; larger values mean that the image will be approximated with
#'  smoother surfaces, yielding more robust algorithm and more blurred motion
#'  field, typically poly_n = 5 or 7.
#'
#' @param poly_sigma Standard deviation of the Gaussian that is used to smooth
#'  derivatives used as a basis for the polynomial expansion; for poly_n = 5, you
#'  can set poly_sigma = 1.1, for poly_n = 7, a good value would be poly_sigma = 1.5.
#'
#' @return A matrix with the same number of rows and columns as the original
#'  images, and two layers representing the x and y components of the optical
#'  flow for each pixel of the image.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @references Farnebäck G. Two-Frame Motion Estimation Based on Polynomial
#'  Expansion. In: Bigun J, Gustavsson T, editors. Image Analysis. Springer
#'  Berlin Heidelberg; 2003. pp. 363–370. doi:10.1007/3-540-45103-X_50
#'
#' @seealso \code{\link{plot.OF_array}}
#'
#' @examples
#' # TODO
#' @export
farneback <- function(image1, image2, pyr_scale = 0.5, levels = 3, winsize = 43,
                      iterations = 3, poly_n = 7, poly_sigma = 1.5) {
  if (pyr_scale >= 1)
    stop("pyr_scale must be < 1.")

  if (!isImage(image1) | !isImage(image2))
    stop("image1 and image2 must be Image objects.")

  img1 <- cloneImage(image1)
  img2 <- cloneImage(image2)

  if (colorspace(img1) != "GRAY")
    img1 <- changeColorSpace(img1, "GRAY")

  if (colorspace(img2) != "GRAY")
    img2 <- changeColorSpace(img2, "GRAY")

  if (bitdepth(img1) != "8U")
    img1 <- changeBitDepth(img1, 8)

  if (bitdepth(img2) != "8U")
    img2 <- changeBitDepth(img2, 8)

  out <- `_farneback`(img1, img2, pyr_scale, levels, winsize, iterations, poly_n, poly_sigma)
  class(out) <- "OF_array"
  out
}


#' @title Plot Optical Flow Arrays
#'
#' @description Plotting method for objects of class \code{OF_array} as produced
#'  by the \code{\link{farneback}} function.
#'
#' @param x An object of class \code{OF_array}.
#'
#' @param gridsize A 2-element vector indicating the number of optical flow
#'  vectors to plot in each x-y dimension (default: c(25, 25)). Alternatively, a
#'  numeric value that will be used for both dimensions.
#'
#' @param thresh The minimal length of optical flow vectors that should be
#'  plotted (default: 0).
#'
#' @param add A logical indicating whether to plot the vector field over an
#'  existing plot (default: FALSE).
#'
#' @param arrow.ex Controls the length of the arrows. The length is in terms of
#'  the fraction of the shorter axis in the plot. So with a default of .05, 20
#'  arrows of maximum length can line up end to end along the shorter axis.
#'
#' @param xpd If true does not clip arrows to fit inside the plot region,
#'  default is not to clip.
#'
#' @param ... Graphics arguments passed to the \code{\link{arrows}} function that
#'  can change the color or arrow sizes. See help on this for details.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @seealso \code{\link{farneback}}, \code{\link{arrows}}
#'
#' @examples
#' # TODO
#' @export
plot.OF_array <- function(x, gridsize = c(25, 25), thresh = 0,
                          add = TRUE, arrow.ex = 0.05, xpd = TRUE, ...) {
  if (class(x) != "OF_array")
    stop("array must be an object of class OF_array as produced by the farneback function.")

  if (length(gridsize) == 1)
    gridsize <- c(gridsize, gridsize)

  if (length(gridsize) > 2)
    gridsize <- gridsize[1:2]

  locs <- expand.grid(x = floor(seq(1, ncol(x), length.out = gridsize[1])),
                      y = floor(seq(1, nrow(x), length.out = gridsize[2])))
  x <- locs$x
  y <- locs$y

  id <- (x - 1) * nrow(x) + y
  y <- max(y) - y
  u <- x[, , 1][id]
  v <- x[, , 2][id]

  valid <- sqrt(u ^ 2 + v ^ 2) >= thresh

  if (add == FALSE) {
    plot(NA, xlim = c(1, ncol(x)), ylim = c(1, nrow(x)))
  }

  ucord <- par()$usr
  arrow.ex <- arrow.ex * min(ucord[2] - ucord[1], ucord[4] - ucord[3])

  maxr <- max(sqrt(u ^ 2 + v ^ 2))
  u <- (arrow.ex * u) / maxr
  v <- (arrow.ex * v) / maxr
  invisible()
  old.xpd <- par()$xpd
  graphics::par(xpd = xpd)
  graphics::arrows(x[valid], y[valid], x[valid] + u[valid], y[valid] + v[valid], ...)
  graphics::par(xpd = old.xpd)
}
