Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44756 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2D2QX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 12:23:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] omap3isp: resizer: Replace the crop API by the selection API
Date: Sun, 29 Apr 2012 18:23:45 +0200
Message-Id: <1335716625-2388-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335716625-2388-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335716625-2388-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for the legacy crop API is emulated in the subdev core.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispresizer.c |  138 ++++++++++++++++++-----------
 1 files changed, 88 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 6958a9e..d7341ab 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1188,32 +1188,6 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 /*
- * resizer_g_crop - handle get crop subdev operation
- * @sd : pointer to v4l2 subdev structure
- * @pad : subdev pad
- * @crop : pointer to crop structure
- * @which : active or try format
- * return zero
- */
-static int resizer_g_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			  struct v4l2_subdev_crop *crop)
-{
-	struct isp_res_device *res = v4l2_get_subdevdata(sd);
-	struct v4l2_mbus_framefmt *format;
-	struct resizer_ratio ratio;
-
-	/* Only sink pad has crop capability */
-	if (crop->pad != RESZ_PAD_SINK)
-		return -EINVAL;
-
-	format = __resizer_get_format(res, fh, RESZ_PAD_SOURCE, crop->which);
-	crop->rect = *__resizer_get_crop(res, fh, crop->which);
-	resizer_calc_ratios(res, &crop->rect, format, &ratio);
-
-	return 0;
-}
-
-/*
  * resizer_try_crop - mangles crop parameters.
  */
 static void resizer_try_crop(const struct v4l2_mbus_framefmt *sink,
@@ -1223,7 +1197,7 @@ static void resizer_try_crop(const struct v4l2_mbus_framefmt *sink,
 	const unsigned int spv = DEFAULT_PHASE;
 	const unsigned int sph = DEFAULT_PHASE;
 
-	/* Crop rectangle is constrained to the output size so that zoom ratio
+	/* Crop rectangle is constrained by the output size so that zoom ratio
 	 * cannot exceed +/-4.0.
 	 */
 	unsigned int min_width =
@@ -1248,51 +1222,115 @@ static void resizer_try_crop(const struct v4l2_mbus_framefmt *sink,
 }
 
 /*
- * resizer_s_crop - handle set crop subdev operation
- * @sd : pointer to v4l2 subdev structure
- * @pad : subdev pad
- * @crop : pointer to crop structure
- * @which : active or try format
- * return -EINVAL or zero when succeed
+ * resizer_get_selection - Retrieve a selection rectangle on a pad
+ * @sd: ISP resizer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @sel: Selection rectangle
+ *
+ * The only supported rectangles are the crop rectangles on the sink pad.
+ *
+ * Return 0 on success or a negative error code otherwise.
  */
-static int resizer_s_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			  struct v4l2_subdev_crop *crop)
+static int resizer_get_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format_source;
+	struct v4l2_mbus_framefmt *format_sink;
+	struct resizer_ratio ratio;
+
+	if (sel->pad != RESZ_PAD_SINK)
+		return -EINVAL;
+
+	format_sink = __resizer_get_format(res, fh, RESZ_PAD_SINK,
+					   sel->which);
+	format_source = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+					     sel->which);
+
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = INT_MAX;
+		sel->r.height = INT_MAX;
+
+		resizer_try_crop(format_sink, format_source, &sel->r);
+		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
+		break;
+
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+		sel->r = *__resizer_get_crop(res, fh, sel->which);
+		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * resizer_set_selection - Set a selection rectangle on a pad
+ * @sd: ISP resizer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @sel: Selection rectangle
+ *
+ * The only supported rectangle is the actual crop rectangle on the sink pad.
+ *
+ * FIXME: This function currently behaves as if the KEEP_CONFIG selection flag
+ * was always set.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int resizer_set_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = to_isp_device(res);
 	struct v4l2_mbus_framefmt *format_sink, *format_source;
 	struct resizer_ratio ratio;
 
-	/* Only sink pad has crop capability */
-	if (crop->pad != RESZ_PAD_SINK)
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
+	    sel->pad != RESZ_PAD_SINK)
 		return -EINVAL;
 
 	format_sink = __resizer_get_format(res, fh, RESZ_PAD_SINK,
-					   crop->which);
+					   sel->which);
 	format_source = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
-					     crop->which);
+					     sel->which);
 
 	dev_dbg(isp->dev, "%s: L=%d,T=%d,W=%d,H=%d,which=%d\n", __func__,
-		crop->rect.left, crop->rect.top, crop->rect.width,
-		crop->rect.height, crop->which);
+		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
+		sel->which);
 
 	dev_dbg(isp->dev, "%s: input=%dx%d, output=%dx%d\n", __func__,
 		format_sink->width, format_sink->height,
 		format_source->width, format_source->height);
 
-	resizer_try_crop(format_sink, format_source, &crop->rect);
-	*__resizer_get_crop(res, fh, crop->which) = crop->rect;
-	resizer_calc_ratios(res, &crop->rect, format_source, &ratio);
+	/* Clamp the crop rectangle to the bounds, and then mangle it further to
+	 * fulfill the TRM equations. Store the clamped but otherwise unmangled
+	 * rectangle to avoid cropping the input multiple times: when an
+	 * application sets the output format, the current crop rectangle is
+	 * mangled during crop rectangle computation, which would lead to a new,
+	 * smaller input crop rectangle every time the output size is set if we
+	 * stored the mangled rectangle.
+	 */
+	resizer_try_crop(format_sink, format_source, &sel->r);
+	*__resizer_get_crop(res, fh, sel->which) = sel->r;
+	resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 
-	if (crop->which == V4L2_SUBDEV_FORMAT_TRY)
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
 		return 0;
 
 	res->ratio = ratio;
-	res->crop.active = crop->rect;
+	res->crop.active = sel->r;
 
 	/*
-	 * s_crop can be called while streaming is on. In this case
-	 * the crop values will be set in the next IRQ.
+	 * set_selection can be called while streaming is on. In this case the
+	 * crop values will be set in the next IRQ.
 	 */
 	if (res->state != ISP_PIPELINE_STREAM_STOPPED)
 		res->applycrop = 1;
@@ -1530,8 +1568,8 @@ static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.enum_frame_size = resizer_enum_frame_size,
 	.get_fmt = resizer_get_format,
 	.set_fmt = resizer_set_format,
-	.get_crop = resizer_g_crop,
-	.set_crop = resizer_s_crop,
+	.get_selection = resizer_get_selection,
+	.set_selection = resizer_set_selection,
 };
 
 /* subdev operations */
-- 
1.7.3.4

