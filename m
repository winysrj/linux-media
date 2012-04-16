Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52119 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2DPN3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 5/9] omap3isp: preview: Merge configuration and feature bits
Date: Mon, 16 Apr 2012 15:29:50 +0200
Message-Id: <1334582994-6967-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The preview engine parameters are referenced by a value suitable for
being used in a bitmask. Two macros named OMAP3ISP_PREV_* and PREV_* are
declared for each parameter and are used interchangeably. Remove the
private macro.

Replace the configuration bit field in the parameter update attributes
structure with a boolean that indicates whether the parameter can be
updated through the preview engine configuration ioctl.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  103 +++++++++++++++--------------
 drivers/media/video/omap3isp/isppreview.h |   26 +------
 2 files changed, 57 insertions(+), 72 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 4e803a3..da031c1 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -653,7 +653,7 @@ preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
 
 	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
 		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
-		prev->update |= PREV_CONTRAST;
+		prev->update |= OMAP3ISP_PREV_CONTRAST;
 	}
 }
 
@@ -685,7 +685,7 @@ preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
 
 	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
 		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
-		prev->update |= PREV_BRIGHTNESS;
+		prev->update |= OMAP3ISP_PREV_BRIGHTNESS;
 	}
 }
 
@@ -723,70 +723,70 @@ preview_config_yc_range(struct isp_prev_device *prev, const void *yclimit)
 
 /* preview parameters update structure */
 struct preview_update {
-	int cfg_bit;
 	int feature_bit;
 	void (*config)(struct isp_prev_device *, const void *);
 	void (*enable)(struct isp_prev_device *, u8);
+	bool skip;
 };
 
 static struct preview_update update_attrs[] = {
-	{OMAP3ISP_PREV_LUMAENH, PREV_LUMA_ENHANCE,
+	{OMAP3ISP_PREV_LUMAENH,
 		preview_config_luma_enhancement,
 		preview_enable_luma_enhancement},
-	{OMAP3ISP_PREV_INVALAW, PREV_INVERSE_ALAW,
+	{OMAP3ISP_PREV_INVALAW,
 		NULL,
 		preview_enable_invalaw},
-	{OMAP3ISP_PREV_HRZ_MED, PREV_HORZ_MEDIAN_FILTER,
+	{OMAP3ISP_PREV_HRZ_MED,
 		preview_config_hmed,
 		preview_enable_hmed},
-	{OMAP3ISP_PREV_CFA, PREV_CFA,
+	{OMAP3ISP_PREV_CFA,
 		preview_config_cfa,
 		preview_enable_cfa},
-	{OMAP3ISP_PREV_CHROMA_SUPP, PREV_CHROMA_SUPPRESS,
+	{OMAP3ISP_PREV_CHROMA_SUPP,
 		preview_config_chroma_suppression,
 		preview_enable_chroma_suppression},
-	{OMAP3ISP_PREV_WB, PREV_WB,
+	{OMAP3ISP_PREV_WB,
 		preview_config_whitebalance,
 		NULL},
-	{OMAP3ISP_PREV_BLKADJ, PREV_BLKADJ,
+	{OMAP3ISP_PREV_BLKADJ,
 		preview_config_blkadj,
 		NULL},
-	{OMAP3ISP_PREV_RGB2RGB, PREV_RGB2RGB,
+	{OMAP3ISP_PREV_RGB2RGB,
 		preview_config_rgb_blending,
 		NULL},
-	{OMAP3ISP_PREV_COLOR_CONV, PREV_COLOR_CONV,
+	{OMAP3ISP_PREV_COLOR_CONV,
 		preview_config_rgb_to_ycbcr,
 		NULL},
-	{OMAP3ISP_PREV_YC_LIMIT, PREV_YCLIMITS,
+	{OMAP3ISP_PREV_YC_LIMIT,
 		preview_config_yc_range,
 		NULL},
-	{OMAP3ISP_PREV_DEFECT_COR, PREV_DEFECT_COR,
+	{OMAP3ISP_PREV_DEFECT_COR,
 		preview_config_dcor,
 		preview_enable_dcor},
-	{OMAP3ISP_PREV_GAMMABYPASS, PREV_GAMMA_BYPASS,
+	{OMAP3ISP_PREV_GAMMABYPASS,
 		NULL,
 		preview_enable_gammabypass},
-	{OMAP3ISP_PREV_DRK_FRM_CAPTURE, PREV_DARK_FRAME_CAPTURE,
+	{OMAP3ISP_PREV_DRK_FRM_CAPTURE,
 		NULL,
 		preview_enable_drkframe_capture},
-	{OMAP3ISP_PREV_DRK_FRM_SUBTRACT, PREV_DARK_FRAME_SUBTRACT,
+	{OMAP3ISP_PREV_DRK_FRM_SUBTRACT,
 		NULL,
 		preview_enable_drkframe},
-	{OMAP3ISP_PREV_LENS_SHADING, PREV_LENS_SHADING,
+	{OMAP3ISP_PREV_LENS_SHADING,
 		preview_config_drkf_shadcomp,
 		preview_enable_drkframe},
-	{OMAP3ISP_PREV_NF, PREV_NOISE_FILTER,
+	{OMAP3ISP_PREV_NF,
 		preview_config_noisefilter,
 		preview_enable_noisefilter},
-	{OMAP3ISP_PREV_GAMMA, PREV_GAMMA,
+	{OMAP3ISP_PREV_GAMMA,
 		preview_config_gammacorrn,
 		NULL},
-	{-1, PREV_CONTRAST,
+	{OMAP3ISP_PREV_CONTRAST,
 		preview_config_contrast,
-		NULL},
-	{-1, PREV_BRIGHTNESS,
+		NULL, true},
+	{OMAP3ISP_PREV_BRIGHTNESS,
 		preview_config_brightness,
-		NULL},
+		NULL, true},
 };
 
 /*
@@ -810,59 +810,59 @@ __preview_get_ptrs(struct prev_params *params, void **param,
 	}
 
 	switch (bit) {
-	case PREV_HORZ_MEDIAN_FILTER:
+	case OMAP3ISP_PREV_HRZ_MED:
 		*param = &params->hmed;
 		CHKARG(configs, config, hmed)
 		return sizeof(params->hmed);
-	case PREV_NOISE_FILTER:
+	case OMAP3ISP_PREV_NF:
 		*param = &params->nf;
 		CHKARG(configs, config, nf)
 		return sizeof(params->nf);
 		break;
-	case PREV_CFA:
+	case OMAP3ISP_PREV_CFA:
 		*param = &params->cfa;
 		CHKARG(configs, config, cfa)
 		return sizeof(params->cfa);
-	case PREV_LUMA_ENHANCE:
+	case OMAP3ISP_PREV_LUMAENH:
 		*param = &params->luma;
 		CHKARG(configs, config, luma)
 		return sizeof(params->luma);
-	case PREV_CHROMA_SUPPRESS:
+	case OMAP3ISP_PREV_CHROMA_SUPP:
 		*param = &params->csup;
 		CHKARG(configs, config, csup)
 		return sizeof(params->csup);
-	case PREV_DEFECT_COR:
+	case OMAP3ISP_PREV_DEFECT_COR:
 		*param = &params->dcor;
 		CHKARG(configs, config, dcor)
 		return sizeof(params->dcor);
-	case PREV_BLKADJ:
+	case OMAP3ISP_PREV_BLKADJ:
 		*param = &params->blk_adj;
 		CHKARG(configs, config, blkadj)
 		return sizeof(params->blk_adj);
-	case PREV_YCLIMITS:
+	case OMAP3ISP_PREV_YC_LIMIT:
 		*param = &params->yclimit;
 		CHKARG(configs, config, yclimit)
 		return sizeof(params->yclimit);
-	case PREV_RGB2RGB:
+	case OMAP3ISP_PREV_RGB2RGB:
 		*param = &params->rgb2rgb;
 		CHKARG(configs, config, rgb2rgb)
 		return sizeof(params->rgb2rgb);
-	case PREV_COLOR_CONV:
+	case OMAP3ISP_PREV_COLOR_CONV:
 		*param = &params->rgb2ycbcr;
 		CHKARG(configs, config, csc)
 		return sizeof(params->rgb2ycbcr);
-	case PREV_WB:
+	case OMAP3ISP_PREV_WB:
 		*param = &params->wbal;
 		CHKARG(configs, config, wbal)
 		return sizeof(params->wbal);
-	case PREV_GAMMA:
+	case OMAP3ISP_PREV_GAMMA:
 		*param = &params->gamma;
 		CHKARG(configs, config, gamma)
 		return sizeof(params->gamma);
-	case PREV_CONTRAST:
+	case OMAP3ISP_PREV_CONTRAST:
 		*param = &params->contrast;
 		return 0;
-	case PREV_BRIGHTNESS:
+	case OMAP3ISP_PREV_BRIGHTNESS:
 		*param = &params->brightness;
 		return 0;
 	default:
@@ -905,10 +905,10 @@ static int preview_config(struct isp_prev_device *prev,
 		attr = &update_attrs[i];
 		bit = 0;
 
-		if (attr->cfg_bit == -1 || !(cfg->update & attr->cfg_bit))
+		if (attr->skip || !(cfg->update & attr->feature_bit))
 			continue;
 
-		bit = cfg->flag & attr->cfg_bit;
+		bit = cfg->flag & attr->feature_bit;
 		if (bit) {
 			void *to = NULL, __user *from = NULL;
 			unsigned long sz = 0;
@@ -1038,23 +1038,24 @@ static void preview_config_input_size(struct isp_prev_device *prev)
 	unsigned int slv = prev->crop.top;
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 
-	if (params->features & PREV_CFA) {
+	if (params->features & OMAP3ISP_PREV_CFA) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
 		elv += 2;
 	}
-	if (params->features & (PREV_DEFECT_COR | PREV_NOISE_FILTER)) {
+	if (params->features & (OMAP3ISP_PREV_DEFECT_COR | OMAP3ISP_PREV_NF)) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
 		elv += 2;
 	}
-	if (params->features & PREV_HORZ_MEDIAN_FILTER) {
+	if (params->features & OMAP3ISP_PREV_HRZ_MED) {
 		sph -= 2;
 		eph += 2;
 	}
-	if (params->features & (PREV_CHROMA_SUPPRESS | PREV_LUMA_ENHANCE))
+	if (params->features & (OMAP3ISP_PREV_CHROMA_SUPP |
+				OMAP3ISP_PREV_LUMAENH))
 		sph -= 2;
 
 	isp_reg_writel(isp, (sph << ISPPRV_HORZ_INFO_SPH_SHIFT) | eph,
@@ -1189,7 +1190,7 @@ int omap3isp_preview_busy(struct isp_prev_device *prev)
  */
 void omap3isp_preview_restore_context(struct isp_device *isp)
 {
-	isp->isp_prev.update = PREV_FEATURES_END - 1;
+	isp->isp_prev.update = OMAP3ISP_PREV_FEATURES_END - 1;
 	preview_setup_hw(&isp->isp_prev);
 }
 
@@ -1292,12 +1293,14 @@ static void preview_init_params(struct isp_prev_device *prev)
 	params->yclimit.minY = ISPPRV_YC_MIN;
 	params->yclimit.maxY = ISPPRV_YC_MAX;
 
-	params->features = PREV_CFA | PREV_DEFECT_COR | PREV_NOISE_FILTER
-			 | PREV_GAMMA | PREV_BLKADJ | PREV_YCLIMITS
-			 | PREV_RGB2RGB | PREV_COLOR_CONV | PREV_WB
-			 | PREV_BRIGHTNESS | PREV_CONTRAST;
+	params->features = OMAP3ISP_PREV_CFA | OMAP3ISP_PREV_DEFECT_COR
+			 | OMAP3ISP_PREV_NF | OMAP3ISP_PREV_GAMMA
+			 | OMAP3ISP_PREV_BLKADJ | OMAP3ISP_PREV_YC_LIMIT
+			 | OMAP3ISP_PREV_RGB2RGB | OMAP3ISP_PREV_COLOR_CONV
+			 | OMAP3ISP_PREV_WB | OMAP3ISP_PREV_BRIGHTNESS
+			 | OMAP3ISP_PREV_CONTRAST;
 
-	prev->update = PREV_FEATURES_END - 1;
+	prev->update = OMAP3ISP_PREV_FEATURES_END - 1;
 }
 
 /*
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index b7f979a..a0d2807 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -45,28 +45,10 @@
 #define ISPPRV_CONTRAST_HIGH		0xFF
 #define ISPPRV_CONTRAST_UNITS		0x1
 
-/* Features list */
-#define PREV_LUMA_ENHANCE		OMAP3ISP_PREV_LUMAENH
-#define PREV_INVERSE_ALAW		OMAP3ISP_PREV_INVALAW
-#define PREV_HORZ_MEDIAN_FILTER		OMAP3ISP_PREV_HRZ_MED
-#define PREV_CFA			OMAP3ISP_PREV_CFA
-#define PREV_CHROMA_SUPPRESS		OMAP3ISP_PREV_CHROMA_SUPP
-#define PREV_WB				OMAP3ISP_PREV_WB
-#define PREV_BLKADJ			OMAP3ISP_PREV_BLKADJ
-#define PREV_RGB2RGB			OMAP3ISP_PREV_RGB2RGB
-#define PREV_COLOR_CONV			OMAP3ISP_PREV_COLOR_CONV
-#define PREV_YCLIMITS			OMAP3ISP_PREV_YC_LIMIT
-#define PREV_DEFECT_COR			OMAP3ISP_PREV_DEFECT_COR
-#define PREV_GAMMA_BYPASS		OMAP3ISP_PREV_GAMMABYPASS
-#define PREV_DARK_FRAME_CAPTURE		OMAP3ISP_PREV_DRK_FRM_CAPTURE
-#define PREV_DARK_FRAME_SUBTRACT	OMAP3ISP_PREV_DRK_FRM_SUBTRACT
-#define PREV_LENS_SHADING		OMAP3ISP_PREV_LENS_SHADING
-#define PREV_NOISE_FILTER		OMAP3ISP_PREV_NF
-#define PREV_GAMMA			OMAP3ISP_PREV_GAMMA
-
-#define PREV_CONTRAST			(1 << 17)
-#define PREV_BRIGHTNESS			(1 << 18)
-#define PREV_FEATURES_END		(1 << 19)
+/* Additional features not listed in linux/omap3isp.h */
+#define OMAP3ISP_PREV_CONTRAST		(1 << 17)
+#define OMAP3ISP_PREV_BRIGHTNESS	(1 << 18)
+#define OMAP3ISP_PREV_FEATURES_END	(1 << 19)
 
 enum preview_input_entity {
 	PREVIEW_INPUT_NONE,
-- 
1.7.3.4

