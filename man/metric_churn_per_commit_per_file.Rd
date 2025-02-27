% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metric.R
\name{metric_churn_per_commit_per_file}
\alias{metric_churn_per_commit_per_file}
\title{Churn Metric per Commit per File}
\usage{
metric_churn_per_commit_per_file(git_log)
}
\arguments{
\item{git_log}{a parsed git log table where each row is identified by commit+file}
}
\value{
`git_log` with an additional `churn` column.
}
\description{
Calculates the churn metric for a sequence of commits per commit per file
}
\seealso{
\code{\link{parse_gitlog}} to obtain `git_log`

Other {metrics}: 
\code{\link{commit_message_id_coverage}()},
\code{\link{metric_churn_per_commit_interval}()},
\code{\link{metric_churn}()}
}
\concept{{metrics}}
