Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id CDAA9189B89
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007p7-Nu
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 44/59] V4L: mt9t112: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:44 +0200
Message-Id: <1311937019-29914-45-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9t112.c |   48 +---------------------------------------
 1 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index a3368d8..608a3b6 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -743,46 +743,6 @@ static int mt9t112_init_camera(const struct i2c_client *client)
 }
 
 /************************************************************************
-			soc_camera_ops
-************************************************************************/
-static int mt9t112_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long	flags)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t112_priv *priv = to_mt9t112(client);
-
-	if (soc_camera_apply_sensor_flags(icl, flags) & SOCAM_PCLK_SAMPLE_RISING)
-		priv->flags |= PCLK_RISING;
-
-	return 0;
-}
-
-static unsigned long mt9t112_query_bus_param(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9t112_priv *priv = to_mt9t112(client);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned long flags = SOCAM_MASTER | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH;
-
-	flags |= (priv->info->flags & MT9T112_FLAG_PCLK_RISING_EDGE) ?
-		SOCAM_PCLK_SAMPLE_RISING : SOCAM_PCLK_SAMPLE_FALLING;
-
-	if (priv->info->flags & MT9T112_FLAG_DATAWIDTH_8)
-		flags |= SOCAM_DATAWIDTH_8;
-	else
-		flags |= SOCAM_DATAWIDTH_10;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
-static struct soc_camera_ops mt9t112_ops = {
-	.set_bus_param		= mt9t112_set_bus_param,
-	.query_bus_param	= mt9t112_query_bus_param,
-};
-
-/************************************************************************
 			v4l2_subdev_core_ops
 ************************************************************************/
 static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
@@ -1117,13 +1077,11 @@ static int mt9t112_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
-	icd->ops = &mt9t112_ops;
+	icd->ops = NULL;
 
 	ret = mt9t112_camera_probe(icd, client);
-	if (ret) {
-		icd->ops = NULL;
+	if (ret)
 		kfree(priv);
-	}
 
 	return ret;
 }
@@ -1131,9 +1089,7 @@ static int mt9t112_probe(struct i2c_client *client,
 static int mt9t112_remove(struct i2c_client *client)
 {
 	struct mt9t112_priv *priv = to_mt9t112(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
-	icd->ops = NULL;
 	kfree(priv);
 	return 0;
 }
-- 
1.7.2.5

