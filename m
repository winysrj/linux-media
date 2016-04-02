Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:35379 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbcDBO1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 10:27:22 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH RFC v2 2/2] media: platform: pxa_camera: make a standalone v4l2 device
Date: Sat,  2 Apr 2016 16:26:53 +0200
Message-Id: <1459607213-15774-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the soc_camera API dependency from pxa_camera.
In the current status :
 - all previously captures are working the same on pxa270
 - the s_crop() call was removed, judged not working
   (see what happens soc_camera_s_crop() when get_crop() == NULL)
 - if the pixel clock is provided by then sensor, ie. not MCLK, the dual
   stage change is not handled yet.
   => there is no in-tree user of this, so I'll let it that way

 - the MCLK is not yet finished, it's as in the legacy way,
   ie. activated at video device opening and closed at video device
   closing.
   In a subsequence patch pxa_camera_mclk_ops should be used, and
   platform data MCLK ignored. It will be the sensor's duty to request
   the clock and enable it, which will end in pxa_camera_mclk_ops.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
Since v1:
  - function namings were cleaned into pxac_XXX_YYYY()
  - function were regrouped in the 3 big categories :
    - device probing/removal : pxa_camera_*()
    - videobuf2 : pxac_vb2_*()
    - v42l file operations : pxac_vidioc_*()
    - internal driver functions : pxa_camera_*() : to be found a cute
      pattern for RFC v3
---
 drivers/media/platform/soc_camera/pxa_camera.c | 1086 ++++++++++++++----------
 include/linux/platform_data/media/camera-pxa.h |    2 +
 2 files changed, 620 insertions(+), 468 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index b8dd878e98d6..30d266bbab55 100644
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
@@ -46,6 +52,9 @@
 #define PXA_CAM_VERSION "0.0.6"
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
 
+#define DEFAULT_WIDTH	640
+#define DEFAULT_HEIGHT	480
+
 /* Camera Interface */
 #define CICR0		0x0000
 #define CICR1		0x0004
@@ -168,6 +177,9 @@
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
 
+#define sensor_call(cam, o, f, args...) \
+	v4l2_subdev_call(cam->sensor, o, f, ##args)
+
 /*
  * Structures
  */
@@ -195,7 +207,18 @@ struct pxa_buffer {
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
+
+	struct v4l2_async_subdev asd;
+	struct v4l2_async_subdev *asds[1];
+
 	/*
 	 * PXA27x is only supposed to handle one camera on its Quick Capture
 	 * interface. If anyone ever builds hardware to enable more than
@@ -215,11 +238,14 @@ struct pxa_camera_dev {
 	unsigned long		ciclk;
 	unsigned long		mclk;
 	u32			mclk_divisor;
+	struct v4l2_clk		*mclk_clk;
 	u16			width_flags;	/* max 10 bits */
 
 	struct list_head	capture;
 
 	spinlock_t		lock;
+	struct mutex		mlock;
+	unsigned int		buf_sequence;
 
 	struct pxa_buffer	*active;
 	struct tasklet_struct	task_eof;
@@ -247,7 +273,12 @@ static struct pxa_buffer *vb2_to_pxa_buffer(struct vb2_buffer *vb)
 
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
@@ -328,7 +359,7 @@ static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
 				    struct pxa_buffer *buf)
 {
 	buf->active_dma = DMA_Y;
-	if (pcdev->channels == 3)
+	if (buf->nb_planes == 3)
 		buf->active_dma |= DMA_U | DMA_V;
 }
 
@@ -390,6 +421,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 	unsigned long cicr0;
 
 	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
+	pcdev->buf_sequence = 0;
 	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
@@ -414,10 +446,13 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 			      struct pxa_buffer *buf)
 {
 	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&buf->queue);
 	vb->timestamp = ktime_get_ns();
+	vbuf->sequence = pcdev->buf_sequence++;
+	vbuf->field = V4L2_FIELD_NONE;
 	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	dev_dbg(pcdev_to_dev(pcdev), "%s dequeud buffer (buf=0x%p)\n",
 		__func__, buf);
@@ -544,7 +579,7 @@ static void pxa_buffer_cleanup(struct pxa_buffer *buf)
 {
 	int i;
 
-	for (i = 0; i < 3 && buf->descs[i]; i++) {
+	for (i = 0; i < buf->nb_planes && buf->descs[i]; i++) {
 		dmaengine_desc_free(buf->descs[i]);
 		kfree(buf->sg[i]);
 		buf->descs[i] = NULL;
@@ -598,170 +633,6 @@ static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
 	return ret;
 }
 
-static void pxac_vb2_cleanup(struct vb2_buffer *vb)
-{
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vb=%p)\n", __func__, vb);
-	pxa_buffer_cleanup(buf);
-}
-
-static void pxac_vb2_queue(struct vb2_buffer *vb)
-{
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
-		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
-		pcdev->active);
-
-	list_add_tail(&buf->queue, &pcdev->capture);
-
-	pxa_dma_add_tail_buf(pcdev, buf);
-
-	if (!pcdev->active)
-		pxa_camera_start_capture(pcdev);
-}
-
-/*
- * Please check the DMA prepared buffer structure in :
- *   Documentation/video4linux/pxa_camera.txt
- * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
- * modification while DMA chain is running will work anyway.
- */
-static int pxac_vb2_prepare(struct vb2_buffer *vb)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	int ret = 0;
-
-	switch (pcdev->channels) {
-	case 1:
-	case 3:
-		vb2_set_plane_payload(vb, 0, icd->sizeimage);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s (vb=%p) nb_channels=%d size=%lu\n",
-		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
-
-	WARN_ON(!icd->current_fmt);
-
-#ifdef DEBUG
-	/*
-	 * This can be useful if you want to see if we actually fill
-	 * the buffer with something
-	 */
-	for (i = 0; i < vb->num_planes; i++)
-		memset((void *)vb2_plane_vaddr(vb, i),
-		       0xaa, vb2_get_plane_payload(vb, i));
-#endif
-
-	/*
-	 * I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours
-	 */
-	buf->inwork = 0;
-	pxa_videobuf_set_actdma(pcdev, buf);
-
-	return ret;
-}
-
-static int pxac_vb2_init(struct vb2_buffer *vb)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(nb_channels=%d)\n",
-		__func__, pcdev->channels);
-
-	return pxa_buffer_init(pcdev, buf);
-}
-
-static int pxac_vb2_queue_setup(struct vb2_queue *vq,
-				unsigned int *nbufs,
-				unsigned int *num_planes, unsigned int sizes[],
-				void *alloc_ctxs[])
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	int size = icd->sizeimage;
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
-		__func__, vq, *nbufs, *num_planes, size);
-	/*
-	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
-	 * format, even if there are 3 planes Y, U and V, we reply there is only
-	 * one plane, containing Y, U and V data, one after the other.
-	 */
-	if (*num_planes)
-		return sizes[0] < size ? -EINVAL : 0;
-
-	*num_planes = 1;
-	switch (pcdev->channels) {
-	case 1:
-	case 3:
-		sizes[0] = size;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	alloc_ctxs[0] = pcdev->alloc_ctx;
-	if (!*nbufs)
-		*nbufs = 1;
-
-	return 0;
-}
-
-static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
-{
-	vb2_wait_for_all_buffers(vq);
-}
-
-static struct vb2_ops pxac_vb2_ops = {
-	.queue_setup		= pxac_vb2_queue_setup,
-	.buf_init		= pxac_vb2_init,
-	.buf_prepare		= pxac_vb2_prepare,
-	.buf_queue		= pxac_vb2_queue,
-	.buf_cleanup		= pxac_vb2_cleanup,
-	.stop_streaming		= pxac_vb2_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
-};
-
-static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
-				     struct soc_camera_device *icd)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	int ret;
-
-	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
-	vq->drv_priv = pcdev;
-	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	vq->buf_struct_size = sizeof(struct pxa_buffer);
-
-	vq->ops = &pxac_vb2_ops;
-	vq->mem_ops = &vb2_dma_sg_memops;
-
-	ret = vb2_queue_init(vq);
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
-
-	return ret;
-}
-
 static u32 mclk_get_divisor(struct platform_device *pdev,
 			    struct pxa_camera_dev *pcdev)
 {
@@ -881,47 +752,6 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
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
@@ -947,15 +777,12 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
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
@@ -964,7 +791,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	 * Datawidth is now guaranteed to be equal to one of the three values.
 	 * We fix bit-per-pixel equal to data-width...
 	 */
-	switch (icd->current_fmt->host_fmt->bits_per_sample) {
+	switch (pcdev->current_fmt->host_fmt->bits_per_sample) {
 	case 10:
 		dw = 4;
 		bpp = 0x40;
@@ -998,7 +825,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	if (cicr0 & CICR0_ENB)
 		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
 
-	cicr1 = CICR1_PPL_VAL(icd->user_width - 1) | bpp | dw;
+	cicr1 = CICR1_PPL_VAL(pcdev->current_pix.width - 1) | bpp | dw;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_YUV422P:
@@ -1027,7 +854,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	}
 
 	cicr2 = 0;
-	cicr3 = CICR3_LPF_VAL(icd->user_height - 1) |
+	cicr3 = CICR3_LPF_VAL(pcdev->current_pix.height - 1) |
 		CICR3_BFW_VAL(min((u32)255, y_skip_top));
 	cicr4 |= pcdev->mclk_divisor;
 
@@ -1043,28 +870,25 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
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
@@ -1103,26 +927,22 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
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
-
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
@@ -1130,12 +950,12 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
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
@@ -1168,45 +988,35 @@ static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
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
@@ -1214,7 +1024,8 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			xlate->host_fmt	= &pxa_camera_formats[0];
 			xlate->code	= code.code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s using code %d\n",
 				pxa_camera_formats[0].name, code.code);
 		}
 	case MEDIA_BUS_FMT_VYUY8_2X8:
@@ -1223,14 +1034,15 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
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
@@ -1246,10 +1058,22 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	return formats;
 }
 
-static void pxa_camera_put_formats(struct soc_camera_device *icd)
+static int pxa_camera_build_formats(struct pxa_camera_dev *pcdev)
+{
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
 {
-	kfree(icd->host_priv);
-	icd->host_priv = NULL;
+	kfree(pcdev->user_formats);
 }
 
 static int pxa_camera_check_frame(u32 width, u32 height)
@@ -1259,237 +1083,538 @@ static int pxa_camera_check_frame(u32 width, u32 height)
 		(width & 0x01);
 }
 
-static int pxa_camera_set_crop(struct soc_camera_device *icd,
-			       const struct v4l2_crop *a)
+static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
+					struct v4l2_fmtdesc *f)
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
-
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
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_mbus_pixelfmt *format;
+	unsigned int idx;
 
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
+	for (idx = 0; pcdev->user_formats[idx].code; idx++);
+	if (f->index >= idx)
+		return -EINVAL;
 
-	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
-		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(dev,
-				"pixel clock %lu set by the camera too high!",
-				sense.pixel_clock);
-			return -EIO;
-		}
-		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
-	}
+	format = pcdev->user_formats[f->index].host_fmt;
 
-	icd->user_width		= mf->width;
-	icd->user_height	= mf->height;
+	if (format->name)
+		strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+	return 0;
+}
 
-	pxa_camera_setup_cicr(icd, cam->flags, fourcc);
+static int pxac_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 
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
 
-static int pxa_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
+				      struct v4l2_format *f)
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
+	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
 	struct v4l2_mbus_framefmt *mf = &format.format;
+	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
-	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
 	if (!xlate) {
-		dev_warn(dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	/* If PCLK is used to latch data from the sensor, check sense */
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		/* The caller holds a mutex. */
-		icd->sense = &sense;
+	/*
+	 * Limit to pxa hardware capabilities.  YUV422P planar format requires
+	 * images size to be a multiple of 16 bytes.  If not, zeros will be
+	 * inserted between Y and U planes, and U and V planes, which violates
+	 * the YUV422P standard.
+	 */
+	v4l_bound_align_image(&pix->width, 48, 2048, 1,
+			      &pix->height, 32, 2048, 0,
+			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	mf->field	= pix->field;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
+	v4l2_fill_mbus_format(mf, pix, xlate->code);
+	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
+	if (ret < 0)
+		return ret;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
+	v4l2_fill_pix_format(pix, mf);
 
-	if (mf->code != xlate->code)
+	/* Only progressive video supported so far */
+	switch (mf->field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		pix->field = V4L2_FIELD_NONE;
+		break;
+	default:
+		/* TODO: support interlaced at least in pass-through mode */
+		dev_err(pcdev_to_dev(pcdev), "Field type %d unsupported.\n",
+			mf->field);
 		return -EINVAL;
+	}
+
+	ret = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
+	if (ret < 0)
+		return ret;
+
+	pix->bytesperline = ret;
+	ret = soc_mbus_image_size(xlate->host_fmt, pix->bytesperline,
+				  pix->height);
+	if (ret < 0)
+		return ret;
+
+	pix->sizeimage = max_t(u32, pix->sizeimage, ret);
+	return 0;
+}
+
+static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	unsigned long flags;
+	int ret, is_busy;
 
-	icd->sense = NULL;
+	dev_dbg(pcdev_to_dev(pcdev),
+		"s_fmt_vid_cap(pix=%dx%d:%x)\n",
+		pix->width, pix->height, pix->pixelformat);
 
+	spin_lock_irqsave(&pcdev->lock, flags);
+	is_busy = pcdev->active || vb2_is_busy(&pcdev->vb2_vq);
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
+	if (is_busy)
+		return -EBUSY;
+
+	ret = pxac_vidioc_try_fmt_vid_cap(filp, priv, f);
+	if (ret)
+		return ret;
+
+	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats,
+					 pix->pixelformat);
+	v4l2_fill_mbus_format(&format.format, pix, xlate->code);
+	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
 	if (ret < 0) {
-		dev_warn(dev, "Failed to configure for format %x\n",
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Failed to configure for format %x\n",
 			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(mf->width, mf->height)) {
-		dev_warn(dev,
+	} else if (pxa_camera_check_frame(pix->width, pix->height)) {
+		dev_warn(pcdev_to_dev(pcdev),
 			 "Camera driver produced an unsupported frame %dx%d\n",
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
+			 pix->width, pix->height);
+		return -EINVAL;
 	}
 
+	pcdev->current_fmt = xlate;
+	pcdev->current_pix = *pix;
+
+	ret = pxa_camera_set_bus_param(pcdev);
+	return ret;
+}
+
+static int pxac_vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
+	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int pxac_vidioc_enum_input(struct file *file, void *priv,
+				  struct v4l2_input *i)
+{
+	if (i->index > 0)
+		return -EINVAL;
+
+	memset(i, 0, sizeof(*i));
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(i->name, "Camera", sizeof(i->name));
+
+	return 0;
+}
+
+static int pxac_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+static int pxac_vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int pxac_fops_camera_open(struct file *filp)
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
+static int pxac_fops_camera_release(struct file *filp)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	int ret;
+
+	ret = vb2_fop_release(filp);
 	if (ret < 0)
 		return ret;
 
-	pix->width		= mf->width;
-	pix->height		= mf->height;
-	pix->field		= mf->field;
-	pix->colorspace		= mf->colorspace;
-	icd->current_fmt	= xlate;
+	mutex_lock(&pcdev->mlock);
+	ret = sensor_call(pcdev, core, s_power, 0);
+	mutex_unlock(&pcdev->mlock);
 
 	return ret;
 }
 
-static int pxa_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static const struct v4l2_file_operations pxa_camera_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pxac_fops_camera_open,
+	.release	= pxac_fops_camera_release,
+	.read		= vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
+	.vidioc_querycap 		= pxac_vidioc_querycap,
+
+	.vidioc_enum_input		= pxac_vidioc_enum_input,
+	.vidioc_g_input			= pxac_vidioc_g_input,
+	.vidioc_s_input			= pxac_vidioc_s_input,
+
+	.vidioc_enum_fmt_vid_cap	= pxac_vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= pxac_vidioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= pxac_vidioc_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= pxac_vidioc_try_fmt_vid_cap,
+
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
+
+static void pxac_vb2_cleanup(struct vb2_buffer *vb)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_pad_config pad_cfg;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_TRY,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-	__u32 pixfmt = pix->pixelformat;
-	int ret;
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
 
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
-	if (!xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p)\n", __func__, vb);
+	pxa_buffer_cleanup(buf);
+}
+
+static void pxac_vb2_queue(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
+		pcdev->active);
+
+	list_add_tail(&buf->queue, &pcdev->capture);
+
+	pxa_dma_add_tail_buf(pcdev, buf);
+
+	if (!pcdev->active)
+		pxa_camera_start_capture(pcdev);
+}
+
+/*
+ * Please check the DMA prepared buffer structure in :
+ *   Documentation/video4linux/pxa_camera.txt
+ * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
+ * modification while DMA chain is running will work anyway.
+ */
+static int pxac_vb2_prepare(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	int ret = 0;
+
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
+		break;
+	default:
 		return -EINVAL;
 	}
 
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s (vb=%p) nb_channels=%d size=%lu\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
+
+	WARN_ON(!pcdev->current_fmt);
+
+#ifdef DEBUG
 	/*
-	 * Limit to pxa hardware capabilities.  YUV422P planar format requires
-	 * images size to be a multiple of 16 bytes.  If not, zeros will be
-	 * inserted between Y and U planes, and U and V planes, which violates
-	 * the YUV422P standard.
+	 * This can be useful if you want to see if we actually fill
+	 * the buffer with something
 	 */
-	v4l_bound_align_image(&pix->width, 48, 2048, 1,
-			      &pix->height, 32, 2048, 0,
-			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
+	for (i = 0; i < vb->num_planes; i++)
+		memset((void *)vb2_plane_vaddr(vb, i),
+		       0xaa, vb2_get_plane_payload(vb, i));
+#endif
 
-	/* limit to sensor capabilities */
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	/* Only progressive video supported so far */
-	mf->field	= V4L2_FIELD_NONE;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
+	buf->inwork = 0;
+	pxa_videobuf_set_actdma(pcdev, buf);
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
-	if (ret < 0)
-		return ret;
+	return ret;
+}
+
+static int pxac_vb2_init(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
 
-	pix->width	= mf->width;
-	pix->height	= mf->height;
-	pix->colorspace	= mf->colorspace;
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(nb_channels=%d)\n",
+		__func__, pcdev->channels);
 
-	switch (mf->field) {
-	case V4L2_FIELD_ANY:
-	case V4L2_FIELD_NONE:
-		pix->field	= V4L2_FIELD_NONE;
+	return pxa_buffer_init(pcdev, buf);
+}
+
+static int pxac_vb2_queue_setup(struct vb2_queue *vq,
+				unsigned int *nbufs,
+				unsigned int *num_planes, unsigned int sizes[],
+				void *alloc_ctxs[])
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+	int size = pcdev->current_pix.sizeimage;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
+		__func__, vq, *nbufs, *num_planes, size);
+	/*
+	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
+	 * format, even if there are 3 planes Y, U and V, we reply there is only
+	 * one plane, containing Y, U and V data, one after the other.
+	 */
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*num_planes = 1;
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		sizes[0] = size;
 		break;
 	default:
-		/* TODO: support interlaced at least in pass-through mode */
-		dev_err(icd->parent, "Field type %d unsupported.\n",
-			mf->field);
 		return -EINVAL;
 	}
 
+	alloc_ctxs[0] = pcdev->alloc_ctx;
+	if (!*nbufs)
+		*nbufs = 1;
+
+	return 0;
+}
+
+static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	vb2_wait_for_all_buffers(vq);
+}
+
+static struct vb2_ops pxac_vb2_ops = {
+	.queue_setup		= pxac_vb2_queue_setup,
+	.buf_init		= pxac_vb2_init,
+	.buf_prepare		= pxac_vb2_prepare,
+	.buf_queue		= pxac_vb2_queue,
+	.buf_cleanup		= pxac_vb2_cleanup,
+	.stop_streaming		= pxac_vb2_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
+{
+	int ret;
+	struct vb2_queue *vq = &pcdev->vb2_vq;
+
+	memset(vq, 0, sizeof(*vq));
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	vq->drv_priv = pcdev;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->buf_struct_size = sizeof(struct pxa_buffer);
+
+	vq->ops = &pxac_vb2_ops;
+	vq->mem_ops = &vb2_dma_sg_memops;
+	vq->lock = &pcdev->mlock;
+
+	ret = vb2_queue_init(vq);
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
+
 	return ret;
 }
 
-static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
+static struct v4l2_clk_ops pxa_camera_mclk_ops = {
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
 {
-	struct soc_camera_device *icd = file->private_data;
+	int err;
+	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
+	struct video_device *vdev = &pcdev->vdev;
+	struct v4l2_pix_format *pix = &pcdev->current_pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
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
+	pcdev->current_fmt = pcdev->user_formats;
+	pix->field = V4L2_FIELD_NONE;
+	pix->width = DEFAULT_WIDTH;
+	pix->height = DEFAULT_HEIGHT;
+	pix->bytesperline =
+		soc_mbus_bytes_per_line(pix->width,
+					pcdev->current_fmt->host_fmt);
+	pix->sizeimage =
+		soc_mbus_image_size(pcdev->current_fmt->host_fmt,
+				    pix->bytesperline, pix->height);
+	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
+	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
+	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
+	if (err)
+		goto out;
+
+	v4l2_fill_pix_format(pix, mf);
+	pr_info("%s(): colorspace=0x%x pixfmt=0x%x\n",
+		__func__, pix->colorspace, pix->pixelformat);
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
+		subdev->owner = v4l2_dev->dev->driver->owner;
+	}
+out:
+	mutex_unlock(&pcdev->mlock);
+	return err;
 }
 
-static int pxa_camera_querycap(struct soc_camera_host *ici,
-			       struct v4l2_capability *cap)
+static void pxa_camera_sensor_unbind(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd)
 {
-	/* cap->name is set by the firendly caller:-> */
-	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(notifier->v4l2_dev);
 
-	return 0;
+	mutex_lock(&pcdev->mlock);
+	dev_info(pcdev_to_dev(pcdev),
+		 "PXA Camera driver detached from camera %s\n",
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
 }
 
 static int pxa_camera_suspend(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
 	int i = 0, ret = 0;
 
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
@@ -1498,9 +1623,8 @@ static int pxa_camera_suspend(struct device *dev)
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
@@ -1510,8 +1634,7 @@ static int pxa_camera_suspend(struct device *dev)
 
 static int pxa_camera_resume(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
 	int i = 0, ret = 0;
 
 	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
@@ -1520,9 +1643,8 @@ static int pxa_camera_resume(struct device *dev)
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
@@ -1534,28 +1656,12 @@ static int pxa_camera_resume(struct device *dev)
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
@@ -1607,6 +1713,15 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
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
 
@@ -1625,6 +1740,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	};
 	dma_cap_mask_t mask;
 	struct pxad_param params;
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	int irq;
 	int err = 0, i;
 
@@ -1651,10 +1767,14 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	pcdev->pdata = pdev->dev.platform_data;
 	if (&pdev->dev.of_node && !pcdev->pdata) {
-		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev);
+		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
 	} else {
 		pcdev->platform_flags = pcdev->pdata->flags;
 		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
+		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
+		pcdev->asd.match.i2c.adapter_id =
+			pcdev->pdata->sensor_i2c_adapter_id;
+		pcdev->asd.match.i2c.address = pcdev->pdata->sensor_i2c_address;
 	}
 	if (err < 0)
 		return err;
@@ -1686,6 +1806,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
+	mutex_init(&pcdev->mlock);
 
 	/*
 	 * Request the regions.
@@ -1748,19 +1869,48 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		goto exit_free_dma;
 	}
 
-	pcdev->soc_host.drv_name	= PXA_CAM_DRV_NAME;
-	pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
-	pcdev->soc_host.priv		= pcdev;
-	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
-	pcdev->soc_host.nr		= pdev->id;
 	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
 
-	err = soc_camera_host_register(&pcdev->soc_host);
+	pxa_camera_activate(pcdev);
+
+	dev_set_drvdata(&pdev->dev, pcdev);
+	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (err)
 		goto exit_free_dma;
 
-	return 0;
+	pcdev->asds[0] = &pcdev->asd;
+	pcdev->notifier.subdevs = pcdev->asds;
+	pcdev->notifier.num_subdevs = 1;
+	pcdev->notifier.bound = pxa_camera_sensor_bound;
+	pcdev->notifier.unbind = pxa_camera_sensor_unbind;
+
+	if (!of_have_populated_dt())
+		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
 
+	err = pxa_camera_init_videobuf2(pcdev);
+	if (err)
+		goto exit_free_v4l2dev;
+
+	if (pcdev->mclk) {
+		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
+				  pcdev->asd.match.i2c.adapter_id,
+				  pcdev->asd.match.i2c.address);
+
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
@@ -1772,16 +1922,16 @@ exit_free_dma_y:
 
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

