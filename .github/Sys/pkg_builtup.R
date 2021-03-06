


unlink("CITestR.Rproj")
usethis::create_package(".")
usethis::use_namespace()
usethis::use_git()
usethis::use_github_links()


usethis::use_travis(ext = "org")
usethis::use_appveyor()

usethis::use_circleci()
usethis::use_github_action_check_standard()
usethis::use_github_actions_badge(name = "GitHub")

usethis::use_r("simple")
usethis::use_test()


# test for tidycells

usethis::use_package("shinytest", type = "Suggests")
