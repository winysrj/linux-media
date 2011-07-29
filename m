Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 793DF18B051
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007om-DS
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 37/59] V4L: pxa_camera: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:37 +0200
Message-Id: <1311937019-29914-38-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |  140 ++++++++++++++++++++++----------------
 1 files changed, 80 insertions(+), 60 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index d07df22..79fb22c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -214,6 +214,7 @@ struct pxa_camera_dev {
 	unsigned long		ciclk;
 	unsigned long		mclk;
 	u32			mclk_divisor;
+	u16			width_flags;	/* max 10 bits */
 
 	struct list_head	capture;
 
@@ -1020,37 +1021,20 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 	 * quick capture interface supports both.
 	 */
 	*flags = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
-		  SOCAM_MASTER : SOCAM_SLAVE) |
-		SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_DATA_ACTIVE_HIGH |
-		SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_PCLK_SAMPLE_FALLING;
+		  V4L2_MBUS_MASTER : V4L2_MBUS_SLAVE) |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		V4L2_MBUS_DATA_ACTIVE_HIGH |
+		V4L2_MBUS_PCLK_SAMPLE_RISING |
+		V4L2_MBUS_PCLK_SAMPLE_FALLING;
 
 	/* If requested data width is supported by the platform, use it */
-	switch (buswidth) {
-	case 10:
-		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10))
-			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_10;
-		break;
-	case 9:
-		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9))
-			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_9;
-		break;
-	case 8:
-		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8))
-			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_8;
-		break;
-	default:
-		return -EINVAL;
-	}
+	if ((1 << (buswidth - 1)) & pcdev->width_flags)
+		return 0;
 
-	return 0;
+	return -EINVAL;
 }
 
 static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
@@ -1070,12 +1054,12 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	 * Datawidth is now guaranteed to be equal to one of the three values.
 	 * We fix bit-per-pixel equal to data-width...
 	 */
-	switch (flags & SOCAM_DATAWIDTH_MASK) {
-	case SOCAM_DATAWIDTH_10:
+	switch (icd->current_fmt->host_fmt->bits_per_sample) {
+	case 10:
 		dw = 4;
 		bpp = 0x40;
 		break;
-	case SOCAM_DATAWIDTH_9:
+	case 9:
 		dw = 3;
 		bpp = 0x20;
 		break;
@@ -1084,7 +1068,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 		 * Actually it can only be 8 now,
 		 * default is just to silence compiler warnings
 		 */
-	case SOCAM_DATAWIDTH_8:
+	case 8:
 		dw = 2;
 		bpp = 0;
 	}
@@ -1093,11 +1077,11 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 		cicr4 |= CICR4_PCLK_EN;
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		cicr4 |= CICR4_MCLK_EN;
-	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cicr4 |= CICR4_PCP;
-	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_HSP;
-	if (flags & SOCAM_VSYNC_ACTIVE_LOW)
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_VSP;
 
 	cicr0 = __raw_readl(pcdev->base + CICR0);
@@ -1151,9 +1135,11 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 
 static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	unsigned long bus_flags, camera_flags, common_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long bus_flags, common_flags;
 	int ret;
 	struct pxa_cam *cam = icd->host_priv;
 
@@ -1162,44 +1148,58 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	if (ret < 0)
 		return ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	if (!common_flags)
-		return -EINVAL;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  bus_flags);
+		if (!common_flags) {
+			dev_warn(icd->parent,
+				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
+				 cfg.flags, bus_flags);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	} else {
+		common_flags = bus_flags;
+	}
 
 	pcdev->channels = 1;
 
 	/* Make choises, based on platform preferences */
-	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
 		if (pcdev->platform_flags & PXA_CAMERA_HSP)
-			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
+			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
 		else
-			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
+			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
 	}
 
-	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
 		if (pcdev->platform_flags & PXA_CAMERA_VSP)
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 		else
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
 	}
 
-	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
-	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
+	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
 		if (pcdev->platform_flags & PXA_CAMERA_PCP)
-			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 		else
-			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
 	}
 
-	cam->flags = common_flags;
-
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
+	cfg.flags = common_flags;
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
+			common_flags, ret);
 		return ret;
+	}
+
+	cam->flags = common_flags;
 
 	pxa_camera_setup_cicr(icd, common_flags, pixfmt);
 
@@ -1209,17 +1209,31 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 				    unsigned char buswidth)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	unsigned long bus_flags, camera_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long bus_flags, common_flags;
 	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
 
 	if (ret < 0)
 		return ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  bus_flags);
+		if (!common_flags) {
+			dev_warn(icd->parent,
+				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
+				 cfg.flags, bus_flags);
+			return -EINVAL;
+		}
+	} else if (ret == -ENOIOCTLCMD) {
+		ret = 0;
+	}
 
-	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
+	return ret;
 }
 
 static const struct soc_mbus_pixelfmt pxa_camera_formats[] = {
@@ -1687,6 +1701,12 @@ static int __devinit pxa_camera_probe(struct platform_device *pdev)
 			 "data widths, using default 10 bit\n");
 		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
 	}
+	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
+		pcdev->width_flags = 1 << 7;
+	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
+		pcdev->width_flags |= 1 << 8;
+	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
+		pcdev->width_flags |= 1 << 9;
 	pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
 	if (!pcdev->mclk) {
 		dev_warn(&pdev->dev,
-- 
1.7.2.5

