Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33412 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2CCP2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:28:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 03/10] mt9m032: Make get/set format/crop operations consistent across drivers
Date: Sat,  3 Mar 2012 16:28:08 +0100
Message-Id: <1330788495-18762-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify the get/set format/crop operation handlers to match the existing
pad-aware Aptina sensor drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |  132 +++++++++++++++++++----------------------
 1 files changed, 61 insertions(+), 71 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index b6ef69f..e09f9a5 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -150,17 +150,15 @@ static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
 }
 
 static int mt9m032_update_timing(struct mt9m032 *sensor,
-				 struct v4l2_fract *interval,
-				 const struct v4l2_rect *crop)
+				 struct v4l2_fract *interval)
 {
+	struct v4l2_rect *crop = &sensor->crop;
 	unsigned long row_time;
 	int additional_blanking_rows;
 	int min_blank;
 
 	if (!interval)
 		interval = &sensor->frame_interval;
-	if (!crop)
-		crop = &sensor->crop;
 
 	row_time = mt9m032_row_time(sensor, crop->width);
 
@@ -186,21 +184,24 @@ static int mt9m032_update_timing(struct mt9m032 *sensor,
 	return mt9m032_write_reg(sensor, MT9M032_VBLANK, additional_blanking_rows);
 }
 
-static int mt9m032_update_geom_timing(struct mt9m032 *sensor,
-				 const struct v4l2_rect *crop)
+static int mt9m032_update_geom_timing(struct mt9m032 *sensor)
 {
 	int ret;
 
-	ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_SIZE, crop->width - 1);
+	ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_SIZE,
+				sensor->crop.width - 1);
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_ROW_SIZE, crop->height - 1);
+		ret = mt9m032_write_reg(sensor, MT9M032_ROW_SIZE,
+					sensor->crop.height - 1);
 	/* offsets compensate for black border */
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_START, crop->left);
+		ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_START,
+					sensor->crop.left);
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_ROW_START, crop->top);
+		ret = mt9m032_write_reg(sensor, MT9M032_ROW_START,
+					sensor->crop.top);
 	if (!ret)
-		ret = mt9m032_update_timing(sensor, NULL, crop);
+		ret = mt9m032_update_timing(sensor, NULL);
 	return ret;
 }
 
@@ -265,8 +266,9 @@ static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
 				  struct v4l2_subdev_fh *fh,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (code->index != 0 || code->pad != 0)
+	if (code->index != 0)
 		return -EINVAL;
+
 	code->code = V4L2_MBUS_FMT_Y8_1X8;
 	return 0;
 }
@@ -275,7 +277,7 @@ static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_fh *fh,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index != 0 || fse->code != V4L2_MBUS_FMT_Y8_1X8 || fse->pad != 0)
+	if (fse->index != 0 || fse->code != V4L2_MBUS_FMT_Y8_1X8)
 		return -EINVAL;
 
 	fse->min_width = MT9M032_WIDTH;
@@ -288,14 +290,15 @@ static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
 
 /**
  * __mt9m032_get_pad_crop() - get crop rect
- * @sensor:	pointer to the sensor struct
- * @fh:	filehandle for getting the try crop rect from
- * @which:	select try or active crop rect
+ * @sensor: pointer to the sensor struct
+ * @fh: filehandle for getting the try crop rect from
+ * @which: select try or active crop rect
+ *
  * Returns a pointer the current active or fh relative try crop rect
  */
-static struct v4l2_rect *__mt9m032_get_pad_crop(struct mt9m032 *sensor,
-						struct v4l2_subdev_fh *fh,
-						u32 which)
+static struct v4l2_rect *
+__mt9m032_get_pad_crop(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
+		       enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
@@ -309,14 +312,15 @@ static struct v4l2_rect *__mt9m032_get_pad_crop(struct mt9m032 *sensor,
 
 /**
  * __mt9m032_get_pad_format() - get format
- * @sensor:	pointer to the sensor struct
- * @fh:	filehandle for getting the try format from
- * @which:	select try or active format
+ * @sensor: pointer to the sensor struct
+ * @fh: filehandle for getting the try format from
+ * @which: select try or active format
+ *
  * Returns a pointer the current active or fh relative try format
  */
-static struct v4l2_mbus_framefmt *__mt9m032_get_pad_format(struct mt9m032 *sensor,
-							   struct v4l2_subdev_fh *fh,
-							   u32 which)
+static struct v4l2_mbus_framefmt *
+__mt9m032_get_pad_format(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
+			 enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
@@ -333,12 +337,8 @@ static int mt9m032_get_pad_format(struct v4l2_subdev *subdev,
 				  struct v4l2_subdev_format *fmt)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
-	struct v4l2_mbus_framefmt *format;
-
-	format = __mt9m032_get_pad_format(sensor, fh, fmt->which);
-
-	fmt->format = *format;
 
+	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
 	return 0;
 }
 
@@ -365,11 +365,8 @@ static int mt9m032_get_crop(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *f
 			    struct v4l2_subdev_crop *crop)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
-	struct v4l2_rect *curcrop;
 
-	curcrop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
-
-	crop->rect = *curcrop;
+	crop->rect = *__mt9m032_get_pad_crop(sensor, fh, crop->which);
 
 	return 0;
 }
@@ -378,47 +375,40 @@ static int mt9m032_set_crop(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *f
 		     struct v4l2_subdev_crop *crop)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
-	struct v4l2_mbus_framefmt tmp_format;
-	struct v4l2_rect tmp_crop_rect;
 	struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect *crop_rect;
-	int ret = 0;
+	struct v4l2_rect *__crop;
+	struct v4l2_rect rect;
 
 	if (sensor->streaming)
 		return -EBUSY;
 
-	format = __mt9m032_get_pad_format(sensor, fh, crop->which);
-	crop_rect = __mt9m032_get_pad_crop(sensor, fh, crop->which);
-	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		tmp_crop_rect = *crop_rect;
-		tmp_format = *format;
-		format = &tmp_format;
-		crop_rect = &tmp_crop_rect;
+	rect.top = clamp(crop->rect.top, 0,
+			 MT9M032_HEIGHT - MT9M032_MINIMALSIZE) & ~1;
+	rect.left = clamp(crop->rect.left, 0,
+			  MT9M032_WIDTH - MT9M032_MINIMALSIZE);
+	rect.height = clamp(crop->rect.height, MT9M032_MINIMALSIZE,
+			    MT9M032_HEIGHT - rect.top);
+	rect.width = clamp(crop->rect.width, MT9M032_MINIMALSIZE,
+			   MT9M032_WIDTH - rect.left) & ~1;
+
+	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
+
+	if (rect.width != __crop->width || rect.height != __crop->height) {
+		/* Reset the output image size if the crop rectangle size has
+		 * been modified.
+		 */
+		format = __mt9m032_get_pad_format(sensor, fh, crop->which);
+		format->width = rect.width;
+		format->height = rect.height;
 	}
 
-	crop_rect->top = clamp(crop->rect.top, 0,
-			       MT9M032_HEIGHT - MT9M032_MINIMALSIZE) & ~1;
-	crop_rect->left = clamp(crop->rect.left, 0,
-			       MT9M032_WIDTH - MT9M032_MINIMALSIZE);
-	crop_rect->height = clamp(crop->rect.height, MT9M032_MINIMALSIZE,
-				  MT9M032_HEIGHT - crop_rect->top);
-	crop_rect->width = clamp(crop->rect.width, MT9M032_MINIMALSIZE,
-				 MT9M032_WIDTH - crop_rect->left) & ~1;
-
-	format->height = crop_rect->height;
-	format->width = crop_rect->width;
-
-	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		ret = mt9m032_update_geom_timing(sensor, crop_rect);
-
-		if (!ret) {
-			sensor->crop = tmp_crop_rect;
-			sensor->format = tmp_format;
-		}
-		return ret;
-	}
+	*__crop = rect;
+	crop->rect = rect;
 
-	return ret;
+	if (crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return 0;
+
+	return mt9m032_update_geom_timing(sensor);
 }
 
 static int mt9m032_get_frame_interval(struct v4l2_subdev *subdev,
@@ -426,8 +416,7 @@ static int mt9m032_get_frame_interval(struct v4l2_subdev *subdev,
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
 
-	fi->pad = 0;
-	memset(fi->reserved, 0, sizeof(fi->reserved));
+	memset(fi, 0, sizeof(*fi));
 	fi->interval = sensor->frame_interval;
 
 	return 0;
@@ -444,9 +433,10 @@ static int mt9m032_set_frame_interval(struct v4l2_subdev *subdev,
 
 	memset(fi->reserved, 0, sizeof(fi->reserved));
 
-	ret = mt9m032_update_timing(sensor, &fi->interval, NULL);
+	ret = mt9m032_update_timing(sensor, &fi->interval);
 	if (!ret)
 		sensor->frame_interval = fi->interval;
+
 	return ret;
 }
 
@@ -742,7 +732,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	v4l2_ctrl_handler_setup(&sensor->ctrls);
 
 	/* SIZE */
-	ret = mt9m032_update_geom_timing(sensor, &sensor->crop);
+	ret = mt9m032_update_geom_timing(sensor);
 	if (ret < 0)
 		goto free_ctrl;
 
-- 
1.7.3.4

