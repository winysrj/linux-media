Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab1IHIoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:12 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 13/13 v3] soc_camera: remove the now obsolete struct soc_camera_ops
Date: Thu,  8 Sep 2011 10:44:06 +0200
Message-Id: <1315471446-17890-14-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: mt9m001 hunk moved to an earlier patch]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c              |    1 -
 drivers/media/video/mt9t112.c             |    2 --
 drivers/media/video/soc_camera_platform.c |    2 --
 drivers/media/video/tw9910.c              |    1 -
 include/media/soc_camera.h                |   18 ------------------
 5 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 20756e0..3f5d4de 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -437,7 +437,6 @@ static int imx074_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &imx074_subdev_ops);
 
-	icd->ops	= NULL;
 	priv->fmt	= &imx074_colour_fmts[0];
 
 	ret = imx074_video_probe(icd, client);
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 25cdcb9..b8da7fe 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -1095,8 +1095,6 @@ static int mt9t112_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
-	icd->ops = NULL;
-
 	ret = mt9t112_camera_probe(icd, client);
 	if (ret)
 		kfree(priv);
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index c8f6b18..4402a8a 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -150,8 +150,6 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	/* Set the control device reference */
 	icd->control = &pdev->dev;
 
-	icd->ops = NULL;
-
 	ici = to_soc_camera_host(icd->parent);
 
 	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 40cc149..2fddd1f 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -921,7 +921,6 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	icd->ops     = NULL;
 	icd->iface   = icl->bus_id;
 
 	ret = tw9910_video_probe(icd, client);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d41b8bd..6398ff0 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -39,7 +39,6 @@ struct soc_camera_device {
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
-	struct soc_camera_ops *ops;
 	struct video_device *vdev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	const struct soc_camera_format_xlate *current_fmt;
@@ -192,11 +191,6 @@ struct soc_camera_format_xlate {
 	const struct soc_mbus_pixelfmt *host_fmt;
 };
 
-struct soc_camera_ops {
-	const struct v4l2_queryctrl *controls;
-	int num_controls;
-};
-
 #define SOCAM_SENSE_PCLK_CHANGED	(1 << 0)
 
 /**
@@ -223,18 +217,6 @@ struct soc_camera_sense {
 	unsigned long pixel_clock;
 };
 
-static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
-	struct soc_camera_ops *ops, int id)
-{
-	int i;
-
-	for (i = 0; i < ops->num_controls; i++)
-		if (ops->controls[i].id == id)
-			return &ops->controls[i];
-
-	return NULL;
-}
-
 #define SOCAM_DATAWIDTH(x)	BIT((x) - 1)
 #define SOCAM_DATAWIDTH_4	SOCAM_DATAWIDTH(4)
 #define SOCAM_DATAWIDTH_8	SOCAM_DATAWIDTH(8)
-- 
1.7.2.5

