Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37599 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2DWL3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:29:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/4] omap3isp: preview: Add support for greyscale input
Date: Mon, 23 Apr 2012 13:29:53 +0200
Message-Id: <1335180595-27931-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configure CFA interpolation automatically based on the input format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   52 ++++++++++++++++------------
 1 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index f839cf8..420b131 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -441,23 +441,6 @@ preview_enable_dcor(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_cfa - Enable/Disable the CFA Interpolation.
- * @enable: 1 - Enables the CFA.
- */
-static void
-preview_enable_cfa(struct isp_prev_device *prev, u8 enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_CFAEN);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_CFAEN);
-}
-
-/*
  * preview_enable_gammabypass - Enables/Disables the GammaByPass
  * @enable: 1 - Bypasses Gamma - 10bit input is cropped to 8MSB.
  *          0 - Goes through Gamma Correction. input and output is 10bit.
@@ -831,7 +814,7 @@ static const struct preview_update update_attrs[] = {
 		offsetof(struct omap3isp_prev_update_config, hmed),
 	}, /* OMAP3ISP_PREV_CFA */ {
 		preview_config_cfa,
-		preview_enable_cfa,
+		NULL,
 		offsetof(struct prev_params, cfa),
 		FIELD_SIZEOF(struct prev_params, cfa),
 		offsetof(struct omap3isp_prev_update_config, cfa),
@@ -1078,6 +1061,27 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 }
 
 /*
+ * preview_config_input_format - Configure the input format
+ * @prev: The preview engine
+ * @format: Format on the preview engine sink pad
+ *
+ * Enable CFA interpolation for Bayer formats and disable it for greyscale
+ * formats.
+ */
+static void preview_config_input_format(struct isp_prev_device *prev,
+					const struct v4l2_mbus_framefmt *format)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (format->code != V4L2_MBUS_FMT_Y10_1X10)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_CFAEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_CFAEN);
+}
+
+/*
  * preview_config_input_size - Configure the input frame size
  *
  * The preview engine crops several rows and columns internally depending on
@@ -1090,6 +1094,7 @@ static void preview_config_averager(struct isp_prev_device *prev, u8 average)
  */
 static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 {
+	const struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
 	struct isp_device *isp = to_isp_device(prev);
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
@@ -1097,15 +1102,16 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
-	features = (prev->params.params[0].features & active)
-		 | (prev->params.params[1].features & ~active);
-
-	if (features & OMAP3ISP_PREV_CFA) {
+	if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
 		elv += 2;
 	}
+
+	features = (prev->params.params[0].features & active)
+		 | (prev->params.params[1].features & ~active);
+
 	if (features & (OMAP3ISP_PREV_DEFECT_COR | OMAP3ISP_PREV_NF)) {
 		sph -= 2;
 		eph += 2;
@@ -1436,6 +1442,7 @@ static void preview_configure(struct isp_prev_device *prev)
 
 	preview_adjust_bandwidth(prev);
 
+	preview_config_input_format(prev, format);
 	preview_config_input_size(prev, active);
 
 	if (prev->input == PREVIEW_INPUT_CCDC)
@@ -1723,6 +1730,7 @@ __preview_get_crop(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
 
 /* previewer format descriptions */
 static const unsigned int preview_input_fmts[] = {
+	V4L2_MBUS_FMT_Y10_1X10,
 	V4L2_MBUS_FMT_SGRBG10_1X10,
 	V4L2_MBUS_FMT_SRGGB10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
-- 
1.7.3.4

