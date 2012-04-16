Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52119 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2DPN3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 7/9] omap3isp: preview: Rename prev_params fields to match userspace API
Date: Mon, 16 Apr 2012 15:29:52 +0200
Message-Id: <1334582994-6967-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the blk_adj and rgb2ycbcr fields to blkadj and csc respectively.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   16 ++++++++--------
 drivers/media/video/omap3isp/isppreview.h |    8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index c487995..b75b675 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -837,9 +837,9 @@ __preview_get_ptrs(struct prev_params *params, void **param,
 		CHKARG(configs, config, dcor)
 		return sizeof(params->dcor);
 	case OMAP3ISP_PREV_BLKADJ:
-		*param = &params->blk_adj;
+		*param = &params->blkadj;
 		CHKARG(configs, config, blkadj)
-		return sizeof(params->blk_adj);
+		return sizeof(params->blkadj);
 	case OMAP3ISP_PREV_YC_LIMIT:
 		*param = &params->yclimit;
 		CHKARG(configs, config, yclimit)
@@ -849,9 +849,9 @@ __preview_get_ptrs(struct prev_params *params, void **param,
 		CHKARG(configs, config, rgb2rgb)
 		return sizeof(params->rgb2rgb);
 	case OMAP3ISP_PREV_COLOR_CONV:
-		*param = &params->rgb2ycbcr;
+		*param = &params->csc;
 		CHKARG(configs, config, csc)
-		return sizeof(params->rgb2ycbcr);
+		return sizeof(params->csc);
 	case OMAP3ISP_PREV_WB:
 		*param = &params->wbal;
 		CHKARG(configs, config, wbal)
@@ -1284,11 +1284,11 @@ static void preview_init_params(struct isp_prev_device *prev)
 	params->wbal.coef1 = FLR_WBAL_COEF;
 	params->wbal.coef2 = FLR_WBAL_COEF;
 	params->wbal.coef3 = FLR_WBAL_COEF;
-	params->blk_adj.red = FLR_BLKADJ_RED;
-	params->blk_adj.green = FLR_BLKADJ_GREEN;
-	params->blk_adj.blue = FLR_BLKADJ_BLUE;
+	params->blkadj.red = FLR_BLKADJ_RED;
+	params->blkadj.green = FLR_BLKADJ_GREEN;
+	params->blkadj.blue = FLR_BLKADJ_BLUE;
 	params->rgb2rgb = flr_rgb2rgb;
-	params->rgb2ycbcr = flr_prev_csc;
+	params->csc = flr_prev_csc;
 	params->yclimit.minC = ISPPRV_YC_MIN;
 	params->yclimit.maxC = ISPPRV_YC_MAX;
 	params->yclimit.minY = ISPPRV_YC_MIN;
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index a0d2807..6ee8306 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -77,9 +77,9 @@ enum preview_ycpos_mode {
  * @dcor: Noise filter coefficients.
  * @gamma: Gamma coefficients.
  * @wbal: White Balance parameters.
- * @blk_adj: Black adjustment parameters.
+ * @blkadj: Black adjustment parameters.
  * @rgb2rgb: RGB blending parameters.
- * @rgb2ycbcr: RGB to ycbcr parameters.
+ * @csc: Color space conversion (RGB to YCbCr) parameters.
  * @hmed: Horizontal median filter.
  * @yclimit: YC limits parameters.
  * @contrast: Contrast.
@@ -94,9 +94,9 @@ struct prev_params {
 	struct omap3isp_prev_dcor dcor;
 	struct omap3isp_prev_gtables gamma;
 	struct omap3isp_prev_wbal wbal;
-	struct omap3isp_prev_blkadj blk_adj;
+	struct omap3isp_prev_blkadj blkadj;
 	struct omap3isp_prev_rgbtorgb rgb2rgb;
-	struct omap3isp_prev_csc rgb2ycbcr;
+	struct omap3isp_prev_csc csc;
 	struct omap3isp_prev_hmed hmed;
 	struct omap3isp_prev_yclimit yclimit;
 	u8 contrast;
-- 
1.7.3.4

