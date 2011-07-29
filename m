Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63718 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 4494318B04D
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007oX-5T
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 32/59] V4L: mx2_camera: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:32 +0200
Message-Id: <1311937019-29914-33-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx2_camera.c |   78 ++++++++++++++++++++++----------------
 1 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ec2410c..a803d9e 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -686,16 +686,15 @@ static void mx2_camera_init_videobuf(struct videobuf_queue *q,
 			icd, &icd->video_lock);
 }
 
-#define MX2_BUS_FLAGS	(SOCAM_DATAWIDTH_8 | \
-			SOCAM_MASTER | \
-			SOCAM_VSYNC_ACTIVE_HIGH | \
-			SOCAM_VSYNC_ACTIVE_LOW | \
-			SOCAM_HSYNC_ACTIVE_HIGH | \
-			SOCAM_HSYNC_ACTIVE_LOW | \
-			SOCAM_PCLK_SAMPLE_RISING | \
-			SOCAM_PCLK_SAMPLE_FALLING | \
-			SOCAM_DATA_ACTIVE_HIGH | \
-			SOCAM_DATA_ACTIVE_LOW)
+#define MX2_BUS_FLAGS	(V4L2_MBUS_MASTER | \
+			V4L2_MBUS_VSYNC_ACTIVE_HIGH | \
+			V4L2_MBUS_VSYNC_ACTIVE_LOW | \
+			V4L2_MBUS_HSYNC_ACTIVE_HIGH | \
+			V4L2_MBUS_HSYNC_ACTIVE_LOW | \
+			V4L2_MBUS_PCLK_SAMPLE_RISING | \
+			V4L2_MBUS_PCLK_SAMPLE_FALLING | \
+			V4L2_MBUS_DATA_ACTIVE_HIGH | \
+			V4L2_MBUS_DATA_ACTIVE_LOW)
 
 static int mx27_camera_emma_prp_reset(struct mx2_camera_dev *pcdev)
 {
@@ -770,46 +769,59 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 		__u32 pixfmt)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->parent);
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
-	unsigned long camera_flags, common_flags;
-	int ret = 0;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long common_flags;
+	int ret;
 	int bytesperline;
 	u32 csicr1 = pcdev->csicr1;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	common_flags = soc_camera_bus_param_compatible(camera_flags,
-				MX2_BUS_FLAGS);
-	if (!common_flags)
-		return -EINVAL;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg, MX2_BUS_FLAGS);
+		if (!common_flags) {
+			dev_warn(icd->parent,
+				 "Flags incompatible: camera 0x%x, host 0x%x\n",
+				 cfg.flags, MX2_BUS_FLAGS);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	} else {
+		common_flags = MX2_BUS_FLAGS;
+	}
 
-	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
 		if (pcdev->platform_flags & MX2_CAMERA_HSYNC_HIGH)
-			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
+			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
 		else
-			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
+			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
 	}
 
-	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
-	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
+	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
 		if (pcdev->platform_flags & MX2_CAMERA_PCLK_SAMPLE_RISING)
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
+		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
+			common_flags, ret);
 		return ret;
+	}
 
-	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
+	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		csicr1 |= CSICR1_REDGE;
-	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
+	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_SOF_POL;
-	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)
+	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_HSYNC_POL;
 	if (pcdev->platform_flags & MX2_CAMERA_SWAP16)
 		csicr1 |= CSICR1_SWAP16_EN;
-- 
1.7.2.5

