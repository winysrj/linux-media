Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:32963 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbaLDJza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 04:55:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 1/8] v4l2 subdevs: replace get/set_crop by get/set_selection
Date: Thu,  4 Dec 2014 10:54:52 +0100
Message-Id: <1417686899-30149-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The crop and selection pad ops are duplicates. Replace all uses of get/set_crop
by get/set_selection. This will make it possible to drop get/set_crop
altogether.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/mt9m032.c                     | 42 ++++++++-------
 drivers/media/i2c/mt9p031.c                     | 41 ++++++++-------
 drivers/media/i2c/mt9t001.c                     | 41 ++++++++-------
 drivers/media/i2c/mt9v032.c                     | 43 ++++++++-------
 drivers/media/i2c/s5k6aa.c                      | 44 +++++++++-------
 drivers/staging/media/davinci_vpfe/dm365_isif.c | 69 +++++++++++++------------
 6 files changed, 156 insertions(+), 124 deletions(-)

diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 45b3fca..7643122 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -422,22 +422,25 @@ done:
 	return ret;
 }
 
-static int mt9m032_get_pad_crop(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_fh *fh,
-				struct v4l2_subdev_crop *crop)
+static int mt9m032_get_pad_selection(struct v4l2_subdev *subdev,
+				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_selection *sel)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
 
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	mutex_lock(&sensor->lock);
-	crop->rect = *__mt9m032_get_pad_crop(sensor, fh, crop->which);
+	sel->r = *__mt9m032_get_pad_crop(sensor, fh, sel->which);
 	mutex_unlock(&sensor->lock);
 
 	return 0;
 }
 
-static int mt9m032_set_pad_crop(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_fh *fh,
-				struct v4l2_subdev_crop *crop)
+static int mt9m032_set_pad_selection(struct v4l2_subdev *subdev,
+				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_selection *sel)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
 	struct v4l2_mbus_framefmt *format;
@@ -445,9 +448,12 @@ static int mt9m032_set_pad_crop(struct v4l2_subdev *subdev,
 	struct v4l2_rect rect;
 	int ret = 0;
 
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	mutex_lock(&sensor->lock);
 
-	if (sensor->streaming && crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+	if (sensor->streaming && sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -455,13 +461,13 @@ static int mt9m032_set_pad_crop(struct v4l2_subdev *subdev,
 	/* Clamp the crop rectangle boundaries and align them to a multiple of 2
 	 * pixels to ensure a GRBG Bayer pattern.
 	 */
-	rect.left = clamp(ALIGN(crop->rect.left, 2), MT9M032_COLUMN_START_MIN,
+	rect.left = clamp(ALIGN(sel->r.left, 2), MT9M032_COLUMN_START_MIN,
 			  MT9M032_COLUMN_START_MAX);
-	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9M032_ROW_START_MIN,
+	rect.top = clamp(ALIGN(sel->r.top, 2), MT9M032_ROW_START_MIN,
 			 MT9M032_ROW_START_MAX);
-	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+	rect.width = clamp_t(unsigned int, ALIGN(sel->r.width, 2),
 			     MT9M032_COLUMN_SIZE_MIN, MT9M032_COLUMN_SIZE_MAX);
-	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+	rect.height = clamp_t(unsigned int, ALIGN(sel->r.height, 2),
 			      MT9M032_ROW_SIZE_MIN, MT9M032_ROW_SIZE_MAX);
 
 	rect.width = min_t(unsigned int, rect.width,
@@ -469,21 +475,21 @@ static int mt9m032_set_pad_crop(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int, rect.height,
 			    MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
+	__crop = __mt9m032_get_pad_crop(sensor, fh, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		format = __mt9m032_get_pad_format(sensor, fh, crop->which);
+		format = __mt9m032_get_pad_format(sensor, fh, sel->which);
 		format->width = rect.width;
 		format->height = rect.height;
 	}
 
 	*__crop = rect;
-	crop->rect = rect;
+	sel->r = rect;
 
-	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		ret = mt9m032_update_geom_timing(sensor);
 
 done:
@@ -690,8 +696,8 @@ static const struct v4l2_subdev_pad_ops mt9m032_pad_ops = {
 	.enum_frame_size = mt9m032_enum_frame_size,
 	.get_fmt = mt9m032_get_pad_format,
 	.set_fmt = mt9m032_set_pad_format,
-	.set_crop = mt9m032_set_pad_crop,
-	.get_crop = mt9m032_get_pad_crop,
+	.set_selection = mt9m032_set_pad_selection,
+	.get_selection = mt9m032_get_pad_selection,
 };
 
 static const struct v4l2_subdev_ops mt9m032_ops = {
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index edb76bd..e3acae9 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -581,37 +581,42 @@ static int mt9p031_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int mt9p031_get_crop(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int mt9p031_get_selection(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
 
-	crop->rect = *__mt9p031_get_pad_crop(mt9p031, fh, crop->pad,
-					     crop->which);
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	sel->r = *__mt9p031_get_pad_crop(mt9p031, fh, sel->pad, sel->which);
 	return 0;
 }
 
-static int mt9p031_set_crop(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int mt9p031_set_selection(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
 	struct v4l2_mbus_framefmt *__format;
 	struct v4l2_rect *__crop;
 	struct v4l2_rect rect;
 
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	/* Clamp the crop rectangle boundaries and align them to a multiple of 2
 	 * pixels to ensure a GRBG Bayer pattern.
 	 */
-	rect.left = clamp(ALIGN(crop->rect.left, 2), MT9P031_COLUMN_START_MIN,
+	rect.left = clamp(ALIGN(sel->r.left, 2), MT9P031_COLUMN_START_MIN,
 			  MT9P031_COLUMN_START_MAX);
-	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9P031_ROW_START_MIN,
+	rect.top = clamp(ALIGN(sel->r.top, 2), MT9P031_ROW_START_MIN,
 			 MT9P031_ROW_START_MAX);
-	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+	rect.width = clamp_t(unsigned int, ALIGN(sel->r.width, 2),
 			     MT9P031_WINDOW_WIDTH_MIN,
 			     MT9P031_WINDOW_WIDTH_MAX);
-	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+	rect.height = clamp_t(unsigned int, ALIGN(sel->r.height, 2),
 			      MT9P031_WINDOW_HEIGHT_MIN,
 			      MT9P031_WINDOW_HEIGHT_MAX);
 
@@ -620,20 +625,20 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int, rect.height,
 			    MT9P031_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9p031_get_pad_crop(mt9p031, fh, crop->pad, crop->which);
+	__crop = __mt9p031_get_pad_crop(mt9p031, fh, sel->pad, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		__format = __mt9p031_get_pad_format(mt9p031, fh, crop->pad,
-						    crop->which);
+		__format = __mt9p031_get_pad_format(mt9p031, fh, sel->pad,
+						    sel->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
 	}
 
 	*__crop = rect;
-	crop->rect = rect;
+	sel->r = rect;
 
 	return 0;
 }
@@ -980,8 +985,8 @@ static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
 	.enum_frame_size = mt9p031_enum_frame_size,
 	.get_fmt = mt9p031_get_format,
 	.set_fmt = mt9p031_set_format,
-	.get_crop = mt9p031_get_crop,
-	.set_crop = mt9p031_set_crop,
+	.get_selection = mt9p031_get_selection,
+	.set_selection = mt9p031_set_selection,
 };
 
 static struct v4l2_subdev_ops mt9p031_subdev_ops = {
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index d9e9889..f6ca636 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -401,39 +401,44 @@ static int mt9t001_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int mt9t001_get_crop(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int mt9t001_get_selection(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
 
-	crop->rect = *__mt9t001_get_pad_crop(mt9t001, fh, crop->pad,
-					     crop->which);
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	sel->r = *__mt9t001_get_pad_crop(mt9t001, fh, sel->pad, sel->which);
 	return 0;
 }
 
-static int mt9t001_set_crop(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int mt9t001_set_selection(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
 	struct v4l2_mbus_framefmt *__format;
 	struct v4l2_rect *__crop;
 	struct v4l2_rect rect;
 
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	/* Clamp the crop rectangle boundaries and align them to a multiple of 2
 	 * pixels.
 	 */
-	rect.left = clamp(ALIGN(crop->rect.left, 2),
+	rect.left = clamp(ALIGN(sel->r.left, 2),
 			  MT9T001_COLUMN_START_MIN,
 			  MT9T001_COLUMN_START_MAX);
-	rect.top = clamp(ALIGN(crop->rect.top, 2),
+	rect.top = clamp(ALIGN(sel->r.top, 2),
 			 MT9T001_ROW_START_MIN,
 			 MT9T001_ROW_START_MAX);
-	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+	rect.width = clamp_t(unsigned int, ALIGN(sel->r.width, 2),
 			     MT9T001_WINDOW_WIDTH_MIN + 1,
 			     MT9T001_WINDOW_WIDTH_MAX + 1);
-	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+	rect.height = clamp_t(unsigned int, ALIGN(sel->r.height, 2),
 			      MT9T001_WINDOW_HEIGHT_MIN + 1,
 			      MT9T001_WINDOW_HEIGHT_MAX + 1);
 
@@ -442,20 +447,20 @@ static int mt9t001_set_crop(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int, rect.height,
 			    MT9T001_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9t001_get_pad_crop(mt9t001, fh, crop->pad, crop->which);
+	__crop = __mt9t001_get_pad_crop(mt9t001, fh, sel->pad, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		__format = __mt9t001_get_pad_format(mt9t001, fh, crop->pad,
-						    crop->which);
+		__format = __mt9t001_get_pad_format(mt9t001, fh, sel->pad,
+						    sel->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
 	}
 
 	*__crop = rect;
-	crop->rect = rect;
+	sel->r = rect;
 
 	return 0;
 }
@@ -819,8 +824,8 @@ static struct v4l2_subdev_pad_ops mt9t001_subdev_pad_ops = {
 	.enum_frame_size = mt9t001_enum_frame_size,
 	.get_fmt = mt9t001_get_format,
 	.set_fmt = mt9t001_set_format,
-	.get_crop = mt9t001_get_crop,
-	.set_crop = mt9t001_set_crop,
+	.get_selection = mt9t001_get_selection,
+	.set_selection = mt9t001_set_selection,
 };
 
 static struct v4l2_subdev_ops mt9t001_subdev_ops = {
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 93687c1..bd3f979 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -552,39 +552,44 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int mt9v032_get_crop(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int mt9v032_get_selection(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
 
-	crop->rect = *__mt9v032_get_pad_crop(mt9v032, fh, crop->pad,
-					     crop->which);
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	sel->r = *__mt9v032_get_pad_crop(mt9v032, fh, sel->pad, sel->which);
 	return 0;
 }
 
-static int mt9v032_set_crop(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
-			    struct v4l2_subdev_crop *crop)
+static int mt9v032_set_selection(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
 	struct v4l2_mbus_framefmt *__format;
 	struct v4l2_rect *__crop;
 	struct v4l2_rect rect;
 
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	/* Clamp the crop rectangle boundaries and align them to a non multiple
 	 * of 2 pixels to ensure a GRBG Bayer pattern.
 	 */
-	rect.left = clamp(ALIGN(crop->rect.left + 1, 2) - 1,
+	rect.left = clamp(ALIGN(sel->r.left + 1, 2) - 1,
 			  MT9V032_COLUMN_START_MIN,
 			  MT9V032_COLUMN_START_MAX);
-	rect.top = clamp(ALIGN(crop->rect.top + 1, 2) - 1,
+	rect.top = clamp(ALIGN(sel->r.top + 1, 2) - 1,
 			 MT9V032_ROW_START_MIN,
 			 MT9V032_ROW_START_MAX);
-	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+	rect.width = clamp_t(unsigned int, ALIGN(sel->r.width, 2),
 			     MT9V032_WINDOW_WIDTH_MIN,
 			     MT9V032_WINDOW_WIDTH_MAX);
-	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+	rect.height = clamp_t(unsigned int, ALIGN(sel->r.height, 2),
 			      MT9V032_WINDOW_HEIGHT_MIN,
 			      MT9V032_WINDOW_HEIGHT_MAX);
 
@@ -593,17 +598,17 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int,
 			    rect.height, MT9V032_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9v032_get_pad_crop(mt9v032, fh, crop->pad, crop->which);
+	__crop = __mt9v032_get_pad_crop(mt9v032, fh, sel->pad, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		__format = __mt9v032_get_pad_format(mt9v032, fh, crop->pad,
-						    crop->which);
+		__format = __mt9v032_get_pad_format(mt9v032, fh, sel->pad,
+						    sel->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
-		if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 			mt9v032->hratio = 1;
 			mt9v032->vratio = 1;
 			mt9v032_configure_pixel_rate(mt9v032);
@@ -611,7 +616,7 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
 	}
 
 	*__crop = rect;
-	crop->rect = rect;
+	sel->r = rect;
 
 	return 0;
 }
@@ -844,8 +849,8 @@ static struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
 	.enum_frame_size = mt9v032_enum_frame_size,
 	.get_fmt = mt9v032_get_format,
 	.set_fmt = mt9v032_set_format,
-	.get_crop = mt9v032_get_crop,
-	.set_crop = mt9v032_set_crop,
+	.get_selection = mt9v032_get_selection,
+	.set_selection = mt9v032_set_selection,
 };
 
 static struct v4l2_subdev_ops mt9v032_subdev_ops = {
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 2851581..19edafb 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1161,17 +1161,21 @@ static int s5k6aa_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return ret;
 }
 
-static int s5k6aa_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			   struct v4l2_subdev_crop *crop)
+static int s5k6aa_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
 	struct v4l2_rect *rect;
 
-	memset(crop->reserved, 0, sizeof(crop->reserved));
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	memset(sel->reserved, 0, sizeof(sel->reserved));
 
 	mutex_lock(&s5k6aa->lock);
-	rect = __s5k6aa_get_crop_rect(s5k6aa, fh, crop->which);
-	crop->rect = *rect;
+	rect = __s5k6aa_get_crop_rect(s5k6aa, fh, sel->which);
+	sel->r = *rect;
 	mutex_unlock(&s5k6aa->lock);
 
 	v4l2_dbg(1, debug, sd, "Current crop rectangle: (%d,%d)/%dx%d\n",
@@ -1180,35 +1184,39 @@ static int s5k6aa_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			   struct v4l2_subdev_crop *crop)
+static int s5k6aa_set_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
 	struct v4l2_mbus_framefmt *mf;
 	unsigned int max_x, max_y;
 	struct v4l2_rect *crop_r;
 
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
 	mutex_lock(&s5k6aa->lock);
-	crop_r = __s5k6aa_get_crop_rect(s5k6aa, fh, crop->which);
+	crop_r = __s5k6aa_get_crop_rect(s5k6aa, fh, sel->which);
 
-	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		mf = &s5k6aa->preset->mbus_fmt;
 		s5k6aa->apply_crop = 1;
 	} else {
 		mf = v4l2_subdev_get_try_format(fh, 0);
 	}
-	v4l_bound_align_image(&crop->rect.width, mf->width,
+	v4l_bound_align_image(&sel->r.width, mf->width,
 			      S5K6AA_WIN_WIDTH_MAX, 1,
-			      &crop->rect.height, mf->height,
+			      &sel->r.height, mf->height,
 			      S5K6AA_WIN_HEIGHT_MAX, 1, 0);
 
-	max_x = (S5K6AA_WIN_WIDTH_MAX - crop->rect.width) & ~1;
-	max_y = (S5K6AA_WIN_HEIGHT_MAX - crop->rect.height) & ~1;
+	max_x = (S5K6AA_WIN_WIDTH_MAX - sel->r.width) & ~1;
+	max_y = (S5K6AA_WIN_HEIGHT_MAX - sel->r.height) & ~1;
 
-	crop->rect.left = clamp_t(unsigned int, crop->rect.left, 0, max_x);
-	crop->rect.top  = clamp_t(unsigned int, crop->rect.top, 0, max_y);
+	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, max_x);
+	sel->r.top  = clamp_t(unsigned int, sel->r.top, 0, max_y);
 
-	*crop_r = crop->rect;
+	*crop_r = sel->r;
 
 	mutex_unlock(&s5k6aa->lock);
 
@@ -1224,8 +1232,8 @@ static const struct v4l2_subdev_pad_ops s5k6aa_pad_ops = {
 	.enum_frame_interval	= s5k6aa_enum_frame_interval,
 	.get_fmt		= s5k6aa_get_fmt,
 	.set_fmt		= s5k6aa_set_fmt,
-	.get_crop		= s5k6aa_get_crop,
-	.set_crop		= s5k6aa_set_crop,
+	.get_selection		= s5k6aa_get_selection,
+	.set_selection		= s5k6aa_set_selection,
 };
 
 static const struct v4l2_subdev_video_ops s5k6aa_video_ops = {
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index fa26f63..6010e72f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1535,7 +1535,7 @@ isif_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 }
 
 /*
- * isif_pad_set_crop() - set crop rectangle on pad
+ * isif_pad_set_selection() - set crop rectangle on pad
  * @sd: VPFE isif V4L2 subdevice
  * @fh: V4L2 subdev file handle
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
@@ -1543,35 +1543,36 @@ isif_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
  * Return 0 on success, -EINVAL if pad is invalid
  */
 static int
-isif_pad_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-		  struct v4l2_subdev_crop *crop)
+isif_pad_set_selection(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_selection *sel)
 {
 	struct vpfe_isif_device *vpfe_isif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	/* check wether its a valid pad */
-	if (crop->pad != ISIF_PAD_SINK)
+	/* check whether it's a valid pad and target */
+	if (sel->pad != ISIF_PAD_SINK || sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	format = __isif_get_format(vpfe_isif, fh, crop->pad, crop->which);
+	format = __isif_get_format(vpfe_isif, fh, sel->pad, sel->which);
 	if (format == NULL)
 		return -EINVAL;
 
 	/* check wether crop rect is within limits */
-	if (crop->rect.top < 0 || crop->rect.left < 0 ||
-		(crop->rect.left + crop->rect.width >
+	if (sel->r.top < 0 || sel->r.left < 0 ||
+		(sel->r.left + sel->r.width >
 		vpfe_isif->formats[ISIF_PAD_SINK].width) ||
-		(crop->rect.top + crop->rect.height >
+		(sel->r.top + sel->r.height >
 			vpfe_isif->formats[ISIF_PAD_SINK].height)) {
-		crop->rect.left = 0;
-		crop->rect.top = 0;
-		crop->rect.width = format->width;
-		crop->rect.height = format->height;
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = format->width;
+		sel->r.height = format->height;
 	}
 	/* adjust the width to 16 pixel boundary */
-	crop->rect.width = ((crop->rect.width + 15) & ~0xf);
-	vpfe_isif->crop = crop->rect;
-	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+	sel->r.width = ((sel->r.width + 15) & ~0xf);
+	vpfe_isif->crop = sel->r;
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		isif_set_image_window(vpfe_isif);
 	} else {
 		struct v4l2_rect *rect;
@@ -1583,7 +1584,7 @@ isif_pad_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 }
 
 /*
- * isif_pad_get_crop() - get crop rectangle on pad
+ * isif_pad_get_selection() - get crop rectangle on pad
  * @sd: VPFE isif V4L2 subdevice
  * @fh: V4L2 subdev file handle
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
@@ -1591,21 +1592,22 @@ isif_pad_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
  * Return 0 on success, -EINVAL if pad is invalid
  */
 static int
-isif_pad_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-		  struct v4l2_subdev_crop *crop)
+isif_pad_get_selection(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_selection *sel)
 {
 	struct vpfe_isif_device *vpfe_isif = v4l2_get_subdevdata(sd);
 
-	/* check wether its a valid pad */
-	if (crop->pad != ISIF_PAD_SINK)
+	/* check whether it's a valid pad and target */
+	if (sel->pad != ISIF_PAD_SINK || sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_rect *rect;
 		rect = v4l2_subdev_get_try_crop(fh, ISIF_PAD_SINK);
-		memcpy(&crop->rect, rect, sizeof(*rect));
+		memcpy(&sel->r, rect, sizeof(*rect));
 	} else {
-		crop->rect = vpfe_isif->crop;
+		sel->r = vpfe_isif->crop;
 	}
 
 	return 0;
@@ -1625,7 +1627,7 @@ isif_init_formats(struct v4l2_subdev *sd,
 		  struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_subdev_format format;
-	struct v4l2_subdev_crop crop;
+	struct v4l2_subdev_selection sel;
 
 	memset(&format, 0, sizeof(format));
 	format.pad = ISIF_PAD_SINK;
@@ -1643,12 +1645,13 @@ isif_init_formats(struct v4l2_subdev *sd,
 	format.format.height = MAX_HEIGHT;
 	isif_set_format(sd, fh, &format);
 
-	memset(&crop, 0, sizeof(crop));
-	crop.pad = ISIF_PAD_SINK;
-	crop.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	crop.rect.width = MAX_WIDTH;
-	crop.rect.height = MAX_HEIGHT;
-	isif_pad_set_crop(sd, fh, &crop);
+	memset(&sel, 0, sizeof(sel));
+	sel.pad = ISIF_PAD_SINK;
+	sel.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	sel.target = V4L2_SEL_TGT_CROP;
+	sel.r.width = MAX_WIDTH;
+	sel.r.height = MAX_HEIGHT;
+	isif_pad_set_selection(sd, fh, &sel);
 
 	return 0;
 }
@@ -1674,8 +1677,8 @@ static const struct v4l2_subdev_pad_ops isif_v4l2_pad_ops = {
 	.enum_frame_size = isif_enum_frame_size,
 	.get_fmt = isif_get_format,
 	.set_fmt = isif_set_format,
-	.set_crop = isif_pad_set_crop,
-	.get_crop = isif_pad_get_crop,
+	.set_selection = isif_pad_set_selection,
+	.get_selection = isif_pad_get_selection,
 };
 
 /* subdev operations */
-- 
2.1.3

