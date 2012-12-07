Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55411 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2LGLmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2012 06:42:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: preview: Lower the crop margins
Date: Fri,  7 Dec 2012 12:43:44 +0100
Message-Id: <1354880624-15528-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1354877797-28333-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1354877797-28333-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The preview engine includes filters that consume columns and lines as
part of their operation, thus resulting in a cropped image. To allow
turning those filters on/off during streaming without affecting the
output image size, the driver adds additional cropping to make the total
number of cropped columns and lines constant regardless of which filters
are enabled.

This process needlessly includes the CFA filter, as whether the filter
is enabled only depends on the sink pad format, which can't change
during streaming.

Exclude the CFA filter from the preview engine margins.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isppreview.c |   40 +++++++++++++------------
 1 files changed, 21 insertions(+), 19 deletions(-)

Changes since v1:

- Remove CFA-related crop rectangle mangling in preview_config_input_size()

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 691b92a..cd8831a 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -82,8 +82,9 @@ static struct omap3isp_prev_csc flr_prev_csc = {
  * The preview engine crops several rows and columns internally depending on
  * which filters are enabled. To avoid format changes when the filters are
  * enabled or disabled (which would prevent them from being turned on or off
- * during streaming), the driver assumes all the filters are enabled when
- * computing sink crop and source format limits.
+ * during streaming), the driver assumes all filters that can be configured
+ * during streaming are enabled when computing sink crop and source format
+ * limits.
  *
  * If a filter is disabled, additional cropping is automatically added at the
  * preview engine input by the driver to avoid overflow at line and frame end.
@@ -92,25 +93,23 @@ static struct omap3isp_prev_csc flr_prev_csc = {
  * Median filter		4 pixels
  * Noise filter,
  * Faulty pixels correction	4 pixels, 4 lines
- * CFA filter			4 pixels, 4 lines in Bayer mode
- *					  2 lines in other modes
  * Color suppression		2 pixels
  * or luma enhancement
  * -------------------------------------------------------------
- * Maximum total		14 pixels, 8 lines
+ * Maximum total		10 pixels, 4 lines
  *
  * The color suppression and luma enhancement filters are applied after bayer to
  * YUV conversion. They thus can crop one pixel on the left and one pixel on the
  * right side of the image without changing the color pattern. When both those
  * filters are disabled, the driver must crop the two pixels on the same side of
  * the image to avoid changing the bayer pattern. The left margin is thus set to
- * 8 pixels and the right margin to 6 pixels.
+ * 6 pixels and the right margin to 4 pixels.
  */
 
-#define PREV_MARGIN_LEFT	8
-#define PREV_MARGIN_RIGHT	6
-#define PREV_MARGIN_TOP		4
-#define PREV_MARGIN_BOTTOM	4
+#define PREV_MARGIN_LEFT	6
+#define PREV_MARGIN_RIGHT	4
+#define PREV_MARGIN_TOP		2
+#define PREV_MARGIN_BOTTOM	2
 
 #define PREV_MIN_IN_WIDTH	64
 #define PREV_MIN_IN_HEIGHT	8
@@ -1080,7 +1079,6 @@ static void preview_config_input_format(struct isp_prev_device *prev,
  */
 static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 {
-	const struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
 	struct isp_device *isp = to_isp_device(prev);
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
@@ -1088,14 +1086,6 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
-	if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
-	    format->code != V4L2_MBUS_FMT_Y10_1X10) {
-		sph -= 2;
-		eph += 2;
-		slv -= 2;
-		elv += 2;
-	}
-
 	features = (prev->params.params[0].features & active)
 		 | (prev->params.params[1].features & ~active);
 
@@ -1849,6 +1839,18 @@ static void preview_try_crop(struct isp_prev_device *prev,
 		right -= 2;
 	}
 
+	/* The CFA filter crops 4 lines and 4 columns in Bayer mode, and 2 lines
+	 * and no columns in other modes. Increase the margins based on the sink
+	 * format.
+	 */
+	if (sink->code != V4L2_MBUS_FMT_Y8_1X8 &&
+	    sink->code != V4L2_MBUS_FMT_Y10_1X10) {
+		left += 2;
+		right -= 2;
+		top += 2;
+		bottom -= 2;
+	}
+
 	/* Restrict left/top to even values to keep the Bayer pattern. */
 	crop->left &= ~1;
 	crop->top &= ~1;
-- 
Regards,

Laurent Pinchart

