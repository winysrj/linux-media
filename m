Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54612 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 2F111189B83
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007oQ-2M
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 30/59] V4L: atmel-isi: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:30 +0200
Message-Id: <1311937019-29914-31-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/atmel-isi.c |  136 +++++++++++++++++++++------------------
 1 files changed, 73 insertions(+), 63 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 7b89f00..3e3d4cc 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -94,6 +94,7 @@ struct atmel_isi {
 	unsigned int			irq;
 
 	struct isi_platform_data	*pdata;
+	u16				width_flags;	/* max 12 bits */
 
 	struct list_head		video_buffer_list;
 	struct frame_buffer		*active;
@@ -637,50 +638,42 @@ static bool isi_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
-static unsigned long make_bus_param(struct atmel_isi *isi)
-{
-	unsigned long flags;
-	/*
-	 * Platform specified synchronization and pixel clock polarities are
-	 * only a recommendation and are only used during probing. Atmel ISI
-	 * camera interface only works in master mode, i.e., uses HSYNC and
-	 * VSYNC signals from the sensor
-	 */
-	flags = SOCAM_MASTER |
-		SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_DATA_ACTIVE_HIGH;
-
-	if (isi->pdata->data_width_flags & ISI_DATAWIDTH_10)
-		flags |= SOCAM_DATAWIDTH_10;
-
-	if (isi->pdata->data_width_flags & ISI_DATAWIDTH_8)
-		flags |= SOCAM_DATAWIDTH_8;
-
-	if (flags & SOCAM_DATAWIDTH_MASK)
-		return flags;
-
-	return 0;
-}
+#define ISI_BUS_PARAM (V4L2_MBUS_MASTER |	\
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
+		V4L2_MBUS_HSYNC_ACTIVE_LOW |	\
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH |	\
+		V4L2_MBUS_VSYNC_ACTIVE_LOW |	\
+		V4L2_MBUS_PCLK_SAMPLE_RISING |	\
+		V4L2_MBUS_PCLK_SAMPLE_FALLING |	\
+		V4L2_MBUS_DATA_ACTIVE_HIGH)
 
 static int isi_camera_try_bus_param(struct soc_camera_device *icd,
 				    unsigned char buswidth)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	unsigned long camera_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long common_flags;
 	int ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-	ret = soc_camera_bus_param_compatible(camera_flags,
-					make_bus_param(isi));
-	if (!ret)
-		return -EINVAL;
-	return 0;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  ISI_BUS_PARAM);
+		if (!common_flags) {
+			dev_warn(icd->parent,
+				 "Flags incompatible: camera 0x%x, host 0x%x\n",
+				 cfg.flags, ISI_BUS_PARAM);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	}
+
+	if ((1 << (buswidth - 1)) & isi->width_flags)
+		return 0;
+	return -EINVAL;
 }
 
 
@@ -802,59 +795,71 @@ static int isi_camera_querycap(struct soc_camera_host *ici,
 
 static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	unsigned long bus_flags, camera_flags, common_flags;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long common_flags;
 	int ret;
 	u32 cfg1 = 0;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	bus_flags = make_bus_param(isi);
-	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	dev_dbg(icd->parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
-		camera_flags, bus_flags, common_flags);
-	if (!common_flags)
-		return -EINVAL;
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  ISI_BUS_PARAM);
+		if (!common_flags) {
+			dev_warn(icd->parent,
+				 "Flags incompatible: camera 0x%x, host 0x%x\n",
+				 cfg.flags, ISI_BUS_PARAM);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	} else {
+		common_flags = ISI_BUS_PARAM;
+	}
+	dev_dbg(icd->parent, "Flags cam: 0x%x host: 0x%x common: 0x%lx\n",
+		cfg.flags, ISI_BUS_PARAM, common_flags);
 
 	/* Make choises, based on platform preferences */
-	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
 		if (isi->pdata->hsync_act_low)
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
 		if (isi->pdata->vsync_act_low)
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
 		if (isi->pdata->pclk_act_falling)
-			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
 		else
-			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
 	}
 
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0) {
-		dev_dbg(icd->parent, "Camera set_bus_param(%lx) returned %d\n",
+	cfg.flags = common_flags;
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
 
 	/* set bus param for ISI */
-	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
+	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;
-	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
+	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
 		cfg1 |= ISI_CFG1_VSYNC_POL_ACTIVE_LOW;
-	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
+	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
 
 	if (isi->pdata->has_emb_sync)
@@ -973,6 +978,11 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	if (pdata->data_width_flags & ISI_DATAWIDTH_8)
+		isi->width_flags = 1 << 7;
+	if (pdata->data_width_flags & ISI_DATAWIDTH_10)
+		isi->width_flags |= 1 << 9;
+
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 
 	irq = platform_get_irq(pdev, 0);
-- 
1.7.2.5

