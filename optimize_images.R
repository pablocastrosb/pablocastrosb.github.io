# Shrinks large images in place. Run after adding new images:
# source("optimize_images.R")

library(magick)

files <- list.files(c("images", "infographics"),
                    pattern = "\\.(jpe?g|png)$", ignore.case = TRUE,
                    recursive = TRUE, full.names = TRUE)

for (f in files) {
  name <- tolower(basename(f))
  if (name %in% c("favicon.png", "thumbnail.jpg")) next
  
  max_w <- if (grepl("^profile", name)) {
    600                                   # profile photo
  } else if (startsWith(f, "infographics")) {
    2000                                  # full-size infographics
  } else {
    1600                                  # backgrounds, publication and outreach images
  }
  
  img <- image_read(f)
  w   <- image_info(img)$width
  if (w <= max_w) next
  
  img <- image_scale(img, as.character(max_w))
  if (grepl("\\.jpe?g$", name)) {
    image_write(img, f, quality = 80)
  } else {
    image_write(img, f)
  }
  message("Resized ", f, " (", w, " -> ", max_w, " px wide)")
}