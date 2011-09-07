Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1IGQJt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:09:49 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 7161D18B03C
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 17:03:13 +0200 (CEST)
Date: Wed, 7 Sep 2011 17:03:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] V4L: sh_mobile_csi2: do not guess the client, the host
 tells us
In-Reply-To: <Pine.LNX.4.64.1109071550320.14818@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109071701460.14818@axis700.grange>
References: <Pine.LNX.4.64.1109071550320.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We do not have to scan the list of subdevices to find our client - the
sensor, the host has already set our grp_id value.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_csi2.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 6f9f2b7..91c680a 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -201,22 +201,13 @@ static void sh_csi2_hwinit(struct sh_csi2 *priv)
 static int sh_csi2_client_connect(struct sh_csi2 *priv)
 {
 	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
-	struct v4l2_subdev *sd, *csi2_sd = &priv->subdev;
-	struct soc_camera_device *icd = NULL;
+	struct soc_camera_device *icd = (struct soc_camera_device *)priv->subdev.grp_id;
+	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
 	struct device *dev = v4l2_get_subdevdata(&priv->subdev);
 	struct v4l2_mbus_config cfg;
 	unsigned long common_flags, csi2_flags;
 	int i, ret;
 
-	v4l2_device_for_each_subdev(sd, csi2_sd->v4l2_dev)
-		if (sd->grp_id) {
-			icd = (struct soc_camera_device *)sd->grp_id;
-			break;
-		}
-
-	if (!icd)
-		return -EINVAL;
-
 	for (i = 0; i < pdata->num_clients; i++)
 		if (&pdata->clients[i].pdev->dev == icd->pdev)
 			break;
@@ -246,7 +237,7 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	}
 
 	cfg.type = V4L2_MBUS_CSI2;
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = v4l2_subdev_call(client_sd, video, g_mbus_config, &cfg);
 	if (ret == -ENOIOCTLCMD)
 		common_flags = csi2_flags;
 	else if (!ret)
@@ -262,8 +253,6 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	priv->mipi_flags = common_flags;
 	priv->client = pdata->clients + i;
 
-	csi2_sd->grp_id = (long)icd;
-
 	pm_runtime_get_sync(dev);
 
 	sh_csi2_hwinit(priv);
@@ -274,7 +263,6 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 static void sh_csi2_client_disconnect(struct sh_csi2 *priv)
 {
 	priv->client = NULL;
-	priv->subdev.grp_id = 0;
 
 	pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
 }
-- 
1.7.2.5

