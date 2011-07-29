Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id C57A918B045
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nz-JW
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 21/59] V4L: sh_mobile_csi2: verify client compatibility
Date: Fri, 29 Jul 2011 12:56:21 +0200
Message-Id: <1311937019-29914-22-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch the meaning of the .lanes platform data parameter to specify
the number of used lanes instead of a bitmask. Verify bus configuration
compatibility with client's capabilities.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_csi2.c |   58 ++++++++++++++++++++++++++++++---
 1 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 2893a01..09ef63d 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -19,6 +19,7 @@
 #include <media/sh_mobile_ceu.h>
 #include <media/sh_mobile_csi2.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
@@ -144,11 +145,21 @@ static void sh_csi2_hwinit(struct sh_csi2 *priv)
 	udelay(5);
 	iowrite32(0x00000000, priv->base + SH_CSI2_SRST);
 
-	if (priv->client->lanes & 3)
-		tmp |= priv->client->lanes & 3;
-	else
-		/* Default - both lanes */
-		tmp |= 3;
+	switch (pdata->type) {
+	case SH_CSI2C:
+		if (priv->client->lanes == 1)
+			tmp |= 1;
+		else
+			/* Default - both lanes */
+			tmp |= 3;
+		break;
+	case SH_CSI2I:
+		if (!priv->client->lanes || priv->client->lanes > 4)
+			/* Default - all 4 lanes */
+			tmp |= 0xf;
+		else
+			tmp |= (1 << priv->client->lanes) - 1;
+	}
 
 	if (priv->client->phy == SH_CSI2_PHY_MAIN)
 		tmp |= 0x8000;
@@ -185,7 +196,9 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	struct v4l2_subdev *sd, *csi2_sd = &priv->subdev;
 	struct soc_camera_device *icd = NULL;
 	struct device *dev = v4l2_get_subdevdata(&priv->subdev);
-	int i;
+	struct v4l2_mbus_config cfg;
+	unsigned long common_flags, csi2_flags;
+	int i, ret;
 
 	v4l2_device_for_each_subdev(sd, csi2_sd->v4l2_dev)
 		if (sd->grp_id) {
@@ -205,6 +218,39 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	if (i == pdata->num_clients)
 		return -ENODEV;
 
+	/* Check if we can support this camera */
+	csi2_flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK | V4L2_MBUS_CSI2_1_LANE;
+
+	switch (pdata->type) {
+	case SH_CSI2C:
+		if (pdata->clients[i].lanes != 1)
+			csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
+		break;
+	case SH_CSI2I:
+		switch (pdata->clients[i].lanes) {
+		default:
+			csi2_flags |= V4L2_MBUS_CSI2_4_LANE;
+		case 3:
+			csi2_flags |= V4L2_MBUS_CSI2_3_LANE;
+		case 2:
+			csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
+		}
+	}
+
+	cfg.type = V4L2_MBUS_CSI2;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (ret == -ENOIOCTLCMD)
+		common_flags = csi2_flags;
+	else if (!ret)
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  csi2_flags);
+	else
+		common_flags = 0;
+
+	if (!common_flags)
+		return -EINVAL;
+
+	/* All good: camera MIPI configuration supported */
 	priv->client = pdata->clients + i;
 
 	priv->set_bus_param		= icd->ops->set_bus_param;
-- 
1.7.2.5

