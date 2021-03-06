% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predictProb.R
\name{predictProb}
\alias{predictProb}
\alias{predictProb.ltrccf,}
\alias{predictProb.ltrcrsf}
\title{Compute a Survival Curve from a LTRCCF model or a LTRCRSF model}
\usage{
predictProb(
  object,
  newdata = NULL,
  newdata.id,
  OOB = FALSE,
  time.eval,
  time.tau = NULL
)
}
\arguments{
\item{object}{an object as returned by \code{\link{ltrccf}} or by \code{\link{ltrcrsf}}.}

\item{newdata}{an optional data frame containing the test data
(with the names of the variables the same as those in \code{data} from \code{object}).}

\item{newdata.id}{optional variable name of subject identifiers for \code{newdata}.
If this is present, it will be searched for in the \code{newdata} data frame.
Each group of rows in \code{newdata} with the same subject \code{id} represents
the covariate path through time of a single subject, and the result will
contain one curve per subject. If it is not specified, then an estimated survival
curve is returned for each row of \code{newdata}.}

\item{OOB}{a logical specifying whether out-of-bag predictions are desired


(only if \code{newdata = NULL}).}

\item{time.eval}{a vector of time points, at which the estimated survival probabilities
will be computed.}

\item{time.tau}{an optional vector, with the \emph{i}-th entry giving the upper time limit for the
computed survival probabilities for the \emph{i}-th data of interest (i.e., only computes
survival probabilies at \code{time.eval[time.eval <= time.tau[i]]} for the \emph{i}-th
data of interest). If \code{OOB = TRUE}, the length of \code{time.tau} is equal to the length of
\code{data} used to train the \code{object};
If \code{OOB = FALSE}, the length of \code{time.tau} is equal to the length
of \code{newdata}, or equal to the length of \code{data} if \code{newdata} is not given.
The default \code{NULL} is simply to set all entries of \code{time.tau} equal to the maximum
value of \code{time.eval}, so that all estimated survival probabilities are computed at the
same \code{time.eval}.}
}
\value{
A list containing:
   \item{survival.id}{subject identifiers.}
   \item{survival.obj}{an object of class \code{\link[survival]{Surv}}.}
   \item{survival.probs}{the estimated survival probabilities for each data of interest.
   It is a list if the length of the estimated values differs from one to another;
   otherwise, it is a matrix with the number of columns equal to the number of the data
   of interest, number of rows equal to the number of the time points at which the estimated
   survival probabilities are computed.}
   \item{survival.tau}{the input value \code{time.tau}.}
   \item{survival.times}{the input value \code{time.eval}. }
}
\description{
Constructs a monotone nonincreasing estimated survival curve from a LTRCCF model or a 
LTRCRSF model for any given (left-truncated) right-censored survival data with time-varying 
covariates.
It can also compute survival function estimates for left-truncated right-censored data
with time-invariant covariates.
}
\examples{
#### Example with data pbcsample
library(survival)
Formula <- Surv(Start, Stop, Event) ~ age + alk.phos + ast + chol + edema
## Fit an LTRC conditional inference forest on time-varying data
LTRCCFobj <- ltrccf(formula = Formula, data = pbcsample, id = ID,
                    mtry = 3, ntree = 50L)


## Construct an estimated survival estimate for the second subject
tpnt <- seq(0, max(pbcsample$Stop), length.out = 50)
newData <- pbcsample[pbcsample$ID == 2, ]
Pred <- predictProb(object = LTRCCFobj, newdata = newData, newdata.id = ID,
                    time.eval = tpnt)
## Since time.tau = NULL, Pred$survival.probs is in the matrix format, with dimensions:
dim(Pred$survival.probs) # length(time.eval) x nrow(newdata)
## Plot the estimated survival curve
plot(Pred$survival.times, Pred$survival.probs, type = "l", col = "red",
     xlab = "Time", ylab = "Survival probabilities")



}
\seealso{
\code{\link{sbrier_ltrc}} for evaluation of model fit
}
