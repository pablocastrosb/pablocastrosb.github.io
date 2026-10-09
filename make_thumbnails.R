# Creates a small thumbnail.jpg in each infographic folder that doesn't have one yet.
# Run it after adding a new infographic: source("make_thumbnails.R")

library(magick)

folders <- list.dirs("infographics", recursive = FALSE)

for (d in folders) {
  thumb <- file.path(d, "thumbnail.jpg")
  if (file.exists(thumb)) next
  
  imgs <- list.files(d, pattern = "\\.(png|jpe?g)$", ignore.case = TRUE, full.names = TRUE)
  imgs <- imgs[basename(imgs) != "thumbnail.jpg"]
  if (length(imgs) == 0) next
  
  img <- image_read(imgs[1])
  img <- image_scale(img, "600")              # 600 px wide, height proportional
  img <- image_background(img, "white")       # flattens transparent backgrounds
  image_write(img, thumb, format = "jpeg", quality = 80)
  
  message("Created ", thumb)
}