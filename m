Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32909 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab1JRVOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 17:14:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/3] omap3isp: preview: Remove horizontal averager support
Date: Tue, 18 Oct 2011 23:14:55 +0200
Message-Id: <1318972497-8367-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The horizontal averager isn't used and will get in the way when
implementing cropping support on the input pad. Remove it, it can be
added back later if needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   18 ++----------------
 drivers/media/video/omap3isp/isppreview.h |    7 -------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index b381835..c920c1e 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1228,7 +1228,6 @@ static void preview_init_params(struct isp_prev_device *prev)
 	/* Init values */
 	params->contrast = ISPPRV_CONTRAST_DEF * ISPPRV_CONTRAST_UNITS;
 	params->brightness = ISPPRV_BRIGHT_DEF * ISPPRV_BRIGHT_UNITS;
-	params->average = NO_AVE;
 	params->cfa.format = OMAP3ISP_CFAFMT_BAYER;
 	memcpy(params->cfa.table, cfa_coef_table,
 	       sizeof(params->cfa.table));
@@ -1297,7 +1296,6 @@ static void preview_configure(struct isp_prev_device *prev)
 	struct isp_device *isp = to_isp_device(prev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int max_out_width;
-	unsigned int format_avg;
 
 	preview_setup_hw(prev);
 
@@ -1337,8 +1335,7 @@ static void preview_configure(struct isp_prev_device *prev)
 
 	max_out_width = preview_max_out_width(prev);
 
-	format_avg = fls(DIV_ROUND_UP(format->width, max_out_width) - 1);
-	preview_config_averager(prev, format_avg);
+	preview_config_averager(prev, 0);
 	preview_config_ycpos(prev, format->code);
 }
 
@@ -1642,7 +1639,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 		 */
 		if (prev->input == PREVIEW_INPUT_MEMORY) {
 			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_WIDTH,
-					     max_out_width * 8);
+					     max_out_width);
 			fmt->height = clamp_t(u32, fmt->height, PREV_MIN_HEIGHT,
 					      PREV_MAX_HEIGHT);
 		}
@@ -1689,17 +1686,6 @@ static void preview_try_format(struct isp_prev_device *prev,
 		if (prev->input == PREVIEW_INPUT_CCDC)
 			fmt->width -= 4;
 
-		/* The preview module can output a maximum of 3312 pixels
-		 * horizontally due to fixed memory-line sizes. Compute the
-		 * horizontal averaging factor accordingly. Note that the limit
-		 * applies to the noise filter and CFA interpolation blocks, so
-		 * it doesn't take cropping by further blocks into account.
-		 *
-		 * ES 1.0 hardware revision is limited to 1280 pixels
-		 * horizontally.
-		 */
-		fmt->width >>= fls(DIV_ROUND_UP(fmt->width, max_out_width) - 1);
-
 		/* Assume that all blocks are enabled and crop pixels and lines
 		 * accordingly. See preview_config_input_size() for more
 		 * information.
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index fa943bd..272a44a 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -45,11 +45,6 @@
 #define ISPPRV_CONTRAST_HIGH		0xFF
 #define ISPPRV_CONTRAST_UNITS		0x1
 
-#define NO_AVE				0x0
-#define AVE_2_PIX			0x1
-#define AVE_4_PIX			0x2
-#define AVE_8_PIX			0x3
-
 /* Features list */
 #define PREV_LUMA_ENHANCE		OMAP3ISP_PREV_LUMAENH
 #define PREV_INVERSE_ALAW		OMAP3ISP_PREV_INVALAW
@@ -106,7 +101,6 @@ enum preview_ycpos_mode {
  * @rgb2ycbcr: RGB to ycbcr parameters.
  * @hmed: Horizontal median filter.
  * @yclimit: YC limits parameters.
- * @average: Downsampling rate for averager.
  * @contrast: Contrast.
  * @brightness: Brightness.
  */
@@ -124,7 +118,6 @@ struct prev_params {
 	struct omap3isp_prev_csc rgb2ycbcr;
 	struct omap3isp_prev_hmed hmed;
 	struct omap3isp_prev_yclimit yclimit;
-	u8 average;
 	u8 contrast;
 	u8 brightness;
 };
-- 
1.7.3.4

