Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id AF69A18B055
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007p1-Kz
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 42/59] V4L: imx074: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:42 +0200
Message-Id: <1311937019-29914-43-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 63f17aa..20756e0 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -298,26 +298,6 @@ static struct v4l2_subdev_ops imx074_subdev_ops = {
 	.video	= &imx074_subdev_video_ops,
 };
 
-/*
- * We have to provide soc-camera operations, but we don't have anything to say
- * there. The MIPI CSI2 driver will provide .query_bus_param and .set_bus_param
- */
-static unsigned long imx074_query_bus_param(struct soc_camera_device *icd)
-{
-	return 0;
-}
-
-static int imx074_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long flags)
-{
-	return -EINVAL;
-}
-
-static struct soc_camera_ops imx074_ops = {
-	.query_bus_param	= imx074_query_bus_param,
-	.set_bus_param		= imx074_set_bus_param,
-};
-
 static int imx074_video_probe(struct soc_camera_device *icd,
 			      struct i2c_client *client)
 {
@@ -457,12 +437,11 @@ static int imx074_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &imx074_subdev_ops);
 
-	icd->ops	= &imx074_ops;
+	icd->ops	= NULL;
 	priv->fmt	= &imx074_colour_fmts[0];
 
 	ret = imx074_video_probe(icd, client);
 	if (ret < 0) {
-		icd->ops = NULL;
 		kfree(priv);
 		return ret;
 	}
@@ -476,7 +455,6 @@ static int imx074_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
 	kfree(priv);
-- 
1.7.2.5

