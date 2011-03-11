Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:47503 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1CKIGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 03:06:11 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v3 4/4] omap3isp: lane shifter support
Date: Fri, 11 Mar 2011 09:05:49 +0100
Message-Id: <1299830749-7269-5-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

To use the lane shifter, set different pixel formats at each end of
the link at the CCDC input.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3-isp/isp.c      |    7 ++-
 drivers/media/video/omap3-isp/isp.h      |    5 +-
 drivers/media/video/omap3-isp/ispccdc.c  |   27 ++++++--
 drivers/media/video/omap3-isp/ispvideo.c |  108 ++++++++++++++++++++++++------
 drivers/media/video/omap3-isp/ispvideo.h |    3 +
 5 files changed, 120 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/omap3-isp/isp.c b/drivers/media/video/omap3-isp/isp.c
index 08d90fe..866ce09 100644
--- a/drivers/media/video/omap3-isp/isp.c
+++ b/drivers/media/video/omap3-isp/isp.c
@@ -285,7 +285,8 @@ static void isp_power_settings(struct isp_device *isp, int idle)
  */
 void omap3isp_configure_bridge(struct isp_device *isp,
 			       enum ccdc_input_entity input,
-			       const struct isp_parallel_platform_data *pdata)
+			       const struct isp_parallel_platform_data *pdata,
+			       int shift)
 {
 	u32 ispctrl_val;
 
@@ -298,9 +299,9 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 	switch (input) {
 	case CCDC_INPUT_PARALLEL:
 		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
-		ispctrl_val |= pdata->data_lane_shift << ISPCTRL_SHIFT_SHIFT;
 		ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
 		ispctrl_val |= pdata->bridge << ISPCTRL_PAR_BRIDGE_SHIFT;
+		shift += pdata->data_lane_shift*2;
 		break;
 
 	case CCDC_INPUT_CSI2A:
@@ -319,6 +320,8 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 		return;
 	}
 
+	ispctrl_val |= ((shift/2) << ISPCTRL_SHIFT_SHIFT) & ISPCTRL_SHIFT_MASK;
+
 	ispctrl_val &= ~ISPCTRL_SYNC_DETECT_MASK;
 	ispctrl_val |= ISPCTRL_SYNC_DETECT_VSRISE;
 
diff --git a/drivers/media/video/omap3-isp/isp.h b/drivers/media/video/omap3-isp/isp.h
index 21fa88b..6f0ff1a 100644
--- a/drivers/media/video/omap3-isp/isp.h
+++ b/drivers/media/video/omap3-isp/isp.h
@@ -130,7 +130,6 @@ struct isp_reg {
 
 /**
  * struct isp_parallel_platform_data - Parallel interface platform data
- * @width: Parallel bus width in bits (8, 10, 11 or 12)
  * @data_lane_shift: Data lane shifter
  *		0 - CAMEXT[13:0] -> CAM[13:0]
  *		1 - CAMEXT[13:2] -> CAM[11:0]
@@ -144,7 +143,6 @@ struct isp_reg {
  *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
  */
 struct isp_parallel_platform_data {
-	unsigned int width;
 	unsigned int data_lane_shift:2;
 	unsigned int clk_pol:1;
 	unsigned int bridge:4;
@@ -322,7 +320,8 @@ int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 				 enum isp_pipeline_stream_state state);
 void omap3isp_configure_bridge(struct isp_device *isp,
 			       enum ccdc_input_entity input,
-			       const struct isp_parallel_platform_data *pdata);
+			       const struct isp_parallel_platform_data *pdata,
+			       int shift);
 
 #define ISP_XCLK_NONE			-1
 #define ISP_XCLK_A			0
diff --git a/drivers/media/video/omap3-isp/ispccdc.c b/drivers/media/video/omap3-isp/ispccdc.c
index 23000b6..bbcf619 100644
--- a/drivers/media/video/omap3-isp/ispccdc.c
+++ b/drivers/media/video/omap3-isp/ispccdc.c
@@ -1120,21 +1120,38 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	struct isp_parallel_platform_data *pdata = NULL;
 	struct v4l2_subdev *sensor;
 	struct v4l2_mbus_framefmt *format;
+	const struct isp_format_info *fmt_info;
+	struct v4l2_subdev_format fmt_src;
+	unsigned int depth_out = 0;
+	unsigned int depth_in = 0;
 	struct media_pad *pad;
 	unsigned long flags;
+	unsigned int shift;
 	u32 syn_mode;
 	u32 ccdc_pattern;
 
-	if (ccdc->input == CCDC_INPUT_PARALLEL) {
-		pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
-		sensor = media_entity_to_v4l2_subdev(pad->entity);
+	pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
+	sensor = media_entity_to_v4l2_subdev(pad->entity);
+	if (ccdc->input == CCDC_INPUT_PARALLEL)
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
 			->bus.parallel;
+
+	/* Compute shift value for lane shifter to configure the bridge. */
+	fmt_src.pad = pad->index;
+	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
+		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
+		depth_in = fmt_info->bpp;
 	}
 
-	omap3isp_configure_bridge(isp, ccdc->input, pdata);
+	fmt_info = omap3isp_video_format_info
+		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
+	depth_out = fmt_info->bpp;
+
+	shift = depth_in - depth_out;
+	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
-	ccdc->syncif.datsz = pdata ? pdata->width : 10;
+	ccdc->syncif.datsz = depth_out;
 	ccdc_config_sync_if(ccdc, &ccdc->syncif);
 
 	/* CCDC_PAD_SINK */
diff --git a/drivers/media/video/omap3-isp/ispvideo.c b/drivers/media/video/omap3-isp/ispvideo.c
index 3c3b3c4..c4b9fe1 100644
--- a/drivers/media/video/omap3-isp/ispvideo.c
+++ b/drivers/media/video/omap3-isp/ispvideo.c
@@ -47,41 +47,59 @@
 
 static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
+	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_PIX_FMT_GREY, 8, },
 	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
-	  V4L2_MBUS_FMT_Y10_1X10, V4L2_PIX_FMT_Y10, 10, },
+	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_PIX_FMT_Y10, 10, },
 	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
-	  V4L2_MBUS_FMT_Y12_1X12, V4L2_PIX_FMT_Y12, 12, },
+	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_PIX_FMT_Y12, 12, },
 	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 8, },
+	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_PIX_FMT_SBGGR8, 8, },
 	{ V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8, 8, },
+	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_PIX_FMT_SGBRG8, 8, },
 	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8, },
+	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_PIX_FMT_SGRBG8, 8, },
 	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 8, },
+	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_PIX_FMT_SRGGB8, 8, },
 	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
-	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
+	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
+	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
 	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
-	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10, 10, },
+	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_PIX_FMT_SBGGR10, 10, },
 	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
-	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10, 10, },
+	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_PIX_FMT_SGBRG10, 10, },
 	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
-	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10, 10, },
+	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_PIX_FMT_SGRBG10, 10, },
 	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
-	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10, 10, },
+	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_PIX_FMT_SRGGB10, 10, },
 	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
-	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12, 12, },
+	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
+	  V4L2_PIX_FMT_SBGGR12, 12, },
 	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
-	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12, 12, },
+	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
+	  V4L2_PIX_FMT_SGBRG12, 12, },
 	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
-	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12, 12, },
+	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
+	  V4L2_PIX_FMT_SGRBG12, 12, },
 	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
-	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12, 12, },
+	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
+	  V4L2_PIX_FMT_SRGGB12, 12, },
 	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
-	  V4L2_MBUS_FMT_UYVY8_1X16, V4L2_PIX_FMT_UYVY, 16, },
+	  V4L2_MBUS_FMT_UYVY8_1X16, 0,
+	  V4L2_PIX_FMT_UYVY, 16, },
 	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
-	  V4L2_MBUS_FMT_YUYV8_1X16, V4L2_PIX_FMT_YUYV, 16, },
+	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
+	  V4L2_PIX_FMT_YUYV, 16, },
 };
 
 const struct isp_format_info *
@@ -98,6 +116,37 @@ omap3isp_video_format_info(enum v4l2_mbus_pixelcode code)
 }
 
 /*
+ * Decide whether desired output pixel code can be obtained with
+ * the lane shifter by shifting the input pixel code.
+ * @in: input pixelcode to shifter
+ * @out: output pixelcode from shifter
+ * @additional_shift: # of bits the sensor's LSB is offset from CAMEXT[0]
+ *
+ * return true if the combination is possible
+ * return false otherwise
+ */
+static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
+		enum v4l2_mbus_pixelcode out,
+		unsigned int additional_shift)
+{
+	const struct isp_format_info *in_info, *out_info;
+
+	if (in == out)
+		return true;
+
+	in_info = omap3isp_video_format_info(in);
+	out_info = omap3isp_video_format_info(out);
+
+	if ((in_info->flavor == 0) || (out_info->flavor == 0))
+		return false;
+
+	if (in_info->flavor != out_info->flavor)
+		return false;
+
+	return in_info->bpp - out_info->bpp + additional_shift <= 6;
+}
+
+/*
  * isp_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
  * @video: ISP video instance
  * @mbus: v4l2_mbus_framefmt format (input)
@@ -247,6 +296,7 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 		return -EPIPE;
 
 	while (1) {
+		unsigned int link_has_shifter;
 		/* Retrieve the sink format */
 		pad = &subdev->entity.pads[0];
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
@@ -275,6 +325,10 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 				return -ENOSPC;
 		}
 
+		/* If sink pad is on CCDC, the link has the lane shifter
+		 * in the middle of it. */
+		link_has_shifter = subdev == &isp->isp_ccdc.subdev;
+
 		/* Retrieve the source format */
 		pad = media_entity_remote_source(pad);
 		if (pad == NULL ||
@@ -290,10 +344,24 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 			return -EPIPE;
 
 		/* Check if the two ends match */
-		if (fmt_source.format.code != fmt_sink.format.code ||
-		    fmt_source.format.width != fmt_sink.format.width ||
+		if (fmt_source.format.width != fmt_sink.format.width ||
 		    fmt_source.format.height != fmt_sink.format.height)
 			return -EPIPE;
+
+		if (link_has_shifter) {
+			unsigned int parallel_shift = 0;
+			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {
+				struct isp_parallel_platform_data *pdata =
+					&((struct isp_v4l2_subdevs_group *)
+					      subdev->host_priv)->bus.parallel;
+				parallel_shift = pdata->data_lane_shift * 2;
+			}
+			if (!isp_video_is_shiftable(fmt_source.format.code,
+						fmt_sink.format.code,
+						parallel_shift))
+				return -EPIPE;
+		} else if (fmt_source.format.code != fmt_sink.format.code)
+			return -EPIPE;
 	}
 
 	return 0;
diff --git a/drivers/media/video/omap3-isp/ispvideo.h b/drivers/media/video/omap3-isp/ispvideo.h
index 524a1ac..911bea6 100644
--- a/drivers/media/video/omap3-isp/ispvideo.h
+++ b/drivers/media/video/omap3-isp/ispvideo.h
@@ -49,6 +49,8 @@ struct v4l2_pix_format;
  *	bits. Identical to @code if the format is 10 bits wide or less.
  * @uncompressed: V4L2 media bus format code for the corresponding uncompressed
  *	format. Identical to @code if the format is not DPCM compressed.
+ * @flavor: V4L2 media bus format code for the same pixel layout but
+ *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
  * @pixelformat: V4L2 pixel format FCC identifier
  * @bpp: Bits per pixel
  */
@@ -56,6 +58,7 @@ struct isp_format_info {
 	enum v4l2_mbus_pixelcode code;
 	enum v4l2_mbus_pixelcode truncated;
 	enum v4l2_mbus_pixelcode uncompressed;
+	enum v4l2_mbus_pixelcode flavor;
 	u32 pixelformat;
 	unsigned int bpp;
 };
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
