Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51760 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 10/20] mt9m111: rewrite make_rect for positioning in debug
Date: Fri, 30 Jul 2010 16:53:28 +0200
Message-Id: <1280501618-23634-11-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If DEBUG is defined it is possible to set upper left corner

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index e8d8e9b..db5ac32 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -428,14 +428,7 @@ static int mt9m111_make_rect(struct i2c_client *client,
 			     struct v4l2_rect *rect)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-
-	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
-		/* Bayer format - even size lengths */
-		rect->width	= ALIGN(rect->width, 2);
-		rect->height	= ALIGN(rect->height, 2);
-		/* Let the user play with the starting pixel */
-	}
+	enum v4l2_mbus_pixelcode code = mt9m111->fmt->code;
 
 	/* FIXME: the datasheet doesn't specify minimum sizes */
 	soc_camera_limit_side(&rect->left, &rect->width,
@@ -444,6 +437,28 @@ static int mt9m111_make_rect(struct i2c_client *client,
 	soc_camera_limit_side(&rect->top, &rect->height,
 		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
 
+	switch (code) {
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
+		/* unprocessed Bayer pattern format, IFP is bypassed */
+#ifndef DEBUG
+		/* assure that Bayer sequence is BGGR */
+		/* in debug mode, let user play with starting pixel */
+		rect->left	= ALIGN(rect->left, 2);
+		rect->top	= ALIGN(rect->top, 2) + 1;
+#endif
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+		/* processed Bayer pattern format, sequence is fixed */
+		/* assure even side lengths for both Bayer modes */
+		rect->width	= ALIGN(rect->width, 2);
+		rect->height	= ALIGN(rect->height, 2);
+	default:
+		/* needed to avoid compiler warnings */;
+	}
+
+	dev_dbg(&client->dev, "%s: rect: left=%d top=%d width=%d height=%d "
+		"mf: pixelcode=%d\n", __func__, rect->left, rect->top,
+		rect->width, rect->height, code);
+
 	return mt9m111_setup_rect(client, rect);
 }
 
-- 
1.7.1

