Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58835 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2GMLhl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:37:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 4/6] omap3isp: preview: Reorder configuration functions
Date: Fri, 13 Jul 2012 13:37:36 +0200
Message-Id: <1342179458-1037-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorder the configuration and enable functions to match the parameters
order.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  452 ++++++++++++++--------------
 1 files changed, 226 insertions(+), 226 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 78a10b0..50be9e2 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -157,64 +157,53 @@ static u32 luma_enhance_table[] = {
 };
 
 /*
- * preview_enable_invalaw - Enable/disable Inverse A-Law decompression
- */
-static void preview_enable_invalaw(struct isp_prev_device *prev, bool enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
-}
-
-/*
- * preview_enable_drkframe_capture - Enable/disable Dark Frame Capture
+ * preview_config_luma_enhancement - Configure the Luminance Enhancement table
  */
 static void
-preview_enable_drkframe_capture(struct isp_prev_device *prev, bool enable)
+preview_config_luma_enhancement(struct isp_prev_device *prev,
+				const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_luma *yt = &params->luma;
+	unsigned int i;
 
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_DRKFCAP);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_DRKFCAP);
+	isp_reg_writel(isp, ISPPRV_YENH_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_YENH_TBL_SIZE; i++) {
+		isp_reg_writel(isp, yt->table[i],
+			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
+	}
 }
 
 /*
- * preview_enable_drkframe - Enable/disable Dark Frame Subtraction
+ * preview_enable_luma_enhancement - Enable/disable Luminance Enhancement
  */
-static void preview_enable_drkframe(struct isp_prev_device *prev, bool enable)
+static void
+preview_enable_luma_enhancement(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
 	if (enable)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_DRKFEN);
+			    ISPPRV_PCR_YNENHEN);
 	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_DRKFEN);
+			    ISPPRV_PCR_YNENHEN);
 }
 
 /*
- * preview_enable_hmed - Enable/disable the Horizontal Median Filter
+ * preview_enable_invalaw - Enable/disable Inverse A-Law decompression
  */
-static void preview_enable_hmed(struct isp_prev_device *prev, bool enable)
+static void preview_enable_invalaw(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
 	if (enable)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_HMEDEN);
+			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
 	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_HMEDEN);
+			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
 }
 
 /*
@@ -233,46 +222,18 @@ static void preview_config_hmed(struct isp_prev_device *prev,
 }
 
 /*
- * preview_config_noisefilter - Configure the Noise Filter
- */
-static void
-preview_config_noisefilter(struct isp_prev_device *prev,
-			   const struct prev_params *params)
-{
-	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_nf *nf = &params->nf;
-	unsigned int i;
-
-	isp_reg_writel(isp, nf->spread, OMAP3_ISP_IOMEM_PREV, ISPPRV_NF);
-	isp_reg_writel(isp, ISPPRV_NF_TABLE_ADDR,
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
-	for (i = 0; i < OMAP3ISP_PREV_NF_TBL_SIZE; i++) {
-		isp_reg_writel(isp, nf->table[i],
-			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
-	}
-}
-
-/*
- * preview_config_dcor - Configure Couplet Defect Correction
+ * preview_enable_hmed - Enable/disable the Horizontal Median Filter
  */
-static void
-preview_config_dcor(struct isp_prev_device *prev,
-		    const struct prev_params *params)
+static void preview_enable_hmed(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_dcor *dcor = &params->dcor;
 
-	isp_reg_writel(isp, dcor->detect_correct[0],
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR0);
-	isp_reg_writel(isp, dcor->detect_correct[1],
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR1);
-	isp_reg_writel(isp, dcor->detect_correct[2],
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR2);
-	isp_reg_writel(isp, dcor->detect_correct[3],
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR3);
-	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			ISPPRV_PCR_DCCOUP,
-			dcor->couplet_mode_en ? ISPPRV_PCR_DCCOUP : 0);
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_HMEDEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_HMEDEN);
 }
 
 /*
@@ -305,55 +266,6 @@ preview_config_cfa(struct isp_prev_device *prev,
 }
 
 /*
- * preview_config_gammacorrn - Configure the Gamma Correction tables
- */
-static void
-preview_config_gammacorrn(struct isp_prev_device *prev,
-			  const struct prev_params *params)
-{
-	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_gtables *gt = &params->gamma;
-	unsigned int i;
-
-	isp_reg_writel(isp, ISPPRV_REDGAMMA_TABLE_ADDR,
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
-	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
-		isp_reg_writel(isp, gt->red[i], OMAP3_ISP_IOMEM_PREV,
-			       ISPPRV_SET_TBL_DATA);
-
-	isp_reg_writel(isp, ISPPRV_GREENGAMMA_TABLE_ADDR,
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
-	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
-		isp_reg_writel(isp, gt->green[i], OMAP3_ISP_IOMEM_PREV,
-			       ISPPRV_SET_TBL_DATA);
-
-	isp_reg_writel(isp, ISPPRV_BLUEGAMMA_TABLE_ADDR,
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
-	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
-		isp_reg_writel(isp, gt->blue[i], OMAP3_ISP_IOMEM_PREV,
-			       ISPPRV_SET_TBL_DATA);
-}
-
-/*
- * preview_config_luma_enhancement - Configure the Luminance Enhancement table
- */
-static void
-preview_config_luma_enhancement(struct isp_prev_device *prev,
-				const struct prev_params *params)
-{
-	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_luma *yt = &params->luma;
-	unsigned int i;
-
-	isp_reg_writel(isp, ISPPRV_YENH_TABLE_ADDR,
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
-	for (i = 0; i < OMAP3ISP_PREV_YENH_TBL_SIZE; i++) {
-		isp_reg_writel(isp, yt->table[i],
-			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
-	}
-}
-
-/*
  * preview_config_chroma_suppression - Configure Chroma Suppression
  */
 static void
@@ -370,72 +282,6 @@ preview_config_chroma_suppression(struct isp_prev_device *prev,
 }
 
 /*
- * preview_enable_noisefilter - Enable/disable the Noise Filter
- */
-static void
-preview_enable_noisefilter(struct isp_prev_device *prev, bool enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_NFEN);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_NFEN);
-}
-
-/*
- * preview_enable_dcor - Enable/disable Couplet Defect Correction
- */
-static void preview_enable_dcor(struct isp_prev_device *prev, bool enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_DCOREN);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_DCOREN);
-}
-
-/*
- * preview_enable_gammabypass - Enable/disable Gamma Bypass
- *
- * When gamma bypass is enabled, the output of the gamma correction is the 8 MSB
- * of the 10-bit input .
- */
-static void
-preview_enable_gammabypass(struct isp_prev_device *prev, bool enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_GAMMA_BYPASS);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_GAMMA_BYPASS);
-}
-
-/*
- * preview_enable_luma_enhancement - Enable/disable Luminance Enhancement
- */
-static void
-preview_enable_luma_enhancement(struct isp_prev_device *prev, bool enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_YNENHEN);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_YNENHEN);
-}
-
-/*
  * preview_enable_chroma_suppression - Enable/disable Chrominance Suppression
  */
 static void
@@ -579,26 +425,175 @@ preview_config_csc(struct isp_prev_device *prev,
 }
 
 /*
- * preview_update_contrast - Updates the contrast.
- * @contrast: Pointer to hold the current programmed contrast value.
+ * preview_config_yc_range - Configure the max and min Y and C values
+ */
+static void
+preview_config_yc_range(struct isp_prev_device *prev,
+			const struct prev_params *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_yclimit *yc = &params->yclimit;
+
+	isp_reg_writel(isp,
+		       yc->maxC << ISPPRV_SETUP_YC_MAXC_SHIFT |
+		       yc->maxY << ISPPRV_SETUP_YC_MAXY_SHIFT |
+		       yc->minC << ISPPRV_SETUP_YC_MINC_SHIFT |
+		       yc->minY << ISPPRV_SETUP_YC_MINY_SHIFT,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SETUP_YC);
+}
+
+/*
+ * preview_config_dcor - Configure Couplet Defect Correction
+ */
+static void
+preview_config_dcor(struct isp_prev_device *prev,
+		    const struct prev_params *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_dcor *dcor = &params->dcor;
+
+	isp_reg_writel(isp, dcor->detect_correct[0],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR0);
+	isp_reg_writel(isp, dcor->detect_correct[1],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR1);
+	isp_reg_writel(isp, dcor->detect_correct[2],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR2);
+	isp_reg_writel(isp, dcor->detect_correct[3],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR3);
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			ISPPRV_PCR_DCCOUP,
+			dcor->couplet_mode_en ? ISPPRV_PCR_DCCOUP : 0);
+}
+
+/*
+ * preview_enable_dcor - Enable/disable Couplet Defect Correction
+ */
+static void preview_enable_dcor(struct isp_prev_device *prev, bool enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DCOREN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DCOREN);
+}
+
+/*
+ * preview_enable_gammabypass - Enable/disable Gamma Bypass
  *
- * Value should be programmed before enabling the module.
+ * When gamma bypass is enabled, the output of the gamma correction is the 8 MSB
+ * of the 10-bit input .
  */
 static void
-preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
+preview_enable_gammabypass(struct isp_prev_device *prev, bool enable)
 {
-	struct prev_params *params;
-	unsigned long flags;
+	struct isp_device *isp = to_isp_device(prev);
 
-	spin_lock_irqsave(&prev->params.lock, flags);
-	params = (prev->params.active & OMAP3ISP_PREV_CONTRAST)
-	       ? &prev->params.params[0] : &prev->params.params[1];
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_GAMMA_BYPASS);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_GAMMA_BYPASS);
+}
 
-	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
-		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
-		params->update |= OMAP3ISP_PREV_CONTRAST;
+/*
+ * preview_enable_drkframe_capture - Enable/disable Dark Frame Capture
+ */
+static void
+preview_enable_drkframe_capture(struct isp_prev_device *prev, bool enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFCAP);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFCAP);
+}
+
+/*
+ * preview_enable_drkframe - Enable/disable Dark Frame Subtraction
+ */
+static void preview_enable_drkframe(struct isp_prev_device *prev, bool enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFEN);
+}
+
+/*
+ * preview_config_noisefilter - Configure the Noise Filter
+ */
+static void
+preview_config_noisefilter(struct isp_prev_device *prev,
+			   const struct prev_params *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_nf *nf = &params->nf;
+	unsigned int i;
+
+	isp_reg_writel(isp, nf->spread, OMAP3_ISP_IOMEM_PREV, ISPPRV_NF);
+	isp_reg_writel(isp, ISPPRV_NF_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_NF_TBL_SIZE; i++) {
+		isp_reg_writel(isp, nf->table[i],
+			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
 	}
-	spin_unlock_irqrestore(&prev->params.lock, flags);
+}
+
+/*
+ * preview_enable_noisefilter - Enable/disable the Noise Filter
+ */
+static void
+preview_enable_noisefilter(struct isp_prev_device *prev, bool enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_NFEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_NFEN);
+}
+
+/*
+ * preview_config_gammacorrn - Configure the Gamma Correction tables
+ */
+static void
+preview_config_gammacorrn(struct isp_prev_device *prev,
+			  const struct prev_params *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_gtables *gt = &params->gamma;
+	unsigned int i;
+
+	isp_reg_writel(isp, ISPPRV_REDGAMMA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
+		isp_reg_writel(isp, gt->red[i], OMAP3_ISP_IOMEM_PREV,
+			       ISPPRV_SET_TBL_DATA);
+
+	isp_reg_writel(isp, ISPPRV_GREENGAMMA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
+		isp_reg_writel(isp, gt->green[i], OMAP3_ISP_IOMEM_PREV,
+			       ISPPRV_SET_TBL_DATA);
+
+	isp_reg_writel(isp, ISPPRV_BLUEGAMMA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
+		isp_reg_writel(isp, gt->blue[i], OMAP3_ISP_IOMEM_PREV,
+			       ISPPRV_SET_TBL_DATA);
 }
 
 /*
@@ -618,57 +613,62 @@ preview_config_contrast(struct isp_prev_device *prev,
 }
 
 /*
- * preview_update_brightness - Updates the brightness in preview module.
- * @brightness: Pointer to hold the current programmed brightness value.
+ * preview_config_brightness - Configure the Brightness
+ */
+static void
+preview_config_brightness(struct isp_prev_device *prev,
+			  const struct prev_params *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT,
+			0xff << ISPPRV_CNT_BRT_BRT_SHIFT,
+			params->brightness << ISPPRV_CNT_BRT_BRT_SHIFT);
+}
+
+/*
+ * preview_update_contrast - Updates the contrast.
+ * @contrast: Pointer to hold the current programmed contrast value.
  *
+ * Value should be programmed before enabling the module.
  */
 static void
-preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
+preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
 {
 	struct prev_params *params;
 	unsigned long flags;
 
 	spin_lock_irqsave(&prev->params.lock, flags);
-	params = (prev->params.active & OMAP3ISP_PREV_BRIGHTNESS)
+	params = (prev->params.active & OMAP3ISP_PREV_CONTRAST)
 	       ? &prev->params.params[0] : &prev->params.params[1];
 
-	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
-		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
-		params->update |= OMAP3ISP_PREV_BRIGHTNESS;
+	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
+		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
+		params->update |= OMAP3ISP_PREV_CONTRAST;
 	}
 	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 /*
- * preview_config_brightness - Configure the Brightness
+ * preview_update_brightness - Updates the brightness in preview module.
+ * @brightness: Pointer to hold the current programmed brightness value.
+ *
  */
 static void
-preview_config_brightness(struct isp_prev_device *prev,
-			  const struct prev_params *params)
+preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
 {
-	struct isp_device *isp = to_isp_device(prev);
-
-	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT,
-			0xff << ISPPRV_CNT_BRT_BRT_SHIFT,
-			params->brightness << ISPPRV_CNT_BRT_BRT_SHIFT);
-}
+	struct prev_params *params;
+	unsigned long flags;
 
-/*
- * preview_config_yc_range - Configure the max and min Y and C values
- */
-static void
-preview_config_yc_range(struct isp_prev_device *prev,
-			const struct prev_params *params)
-{
-	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_yclimit *yc = &params->yclimit;
+	spin_lock_irqsave(&prev->params.lock, flags);
+	params = (prev->params.active & OMAP3ISP_PREV_BRIGHTNESS)
+	       ? &prev->params.params[0] : &prev->params.params[1];
 
-	isp_reg_writel(isp,
-		       yc->maxC << ISPPRV_SETUP_YC_MAXC_SHIFT |
-		       yc->maxY << ISPPRV_SETUP_YC_MAXY_SHIFT |
-		       yc->minC << ISPPRV_SETUP_YC_MINC_SHIFT |
-		       yc->minY << ISPPRV_SETUP_YC_MINY_SHIFT,
-		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SETUP_YC);
+	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
+		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
+		params->update |= OMAP3ISP_PREV_BRIGHTNESS;
+	}
+	spin_unlock_irqrestore(&prev->params.lock, flags);
 }
 
 static u32
-- 
1.7.8.6

