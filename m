Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 6FD0418B050
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007oj-CL
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 36/59] V4L: omap1_camera: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:36 +0200
Message-Id: <1311937019-29914-37-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/omap1_camera.c |   52 ++++++++++++++++++++++-------------
 1 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index 8a947e6..f24bcaf 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -102,10 +102,10 @@
 /* end of OMAP1 Camera Interface registers */
 
 
-#define SOCAM_BUS_FLAGS	(SOCAM_MASTER | \
-			SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH | \
-			SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING | \
-			SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8)
+#define SOCAM_BUS_FLAGS	(V4L2_MBUS_MASTER | \
+			V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH | \
+			V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING | \
+			V4L2_MBUS_DATA_ACTIVE_HIGH)
 
 
 #define FIFO_SIZE		((THRESHOLD_MASK >> THRESHOLD_SHIFT) + 1)
@@ -1438,41 +1438,55 @@ static int omap1_cam_querycap(struct soc_camera_host *ici,
 static int omap1_cam_set_bus_param(struct soc_camera_device *icd,
 		__u32 pixfmt)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	const struct soc_camera_format_xlate *xlate;
 	const struct soc_mbus_pixelfmt *fmt;
-	unsigned long camera_flags, common_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long common_flags;
 	u32 ctrlclock, mode;
 	int ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	common_flags = soc_camera_bus_param_compatible(camera_flags,
-			SOCAM_BUS_FLAGS);
-	if (!common_flags)
-		return -EINVAL;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg, SOCAM_BUS_FLAGS);
+		if (!common_flags) {
+			dev_warn(dev,
+				 "Flags incompatible: camera 0x%x, host 0x%x\n",
+				 cfg.flags, SOCAM_BUS_FLAGS);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	} else {
+		common_flags = SOCAM_BUS_FLAGS;
+	}
 
 	/* Make choices, possibly based on platform configuration */
-	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
-			(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
+			(common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
 		if (!pcdev->pdata ||
 				pcdev->pdata->flags & OMAP1_CAMERA_LCLK_RISING)
-			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
 		else
-			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 	}
 
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
+	cfg.flags = common_flags;
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		dev_dbg(dev, "camera s_mbus_config(0x%lx) returned %d\n",
+			common_flags, ret);
 		return ret;
+	}
 
 	ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
 	if (ctrlclock & LCLK_EN)
 		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
 
-	if (common_flags & SOCAM_PCLK_SAMPLE_RISING) {
+	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) {
 		dev_dbg(dev, "CTRLCLOCK_REG |= POLCLK\n");
 		ctrlclock |= POLCLK;
 	} else {
@@ -1716,5 +1730,5 @@ MODULE_PARM_DESC(sg_mode, "videobuf mode, 0: dma-contig (default), 1: dma-sg");
 MODULE_DESCRIPTION("OMAP1 Camera Interface driver");
 MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
 MODULE_LICENSE("GPL v2");
-MODULE_LICENSE(DRIVER_VERSION);
+MODULE_VERSION(DRIVER_VERSION);
 MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.7.2.5

