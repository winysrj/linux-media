Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2DWL3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:29:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/4] omap3isp: ccdc: Add crop support on output formatter source pad
Date: Mon, 23 Apr 2012 13:29:54 +0200
Message-Id: <1335180595-27931-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c |  147 +++++++++++++++++++++++++++++---
 drivers/media/video/omap3isp/ispccdc.h |    2 +
 2 files changed, 136 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 8d8d6f3..f7851fa 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -38,6 +38,9 @@
 #include "ispreg.h"
 #include "ispccdc.h"
 
+#define CCDC_MIN_WIDTH		32
+#define CCDC_MIN_HEIGHT		32
+
 static struct v4l2_mbus_framefmt *
 __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
@@ -1118,6 +1121,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	struct isp_parallel_platform_data *pdata = NULL;
 	struct v4l2_subdev *sensor;
 	struct v4l2_mbus_framefmt *format;
+	const struct v4l2_rect *crop;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
 	unsigned int depth_out;
@@ -1211,14 +1215,14 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 
 	/* CCDC_PAD_SOURCE_OF */
-	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
+	crop = &ccdc->crop;
 
-	isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
-		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+	isp_reg_writel(isp, (crop->left << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+		       ((crop->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
-	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+	isp_reg_writel(isp, crop->top << ISPCCDC_VERT_START_SLV0_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
-	isp_reg_writel(isp, (format->height - 1)
+	isp_reg_writel(isp, (crop->height - 1)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
@@ -1793,6 +1797,16 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		return &ccdc->formats[pad];
 }
 
+static struct v4l2_rect *
+__ccdc_get_crop(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+		enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(fh, CCDC_PAD_SOURCE_OF);
+	else
+		return &ccdc->crop;
+}
+
 /*
  * ccdc_try_format - Try video format on a pad
  * @ccdc: ISP CCDC device
@@ -1809,6 +1823,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	const struct isp_format_info *info;
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
+	struct v4l2_rect *crop;
 	unsigned int i;
 
 	switch (pad) {
@@ -1834,14 +1849,10 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 
-		/* The data formatter truncates the number of horizontal output
-		 * pixels to a multiple of 16. To avoid clipping data, allow
-		 * callers to request an output size bigger than the input size
-		 * up to the nearest multiple of 16.
-		 */
-		fmt->width = clamp_t(u32, width, 32, fmt->width + 15);
-		fmt->width &= ~15;
-		fmt->height = clamp_t(u32, height, 32, fmt->height);
+		/* Hardcode the output size to the crop rectangle size. */
+		crop = __ccdc_get_crop(ccdc, fh, which);
+		fmt->width = crop->width;
+		fmt->height = crop->height;
 		break;
 
 	case CCDC_PAD_SOURCE_VP:
@@ -1869,6 +1880,49 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 }
 
 /*
+ * ccdc_try_crop - Validate a crop rectangle
+ * @ccdc: ISP CCDC device
+ * @sink: format on the sink pad
+ * @crop: crop rectangle to be validated
+ */
+static void ccdc_try_crop(struct isp_ccdc_device *ccdc,
+			  const struct v4l2_mbus_framefmt *sink,
+			  struct v4l2_rect *crop)
+{
+	const struct isp_format_info *info;
+	unsigned int max_width;
+
+	/* For Bayer formats, restrict left/top and width/height to even values
+	 * to keep the Bayer pattern.
+	 */
+	info = omap3isp_video_format_info(sink->code);
+	if (info->flavor != V4L2_MBUS_FMT_Y8_1X8) {
+		crop->left &= ~1;
+		crop->top &= ~1;
+	}
+
+	crop->left = clamp_t(u32, crop->left, 0, sink->width - CCDC_MIN_WIDTH);
+	crop->top = clamp_t(u32, crop->top, 0, sink->height - CCDC_MIN_HEIGHT);
+
+	/* The data formatter truncates the number of horizontal output pixels
+	 * to a multiple of 16. To avoid clipping data, allow callers to request
+	 * an output size bigger than the input size up to the nearest multiple
+	 * of 16.
+	 */
+	max_width = (sink->width - crop->left + 15) & ~15;
+	crop->width = clamp_t(u32, crop->width, CCDC_MIN_WIDTH, max_width)
+		    & ~15;
+	crop->height = clamp_t(u32, crop->height, CCDC_MIN_HEIGHT,
+			       sink->height - crop->top);
+
+	/* Odd width/height values don't make sense for Bayer formats. */
+	if (info->flavor != V4L2_MBUS_FMT_Y8_1X8) {
+		crop->width &= ~1;
+		crop->height &= ~1;
+	}
+}
+
+/*
  * ccdc_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
  * @fh : V4L2 subdev file handle
@@ -1940,6 +1994,60 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 /*
+ * ccdc_get_crop - Retrieve the crop rectangle on a pad
+ * @sd: ISP CCDC V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @crop: crop rectangle
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int ccdc_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_crop *crop)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+
+	/* Cropping is only supported on the output formatter source pad. */
+	if (crop->pad != CCDC_PAD_SOURCE_OF)
+		return -EINVAL;
+
+	crop->rect = *__ccdc_get_crop(ccdc, fh, crop->which);
+	return 0;
+}
+
+/*
+ * ccdc_set_crop - Retrieve the crop rectangle on a pad
+ * @sd: ISP CCDC V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @crop: crop rectangle
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static int ccdc_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_crop *crop)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Cropping is only supported on the output formatter source pad. */
+	if (crop->pad != CCDC_PAD_SOURCE_OF)
+		return -EINVAL;
+
+	/* The crop rectangle can't be changed while streaming. */
+	if (ccdc->state != ISP_PIPELINE_STREAM_STOPPED)
+		return -EBUSY;
+
+	format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, crop->which);
+	ccdc_try_crop(ccdc, format, &crop->rect);
+	*__ccdc_get_crop(ccdc, fh, crop->which) = crop->rect;
+
+	/* Update the source format. */
+	format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF, crop->which);
+	ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_OF, format, crop->which);
+
+	return 0;
+}
+
+/*
  * ccdc_get_format - Retrieve the video format on a pad
  * @sd : ISP CCDC V4L2 subdevice
  * @fh : V4L2 subdev file handle
@@ -1976,6 +2084,7 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
 
 	format = __ccdc_get_format(ccdc, fh, fmt->pad, fmt->which);
 	if (format == NULL)
@@ -1986,6 +2095,16 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == CCDC_PAD_SINK) {
+		/* Reset the crop rectangle. */
+		crop = __ccdc_get_crop(ccdc, fh, fmt->which);
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = fmt->format.width;
+		crop->height = fmt->format.height;
+
+		ccdc_try_crop(ccdc, &fmt->format, crop);
+
+		/* Update the source formats. */
 		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF,
 					   fmt->which);
 		*format = fmt->format;
@@ -2044,6 +2163,8 @@ static const struct v4l2_subdev_pad_ops ccdc_v4l2_pad_ops = {
 	.enum_frame_size = ccdc_enum_frame_size,
 	.get_fmt = ccdc_get_format,
 	.set_fmt = ccdc_set_format,
+	.get_crop = ccdc_get_crop,
+	.set_crop = ccdc_set_crop,
 };
 
 /* V4L2 subdev operations */
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 6d0264b..966bbf8 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -147,6 +147,7 @@ struct ispccdc_lsc {
  * @subdev: V4L2 subdevice
  * @pads: Sink and source media entity pads
  * @formats: Active video formats
+ * @crop: Active crop rectangle on the OF source pad
  * @input: Active input
  * @output: Active outputs
  * @video_out: Output video node
@@ -173,6 +174,7 @@ struct isp_ccdc_device {
 	struct v4l2_subdev subdev;
 	struct media_pad pads[CCDC_PADS_NUM];
 	struct v4l2_mbus_framefmt formats[CCDC_PADS_NUM];
+	struct v4l2_rect crop;
 
 	enum ccdc_input_entity input;
 	unsigned int output;
-- 
1.7.3.4

