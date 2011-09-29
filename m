Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab1I2QTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:04 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 8/9] V4L: mt9t112: add pad level operations
Date: Thu, 29 Sep 2011 18:18:56 +0200
Message-Id: <1317313137-4403-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Media Controller enabled systems this patch allows the user to
communicate with the driver directly over /dev/v4l-subdev* device nodes
using VIDIOC_SUBDEV_* ioctl()s.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9t112.c |   97 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 32114a3..bb95ad1 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -25,6 +25,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
+#include <media/media-entity.h>
 #include <media/mt9t112.h>
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
@@ -87,6 +88,7 @@ struct mt9t112_format {
 
 struct mt9t112_priv {
 	struct v4l2_subdev		 subdev;
+	struct media_pad		 pad;
 	struct mt9t112_camera_info	*info;
 	struct i2c_client		*client;
 	struct v4l2_rect		 frame;
@@ -739,8 +741,7 @@ static int mt9t112_init_camera(const struct i2c_client *client)
 static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *id)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 
 	id->ident    = priv->model;
 	id->revision = 0;
@@ -790,7 +791,7 @@ static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
 static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 	int ret = 0;
 
 	if (!enable) {
@@ -888,8 +889,7 @@ static int mt9t112_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 
 static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 
 	a->c	= priv->frame;
 	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -899,8 +899,7 @@ static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 
 static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 	struct v4l2_rect *rect = &a->c;
 
 	return mt9t112_set_params(priv, rect, priv->format->code);
@@ -909,8 +908,7 @@ static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 static int mt9t112_g_fmt(struct v4l2_subdev *sd,
 			 struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 
 	mf->width	= priv->frame.width;
 	mf->height	= priv->frame.height;
@@ -924,8 +922,7 @@ static int mt9t112_g_fmt(struct v4l2_subdev *sd,
 static int mt9t112_s_fmt(struct v4l2_subdev *sd,
 			 struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t112_priv *priv = to_mt9t112(client);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 	struct v4l2_rect rect = {
 		.width = mf->width,
 		.height = mf->height,
@@ -996,8 +993,8 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 				 const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9t112_priv *priv = container_of(sd, struct mt9t112_priv, subdev);
 	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
-	struct mt9t112_priv *priv = to_mt9t112(client);
 
 	if (soc_camera_apply_board_flags(icl, cfg) & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		priv->flags |= PCLK_RISING;
@@ -1018,14 +1015,67 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.s_mbus_config	= mt9t112_s_mbus_config,
 };
 
-/************************************************************************
-			i2c driver
-************************************************************************/
+static int mt9t112_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *ce)
+{
+	if (ce->index >= ARRAY_SIZE(mt9t112_cfmts))
+		return -EINVAL;
+
+	ce->code = mt9t112_cfmts[ce->index].code;
+	return 0;
+}
+
+static int mt9t112_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *sd_fmt)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return mt9t112_g_fmt(sd, &sd_fmt->format);
+
+	mf = v4l2_subdev_get_try_format(fh, sd_fmt->pad);
+	sd_fmt->format = *mf;
+	return 0;
+}
+
+static int mt9t112_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *sd_fmt)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return mt9t112_s_fmt(sd, &sd_fmt->format);
+
+	mf = v4l2_subdev_get_try_format(fh, sd_fmt->pad);
+	*mf = sd_fmt->format;
+	return mt9t112_try_fmt(sd, mf);
+}
+
+struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
+	.enum_mbus_code	= mt9t112_enum_mbus_code,
+	.get_fmt	= mt9t112_get_fmt,
+	.set_fmt	= mt9t112_set_fmt,
+};
+
 static struct v4l2_subdev_ops mt9t112_subdev_ops = {
 	.core	= &mt9t112_subdev_core_ops,
 	.video	= &mt9t112_subdev_video_ops,
+	.pad	= &mt9t112_subdev_pad_ops,
 };
 
+static int mt9t112_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	return mf ? mt9t112_try_fmt(sd, mf) : 0;
+}
+
+static const struct v4l2_subdev_internal_ops mt9t112_subdev_internal_ops = {
+	.open = mt9t112_open,
+};
+
+/************************************************************************
+			i2c driver
+************************************************************************/
 static int mt9t112_camera_probe(struct i2c_client *client)
 {
 	struct mt9t112_priv *priv = to_mt9t112(client);
@@ -1081,21 +1131,36 @@ static int mt9t112_probe(struct i2c_client *client,
 	priv->info = icl->priv;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
+	priv->subdev.internal_ops = &mt9t112_subdev_internal_ops;
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	priv->pad.flags	= MEDIA_PAD_FL_SOURCE;
+	ret = subdev_media_entity_init(&priv->subdev, 1, &priv->pad, 0);
+	if (ret < 0)
+		goto emeinit;
 
 	ret = mt9t112_camera_probe(client);
 	if (ret)
-		kfree(priv);
+		goto evprobe;
 
 	/* Cannot fail: using the default supported pixel code */
 	mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
 
 	return ret;
+
+evprobe:
+	subdev_media_entity_cleanup(&priv->subdev);
+emeinit:
+	kfree(priv);
+	return ret;
 }
 
 static int mt9t112_remove(struct i2c_client *client)
 {
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
+	v4l2_device_unregister_subdev(&priv->subdev);
+	subdev_media_entity_cleanup(&priv->subdev);
 	kfree(priv);
 	return 0;
 }
-- 
1.7.2.5

