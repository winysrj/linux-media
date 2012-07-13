Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58835 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2GMLhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:37:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 6/6] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Fri, 13 Jul 2012 13:37:38 +0200
Message-Id: <1342179458-1037-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rearrange the CFA interpolation coefficients table based on the Bayer
pattern. Support for non-Bayer CFA patterns is dropped as they were not
correctly supported, and have never been tested.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/cfa_coef_table.h |   16 ++--
 drivers/media/video/omap3isp/isppreview.c     |  131 +++++++++++++++----------
 drivers/media/video/omap3isp/isppreview.h     |    1 +
 include/linux/omap3isp.h                      |    3 +-
 4 files changed, 91 insertions(+), 60 deletions(-)

diff --git a/drivers/media/video/omap3isp/cfa_coef_table.h b/drivers/media/video/omap3isp/cfa_coef_table.h
index c60df0e..c84df07 100644
--- a/drivers/media/video/omap3isp/cfa_coef_table.h
+++ b/drivers/media/video/omap3isp/cfa_coef_table.h
@@ -23,7 +23,7 @@
  * 02110-1301 USA
  */
 
-244,   0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
+{ 244, 0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
 248,   0,   0,   0,   0,  40,   0,   0, 244,  12, 250,   4,   0,  27,   0, 250,
 247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248,
 244,   0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
@@ -31,8 +31,8 @@
 247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248,
 244,   0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
 248,   0,   0,   0,   0,  40,   0,   0, 244,  12, 250,   4,   0,  27,   0, 250,
-247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248,
-  0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
+247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248 },
+{ 0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
   0,   0,   0, 248,   0,   0,  40,   0,   4, 250,  12, 244, 250,   0,  27,   0,
  12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0,
   0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
@@ -40,8 +40,8 @@
  12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0,
   0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
   0,   0,   0, 248,   0,   0,  40,   0,   4, 250,  12, 244, 250,   0,  27,   0,
- 12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0,
-  4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
+ 12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0 },
+{ 4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
   0,   0,   0, 248,   0,   0,  40,   0,   0, 247,   0, 244, 247,  36,  27,  12,
   0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0,
   4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
@@ -49,8 +49,8 @@
   0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0,
   4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
   0,   0,   0, 248,   0,   0,  40,   0,   0, 247,   0, 244, 247,  36,  27,  12,
-  0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0,
-244,  12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
+  0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0 },
+{ 244,12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
 248,   0,   0,   0,   0,  40,   0,   0, 244,   0, 247,   0,  12,  27,  36, 247,
 250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248,
 244,  12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
@@ -58,4 +58,4 @@
 250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248,
 244,  12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
 248,   0,   0,   0,   0,  40,   0,   0, 244,   0, 247,   0,  12,  27,  36, 247,
-250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248
+250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248 },
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 5b6f636..ed412fb 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -131,7 +131,7 @@ static struct omap3isp_prev_csc flr_prev_csc = {
  * CFA Filter Coefficient Table
  *
  */
-static u32 cfa_coef_table[] = {
+static u32 cfa_coef_table[4][OMAP3ISP_PREV_CFA_BLK_SIZE] = {
 #include "cfa_coef_table.h"
 };
 
@@ -237,19 +237,27 @@ static void preview_enable_hmed(struct isp_prev_device *prev, bool enable)
 }
 
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
@@ -259,9 +267,12 @@ preview_config_cfa(struct isp_prev_device *prev,
 	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
 		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
 
-	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
-		isp_reg_writel(isp, cfa->table[i],
-			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
+	for (i = 0; i < 4; ++i) {
+		const __u32 *block = cfa->table[order[i]];
+
+		for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
+			isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
+				       ISPPRV_SET_TBL_DATA);
 	}
 }
 
@@ -993,42 +1004,60 @@ preview_config_ycpos(struct isp_prev_device *prev,
 static void preview_config_averager(struct isp_prev_device *prev, u8 average)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	struct prev_params *params;
-	int reg = 0;
-
-	params = (prev->params.active & OMAP3ISP_PREV_CFA)
-	       ? &prev->params.params[0] : &prev->params.params[1];
 
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
@@ -1371,22 +1400,6 @@ static void preview_configure(struct isp_prev_device *prev)
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
 
@@ -1401,10 +1414,26 @@ static void preview_configure(struct isp_prev_device *prev)
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
diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
index 79af5c4..cd61e0a 100644
--- a/include/linux/omap3isp.h
+++ b/include/linux/omap3isp.h
@@ -436,6 +436,7 @@ struct omap3isp_ccdc_update_config {
 
 #define OMAP3ISP_PREV_NF_TBL_SIZE	64
 #define OMAP3ISP_PREV_CFA_TBL_SIZE	576
+#define OMAP3ISP_PREV_CFA_BLK_SIZE	(OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
 #define OMAP3ISP_PREV_GAMMA_TBL_SIZE	1024
 #define OMAP3ISP_PREV_YENH_TBL_SIZE	128
 
@@ -477,7 +478,7 @@ struct omap3isp_prev_cfa {
 	enum omap3isp_cfa_fmt format;
 	__u8 gradthrs_vert;
 	__u8 gradthrs_horz;
-	__u32 table[OMAP3ISP_PREV_CFA_TBL_SIZE];
+	__u32 table[4][OMAP3ISP_PREV_CFA_BLK_SIZE];
 };
 
 /**
-- 
1.7.8.6

