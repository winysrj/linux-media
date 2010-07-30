Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51773 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 15/20] mt9m111: rewrite setup_rect, added soft_crop for smooth panning
Date: Fri, 30 Jul 2010 16:53:33 +0200
Message-Id: <1280501618-23634-16-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-soft_crop: enables the use of the sensors cropping abilities
instead of using real roi. This is needed to make use of the 'pan'
registers for smooth panning.

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |  106 +++++++++++++++++++++++++++++++---------
 1 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 161c751..11a68b6 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -87,12 +87,16 @@
  */
 #define MT9M111_OPER_MODE_CTRL		0x106
 #define MT9M111_OUTPUT_FORMAT_CTRL	0x108
+#define MT9M111_REDUCER_XPAN_B		0x19f
 #define MT9M111_REDUCER_XZOOM_B		0x1a0
 #define MT9M111_REDUCER_XSIZE_B		0x1a1
+#define MT9M111_REDUCER_YPAN_B		0x1a2
 #define MT9M111_REDUCER_YZOOM_B		0x1a3
 #define MT9M111_REDUCER_YSIZE_B		0x1a4
+#define MT9M111_REDUCER_XPAN_A		0x1a5
 #define MT9M111_REDUCER_XZOOM_A		0x1a6
 #define MT9M111_REDUCER_XSIZE_A		0x1a7
+#define MT9M111_REDUCER_YPAN_A		0x1a8
 #define MT9M111_REDUCER_YZOOM_A		0x1a9
 #define MT9M111_REDUCER_YSIZE_A		0x1aa
 
@@ -101,7 +105,8 @@
 
 #define MT9M111_OPMODE_AUTOEXPO_EN	(1 << 14)
 #define MT9M111_OPMODE_AUTOWHITEBAL_EN	(1 << 1)
-
+#define MT9M111_OUTFMT_CFA_1ST_ROW_BLUE	(1 << 1)
+#define MT9M111_OUTFMT_CFA_1ST_COL_R_B	(1 << 0)
 #define MT9M111_OUTFMT_PROCESSED_BAYER	(1 << 14)
 #define MT9M111_OUTFMT_BYPASS_IFP	(1 << 10)
 #define MT9M111_OUTFMT_INV_PIX_CLOCK	(1 << 9)
@@ -140,6 +145,11 @@
 #define MT9M111_DEF_HEIGHT	1024
 #define MT9M111_DEF_WIDTH	1280
 
+static int soft_crop;
+module_param(soft_crop, int, S_IRUGO);
+MODULE_PARM_DESC(soft_crop, "Enables soft-cropping and thus the use of "
+		"pan register");
+
 /* MT9M111 has only one fixed colorspace per pixelcode */
 struct mt9m111_datafmt {
 	enum v4l2_mbus_pixelcode	code;
@@ -296,42 +306,90 @@ static int mt9m111_setup_rect(struct i2c_client *client,
 			      struct mt9m111_format *format)
 {
 	struct v4l2_rect *rect = &format->rect;
-	int ret, is_raw_format;
-	int width = rect->width;
-	int height = rect->height;
-
-	if (format->mf.code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-	    format->mf.code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE)
-		is_raw_format = 1;
-	else
-		is_raw_format = 0;
+	struct v4l2_mbus_framefmt *mf = &format->mf;
+	enum v4l2_mbus_pixelcode *code = &format->mf.code;
+	u16 data_outfmt1 = 0, mask_outfmt1;
+	u16 colum_start, row_start, window_width, window_height, xpan, ypan;
+	int ret;
 
-	ret = reg_write(COLUMN_START, rect->left);
-	if (!ret)
-		ret = reg_write(ROW_START, rect->top);
+	dev_dbg(&client->dev, "%s: rect: left=%d top=%d width=%d height=%d "
+		"mf: pixelcode=%d\n", __func__, rect->left, rect->top,
+		rect->width, rect->height, *code);
 
-	if (is_raw_format) {
+	if (*code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+			ret = reg_write(COLUMN_START, rect->left);
 		if (!ret)
-			ret = reg_write(WINDOW_WIDTH, width);
+			ret = reg_write(ROW_START, rect->top);
 		if (!ret)
-			ret = reg_write(WINDOW_HEIGHT, height);
+			ret = reg_write(WINDOW_WIDTH, rect->width);
+		if (!ret)
+			ret = reg_write(WINDOW_HEIGHT, rect->height);
 	} else {
+		if (soft_crop) {
+			/* use 'soft cropping' through ZOOM and PAN registers */
+			/* enables use of smart zooming and panning functions */
+			colum_start     = MT9M111_MIN_DARK_COLS;
+			row_start       = MT9M111_MIN_DARK_ROWS;
+			window_width    = MT9M111_MAX_WIDTH;
+			window_height   = MT9M111_MAX_HEIGHT;
+			xpan            = rect->left - MT9M111_MIN_DARK_COLS;
+			ypan            = rect->top - MT9M111_MIN_DARK_ROWS;
+		} else {
+			/* use real cropping, smaller roi increases framerate */
+			colum_start     = rect->left;
+			row_start       = rect->top;
+			window_width    = rect->width;
+			window_height   = rect->height;
+			xpan            = 0;
+			ypan            = 0;
+		}
+
+		ret = reg_write(COLUMN_START, colum_start);
+		if (!ret)
+			ret = reg_write(ROW_START, row_start);
 		if (!ret)
-			ret = reg_write(REDUCER_XZOOM_B, MT9M111_MAX_WIDTH);
+			ret = reg_write(WINDOW_WIDTH, window_width);
 		if (!ret)
-			ret = reg_write(REDUCER_YZOOM_B, MT9M111_MAX_HEIGHT);
+			ret = reg_write(WINDOW_HEIGHT, window_height);
 		if (!ret)
-			ret = reg_write(REDUCER_XSIZE_B, width);
+			ret = reg_write(REDUCER_XPAN_A, xpan);
 		if (!ret)
-			ret = reg_write(REDUCER_YSIZE_B, height);
+			ret = reg_write(REDUCER_YPAN_A, ypan);
 		if (!ret)
-			ret = reg_write(REDUCER_XZOOM_A, MT9M111_MAX_WIDTH);
+			ret = reg_write(REDUCER_XZOOM_A, rect->width);
 		if (!ret)
-			ret = reg_write(REDUCER_YZOOM_A, MT9M111_MAX_HEIGHT);
+			ret = reg_write(REDUCER_YZOOM_A, rect->height);
 		if (!ret)
-			ret = reg_write(REDUCER_XSIZE_A, width);
+			ret = reg_write(REDUCER_XSIZE_A, mf->width);
+		if (!ret)
+			ret = reg_write(REDUCER_YSIZE_A, mf->height);
+		if (!ret)
+			ret = reg_write(REDUCER_XPAN_B, xpan);
+		if (!ret)
+			ret = reg_write(REDUCER_YPAN_B, ypan);
+		if (!ret)
+			ret = reg_write(REDUCER_XZOOM_B, rect->width);
+		if (!ret)
+			ret = reg_write(REDUCER_YZOOM_B, rect->height);
+		if (!ret)
+			ret = reg_write(REDUCER_XSIZE_B, mf->width);
+		if (!ret)
+			ret = reg_write(REDUCER_YSIZE_B, mf->height);
+
+		/* not making assumptions about where default and maximum
+		 * rectangles are, we need to do this calculation always
+		 * when IFP is involved */
+		if (row_start % 2)
+			data_outfmt1 |= MT9M111_OUTFMT_CFA_1ST_ROW_BLUE;
+		if (row_start % 2 ^ colum_start % 2)
+			data_outfmt1 |= MT9M111_OUTFMT_CFA_1ST_COL_R_B;
+
+		mask_outfmt1 = MT9M111_OUTFMT_CFA_1ST_ROW_BLUE |
+			MT9M111_OUTFMT_CFA_1ST_COL_R_B;
+
 		if (!ret)
-			ret = reg_write(REDUCER_YSIZE_A, height);
+			ret = reg_mask(OUTPUT_FORMAT_CTRL, data_outfmt1,
+				mask_outfmt1);
 	}
 
 	return ret;
-- 
1.7.1

