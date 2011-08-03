Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1HCRMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2011 13:12:18 -0400
Date: Wed, 3 Aug 2011 19:12:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] V4L: mt9t112: fix broken cropping and scaling
Message-ID: <Pine.LNX.4.64.1108031904050.28502@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

G_CROP, S_CROP, CROPCAP, G_FMT, and S_FMT functionality in the mt9t112
driver was broken on many occasions. This patch allows consistent
cropping for rectangles also larger than VGA and cleans up multiple
other issues in this area. It still doesn't add support for proper
scaling, using the sensor own scaler, so input window is still
always equal to the output frame.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Applies and tested on top of

git://linuxtv.org/gliakhovetski/v4l-dvb.git mbus-config

but might also apply and work on top of a recent tree.

 drivers/media/video/mt9t112.c |  119 ++++++++++++++++++++++++-----------------
 1 files changed, 70 insertions(+), 49 deletions(-)

diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 608a3b6..25cdcb9 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -78,11 +78,6 @@
 /************************************************************************
 			struct
 ************************************************************************/
-struct mt9t112_frame_size {
-	u16 width;
-	u16 height;
-};
-
 struct mt9t112_format {
 	enum v4l2_mbus_pixelcode code;
 	enum v4l2_colorspace colorspace;
@@ -95,7 +90,7 @@ struct mt9t112_priv {
 	struct mt9t112_camera_info	*info;
 	struct i2c_client		*client;
 	struct soc_camera_device	 icd;
-	struct mt9t112_frame_size	 frame;
+	struct v4l2_rect		 frame;
 	const struct mt9t112_format	*format;
 	int				 model;
 	u32				 flags;
@@ -348,13 +343,10 @@ static int mt9t112_clock_info(const struct i2c_client *client, u32 ext)
 }
 #endif
 
-static void mt9t112_frame_check(u32 *width, u32 *height)
+static void mt9t112_frame_check(u32 *width, u32 *height, u32 *left, u32 *top)
 {
-	if (*width > MAX_WIDTH)
-		*width = MAX_WIDTH;
-
-	if (*height > MAX_HEIGHT)
-		*height = MAX_HEIGHT;
+	soc_camera_limit_side(left, width, 0, 0, MAX_WIDTH);
+	soc_camera_limit_side(top, height, 0, 0, MAX_HEIGHT);
 }
 
 static int mt9t112_set_a_frame_size(const struct i2c_client *client,
@@ -849,19 +841,12 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-static int mt9t112_set_params(struct i2c_client *client, u32 width, u32 height,
+static int mt9t112_set_params(struct mt9t112_priv *priv,
+			      const struct v4l2_rect *rect,
 			      enum v4l2_mbus_pixelcode code)
 {
-	struct mt9t112_priv *priv = to_mt9t112(client);
 	int i;
 
-	priv->format = NULL;
-
-	/*
-	 * frame size check
-	 */
-	mt9t112_frame_check(&width, &height);
-
 	/*
 	 * get color format
 	 */
@@ -872,8 +857,13 @@ static int mt9t112_set_params(struct i2c_client *client, u32 width, u32 height,
 	if (i == ARRAY_SIZE(mt9t112_cfmts))
 		return -EINVAL;
 
-	priv->frame.width  = (u16)width;
-	priv->frame.height = (u16)height;
+	priv->frame  = *rect;
+
+	/*
+	 * frame size check
+	 */
+	mt9t112_frame_check(&priv->frame.width, &priv->frame.height,
+			    &priv->frame.left, &priv->frame.top);
 
 	priv->format = mt9t112_cfmts + i;
 
@@ -884,9 +874,12 @@ static int mt9t112_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	a->bounds.left			= 0;
 	a->bounds.top			= 0;
-	a->bounds.width			= VGA_WIDTH;
-	a->bounds.height		= VGA_HEIGHT;
-	a->defrect			= a->bounds;
+	a->bounds.width			= MAX_WIDTH;
+	a->bounds.height		= MAX_HEIGHT;
+	a->defrect.left			= 0;
+	a->defrect.top			= 0;
+	a->defrect.width		= VGA_WIDTH;
+	a->defrect.height		= VGA_HEIGHT;
 	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
 	a->pixelaspect.denominator	= 1;
@@ -896,11 +889,11 @@ static int mt9t112_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 
 static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	a->c.left	= 0;
-	a->c.top	= 0;
-	a->c.width	= VGA_WIDTH;
-	a->c.height	= VGA_HEIGHT;
-	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9t112_priv *priv = to_mt9t112(client);
+
+	a->c	= priv->frame;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	return 0;
 }
@@ -908,10 +901,10 @@ static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9t112_priv *priv = to_mt9t112(client);
 	struct v4l2_rect *rect = &a->c;
 
-	return mt9t112_set_params(client, rect->width, rect->height,
-				 V4L2_MBUS_FMT_UYVY8_2X8);
+	return mt9t112_set_params(priv, rect, priv->format->code);
 }
 
 static int mt9t112_g_fmt(struct v4l2_subdev *sd,
@@ -920,16 +913,9 @@ static int mt9t112_g_fmt(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
-	if (!priv->format) {
-		int ret = mt9t112_set_params(client, VGA_WIDTH, VGA_HEIGHT,
-					     V4L2_MBUS_FMT_UYVY8_2X8);
-		if (ret < 0)
-			return ret;
-	}
-
 	mf->width	= priv->frame.width;
 	mf->height	= priv->frame.height;
-	/* TODO: set colorspace */
+	mf->colorspace	= priv->format->colorspace;
 	mf->code	= priv->format->code;
 	mf->field	= V4L2_FIELD_NONE;
 
@@ -940,17 +926,42 @@ static int mt9t112_s_fmt(struct v4l2_subdev *sd,
 			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct v4l2_rect rect = {
+		.width = mf->width,
+		.height = mf->height,
+		.left = priv->frame.left,
+		.top = priv->frame.top,
+	};
+	int ret;
+
+	ret = mt9t112_set_params(priv, &rect, mf->code);
+
+	if (!ret)
+		mf->colorspace = priv->format->colorspace;
 
-	/* TODO: set colorspace */
-	return mt9t112_set_params(client, mf->width, mf->height, mf->code);
+	return ret;
 }
 
 static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
-	mt9t112_frame_check(&mf->width, &mf->height);
+	unsigned int top, left;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mt9t112_cfmts); i++)
+		if (mt9t112_cfmts[i].code == mf->code)
+			break;
+
+	if (i == ARRAY_SIZE(mt9t112_cfmts)) {
+		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+		mf->colorspace = V4L2_COLORSPACE_JPEG;
+	} else {
+		mf->colorspace	= mt9t112_cfmts[i].colorspace;
+	}
+
+	mt9t112_frame_check(&mf->width, &mf->height, &left, &top);
 
-	/* TODO: set colorspace */
 	mf->field = V4L2_FIELD_NONE;
 
 	return 0;
@@ -963,6 +974,7 @@ static int mt9t112_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 		return -EINVAL;
 
 	*code = mt9t112_cfmts[index].code;
+
 	return 0;
 }
 
@@ -1055,10 +1067,16 @@ static int mt9t112_camera_probe(struct soc_camera_device *icd,
 static int mt9t112_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
-	struct mt9t112_priv        *priv;
-	struct soc_camera_device   *icd = client->dev.platform_data;
-	struct soc_camera_link     *icl;
-	int                         ret;
+	struct mt9t112_priv *priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl;
+	struct v4l2_rect rect = {
+		.width = VGA_WIDTH,
+		.height = VGA_HEIGHT,
+		.left = (MAX_WIDTH - VGA_WIDTH) / 2,
+		.top = (MAX_HEIGHT - VGA_HEIGHT) / 2,
+	};
+	int ret;
 
 	if (!icd) {
 		dev_err(&client->dev, "mt9t112: missing soc-camera data!\n");
@@ -1083,6 +1101,9 @@ static int mt9t112_probe(struct i2c_client *client,
 	if (ret)
 		kfree(priv);
 
+	/* Cannot fail: using the default supported pixel code */
+	mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
+
 	return ret;
 }
 
-- 
1.7.2.5

