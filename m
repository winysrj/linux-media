Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:18656 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755427AbcH2SDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 14:03:44 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 10/13] media: platform: pxa_camera: make a standalone v4l2 device
Date: Mon, 29 Aug 2016 19:55:55 +0200
Message-Id: <1472493358-24618-11-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
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
Since v2:
  - split functions
  - start_streaming() implemented
Since v3:
  - conflict in void *alloc_ctxt by struct device *alloc_devs change
  - ctrl_handler for video device added
  - 2 ioctrl disables removed
  - disable sensor module removal, it will be loaded forever ...
Since v4:
 - videobuf2 device initialization moved
---
 drivers/media/platform/soc_camera/Kconfig      |   2 +-
 drivers/media/platform/soc_camera/pxa_camera.c | 753 +++++++++++++++++--------
 include/linux/platform_data/media/camera-pxa.h |   2 +
 3 files changed, 518 insertions(+), 239 deletions(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 3f927f96763a..0bf33ccf9a1e 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -19,7 +19,7 @@ config SOC_CAMERA_PLATFORM
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && SOC_CAMERA && HAS_DMA
+	depends on VIDEO_DEV && PXA27x && HAS_DMA
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
 	---help---
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 8f329d0b2cda..395cd398c32b 100644
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
@@ -169,7 +178,25 @@
 			CICR0_EOFM | CICR0_FOM)
 
 #define sensor_call(cam, o, f, args...) \
-	v4l2_subdev_call(sd, o, f, ##args)
+	v4l2_subdev_call(cam->sensor, o, f, ##args)
+
+/*
+ * Format handling
+ */
+/**
+ * struct soc_camera_format_xlate - match between host and sensor formats
+ * @code: code of a sensor provided format
+ * @host_fmt: host format after host translation from code
+ *
+ * Host and sensor translation structure. Used in table of host and sensor
+ * formats matchings in soc_camera_device. A host can override the generic list
+ * generation by implementing get_formats(), and use it for format checks and
+ * format setup.
+ */
+struct soc_camera_format_xlate {
+	u32 code;
+	const struct soc_mbus_pixelfmt *host_fmt;
+};
 
 /*
  * Structures
@@ -198,7 +225,18 @@ struct pxa_buffer {
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
@@ -218,11 +256,13 @@ struct pxa_camera_dev {
 	unsigned long		ciclk;
 	unsigned long		mclk;
 	u32			mclk_divisor;
+	struct v4l2_clk		*mclk_clk;
 	u16			width_flags;	/* max 10 bits */
 
 	struct list_head	capture;
 
 	spinlock_t		lock;
+	struct mutex		mlock;
 	unsigned int		buf_sequence;
 
 	struct pxa_buffer	*active;
@@ -237,12 +277,69 @@ struct pxa_cam {
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
 
-static struct pxa_camera_dev *icd_to_pcdev(struct soc_camera_device *icd)
+/*
+ * Format translation functions
+ */
+const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
+	struct soc_camera_format_xlate *user_formats, unsigned int fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; user_formats[i].code; i++)
+		if (user_formats[i].host_fmt->fourcc == fourcc)
+			return user_formats + i;
+	return NULL;
+}
+
+static struct soc_camera_format_xlate *soc_mbus_build_fmts_xlate(
+	struct v4l2_device *v4l2_dev, struct v4l2_subdev *subdev,
+	int (*get_formats)(struct v4l2_device *, unsigned int,
+			   struct soc_camera_format_xlate *xlate))
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	unsigned int i, fmts = 0, raw_fmts = 0;
+	int ret;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct soc_camera_format_xlate *user_formats;
+
+	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
+		raw_fmts++;
+		code.index++;
+	}
+
+	/*
+	 * First pass - only count formats this host-sensor
+	 * configuration can provide
+	 */
+	for (i = 0; i < raw_fmts; i++) {
+		ret = get_formats(v4l2_dev, i, NULL);
+		if (ret < 0)
+			return ERR_PTR(ret);
+		fmts += ret;
+	}
+
+	if (!fmts)
+		return ERR_PTR(-ENXIO);
 
-	return pcdev;
+	user_formats = kcalloc(fmts + 1, sizeof(*user_formats), GFP_KERNEL);
+	if (!user_formats)
+		return ERR_PTR(-ENOMEM);
+
+	/* Second pass - actually fill data formats */
+	fmts = 0;
+	for (i = 0; i < raw_fmts; i++) {
+		ret = get_formats(v4l2_dev, i, user_formats + fmts);
+		if (ret < 0)
+			goto egfmt;
+		fmts += ret;
+	}
+	user_formats[fmts].code = 0;
+
+	return user_formats;
+egfmt:
+	kfree(user_formats);
+	return ERR_PTR(ret);
 }
 
 /*
@@ -257,7 +354,12 @@ static struct pxa_buffer *vb2_to_pxa_buffer(struct vb2_buffer *vb)
 
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
@@ -338,7 +440,7 @@ static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
 				    struct pxa_buffer *buf)
 {
 	buf->active_dma = DMA_Y;
-	if (pcdev->channels == 3)
+	if (buf->nb_planes == 3)
 		buf->active_dma |= DMA_U | DMA_V;
 }
 
@@ -671,51 +773,6 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int pxa_camera_add_device(struct soc_camera_device *icd)
-{
-	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
-
-	dev_info(pcdev_to_dev(pcdev), "PXA Camera driver attached to camera %d\n",
-		 icd->devnum);
-
-	return 0;
-}
-
-static void pxa_camera_remove_device(struct soc_camera_device *icd)
-{
-	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
-
-	dev_info(pcdev_to_dev(pcdev), "PXA Camera driver detached from camera %d\n",
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
@@ -741,12 +798,9 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
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
 	int ret = sensor_call(pcdev, sensor, g_skip_top_lines, &y_skip_top);
@@ -758,7 +812,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	 * Datawidth is now guaranteed to be equal to one of the three values.
 	 * We fix bit-per-pixel equal to data-width...
 	 */
-	switch (icd->current_fmt->host_fmt->bits_per_sample) {
+	switch (pcdev->current_fmt->host_fmt->bits_per_sample) {
 	case 10:
 		dw = 4;
 		bpp = 0x40;
@@ -792,7 +846,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	if (cicr0 & CICR0_ENB)
 		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
 
-	cicr1 = CICR1_PPL_VAL(icd->user_width - 1) | bpp | dw;
+	cicr1 = CICR1_PPL_VAL(pcdev->current_pix.width - 1) | bpp | dw;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_YUV422P:
@@ -821,7 +875,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	}
 
 	cicr2 = 0;
-	cicr3 = CICR3_LPF_VAL(icd->user_height - 1) |
+	cicr3 = CICR3_LPF_VAL(pcdev->current_pix.height - 1) |
 		CICR3_BFW_VAL(min((u32)255, y_skip_top));
 	cicr4 |= pcdev->mclk_divisor;
 
@@ -933,13 +987,12 @@ static int pxac_vb2_prepare(struct vb2_buffer *vb)
 {
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	int ret = 0;
 
 	switch (pcdev->channels) {
 	case 1:
 	case 3:
-		vb2_set_plane_payload(vb, 0, icd->sizeimage);
+		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
 		break;
 	default:
 		return -EINVAL;
@@ -949,7 +1002,7 @@ static int pxac_vb2_prepare(struct vb2_buffer *vb)
 		 "%s (vb=%p) nb_channels=%d size=%lu\n",
 		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
 
-	WARN_ON(!icd->current_fmt);
+	WARN_ON(!pcdev->current_fmt);
 
 #ifdef DEBUG
 	/*
@@ -989,8 +1042,7 @@ static int pxac_vb2_queue_setup(struct vb2_queue *vq,
 				struct device *alloc_devs[])
 {
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	int size = icd->sizeimage;
+	int size = pcdev->current_pix.sizeimage;
 
 	dev_dbg(pcdev_to_dev(pcdev),
 		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
@@ -1050,21 +1102,22 @@ static struct vb2_ops pxac_vb2_ops = {
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
 	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	vq->drv_priv = pcdev;
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vq->buf_struct_size = sizeof(struct pxa_buffer);
+	vq->dev = pcdev->v4l2_dev.dev;
 
 	vq->ops = &pxac_vb2_ops;
 	vq->mem_ops = &vb2_dma_sg_memops;
+	vq->lock = &pcdev->mlock;
 
 	ret = vb2_queue_init(vq);
 	dev_dbg(pcdev_to_dev(pcdev),
@@ -1076,18 +1129,15 @@ static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
 /*
  * Video ioctls section
  */
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
@@ -1138,24 +1188,20 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 	cfg.flags = common_flags;
 	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		dev_dbg(pcdev_to_dev(pcdev), "camera s_mbus_config(0x%lx) returned %d\n",
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
@@ -1201,13 +1247,12 @@ static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
-static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int idx,
+static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
+				  unsigned int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
 	int formats = 0, ret;
-	struct pxa_cam *cam;
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 		.index = idx,
@@ -1221,25 +1266,16 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 
 	fmt = soc_mbus_get_fmtdesc(code.code);
 	if (!fmt) {
-		dev_err(pcdev_to_dev(pcdev), "Invalid format code #%u: %d\n", idx, code.code);
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
@@ -1281,10 +1317,22 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
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
@@ -1294,86 +1342,44 @@ static int pxa_camera_check_frame(u32 width, u32 height)
 		(width & 0x01);
 }
 
-static int pxa_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
+					struct v4l2_fmtdesc *f)
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
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-	int ret;
-
-	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
-	if (!xlate) {
-		dev_warn(pcdev_to_dev(pcdev),
-			 "Format %x not found\n", pix->pixelformat);
-		return -EINVAL;
-	}
-
-	/* If PCLK is used to latch data from the sensor, check sense */
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		/* The caller holds a mutex. */
-		icd->sense = &sense;
-
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	mf->field	= pix->field;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_mbus_pixelfmt *format;
+	unsigned int idx;
 
-	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
-
-	if (mf->code != xlate->code)
+	for (idx = 0; pcdev->user_formats[idx].code; idx++);
+	if (f->index >= idx)
 		return -EINVAL;
 
-	icd->sense = NULL;
-
-	if (ret < 0) {
-		dev_warn(pcdev_to_dev(pcdev),
-			 "Failed to configure for format %x\n",
-			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(mf->width, mf->height)) {
-		dev_warn(pcdev_to_dev(pcdev),
-			 "Camera driver produced an unsupported frame %dx%d\n",
-			 mf->width, mf->height);
-		ret = -EINVAL;
-	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
-		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(pcdev_to_dev(pcdev),
-				"pixel clock %lu set by the camera too high!",
-				sense.pixel_clock);
-			return -EIO;
-		}
-		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
-	}
-
-	if (ret < 0)
-		return ret;
+	format = pcdev->user_formats[f->index].host_fmt;
+	f->pixelformat = format->fourcc;
+	return 0;
+}
 
-	pix->width		= mf->width;
-	pix->height		= mf->height;
-	pix->field		= mf->field;
-	pix->colorspace		= mf->colorspace;
-	icd->current_fmt	= xlate;
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
 
-static int pxa_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
+				      struct v4l2_format *f)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct pxa_camera_dev *pcdev = icd_to_pcdev(icd);
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_pad_config pad_cfg;
@@ -1384,7 +1390,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
 	if (!xlate) {
 		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
 		return -EINVAL;
@@ -1400,26 +1406,18 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      &pix->height, 32, 2048, 0,
 			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
-	/* limit to sensor capabilities */
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	/* Only progressive video supported so far */
-	mf->field	= V4L2_FIELD_NONE;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
-
+	v4l2_fill_mbus_format(mf, pix, xlate->code);
 	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf->width;
-	pix->height	= mf->height;
-	pix->colorspace	= mf->colorspace;
+	v4l2_fill_pix_format(pix, mf);
 
+	/* Only progressive video supported so far */
 	switch (mf->field) {
 	case V4L2_FIELD_ANY:
 	case V4L2_FIELD_NONE:
-		pix->field	= V4L2_FIELD_NONE;
+		pix->field = V4L2_FIELD_NONE;
 		break;
 	default:
 		/* TODO: support interlaced at least in pass-through mode */
@@ -1428,20 +1426,74 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	return ret;
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
+	pix->sizeimage = ret;
+	return 0;
 }
 
-static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
+static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
 {
-	struct soc_camera_device *icd = file->private_data;
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	unsigned long flags;
+	int ret, is_busy;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		"s_fmt_vid_cap(pix=%dx%d:%x)\n",
+		pix->width, pix->height, pix->pixelformat);
+
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
+
+	pcdev->current_fmt = xlate;
+	pcdev->current_pix = *pix;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	ret = pxa_camera_set_bus_param(pcdev);
+	return ret;
 }
 
-static int pxa_camera_querycap(struct soc_camera_host *ici,
-			       struct v4l2_capability *cap)
+static int pxac_vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
 {
-	/* cap->name is set by the firendly caller:-> */
+	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
+	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -1449,13 +1501,212 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
+static int pxac_vidioc_enum_input(struct file *file, void *priv,
+				  struct v4l2_input *i)
+{
+	if (i->index > 0)
+		return -EINVAL;
+
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
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&pcdev->mlock);
+	ret = sensor_call(pcdev, core, s_power, 0);
+	mutex_unlock(&pcdev->mlock);
+
+	return ret;
+}
+
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
+	.vidioc_querycap		= pxac_vidioc_querycap,
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
+static struct v4l2_clk_ops pxa_camera_mclk_ops = {
+};
+
+static const struct video_device pxa_camera_videodev_template = {
+	.name = "pxa-camera",
+	.minor = -1,
+	.fops = &pxa_camera_fops,
+	.ioctl_ops = &pxa_camera_ioctl_ops,
+	.release = video_device_release_empty,
+	.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING,
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
+	struct v4l2_pix_format *pix = &pcdev->current_pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
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
+	pcdev->vdev.ctrl_handler = subdev->ctrl_handler;
+	video_set_drvdata(&pcdev->vdev, pcdev);
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
+}
+
 /*
  * Driver probe, remove, suspend and resume operations
  */
 static int pxa_camera_suspend(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
 	int i = 0, ret = 0;
 
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
@@ -1464,8 +1715,7 @@ static int pxa_camera_suspend(struct device *dev)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if (pcdev->soc_host.icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
+	if (pcdev->sensor) {
 		ret = sensor_call(pcdev, core, s_power, 0);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
@@ -1476,8 +1726,7 @@ static int pxa_camera_suspend(struct device *dev)
 
 static int pxa_camera_resume(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(dev);
-	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
 	int i = 0, ret = 0;
 
 	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
@@ -1486,8 +1735,7 @@ static int pxa_camera_resume(struct device *dev)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
-	if (pcdev->soc_host.icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->soc_host.icd);
+	if (pcdev->sensor) {
 		ret = sensor_call(pcdev, core, s_power, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
@@ -1500,27 +1748,12 @@ static int pxa_camera_resume(struct device *dev)
 	return ret;
 }
 
-static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
-	.owner		= THIS_MODULE,
-	.add		= pxa_camera_add_device,
-	.remove		= pxa_camera_remove_device,
-	.clock_start	= pxa_camera_clock_start,
-	.clock_stop	= pxa_camera_clock_stop,
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
@@ -1531,13 +1764,13 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 
 	np = of_graph_get_next_endpoint(np, NULL);
 	if (!np) {
-		dev_err(pcdev_to_dev(pcdev), "could not find endpoint\n");
+		dev_err(dev, "could not find endpoint\n");
 		return -EINVAL;
 	}
 
 	err = v4l2_of_parse_endpoint(np, &ep);
 	if (err) {
-		dev_err(pcdev_to_dev(pcdev), "could not parse endpoint\n");
+		dev_err(dev, "could not parse endpoint\n");
 		goto out;
 	}
 
@@ -1572,6 +1805,15 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
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
 
@@ -1590,6 +1832,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	};
 	dma_cap_mask_t mask;
 	struct pxad_param params;
+	char clk_name[V4L2_CLK_NAME_SIZE];
 	int irq;
 	int err = 0, i;
 
@@ -1612,10 +1855,14 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
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
@@ -1647,6 +1894,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
+	mutex_init(&pcdev->mlock);
 
 	/*
 	 * Request the regions.
@@ -1709,19 +1957,48 @@ static int pxa_camera_probe(struct platform_device *pdev)
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
+
+	err = pxa_camera_init_videobuf2(pcdev);
+	if (err)
+		goto exit_free_v4l2dev;
 
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
@@ -1733,15 +2010,15 @@ exit_free_dma_y:
 
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
 
-	soc_camera_host_unregister(soc_host);
+	v4l2_clk_unregister(pcdev->mclk_clk);
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

