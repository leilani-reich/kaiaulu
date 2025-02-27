% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metric.R
\name{metric_churn}
\alias{metric_churn}
\title{Churn Metric}
\usage{
metric_churn(lines_added, lines_removed)
}
\arguments{
\item{lines_added}{numeric vector additions to a file due to a commit}

\item{lines_removed}{numeric vector of deletions to a file due to a commit
in the table}
}
\value{
a numeric vector of churn
}
\description{
Simply adds two columns, expected to be additions and deletions from a file.
}
\seealso{
\code{\link{parse_gitlog}} to obtain additions and deletions from gitlog

Other {metrics}: 
\code{\link{commit_message_id_coverage}()},
\code{\link{metric_churn_per_commit_interval}()},
\code{\link{metric_churn_per_commit_per_file}()}
}
\concept{{metrics}}
