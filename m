Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 20/20] mt9m111: s_fmt make use of try_fmt
Date: Fri, 30 Jul 2010 16:53:38 +0200
Message-Id: <1280501618-23634-21-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   60 +++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index f472ca1..ec758ae 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -697,38 +697,6 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
 	return ret;
 }
 
-static int mt9m111_s_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_mbus_framefmt *mf)
-{
-	struct i2c_client *client = sd->priv;
-	const struct mt9m111_datafmt *fmt;
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct v4l2_rect *rect;
-	struct mt9m111_format format;
-	int ret;
-
-	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
-				   ARRAY_SIZE(mt9m111_colour_fmts));
-	if (!fmt)
-		return -EINVAL;
-
-	format.rect	= mt9m111->format.rect;
-	format.mf	= *mf;
-	rect		= &format.rect;
-
-	dev_dbg(&client->dev,
-		"%s code=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
-		mf->code, rect->left, rect->top, rect->width, rect->height);
-
-	ret = mt9m111_make_rect(client, &format);
-	if (!ret)
-		ret = mt9m111_set_pixfmt(client, format.mf.code);
-	if (!ret)
-		mt9m111->format = format;
-
-	return ret;
-}
-
 static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
@@ -763,6 +731,34 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int mt9m111_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct mt9m111_format format;
+	int ret;
+
+	dev_dbg(&client->dev, "%s: mf: width=%d height=%d pixelcode=%d "
+		"field=%x colorspace=%x\n", __func__, mf->width, mf->height,
+		mf->code, mf->field, mf->colorspace);
+
+	ret = mt9m111_try_fmt(sd, mf);
+
+	if (!ret) {
+		format.rect	= mt9m111->format.rect;
+		format.mf	= *mf;
+
+		ret = mt9m111_make_rect(client, &format);
+	}
+	if (!ret)
+		ret = mt9m111_set_pixfmt(client, format.mf.code);
+	if (!ret)
+		mt9m111->format = format;
+
+	return ret;
+}
+
 static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *id)
 {
-- 
1.7.1

