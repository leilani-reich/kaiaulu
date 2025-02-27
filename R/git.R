# Kaiaulu - https://github.com/sailuh/kaiaulu
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#' Performs a git checkout on specified repo
#'
#' @param commit_hash The commit hash the repo should be checkout
#' @param git_repo_path The git repo path
#' @return Any error message generated by git
#' @export
git_checkout <- function(commit_hash,git_repo_path){
  # Expand paths (e.g. "~/Desktop" => "/Users/someuser/Desktop")
  git_repo_path <- path.expand(git_repo_path)
  # Remove ".git"
  folder_path <- stri_replace_last(git_repo_path,replacement="",regex=".git")
  error <- system2('git',
                  args = c('--git-dir',
                           git_repo_path,
                           '--work-tree',
                           folder_path,
                           'checkout',
                           commit_hash),
                  stdout = TRUE,
                  stderr = FALSE)
  return(error)
}
#' Gets the current commit hash head of the git repo
#'
#' @param git_repo_path The git repo path
#' @return A commit hash character
#' @export
git_head <- function(git_repo_path){
  # Expand paths (e.g. "~/Desktop" => "/Users/someuser/Desktop")
  git_repo_path <- path.expand(git_repo_path)
  head <- system2('git',
                  args = c('--git-dir',
                           git_repo_path,
                           'rev-parse',
                           'HEAD'),
                  stdout = TRUE,
                  stderr = FALSE)
  return(head)
}
#' Saves gitlog to a path
#'
#' Saves the `.git` of a github repository as a gitlog at the specified path
#'
#' @param git_repo_path The git repo path
#' @param flags Optional flags for git log command
#' @param save_path the filepath to save the file
#' @export
git_log <- function(git_repo_path,flags,save_path){
  system2(
    "git",
    args = c(
      '--git-dir',
      git_repo_path,
      'log',
      flags,
      '>' ,
      save_path
    ),
    stdout = TRUE,
    stderr = FALSE
  )
}
#' Git blame wrapper
#'
#' @param git_repo_path The git repo pat
#' @param flags Optional flags for git log command
#' @param commit_hash The commit hash of the file we will blame
#' @param file_path The file we will blame
#' @export
git_blame <- function(git_repo_path,flags,commit_hash,file_path){

  # Some commit hashes, like APR's project git 572
  # throws error 128 from git
  # 6154ab7b1e862927c90ae6afa4dc6c57ee657ceb

  # This example changes function signature and a line inside
  # https://github.com/apache/apr/commit/ffdad353ac4b4bc2868603338e8ca50db90923a8
  blamed_file <- tryCatch({
    system2(
      "git",
      args = c(
        '--git-dir',
        git_repo_path,
        'blame',
        flags,
        commit_hash,
        file_path
      ),
      stdout = TRUE,
      stderr = FALSE
    )
  },
  warning = function(e) {
    #message(e)
    return(NULL)
  })
  # Blamed file was deleted by the commit
  if(is.character(blamed_file) & length(blamed_file) == 0){return(NULL)}
  return(blamed_file)


}

#' Creates a sample git log with one commit
#'
#' This is a SetUp helper function for Kaiaulu unit tests
#' that manipulates git logs.
#'
#' A folder kaiaulu_sample is created in /tmp by default. A file,
#' hello.R with a single print is then added to the folder.
#' Git init is performed, the file is git add, and commit to
#' the git log.
#'
#'
#' @param folder_path An optional path to where the sample .git should be created.
#' @return The path to the sample .git file.
#' @export
#' @family {unittest}
git_create_sample_log <- function(folder_path="/tmp"){
  # Expand paths (e.g. "~/Desktop" => "/Users/someuser/Desktop")
  folder_path <- path.expand(folder_path)
  folder_path <- file.path(folder_path,"kaiaulu_sample")

  #mkdir path/to/folder/sample
  error <- system2('mkdir',
                   args = c(folder_path),
                   stdout = TRUE,
                   stderr = FALSE)


  file_path <- file.path(folder_path,"hello.R")

  #echo "print('hello world!')" >  path/to/folder/hello.R
  error <- system2('echo',
                   args = c("\"print('hello world!')\"",
                            '>',
                            file_path),
                   stdout = TRUE,
                   stderr = FALSE)

  # git init path/to/folder
  error <- system2('git',
                   args = c('init',
                            folder_path),
                   stdout = TRUE,
                   stderr = FALSE)

  git_repo <- file.path(folder_path,'.git')

  # git --git-dir sample/.git --work-tree sample add hello.R
  error <- system2('git',
                   args = c('--git-dir',
                            git_repo,
                            '--work-tree',
                            folder_path,
                            'add',
                            '.'),
                   stdout = TRUE,
                   stderr = FALSE)

  # git --git-dir sample/.git --work-tree sample commit -m 'hello world commit'
  error <- system2('git',
                   args = c('--git-dir',
                            git_repo,
                            '--work-tree',
                            folder_path,
                            'commit',
                            '-m',
                            "'hello world commit'"),
                   stdout = TRUE,
                   stderr = FALSE)

  return(git_repo)
}

#' Removes sample folder and git log
#'
#' This is a TearDown helper function for Kaiaulu unit tests
#' that manipulates git logs.
#'
#' A folder kaiaulu_sample is assumed to have been created by \code{\link{git_create_sample_log}}, and is deleted by this function.
#'
#' @param folder_path An optional path to where the sample .git should be created.
#' @return The path to the sample .git file.
#' @export
#' @family {unittest}
git_delete_sample_log <- function(folder_path="/tmp"){
  folder_path <- path.expand(folder_path)
  folder_path <- file.path(folder_path,"kaiaulu_sample")
  error <- system2('rm',
                   args = c('-r',
                            folder_path),
                   stdout = TRUE,
                   stderr = FALSE)
}
