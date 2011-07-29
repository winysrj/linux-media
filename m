Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab1G2K5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:06 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 57C1018B057
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pe-8X
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 55/59] V4L: sh_mobile_csi2: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:55 +0200
Message-Id: <1311937019-29914-56-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_csi2.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 6b40441..6f9f2b7 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -40,8 +40,6 @@ struct sh_csi2 {
 	void __iomem			*base;
 	struct platform_device		*pdev;
 	struct sh_csi2_client_config	*client;
-	unsigned long (*query_bus_param)(struct soc_camera_device *);
-	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 };
 
 static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
@@ -200,22 +198,6 @@ static void sh_csi2_hwinit(struct sh_csi2 *priv)
 	iowrite32(tmp, priv->base + SH_CSI2_CHKSUM);
 }
 
-static int sh_csi2_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long flags)
-{
-	return 0;
-}
-
-static unsigned long sh_csi2_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	const unsigned long flags = SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_DATA_ACTIVE_HIGH;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 static int sh_csi2_client_connect(struct sh_csi2 *priv)
 {
 	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
@@ -280,11 +262,6 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	priv->mipi_flags = common_flags;
 	priv->client = pdata->clients + i;
 
-	priv->set_bus_param		= icd->ops->set_bus_param;
-	priv->query_bus_param		= icd->ops->query_bus_param;
-	icd->ops->set_bus_param		= sh_csi2_set_bus_param;
-	icd->ops->query_bus_param	= sh_csi2_query_bus_param;
-
 	csi2_sd->grp_id = (long)icd;
 
 	pm_runtime_get_sync(dev);
@@ -296,17 +273,9 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 
 static void sh_csi2_client_disconnect(struct sh_csi2 *priv)
 {
-	struct soc_camera_device *icd = (struct soc_camera_device *)priv->subdev.grp_id;
-
 	priv->client = NULL;
 	priv->subdev.grp_id = 0;
 
-	/* Driver is about to be unbound */
-	icd->ops->set_bus_param		= priv->set_bus_param;
-	icd->ops->query_bus_param	= priv->query_bus_param;
-	priv->set_bus_param		= NULL;
-	priv->query_bus_param		= NULL;
-
 	pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
 }
 
-- 
1.7.2.5

