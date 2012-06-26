Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37290 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab2FZNpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 09:45:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 6/6] omap3isp: ccdc: Add YUV input formats support
Date: Tue, 26 Jun 2012 15:45:39 +0200
Message-Id: <1340718339-29915-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the bridge automatically when the input format is YUYV8 or UYVY8.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c      |    4 +-
 drivers/media/video/omap3isp/isp.h      |    2 +-
 drivers/media/video/omap3isp/ispccdc.c  |  145 ++++++++++++++++++++++++++-----
 drivers/media/video/omap3isp/ispvideo.c |    4 +
 include/media/omap3isp.h                |   11 ---
 5 files changed, 129 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 36805ca..e0096e0 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -293,7 +293,7 @@ static void isp_core_init(struct isp_device *isp, int idle)
 void omap3isp_configure_bridge(struct isp_device *isp,
 			       enum ccdc_input_entity input,
 			       const struct isp_parallel_platform_data *pdata,
-			       unsigned int shift)
+			       unsigned int shift, unsigned int bridge)
 {
 	u32 ispctrl_val;
 
@@ -302,12 +302,12 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 	ispctrl_val &= ~ISPCTRL_PAR_CLK_POL_INV;
 	ispctrl_val &= ~ISPCTRL_PAR_SER_CLK_SEL_MASK;
 	ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_MASK;
+	ispctrl_val |= bridge;
 
 	switch (input) {
 	case CCDC_INPUT_PARALLEL:
 		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
 		ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
-		ispctrl_val |= pdata->bridge << ISPCTRL_PAR_BRIDGE_SHIFT;
 		shift += pdata->data_lane_shift * 2;
 		break;
 
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index ba2159b..8be7487 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -236,7 +236,7 @@ int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 void omap3isp_configure_bridge(struct isp_device *isp,
 			       enum ccdc_input_entity input,
 			       const struct isp_parallel_platform_data *pdata,
-			       unsigned int shift);
+			       unsigned int shift, unsigned int bridge);
 
 struct isp_device *omap3isp_get(struct isp_device *isp);
 void omap3isp_put(struct isp_device *isp);
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index d5aed79..7e148c8 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -61,6 +61,8 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SRGGB12_1X12,
 	V4L2_MBUS_FMT_SBGGR12_1X12,
 	V4L2_MBUS_FMT_SGBRG12_1X12,
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
 };
 
 /*
@@ -973,8 +975,19 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 				unsigned int data_size)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
+	const struct v4l2_mbus_framefmt *format;
 	u32 syn_mode = ISPCCDC_SYN_MODE_VDHDEN;
 
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
+	if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    format->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+		/* The bridge is enabled for YUV8 formats. Configure the input
+		 * mode accordingly.
+		 */
+		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+	}
+
 	switch (data_size) {
 	case 8:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
@@ -1000,6 +1013,19 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+
+	/* The CCDC_CFG.Y8POS bit is used in YCbCr8 input mode only. The
+	 * hardware seems to ignore it in all other input modes.
+	 */
+	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
+
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+		    ISPCCDC_REC656IF_R656ON);
 }
 
 /* CCDC formats descriptions */
@@ -1088,6 +1114,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	unsigned int depth_in = 0;
 	struct media_pad *pad;
 	unsigned long flags;
+	unsigned int bridge;
 	unsigned int shift;
 	u32 syn_mode;
 	u32 ccdc_pattern;
@@ -1098,7 +1125,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
 			->bus.parallel;
 
-	/* Compute shift value for lane shifter to configure the bridge. */
+	/* Compute the lane shifter shift value and enable the bridge when the
+	 * input format is YUV.
+	 */
 	fmt_src.pad = pad->index;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
@@ -1109,14 +1138,18 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	fmt_info = omap3isp_video_format_info
 		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
 	depth_out = fmt_info->width;
-
 	shift = depth_in - depth_out;
-	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
-	ccdc_config_sync_if(ccdc, pdata, depth_out);
+	if (fmt_info->code == V4L2_MBUS_FMT_YUYV8_2X8)
+		bridge = ISPCTRL_PAR_BRIDGE_LENDIAN;
+	else if (fmt_info->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		bridge = ISPCTRL_PAR_BRIDGE_BENDIAN;
+	else
+		bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
 
-	/* CCDC_PAD_SINK */
-	format = &ccdc->formats[CCDC_PAD_SINK];
+	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift, bridge);
+
+	ccdc_config_sync_if(ccdc, pdata, depth_out);
 
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
@@ -1135,13 +1168,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
-	/* Use PACK8 mode for 1byte per pixel formats. */
-	if (omap3isp_video_format_info(format->code)->width <= 8)
-		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
-
-	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
 
 	/* Mosaic filter */
 	switch (format->code) {
@@ -1172,6 +1200,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 
 	/* CCDC_PAD_SOURCE_OF */
+	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 	crop = &ccdc->crop;
 
 	isp_reg_writel(isp, (crop->left << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
@@ -1185,6 +1214,24 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
 
+	/* The CCDC outputs data in UYVY order by default. Swap bytes to get
+	 * YUYV.
+	 */
+	if (format->code == V4L2_MBUS_FMT_YUYV8_1X16)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_BSWD);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_BSWD);
+
+	/* Use PACK8 mode for 1byte per pixel formats. */
+	if (omap3isp_video_format_info(format->code)->width <= 8)
+		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
+
+	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+
 	/* CCDC_PAD_SOURCE_VP */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
 
@@ -1199,6 +1246,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		       (format->height << ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
 
+	/* Lens shading correction. */
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
 	if (ccdc->lsc.request == NULL)
 		goto unlock;
@@ -1776,8 +1824,8 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
-	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
+	enum v4l2_mbus_pixelcode pixelcode;
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
 	struct v4l2_rect *crop;
@@ -1785,9 +1833,6 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 
 	switch (pad) {
 	case CCDC_PAD_SINK:
-		/* TODO: If the CCDC output formatter pad is connected directly
-		 * to the resizer, only YUV formats can be used.
-		 */
 		for (i = 0; i < ARRAY_SIZE(ccdc_fmts); i++) {
 			if (fmt->code == ccdc_fmts[i])
 				break;
@@ -1803,8 +1848,26 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		break;
 
 	case CCDC_PAD_SOURCE_OF:
-		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
-		memcpy(fmt, format, sizeof(*fmt));
+		pixelcode = fmt->code;
+		*fmt = *__ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
+
+		/* YUV formats are converted from 2X8 to 1X16 by the bridge and
+		 * can be byte-swapped.
+		 */
+		if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+		    fmt->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+			/* Use the user requested format if YUV. */
+			if (pixelcode == V4L2_MBUS_FMT_YUYV8_2X8 ||
+			    pixelcode == V4L2_MBUS_FMT_UYVY8_2X8 ||
+			    pixelcode == V4L2_MBUS_FMT_YUYV8_1X16 ||
+			    pixelcode == V4L2_MBUS_FMT_UYVY8_1X16)
+				fmt->code = pixelcode;
+
+			if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8)
+				fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+			else if (fmt->code == V4L2_MBUS_FMT_UYVY8_2X8)
+				fmt->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		}
 
 		/* Hardcode the output size to the crop rectangle size. */
 		crop = __ccdc_get_crop(ccdc, fh, which);
@@ -1813,13 +1876,17 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		break;
 
 	case CCDC_PAD_SOURCE_VP:
-		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
-		memcpy(fmt, format, sizeof(*fmt));
+		*fmt = *__ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
 
 		/* The video port interface truncates the data to 10 bits. */
 		info = omap3isp_video_format_info(fmt->code);
 		fmt->code = info->truncated;
 
+		/* YUV formats are not supported by the video port. */
+		if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+		    fmt->code == V4L2_MBUS_FMT_UYVY8_2X8)
+			fmt->code = 0;
+
 		/* The number of lines that can be clocked out from the video
 		 * port output must be at least one line less than the number
 		 * of input lines.
@@ -1902,14 +1969,46 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
 		break;
 
 	case CCDC_PAD_SOURCE_OF:
+		format = __ccdc_get_format(ccdc, fh, code->pad,
+					   V4L2_SUBDEV_FORMAT_TRY);
+
+		if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+		    format->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+			/* In YUV mode the CCDC can swap bytes. */
+			if (code->index == 0)
+				code->code = V4L2_MBUS_FMT_YUYV8_1X16;
+			else if (code->index == 1)
+				code->code = V4L2_MBUS_FMT_UYVY8_1X16;
+			else
+				return -EINVAL;
+		} else {
+			/* In raw mode, no configurable format confversion is
+			 * available.
+			 */
+			if (code->index == 0)
+				code->code = format->code;
+			else
+				return -EINVAL;
+		}
+		break;
+
 	case CCDC_PAD_SOURCE_VP:
-		/* No format conversion inside CCDC */
+		/* The CCDC supports no configurable format conversion
+		 * compatible with the video port. Enumerate a single output
+		 * format code.
+		 */
 		if (code->index != 0)
 			return -EINVAL;
 
-		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK,
+		format = __ccdc_get_format(ccdc, fh, code->pad,
 					   V4L2_SUBDEV_FORMAT_TRY);
 
+		/* A pixel code equal to 0 means that the video port doesn't
+		 * support the input format. Don't enumerate any pixel code.
+		 */
+		if (format->code == 0)
+			return -EINVAL;
+
 		code->code = format->code;
 		break;
 
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 9ce158e..f837b76 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -120,6 +120,10 @@ static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_YUYV8_2X8,
 	  V4L2_MBUS_FMT_YUYV8_2X8, 0,
 	  V4L2_PIX_FMT_YUYV, 8, 16, },
+	/* Empty entry to catch the unsupported pixel code (0) used by the CCDC
+	 * module and avoid NULL pointer dereferences.
+	 */
+	{ 0, }
 };
 
 const struct isp_format_info *
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 5ab9449..9584269 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -42,12 +42,6 @@ enum isp_interface_type {
 };
 
 enum {
-	ISP_BRIDGE_DISABLE = 0,
-	ISP_BRIDGE_LITTLE_ENDIAN = 2,
-	ISP_BRIDGE_BIG_ENDIAN = 3,
-};
-
-enum {
 	ISP_LANE_SHIFT_0 = 0,
 	ISP_LANE_SHIFT_2 = 1,
 	ISP_LANE_SHIFT_4 = 2,
@@ -69,10 +63,6 @@ enum {
  *		0 - Active high, 1 - Active low
  * @data_pol: Data polarity
  *		0 - Normal, 1 - One's complement
- * @bridge: CCDC Bridge input control
- *		ISP_BRIDGE_DISABLE - Disable
- *		ISP_BRIDGE_LITTLE_ENDIAN - Little endian
- *		ISP_BRIDGE_BIG_ENDIAN - Big endian
  */
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
@@ -80,7 +70,6 @@ struct isp_parallel_platform_data {
 	unsigned int hs_pol:1;
 	unsigned int vs_pol:1;
 	unsigned int data_pol:1;
-	unsigned int bridge:2;
 };
 
 enum {
-- 
1.7.3.4

