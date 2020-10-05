# steps #

# step 1
available::available("workflowrsubdirss")  # [lit 3a]
base::setwd("D:\\Cloud\\Sync\\Study\\Programming\\R\\Work\\Projects\\GitHub\\workflowrSubfolders")
devtools::create("code/workflowrsubdirs")
# Following message appears (shown options for Selection may differ each time):
#   New project 'workflowrsubdirs' is nested inside an existing project 'code/', which is rarely a good idea.
#   If this is unexpected, the here package has a function, `here::dr_here()` that reveals why 'code/' is regarded as a project.
#   Do you want to create anyway?

#   1: Negative
#   2: For sure
#   3: No way

#   Selection: 2

# step 2
# Close (click on the red x button in top right corner) a newly opened RStudio window.
# Update file "workflowrsubdirs/DESCRIPTION" [lit 3b]
# Create new .R files in directory "code/workflowrsubdirsUDP/R": generate.rmd.R, generate.subdir.R
# Create 1 function with 1 description per 1 .R file into these new .R files.


# step 3
devtools::document("code/workflowrsubdirs")
devtools::install("code/workflowrsubdirs")  # also for re-installing a package after a made change


# step 4 - test
workflowrsubdirs::generate.rmd()


# notes:
#  - possible code for committing new files relevant to package workflowrsubdirsUDP (redesign it to workflowrsubdirs)
#  workflowr::wflow_git_commit(
#    files = c("code/_workflowrsubdirs_steps.R", "code/workflowrsubdirs/*"),
#    message = "added: files for package",
#    all = T
#  )



# used literature
# [lit 1] https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html
# [lit 2] D:\Cloud\Sync\Study\Programming\R\Work\Projects\LearnUse R packages\steps to create and install my package.R
# [lit 3a] https://www.youtube.com/watch?v=79s3z0gIuFU - time 00:52 - 02:08
# [lit 3b] https://www.youtube.com/watch?v=79s3z0gIuFU - time 02:59 - 04:19
