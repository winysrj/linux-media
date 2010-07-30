Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51775 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 19/20] mt9m111: try_fmt rewrite to use preset values
Date: Fri, 30 Jul 2010 16:53:37 +0200
Message-Id: <1280501618-23634-20-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make use of the format.rect boundery values

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 799a735..f472ca1 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -733,35 +733,32 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct v4l2_rect rect = mt9m111->format.rect;
 	const struct mt9m111_datafmt *fmt;
-	bool bayer = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
 
 	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
 				   ARRAY_SIZE(mt9m111_colour_fmts));
 	if (!fmt)
 		return -EINVAL;
 
-	/*
-	 * With Bayer format enforce even side lengths, but let the user play
-	 * with the starting pixel
-	 */
+	mf->code	= fmt->code;
+	mf->colorspace	= fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
 
-	if (mf->height > MT9M111_MAX_HEIGHT)
-		mf->height = MT9M111_MAX_HEIGHT;
-	else if (mf->height < 2)
-		mf->height = 2;
-	else if (bayer)
-		mf->height = ALIGN(mf->height, 2);
-
-	if (mf->width > MT9M111_MAX_WIDTH)
-		mf->width = MT9M111_MAX_WIDTH;
-	else if (mf->width < 2)
-		mf->width = 2;
-	else if (bayer)
-		mf->width = ALIGN(mf->width, 2);
-
-	mf->colorspace = fmt->colorspace;
+	if (mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+		mf->width	= rect.width;
+		mf->height	= rect.height;
+	} else {
+		if (mf->width > rect.width)
+			mf->width = rect.width;
+		if (mf->height > rect.height)
+			mf->height = rect.height;
+	}
+
+	dev_dbg(&client->dev, "%s: mf: width=%d height=%d pixelcode=%d "
+		"field=%x colorspace=%x\n", __func__, mf->width, mf->height,
+		mf->code, mf->field, mf->colorspace);
 
 	return 0;
 }
-- 
1.7.1

