# 20-09-19
# Steps based on https://github.com/jdblischak/workflowr/issues/220#issuecomment-694924738
#   -> https://github.com/jdblischak/workflowr/issues/95
# ----

# step 1 - create suitable subfolders
#  Folder "workflowr project directory/code": This directory is for code that might not be appropriate to include
#    in R Markdown format (e.g. for pre-processing the data, or for long-running code). [https://jdblischak.github.io/workflowr/articles/wflow-01-getting-started.html]
#    For organizational purposes: don't write save .Rmd files here, create suitable subfolders here. [me]
#  Create "workflowr project directory/codeRmd" folder (with further additional folder names that are same as "workflowr project directory/code" subfolder names)
#    for .Rmd files for relevant "workflowr project directory/code" subfolders. [me]
#    Important: Don't use "analysis/codeRmd" otherwise following error pops-up when using workflowr::wflow_publish(...)
#      Error in to_html(files_analysis, outdir = o$docs) : Invalid file extension

# step 2 - ensure that ./analysis is the working directory

# step 3 - execute generate_rmd() and wflow_build_dir()
#   edited codes from https://github.com/jdblischak/workflowr/issues/95#issuecomment-360094662
generate_rmd <- function(path, alias, dir) {
  path <- base::paste0(dir, '/', path)
  abs.path <- tools::file_path_as_absolute(paste0('../', path))
  base::cat(
    "---\n",
    yaml::as.yaml(rmarkdown::yaml_front_matter(abs.path)),  # yaml header from original .Rmd file
    "---\n\n",
    # "**Source file\\:** ", path, "\n\n",  # link to original .Rmd file; update (it's commented) of issues/95
    "```{r child='", abs.path, "'}\n```",   # code (not yaml header) of original .Rmd file
    sep = "",
    file = alias  # where a file will be created
  )
}

# ensure that a) .analysis is the working directory, b) folder with subdirectories (subfolders) is in the workflowr project directory
wflow_build_dir <- function(files = NULL, dir = 'codeRmd', ...) {
  if (base::is.null(files)) {
    files <- list.files(paste0('../', dir), recursive = T,
                      include.dirs = T, pattern = "./*.(r|R)md")
  }
  else {
    for (file in files) {
      path<-base::paste0(dir, "/", file)
      if (!file.exists(paste0('../', path)))
        stop(base::paste0("File doesn't exist: ./", path))
    }
  }

  file_aliases <- base::gsub("/", "--", files)
  base::mapply(generate_rmd, files, file_aliases, dir = dir)
  workflowr::wflow_build(files = file_aliases, ...)
  base::invisible(file.remove(file_aliases))
}

# step 4 - execute wflow_build_dir()
wflow_build_dir()

# step 5 - at this point
#   - folder "code" contains subfolders with (e.g.) development codes, ...
#   - folder "codeRmd" contains subfolders with .Rmd files associated with development codes, ...
#   - more efficient way (less manual work) of creating .html files is prepared in comparison with steps on 19-09-17
#     plus a potential problem with the workflowr reproducibility checks [https://github.com/jdblischak/workflowr/issues/220#issuecomment-694924738] could be resolved.
#   - folder "docs" contains .html files created from .Rmd files from folder "codeRmd" but I'd like to have them in an appropriate subfolders instead of using delimiters like "--"
#     so that means similar steps like on 19-09-17 in "step 4" and "step 5" should be applied or I need to live with using of delimiters like "--"
#       - I think to simply live with that because I critical is to have perfectly organized .Rmd files rather than .html files because workflowr will basically take care about these .html files.
#   - keep in mind to use correct hyperlinks to future .html files (this shouldn't be a problem)

# step 6 - commit/publish, push
base::setwd("../")  # set workflowr project as the working directory
workflowr::wflow_publish(".", "better notes for wflow_use_github()")  # 1stly ensure that correct working directory is set
workflowr::wflow_use_github("LearnUseZone", "workflowrSubfolders")  # choose 1 to create repository "workflowrSubfolders" automatically -> sign-in in loaded web browser to authenticate
workflowr::wflow_git_push()  # enter username and password (if SSH is not set)

