Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53536 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2GFNcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 09:32:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 3/6] omap3isp: preview: Pass a prev_params pointer to configuration functions
Date: Fri,  6 Jul 2012 15:32:46 +0200
Message-Id: <1341581569-8292-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using void pointers and offset arithmetics to compute a
pointer to configuration parameters in a generic way, pass the complete
parameters structure to configuration functions and let them access the
parameters they need.

Also modify the enable functions to use a bool enable parameter instead
of a u8.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  200 ++++++++++++-----------------
 1 files changed, 83 insertions(+), 117 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 4cdcc48..1ac48b7 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -157,11 +157,9 @@ static u32 luma_enhance_table[] = {
 };
 
 /*
- * preview_enable_invalaw - Enable/Disable Inverse A-Law module in Preview.
- * @enable: 1 - Reverse the A-Law done in CCDC.
+ * preview_enable_invalaw - Enable/disable Inverse A-Law decompression
  */
-static void
-preview_enable_invalaw(struct isp_prev_device *prev, u8 enable)
+static void preview_enable_invalaw(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -174,15 +172,10 @@ preview_enable_invalaw(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_drkframe_capture - Enable/Disable of the darkframe capture.
- * @prev -
- * @enable: 1 - Enable, 0 - Disable
- *
- * NOTE: PRV_WSDR_ADDR and PRV_WADD_OFFSET must be set also
- * The process is applied for each captured frame.
+ * preview_enable_drkframe_capture - Enable/disable Dark Frame Capture
  */
 static void
-preview_enable_drkframe_capture(struct isp_prev_device *prev, u8 enable)
+preview_enable_drkframe_capture(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -195,14 +188,9 @@ preview_enable_drkframe_capture(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_drkframe - Enable/Disable of the darkframe subtract.
- * @enable: 1 - Acquires memory bandwidth since the pixels in each frame is
- *          subtracted with the pixels in the current frame.
- *
- * The process is applied for each captured frame.
+ * preview_enable_drkframe - Enable/disable Dark Frame Subtraction
  */
-static void
-preview_enable_drkframe(struct isp_prev_device *prev, u8 enable)
+static void preview_enable_drkframe(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -215,11 +203,9 @@ preview_enable_drkframe(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_hmed - Enables/Disables of the Horizontal Median Filter.
- * @enable: 1 - Enables Horizontal Median Filter.
+ * preview_enable_hmed - Enable/disable the Horizontal Median Filter
  */
-static void
-preview_enable_hmed(struct isp_prev_device *prev, u8 enable)
+static void preview_enable_hmed(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -232,15 +218,13 @@ preview_enable_hmed(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_config_hmed - Configures the Horizontal Median Filter.
- * @prev_hmed: Structure containing the odd and even distance between the
- *             pixels in the image along with the filter threshold.
+ * preview_config_hmed - Configure the Horizontal Median Filter
  */
-static void
-preview_config_hmed(struct isp_prev_device *prev, const void *prev_hmed)
+static void preview_config_hmed(struct isp_prev_device *prev,
+				const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_hmed *hmed = prev_hmed;
+	const struct omap3isp_prev_hmed *hmed = &params->hmed;
 
 	isp_reg_writel(isp, (hmed->odddist == 1 ? 0 : ISPPRV_HMED_ODDDIST) |
 		       (hmed->evendist == 1 ? 0 : ISPPRV_HMED_EVENDIST) |
@@ -249,15 +233,14 @@ preview_config_hmed(struct isp_prev_device *prev, const void *prev_hmed)
 }
 
 /*
- * preview_config_noisefilter - Configures the Noise Filter.
- * @prev_nf: Structure containing the noisefilter table, strength to be used
- *           for the noise filter and the defect correction enable flag.
+ * preview_config_noisefilter - Configure the Noise Filter
  */
 static void
-preview_config_noisefilter(struct isp_prev_device *prev, const void *prev_nf)
+preview_config_noisefilter(struct isp_prev_device *prev,
+			   const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_nf *nf = prev_nf;
+	const struct omap3isp_prev_nf *nf = &params->nf;
 	unsigned int i;
 
 	isp_reg_writel(isp, nf->spread, OMAP3_ISP_IOMEM_PREV, ISPPRV_NF);
@@ -270,14 +253,14 @@ preview_config_noisefilter(struct isp_prev_device *prev, const void *prev_nf)
 }
 
 /*
- * preview_config_dcor - Configures the defect correction
- * @prev_dcor: Structure containing the defect correct thresholds
+ * preview_config_dcor - Configure Couplet Defect Correction
  */
 static void
-preview_config_dcor(struct isp_prev_device *prev, const void *prev_dcor)
+preview_config_dcor(struct isp_prev_device *prev,
+		    const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_dcor *dcor = prev_dcor;
+	const struct omap3isp_prev_dcor *dcor = &params->dcor;
 
 	isp_reg_writel(isp, dcor->detect_correct[0],
 		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR0);
@@ -293,15 +276,14 @@ preview_config_dcor(struct isp_prev_device *prev, const void *prev_dcor)
 }
 
 /*
- * preview_config_cfa - Configures the CFA Interpolation parameters.
- * @prev_cfa: Structure containing the CFA interpolation table, CFA format
- *            in the image, vertical and horizontal gradient threshold.
+ * preview_config_cfa - Configure CFA Interpolation
  */
 static void
-preview_config_cfa(struct isp_prev_device *prev, const void *prev_cfa)
+preview_config_cfa(struct isp_prev_device *prev,
+		   const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_cfa *cfa = prev_cfa;
+	const struct omap3isp_prev_cfa *cfa = &params->cfa;
 	unsigned int i;
 
 	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
@@ -323,14 +305,14 @@ preview_config_cfa(struct isp_prev_device *prev, const void *prev_cfa)
 }
 
 /*
- * preview_config_gammacorrn - Configures the Gamma Correction table values
- * @gtable: Structure containing the table for red, blue, green gamma table.
+ * preview_config_gammacorrn - Configure the Gamma Correction tables
  */
 static void
-preview_config_gammacorrn(struct isp_prev_device *prev, const void *gtable)
+preview_config_gammacorrn(struct isp_prev_device *prev,
+			  const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_gtables *gt = gtable;
+	const struct omap3isp_prev_gtables *gt = &params->gamma;
 	unsigned int i;
 
 	isp_reg_writel(isp, ISPPRV_REDGAMMA_TABLE_ADDR,
@@ -353,15 +335,14 @@ preview_config_gammacorrn(struct isp_prev_device *prev, const void *gtable)
 }
 
 /*
- * preview_config_luma_enhancement - Sets the Luminance Enhancement table.
- * @ytable: Structure containing the table for Luminance Enhancement table.
+ * preview_config_luma_enhancement - Configure the Luminance Enhancement table
  */
 static void
 preview_config_luma_enhancement(struct isp_prev_device *prev,
-				const void *ytable)
+				const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_luma *yt = ytable;
+	const struct omap3isp_prev_luma *yt = &params->luma;
 	unsigned int i;
 
 	isp_reg_writel(isp, ISPPRV_YENH_TABLE_ADDR,
@@ -373,16 +354,14 @@ preview_config_luma_enhancement(struct isp_prev_device *prev,
 }
 
 /*
- * preview_config_chroma_suppression - Configures the Chroma Suppression.
- * @csup: Structure containing the threshold value for suppression
- *        and the hypass filter enable flag.
+ * preview_config_chroma_suppression - Configure Chroma Suppression
  */
 static void
 preview_config_chroma_suppression(struct isp_prev_device *prev,
-				  const void *csup)
+				  const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_csup *cs = csup;
+	const struct omap3isp_prev_csup *cs = &params->csup;
 
 	isp_reg_writel(isp,
 		       cs->gain | (cs->thres << ISPPRV_CSUP_THRES_SHIFT) |
@@ -391,11 +370,10 @@ preview_config_chroma_suppression(struct isp_prev_device *prev,
 }
 
 /*
- * preview_enable_noisefilter - Enables/Disables the Noise Filter.
- * @enable: 1 - Enables the Noise Filter.
+ * preview_enable_noisefilter - Enable/disable the Noise Filter
  */
 static void
-preview_enable_noisefilter(struct isp_prev_device *prev, u8 enable)
+preview_enable_noisefilter(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -408,11 +386,9 @@ preview_enable_noisefilter(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_dcor - Enables/Disables the defect correction.
- * @enable: 1 - Enables the defect correction.
+ * preview_enable_dcor - Enable/disable Couplet Defect Correction
  */
-static void
-preview_enable_dcor(struct isp_prev_device *prev, u8 enable)
+static void preview_enable_dcor(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -425,12 +401,13 @@ preview_enable_dcor(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_gammabypass - Enables/Disables the GammaByPass
- * @enable: 1 - Bypasses Gamma - 10bit input is cropped to 8MSB.
- *          0 - Goes through Gamma Correction. input and output is 10bit.
+ * preview_enable_gammabypass - Enable/disable Gamma Bypass
+ *
+ * When gamma bypass is enabled, the output of the gamma correction is the 8 MSB
+ * of the 10-bit input .
  */
 static void
-preview_enable_gammabypass(struct isp_prev_device *prev, u8 enable)
+preview_enable_gammabypass(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -443,11 +420,10 @@ preview_enable_gammabypass(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_luma_enhancement - Enables/Disables Luminance Enhancement
- * @enable: 1 - Enable the Luminance Enhancement.
+ * preview_enable_luma_enhancement - Enable/disable Luminance Enhancement
  */
 static void
-preview_enable_luma_enhancement(struct isp_prev_device *prev, u8 enable)
+preview_enable_luma_enhancement(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -460,11 +436,10 @@ preview_enable_luma_enhancement(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_enable_chroma_suppression - Enables/Disables Chrominance Suppr.
- * @enable: 1 - Enable the Chrominance Suppression.
+ * preview_enable_chroma_suppression - Enable/disable Chrominance Suppression
  */
 static void
-preview_enable_chroma_suppression(struct isp_prev_device *prev, u8 enable)
+preview_enable_chroma_suppression(struct isp_prev_device *prev, bool enable)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
@@ -477,17 +452,16 @@ preview_enable_chroma_suppression(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_config_whitebalance - Configures the White Balance parameters.
- * @prev_wbal: Structure containing the digital gain and white balance
- *             coefficient.
+ * preview_config_whitebalance - Configure White Balance parameters
  *
  * Coefficient matrix always with default values.
  */
 static void
-preview_config_whitebalance(struct isp_prev_device *prev, const void *prev_wbal)
+preview_config_whitebalance(struct isp_prev_device *prev,
+			    const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_wbal *wbal = prev_wbal;
+	const struct omap3isp_prev_wbal *wbal = &params->wbal;
 	u32 val;
 
 	isp_reg_writel(isp, wbal->dgain, OMAP3_ISP_IOMEM_PREV, ISPPRV_WB_DGAIN);
@@ -519,15 +493,14 @@ preview_config_whitebalance(struct isp_prev_device *prev, const void *prev_wbal)
 }
 
 /*
- * preview_config_blkadj - Configures the Black Adjustment parameters.
- * @prev_blkadj: Structure containing the black adjustment towards red, green,
- *               blue.
+ * preview_config_blkadj - Configure Black Adjustment
  */
 static void
-preview_config_blkadj(struct isp_prev_device *prev, const void *prev_blkadj)
+preview_config_blkadj(struct isp_prev_device *prev,
+		      const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_blkadj *blkadj = prev_blkadj;
+	const struct omap3isp_prev_blkadj *blkadj = &params->blkadj;
 
 	isp_reg_writel(isp, (blkadj->blue << ISPPRV_BLKADJOFF_B_SHIFT) |
 		       (blkadj->green << ISPPRV_BLKADJOFF_G_SHIFT) |
@@ -536,15 +509,14 @@ preview_config_blkadj(struct isp_prev_device *prev, const void *prev_blkadj)
 }
 
 /*
- * preview_config_rgb_blending - Configures the RGB-RGB Blending matrix.
- * @rgb2rgb: Structure containing the rgb to rgb blending matrix and the rgb
- *           offset.
+ * preview_config_rgb_blending - Configure RGB-RGB Blending
  */
 static void
-preview_config_rgb_blending(struct isp_prev_device *prev, const void *rgb2rgb)
+preview_config_rgb_blending(struct isp_prev_device *prev,
+			    const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_rgbtorgb *rgbrgb = rgb2rgb;
+	const struct omap3isp_prev_rgbtorgb *rgbrgb = &params->rgb2rgb;
 	u32 val;
 
 	val = (rgbrgb->matrix[0][0] & 0xfff) << ISPPRV_RGB_MAT1_MTX_RR_SHIFT;
@@ -575,15 +547,14 @@ preview_config_rgb_blending(struct isp_prev_device *prev, const void *rgb2rgb)
 }
 
 /*
- * Configures the color space conversion (RGB toYCbYCr) matrix
- * @prev_csc: Structure containing the RGB to YCbYCr matrix and the
- *            YCbCr offset.
+ * preview_config_csc - Configure Color Space Conversion (RGB to YCbYCr)
  */
 static void
-preview_config_csc(struct isp_prev_device *prev, const void *prev_csc)
+preview_config_csc(struct isp_prev_device *prev,
+		   const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_csc *csc = prev_csc;
+	const struct omap3isp_prev_csc *csc = &params->csc;
 	u32 val;
 
 	val = (csc->matrix[0][0] & 0x3ff) << ISPPRV_CSC0_RY_SHIFT;
@@ -631,19 +602,19 @@ preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
 }
 
 /*
- * preview_config_contrast - Configures the Contrast.
- * @params: Contrast value (u8 pointer, U8Q0 format).
+ * preview_config_contrast - Configure the Contrast
  *
  * Value should be programmed before enabling the module.
  */
 static void
-preview_config_contrast(struct isp_prev_device *prev, const void *params)
+preview_config_contrast(struct isp_prev_device *prev,
+			const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
 	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT,
 			0xff << ISPPRV_CNT_BRT_CNT_SHIFT,
-			*(u8 *)params << ISPPRV_CNT_BRT_CNT_SHIFT);
+			params->contrast << ISPPRV_CNT_BRT_CNT_SHIFT);
 }
 
 /*
@@ -669,28 +640,28 @@ preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
 }
 
 /*
- * preview_config_brightness - Configures the brightness.
- * @params: Brightness value (u8 pointer, U8Q0 format).
+ * preview_config_brightness - Configure the Brightness
  */
 static void
-preview_config_brightness(struct isp_prev_device *prev, const void *params)
+preview_config_brightness(struct isp_prev_device *prev,
+			  const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
 
 	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT,
 			0xff << ISPPRV_CNT_BRT_BRT_SHIFT,
-			*(u8 *)params << ISPPRV_CNT_BRT_BRT_SHIFT);
+			params->brightness << ISPPRV_CNT_BRT_BRT_SHIFT);
 }
 
 /*
- * preview_config_yc_range - Configures the max and min Y and C values.
- * @yclimit: Structure containing the range of Y and C values.
+ * preview_config_yc_range - Configure the max and min Y and C values
  */
 static void
-preview_config_yc_range(struct isp_prev_device *prev, const void *yclimit)
+preview_config_yc_range(struct isp_prev_device *prev,
+			const struct prev_params *params)
 {
 	struct isp_device *isp = to_isp_device(prev);
-	const struct omap3isp_prev_yclimit *yc = yclimit;
+	const struct omap3isp_prev_yclimit *yc = &params->yclimit;
 
 	isp_reg_writel(isp,
 		       yc->maxC << ISPPRV_SETUP_YC_MAXC_SHIFT |
@@ -771,8 +742,8 @@ static void preview_params_switch(struct isp_prev_device *prev)
 
 /* preview parameters update structure */
 struct preview_update {
-	void (*config)(struct isp_prev_device *, const void *);
-	void (*enable)(struct isp_prev_device *, u8);
+	void (*config)(struct isp_prev_device *, const struct prev_params *);
+	void (*enable)(struct isp_prev_device *, bool);
 	unsigned int param_offset;
 	unsigned int param_size;
 	unsigned int config_offset;
@@ -871,13 +842,11 @@ static const struct preview_update update_attrs[] = {
 	}, /* OMAP3ISP_PREV_CONTRAST */ {
 		preview_config_contrast,
 		NULL,
-		offsetof(struct prev_params, contrast),
-		0, 0, true,
+		0, 0, 0, true,
 	}, /* OMAP3ISP_PREV_BRIGHTNESS */ {
 		preview_config_brightness,
 		NULL,
-		offsetof(struct prev_params, brightness),
-		0, 0, true,
+		0, 0, 0, true,
 	},
 };
 
@@ -972,7 +941,6 @@ static void preview_setup_hw(struct isp_prev_device *prev, u32 update,
 		const struct preview_update *attr = &update_attrs[i];
 		struct prev_params *params;
 		unsigned int bit = 1 << i;
-		void *param_ptr;
 
 		if (!(update & bit))
 			continue;
@@ -980,15 +948,13 @@ static void preview_setup_hw(struct isp_prev_device *prev, u32 update,
 		params = &prev->params.params[!(active & bit)];
 
 		if (params->features & bit) {
-			if (attr->config) {
-				param_ptr = (void *)params + attr->param_offset;
-				attr->config(prev, param_ptr);
-			}
+			if (attr->config)
+				attr->config(prev, params);
 			if (attr->enable)
-				attr->enable(prev, 1);
+				attr->enable(prev, true);
 		} else {
 			if (attr->enable)
-				attr->enable(prev, 0);
+				attr->enable(prev, false);
 		}
 	}
 }
-- 
1.7.8.6

