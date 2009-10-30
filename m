Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932108AbZJ3OBB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:01:01 -0400
Date: Fri, 30 Oct 2009 15:01:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 3/9] soc-camera: fix multi-line comment coding style
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301405140.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c              |   36 ++++++++++++------
 drivers/media/video/mt9t031.c              |   24 ++++++++----
 drivers/media/video/mt9v022.c              |   48 ++++++++++++++++--------
 drivers/media/video/mx1_camera.c           |   36 ++++++++++++------
 drivers/media/video/mx3_camera.c           |   18 ++++++---
 drivers/media/video/pxa_camera.c           |   54 ++++++++++++++++++---------
 drivers/media/video/sh_mobile_ceu_camera.c |   18 ++++++---
 drivers/media/video/soc_camera.c           |   24 ++++++++----
 drivers/media/video/tw9910.c               |    8 ++--
 include/media/ov772x.h                     |    3 +-
 10 files changed, 178 insertions(+), 91 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 17be2d4..cc90660 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -17,9 +17,11 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-/* mt9m001 i2c address 0x5d
+/*
+ * mt9m001 i2c address 0x5d
  * The platform has to define ctruct i2c_board_info objects and link to them
- * from struct soc_camera_link */
+ * from struct soc_camera_link
+ */
 
 /* mt9m001 selected register addresses */
 #define MT9M001_CHIP_VERSION		0x00
@@ -47,8 +49,10 @@
 #define MT9M001_ROW_SKIP		12
 
 static const struct soc_camera_data_format mt9m001_colour_formats[] = {
-	/* Order important: first natively supported,
-	 * second supported with a GPIO extender */
+	/*
+	 * Order important: first natively supported,
+	 * second supported with a GPIO extender
+	 */
 	{
 		.name		= "Bayer (sRGB) 10 bit",
 		.depth		= 10,
@@ -230,8 +234,10 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (!ret)
 		ret = reg_write(client, MT9M001_VERTICAL_BLANKING, vblank);
 
-	/* The caller provides a supported format, as verified per
-	 * call to icd->try_fmt() */
+	/*
+	 * The caller provides a supported format, as verified per
+	 * call to icd->try_fmt()
+	 */
 	if (!ret)
 		ret = reg_write(client, MT9M001_COLUMN_START, rect.left);
 	if (!ret)
@@ -569,8 +575,10 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
-/* Interface active, can use i2c. If it fails, it can indeed mean, that
- * this wasn't our capture interface, so, we wait for the right one */
+/*
+ * Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one
+ */
 static int mt9m001_video_probe(struct soc_camera_device *icd,
 			       struct i2c_client *client)
 {
@@ -580,8 +588,10 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	unsigned long flags;
 	int ret;
 
-	/* We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant. */
+	/*
+	 * We must have a parent by now. And it cannot be a wrong one.
+	 * So this entire test is completely redundant.
+	 */
 	if (!icd->dev.parent ||
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
@@ -737,8 +747,10 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
-	/* Simulated autoexposure. If enabled, we calculate shutter width
-	 * ourselves in the driver based on vertical blanking and frame width */
+	/*
+	 * Simulated autoexposure. If enabled, we calculate shutter width
+	 * ourselves in the driver based on vertical blanking and frame width
+	 */
 	mt9m001->autoexposure = 1;
 
 	ret = mt9m001_video_probe(icd, client);
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 57e04e9..0d2a8fd 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -17,9 +17,11 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-/* mt9t031 i2c address 0x5d
+/*
+ * mt9t031 i2c address 0x5d
  * The platform has to define i2c_board_info and link to it from
- * struct soc_camera_link */
+ * struct soc_camera_link
+ */
 
 /* mt9t031 selected register addresses */
 #define MT9T031_CHIP_VERSION		0x00
@@ -291,8 +293,10 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 	dev_dbg(&client->dev, "new physical left %u, top %u\n",
 		rect->left, rect->top);
 
-	/* The caller provides a supported format, as guaranteed by
-	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap() */
+	/*
+	 * The caller provides a supported format, as guaranteed by
+	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap()
+	 */
 	if (ret >= 0)
 		ret = reg_write(client, MT9T031_COLUMN_START, rect->left);
 	if (ret >= 0)
@@ -672,8 +676,10 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
-/* Interface active, can use i2c. If it fails, it can indeed mean, that
- * this wasn't our capture interface, so, we wait for the right one */
+/*
+ * Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one
+ */
 static int mt9t031_video_probe(struct i2c_client *client)
 {
 	struct soc_camera_device *icd = client->dev.platform_data;
@@ -778,8 +784,10 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->rect.width	= MT9T031_MAX_WIDTH;
 	mt9t031->rect.height	= MT9T031_MAX_HEIGHT;
 
-	/* Simulated autoexposure. If enabled, we calculate shutter width
-	 * ourselves in the driver based on vertical blanking and frame width */
+	/*
+	 * Simulated autoexposure. If enabled, we calculate shutter width
+	 * ourselves in the driver based on vertical blanking and frame width
+	 */
 	mt9t031->autoexposure = 1;
 
 	mt9t031->xskip = 1;
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index b71898f..f60a9a1 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -18,9 +18,11 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-/* mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
+/*
+ * mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
  * The platform has to define ctruct i2c_board_info objects and link to them
- * from struct soc_camera_link */
+ * from struct soc_camera_link
+ */
 
 static char *sensor_type;
 module_param(sensor_type, charp, S_IRUGO);
@@ -63,8 +65,10 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_ROW_SKIP		4
 
 static const struct soc_camera_data_format mt9v022_colour_formats[] = {
-	/* Order important: first natively supported,
-	 * second supported with a GPIO extender */
+	/*
+	 * Order important: first natively supported,
+	 * second supported with a GPIO extender
+	 */
 	{
 		.name		= "Bayer (sRGB) 10 bit",
 		.depth		= 10,
@@ -144,9 +148,11 @@ static int mt9v022_init(struct i2c_client *client)
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	int ret;
 
-	/* Almost the default mode: master, parallel, simultaneous, and an
+	/*
+	 * Almost the default mode: master, parallel, simultaneous, and an
 	 * undocumented bit 0x200, which is present in table 7, but not in 8,
-	 * plus snapshot mode to disable scan for now */
+	 * plus snapshot mode to disable scan for now
+	 */
 	mt9v022->chip_control |= 0x10;
 	ret = reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
 	if (!ret)
@@ -298,8 +304,10 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (!ret)
 		ret = reg_write(client, MT9V022_ROW_START, rect.top);
 	if (!ret)
-		/* Default 94, Phytec driver says:
-		 * "width + horizontal blank >= 660" */
+		/*
+		 * Default 94, Phytec driver says:
+		 * "width + horizontal blank >= 660"
+		 */
 		ret = reg_write(client, MT9V022_HORIZONTAL_BLANKING,
 				rect.width > 660 - 43 ? 43 :
 				660 - rect.width);
@@ -376,8 +384,10 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	};
 	int ret;
 
-	/* The caller provides a supported format, as verified per call to
-	 * icd->try_fmt(), datawidth is from our supported format list */
+	/*
+	 * The caller provides a supported format, as verified per call to
+	 * icd->try_fmt(), datawidth is from our supported format list
+	 */
 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
@@ -635,8 +645,10 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 					      48 + range / 2) / range + 16;
 			if (gain >= 32)
 				gain &= ~1;
-			/* The user wants to set gain manually, hope, she
-			 * knows, what she's doing... Switch AGC off. */
+			/*
+			 * The user wants to set gain manually, hope, she
+			 * knows, what she's doing... Switch AGC off.
+			 */
 
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
 				return -EIO;
@@ -655,8 +667,10 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			unsigned long range = qctrl->maximum - qctrl->minimum;
 			unsigned long shutter = ((ctrl->value - qctrl->minimum) *
 						 479 + range / 2) / range + 1;
-			/* The user wants to set shutter width manually, hope,
-			 * she knows, what she's doing... Switch AEC off. */
+			/*
+			 * The user wants to set shutter width manually, hope,
+			 * she knows, what she's doing... Switch AEC off.
+			 */
 
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1) < 0)
 				return -EIO;
@@ -689,8 +703,10 @@ static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
-/* Interface active, can use i2c. If it fails, it can indeed mean, that
- * this wasn't our capture interface, so, we wait for the right one */
+/*
+ * Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one
+ */
 static int mt9v022_video_probe(struct soc_camera_device *icd,
 			       struct i2c_client *client)
 {
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 5f37952..659d20a 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -98,9 +98,11 @@ struct mx1_buffer {
 	int inwork;
 };
 
-/* i.MX1/i.MXL is only supposed to handle one camera on its Camera Sensor
+/*
+ * i.MX1/i.MXL is only supposed to handle one camera on its Camera Sensor
  * Interface. If anyone ever builds hardware to enable more than
- * one camera, they will have to modify this driver too */
+ * one camera, they will have to modify this driver too
+ */
 struct mx1_camera_dev {
 	struct soc_camera_host		soc_host;
 	struct soc_camera_device	*icd;
@@ -150,8 +152,10 @@ static void free_buffer(struct videobuf_queue *vq, struct mx1_buffer *buf)
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	/* This waits until this buffer is out of danger, i.e., until it is no
-	 * longer in STATE_QUEUED or STATE_ACTIVE */
+	/*
+	 * This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE
+	 */
 	videobuf_waiton(vb, 0, 0);
 	videobuf_dma_contig_free(vq, vb);
 
@@ -173,8 +177,10 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 
 	BUG_ON(NULL == icd->current_fmt);
 
-	/* I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours */
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
 	buf->inwork = 1;
 
 	if (buf->fmt	!= icd->current_fmt ||
@@ -380,8 +386,10 @@ static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
 
 	lcdclk = clk_get_rate(pcdev->clk);
 
-	/* We verify platform_mclk_10khz != 0, so if anyone breaks it, here
-	 * they get a nice Oops */
+	/*
+	 * We verify platform_mclk_10khz != 0, so if anyone breaks it, here
+	 * they get a nice Oops
+	 */
 	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
 
 	dev_dbg(pcdev->icd->dev.parent,
@@ -419,8 +427,10 @@ static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 	clk_disable(pcdev->clk);
 }
 
-/* The following two functions absolutely depend on the fact, that
- * there can be only one camera on i.MX1/i.MXL camera sensor interface */
+/*
+ * The following two functions absolutely depend on the fact, that
+ * there can be only one camera on i.MX1/i.MXL camera sensor interface
+ */
 static int mx1_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
@@ -577,10 +587,12 @@ static int mx1_camera_reqbufs(struct soc_camera_file *icf,
 {
 	int i;
 
-	/* This is for locking debugging only. I removed spinlocks and now I
+	/*
+	 * This is for locking debugging only. I removed spinlocks and now I
 	 * check whether .prepare is ever called on a linked buffer, or whether
 	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
-	 * it hadn't triggered */
+	 * it hadn't triggered
+	 */
 	for (i = 0; i < p->count; i++) {
 		struct mx1_buffer *buf = container_of(icf->vb_vidq.bufs[i],
 						      struct mx1_buffer, vb);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index dff2e5e..545a430 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -563,8 +563,10 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 		SOCAM_DATA_ACTIVE_HIGH |
 		SOCAM_DATA_ACTIVE_LOW;
 
-	/* If requested data width is supported by the platform, use it or any
-	 * possible lower value - i.MX31 is smart enough to schift bits */
+	/*
+	 * If requested data width is supported by the platform, use it or any
+	 * possible lower value - i.MX31 is smart enough to schift bits
+	 */
 	switch (buswidth) {
 	case 15:
 		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15))
@@ -1026,8 +1028,10 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
 	}
 
-	/* Make the camera work in widest common mode, we'll take care of
-	 * the rest */
+	/*
+	 * Make the camera work in widest common mode, we'll take care of
+	 * the rest
+	 */
 	if (common_flags & SOCAM_DATAWIDTH_15)
 		common_flags = (common_flags & ~SOCAM_DATAWIDTH_MASK) |
 			SOCAM_DATAWIDTH_15;
@@ -1151,8 +1155,10 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 	if (!(mx3_cam->platform_flags & (MX3_CAMERA_DATAWIDTH_4 |
 			MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10 |
 			MX3_CAMERA_DATAWIDTH_15))) {
-		/* Platform hasn't set available data widths. This is bad.
-		 * Warn and use a default. */
+		/*
+		 * Platform hasn't set available data widths. This is bad.
+		 * Warn and use a default.
+		 */
 		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
 			 "data widths, using default 8 bit\n");
 		mx3_cam->platform_flags |= MX3_CAMERA_DATAWIDTH_8;
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 4df09a6..f063f59 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -197,9 +197,11 @@ struct pxa_buffer {
 
 struct pxa_camera_dev {
 	struct soc_camera_host	soc_host;
-	/* PXA27x is only supposed to handle one camera on its Quick Capture
+	/*
+	 * PXA27x is only supposed to handle one camera on its Quick Capture
 	 * interface. If anyone ever builds hardware to enable more than
-	 * one camera, they will have to modify this driver too */
+	 * one camera, they will have to modify this driver too
+	 */
 	struct soc_camera_device *icd;
 	struct clk		*clk;
 
@@ -267,8 +269,10 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 
-	/* This waits until this buffer is out of danger, i.e., until it is no
-	 * longer in STATE_QUEUED or STATE_ACTIVE */
+	/*
+	 * This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE
+	 */
 	videobuf_waiton(&buf->vb, 0, 0);
 	videobuf_dma_unmap(vq, dma);
 	videobuf_dma_free(dma);
@@ -437,15 +441,19 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	WARN_ON(!list_empty(&vb->queue));
 
 #ifdef DEBUG
-	/* This can be useful if you want to see if we actually fill
-	 * the buffer with something */
+	/*
+	 * This can be useful if you want to see if we actually fill
+	 * the buffer with something
+	 */
 	memset((void *)vb->baddr, 0xaa, vb->bsize);
 #endif
 
 	BUG_ON(NULL == icd->current_fmt);
 
-	/* I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours */
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
 	buf->inwork = 1;
 
 	if (buf->fmt	!= icd->current_fmt ||
@@ -834,8 +842,10 @@ static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
-	/* We must pass NULL as dev pointer, then all pci_* dma operations
-	 * transform to normal dma_* ones. */
+	/*
+	 * We must pass NULL as dev pointer, then all pci_* dma operations
+	 * transform to normal dma_* ones.
+	 */
 	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				sizeof(struct pxa_buffer), icd);
@@ -1059,8 +1069,10 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	if (ret < 0)
 		y_skip_top = 0;
 
-	/* Datawidth is now guaranteed to be equal to one of the three values.
-	 * We fix bit-per-pixel equal to data-width... */
+	/*
+	 * Datawidth is now guaranteed to be equal to one of the three values.
+	 * We fix bit-per-pixel equal to data-width...
+	 */
 	switch (flags & SOCAM_DATAWIDTH_MASK) {
 	case SOCAM_DATAWIDTH_10:
 		dw = 4;
@@ -1071,8 +1083,10 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 		bpp = 0x20;
 		break;
 	default:
-		/* Actually it can only be 8 now,
-		 * default is just to silence compiler warnings */
+		/*
+		 * Actually it can only be 8 now,
+		 * default is just to silence compiler warnings
+		 */
 	case SOCAM_DATAWIDTH_8:
 		dw = 2;
 		bpp = 0;
@@ -1524,10 +1538,12 @@ static int pxa_camera_reqbufs(struct soc_camera_file *icf,
 {
 	int i;
 
-	/* This is for locking debugging only. I removed spinlocks and now I
+	/*
+	 * This is for locking debugging only. I removed spinlocks and now I
 	 * check whether .prepare is ever called on a linked buffer, or whether
 	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
-	 * it hadn't triggered */
+	 * it hadn't triggered
+	 */
 	for (i = 0; i < p->count; i++) {
 		struct pxa_buffer *buf = container_of(icf->vb_vidq.bufs[i],
 						      struct pxa_buffer, vb);
@@ -1662,8 +1678,10 @@ static int __devinit pxa_camera_probe(struct platform_device *pdev)
 	pcdev->platform_flags = pcdev->pdata->flags;
 	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
 			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
-		/* Platform hasn't set available data widths. This is bad.
-		 * Warn and use a default. */
+		/*
+		 * Platform hasn't set available data widths. This is bad.
+		 * Warn and use a default.
+		 */
 		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
 			 "data widths, using default 10 bit\n");
 		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2f78b4f..6613606 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -209,7 +209,8 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	struct soc_camera_device *icd = pcdev->icd;
 	dma_addr_t phys_addr_top, phys_addr_bottom;
 
-	/* The hardware is _very_ picky about this sequence. Especially
+	/*
+	 * The hardware is _very_ picky about this sequence. Especially
 	 * the CEU_CETCR_MAGIC value. It seems like we need to acknowledge
 	 * several not-so-well documented interrupt sources in CETCR.
 	 */
@@ -265,8 +266,10 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 	WARN_ON(!list_empty(&vb->queue));
 
 #ifdef DEBUG
-	/* This can be useful if you want to see if we actually fill
-	 * the buffer with something */
+	/*
+	 * This can be useful if you want to see if we actually fill
+	 * the buffer with something
+	 */
 	memset((void *)vb->baddr, 0xaa, vb->bsize);
 #endif
 
@@ -653,7 +656,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 
 	ceu_write(pcdev, CFLCR, pcdev->cflcr);
 
-	/* A few words about byte order (observed in Big Endian mode)
+	/*
+	 * A few words about byte order (observed in Big Endian mode)
 	 *
 	 * In data fetch mode bytes are received in chunks of 8 bytes.
 	 * D0, D1, D2, D3, D4, D5, D6, D7 (D0 received first)
@@ -1517,10 +1521,12 @@ static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
 {
 	int i;
 
-	/* This is for locking debugging only. I removed spinlocks and now I
+	/*
+	 * This is for locking debugging only. I removed spinlocks and now I
 	 * check whether .prepare is ever called on a linked buffer, or whether
 	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
-	 * it hadn't triggered */
+	 * it hadn't triggered
+	 */
 	for (i = 0; i < p->count; i++) {
 		struct sh_mobile_ceu_buffer *buf;
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 36e617b..bf77935 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -621,8 +621,10 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 
 	mutex_lock(&icd->video_lock);
 
-	/* This calls buf_release from host driver's videobuf_queue_ops for all
-	 * remaining buffers. When the last buffer is freed, stop capture */
+	/*
+	 * This calls buf_release from host driver's videobuf_queue_ops for all
+	 * remaining buffers. When the last buffer is freed, stop capture
+	 */
 	videobuf_streamoff(&icf->vb_vidq);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
@@ -1004,8 +1006,10 @@ epower:
 	return ret;
 }
 
-/* This is called on device_unregister, which only means we have to disconnect
- * from the host, but not remove ourselves from the device list */
+/*
+ * This is called on device_unregister, which only means we have to disconnect
+ * from the host, but not remove ourselves from the device list
+ */
 static int soc_camera_remove(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
@@ -1196,8 +1200,10 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 	}
 
 	if (num < 0)
-		/* ok, we have 256 cameras on this host...
-		 * man, stay reasonable... */
+		/*
+		 * ok, we have 256 cameras on this host...
+		 * man, stay reasonable...
+		 */
 		return -ENOMEM;
 
 	icd->devnum = num;
@@ -1328,9 +1334,11 @@ escdevreg:
 	return ret;
 }
 
-/* Only called on rmmod for each platform device, since they are not
+/*
+ * Only called on rmmod for each platform device, since they are not
  * hot-pluggable. Now we know, that all our users - hosts and devices have
- * been unloaded already */
+ * been unloaded already
+ */
 static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 {
 	struct soc_camera_device *icd = platform_get_drvdata(pdev);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 7bf90a2..3cb9ba6 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -180,9 +180,8 @@
 			  */
 
 /* VBICNTL */
-/* RTSEL : control the real time signal
-*          output from the MPOUT pin
-*/
+
+/* RTSEL : control the real time signal output from the MPOUT pin */
 #define RTSEL_MASK  0x07
 #define RTSEL_VLOSS 0x00 /* 0000 = Video loss */
 #define RTSEL_HLOCK 0x01 /* 0001 = H-lock */
@@ -596,7 +595,8 @@ static int tw9910_g_register(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
 
-	/* ret      = int
+	/*
+	 * ret      = int
 	 * reg->val = __u64
 	 */
 	reg->val = (__u64)ret;
diff --git a/include/media/ov772x.h b/include/media/ov772x.h
index 30d9629..37bcd09 100644
--- a/include/media/ov772x.h
+++ b/include/media/ov772x.h
@@ -1,4 +1,5 @@
-/* ov772x Camera
+/*
+ * ov772x Camera
  *
  * Copyright (C) 2008 Renesas Solutions Corp.
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
-- 
1.6.2.4

