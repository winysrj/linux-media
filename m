Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52118 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2DPN3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 6/9] omap3isp: preview: Remove update_attrs feature_bit field
Date: Mon, 16 Apr 2012 15:29:51 +0200
Message-Id: <1334582994-6967-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The feature_bit is always equal to 1 << array position, remove it and
compute the value dynamically.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  107 +++++++++++++++--------------
 1 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index da031c1..c487995 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -723,70 +723,71 @@ preview_config_yc_range(struct isp_prev_device *prev, const void *yclimit)
 
 /* preview parameters update structure */
 struct preview_update {
-	int feature_bit;
 	void (*config)(struct isp_prev_device *, const void *);
 	void (*enable)(struct isp_prev_device *, u8);
 	bool skip;
 };
 
+/* Keep the array indexed by the OMAP3ISP_PREV_* bit number. */
 static struct preview_update update_attrs[] = {
-	{OMAP3ISP_PREV_LUMAENH,
+	/* OMAP3ISP_PREV_LUMAENH */ {
 		preview_config_luma_enhancement,
-		preview_enable_luma_enhancement},
-	{OMAP3ISP_PREV_INVALAW,
+		preview_enable_luma_enhancement,
+	}, /* OMAP3ISP_PREV_INVALAW */ {
 		NULL,
-		preview_enable_invalaw},
-	{OMAP3ISP_PREV_HRZ_MED,
+		preview_enable_invalaw,
+	}, /* OMAP3ISP_PREV_HRZ_MED */ {
 		preview_config_hmed,
-		preview_enable_hmed},
-	{OMAP3ISP_PREV_CFA,
+		preview_enable_hmed,
+	}, /* OMAP3ISP_PREV_CFA */ {
 		preview_config_cfa,
-		preview_enable_cfa},
-	{OMAP3ISP_PREV_CHROMA_SUPP,
+		preview_enable_cfa,
+	}, /* OMAP3ISP_PREV_CHROMA_SUPP */ {
 		preview_config_chroma_suppression,
-		preview_enable_chroma_suppression},
-	{OMAP3ISP_PREV_WB,
+		preview_enable_chroma_suppression,
+	}, /* OMAP3ISP_PREV_WB */ {
 		preview_config_whitebalance,
-		NULL},
-	{OMAP3ISP_PREV_BLKADJ,
+		NULL,
+	}, /* OMAP3ISP_PREV_BLKADJ */ {
 		preview_config_blkadj,
-		NULL},
-	{OMAP3ISP_PREV_RGB2RGB,
+		NULL,
+	}, /* OMAP3ISP_PREV_RGB2RGB */ {
 		preview_config_rgb_blending,
-		NULL},
-	{OMAP3ISP_PREV_COLOR_CONV,
+		NULL,
+	}, /* OMAP3ISP_PREV_COLOR_CONV */ {
 		preview_config_rgb_to_ycbcr,
-		NULL},
-	{OMAP3ISP_PREV_YC_LIMIT,
+		NULL,
+	}, /* OMAP3ISP_PREV_YC_LIMIT */ {
 		preview_config_yc_range,
-		NULL},
-	{OMAP3ISP_PREV_DEFECT_COR,
+		NULL,
+	}, /* OMAP3ISP_PREV_DEFECT_COR */ {
 		preview_config_dcor,
-		preview_enable_dcor},
-	{OMAP3ISP_PREV_GAMMABYPASS,
+		preview_enable_dcor,
+	}, /* OMAP3ISP_PREV_GAMMABYPASS */ {
 		NULL,
-		preview_enable_gammabypass},
-	{OMAP3ISP_PREV_DRK_FRM_CAPTURE,
+		preview_enable_gammabypass,
+	}, /* OMAP3ISP_PREV_DRK_FRM_CAPTURE */ {
 		NULL,
-		preview_enable_drkframe_capture},
-	{OMAP3ISP_PREV_DRK_FRM_SUBTRACT,
+		preview_enable_drkframe_capture,
+	}, /* OMAP3ISP_PREV_DRK_FRM_SUBTRACT */ {
 		NULL,
-		preview_enable_drkframe},
-	{OMAP3ISP_PREV_LENS_SHADING,
+		preview_enable_drkframe,
+	}, /* OMAP3ISP_PREV_LENS_SHADING */ {
 		preview_config_drkf_shadcomp,
-		preview_enable_drkframe},
-	{OMAP3ISP_PREV_NF,
+		preview_enable_drkframe,
+	}, /* OMAP3ISP_PREV_NF */ {
 		preview_config_noisefilter,
-		preview_enable_noisefilter},
-	{OMAP3ISP_PREV_GAMMA,
+		preview_enable_noisefilter,
+	}, /* OMAP3ISP_PREV_GAMMA */ {
 		preview_config_gammacorrn,
-		NULL},
-	{OMAP3ISP_PREV_CONTRAST,
+		NULL,
+	}, /* OMAP3ISP_PREV_CONTRAST */ {
 		preview_config_contrast,
-		NULL, true},
-	{OMAP3ISP_PREV_BRIGHTNESS,
+		NULL, true,
+	}, /* OMAP3ISP_PREV_BRIGHTNESS */ {
 		preview_config_brightness,
-		NULL, true},
+		NULL, true,
+	},
 };
 
 /*
@@ -903,30 +904,28 @@ static int preview_config(struct isp_prev_device *prev,
 
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
 		attr = &update_attrs[i];
-		bit = 0;
+		bit = 1 << i;
 
-		if (attr->skip || !(cfg->update & attr->feature_bit))
+		if (attr->skip || !(cfg->update & bit))
 			continue;
 
-		bit = cfg->flag & attr->feature_bit;
-		if (bit) {
+		if (cfg->flag & bit) {
 			void *to = NULL, __user *from = NULL;
 			unsigned long sz = 0;
 
-			sz = __preview_get_ptrs(params, &to, cfg, &from,
-						   bit);
+			sz = __preview_get_ptrs(params, &to, cfg, &from, bit);
 			if (to && from && sz) {
 				if (copy_from_user(to, from, sz)) {
 					rval = -EFAULT;
 					break;
 				}
 			}
-			params->features |= attr->feature_bit;
+			params->features |= bit;
 		} else {
-			params->features &= ~attr->feature_bit;
+			params->features &= ~bit;
 		}
 
-		prev->update |= attr->feature_bit;
+		prev->update |= bit;
 	}
 
 	prev->shadow_update = 0;
@@ -943,7 +942,8 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 {
 	struct prev_params *params = &prev->params;
 	struct preview_update *attr;
-	int i, bit;
+	unsigned int bit;
+	unsigned int i;
 	void *param_ptr;
 
 	if (prev->update == 0)
@@ -951,11 +951,12 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
 		attr = &update_attrs[i];
+		bit = 1 << i;
 
-		if (!(prev->update & attr->feature_bit))
+		if (!(prev->update & bit))
 			continue;
-		bit = params->features & attr->feature_bit;
-		if (bit) {
+
+		if (params->features & bit) {
 			if (attr->config) {
 				__preview_get_ptrs(params, &param_ptr, NULL,
 						      NULL, bit);
@@ -967,7 +968,7 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 			if (attr->enable)
 				attr->enable(prev, 0);
 
-		prev->update &= ~attr->feature_bit;
+		prev->update &= ~bit;
 	}
 }
 
-- 
1.7.3.4

