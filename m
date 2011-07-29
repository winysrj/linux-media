Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id D080118B047
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007o2-LZ
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 22/59] V4L: sh_mobile_csi2: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:22 +0200
Message-Id: <1311937019-29914-23-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_csi2.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 09ef63d..6b40441 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -36,6 +36,7 @@ struct sh_csi2 {
 	struct v4l2_subdev		subdev;
 	struct list_head		list;
 	unsigned int			irq;
+	unsigned long			mipi_flags;
 	void __iomem			*base;
 	struct platform_device		*pdev;
 	struct sh_csi2_client_config	*client;
@@ -128,9 +129,34 @@ static int sh_csi2_s_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int sh_csi2_g_mbus_config(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_config *cfg)
+{
+	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+
+	return 0;
+}
+
+static int sh_csi2_s_mbus_config(struct v4l2_subdev *sd,
+				 const struct v4l2_mbus_config *cfg)
+{
+	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
+	struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
+	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,
+					      .flags = priv->mipi_flags};
+
+	return v4l2_subdev_call(client_sd, video, s_mbus_config, &client_cfg);
+}
+
 static struct v4l2_subdev_video_ops sh_csi2_subdev_video_ops = {
 	.s_mbus_fmt	= sh_csi2_s_fmt,
 	.try_mbus_fmt	= sh_csi2_try_fmt,
+	.g_mbus_config	= sh_csi2_g_mbus_config,
+	.s_mbus_config	= sh_csi2_s_mbus_config,
 };
 
 static void sh_csi2_hwinit(struct sh_csi2 *priv)
@@ -251,6 +277,7 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 		return -EINVAL;
 
 	/* All good: camera MIPI configuration supported */
+	priv->mipi_flags = common_flags;
 	priv->client = pdata->clients + i;
 
 	priv->set_bus_param		= icd->ops->set_bus_param;
-- 
1.7.2.5

