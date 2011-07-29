Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id F3A9F18B03A
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007pG-Sh
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 47/59] V4L: ov5642: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:47 +0200
Message-Id: <1311937019-29914-48-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov5642.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 60ffc60..6410bda 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -888,26 +888,6 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
 	.video	= &ov5642_subdev_video_ops,
 };
 
-/*
- * We have to provide soc-camera operations, but we don't have anything to say
- * there. The MIPI CSI2 driver will provide .query_bus_param and .set_bus_param
- */
-static unsigned long soc_ov5642_query_bus_param(struct soc_camera_device *icd)
-{
-	return 0;
-}
-
-static int soc_ov5642_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long flags)
-{
-	return -EINVAL;
-}
-
-static struct soc_camera_ops soc_ov5642_ops = {
-	.query_bus_param	= soc_ov5642_query_bus_param,
-	.set_bus_param		= soc_ov5642_set_bus_param,
-};
-
 static int ov5642_video_probe(struct soc_camera_device *icd,
 			      struct i2c_client *client)
 {
@@ -961,7 +941,7 @@ static int ov5642_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
 
-	icd->ops	= &soc_ov5642_ops;
+	icd->ops	= NULL;
 	priv->fmt	= &ov5642_colour_fmts[0];
 
 	ret = ov5642_video_probe(icd, client);
@@ -971,7 +951,6 @@ static int ov5642_probe(struct i2c_client *client,
 	return 0;
 
 error:
-	icd->ops = NULL;
 	kfree(priv);
 	return ret;
 }
@@ -982,7 +961,6 @@ static int ov5642_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
 	kfree(priv);
-- 
1.7.2.5

