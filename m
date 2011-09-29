Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab1I2QTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:04 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 9/9] V4L: imx074: add pad level operations
Date: Thu, 29 Sep 2011 18:18:57 +0200
Message-Id: <1317313137-4403-10-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Media Controller enabled systems this patch allows the user to
communicate with the driver directly over /dev/v4l-subdev* device nodes
using VIDIOC_SUBDEV_* ioctl()s.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c |   85 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 8775e26..9745887 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
+#include <media/media-entity.h>
 #include <media/soc_camera.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
@@ -75,6 +76,7 @@ struct imx074_datafmt {
 
 struct imx074 {
 	struct v4l2_subdev		subdev;
+	struct media_pad		pad;
 	const struct imx074_datafmt	*fmt;
 };
 
@@ -172,8 +174,7 @@ static int imx074_try_fmt(struct v4l2_subdev *sd,
 static int imx074_s_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct imx074 *priv = to_imx074(client);
+	struct imx074 *priv = container_of(sd, struct imx074, subdev);
 
 	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
 
@@ -191,9 +192,7 @@ static int imx074_s_fmt(struct v4l2_subdev *sd,
 static int imx074_g_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct imx074 *priv = to_imx074(client);
-
+	struct imx074 *priv = container_of(sd, struct imx074, subdev);
 	const struct imx074_datafmt *fmt = priv->fmt;
 
 	mf->code	= fmt->code;
@@ -293,9 +292,62 @@ static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 	.g_chip_ident	= imx074_g_chip_ident,
 };
 
+static int imx074_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_mbus_code_enum *ce)
+{
+	if (ce->index >= ARRAY_SIZE(imx074_colour_fmts))
+		return -EINVAL;
+
+	ce->code = imx074_colour_fmts[ce->index].code;
+	return 0;
+}
+
+static int imx074_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *sd_fmt)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return imx074_g_fmt(sd, &sd_fmt->format);
+
+	mf = v4l2_subdev_get_try_format(fh, sd_fmt->pad);
+	sd_fmt->format = *mf;
+	return 0;
+}
+
+static int imx074_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *sd_fmt)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return imx074_s_fmt(sd, &sd_fmt->format);
+
+	mf = v4l2_subdev_get_try_format(fh, sd_fmt->pad);
+	*mf = sd_fmt->format;
+	return imx074_try_fmt(sd, mf);
+}
+
+struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
+	.enum_mbus_code	= imx074_enum_mbus_code,
+	.get_fmt	= imx074_get_fmt,
+	.set_fmt	= imx074_set_fmt,
+};
+
 static struct v4l2_subdev_ops imx074_subdev_ops = {
 	.core	= &imx074_subdev_core_ops,
 	.video	= &imx074_subdev_video_ops,
+	.pad	= &imx074_subdev_pad_ops,
+};
+
+static int imx074_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	return mf ? imx074_try_fmt(sd, mf) : 0;
+}
+
+static const struct v4l2_subdev_internal_ops imx074_subdev_internal_ops = {
+	.open = imx074_open,
 };
 
 static int imx074_video_probe(struct i2c_client *client)
@@ -427,16 +479,27 @@ static int imx074_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
+	priv->fmt = &imx074_colour_fmts[0];
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &imx074_subdev_ops);
+	priv->subdev.internal_ops = &imx074_subdev_internal_ops;
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-	priv->fmt	= &imx074_colour_fmts[0];
+	priv->pad.flags	= MEDIA_PAD_FL_SOURCE;
+	ret = subdev_media_entity_init(&priv->subdev, 1, &priv->pad, 0);
+	if (ret < 0)
+		goto emeinit;
 
 	ret = imx074_video_probe(client);
-	if (ret < 0) {
-		kfree(priv);
-		return ret;
-	}
+	if (ret < 0)
+		goto evprobe;
+
+	return ret;
 
+evprobe:
+	subdev_media_entity_cleanup(&priv->subdev);
+emeinit:
+	kfree(priv);
 	return ret;
 }
 
@@ -447,6 +510,8 @@ static int imx074_remove(struct i2c_client *client)
 
 	if (icl->free_bus)
 		icl->free_bus(icl);
+	v4l2_device_unregister_subdev(&priv->subdev);
+	subdev_media_entity_cleanup(&priv->subdev);
 	kfree(priv);
 
 	return 0;
-- 
1.7.2.5

