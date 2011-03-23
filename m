Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:50517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab1CWKF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:05:59 -0400
Date: Wed, 23 Mar 2011 11:05:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org
Subject: [PATCH] V4L: sh_mobile_csi2: fix module reloading
Message-ID: <Pine.LNX.4.64.1103231105110.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If the camera host driver (sh_mobile_ceu_camera.c) is unloaded and then
reloaded, probe will fail, because camera client .set_bus_param() and
.query_bus_param() methods have been set to NULL. Fix this by caching
the original pointers and restoring them on driver-unbind.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_csi2.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 94e575f..9b68a40 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -38,6 +38,8 @@ struct sh_csi2 {
 	void __iomem			*base;
 	struct platform_device		*pdev;
 	struct sh_csi2_client_config	*client;
+	unsigned long (*query_bus_param)(struct soc_camera_device *);
+	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 };
 
 static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
@@ -216,6 +218,8 @@ static int sh_csi2_notify(struct notifier_block *nb,
 
 		priv->client = pdata->clients + i;
 
+		priv->set_bus_param		= icd->ops->set_bus_param;
+		priv->query_bus_param		= icd->ops->query_bus_param;
 		icd->ops->set_bus_param		= sh_csi2_set_bus_param;
 		icd->ops->query_bus_param	= sh_csi2_query_bus_param;
 
@@ -227,8 +231,10 @@ static int sh_csi2_notify(struct notifier_block *nb,
 		priv->client = NULL;
 
 		/* Driver is about to be unbound */
-		icd->ops->set_bus_param		= NULL;
-		icd->ops->query_bus_param	= NULL;
+		icd->ops->set_bus_param		= priv->set_bus_param;
+		icd->ops->query_bus_param	= priv->query_bus_param;
+		priv->set_bus_param		= NULL;
+		priv->query_bus_param		= NULL;
 
 		v4l2_device_unregister_subdev(&priv->subdev);
 
-- 
1.7.2.5

