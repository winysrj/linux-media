Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 5E07A18B04E
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007od-9A
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 34/59] V4L: mx3_camera: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:34 +0200
Message-Id: <1311937019-29914-35-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx3_camera.c |  197 +++++++++++++++++---------------------
 1 files changed, 89 insertions(+), 108 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index c045b47..3f37522f 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -109,6 +109,7 @@ struct mx3_camera_dev {
 
 	unsigned long		platform_flags;
 	unsigned long		mclk;
+	u16			width_flags;	/* max 15 bits */
 
 	struct list_head	capture;
 	spinlock_t		lock;		/* Protects video buffer lists */
@@ -548,58 +549,27 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 			       unsigned char buswidth, unsigned long *flags)
 {
 	/*
+	 * If requested data width is supported by the platform, use it or any
+	 * possible lower value - i.MX31 is smart enough to shift bits
+	 */
+	if (buswidth > fls(mx3_cam->width_flags))
+		return -EINVAL;
+
+	/*
 	 * Platform specified synchronization and pixel clock polarities are
 	 * only a recommendation and are only used during probing. MX3x
 	 * camera interface only works in master mode, i.e., uses HSYNC and
 	 * VSYNC signals from the sensor
 	 */
-	*flags = SOCAM_MASTER |
-		SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_DATA_ACTIVE_HIGH |
-		SOCAM_DATA_ACTIVE_LOW;
-
-	/*
-	 * If requested data width is supported by the platform, use it or any
-	 * possible lower value - i.MX31 is smart enough to schift bits
-	 */
-	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
-		*flags |= SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_10 |
-			SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
-	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10)
-		*flags |= SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_8 |
-			SOCAM_DATAWIDTH_4;
-	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8)
-		*flags |= SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
-	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4)
-		*flags |= SOCAM_DATAWIDTH_4;
-
-	switch (buswidth) {
-	case 15:
-		if (!(*flags & SOCAM_DATAWIDTH_15))
-			return -EINVAL;
-		break;
-	case 10:
-		if (!(*flags & SOCAM_DATAWIDTH_10))
-			return -EINVAL;
-		break;
-	case 8:
-		if (!(*flags & SOCAM_DATAWIDTH_8))
-			return -EINVAL;
-		break;
-	case 4:
-		if (!(*flags & SOCAM_DATAWIDTH_4))
-			return -EINVAL;
-		break;
-	default:
-		dev_warn(mx3_cam->soc_host.v4l2_dev.dev,
-			 "Unsupported bus width %d\n", buswidth);
-		return -EINVAL;
-	}
+	*flags = V4L2_MBUS_MASTER |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		V4L2_MBUS_PCLK_SAMPLE_RISING |
+		V4L2_MBUS_PCLK_SAMPLE_FALLING |
+		V4L2_MBUS_DATA_ACTIVE_HIGH |
+		V4L2_MBUS_DATA_ACTIVE_LOW;
 
 	return 0;
 }
@@ -607,9 +577,11 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 				    const unsigned int depth)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	unsigned long bus_flags, camera_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long bus_flags, common_flags;
 	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
 
 	dev_dbg(icd->parent, "request bus width %d bit: %d\n", depth, ret);
@@ -617,15 +589,21 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	ret = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	if (ret < 0)
-		dev_warn(icd->parent,
-			 "Flags incompatible: camera %lx, host %lx\n",
-			 camera_flags, bus_flags);
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
+	}
 
-	return ret;
+	return 0;
 }
 
 static bool chan_filter(struct dma_chan *chan, void *arg)
@@ -994,9 +972,11 @@ static int mx3_camera_querycap(struct soc_camera_host *ici,
 
 static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	unsigned long bus_flags, camera_flags, common_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long bus_flags, common_flags;
 	u32 dw, sens_conf;
 	const struct soc_mbus_pixelfmt *fmt;
 	int buswidth;
@@ -1008,83 +988,76 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	if (!fmt)
 		return -EINVAL;
 
-	buswidth = fmt->bits_per_sample;
-	ret = test_platform_param(mx3_cam, buswidth, &bus_flags);
-
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		dev_warn(dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
+	buswidth = fmt->bits_per_sample;
+	ret = test_platform_param(mx3_cam, buswidth, &bus_flags);
+
 	dev_dbg(dev, "requested bus width %d bit: %d\n", buswidth, ret);
 
 	if (ret < 0)
 		return ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	dev_dbg(dev, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
-		camera_flags, bus_flags, common_flags);
-	if (!common_flags) {
-		dev_dbg(dev, "no common flags");
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
 	}
 
+	dev_dbg(dev, "Flags cam: 0x%x host: 0x%lx common: 0x%lx\n",
+		cfg.flags, bus_flags, common_flags);
+
 	/* Make choices, based on platform preferences */
-	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
 		if (mx3_cam->platform_flags & MX3_CAMERA_HSP)
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
 		if (mx3_cam->platform_flags & MX3_CAMERA_VSP)
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 		else
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
 	}
 
-	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_DATA_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_DATA_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_DATA_ACTIVE_LOW)) {
 		if (mx3_cam->platform_flags & MX3_CAMERA_DP)
-			common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
+			common_flags &= ~V4L2_MBUS_DATA_ACTIVE_HIGH;
 		else
-			common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
+			common_flags &= ~V4L2_MBUS_DATA_ACTIVE_LOW;
 	}
 
-	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
-	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
+	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
 		if (mx3_cam->platform_flags & MX3_CAMERA_PCP)
-			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 		else
-			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
 	}
 
-	/*
-	 * Make the camera work in widest common mode, we'll take care of
-	 * the rest
-	 */
-	if (common_flags & SOCAM_DATAWIDTH_15)
-		common_flags = (common_flags & ~SOCAM_DATAWIDTH_MASK) |
-			SOCAM_DATAWIDTH_15;
-	else if (common_flags & SOCAM_DATAWIDTH_10)
-		common_flags = (common_flags & ~SOCAM_DATAWIDTH_MASK) |
-			SOCAM_DATAWIDTH_10;
-	else if (common_flags & SOCAM_DATAWIDTH_8)
-		common_flags = (common_flags & ~SOCAM_DATAWIDTH_MASK) |
-			SOCAM_DATAWIDTH_8;
-	else
-		common_flags = (common_flags & ~SOCAM_DATAWIDTH_MASK) |
-			SOCAM_DATAWIDTH_4;
-
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0) {
-		dev_dbg(dev, "camera set_bus_param(%lx) returned %d\n",
+	cfg.flags = common_flags;
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		dev_dbg(dev, "camera s_mbus_config(0x%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
@@ -1108,13 +1081,13 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	/* This has been set in mx3_camera_activate(), but we clear it above */
 	sens_conf |= CSI_SENS_CONF_DATA_FMT_BAYER;
 
-	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
+	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		sens_conf |= 1 << CSI_SENS_CONF_PIX_CLK_POL_SHIFT;
-	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
+	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		sens_conf |= 1 << CSI_SENS_CONF_HSYNC_POL_SHIFT;
-	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
+	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
 		sens_conf |= 1 << CSI_SENS_CONF_VSYNC_POL_SHIFT;
-	if (common_flags & SOCAM_DATA_ACTIVE_LOW)
+	if (common_flags & V4L2_MBUS_DATA_ACTIVE_LOW)
 		sens_conf |= 1 << CSI_SENS_CONF_DATA_POL_SHIFT;
 
 	/* Just do what we're asked to do */
@@ -1199,6 +1172,14 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 			 "data widths, using default 8 bit\n");
 		mx3_cam->platform_flags |= MX3_CAMERA_DATAWIDTH_8;
 	}
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4)
+		mx3_cam->width_flags = 1 << 3;
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8)
+		mx3_cam->width_flags |= 1 << 7;
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10)
+		mx3_cam->width_flags |= 1 << 9;
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
+		mx3_cam->width_flags |= 1 << 14;
 
 	mx3_cam->mclk = mx3_cam->pdata->mclk_10khz * 10000;
 	if (!mx3_cam->mclk) {
-- 
1.7.2.5

