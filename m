Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32911 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab1JRVOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 17:14:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] omap3isp: preview: Add crop support on the sink pad
Date: Tue, 18 Oct 2011 23:14:57 +0200
Message-Id: <1318972497-8367-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The crop rectangle takes the preview engine internal cropping
requirements into account. The smallest allowable margins are 14 columns
and 8 rows when reading from memory, and 18 columns and 8 rows when
processing data on the fly from the CCDC.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  262 +++++++++++++++++++++-------
 drivers/media/video/omap3isp/isppreview.h |    2 +
 2 files changed, 198 insertions(+), 66 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index d5cce42..ccb876f 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -76,6 +76,42 @@ static struct omap3isp_prev_csc flr_prev_csc = {
 
 #define DEF_DETECT_CORRECT_VAL	0xe
 
+/*
+ * Margins and image size limits.
+ *
+ * The preview engine crops several rows and columns internally depending on
+ * which filters are enabled. To avoid format changes when the filters are
+ * enabled or disabled (which would prevent them from being turned on or off
+ * during streaming), the driver assumes all the filters are enabled when
+ * computing sink crop and source format limits.
+ *
+ * If a filter is disabled, additional cropping is automatically added at the
+ * preview engine input by the driver to avoid overflow at line and frame end.
+ * This is completely transparent for applications.
+ *
+ * Median filter		4 pixels
+ * Noise filter,
+ * Faulty pixels correction	4 pixels, 4 lines
+ * CFA filter			4 pixels, 4 lines in Bayer mode
+ *					  2 lines in other modes
+ * Color suppression		2 pixels
+ * or luma enhancement
+ * -------------------------------------------------------------
+ * Maximum total		14 pixels, 8 lines
+ *
+ * The color suppression and luma enhancement filters are applied after bayer to
+ * YUV conversion. They thus can crop one pixel on the left and one pixel on the
+ * right side of the image without changing the color pattern. When both those
+ * filters are disabled, the driver must crop the two pixels on the same side of
+ * the image to avoid changing the bayer pattern. The left margin is thus set to
+ * 8 pixels and the right margin to 6 pixels.
+ */
+
+#define PREV_MARGIN_LEFT	8
+#define PREV_MARGIN_RIGHT	6
+#define PREV_MARGIN_TOP		4
+#define PREV_MARGIN_BOTTOM	4
+
 #define PREV_MIN_IN_WIDTH	64
 #define PREV_MIN_IN_HEIGHT	8
 #define PREV_MAX_IN_HEIGHT	16384
@@ -985,52 +1021,36 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
  * enabled when reporting source pad formats to userspace. If this assumption is
  * not true, rows and columns must be manually cropped at the preview engine
  * input to avoid overflows at the end of lines and frames.
+ *
+ * See the explanation at the PREV_MARGIN_* definitions for more details.
  */
 static void preview_config_input_size(struct isp_prev_device *prev)
 {
 	struct isp_device *isp = to_isp_device(prev);
 	struct prev_params *params = &prev->params;
-	struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
-	unsigned int sph = 0;
-	unsigned int eph = format->width - 1;
-	unsigned int slv = 0;
-	unsigned int elv = format->height - 1;
-
-	if (prev->input == PREVIEW_INPUT_CCDC) {
-		sph += 2;
-		eph -= 2;
-	}
-
-	/*
-	 * Median filter	4 pixels
-	 * Noise filter		4 pixels, 4 lines
-	 * or faulty pixels correction
-	 * CFA filter		4 pixels, 4 lines in Bayer mode
-	 *				  2 lines in other modes
-	 * Color suppression	2 pixels
-	 * or luma enhancement
-	 * -------------------------------------------------------------
-	 * Maximum total	14 pixels, 8 lines
-	 */
-
-	if (!(params->features & PREV_CFA)) {
-		sph += 2;
-		eph -= 2;
-		slv += 2;
-		elv -= 2;
+	unsigned int sph = prev->crop.left;
+	unsigned int eph = prev->crop.left + prev->crop.width - 1;
+	unsigned int slv = prev->crop.top;
+	unsigned int elv = prev->crop.top + prev->crop.height - 1;
+
+	if (params->features & PREV_CFA) {
+		sph -= 2;
+		eph += 2;
+		slv -= 2;
+		elv += 2;
 	}
-	if (!(params->features & (PREV_DEFECT_COR | PREV_NOISE_FILTER))) {
-		sph += 2;
-		eph -= 2;
-		slv += 2;
-		elv -= 2;
+	if (params->features & (PREV_DEFECT_COR | PREV_NOISE_FILTER)) {
+		sph -= 2;
+		eph += 2;
+		slv -= 2;
+		elv += 2;
 	}
-	if (!(params->features & PREV_HORZ_MEDIAN_FILTER)) {
-		sph += 2;
-		eph -= 2;
+	if (params->features & PREV_HORZ_MEDIAN_FILTER) {
+		sph -= 2;
+		eph += 2;
 	}
-	if (!(params->features & (PREV_CHROMA_SUPPRESS | PREV_LUMA_ENHANCE)))
-		sph += 2;
+	if (params->features & (PREV_CHROMA_SUPPRESS | PREV_LUMA_ENHANCE))
+		sph -= 2;
 
 	isp_reg_writel(isp, (sph << ISPPRV_HORZ_INFO_SPH_SHIFT) | eph,
 		       OMAP3_ISP_IOMEM_PREV, ISPPRV_HORZ_INFO);
@@ -1597,6 +1617,16 @@ __preview_get_format(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
 		return &prev->formats[pad];
 }
 
+static struct v4l2_rect *
+__preview_get_crop(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
+		   enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(fh, PREV_PAD_SINK);
+	else
+		return &prev->crop;
+}
+
 /* previewer format descriptions */
 static const unsigned int preview_input_fmts[] = {
 	V4L2_MBUS_FMT_SGRBG10_1X10,
@@ -1611,19 +1641,23 @@ static const unsigned int preview_output_fmts[] = {
 };
 
 /*
- * preview_try_format - Handle try format by pad subdev method
- * @prev: ISP preview device
- * @fh : V4L2 subdev file handle
- * @pad: pad num
- * @fmt: pointer to v4l2 format structure
+ * preview_try_format - Validate a format
+ * @prev: ISP preview engine
+ * @fh: V4L2 subdev file handle
+ * @pad: pad number
+ * @fmt: format to be validated
+ * @which: try/active format selector
+ *
+ * Validate and adjust the given format for the given pad based on the preview
+ * engine limits and the format and crop rectangles on other pads.
  */
 static void preview_try_format(struct isp_prev_device *prev,
 			       struct v4l2_subdev_fh *fh, unsigned int pad,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
-	struct v4l2_mbus_framefmt *format;
 	enum v4l2_mbus_pixelcode pixelcode;
+	struct v4l2_rect *crop;
 	unsigned int i;
 
 	switch (pad) {
@@ -1659,15 +1693,8 @@ static void preview_try_format(struct isp_prev_device *prev,
 
 	case PREV_PAD_SOURCE:
 		pixelcode = fmt->code;
-		format = __preview_get_format(prev, fh, PREV_PAD_SINK, which);
-		memcpy(fmt, format, sizeof(*fmt));
+		*fmt = *__preview_get_format(prev, fh, PREV_PAD_SINK, which);
 
-		/* The preview module output size is configurable through the
-		 * input interface (horizontal and vertical cropping) and the
-		 * averager (horizontal scaling by 1/1, 1/2, 1/4 or 1/8). In
-		 * spite of this, hardcode the output size to the biggest
-		 * possible value for simplicity reasons.
-		 */
 		switch (pixelcode) {
 		case V4L2_MBUS_FMT_YUYV8_1X16:
 		case V4L2_MBUS_FMT_UYVY8_1X16:
@@ -1679,20 +1706,14 @@ static void preview_try_format(struct isp_prev_device *prev,
 			break;
 		}
 
-		/* The TRM states (12.1.4.7.1.2) that 2 pixels must be cropped
-		 * from the left and right sides when the input source is the
-		 * CCDC. This seems not to be needed in practice, investigation
-		 * is required.
-		 */
-		if (prev->input == PREVIEW_INPUT_CCDC)
-			fmt->width -= 4;
-
-		/* Assume that all blocks are enabled and crop pixels and lines
-		 * accordingly. See preview_config_input_size() for more
-		 * information.
+		/* The preview module output size is configurable through the
+		 * averager (horizontal scaling by 1/1, 1/2, 1/4 or 1/8). This
+		 * is not supported yet, hardcode the output size to the crop
+		 * rectangle size.
 		 */
-		fmt->width -= 14;
-		fmt->height -= 8;
+		crop = __preview_get_crop(prev, fh, which);
+		fmt->width = crop->width;
+		fmt->height = crop->height;
 
 		fmt->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
@@ -1702,6 +1723,49 @@ static void preview_try_format(struct isp_prev_device *prev,
 }
 
 /*
+ * preview_try_crop - Validate a crop rectangle
+ * @prev: ISP preview engine
+ * @sink: format on the sink pad
+ * @crop: crop rectangle to be validated
+ *
+ * The preview engine crops lines and columns for its internal operation,
+ * depending on which filters are enabled. Enforce minimum crop margins to
+ * handle that transparently for userspace.
+ *
+ * See the explanation at the PREV_MARGIN_* definitions for more details.
+ */
+static void preview_try_crop(struct isp_prev_device *prev,
+			     const struct v4l2_mbus_framefmt *sink,
+			     struct v4l2_rect *crop)
+{
+	unsigned int left = PREV_MARGIN_LEFT;
+	unsigned int right = sink->width - PREV_MARGIN_RIGHT;
+	unsigned int top = PREV_MARGIN_TOP;
+	unsigned int bottom = sink->height - PREV_MARGIN_BOTTOM;
+
+	/* When processing data on-the-fly from the CCDC, at least 2 pixels must
+	 * be cropped from the left and right sides of the image. As we don't
+	 * know which filters will be enabled, increase the left and right
+	 * margins by two.
+	 */
+	if (prev->input == PREVIEW_INPUT_CCDC) {
+		left += 2;
+		right -= 2;
+	}
+
+	/* Restrict left/top to even values to keep the Bayer pattern. */
+	crop->left &= ~1;
+	crop->top &= ~1;
+
+	crop->left = clamp_t(u32, crop->left, left, right - PREV_MIN_OUT_WIDTH);
+	crop->top = clamp_t(u32, crop->top, top, bottom - PREV_MIN_OUT_HEIGHT);
+	crop->width = clamp_t(u32, crop->width, PREV_MIN_OUT_WIDTH,
+			      right - crop->left);
+	crop->height = clamp_t(u32, crop->height, PREV_MIN_OUT_HEIGHT,
+			       bottom - crop->top);
+}
+
+/*
  * preview_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
  * @fh     : V4L2 subdev file handle
@@ -1763,6 +1827,60 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 /*
+ * preview_get_crop - Retrieve the crop rectangle on a pad
+ * @sd: ISP preview V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @crop: crop rectangle
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int preview_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_crop *crop)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+
+	/* Cropping is only supported on the sink pad. */
+	if (crop->pad != PREV_PAD_SINK)
+		return -EINVAL;
+
+	crop->rect = *__preview_get_crop(prev, fh, crop->which);
+	return 0;
+}
+
+/*
+ * preview_set_crop - Retrieve the crop rectangle on a pad
+ * @sd: ISP preview V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @crop: crop rectangle
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int preview_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_crop *crop)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Cropping is only supported on the sink pad. */
+	if (crop->pad != PREV_PAD_SINK)
+		return -EINVAL;
+
+	/* The crop rectangle can't be changed while streaming. */
+	if (prev->state != ISP_PIPELINE_STREAM_STOPPED)
+		return -EBUSY;
+
+	format = __preview_get_format(prev, fh, PREV_PAD_SINK, crop->which);
+	preview_try_crop(prev, format, &crop->rect);
+	*__preview_get_crop(prev, fh, crop->which) = crop->rect;
+
+	/* Update the source format. */
+	format = __preview_get_format(prev, fh, PREV_PAD_SOURCE, crop->which);
+	preview_try_format(prev, fh, PREV_PAD_SOURCE, format, crop->which);
+
+	return 0;
+}
+
+/*
  * preview_get_format - Handle get format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
  * @fh : V4L2 subdev file handle
@@ -1795,6 +1913,7 @@ static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
 
 	format = __preview_get_format(prev, fh, fmt->pad, fmt->which);
 	if (format == NULL)
@@ -1805,9 +1924,18 @@ static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == PREV_PAD_SINK) {
+		/* Reset the crop rectangle. */
+		crop = __preview_get_crop(prev, fh, fmt->which);
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = fmt->format.width;
+		crop->height = fmt->format.height;
+
+		preview_try_crop(prev, &fmt->format, crop);
+
+		/* Update the source format. */
 		format = __preview_get_format(prev, fh, PREV_PAD_SOURCE,
 					      fmt->which);
-		*format = fmt->format;
 		preview_try_format(prev, fh, PREV_PAD_SOURCE, format,
 				   fmt->which);
 	}
@@ -1856,6 +1984,8 @@ static const struct v4l2_subdev_pad_ops preview_v4l2_pad_ops = {
 	.enum_frame_size = preview_enum_frame_size,
 	.get_fmt = preview_get_format,
 	.set_fmt = preview_set_format,
+	.get_crop = preview_get_crop,
+	.set_crop = preview_set_crop,
 };
 
 /* subdev operations */
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index 272a44a..f54e775 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -152,6 +152,7 @@ struct isptables_update {
  * @subdev: V4L2 subdevice
  * @pads: Media entity pads
  * @formats: Active formats at the subdev pad
+ * @crop: Active crop rectangle
  * @input: Module currently connected to the input pad
  * @output: Bitmask of the active output
  * @video_in: Input video entity
@@ -170,6 +171,7 @@ struct isp_prev_device {
 	struct v4l2_subdev subdev;
 	struct media_pad pads[PREV_PADS_NUM];
 	struct v4l2_mbus_framefmt formats[PREV_PADS_NUM];
+	struct v4l2_rect crop;
 
 	struct v4l2_ctrl_handler ctrls;
 
-- 
1.7.3.4

