Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3A3Lk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 06:40:58 -0500
Date: Wed, 30 Jan 2013 12:40:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Simon Horman <horms@verge.net.au>
Subject: [PATCH] mt9t112: mt9t111 format set up differs from mt9t112
Message-ID: <Pine.LNX.4.64.1301301239560.3113@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original commit, adding the mt9t112 driver said, that mt9t111 and
mt9t112 had identical register layouts. This however doesn't seem to be
the case. At least pixel format selection in the mt9t111 datasheet is
different from the driver implementation. So far only the default YUYV
format has been verified to work with mt9t111. Limit the driver to only
report one supported format with mt9t111 until more formats are
implemented.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9t112.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index de7cd83..58f3509 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -92,6 +92,7 @@ struct mt9t112_priv {
 	struct v4l2_rect		 frame;
 	const struct mt9t112_format	*format;
 	int				 model;
+	int				 num_formats;
 	u32				 flags;
 /* for flags */
 #define INIT_DONE	(1 << 0)
@@ -859,11 +860,11 @@ static int mt9t112_set_params(struct mt9t112_priv *priv,
 	/*
 	 * get color format
 	 */
-	for (i = 0; i < ARRAY_SIZE(mt9t112_cfmts); i++)
+	for (i = 0; i < priv->num_formats; i++)
 		if (mt9t112_cfmts[i].code == code)
 			break;
 
-	if (i == ARRAY_SIZE(mt9t112_cfmts))
+	if (i == priv->num_formats)
 		return -EINVAL;
 
 	priv->frame  = *rect;
@@ -955,14 +956,16 @@ static int mt9t112_s_fmt(struct v4l2_subdev *sd,
 static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9t112_priv *priv = to_mt9t112(client);
 	unsigned int top, left;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mt9t112_cfmts); i++)
+	for (i = 0; i < priv->num_formats; i++)
 		if (mt9t112_cfmts[i].code == mf->code)
 			break;
 
-	if (i == ARRAY_SIZE(mt9t112_cfmts)) {
+	if (i == priv->num_formats) {
 		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	} else {
@@ -979,7 +982,10 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 static int mt9t112_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 			   enum v4l2_mbus_pixelcode *code)
 {
-	if (index >= ARRAY_SIZE(mt9t112_cfmts))
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9t112_priv *priv = to_mt9t112(client);
+
+	if (index >= priv->num_formats)
 		return -EINVAL;
 
 	*code = mt9t112_cfmts[index].code;
@@ -1056,10 +1062,12 @@ static int mt9t112_camera_probe(struct i2c_client *client)
 	case 0x2680:
 		devname = "mt9t111";
 		priv->model = V4L2_IDENT_MT9T111;
+		priv->num_formats = 1;
 		break;
 	case 0x2682:
 		devname = "mt9t112";
 		priv->model = V4L2_IDENT_MT9T112;
+		priv->num_formats = ARRAY_SIZE(mt9t112_cfmts);
 		break;
 	default:
 		dev_err(&client->dev, "Product ID error %04x\n", chipid);
-- 
1.7.2.5

