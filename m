Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m27Lvtoi018059
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 16:57:55 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m27LvNcB015549
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 16:57:23 -0500
Date: Fri, 7 Mar 2008 22:57:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0803072240140.20036@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] soc-camera: streamline hardware parameter negotiation
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Improve hardware parameter negotiation between the camera host driver and 
camera drivers. Parameters like horizontal and vertical synchronisation, 
pixel clock polarity shall be set depending on capabilities of the 
parties.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 4ad8343..117af9c 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -210,40 +210,64 @@ static int bus_switch_act(struct mt9m001 *mt9m001, int go8bit)
 #endif
 }
 
-static int mt9m001_set_capture_format(struct soc_camera_device *icd,
-		__u32 pixfmt, struct v4l2_rect *rect, unsigned int flags)
+static int bus_switch_possible(struct mt9m001 *mt9m001)
+{
+#ifdef CONFIG_MT9M001_PCA9536_SWITCH
+	return gpio_is_valid(mt9m001->switch_gpio);
+#else
+	return 0;
+#endif
+}
+
+static int mt9m001_set_bus_param(struct soc_camera_device *icd,
+				 unsigned long flags)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	unsigned int width_flag = flags & (IS_DATAWIDTH_10 | IS_DATAWIDTH_9 |
-					   IS_DATAWIDTH_8);
+	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
 	int ret;
-	const u16 hblank = 9, vblank = 25;
 
-	/* MT9M001 has all capture_format parameters fixed */
-	if (!(flags & IS_MASTER) ||
-	    !(flags & IS_PCLK_SAMPLE_RISING) ||
-	    !(flags & IS_HSYNC_ACTIVE_HIGH) ||
-	    !(flags & IS_VSYNC_ACTIVE_HIGH))
-		return -EINVAL;
-
-	/* Only one width bit may be set */
-	if (!is_power_of_2(width_flag))
-		return -EINVAL;
+	/* Flags validity verified in test_bus_param */
 
-	if ((mt9m001->datawidth != 10 && (width_flag == IS_DATAWIDTH_10)) ||
-	    (mt9m001->datawidth != 9  && (width_flag == IS_DATAWIDTH_9)) ||
-	    (mt9m001->datawidth != 8  && (width_flag == IS_DATAWIDTH_8))) {
+	if ((mt9m001->datawidth != 10 && (width_flag == SOCAM_DATAWIDTH_10)) ||
+	    (mt9m001->datawidth != 9  && (width_flag == SOCAM_DATAWIDTH_9)) ||
+	    (mt9m001->datawidth != 8  && (width_flag == SOCAM_DATAWIDTH_8))) {
 		/* Well, we actually only can do 10 or 8 bits... */
-		if (width_flag == IS_DATAWIDTH_9)
+		if (width_flag == SOCAM_DATAWIDTH_9)
 			return -EINVAL;
 		ret = bus_switch_act(mt9m001,
-				     width_flag == IS_DATAWIDTH_8);
+				     width_flag == SOCAM_DATAWIDTH_8);
 		if (ret < 0)
 			return ret;
 
-		mt9m001->datawidth = width_flag == IS_DATAWIDTH_8 ? 8 : 10;
+		mt9m001->datawidth = width_flag == SOCAM_DATAWIDTH_8 ? 8 : 10;
 	}
 
+	return 0;
+}
+
+static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
+{
+	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	unsigned int width_flag = SOCAM_DATAWIDTH_10;
+
+	if (bus_switch_possible(mt9m001))
+		width_flag |= SOCAM_DATAWIDTH_8;
+
+	/* MT9M001 has all capture_format parameters fixed */
+	return SOCAM_PCLK_SAMPLE_RISING |
+		SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_MASTER |
+		width_flag;
+}
+
+static int mt9m001_set_fmt_cap(struct soc_camera_device *icd,
+		__u32 pixfmt, struct v4l2_rect *rect)
+{
+	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	int ret;
+	const u16 hblank = 9, vblank = 25;
+
 	/* Blanking and start values - default... */
 	ret = reg_write(icd, MT9M001_HORIZONTAL_BLANKING, hblank);
 	if (ret >= 0)
@@ -348,12 +372,6 @@ static int mt9m001_set_register(struct soc_camera_device *icd,
 }
 #endif
 
-static unsigned int mt9m001_get_datawidth(struct soc_camera_device *icd)
-{
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	return mt9m001->datawidth;
-}
-
 const struct v4l2_queryctrl mt9m001_controls[] = {
 	{
 		.id		= V4L2_CID_VFLIP,
@@ -401,11 +419,12 @@ static struct soc_camera_ops mt9m001_ops = {
 	.release		= mt9m001_release,
 	.start_capture		= mt9m001_start_capture,
 	.stop_capture		= mt9m001_stop_capture,
-	.set_capture_format	= mt9m001_set_capture_format,
+	.set_fmt_cap		= mt9m001_set_fmt_cap,
 	.try_fmt_cap		= mt9m001_try_fmt_cap,
+	.set_bus_param		= mt9m001_set_bus_param,
+	.query_bus_param	= mt9m001_query_bus_param,
 	.formats		= NULL, /* Filled in later depending on the */
 	.num_formats		= 0,	/* camera type and data widths */
-	.get_datawidth		= mt9m001_get_datawidth,
 	.controls		= mt9m001_controls,
 	.num_controls		= ARRAY_SIZE(mt9m001_controls),
 	.get_control		= mt9m001_get_control,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index d677344..f2f11b8 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -241,19 +241,89 @@ static int bus_switch_act(struct mt9v022 *mt9v022, int go8bit)
 #endif
 }
 
-static int mt9v022_set_capture_format(struct soc_camera_device *icd,
-		__u32 pixfmt, struct v4l2_rect *rect, unsigned int flags)
+static int bus_switch_possible(struct mt9v022 *mt9v022)
+{
+#ifdef CONFIG_MT9V022_PCA9536_SWITCH
+	return gpio_is_valid(mt9v022->switch_gpio);
+#else
+	return 0;
+#endif
+}
+
+static int mt9v022_set_bus_param(struct soc_camera_device *icd,
+				 unsigned long flags)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	unsigned int width_flag = flags & (IS_DATAWIDTH_10 | IS_DATAWIDTH_9 |
-					   IS_DATAWIDTH_8);
-	u16 pixclk = 0;
+	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
 	int ret;
+	u16 pixclk = 0;
 
 	/* Only one width bit may be set */
 	if (!is_power_of_2(width_flag))
 		return -EINVAL;
 
+	if ((mt9v022->datawidth != 10 && (width_flag == SOCAM_DATAWIDTH_10)) ||
+	    (mt9v022->datawidth != 9  && (width_flag == SOCAM_DATAWIDTH_9)) ||
+	    (mt9v022->datawidth != 8  && (width_flag == SOCAM_DATAWIDTH_8))) {
+		/* Well, we actually only can do 10 or 8 bits... */
+		if (width_flag == SOCAM_DATAWIDTH_9)
+			return -EINVAL;
+
+		ret = bus_switch_act(mt9v022,
+				     width_flag == SOCAM_DATAWIDTH_8);
+		if (ret < 0)
+			return ret;
+
+		mt9v022->datawidth = width_flag == SOCAM_DATAWIDTH_8 ? 8 : 10;
+	}
+
+	if (flags & SOCAM_PCLK_SAMPLE_RISING)
+		pixclk |= 0x10;
+
+	if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
+		pixclk |= 0x1;
+
+	if (!(flags & SOCAM_VSYNC_ACTIVE_HIGH))
+		pixclk |= 0x2;
+
+	ret = reg_write(icd, MT9V022_PIXCLK_FV_LV, pixclk);
+	if (ret < 0)
+		return ret;
+
+	if (!(flags & SOCAM_MASTER))
+		mt9v022->chip_control &= ~0x8;
+
+	ret = reg_write(icd, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(&icd->dev, "Calculated pixclk 0x%x, chip control 0x%x\n",
+		pixclk, mt9v022->chip_control);
+
+	return 0;
+}
+
+static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
+{
+	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	unsigned int width_flag = SOCAM_DATAWIDTH_10;
+
+	if (bus_switch_possible(mt9v022))
+		width_flag |= SOCAM_DATAWIDTH_8;
+
+	return SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
+		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
+		SOCAM_MASTER | SOCAM_SLAVE |
+		width_flag;
+}
+
+static int mt9v022_set_fmt_cap(struct soc_camera_device *icd,
+		__u32 pixfmt, struct v4l2_rect *rect)
+{
+	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	int ret;
+
 	/* The caller provides a supported format, as verified per call to
 	 * icd->try_fmt_cap(), datawidth is from our supported format list */
 	switch (pixfmt) {
@@ -308,44 +378,6 @@ static int mt9v022_set_capture_format(struct soc_camera_device *icd,
 
 	dev_dbg(&icd->dev, "Frame %ux%u pixel\n", rect->width, rect->height);
 
-	if ((mt9v022->datawidth != 10 && (width_flag == IS_DATAWIDTH_10)) ||
-	    (mt9v022->datawidth != 9  && (width_flag == IS_DATAWIDTH_9)) ||
-	    (mt9v022->datawidth != 8  && (width_flag == IS_DATAWIDTH_8))) {
-		/* Well, we actually only can do 10 or 8 bits... */
-		if (width_flag == IS_DATAWIDTH_9)
-			return -EINVAL;
-
-		ret = bus_switch_act(mt9v022,
-				     width_flag == IS_DATAWIDTH_8);
-		if (ret < 0)
-			return ret;
-
-		mt9v022->datawidth = width_flag == IS_DATAWIDTH_8 ? 8 : 10;
-	}
-
-	if (flags & IS_PCLK_SAMPLE_RISING)
-		pixclk |= 0x10;
-
-	if (!(flags & IS_HSYNC_ACTIVE_HIGH))
-		pixclk |= 0x1;
-
-	if (!(flags & IS_VSYNC_ACTIVE_HIGH))
-		pixclk |= 0x2;
-
-	ret = reg_write(icd, MT9V022_PIXCLK_FV_LV, pixclk);
-	if (ret < 0)
-		return ret;
-
-	if (!(flags & IS_MASTER))
-		mt9v022->chip_control &= ~0x8;
-
-	ret = reg_write(icd, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
-	if (ret < 0)
-		return ret;
-
-	dev_dbg(&icd->dev, "Calculated pixclk 0x%x, chip control 0x%x\n",
-		pixclk, mt9v022->chip_control);
-
 	return 0;
 }
 
@@ -420,12 +452,6 @@ static int mt9v022_set_register(struct soc_camera_device *icd,
 }
 #endif
 
-static unsigned int mt9v022_get_datawidth(struct soc_camera_device *icd)
-{
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	return mt9v022->datawidth;
-}
-
 const struct v4l2_queryctrl mt9v022_controls[] = {
 	{
 		.id		= V4L2_CID_VFLIP,
@@ -491,11 +517,12 @@ static struct soc_camera_ops mt9v022_ops = {
 	.release		= mt9v022_release,
 	.start_capture		= mt9v022_start_capture,
 	.stop_capture		= mt9v022_stop_capture,
-	.set_capture_format	= mt9v022_set_capture_format,
+	.set_fmt_cap		= mt9v022_set_fmt_cap,
 	.try_fmt_cap		= mt9v022_try_fmt_cap,
+	.set_bus_param		= mt9v022_set_bus_param,
+	.query_bus_param	= mt9v022_query_bus_param,
 	.formats		= NULL, /* Filled in later depending on the */
 	.num_formats		= 0,	/* sensor type and data widths */
-	.get_datawidth		= mt9v022_get_datawidth,
 	.controls		= mt9v022_controls,
 	.num_controls		= ARRAY_SIZE(mt9v022_controls),
 	.get_control		= mt9v022_get_control,
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index a34a193..8e29a38 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -581,64 +581,109 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 	pcdev->icd = NULL;
 }
 
-static int pxa_camera_set_capture_format(struct soc_camera_device *icd,
-					 __u32 pixfmt, struct v4l2_rect *rect)
+static int test_platform_param(struct pxa_camera_dev *pcdev,
+			       unsigned char buswidth, unsigned long *flags)
 {
-	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	unsigned int datawidth = 0, dw, bpp;
-	u32 cicr0, cicr4 = 0;
-	int ret;
+	/*
+	 * Platform specified synchronization and pixel clock polarities are
+	 * only a recommendation and are only used during probing. The PXA270
+	 * quick capture interface supports both.
+	 */
+	*flags = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
+		  SOCAM_MASTER : SOCAM_SLAVE) |
+		SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_HSYNC_ACTIVE_LOW |
+		SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_VSYNC_ACTIVE_LOW |
+		SOCAM_PCLK_SAMPLE_RISING |
+		SOCAM_PCLK_SAMPLE_FALLING;
 
 	/* If requested data width is supported by the platform, use it */
-	switch (icd->cached_datawidth) {
+	switch (buswidth) {
 	case 10:
-		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
-			datawidth = IS_DATAWIDTH_10;
+		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_10;
 		break;
 	case 9:
-		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
-			datawidth = IS_DATAWIDTH_9;
+		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_9;
 		break;
 	case 8:
-		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
-			datawidth = IS_DATAWIDTH_8;
+		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_8;
 	}
-	if (!datawidth)
+
+	return 0;
+}
+
+static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
+	u32 cicr0, cicr4 = 0;
+	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
+
+	if (ret < 0)
+		return ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
+	if (!common_flags)
 		return -EINVAL;
 
-	ret = icd->ops->set_capture_format(icd, pixfmt, rect,
-			datawidth |
-			(pcdev->platform_flags & PXA_CAMERA_MASTER ?
-			 IS_MASTER : 0) |
-			(pcdev->platform_flags & PXA_CAMERA_HSP ?
-			 0 : IS_HSYNC_ACTIVE_HIGH) |
-			(pcdev->platform_flags & PXA_CAMERA_VSP ?
-			 0 : IS_VSYNC_ACTIVE_HIGH) |
-			(pcdev->platform_flags & PXA_CAMERA_PCP ?
-			 0 : IS_PCLK_SAMPLE_RISING));
+	/* Make choises, based on platform preferences */
+	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+		if (pcdev->platform_flags & PXA_CAMERA_HSP)
+			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+		if (pcdev->platform_flags & PXA_CAMERA_VSP)
+			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+		if (pcdev->platform_flags & PXA_CAMERA_PCP)
+			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+		else
+			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+	}
+
+	ret = icd->ops->set_bus_param(icd, common_flags);
 	if (ret < 0)
 		return ret;
 
 	/* Datawidth is now guaranteed to be equal to one of the three values.
 	 * We fix bit-per-pixel equal to data-width... */
-	switch (datawidth) {
-	case IS_DATAWIDTH_10:
-		icd->cached_datawidth = 10;
+	switch (common_flags & SOCAM_DATAWIDTH_MASK) {
+	case SOCAM_DATAWIDTH_10:
+		icd->buswidth = 10;
 		dw = 4;
 		bpp = 0x40;
 		break;
-	case IS_DATAWIDTH_9:
-		icd->cached_datawidth = 9;
+	case SOCAM_DATAWIDTH_9:
+		icd->buswidth = 9;
 		dw = 3;
 		bpp = 0x20;
 		break;
 	default:
 		/* Actually it can only be 8 now,
 		 * default is just to silence compiler warnings */
-	case IS_DATAWIDTH_8:
-		icd->cached_datawidth = 8;
+	case SOCAM_DATAWIDTH_8:
+		icd->buswidth = 8;
 		dw = 2;
 		bpp = 0;
 	}
@@ -647,19 +692,19 @@ static int pxa_camera_set_capture_format(struct soc_camera_device *icd,
 		cicr4 |= CICR4_PCLK_EN;
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		cicr4 |= CICR4_MCLK_EN;
-	if (pcdev->platform_flags & PXA_CAMERA_PCP)
+	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
 		cicr4 |= CICR4_PCP;
-	if (pcdev->platform_flags & PXA_CAMERA_HSP)
+	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_HSP;
-	if (pcdev->platform_flags & PXA_CAMERA_VSP)
+	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_VSP;
 
 	cicr0 = CICR0;
 	if (cicr0 & CICR0_ENB)
 		CICR0 = cicr0 & ~CICR0_ENB;
-	CICR1 = CICR1_PPL_VAL(rect->width - 1) | bpp | dw;
+	CICR1 = CICR1_PPL_VAL(icd->width - 1) | bpp | dw;
 	CICR2 = 0;
-	CICR3 = CICR3_LPF_VAL(rect->height - 1) |
+	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
 		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
 	CICR4 = mclk_get_divisor(pcdev) | cicr4;
 
@@ -671,7 +716,29 @@ static int pxa_camera_set_capture_format(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int pxa_camera_try_fmt_cap(struct soc_camera_host *ici,
+static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	unsigned long bus_flags, camera_flags;
+	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
+
+	if (ret < 0)
+		return ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
+}
+
+static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
+				  __u32 pixfmt, struct v4l2_rect *rect)
+{
+	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
+}
+
+static int pxa_camera_try_fmt_cap(struct soc_camera_device *icd,
 				  struct v4l2_format *f)
 {
 	/* limit to pxa hardware capabilities */
@@ -685,7 +752,8 @@ static int pxa_camera_try_fmt_cap(struct soc_camera_host *ici,
 		f->fmt.pix.width = 2048;
 	f->fmt.pix.width &= ~0x01;
 
-	return 0;
+	/* limit to sensor capabilities */
+	return icd->ops->try_fmt_cap(icd, f);
 }
 
 static int pxa_camera_reqbufs(struct soc_camera_file *icf,
@@ -742,11 +810,13 @@ static struct soc_camera_host pxa_soc_camera_host = {
 	.add			= pxa_camera_add_device,
 	.remove			= pxa_camera_remove_device,
 	.msize			= sizeof(struct pxa_buffer),
-	.set_capture_format	= pxa_camera_set_capture_format,
+	.set_fmt_cap		= pxa_camera_set_fmt_cap,
 	.try_fmt_cap		= pxa_camera_try_fmt_cap,
 	.reqbufs		= pxa_camera_reqbufs,
 	.poll			= pxa_camera_poll,
 	.querycap		= pxa_camera_querycap,
+	.try_bus_param		= pxa_camera_try_bus_param,
+	.set_bus_param		= pxa_camera_set_bus_param,
 };
 
 static int pxa_camera_probe(struct platform_device *pdev)
@@ -782,8 +852,8 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	pcdev->pdata = pdev->dev.platform_data;
 	pcdev->platform_flags = pcdev->pdata->flags;
-	if (!pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
-			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10)) {
+	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
+			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
 		/* Platform hasn't set available data widths. This is bad.
 		 * Warn and use a default. */
 		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 322f837..4e7c8b6 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -75,12 +75,13 @@ static int soc_camera_try_fmt_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* limit to host capabilities */
-	ret = ici->try_fmt_cap(ici, f);
+	/* test physical bus parameters */
+	ret = ici->try_bus_param(icd, f->fmt.pix.pixelformat);
+	if (ret)
+		return ret;
 
-	/* limit to sensor capabilities */
-	if (!ret)
-		ret = icd->ops->try_fmt_cap(icd, f);
+	/* limit format to hardware capabilities */
+	ret = ici->try_fmt_cap(icd, f);
 
 	/* calculate missing fields */
 	f->fmt.pix.field = field;
@@ -344,8 +345,8 @@ static int soc_camera_s_fmt_cap(struct file *file, void *priv,
 	if (!data_fmt)
 		return -EINVAL;
 
-	/* cached_datawidth may be further adjusted by the ici */
-	icd->cached_datawidth = data_fmt->depth;
+	/* buswidth may be further adjusted by the ici */
+	icd->buswidth = data_fmt->depth;
 
 	ret = soc_camera_try_fmt_cap(file, icf, f);
 	if (ret < 0)
@@ -355,22 +356,23 @@ static int soc_camera_s_fmt_cap(struct file *file, void *priv,
 	rect.top	= icd->y_current;
 	rect.width	= f->fmt.pix.width;
 	rect.height	= f->fmt.pix.height;
-	ret = ici->set_capture_format(icd, f->fmt.pix.pixelformat, &rect);
+	ret = ici->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
+	if (ret < 0)
+		return ret;
 
-	if (!ret) {
-		icd->current_fmt	= data_fmt;
-		icd->width		= rect.width;
-		icd->height		= rect.height;
-		icf->vb_vidq.field	= f->fmt.pix.field;
-		if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
-			dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
-				 f->type);
-
-		dev_dbg(&icd->dev, "set width: %d height: %d\n",
-		       icd->width, icd->height);
-	}
+	icd->current_fmt	= data_fmt;
+	icd->width		= rect.width;
+	icd->height		= rect.height;
+	icf->vb_vidq.field	= f->fmt.pix.field;
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
+		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
+			 f->type);
 
-	return ret;
+	dev_dbg(&icd->dev, "set width: %d height: %d\n",
+		icd->width, icd->height);
+
+	/* set physical bus parameters */
+	return ici->set_bus_param(icd, f->fmt.pix.pixelformat);
 }
 
 static int soc_camera_enum_fmt_cap(struct file *file, void  *priv,
@@ -577,7 +579,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	ret = ici->set_capture_format(icd, 0, &a->c);
+	ret = ici->set_fmt_cap(icd, 0, &a->c);
 	if (!ret) {
 		icd->width	= a->c.width;
 		icd->height	= a->c.height;
@@ -860,9 +862,6 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 
 	icd->dev.release = dummy_release;
 
-	if (icd->ops->get_datawidth)
-		icd->cached_datawidth = icd->ops->get_datawidth(icd);
-
 	return scan_add_device(icd);
 }
 EXPORT_SYMBOL(soc_camera_device_register);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index c886b1e..3f1ccc1 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -34,7 +34,7 @@ struct soc_camera_device {
 	unsigned short exposure;
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
-	unsigned char cached_datawidth;	/* See comment in .c */
+	unsigned char buswidth;		/* See comment in .c */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
 	const struct soc_camera_data_format *current_fmt;
@@ -61,11 +61,13 @@ struct soc_camera_host {
 	char *drv_name;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
-	int (*set_capture_format)(struct soc_camera_device *, __u32,
-				  struct v4l2_rect *);
-	int (*try_fmt_cap)(struct soc_camera_host *, struct v4l2_format *);
+	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
+			   struct v4l2_rect *);
+	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
 	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
+	int (*try_bus_param)(struct soc_camera_device *, __u32);
+	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	unsigned int (*poll)(struct file *, poll_table *);
 };
 
@@ -108,9 +110,11 @@ struct soc_camera_ops {
 	int (*release)(struct soc_camera_device *);
 	int (*start_capture)(struct soc_camera_device *);
 	int (*stop_capture)(struct soc_camera_device *);
-	int (*set_capture_format)(struct soc_camera_device *, __u32,
-				  struct v4l2_rect *, unsigned int);
+	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
+			   struct v4l2_rect *);
 	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
+	unsigned long (*query_bus_param)(struct soc_camera_device *);
+	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 	int (*get_chip_id)(struct soc_camera_device *,
 			   struct v4l2_chip_ident *);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -123,7 +127,6 @@ struct soc_camera_ops {
 	int (*set_control)(struct soc_camera_device *, struct v4l2_control *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
-	unsigned int(*get_datawidth)(struct soc_camera_device *icd);
 };
 
 static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
@@ -138,12 +141,33 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 	return NULL;
 }
 
-#define IS_MASTER		(1<<0)
-#define IS_HSYNC_ACTIVE_HIGH	(1<<1)
-#define IS_VSYNC_ACTIVE_HIGH	(1<<2)
-#define IS_DATAWIDTH_8		(1<<3)
-#define IS_DATAWIDTH_9		(1<<4)
-#define IS_DATAWIDTH_10		(1<<5)
-#define IS_PCLK_SAMPLE_RISING	(1<<6)
+#define SOCAM_MASTER			(1 << 0)
+#define SOCAM_SLAVE			(1 << 1)
+#define SOCAM_HSYNC_ACTIVE_HIGH		(1 << 2)
+#define SOCAM_HSYNC_ACTIVE_LOW		(1 << 3)
+#define SOCAM_VSYNC_ACTIVE_HIGH		(1 << 4)
+#define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)
+#define SOCAM_DATAWIDTH_8		(1 << 6)
+#define SOCAM_DATAWIDTH_9		(1 << 7)
+#define SOCAM_DATAWIDTH_10		(1 << 8)
+#define SOCAM_PCLK_SAMPLE_RISING	(1 << 9)
+#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 10)
+
+#define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_9 | \
+			      SOCAM_DATAWIDTH_10)
+
+static inline unsigned long soc_camera_bus_param_compatible(
+			unsigned long camera_flags, unsigned long bus_flags)
+{
+	unsigned long common_flags, hsync, vsync, pclk;
+
+	common_flags = camera_flags & bus_flags;
+
+	hsync = common_flags & (SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW);
+	vsync = common_flags & (SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW);
+	pclk = common_flags & (SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING);
+
+	return (!hsync || !vsync || !pclk) ? 0 : common_flags;
+}
 
 #endif

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
