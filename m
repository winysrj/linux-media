Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38702 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751595AbeCWNss (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 09:48:48 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: mchehab@s-opensource.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Bring back array_size parameter to v4l2_find_nearest_size
Date: Fri, 23 Mar 2018 15:48:41 +0200
Message-Id: <20180323134841.21408-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An older version of the driver patches were merged accidentally which
resulted in missing the array_size parameter that tells the length of the
array that contains the different supported sizes.

Bring it back to v4l2_find_nearest size and make the corresponding change
for the drivers using it as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Mauro,

Here's the patch I mentioned. It restores the intended state of the
v4l2_find_nearest_size() API as it was reviewed and acked (by Hans).

This time the exact patch is tested for vivid.

 drivers/media/i2c/ov13858.c                  | 5 +++--
 drivers/media/i2c/ov5670.c                   | 5 +++--
 drivers/media/platform/vivid/vivid-vid-cap.c | 5 +++--
 include/media/v4l2-common.h                  | 5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 30ee9f71bf0d..420af1e32d4e 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1375,8 +1375,9 @@ ov13858_set_pad_format(struct v4l2_subdev *sd,
 	if (fmt->format.code != MEDIA_BUS_FMT_SGRBG10_1X10)
 		fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
-	mode = v4l2_find_nearest_size(supported_modes, width, height,
-				      fmt->format.width, fmt->format.height);
+	mode = v4l2_find_nearest_size(
+		supported_modes, ARRAY_SIZE(supported_modes), width, height,
+		fmt->format.width, fmt->format.height);
 	ov13858_update_pad_format(mode, fmt);
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 556a95c30781..028abc860387 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2229,8 +2229,9 @@ static int ov5670_set_pad_format(struct v4l2_subdev *sd,
 
 	fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
-	mode = v4l2_find_nearest_size(supported_modes, width, height,
-				      fmt->format.width, fmt->format.height);
+	mode = v4l2_find_nearest_size(
+		supported_modes, ARRAY_SIZE(supported_modes), width, height,
+		fmt->format.width, fmt->format.height);
 	ov5670_update_pad_format(mode, fmt);
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 01c703683657..1599159f2574 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -561,8 +561,9 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	mp->field = vivid_field_cap(dev, mp->field);
 	if (vivid_is_webcam(dev)) {
 		const struct v4l2_frmsize_discrete *sz =
-			v4l2_find_nearest_size(webcam_sizes, width, height,
-					       mp->width, mp->height);
+			v4l2_find_nearest_size(webcam_sizes,
+					       VIVID_WEBCAM_SIZES, width,
+					       height, mp->width, mp->height);
 
 		w = sz->width;
 		h = sz->height;
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 54b689247937..160bca96d524 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -320,6 +320,7 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
  *	set of resolutions contained in an array of a driver specific struct.
  *
  * @array: a driver specific array of image sizes
+ * @array_size: the length of the driver specific array of image sizes
  * @width_field: the name of the width field in the driver specific struct
  * @height_field: the name of the height field in the driver specific struct
  * @width: desired width.
@@ -332,13 +333,13 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
  *
  * Returns the best match or NULL if the length of the array is zero.
  */
-#define v4l2_find_nearest_size(array, width_field, height_field, \
+#define v4l2_find_nearest_size(array, array_size, width_field, height_field, \
 			       width, height)				\
 	({								\
 		BUILD_BUG_ON(sizeof((array)->width_field) != sizeof(u32) || \
 			     sizeof((array)->height_field) != sizeof(u32)); \
 		(typeof(&(*(array))))__v4l2_find_nearest_size(		\
-			(array), ARRAY_SIZE(array), sizeof(*(array)),	\
+			(array), array_size, sizeof(*(array)),		\
 			offsetof(typeof(*(array)), width_field),	\
 			offsetof(typeof(*(array)), height_field),	\
 			width, height);					\
-- 
2.11.0
