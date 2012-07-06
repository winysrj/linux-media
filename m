Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53535 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2GFNcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 09:32:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 6/6] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Fri,  6 Jul 2012 15:32:49 +0200
Message-Id: <1341581569-8292-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rearrange the CFA interpolation coefficients table based on the Bayer
pattern. Support for non-Bayer CFA patterns is dropped as they were not
correctly supported, and have never been tested.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  134 ++++++++++++++++++-----------
 drivers/media/video/omap3isp/isppreview.h |    1 +
 2 files changed, 85 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 71ce0f4..475908b 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -236,20 +236,30 @@ static void preview_enable_hmed(struct isp_prev_device *prev, bool enable)
 			    ISPPRV_PCR_HMEDEN);
 }
 
+#define OMAP3ISP_PREV_CFA_BLK_SIZE	(OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
+
 /*
- * preview_config_cfa - Configure CFA Interpolation
- */
-static void
-preview_config_cfa(struct isp_prev_device *prev,
-		   const struct prev_params *params)
-{
-	struct isp_device *isp = to_isp_device(prev);
+ * preview_config_cfa - Configure CFA Interpolation for Bayer formats
+ *
+ * The CFA table is organised in four blocks, one per Bayer component. The
+ * hardware expects blocks to follow the Bayer order of the input data, while
+ * the driver stores the table in GRBG order in memory. The blocks need to be
+ * reordered to support non-GRBG Bayer patterns.
+ */
+static void preview_config_cfa(struct isp_prev_device *prev,
+			       const struct prev_params *params)
+{
+	static const unsigned int cfa_coef_order[4][4] = {
+		{ 0, 1, 2, 3 }, /* GRBG */
+		{ 1, 0, 3, 2 }, /* RGGB */
+		{ 2, 3, 0, 1 }, /* BGGR */
+		{ 3, 2, 1, 0 }, /* GBRG */
+	};
+	const unsigned int *order = cfa_coef_order[prev->params.cfa_order];
 	const struct omap3isp_prev_cfa *cfa = &params->cfa;
+	struct isp_device *isp = to_isp_device(prev);
 	unsigned int i;
-
-	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			ISPPRV_PCR_CFAFMT_MASK,
-			cfa->format << ISPPRV_PCR_CFAFMT_SHIFT);
+	unsigned int j;
 
 	isp_reg_writel(isp,
 		(cfa->gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
@@ -259,9 +269,13 @@ preview_config_cfa(struct isp_prev_device *prev,
 	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
 		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
 
-	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
-		isp_reg_writel(isp, cfa->table[i],
-			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
+	for (i = 0; i < 4; ++i) {
+		const __u32 *block = cfa->table
+				   + order[i] * OMAP3ISP_PREV_CFA_BLK_SIZE;
+
+		for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
+			isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
+				       ISPPRV_SET_TBL_DATA);
 	}
 }
 
@@ -993,42 +1007,62 @@ preview_config_ycpos(struct isp_prev_device *prev,
 static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	struct prev_params *params;
-	int reg = 0;
 
-	params = (prev->params.active & OMAP3ISP_PREV_CFA)
-	       ? &prev->params.params[0] : &prev->params.params[1];
-
-	if (params->cfa.format == OMAP3ISP_CFAFMT_BAYER)
-		reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
-		      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
-		      average;
-	else if (params->cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
-		reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
-		      ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
-		      average;
-	isp_reg_writel(isp, reg, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
+	isp_reg_writel(isp, ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
+		       ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
+		       average, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
 }
 
+
+#define OMAP3ISP_PREV_CFA_BLK_SIZE	(OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
+
 /*
  * preview_config_input_format - Configure the input format
  * @prev: The preview engine
  * @format: Format on the preview engine sink pad
  *
- * Enable CFA interpolation for Bayer formats and disable it for greyscale
- * formats.
+ * Enable and configure CFA interpolation for Bayer formats and disable it for
+ * greyscale formats.
+ *
+ * The CFA table is organised in four blocks, one per Bayer component. The
+ * hardware expects blocks to follow the Bayer order of the input data, while
+ * the driver stores the table in GRBG order in memory. The blocks need to be
+ * reordered to support non-GRBG Bayer patterns.
  */
 static void preview_config_input_format(struct isp_prev_device *prev,
 					const struct v4l2_mbus_framefmt *format)
 {
 	struct isp_device *isp = to_isp_device(prev);
+	struct prev_params *params;
 
-	if (format->code != V4L2_MBUS_FMT_Y10_1X10)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_CFAEN);
-	else
+	switch (format->code) {
+	case V4L2_MBUS_FMT_SGRBG10_1X10:
+		prev->params.cfa_order = 0;
+		break;
+	case V4L2_MBUS_FMT_SRGGB10_1X10:
+		prev->params.cfa_order = 1;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+		prev->params.cfa_order = 2;
+		break;
+	case V4L2_MBUS_FMT_SGBRG10_1X10:
+		prev->params.cfa_order = 3;
+		break;
+	default:
+		/* Disable CFA for non-Bayer formats. */
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
 			    ISPPRV_PCR_CFAEN);
+		return;
+	}
+
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR, ISPPRV_PCR_CFAEN);
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			ISPPRV_PCR_CFAFMT_MASK, ISPPRV_PCR_CFAFMT_BAYER);
+
+	params = (prev->params.active & OMAP3ISP_PREV_CFA)
+	       ? &prev->params.params[0] : &prev->params.params[1];
+
+	preview_config_cfa(prev, params);
 }
 
 /*
@@ -1371,22 +1405,6 @@ static void preview_configure(struct isp_prev_device *prev)
 	active = prev->params.active;
 	spin_unlock_irqrestore(&prev->params.lock, flags);
 
-	preview_setup_hw(prev, update, active);
-
-	if (prev->output & PREVIEW_OUTPUT_MEMORY)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_SDRPORT);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_SDRPORT);
-
-	if (prev->output & PREVIEW_OUTPUT_RESIZER)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_RSZPORT);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_RSZPORT);
-
 	/* PREV_PAD_SINK */
 	format = &prev->formats[PREV_PAD_SINK];
 
@@ -1401,10 +1419,26 @@ static void preview_configure(struct isp_prev_device *prev)
 		preview_config_inlineoffset(prev,
 				ALIGN(format->width, 0x20) * 2);
 
+	preview_setup_hw(prev, update, active);
+
 	/* PREV_PAD_SOURCE */
 	format = &prev->formats[PREV_PAD_SOURCE];
 
 	if (prev->output & PREVIEW_OUTPUT_MEMORY)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SDRPORT);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SDRPORT);
+
+	if (prev->output & PREVIEW_OUTPUT_RESIZER)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_RSZPORT);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_RSZPORT);
+
+	if (prev->output & PREVIEW_OUTPUT_MEMORY)
 		preview_config_outlineoffset(prev,
 				ALIGN(format->width, 0x10) * 2);
 
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index 6663ab6..f669234 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -144,6 +144,7 @@ struct isp_prev_device {
 	struct isp_video video_out;
 
 	struct {
+		unsigned int cfa_order;
 		struct prev_params params[2];
 		u32 active;
 		spinlock_t lock;
-- 
1.7.8.6

