library(magrittr)

lastshow <- phishr::pi_get_shows(key, "2019-12-31")$set_list[[1]] %>%
  dplyr::select(title, set, duration) %>%
  as.data.frame() %>%
  dplyr::mutate(
    set = ifelse(title == "Rescue Squad", 4, set)
  )

treemap::treemap(lastshow, 
                 index="title",
                 vSize="duration",
                 vColor = "set",
                 type="categorical",
                 palette = c("#E1DDDC", "#EAB936", "#0f478c", "#EE4133"),
                 title = "",
                 border.lwds = 4,
                 #fontsize.labels = 0,
                 algorithm = "pivotSize")