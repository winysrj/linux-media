Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:38244 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbcCSVBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 17:01:48 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH RFC 2/2] media: platform: pxa_camera: make a standalone v4l2 device
Date: Sat, 19 Mar 2016 22:01:28 +0100
Message-Id: <1458421288-22094-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
References: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the soc_camera API dependency from pxa_camera.
In the current status :
 - all previously captures are working the same on pxa270
 - the s_crop() call was removed, judged not working
   (see what happens soc_camera_s_crop() when get_crop() == NULL)
 - if the pixel clock is provided by then sensor, ie. not MCLK, the dual
   stage change is not handled yet.
   (see all the comments left)

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 715 ++++++++++++++-----------
 include/linux/platform_data/media/camera-pxa.h |   2 +
 2 files changed, 407 insertions(+), 310 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 141a5ba603a8..3670ae798e31 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2006, Sascha Hauer, Pengutronix
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ * Copyright (C) 2016, Robert Jarzmik <robert.jarzmik@free.fr>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -14,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -22,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
+#include <linux/of.h>
 #include <linux/time.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
@@ -32,13 +35,16 @@
 #include <linux/dma-mapping.h>
 #include <linux/dma/pxa-dma.h>
 
+#include <media/v4l2-async.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-dev.h>
-#include <media/videobuf2-dma-sg.h>
-#include <media/soc_camera.h>
-#include <media/drv-intf/soc_mediabus.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
 #include <media/v4l2-of.h>
 
+#include <media/drv-intf/soc_mediabus.h>
+#include <media/videobuf2-dma-sg.h>
+
 #include <linux/videodev2.h>
 
 #include <linux/platform_data/media/camera-pxa.h>
@@ -168,6 +174,9 @@
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
 
+#define sensor_call(cam, o, f, args...) \
+	v4l2_subdev_call(cam->sensor, o, f, ##args)
+
 /*
  * Structures
  */
@@ -195,7 +204,14 @@ struct pxa_buffer {
 };
 
 struct pxa_camera_dev {
-	struct soc_camera_host	soc_host;
+	struct v4l2_device	v4l2_dev;
+	struct video_device	vdev;
+	struct v4l2_async_notifier notifier;
+	struct vb2_queue	vb2_vq;
+	struct v4l2_subdev	*sensor;
+	struct soc_camera_format_xlate *user_formats;
+	const struct soc_camera_format_xlate *current_fmt;
+	struct v4l2_pix_format	current_pix;
 	/*
 	 * PXA27x is only supposed to handle one camera on its Quick Capture
 	 * interface. If anyone ever builds hardware to enable more than
@@ -215,11 +231,13 @@ struct pxa_camera_dev {
 	unsigned long		ciclk;
 	unsigned long		mclk;
 	u32			mclk_divisor;
+	struct v4l2_clk		*mclk_clk;
 	u16			width_flags;	/* max 10 bits */
 
 	struct list_head	capture;
 
 	spinlock_t		lock;
+	struct mutex		mlock;
 
 	struct pxa_buffer	*active;
 	struct tasklet_struct	task_eof;
@@ -249,7 +267,12 @@ static struct pxa_buffer *vb2_to_pxa_buffer(struct vb2_buffer *vb)
 
 static struct device *pcdev_to_dev(struct pxa_camera_dev *pcdev)
 {
-	return pcdev->soc_host.v4l2_dev.dev;
+	return pcdev->v4l2_dev.dev;
+}
+
+static struct pxa_camera_dev *v4l2_dev_to_pcdev(struct v4l2_device *v4l2_dev)
+{
+	return container_of(v4l2_dev, struct pxa_camera_dev, v4l2_dev);
 }
 
 static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
@@ -638,13 +661,12 @@ static int pxa_vb2_prepare(struct vb2_buffer *vb)
 {
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	int i, ret = 0;
 
 	switch (pcdev->channels) {
 	case 1:
 	case 3:
-		vb2_set_plane_payload(vb, 0, icd->sizeimage);
+		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
 		break;
 	default:
 		return -EINVAL;
@@ -654,7 +676,7 @@ static int pxa_vb2_prepare(struct vb2_buffer *vb)
 		 "%s (vb=%p) nb_channels=%d size=%lu\n",
 		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
 
-	WARN_ON(!icd->current_fmt);
+	WARN_ON(!pcdev->current_fmt);
 
 #ifdef DEBUG
 	/*
@@ -691,16 +713,15 @@ static int pxa_vb2_init(struct vb2_buffer *vb)
 {
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 
 	dev_dbg(pcdev_to_dev(pcdev),
 		 "%s(nb_channels=%d size=%u)\n",
-		 __func__, pcdev->channels, icd->sizeimage);
+		 __func__, pcdev->channels, pcdev->current_pix.sizeimage);
 
 	switch (pcdev->channels) {
 	case 1:
 	case 3:
-		vb2_set_plane_payload(vb, 0, icd->sizeimage);
+		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
 		break;
 	default:
 		return -EINVAL;
@@ -715,12 +736,11 @@ static int pxa_vb2_queue_setup(struct vb2_queue *vq,
 			       void *alloc_ctxs[])
 {
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	int size = icd->sizeimage;
+	int size = pcdev->current_pix.sizeimage;
 
 	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vq=%p nbufs=%d num_planes=%d)\n",
-		 __func__, vq, *nbufs, *num_planes);
+		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
+		__func__, vq, *nbufs, *num_planes, size);
 	/*
 	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
 	 * format, even if there are 3 planes Y, U and V, we reply there is only
@@ -730,7 +750,7 @@ static int pxa_vb2_queue_setup(struct vb2_queue *vq,
 		switch (pcdev->channels) {
 		case 1:
 		case 3:
-			sizes[0] = icd->sizeimage;
+			sizes[0] = size;
 			break;
 		default:
 			return -EINVAL;
@@ -765,13 +785,12 @@ static struct vb2_ops pxa_vb2_ops = {
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
-				     struct soc_camera_device *icd)
+static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
 	int ret;
+	struct vb2_queue *vq = &pcdev->vb2_vq;
 
+	memset(vq, 0, sizeof(*vq));
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
 	vq->drv_priv = pcdev;
@@ -780,6 +799,7 @@ static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
 
 	vq->ops = &pxa_vb2_ops;
 	vq->mem_ops = &vb2_dma_sg_memops;
+	vq->lock = &pcdev->mlock;
 
 	ret = vb2_queue_init(vq);
 	dev_dbg(pcdev_to_dev(pcdev),
@@ -907,47 +927,6 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int pxa_camera_add_device(struct soc_camera_device *icd)
-{
-	dev_info(icd->parent, "PXA Camera driver attached to camera %d\n",
-		 icd->devnum);
-
-	return 0;
-}
-
-static void pxa_camera_remove_device(struct soc_camera_device *icd)
-{
-	dev_info(icd->parent, "PXA Camera driver detached from camera %d\n",
-		 icd->devnum);
-}
-
-/*
- * The following two functions absolutely depend on the fact, that
- * there can be only one camera on PXA quick capture interface
- * Called with .host_lock held
- */
-static int pxa_camera_clock_start(struct soc_camera_host *ici)
-{
-	struct pxa_camera_dev *pcdev = ici->priv;
-
-	pxa_camera_activate(pcdev);
-
-	return 0;
-}
-
-/* Called with .host_lock held */
-static void pxa_camera_clock_stop(struct soc_camera_host *ici)
-{
-	struct pxa_camera_dev *pcdev = ici->priv;
-
-	/* disable capture, disable interrupts */
-	__raw_writel(0x3ff, pcdev->base + CICR0);
-
-	/* Stop DMA engine */
-	pxa_dma_stop_channels(pcdev);
-	pxa_camera_deactivate(pcdev);
-}
-
 static int test_platform_param(struct pxa_camera_dev *pcdev,
 			       unsigned char buswidth, unsigned long *flags)
 {
@@ -973,15 +952,12 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 	return -EINVAL;
 }
 
-static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
+static void pxa_camera_setup_cicr(struct pxa_camera_dev *pcdev,
 				  unsigned long flags, __u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	unsigned long dw, bpp;
 	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0, y_skip_top;
-	int ret = v4l2_subdev_call(sd, sensor, g_skip_top_lines, &y_skip_top);
+	int ret = sensor_call(pcdev, sensor, g_skip_top_lines, &y_skip_top);
 
 	if (ret < 0)
 		y_skip_top = 0;
@@ -990,7 +966,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	 * Datawidth is now guaranteed to be equal to one of the three values.
 	 * We fix bit-per-pixel equal to data-width...
 	 */
-	switch (icd->current_fmt->host_fmt->bits_per_sample) {
+	switch (pcdev->current_fmt->host_fmt->bits_per_sample) {
 	case 10:
 		dw = 4;
 		bpp = 0x40;
@@ -1024,7 +1000,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	if (cicr0 & CICR0_ENB)
 		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
 
-	cicr1 = CICR1_PPL_VAL(icd->user_width - 1) | bpp | dw;
+	cicr1 = CICR1_PPL_VAL(pcdev->current_pix.width - 1) | bpp | dw;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_YUV422P:
@@ -1053,7 +1029,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	}
 
 	cicr2 = 0;
-	cicr3 = CICR3_LPF_VAL(icd->user_height - 1) |
+	cicr3 = CICR3_LPF_VAL(pcdev->current_pix.height - 1) |
 		CICR3_BFW_VAL(min((u32)255, y_skip_top));
 	cicr4 |= pcdev->mclk_divisor;
 
@@ -1069,28 +1045,25 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	__raw_writel(cicr0, pcdev->base + CICR0);
 }
 
-static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
+static int pxa_camera_set_bus_param(struct pxa_camera_dev *pcdev)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
-	u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
+	u32 pixfmt = pcdev->current_fmt->host_fmt->fourcc;
 	unsigned long bus_flags, common_flags;
 	int ret;
-	struct pxa_cam *cam = icd->host_priv;
 
-	ret = test_platform_param(pcdev, icd->current_fmt->host_fmt->bits_per_sample,
+	ret = test_platform_param(pcdev,
+				  pcdev->current_fmt->host_fmt->bits_per_sample,
 				  &bus_flags);
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
 		if (!common_flags) {
-			dev_warn(icd->parent,
+			dev_warn(pcdev_to_dev(pcdev),
 				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
 				 cfg.flags, bus_flags);
 			return -EINVAL;
@@ -1129,26 +1102,24 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	}
 
 	cfg.flags = common_flags;
-	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
+		dev_dbg(pcdev_to_dev(pcdev),
+			"camera s_mbus_config(0x%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
 
-	cam->flags = common_flags;
+	//RJK cam->flags = common_flags;
 
-	pxa_camera_setup_cicr(icd, common_flags, pixfmt);
+	pxa_camera_setup_cicr(pcdev, common_flags, pixfmt);
 
 	return 0;
 }
 
-static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
+static int pxa_camera_try_bus_param(struct pxa_camera_dev *pcdev,
 				    unsigned char buswidth)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
 	unsigned long bus_flags, common_flags;
 	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
@@ -1156,12 +1127,12 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
 	if (!ret) {
 		common_flags = soc_mbus_config_compatible(&cfg,
 							  bus_flags);
 		if (!common_flags) {
-			dev_warn(icd->parent,
+			dev_warn(pcdev_to_dev(pcdev),
 				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
 				 cfg.flags, bus_flags);
 			return -EINVAL;
@@ -1194,45 +1165,36 @@ static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
-static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int idx,
+static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
+				  unsigned int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->parent;
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
 	int formats = 0, ret;
-	struct pxa_cam *cam;
+	/* struct pxa_cam *cam; */
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 		.index = idx,
 	};
 	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
+	ret = sensor_call(pcdev, pad, enum_mbus_code, NULL, &code);
 	if (ret < 0)
 		/* No more formats */
 		return 0;
 
 	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_err(dev, "Invalid format code #%u: %d\n", idx, code.code);
+		dev_err(pcdev_to_dev(pcdev),
+			"Invalid format code #%u: %d\n", idx, code.code);
 		return 0;
 	}
 
 	/* This also checks support for the requested bits-per-sample */
-	ret = pxa_camera_try_bus_param(icd, fmt->bits_per_sample);
+	ret = pxa_camera_try_bus_param(pcdev, fmt->bits_per_sample);
 	if (ret < 0)
 		return 0;
 
-	if (!icd->host_priv) {
-		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
-		if (!cam)
-			return -ENOMEM;
-
-		icd->host_priv = cam;
-	} else {
-		cam = icd->host_priv;
-	}
-
 	switch (code.code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		formats++;
@@ -1240,7 +1202,8 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			xlate->host_fmt	= &pxa_camera_formats[0];
 			xlate->code	= code.code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s using code %d\n",
 				pxa_camera_formats[0].name, code.code);
 		}
 	case MEDIA_BUS_FMT_VYUY8_2X8:
@@ -1249,14 +1212,15 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		if (xlate)
-			dev_dbg(dev, "Providing format %s packed\n",
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s packed\n",
 				fmt->name);
 		break;
 	default:
 		if (!pxa_camera_packing_supported(fmt))
 			return 0;
 		if (xlate)
-			dev_dbg(dev,
+			dev_dbg(pcdev_to_dev(pcdev),
 				"Providing format %s in pass-through mode\n",
 				fmt->name);
 	}
@@ -1272,10 +1236,22 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	return formats;
 }
 
-static void pxa_camera_put_formats(struct soc_camera_device *icd)
+static int pxa_camera_build_formats(struct pxa_camera_dev *pcdev)
 {
-	kfree(icd->host_priv);
-	icd->host_priv = NULL;
+	struct soc_camera_format_xlate *xlate;
+
+	xlate = soc_mbus_build_fmts_xlate(&pcdev->v4l2_dev, pcdev->sensor,
+					  pxa_camera_get_formats);
+	if (IS_ERR(xlate))
+		return PTR_ERR(xlate);
+
+	pcdev->user_formats = xlate;
+	return 0;
+}
+
+static void pxa_camera_destroy_formats(struct pxa_camera_dev *pcdev)
+{
+	kfree(pcdev->user_formats);
 }
 
 static int pxa_camera_check_frame(u32 width, u32 height)
@@ -1285,158 +1261,47 @@ static int pxa_camera_check_frame(u32 width, u32 height)
 		(width & 0x01);
 }
 
-static int pxa_camera_set_crop(struct soc_camera_device *icd,
-			       const struct v4l2_crop *a)
+static int pxa_camera_enum_fmt_vid_cap(struct file *filp, void  *priv,
+				       struct v4l2_fmtdesc *f)
 {
-	const struct v4l2_rect *rect = &a->c;
-	struct device *dev = icd->parent;
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_sense sense = {
-		.master_clock = pcdev->mclk,
-		.pixel_clock_max = pcdev->ciclk / 4,
-	};
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
-	struct pxa_cam *cam = icd->host_priv;
-	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
-	int ret;
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_mbus_pixelfmt *format;
+	unsigned int idx;
 
-	/* If PCLK is used to latch data from the sensor, check sense */
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		icd->sense = &sense;
-
-	ret = v4l2_subdev_call(sd, video, s_crop, a);
-
-	icd->sense = NULL;
-
-	if (ret < 0) {
-		dev_warn(dev, "Failed to crop to %ux%u@%u:%u\n",
-			 rect->width, rect->height, rect->left, rect->top);
-		return ret;
-	}
-
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
-	if (ret < 0)
-		return ret;
-
-	if (pxa_camera_check_frame(mf->width, mf->height)) {
-		/*
-		 * Camera cropping produced a frame beyond our capabilities.
-		 * FIXME: just extract a subframe, that we can process.
-		 */
-		v4l_bound_align_image(&mf->width, 48, 2048, 1,
-			&mf->height, 32, 2048, 0,
-			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &fmt);
-		if (ret < 0)
-			return ret;
-
-		if (pxa_camera_check_frame(mf->width, mf->height)) {
-			dev_warn(icd->parent,
-				 "Inconsistent state. Use S_FMT to repair\n");
-			return -EINVAL;
-		}
-	}
-
-	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
-		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(dev,
-				"pixel clock %lu set by the camera too high!",
-				sense.pixel_clock);
-			return -EIO;
-		}
-		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
-	}
-
-	icd->user_width		= mf->width;
-	icd->user_height	= mf->height;
+	for (idx = 0; pcdev->user_formats[idx].code; idx++);
+	if (f->index >= idx)
+		return -EINVAL;
 
-	pxa_camera_setup_cicr(icd, cam->flags, fourcc);
+	format = pcdev->user_formats[f->index].host_fmt;
 
-	return ret;
+	if (format->name)
+		strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+	return 0;
 }
 
-static int pxa_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int pxa_camera_g_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
 {
-	struct device *dev = icd->parent;
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_format_xlate *xlate = NULL;
-	struct soc_camera_sense sense = {
-		.master_clock = pcdev->mclk,
-		.pixel_clock_max = pcdev->ciclk / 4,
-	};
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-	int ret;
-
-	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
-	if (!xlate) {
-		dev_warn(dev, "Format %x not found\n", pix->pixelformat);
-		return -EINVAL;
-	}
-
-	/* If PCLK is used to latch data from the sensor, check sense */
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		/* The caller holds a mutex. */
-		icd->sense = &sense;
 
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	mf->field	= pix->field;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
-
-	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
-
-	if (mf->code != xlate->code)
-		return -EINVAL;
-
-	icd->sense = NULL;
-
-	if (ret < 0) {
-		dev_warn(dev, "Failed to configure for format %x\n",
-			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(mf->width, mf->height)) {
-		dev_warn(dev,
-			 "Camera driver produced an unsupported frame %dx%d\n",
-			 mf->width, mf->height);
-		ret = -EINVAL;
-	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
-		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(dev,
-				"pixel clock %lu set by the camera too high!",
-				sense.pixel_clock);
-			return -EIO;
-		}
-		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
-	}
-
-	if (ret < 0)
-		return ret;
-
-	pix->width		= mf->width;
-	pix->height		= mf->height;
-	pix->field		= mf->field;
-	pix->colorspace		= mf->colorspace;
-	icd->current_fmt	= xlate;
-
-	return ret;
+	pix->width		= pcdev->current_pix.width;
+	pix->height		= pcdev->current_pix.height;
+	pix->bytesperline	= pcdev->current_pix.bytesperline;
+	pix->sizeimage		= pcdev->current_pix.sizeimage;
+	pix->field		= pcdev->current_pix.field;
+	pix->pixelformat	= pcdev->current_fmt->host_fmt->fourcc;
+	pix->colorspace		= pcdev->current_pix.colorspace;
+	dev_dbg(pcdev_to_dev(pcdev), "current_fmt->fourcc: 0x%08x\n",
+		pcdev->current_fmt->host_fmt->fourcc);
+	return 0;
 }
 
-static int pxa_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int pxa_camera_try_fmt_vid_cap(struct file *filp, void *priv,
+				      struct v4l2_format *f)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_pad_config pad_cfg;
@@ -1447,9 +1312,9 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
+		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1463,21 +1328,15 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      &pix->height, 32, 2048, 0,
 			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
-	/* limit to sensor capabilities */
-	mf->width	= pix->width;
-	mf->height	= pix->height;
 	/* Only progressive video supported so far */
+	v4l2_fill_mbus_format(mf, pix, xlate->code);
 	mf->field	= V4L2_FIELD_NONE;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
+	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf->width;
-	pix->height	= mf->height;
-	pix->colorspace	= mf->colorspace;
+	v4l2_fill_pix_format(pix, mf);
 
 	switch (mf->field) {
 	case V4L2_FIELD_ANY:
@@ -1486,22 +1345,87 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		break;
 	default:
 		/* TODO: support interlaced at least in pass-through mode */
-		dev_err(icd->parent, "Field type %d unsupported.\n",
+		dev_err(pcdev_to_dev(pcdev), "Field type %d unsupported.\n",
 			mf->field);
 		return -EINVAL;
 	}
 
-	return ret;
+	ret = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
+	if (ret < 0)
+		return ret;
+
+	pix->bytesperline = max_t(u32, pix->bytesperline, ret);
+	ret = soc_mbus_image_size(xlate->host_fmt, pix->bytesperline,
+				  pix->height);
+	if (ret < 0)
+		return ret;
+
+	pix->sizeimage = max_t(u32, pix->sizeimage, ret);
+	return 0;
 }
 
-static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
+static int pxa_camera_s_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
 {
-	struct soc_camera_device *icd = file->private_data;
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	int ret;
+	/* struct soc_camera_sense sense = { */
+	/* 	.master_clock = pcdev->mclk, */
+	/* 	.pixel_clock_max = pcdev->ciclk / 4, */
+	/* }; */
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	dev_dbg(pcdev_to_dev(pcdev),
+		"s_fmt_vid_cap(pix=%dx%d:%x)\n",
+		pix->width, pix->height, pix->pixelformat);
+	ret = pxa_camera_try_fmt_vid_cap(filp, priv, f);
+	if (ret)
+		return ret;
+
+	/* If PCLK is used to latch data from the sensor, check sense */
+	/* if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN) */
+	/* 	/\* The caller holds a mutex. *\/ */
+	/* 	icd->sense = &sense; */
+	/* if (mf->code != xlate->code) */
+	/* 	return -EINVAL; */
+	/* icd->sense = NULL; */
+
+	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats,
+					 pix->pixelformat);
+	v4l2_fill_mbus_format(&format.format, pix, xlate->code);
+	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
+	if (ret < 0) {
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Failed to configure for format %x\n",
+			 pix->pixelformat);
+	} else if (pxa_camera_check_frame(pix->width, pix->height)) {
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Camera driver produced an unsupported frame %dx%d\n",
+			 pix->width, pix->height);
+		return -EINVAL;
+	}
+	/* else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) { */
+	/* 	if (sense.pixel_clock > sense.pixel_clock_max) { */
+	/* 		dev_err(dev, */
+	/* 			"pixel clock %lu set by the camera too high!", */
+	/* 			sense.pixel_clock); */
+	/* 		return -EIO; */
+	/* 	} */
+	/* 	recalculate_fifo_timeout(pcdev, sense.pixel_clock); */
+	/* } */
+
+	pcdev->current_fmt = xlate;
+	pcdev->current_pix = *pix;
+
+	ret = pxa_camera_set_bus_param(pcdev);
+	return ret;
 }
 
-static int pxa_camera_querycap(struct soc_camera_host *ici,
+static int pxa_camera_querycap(struct file *file, void *priv,
 			       struct v4l2_capability *cap)
 {
 	/* cap->name is set by the firendly caller:-> */
@@ -1514,8 +1438,7 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 
 static int pxa_camera_suspend(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
 	int i = 0, ret = 0;
 
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
@@ -1524,9 +1447,8 @@ static int pxa_camera_suspend(struct device *dev)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if (pcdev->soc_host.icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
-		ret = v4l2_subdev_call(sd, core, s_power, 0);
+	if (pcdev->sensor) {
+		ret = sensor_call(pcdev, core, s_power, 0);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 	}
@@ -1536,8 +1458,7 @@ static int pxa_camera_suspend(struct device *dev)
 
 static int pxa_camera_resume(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
 	int i = 0, ret = 0;
 
 	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
@@ -1546,9 +1467,8 @@ static int pxa_camera_resume(struct device *dev)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
-	if (pcdev->soc_host.icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
-		ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (pcdev->sensor) {
+		ret = sensor_call(pcdev, core, s_power, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 	}
@@ -1560,28 +1480,12 @@ static int pxa_camera_resume(struct device *dev)
 	return ret;
 }
 
-static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
-	.owner		= THIS_MODULE,
-	.add		= pxa_camera_add_device,
-	.remove		= pxa_camera_remove_device,
-	.clock_start	= pxa_camera_clock_start,
-	.clock_stop	= pxa_camera_clock_stop,
-	.set_crop	= pxa_camera_set_crop,
-	.get_formats	= pxa_camera_get_formats,
-	.put_formats	= pxa_camera_put_formats,
-	.set_fmt	= pxa_camera_set_fmt,
-	.try_fmt	= pxa_camera_try_fmt,
-	.init_videobuf2	= pxa_camera_init_videobuf2,
-	.poll		= pxa_camera_poll,
-	.querycap	= pxa_camera_querycap,
-	.set_bus_param	= pxa_camera_set_bus_param,
-};
-
 static int pxa_camera_pdata_from_dt(struct device *dev,
-				    struct pxa_camera_dev *pcdev)
+				    struct pxa_camera_dev *pcdev,
+				    struct v4l2_async_subdev *asd)
 {
 	u32 mclk_rate;
-	struct device_node *np = dev->of_node;
+	struct device_node *remote, *np = dev->of_node;
 	struct v4l2_of_endpoint ep;
 	int err = of_property_read_u32(np, "clock-frequency",
 				       &mclk_rate);
@@ -1633,12 +1537,169 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
 
+	asd->match_type = V4L2_ASYNC_MATCH_OF;
+	remote = of_graph_get_remote_port(np);
+	if (remote) {
+		asd->match.of.node = remote;
+		of_node_put(remote);
+	} else {
+		dev_notice(dev, "no remote for %s\n", of_node_full_name(np));
+	}
+
 out:
 	of_node_put(np);
 
 	return err;
 }
 
+static int pxa_camera_open(struct file *filp)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	int ret;
+
+	mutex_lock(&pcdev->mlock);
+	ret = v4l2_fh_open(filp);
+	if (ret < 0)
+		goto out;
+
+	ret = sensor_call(pcdev, core, s_power, 1);
+	if (ret)
+		v4l2_fh_release(filp);
+out:
+	mutex_unlock(&pcdev->mlock);
+	return ret;
+}
+
+static int pxa_camera_release(struct file *filp)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	int ret;
+
+	mutex_lock(&pcdev->mlock);
+	ret = sensor_call(pcdev, core, s_power, 0);
+	mutex_unlock(&pcdev->mlock);
+	if (ret < 0)
+		return ret;
+
+	ret = vb2_fop_release(filp);
+	return ret;
+}
+
+static const struct v4l2_file_operations pxa_camera_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pxa_camera_open,
+	.release	= pxa_camera_release,
+	.read		= vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
+	.vidioc_querycap 		= pxa_camera_querycap,
+	.vidioc_enum_fmt_vid_cap	= pxa_camera_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= pxa_camera_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= pxa_camera_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= pxa_camera_try_fmt_vid_cap,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+};
+
+struct v4l2_clk_ops pxa_camera_mclk_ops = {
+};
+
+static const struct video_device pxa_camera_videodev_template = {
+	.name = "pxa-camera",
+	.minor = -1,
+	.fops = &pxa_camera_fops,
+	.ioctl_ops = &pxa_camera_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd)
+{
+	int err;
+	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
+	struct video_device *vdev = &pcdev->vdev;
+
+	dev_info(pcdev_to_dev(pcdev), "%s(): trying to bind a device\n",
+		 __func__);
+	mutex_lock(&pcdev->mlock);
+	*vdev = pxa_camera_videodev_template;
+	vdev->v4l2_dev = v4l2_dev;
+	vdev->lock = &pcdev->mlock;
+	pcdev->sensor = subdev;
+	pcdev->vdev.queue = &pcdev->vb2_vq;
+	pcdev->vdev.v4l2_dev = &pcdev->v4l2_dev;
+	video_set_drvdata(&pcdev->vdev, pcdev);
+
+	v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
+	v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
+	v4l2_disable_ioctl(vdev, VIDIOC_ENUMSTD);
+
+	err = pxa_camera_build_formats(pcdev);
+	if (err) {
+		dev_err(pcdev_to_dev(pcdev), "building formats failed: %d\n",
+			err);
+		goto out;
+	}
+
+	err = pxa_camera_init_videobuf2(pcdev);
+	if (err)
+		goto out;
+
+	err = video_register_device(&pcdev->vdev, VFL_TYPE_GRABBER, -1);
+	if (err) {
+		v4l2_err(v4l2_dev, "register video device failed: %d\n", err);
+		pcdev->sensor = NULL;
+	} else {
+		dev_info(pcdev_to_dev(pcdev),
+			 "PXA Camera driver attached to camera %s\n",
+			 subdev->name);
+	}
+out:
+	mutex_unlock(&pcdev->mlock);
+	return err;
+}
+
+static void pxa_camera_sensor_unbind(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd)
+{
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(notifier->v4l2_dev);
+
+	mutex_lock(&pcdev->mlock);
+	dev_info(pcdev_to_dev(pcdev),
+		 "PXA Camera driver attached to camera %s\n",
+		 subdev->name);
+
+	/* disable capture, disable interrupts */
+	__raw_writel(0x3ff, pcdev->base + CICR0);
+
+	/* Stop DMA engine */
+	pxa_dma_stop_channels(pcdev);
+
+	pxa_camera_destroy_formats(pcdev);
+	video_unregister_device(&pcdev->vdev);
+	pcdev->sensor = NULL;
+
+	mutex_unlock(&pcdev->mlock);
+}
+
+static struct v4l2_async_subdev asd;
+static struct v4l2_async_subdev *asds[1] = {
+	[0] = &asd,
+};
+
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
@@ -1651,6 +1712,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	};
 	dma_cap_mask_t mask;
 	struct pxad_param params;
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	int irq;
 	int err = 0, i;
 
@@ -1677,10 +1739,13 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	pcdev->pdata = pdev->dev.platform_data;
 	if (&pdev->dev.of_node && !pcdev->pdata) {
-		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev);
+		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &asd);
 	} else {
 		pcdev->platform_flags = pcdev->pdata->flags;
 		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
+		asd.match_type = V4L2_ASYNC_MATCH_I2C;
+		asd.match.i2c.adapter_id = pcdev->pdata->sensor_i2c_adapter_id;
+		asd.match.i2c.address = pcdev->pdata->sensor_i2c_address;
 	}
 	if (err < 0)
 		return err;
@@ -1712,6 +1777,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
+	mutex_init(&pcdev->mlock);
 
 	/*
 	 * Request the regions.
@@ -1774,19 +1840,48 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		goto exit_free_dma;
 	}
 
-	pcdev->soc_host.drv_name	= PXA_CAM_DRV_NAME;
-	pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
-	pcdev->soc_host.priv		= pcdev;
-	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
-	pcdev->soc_host.nr		= pdev->id;
+	//RJK pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
 	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
 
-	err = soc_camera_host_register(&pcdev->soc_host);
+	pxa_camera_activate(pcdev);
+
+	dev_set_drvdata(&pdev->dev, pcdev);
+	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (err)
 		goto exit_free_dma;
 
-	return 0;
+	pcdev->notifier.subdevs = asds;
+	pcdev->notifier.num_subdevs = 1;
+	pcdev->notifier.bound = pxa_camera_sensor_bound;
+	pcdev->notifier.unbind = pxa_camera_sensor_unbind;
+
+	if (!of_have_populated_dt())
+		asd.match_type = V4L2_ASYNC_MATCH_I2C;
+
+	err = pxa_camera_init_videobuf2(pcdev);
+	if (err)
+		goto exit_free_v4l2dev;
+
+	if (pcdev->mclk) {
+		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
+				  asd.match.i2c.adapter_id,
+				  asd.match.i2c.address);
 
+		pcdev->mclk_clk = v4l2_clk_register(&pxa_camera_mclk_ops,
+						    clk_name, NULL);
+		if (IS_ERR(pcdev->mclk_clk))
+			return PTR_ERR(pcdev->mclk_clk);
+	}
+
+	err = v4l2_async_notifier_register(&pcdev->v4l2_dev, &pcdev->notifier);
+	if (err)
+		goto exit_free_clk;
+
+	return 0;
+exit_free_clk:
+	v4l2_clk_unregister(pcdev->mclk_clk);
+exit_free_v4l2dev:
+	v4l2_device_unregister(&pcdev->v4l2_dev);
 exit_free_dma:
 	dma_release_channel(pcdev->dma_chans[2]);
 exit_free_dma_u:
@@ -1798,16 +1893,16 @@ exit_free_dma_y:
 
 static int pxa_camera_remove(struct platform_device *pdev)
 {
-	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
-	struct pxa_camera_dev *pcdev = container_of(soc_host,
-					struct pxa_camera_dev, soc_host);
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(&pdev->dev);
 
+	pxa_camera_deactivate(pcdev);
 	dma_release_channel(pcdev->dma_chans[0]);
 	dma_release_channel(pcdev->dma_chans[1]);
 	dma_release_channel(pcdev->dma_chans[2]);
 	vb2_dma_sg_cleanup_ctx(pcdev->alloc_ctx);
+	v4l2_clk_unregister(pcdev->mclk_clk);
 
-	soc_camera_host_unregister(soc_host);
+	v4l2_device_unregister(&pcdev->v4l2_dev);
 
 	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
 
diff --git a/include/linux/platform_data/media/camera-pxa.h b/include/linux/platform_data/media/camera-pxa.h
index 6709b1cd7c77..ce5d90e1a6e4 100644
--- a/include/linux/platform_data/media/camera-pxa.h
+++ b/include/linux/platform_data/media/camera-pxa.h
@@ -37,6 +37,8 @@
 struct pxacamera_platform_data {
 	unsigned long flags;
 	unsigned long mclk_10khz;
+	int sensor_i2c_adapter_id;
+	int sensor_i2c_address;
 };
 
 extern void pxa_set_camera_info(struct pxacamera_platform_data *);
-- 
2.1.4

