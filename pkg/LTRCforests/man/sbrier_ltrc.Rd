% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sbrier_ltrc.R
\name{sbrier_ltrc}
\alias{sbrier_ltrc}
\title{Model fit evaluation for LTRC forests.}
\usage{
sbrier_ltrc(obj, id = NULL, pred, type = c("IBS", "BS"))
}
\arguments{
\item{obj}{an object of class \code{\link[survival]{Surv}}, formed on
left-truncated right-censored observations (which are pseudo-subject
observations in the time-varying case).}

\item{id}{an optional vector as subject identifiers for \code{obj}.}

\item{pred}{a list. This should contain 1) either a matrix
or a list of survival probabilies named \code{survival.probs}; 2) a sequence
of time points \code{survival.times}; 3) a vector of upper time limits
\code{survival.tau}.
See the values returned by \code{\link{predictProb}}.}

\item{type}{a character string denoting the type of scores returned. If \code{type = "IBS"},
the integrated Brier score up to the last time point in \code{pred$surv.times} that is
not larger than the minimum value of \code{pred$surv.tau} is returned.
If \code{type = "BS"}, the Brier score at every time point in \code{pred$surv.times} up to
the minimum value of \code{pred$surv.tau} is returned. \code{type = "IBS"} is set by default.}
}
\value{
If \code{type = "IBS"}, this returns the integrated Brier score.

If \code{type = "BS"}, this returns \code{BScore}, the Brier scores
and \code{Time}, the time points at which the scores are computed.
}
\description{
Compute the (integrated) Brier score to evaluate the model fit for
(left-truncated) right-censored survival data with time-varying covariates,
as well as left-truncated right-censored data with time-invariant covariates.
}
\examples{
### Example with dataset pbcsample
library(survival)
Formula = Surv(Start, Stop, Event) ~ age + alk.phos + ast + chol + edema
## Fit an LTRC conditional inference forest on time-varying data
LTRCCFobj = ltrccf(formula = Formula, data = pbcsample, id = ID, mtry = 3, ntree = 50L)

# Time points
tpnt = seq(0, 6000, by = 100)
# Set different upper time limits for each of the subjects
tau = seq(4001, 6200, length.out = length(unique(pbcsample$ID)))
## Obstain estimation at time points tpnt
Predobj = predictProb(object = LTRCCFobj, time.eval = tpnt, time.tau = tau)

## Compute the integrated Brier score:
pbcobj = Surv(pbcsample$Start, pbcsample$Stop, pbcsample$Event)
IBS = sbrier_ltrc(obj = pbcobj, id = pbcsample$ID, pred = Predobj, type = "IBS")

## Compute the Brier score at each value of tpnt
BS = sbrier_ltrc(obj = pbcobj, id = pbcsample$ID, pred = Predobj, type = "BS")
## Plot the Brier scores
plot(BS$Time, BS$BScore, pch = 20, xlab = "Time", ylab = "Brier score", col = 2)
## As one can see, the Brier scores are returned at all tpnt up to 4000,
## this is because the algorithm set the last evaluation time point
## to be 4000 based on the value of time.eval and time.tau
## (max(tpnt[tpnt <= min(tau)]) == 4000).
}
