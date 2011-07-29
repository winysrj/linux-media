Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 871C418B052
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007op-FK
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 38/59] V4L: sh_mobile_ceu_camera: convert to the new mbus-config subdev operations
Date: Fri, 29 Jul 2011 12:56:38 +0200
Message-Id: <1311937019-29914-39-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from soc-camera specific .{query,set}_bus_param() to V4L2
subdevice .[gs]_mbus_config() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |  156 +++++++++++++++-------------
 1 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index aa187a4..dedc981 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -144,30 +144,6 @@ static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_buffer *vb)
 	return container_of(vb, struct sh_mobile_ceu_buffer, vb);
 }
 
-static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
-{
-	unsigned long flags;
-
-	flags = SOCAM_MASTER |
-		SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_DATA_ACTIVE_HIGH;
-
-	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_8BIT_BUS)
-		flags |= SOCAM_DATAWIDTH_8;
-
-	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_16BIT_BUS)
-		flags |= SOCAM_DATAWIDTH_16;
-
-	if (flags & SOCAM_DATAWIDTH_MASK)
-		return flags;
-
-	return 0;
-}
-
 static void ceu_write(struct sh_mobile_ceu_dev *priv,
 		      unsigned long reg_offs, u32 data)
 {
@@ -737,66 +713,90 @@ static void capture_restore(struct sh_mobile_ceu_dev *pcdev, u32 capsr)
 		ceu_write(pcdev, CAPSR, capsr);
 }
 
+/* Find the bus subdevice driver, e.g., CSI2 */
+static struct v4l2_subdev *find_bus_subdev(struct sh_mobile_ceu_dev *pcdev,
+					   struct soc_camera_device *icd)
+{
+	if (!pcdev->csi2_pdev)
+		return soc_camera_to_subdev(icd);
+
+	return find_csi2(pcdev);
+}
+
+#define CEU_BUS_FLAGS (V4L2_MBUS_MASTER |	\
+		V4L2_MBUS_PCLK_SAMPLE_RISING |	\
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
+		V4L2_MBUS_HSYNC_ACTIVE_LOW |	\
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH |	\
+		V4L2_MBUS_VSYNC_ACTIVE_LOW |	\
+		V4L2_MBUS_DATA_ACTIVE_HIGH)
+
 /* Capture is not running, no interrupts, no locking needed */
 static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 				       __u32 pixfmt)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int ret;
-	unsigned long camera_flags, common_flags, value;
-	int yuv_lineskip;
+	struct v4l2_subdev *sd = find_bus_subdev(pcdev, icd);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long value, common_flags = CEU_BUS_FLAGS;
 	u32 capsr = capture_save_reset(pcdev);
+	unsigned int yuv_lineskip;
+	int ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-	common_flags = soc_camera_bus_param_compatible(camera_flags,
-						       make_bus_param(pcdev));
-	if (!common_flags)
-		return -EINVAL;
+	/*
+	 * If the client doesn't implement g_mbus_config, we just use our
+	 * platform data
+	 */
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  common_flags);
+		if (!common_flags)
+			return -EINVAL;
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	}
 
 	/* Make choises, based on platform preferences */
-	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
 		if (pcdev->pdata->flags & SH_CEU_FLAG_HSYNC_LOW)
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
 		if (pcdev->pdata->flags & SH_CEU_FLAG_VSYNC_LOW)
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 		else
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
 	}
 
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
+	cfg.flags = common_flags;
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
-	switch (common_flags & SOCAM_DATAWIDTH_MASK) {
-	case SOCAM_DATAWIDTH_8:
-		pcdev->is_16bit = 0;
-		break;
-	case SOCAM_DATAWIDTH_16:
+	if (icd->current_fmt->host_fmt->bits_per_sample > 8)
 		pcdev->is_16bit = 1;
-		break;
-	default:
-		return -EINVAL;
-	}
+	else
+		pcdev->is_16bit = 0;
 
 	ceu_write(pcdev, CRCNTR, 0);
 	ceu_write(pcdev, CRCMPR, 0);
 
 	value = 0x00000010; /* data fetch by default */
-	yuv_lineskip = 0;
+	yuv_lineskip = 0x10;
 
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
-		yuv_lineskip = 1; /* skip for NV12/21, no skip for NV16/61 */
+		/* convert 4:2:2 -> 4:2:0 */
+		yuv_lineskip = 0; /* skip for NV12/21, no skip for NV16/61 */
 		/* fall-through */
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
@@ -822,8 +822,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	    icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV61)
 		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
 
-	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
-	value |= common_flags & SOCAM_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
+	value |= common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
+	value |= common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
 	value |= pcdev->is_16bit ? 1 << 12 : 0;
 
 	/* CSI2 mode */
@@ -866,9 +866,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	 * using 7 we swap the data bytes to match the incoming order:
 	 * D0, D1, D2, D3, D4, D5, D6, D7
 	 */
-	value = 0x00000017;
-	if (yuv_lineskip)
-		value &= ~0x00000010; /* convert 4:2:2 -> 4:2:0 */
+	value = 0x00000007 | yuv_lineskip;
 
 	ceu_write(pcdev, CDOCR, value);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
@@ -889,13 +887,19 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	unsigned long camera_flags, common_flags;
+	struct v4l2_subdev *sd = find_bus_subdev(pcdev, icd);
+	unsigned long common_flags = CEU_BUS_FLAGS;
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	int ret;
 
-	camera_flags = icd->ops->query_bus_param(icd);
-	common_flags = soc_camera_bus_param_compatible(camera_flags,
-						       make_bus_param(pcdev));
-	if (!common_flags || buswidth > 16 ||
-	    (buswidth > 8 && !(common_flags & SOCAM_DATAWIDTH_16)))
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (!ret)
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  common_flags);
+	else if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	if (!common_flags || buswidth > 16)
 		return -EINVAL;
 
 	return 0;
@@ -905,26 +909,26 @@ static const struct soc_mbus_pixelfmt sh_mobile_ceu_formats[] = {
 	{
 		.fourcc			= V4L2_PIX_FMT_NV12,
 		.name			= "NV12",
-		.bits_per_sample	= 12,
-		.packing		= SOC_MBUS_PACKING_NONE,
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_NV21,
 		.name			= "NV21",
-		.bits_per_sample	= 12,
-		.packing		= SOC_MBUS_PACKING_NONE,
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_NV16,
 		.name			= "NV16",
-		.bits_per_sample	= 16,
-		.packing		= SOC_MBUS_PACKING_NONE,
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_NV61,
 		.name			= "NV61",
-		.bits_per_sample	= 16,
-		.packing		= SOC_MBUS_PACKING_NONE,
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 };
@@ -934,6 +938,8 @@ static bool sh_mobile_ceu_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 {
 	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
 		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_1_5X8) ||
+		(fmt->bits_per_sample == 8 &&
 		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
 		(fmt->bits_per_sample > 8 &&
 		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
@@ -966,6 +972,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 	}
 
 	if (!pcdev->pdata->csi2) {
+		/* Are there any restrictions in the CSI-2 case? */
 		ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
 		if (ret < 0)
 			return 0;
@@ -1626,8 +1633,6 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	bool image_mode;
 	enum v4l2_field field;
 
-	dev_geo(dev, "S_FMT(pix=0x%x, %ux%u)\n", pixfmt, pix->width, pix->height);
-
 	switch (pix->field) {
 	default:
 		pix->field = V4L2_FIELD_NONE;
@@ -1665,6 +1670,9 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		image_mode = false;
 	}
 
+	dev_info(dev, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n", pixfmt, mf.field, mf.code,
+		pix->width, pix->height);
+
 	dev_geo(dev, "4: request camera output %ux%u\n", mf.width, mf.height);
 
 	/* 5. - 9. */
-- 
1.7.2.5

