Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 37C9218B04C
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007oU-3j
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 31/59] V4L: mx1_camera: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:31 +0200
Message-Id: <1311937019-29914-32-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx1_camera.c |   71 ++++++++++++++++++++++---------------
 1 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 087db12..18e94c7 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -78,11 +78,10 @@
 #define CSI_IRQ_MASK	(CSISR_SFF_OR_INT | CSISR_RFF_OR_INT | \
 			CSISR_STATFF_INT | CSISR_RXFF_INT | CSISR_SOF_INT)
 
-#define CSI_BUS_FLAGS	(SOCAM_MASTER | SOCAM_HSYNC_ACTIVE_HIGH | \
-			SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW | \
-			SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING | \
-			SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_LOW | \
-			SOCAM_DATAWIDTH_8)
+#define CSI_BUS_FLAGS	(V4L2_MBUS_MASTER | V4L2_MBUS_HSYNC_ACTIVE_HIGH | \
+			V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW | \
+			V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING | \
+			V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_LOW)
 
 #define MAX_VIDEO_MEM 16	/* Video memory limit in megabytes */
 
@@ -490,59 +489,73 @@ static int mx1_camera_set_crop(struct soc_camera_device *icd,
 
 static int mx1_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
-	unsigned long camera_flags, common_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long common_flags;
 	unsigned int csicr1;
 	int ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
 	/* MX1 supports only 8bit buswidth */
-	common_flags = soc_camera_bus_param_compatible(camera_flags,
-						       CSI_BUS_FLAGS);
-	if (!common_flags)
-		return -EINVAL;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg, CSI_BUS_FLAGS);
+		if (!common_flags) {
+			dev_warn(icd->parent,
+				 "Flags incompatible: camera 0x%x, host 0x%x\n",
+				 cfg.flags, CSI_BUS_FLAGS);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	} else {
+		common_flags = CSI_BUS_FLAGS;
+	}
 
 	/* Make choises, based on platform choice */
-	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
-		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
+		(common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
 			if (!pcdev->pdata ||
 			     pcdev->pdata->flags & MX1_CAMERA_VSYNC_HIGH)
-				common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+				common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
 			else
-				common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+				common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 	}
 
-	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
-		(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
+		(common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
 			if (!pcdev->pdata ||
 			     pcdev->pdata->flags & MX1_CAMERA_PCLK_RISING)
-				common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+				common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
 			else
-				common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+				common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 	}
 
-	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
-		(common_flags & SOCAM_DATA_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_DATA_ACTIVE_HIGH) &&
+		(common_flags & V4L2_MBUS_DATA_ACTIVE_LOW)) {
 			if (!pcdev->pdata ||
 			     pcdev->pdata->flags & MX1_CAMERA_DATA_HIGH)
-				common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
+				common_flags &= ~V4L2_MBUS_DATA_ACTIVE_LOW;
 			else
-				common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
+				common_flags &= ~V4L2_MBUS_DATA_ACTIVE_HIGH;
 	}
 
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
+	cfg.flags = common_flags;
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
+			common_flags, ret);
 		return ret;
+	}
 
 	csicr1 = __raw_readl(pcdev->base + CSICR1);
 
-	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
+	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		csicr1 |= CSICR1_REDGE;
-	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
+	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_SOF_POL;
-	if (common_flags & SOCAM_DATA_ACTIVE_LOW)
+	if (common_flags & V4L2_MBUS_DATA_ACTIVE_LOW)
 		csicr1 |= CSICR1_DATA_POL;
 
 	__raw_writel(csicr1, pcdev->base + CSICR1);
-- 
1.7.2.5

