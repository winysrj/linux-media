Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:57748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab1CWKD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:03:57 -0400
Date: Wed, 23 Mar 2011 11:03:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org
Subject: [PATCH] V4L: soc-camera: fix a recent multi-camera breakage on
 sh-mobile
Message-ID: <Pine.LNX.4.64.1103231102550.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the introduction of CSI2 support on sh-mobile, the host driver
switched to using v4l2_device_call_until_err() with grp_id == 0 to
call subdev operations on the sensor and the CSI2 subdev. However,
this has broken multi-client set ups like the one on migor, because
that way all operations get called on both clients. To fix this add
a grp_id and set it to the client private context.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   10 +++++-----
 drivers/media/video/sh_mobile_csi2.c       |    1 +
 drivers/media/video/soc_camera.c           |    4 +++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3fe54bf..d84daf1 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -922,7 +922,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 			/* Try 2560x1920, 1280x960, 640x480, 320x240 */
 			mf.width	= 2560 >> shift;
 			mf.height	= 1920 >> shift;
-			ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+			ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
 							 s_mbus_fmt, &mf);
 			if (ret < 0)
 				return ret;
@@ -1224,7 +1224,7 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	struct v4l2_cropcap cap;
 	int ret;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+	ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
 					 s_mbus_fmt, mf);
 	if (ret < 0)
 		return ret;
@@ -1254,7 +1254,7 @@ static int client_s_fmt(struct soc_camera_device *icd,
 		tmp_h = min(2 * tmp_h, max_height);
 		mf->width = tmp_w;
 		mf->height = tmp_h;
-		ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+		ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
 						 s_mbus_fmt, mf);
 		dev_geo(dev, "Camera scaled to %ux%u\n",
 			mf->width, mf->height);
@@ -1658,7 +1658,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	mf.code		= xlate->code;
 	mf.colorspace	= pix->colorspace;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video, try_mbus_fmt, &mf);
+	ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video, try_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
@@ -1682,7 +1682,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			 */
 			mf.width = 2560;
 			mf.height = 1920;
-			ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, video,
+			ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
 							 try_mbus_fmt, &mf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index dd1b81b..94e575f 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -208,6 +208,7 @@ static int sh_csi2_notify(struct notifier_block *nb,
 	case BUS_NOTIFY_BOUND_DRIVER:
 		snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s%s",
 			 dev_name(v4l2_dev->dev), ".mipi-csi");
+		priv->subdev.grp_id = (int)icd;
 		ret = v4l2_device_register_subdev(v4l2_dev, &priv->subdev);
 		dev_dbg(dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
 		if (ret < 0)
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4628448..e97be53 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1071,6 +1071,9 @@ static int soc_camera_probe(struct device *dev)
 		}
 	}
 
+	sd = soc_camera_to_subdev(icd);
+	sd->grp_id = (int)icd;
+
 	/* At this point client .probe() should have run already */
 	ret = soc_camera_init_user_formats(icd);
 	if (ret < 0)
@@ -1092,7 +1095,6 @@ static int soc_camera_probe(struct device *dev)
 		goto evidstart;
 
 	/* Try to improve our guess of a reasonable window format */
-	sd = soc_camera_to_subdev(icd);
 	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
 		icd->user_width		= mf.width;
 		icd->user_height	= mf.height;
-- 
1.7.2.5

