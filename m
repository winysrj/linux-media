Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38415 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2JWNKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 09:10:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2] omap3isp: preview: Add support for 8-bit formats at the sink pad
Date: Tue, 23 Oct 2012 15:11:02 +0200
Message-Id: <1350997862-18880-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1350991419-23028-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1350991419-23028-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support both grayscale (Y8) and Bayer (SBGGR8, SGBRG8, SGRBG8 and
SRGGB8) formats.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isppreview.c |   40 ++++++++++++++++++--------
 1 files changed, 28 insertions(+), 12 deletions(-)

Changes since v1:

- Handle V4L2_MBUS_FMT_Y8_1X8 in preview_config_input_size()

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 1ae1c09..e3d192c 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -200,10 +200,10 @@ static void preview_enable_invalaw(struct isp_prev_device *prev, bool enable)
 
 	if (enable)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
+			    ISPPRV_PCR_INVALAW);
 	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
+			    ISPPRV_PCR_INVALAW);
 }
 
 /*
@@ -1014,7 +1014,7 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 /*
  * preview_config_input_format - Configure the input format
  * @prev: The preview engine
- * @format: Format on the preview engine sink pad
+ * @info: Sink pad format information
  *
  * Enable and configure CFA interpolation for Bayer formats and disable it for
  * greyscale formats.
@@ -1025,22 +1025,29 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
  * reordered to support non-GRBG Bayer patterns.
  */
 static void preview_config_input_format(struct isp_prev_device *prev,
-					const struct v4l2_mbus_framefmt *format)
+					const struct isp_format_info *info)
 {
 	struct isp_device *isp = to_isp_device(prev);
 	struct prev_params *params;
 
-	switch (format->code) {
-	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	if (info->bpp == 8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_WIDTH);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_WIDTH);
+
+	switch (info->flavor) {
+	case V4L2_MBUS_FMT_SGRBG8_1X8:
 		prev->params.cfa_order = 0;
 		break;
-	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case V4L2_MBUS_FMT_SRGGB8_1X8:
 		prev->params.cfa_order = 1;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
 		prev->params.cfa_order = 2;
 		break;
-	case V4L2_MBUS_FMT_SGBRG10_1X10:
+	case V4L2_MBUS_FMT_SGBRG8_1X8:
 		prev->params.cfa_order = 3;
 		break;
 	default:
@@ -1081,7 +1088,8 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
-	if (format->code != V4L2_MBUS_FMT_Y10_1X10) {
+	if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
+	    format->code != V4L2_MBUS_FMT_Y10_1X10) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
@@ -1389,6 +1397,7 @@ static unsigned int preview_max_out_width(struct isp_prev_device *prev)
 static void preview_configure(struct isp_prev_device *prev)
 {
 	struct isp_device *isp = to_isp_device(prev);
+	const struct isp_format_info *info;
 	struct v4l2_mbus_framefmt *format;
 	unsigned long flags;
 	u32 update;
@@ -1402,17 +1411,19 @@ static void preview_configure(struct isp_prev_device *prev)
 
 	/* PREV_PAD_SINK */
 	format = &prev->formats[PREV_PAD_SINK];
+	info = omap3isp_video_format_info(format->code);
 
 	preview_adjust_bandwidth(prev);
 
-	preview_config_input_format(prev, format);
+	preview_config_input_format(prev, info);
 	preview_config_input_size(prev, active);
 
 	if (prev->input == PREVIEW_INPUT_CCDC)
 		preview_config_inlineoffset(prev, 0);
 	else
 		preview_config_inlineoffset(prev,
-				ALIGN(format->width, 0x20) * 2);
+				ALIGN(format->width, 0x20) *
+				DIV_ROUND_UP(info->bpp, 8));
 
 	preview_setup_hw(prev, update, active);
 
@@ -1709,6 +1720,11 @@ __preview_get_crop(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
 
 /* previewer format descriptions */
 static const unsigned int preview_input_fmts[] = {
+	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SRGGB8_1X8,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_SGBRG8_1X8,
 	V4L2_MBUS_FMT_Y10_1X10,
 	V4L2_MBUS_FMT_SGRBG10_1X10,
 	V4L2_MBUS_FMT_SRGGB10_1X10,
-- 
Regards,

Laurent Pinchart

