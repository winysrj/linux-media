Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52118 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2DPN3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 8/9] omap3isp: preview: Simplify configuration parameters access
Date: Mon, 16 Apr 2012 15:29:53 +0200
Message-Id: <1334582994-6967-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a large switch/case statement to return offsets to and
sizes of individual preview engine parameters in the parameters and
configuration structures, store the information in the update_attrs
table and use it at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |  134 +++++++++++++---------------
 1 files changed, 62 insertions(+), 72 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index b75b675..e12df2c 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -725,44 +725,77 @@ preview_config_yc_range(struct isp_prev_device *prev, const void *yclimit)
 struct preview_update {
 	void (*config)(struct isp_prev_device *, const void *);
 	void (*enable)(struct isp_prev_device *, u8);
+	unsigned int param_offset;
+	unsigned int param_size;
+	unsigned int config_offset;
 	bool skip;
 };
 
 /* Keep the array indexed by the OMAP3ISP_PREV_* bit number. */
-static struct preview_update update_attrs[] = {
+static const struct preview_update update_attrs[] = {
 	/* OMAP3ISP_PREV_LUMAENH */ {
 		preview_config_luma_enhancement,
 		preview_enable_luma_enhancement,
+		offsetof(struct prev_params, luma),
+		FIELD_SIZEOF(struct prev_params, luma),
+		offsetof(struct omap3isp_prev_update_config, luma),
 	}, /* OMAP3ISP_PREV_INVALAW */ {
 		NULL,
 		preview_enable_invalaw,
 	}, /* OMAP3ISP_PREV_HRZ_MED */ {
 		preview_config_hmed,
 		preview_enable_hmed,
+		offsetof(struct prev_params, hmed),
+		FIELD_SIZEOF(struct prev_params, hmed),
+		offsetof(struct omap3isp_prev_update_config, hmed),
 	}, /* OMAP3ISP_PREV_CFA */ {
 		preview_config_cfa,
 		preview_enable_cfa,
+		offsetof(struct prev_params, cfa),
+		FIELD_SIZEOF(struct prev_params, cfa),
+		offsetof(struct omap3isp_prev_update_config, cfa),
 	}, /* OMAP3ISP_PREV_CHROMA_SUPP */ {
 		preview_config_chroma_suppression,
 		preview_enable_chroma_suppression,
+		offsetof(struct prev_params, csup),
+		FIELD_SIZEOF(struct prev_params, csup),
+		offsetof(struct omap3isp_prev_update_config, csup),
 	}, /* OMAP3ISP_PREV_WB */ {
 		preview_config_whitebalance,
 		NULL,
+		offsetof(struct prev_params, wbal),
+		FIELD_SIZEOF(struct prev_params, wbal),
+		offsetof(struct omap3isp_prev_update_config, wbal),
 	}, /* OMAP3ISP_PREV_BLKADJ */ {
 		preview_config_blkadj,
 		NULL,
+		offsetof(struct prev_params, blkadj),
+		FIELD_SIZEOF(struct prev_params, blkadj),
+		offsetof(struct omap3isp_prev_update_config, blkadj),
 	}, /* OMAP3ISP_PREV_RGB2RGB */ {
 		preview_config_rgb_blending,
 		NULL,
+		offsetof(struct prev_params, rgb2rgb),
+		FIELD_SIZEOF(struct prev_params, rgb2rgb),
+		offsetof(struct omap3isp_prev_update_config, rgb2rgb),
 	}, /* OMAP3ISP_PREV_COLOR_CONV */ {
 		preview_config_rgb_to_ycbcr,
 		NULL,
+		offsetof(struct prev_params, csc),
+		FIELD_SIZEOF(struct prev_params, csc),
+		offsetof(struct omap3isp_prev_update_config, csc),
 	}, /* OMAP3ISP_PREV_YC_LIMIT */ {
 		preview_config_yc_range,
 		NULL,
+		offsetof(struct prev_params, yclimit),
+		FIELD_SIZEOF(struct prev_params, yclimit),
+		offsetof(struct omap3isp_prev_update_config, yclimit),
 	}, /* OMAP3ISP_PREV_DEFECT_COR */ {
 		preview_config_dcor,
 		preview_enable_dcor,
+		offsetof(struct prev_params, dcor),
+		FIELD_SIZEOF(struct prev_params, dcor),
+		offsetof(struct omap3isp_prev_update_config, dcor),
 	}, /* OMAP3ISP_PREV_GAMMABYPASS */ {
 		NULL,
 		preview_enable_gammabypass,
@@ -778,15 +811,25 @@ static struct preview_update update_attrs[] = {
 	}, /* OMAP3ISP_PREV_NF */ {
 		preview_config_noisefilter,
 		preview_enable_noisefilter,
+		offsetof(struct prev_params, nf),
+		FIELD_SIZEOF(struct prev_params, nf),
+		offsetof(struct omap3isp_prev_update_config, nf),
 	}, /* OMAP3ISP_PREV_GAMMA */ {
 		preview_config_gammacorrn,
 		NULL,
+		offsetof(struct prev_params, gamma),
+		FIELD_SIZEOF(struct prev_params, gamma),
+		offsetof(struct omap3isp_prev_update_config, gamma),
 	}, /* OMAP3ISP_PREV_CONTRAST */ {
 		preview_config_contrast,
-		NULL, true,
+		NULL,
+		offsetof(struct prev_params, contrast),
+		0, true,
 	}, /* OMAP3ISP_PREV_BRIGHTNESS */ {
 		preview_config_brightness,
-		NULL, true,
+		NULL,
+		offsetof(struct prev_params, brightness),
+		0, true,
 	},
 };
 
@@ -803,75 +846,22 @@ static struct preview_update update_attrs[] = {
 static u32
 __preview_get_ptrs(struct prev_params *params, void **param,
 		   struct omap3isp_prev_update_config *configs,
-		   void __user **config, u32 bit)
+		   void __user **config, unsigned int index)
 {
-#define CHKARG(cfgs, cfg, field)				\
-	if (cfgs && cfg) {					\
-		*(cfg) = (cfgs)->field;				\
-	}
+	const struct preview_update *info = &update_attrs[index];
 
-	switch (bit) {
-	case OMAP3ISP_PREV_HRZ_MED:
-		*param = &params->hmed;
-		CHKARG(configs, config, hmed)
-		return sizeof(params->hmed);
-	case OMAP3ISP_PREV_NF:
-		*param = &params->nf;
-		CHKARG(configs, config, nf)
-		return sizeof(params->nf);
-		break;
-	case OMAP3ISP_PREV_CFA:
-		*param = &params->cfa;
-		CHKARG(configs, config, cfa)
-		return sizeof(params->cfa);
-	case OMAP3ISP_PREV_LUMAENH:
-		*param = &params->luma;
-		CHKARG(configs, config, luma)
-		return sizeof(params->luma);
-	case OMAP3ISP_PREV_CHROMA_SUPP:
-		*param = &params->csup;
-		CHKARG(configs, config, csup)
-		return sizeof(params->csup);
-	case OMAP3ISP_PREV_DEFECT_COR:
-		*param = &params->dcor;
-		CHKARG(configs, config, dcor)
-		return sizeof(params->dcor);
-	case OMAP3ISP_PREV_BLKADJ:
-		*param = &params->blkadj;
-		CHKARG(configs, config, blkadj)
-		return sizeof(params->blkadj);
-	case OMAP3ISP_PREV_YC_LIMIT:
-		*param = &params->yclimit;
-		CHKARG(configs, config, yclimit)
-		return sizeof(params->yclimit);
-	case OMAP3ISP_PREV_RGB2RGB:
-		*param = &params->rgb2rgb;
-		CHKARG(configs, config, rgb2rgb)
-		return sizeof(params->rgb2rgb);
-	case OMAP3ISP_PREV_COLOR_CONV:
-		*param = &params->csc;
-		CHKARG(configs, config, csc)
-		return sizeof(params->csc);
-	case OMAP3ISP_PREV_WB:
-		*param = &params->wbal;
-		CHKARG(configs, config, wbal)
-		return sizeof(params->wbal);
-	case OMAP3ISP_PREV_GAMMA:
-		*param = &params->gamma;
-		CHKARG(configs, config, gamma)
-		return sizeof(params->gamma);
-	case OMAP3ISP_PREV_CONTRAST:
-		*param = &params->contrast;
-		return 0;
-	case OMAP3ISP_PREV_BRIGHTNESS:
-		*param = &params->brightness;
-		return 0;
-	default:
+	if (index >= ARRAY_SIZE(update_attrs)) {
+		if (config)
+			*config = NULL;
 		*param = NULL;
-		*config = NULL;
-		break;
+		return 0;
 	}
-	return 0;
+
+	if (configs && config)
+		*config = *(void **)((void *)configs + info->config_offset);
+
+	*param = (void *)params + info->param_offset;
+	return info->param_size;
 }
 
 /*
@@ -886,8 +876,8 @@ __preview_get_ptrs(struct prev_params *params, void **param,
 static int preview_config(struct isp_prev_device *prev,
 			  struct omap3isp_prev_update_config *cfg)
 {
+	const struct preview_update *attr;
 	struct prev_params *params;
-	struct preview_update *attr;
 	int i, bit, rval = 0;
 
 	params = &prev->params;
@@ -913,7 +903,7 @@ static int preview_config(struct isp_prev_device *prev,
 			void *to = NULL, __user *from = NULL;
 			unsigned long sz = 0;
 
-			sz = __preview_get_ptrs(params, &to, cfg, &from, bit);
+			sz = __preview_get_ptrs(params, &to, cfg, &from, i);
 			if (to && from && sz) {
 				if (copy_from_user(to, from, sz)) {
 					rval = -EFAULT;
@@ -941,7 +931,7 @@ static int preview_config(struct isp_prev_device *prev,
 static void preview_setup_hw(struct isp_prev_device *prev)
 {
 	struct prev_params *params = &prev->params;
-	struct preview_update *attr;
+	const struct preview_update *attr;
 	unsigned int bit;
 	unsigned int i;
 	void *param_ptr;
@@ -959,7 +949,7 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 		if (params->features & bit) {
 			if (attr->config) {
 				__preview_get_ptrs(params, &param_ptr, NULL,
-						      NULL, bit);
+						   NULL, i);
 				attr->config(prev, param_ptr);
 			}
 			if (attr->enable)
-- 
1.7.3.4

