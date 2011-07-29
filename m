Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 2AA5E18B056
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pS-1t
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 51/59] V4L: ov772x: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:51 +0200
Message-Id: <1311937019-29914-52-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov772x.c |   25 -------------------------
 include/media/ov772x.h       |    1 -
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index b70ffba..f77e899 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -621,29 +621,6 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int ov772x_set_bus_param(struct soc_camera_device *icd,
-				unsigned long		  flags)
-{
-	return 0;
-}
-
-static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct ov772x_priv *priv = i2c_get_clientdata(client);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_DATA_ACTIVE_HIGH;
-
-	if (priv->info->flags & OV772X_FLAG_8BIT)
-		flags |= SOCAM_DATAWIDTH_8;
-	else
-		flags |= SOCAM_DATAWIDTH_10;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
@@ -1070,8 +1047,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 }
 
 static struct soc_camera_ops ov772x_ops = {
-	.set_bus_param		= ov772x_set_bus_param,
-	.query_bus_param	= ov772x_query_bus_param,
 	.controls		= ov772x_controls,
 	.num_controls		= ARRAY_SIZE(ov772x_controls),
 };
diff --git a/include/media/ov772x.h b/include/media/ov772x.h
index f9e27c0..00dbb7c 100644
--- a/include/media/ov772x.h
+++ b/include/media/ov772x.h
@@ -15,7 +15,6 @@
 /* for flags */
 #define OV772X_FLAG_VFLIP	(1 << 0) /* Vertical flip image */
 #define OV772X_FLAG_HFLIP	(1 << 1) /* Horizontal flip image */
-#define OV772X_FLAG_8BIT	(1 << 2) /* default 10 bit */
 
 /*
  * for Edge ctrl
-- 
1.7.2.5

