% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/objectSize.R
\name{objSize}
\alias{objSize}
\alias{objSize.default}
\alias{objSize.list}
\alias{objSize.environment}
\alias{objSize.Path}
\alias{objSize.function}
\alias{objSizeSession}
\title{Recursive \code{object.size}}
\usage{
objSize(x, quick, enclosingEnvs, .prevEnvirs, ...)

\method{objSize}{default}(
  x,
  quick = getOption("reproducible.quick", FALSE),
  enclosingEnvs = TRUE,
  .prevEnvirs = list(),
  ...
)

\method{objSize}{list}(
  x,
  quick = getOption("reproducible.quick", FALSE),
  enclosingEnvs = TRUE,
  .prevEnvirs = list(),
  ...
)

\method{objSize}{environment}(
  x,
  quick = getOption("reproducible.quick", FALSE),
  enclosingEnvs = TRUE,
  .prevEnvirs = list(),
  ...
)

\method{objSize}{Path}(
  x,
  quick = getOption("reproducible.quick", FALSE),
  enclosingEnvs = TRUE,
  .prevEnvirs = list(),
  ...
)

\method{objSize}{`function`}(
  x,
  quick = getOption("reproducible.quick", FALSE),
  enclosingEnvs = TRUE,
  .prevEnvirs = list(),
  ...
)

objSizeSession(sumLevel = Inf, enclosingEnvs = TRUE, .prevEnvirs = list())
}
\arguments{
\item{x}{An object}

\item{quick}{Logical. Only some methods use this. e.g.,
\code{Path} class objects. In which case, \code{file.size} will be
used instead of \code{object.size}.}

\item{enclosingEnvs}{Logical indicating whether to include enclosing environments.
Default \code{TRUE}.}

\item{.prevEnvirs}{For internal account keeping to identify and prevent duplicate counting}

\item{...}{Additional arguments (currently unused)}

\item{sumLevel}{Numeric, indicating at which depth in the list of objects should the
object sizes be summed (summarized). Default is \code{Inf}, meaning no sums. Currently,
the only option other than Inf is 1: \code{objSizeSession(1)},
which gives the size of each package.}
}
\description{
This has methods for various types of things that may not correctly report
their object size using \code{object.size}.
Also, for lists and environments, it will return the object size separately for each element.
These are estimates only, and could be inaccurate.
Alternative, similar functions include \code{object.size} and \code{pryr::object_size}.
See Details for the special case of functions and their enclosing environments.
}
\details{
For functions, a user can include the enclosing environment as described
\url{https://www.r-bloggers.com/using-closures-as-objects-in-r/} and
\url{http://adv-r.had.co.nz/memory.html}.
It is not entirely clear which estimate is better.
However, if the enclosing environment is the \code{.GlobalEnv}, it will
not be included even though \code{enclosingEnvs = TRUE}.

\code{objSizeSession} will give the size of the whole session, including loaded packages.
Because of the difficulties in calculating the object size of \code{base}
and \code{methods} packages and \code{Autoloads}, these are omitted.
}
\examples{
library(utils)

foo <- new.env()
foo$b <- 1:10
foo$d <- 1:10

objSize(foo) # all the elements in the environment
object.size(foo) # different - only measuring the environment as an object

object.size(prepInputs) # only the function, without its enclosing environment
objSize(prepInputs)     # the function, plus its enclosing environment

# Size of all packages; includes their imported functions
\dontrun{
  bar <- objSizeSession(1)
  print(bar, units = "auto")
}

os1 <- object.size(as.environment("package:reproducible"))
os2 <- objSize(as.environment("package:reproducible"))
(os1) # very small -- just the environment container
sum(unlist(os2)) # around 13 MB, with all functions, objects
                 # and imported functions

}
