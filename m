Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1G2K5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:06 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 79D1E18B058
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pn-DM
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 58/59] V4L: tw9910: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:58 +0200
Message-Id: <1311937019-29914-59-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/tw9910.c |   53 ++---------------------------------------
 1 files changed, 3 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 4f9fbf2..40cc149 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -453,7 +453,7 @@ static const struct tw9910_scale_ctrl *tw9910_select_norm(struct soc_camera_devi
 }
 
 /*
- * soc_camera_ops function
+ * subdevice operations
  */
 static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 {
@@ -495,44 +495,6 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 	return tw9910_power(client, enable);
 }
 
-static int tw9910_set_bus_param(struct soc_camera_device *icd,
-				unsigned long flags)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	u8 val = VSSL_VVALID | HSSL_DVALID;
-
-	flags = soc_camera_apply_sensor_flags(icl, flags);
-
-	/*
-	 * set OUTCTR1
-	 *
-	 * We use VVALID and DVALID signals to control VSYNC and HSYNC
-	 * outputs, in this mode their polarity is inverted.
-	 */
-	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
-		val |= HSP_HI;
-
-	if (flags & SOCAM_VSYNC_ACTIVE_LOW)
-		val |= VSP_HI;
-
-	return i2c_smbus_write_byte_data(client, OUTCTR1, val);
-}
-
-static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct tw9910_priv *priv = to_tw9910(client);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_LOW  | SOCAM_HSYNC_ACTIVE_LOW  |
-		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	int ret = -EINVAL;
@@ -840,11 +802,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	return 0;
 }
 
-static struct soc_camera_ops tw9910_ops = {
-	.set_bus_param		= tw9910_set_bus_param,
-	.query_bus_param	= tw9910_query_bus_param,
-};
-
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 	.g_chip_ident	= tw9910_g_chip_ident,
 	.s_std		= tw9910_s_std,
@@ -964,14 +921,12 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	icd->ops     = &tw9910_ops;
+	icd->ops     = NULL;
 	icd->iface   = icl->bus_id;
 
 	ret = tw9910_video_probe(icd, client);
-	if (ret) {
-		icd->ops = NULL;
+	if (ret)
 		kfree(priv);
-	}
 
 	return ret;
 }
@@ -979,9 +934,7 @@ static int tw9910_probe(struct i2c_client *client,
 static int tw9910_remove(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
-	icd->ops = NULL;
 	kfree(priv);
 	return 0;
 }
-- 
1.7.2.5

