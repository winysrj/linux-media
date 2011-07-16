Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1GPAON (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 20:14:13 -0400
Date: Sat, 16 Jul 2011 02:14:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 6/6] V4L: soc-camera: remove soc-camera bus and devices on
 it
In-Reply-To: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107160209460.27399@axis700.grange>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that v4l2 subdevices have got their own device objects, having
one more device in soc-camera clients became redundant and confusing.
This patch removes those devices and the soc-camera bus, they used to
reside on.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This one looks pretty big, most of it are just 10-liners. It removes more 
than a 100 lines of code. Tested on sh-mobile, pxa270, i.MX31. Compile 
tested with all soc-camera hosts and clients. Hope it doesn't break too 
many things, if it does, we'll have the whole 3.1-rc timeframe to fix 
them.

 arch/arm/mach-shmobile/board-mackerel.c    |   13 +-
 arch/sh/boards/mach-ap325rxa/setup.c       |   15 +-
 drivers/media/video/atmel-isi.c            |   64 ++++----
 drivers/media/video/mt9m001.c              |   14 +-
 drivers/media/video/mt9m111.c              |   10 +-
 drivers/media/video/mt9t031.c              |    3 +-
 drivers/media/video/mt9t112.c              |   10 +-
 drivers/media/video/mt9v022.c              |   10 +-
 drivers/media/video/mx1_camera.c           |   42 +++---
 drivers/media/video/mx2_camera.c           |   46 +++---
 drivers/media/video/mx3_camera.c           |   56 ++++----
 drivers/media/video/omap1_camera.c         |   52 +++---
 drivers/media/video/ov2640.c               |   13 +--
 drivers/media/video/ov772x.c               |   10 +-
 drivers/media/video/ov9640.c               |   13 +--
 drivers/media/video/ov9740.c               |   13 +--
 drivers/media/video/pxa_camera.c           |   46 +++---
 drivers/media/video/rj54n1cb0c.c           |    7 +-
 drivers/media/video/sh_mobile_ceu_camera.c |   74 +++++-----
 drivers/media/video/soc_camera.c           |  234 ++++++++++------------------
 drivers/media/video/soc_camera_platform.c  |   10 +-
 drivers/media/video/tw9910.c               |   10 +-
 include/media/soc_camera.h                 |   19 +--
 include/media/soc_camera_platform.h        |   15 +-
 24 files changed, 337 insertions(+), 462 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 448ddbe..df412a6 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1039,8 +1039,8 @@ static struct platform_device sh_mmcif_device = {
 };
 
 
-static int mackerel_camera_add(struct soc_camera_link *icl, struct device *dev);
-static void mackerel_camera_del(struct soc_camera_link *icl);
+static int mackerel_camera_add(struct soc_camera_device *icd);
+static void mackerel_camera_del(struct soc_camera_device *icd);
 
 static int camera_set_capture(struct soc_camera_platform_info *info,
 			      int enable)
@@ -1079,16 +1079,15 @@ static void mackerel_camera_release(struct device *dev)
 	soc_camera_platform_release(&camera_device);
 }
 
-static int mackerel_camera_add(struct soc_camera_link *icl,
-			       struct device *dev)
+static int mackerel_camera_add(struct soc_camera_device *icd)
 {
-	return soc_camera_platform_add(icl, dev, &camera_device, &camera_link,
+	return soc_camera_platform_add(icd, &camera_device, &camera_link,
 				       mackerel_camera_release, 0);
 }
 
-static void mackerel_camera_del(struct soc_camera_link *icl)
+static void mackerel_camera_del(struct soc_camera_device *icd)
 {
-	soc_camera_platform_del(icl, camera_device, &camera_link);
+	soc_camera_platform_del(icd, camera_device, &camera_link);
 }
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 969421f..e57b1df 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -332,8 +332,8 @@ static int camera_set_capture(struct soc_camera_platform_info *info,
 	return ret;
 }
 
-static int ap325rxa_camera_add(struct soc_camera_link *icl, struct device *dev);
-static void ap325rxa_camera_del(struct soc_camera_link *icl);
+static int ap325rxa_camera_add(struct soc_camera_device *icd);
+static void ap325rxa_camera_del(struct soc_camera_device *icd);
 
 static struct soc_camera_platform_info camera_info = {
 	.format_name = "UYVY",
@@ -366,24 +366,23 @@ static void ap325rxa_camera_release(struct device *dev)
 	soc_camera_platform_release(&camera_device);
 }
 
-static int ap325rxa_camera_add(struct soc_camera_link *icl,
-			       struct device *dev)
+static int ap325rxa_camera_add(struct soc_camera_device *icd)
 {
-	int ret = soc_camera_platform_add(icl, dev, &camera_device, &camera_link,
+	int ret = soc_camera_platform_add(icd, &camera_device, &camera_link,
 					  ap325rxa_camera_release, 0);
 	if (ret < 0)
 		return ret;
 
 	ret = camera_probe();
 	if (ret < 0)
-		soc_camera_platform_del(icl, camera_device, &camera_link);
+		soc_camera_platform_del(icd, camera_device, &camera_link);
 
 	return ret;
 }
 
-static void ap325rxa_camera_del(struct soc_camera_link *icl)
+static void ap325rxa_camera_del(struct soc_camera_device *icd)
 {
-	soc_camera_platform_del(icl, camera_device, &camera_link);
+	soc_camera_platform_del(icd, camera_device, &camera_link);
 }
 #endif /* CONFIG_I2C */
 
diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 4742c28..7b89f00 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -253,7 +253,7 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 				void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
 	int ret, bytes_per_line;
@@ -261,7 +261,7 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	/* Reset ISI */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
 	if (ret < 0) {
-		dev_err(icd->dev.parent, "Reset ISI timed out\n");
+		dev_err(icd->parent, "Reset ISI timed out\n");
 		return ret;
 	}
 	/* Disable all interrupts */
@@ -288,7 +288,7 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	isi->sequence = 0;
 	isi->active = NULL;
 
-	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
+	dev_dbg(icd->parent, "%s, count=%d, size=%ld\n", __func__,
 		*nbuffers, size);
 
 	return 0;
@@ -308,7 +308,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
 	struct isi_dma_desc *desc;
@@ -321,7 +321,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	size = bytes_per_line * icd->user_height;
 
 	if (vb2_plane_size(vb, 0) < size) {
-		dev_err(icd->dev.parent, "%s data will not fit into plane (%lu < %lu)\n",
+		dev_err(icd->parent, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
@@ -330,7 +330,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	if (!buf->p_dma_desc) {
 		if (list_empty(&isi->dma_desc_head)) {
-			dev_err(icd->dev.parent, "Not enough dma descriptors.\n");
+			dev_err(icd->parent, "Not enough dma descriptors.\n");
 			return -EINVAL;
 		} else {
 			/* Get an available descriptor */
@@ -354,7 +354,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
 
@@ -374,7 +374,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 
 	/* Check if already in a frame */
 	if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
-		dev_err(isi->icd->dev.parent, "Already in frame handling.\n");
+		dev_err(isi->icd->parent, "Already in frame handling.\n");
 		return;
 	}
 
@@ -394,7 +394,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
 	unsigned long flags = 0;
@@ -412,7 +412,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 static int start_streaming(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 
 	u32 sr = 0;
@@ -427,7 +427,7 @@ static int start_streaming(struct vb2_queue *vq)
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_EN);
 	spin_unlock_irq(&isi->lock);
 
-	dev_dbg(icd->dev.parent, "Waiting for SOF\n");
+	dev_dbg(icd->parent, "Waiting for SOF\n");
 	ret = wait_event_interruptible(isi->vsync_wq,
 				       isi->state != ISI_STATE_IDLE);
 	if (ret)
@@ -448,7 +448,7 @@ static int start_streaming(struct vb2_queue *vq)
 static int stop_streaming(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	struct frame_buffer *buf, *node;
 	int ret = 0;
@@ -470,7 +470,7 @@ static int stop_streaming(struct vb2_queue *vq)
 		msleep(1);
 
 	if (time_after(jiffies, timeout)) {
-		dev_err(icd->dev.parent,
+		dev_err(icd->parent,
 			"Timeout waiting for finishing codec request\n");
 		return -ETIMEDOUT;
 	}
@@ -482,7 +482,7 @@ static int stop_streaming(struct vb2_queue *vq)
 	/* Disable ISI and wait for it is done */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
 	if (ret < 0)
-		dev_err(icd->dev.parent, "Disable ISI timed out\n");
+		dev_err(icd->parent, "Disable ISI timed out\n");
 
 	return ret;
 }
@@ -518,7 +518,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 static int isi_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -528,12 +528,12 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n",
+		dev_warn(icd->parent, "Format %x not found\n",
 			 pix->pixelformat);
 		return -EINVAL;
 	}
 
-	dev_dbg(icd->dev.parent, "Plan to set format %dx%d\n",
+	dev_dbg(icd->parent, "Plan to set format %dx%d\n",
 			pix->width, pix->height);
 
 	mf.width	= pix->width;
@@ -559,7 +559,7 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
-	dev_dbg(icd->dev.parent, "Finally set format %dx%d\n",
+	dev_dbg(icd->parent, "Finally set format %dx%d\n",
 		pix->width, pix->height);
 
 	return ret;
@@ -577,7 +577,7 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -609,7 +609,7 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 	case V4L2_FIELD_NONE:
 		break;
 	default:
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+		dev_err(icd->parent, "Field type %d unsupported.\n",
 			mf.field);
 		ret = -EINVAL;
 	}
@@ -670,7 +670,7 @@ static unsigned long make_bus_param(struct atmel_isi *isi)
 static int isi_camera_try_bus_param(struct soc_camera_device *icd,
 				    unsigned char buswidth)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long camera_flags;
 	int ret;
@@ -702,7 +702,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
-		dev_err(icd->dev.parent,
+		dev_err(icd->parent,
 			"Invalid format code #%u: %d\n", idx, code);
 		return 0;
 	}
@@ -710,7 +710,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	/* This also checks support for the requested bits-per-sample */
 	ret = isi_camera_try_bus_param(icd, fmt->bits_per_sample);
 	if (ret < 0) {
-		dev_err(icd->dev.parent,
+		dev_err(icd->parent,
 			"Fail to try the bus parameters.\n");
 		return 0;
 	}
@@ -725,7 +725,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 			xlate->host_fmt	= &isi_camera_formats[0];
 			xlate->code	= code;
 			xlate++;
-			dev_dbg(icd->dev.parent, "Providing format %s using code %d\n",
+			dev_dbg(icd->parent, "Providing format %s using code %d\n",
 				isi_camera_formats[0].name, code);
 		}
 		break;
@@ -733,7 +733,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 		if (!isi_camera_packing_supported(fmt))
 			return 0;
 		if (xlate)
-			dev_dbg(icd->dev.parent,
+			dev_dbg(icd->parent,
 				"Providing format %s in pass-through mode\n",
 				fmt->name);
 	}
@@ -752,7 +752,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 /* Called with .video_lock held */
 static int isi_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
@@ -764,14 +764,14 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 		return ret;
 
 	isi->icd = icd;
-	dev_dbg(icd->dev.parent, "Atmel ISI Camera driver attached to camera %d\n",
+	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
 		 icd->devnum);
 	return 0;
 }
 /* Called with .video_lock held */
 static void isi_camera_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 
 	BUG_ON(icd != isi->icd);
@@ -779,7 +779,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 	clk_disable(isi->pclk);
 	isi->icd = NULL;
 
-	dev_dbg(icd->dev.parent, "Atmel ISI Camera driver detached from camera %d\n",
+	dev_dbg(icd->parent, "Atmel ISI Camera driver detached from camera %d\n",
 		 icd->devnum);
 }
 
@@ -802,7 +802,7 @@ static int isi_camera_querycap(struct soc_camera_host *ici,
 
 static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
 	int ret;
@@ -812,7 +812,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 
 	bus_flags = make_bus_param(isi);
 	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
+	dev_dbg(icd->parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
 		camera_flags, bus_flags, common_flags);
 	if (!common_flags)
 		return -EINVAL;
@@ -844,7 +844,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 
 	ret = icd->ops->set_bus_param(icd, common_flags);
 	if (ret < 0) {
-		dev_dbg(icd->dev.parent, "Camera set_bus_param(%lx) returned %d\n",
+		dev_dbg(icd->parent, "Camera set_bus_param(%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index e2bbd8c..4da9cca 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -603,13 +603,9 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	unsigned long flags;
 	int ret;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
@@ -675,8 +671,8 @@ static void mt9m001_video_remove(struct soc_camera_device *icd)
 {
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	dev_dbg(&icd->dev, "Video removed: %p, %p\n",
-		icd->dev.parent, icd->vdev);
+	dev_dbg(icd->pdev, "Video removed: %p, %p\n",
+		icd->parent, icd->vdev);
 	if (icl->free_bus)
 		icl->free_bus(icl);
 }
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 7962334..cbccc86 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -960,13 +960,9 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	s32 data;
 	int ret;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	mt9m111->autoexposure = 1;
 	mt9m111->autowhitebalance = 1;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 7ce279c..30547cc 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -700,8 +700,7 @@ static int mt9t031_runtime_suspend(struct device *dev)
 static int mt9t031_runtime_resume(struct device *dev)
 {
 	struct video_device *vdev = to_video_device(dev);
-	struct soc_camera_device *icd = container_of(vdev->parent,
-		struct soc_camera_device, dev);
+	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index bffa9ee..d2e0a50 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -1057,13 +1057,9 @@ static int mt9t112_camera_probe(struct soc_camera_device *icd,
 	const char          *devname;
 	int                  chipid;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/*
 	 * check and show chip ID
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index fc76ed1..51b0fcc 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -728,9 +728,9 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	int ret;
 	unsigned long flags;
 
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
@@ -809,8 +809,8 @@ static void mt9v022_video_remove(struct soc_camera_device *icd)
 {
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	dev_dbg(&icd->dev, "Video removed: %p, %p\n",
-		icd->dev.parent, icd->vdev);
+	dev_dbg(icd->pdev, "Video removed: %p, %p\n",
+		icd->parent, icd->vdev);
 	if (icl->free_bus)
 		icl->free_bus(icl);
 }
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index bc0c23a..ba9c2c8 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -142,7 +142,7 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
 		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
 
-	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
 
 	return 0;
 }
@@ -154,7 +154,7 @@ static void free_buffer(struct videobuf_queue *vq, struct mx1_buffer *buf)
 
 	BUG_ON(in_interrupt());
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/*
@@ -179,7 +179,7 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* Added list head initialization on alloc */
@@ -232,7 +232,7 @@ out:
 static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 {
 	struct videobuf_buffer *vbuf = &pcdev->active->vb;
-	struct device *dev = pcdev->icd->dev.parent;
+	struct device *dev = pcdev->icd->parent;
 	int ret;
 
 	if (unlikely(!pcdev->active)) {
@@ -256,11 +256,11 @@ static void mx1_videobuf_queue(struct videobuf_queue *vq,
 						struct videobuf_buffer *vb)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	list_add_tail(&vb->queue, &pcdev->capture);
@@ -287,7 +287,7 @@ static void mx1_videobuf_release(struct videobuf_queue *vq,
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 #ifdef DEBUG
 	struct soc_camera_device *icd = vq->priv_data;
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -343,7 +343,7 @@ static void mx1_camera_wakeup(struct mx1_camera_dev *pcdev,
 static void mx1_camera_dma_irq(int channel, void *data)
 {
 	struct mx1_camera_dev *pcdev = data;
-	struct device *dev = pcdev->icd->dev.parent;
+	struct device *dev = pcdev->icd->parent;
 	struct mx1_buffer *buf;
 	struct videobuf_buffer *vb;
 	unsigned long flags;
@@ -378,10 +378,10 @@ static struct videobuf_queue_ops mx1_videobuf_ops = {
 static void mx1_camera_init_videobuf(struct videobuf_queue *q,
 				     struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 
-	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->dev.parent,
+	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->parent,
 				&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				V4L2_FIELD_NONE,
 				sizeof(struct mx1_buffer), icd, &icd->video_lock);
@@ -401,7 +401,7 @@ static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
 	 */
 	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
 
-	dev_dbg(pcdev->icd->dev.parent,
+	dev_dbg(pcdev->icd->parent,
 		"System clock %lukHz, target freq %dkHz, divisor %lu\n",
 		lcdclk / 1000, mclk / 1000, div);
 
@@ -412,7 +412,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 {
 	unsigned int csicr1 = CSICR1_EN;
 
-	dev_dbg(pcdev->icd->dev.parent, "Activate device\n");
+	dev_dbg(pcdev->icd->parent, "Activate device\n");
 
 	clk_enable(pcdev->clk);
 
@@ -428,7 +428,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 {
-	dev_dbg(pcdev->icd->dev.parent, "Deactivate device\n");
+	dev_dbg(pcdev->icd->parent, "Deactivate device\n");
 
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
@@ -442,7 +442,7 @@ static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
  */
 static int mx1_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 	int ret;
 
@@ -451,7 +451,7 @@ static int mx1_camera_add_device(struct soc_camera_device *icd)
 		goto ebusy;
 	}
 
-	dev_info(icd->dev.parent, "MX1 Camera driver attached to camera %d\n",
+	dev_info(icd->parent, "MX1 Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	mx1_camera_activate(pcdev);
@@ -464,7 +464,7 @@ ebusy:
 
 static void mx1_camera_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 	unsigned int csicr1;
 
@@ -477,7 +477,7 @@ static void mx1_camera_remove_device(struct soc_camera_device *icd)
 	/* Stop DMA engine */
 	imx_dma_disable(pcdev->dma_chan);
 
-	dev_info(icd->dev.parent, "MX1 Camera driver detached from camera %d\n",
+	dev_info(icd->parent, "MX1 Camera driver detached from camera %d\n",
 		 icd->devnum);
 
 	mx1_camera_deactivate(pcdev);
@@ -495,7 +495,7 @@ static int mx1_camera_set_crop(struct soc_camera_device *icd,
 
 static int mx1_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 	unsigned long camera_flags, common_flags;
 	unsigned int csicr1;
@@ -566,14 +566,14 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n",
+		dev_warn(icd->parent, "Format %x not found\n",
 			 pix->pixelformat);
 		return -EINVAL;
 	}
 
 	buswidth = xlate->host_fmt->bits_per_sample;
 	if (buswidth > 8) {
-		dev_warn(icd->dev.parent,
+		dev_warn(icd->parent,
 			 "bits-per-sample %d for format %x unsupported\n",
 			 buswidth, pix->pixelformat);
 		return -EINVAL;
@@ -613,7 +613,7 @@ static int mx1_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n",
+		dev_warn(icd->parent, "Format %x not found\n",
 			 pix->pixelformat);
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 8e073a3..8528533 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -278,7 +278,7 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
  */
 static int mx2_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	int ret;
 	u32 csicr1;
@@ -303,7 +303,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 	pcdev->icd = icd;
 
-	dev_info(icd->dev.parent, "Camera driver attached to camera %d\n",
+	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	return 0;
@@ -311,12 +311,12 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 static void mx2_camera_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 
 	BUG_ON(icd != pcdev->icd);
 
-	dev_info(icd->dev.parent, "Camera driver detached from camera %d\n",
+	dev_info(icd->parent, "Camera driver detached from camera %d\n",
 		 icd->devnum);
 
 	mx2_camera_deactivate(pcdev);
@@ -437,7 +437,7 @@ static int mx2_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 			icd->current_fmt->host_fmt);
 
-	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
 
 	if (bytes_per_line < 0)
 		return bytes_per_line;
@@ -457,7 +457,7 @@ static void free_buffer(struct videobuf_queue *vq, struct mx2_buffer *buf)
 	struct soc_camera_device *icd = vq->priv_data;
 	struct videobuf_buffer *vb = &buf->vb;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/*
@@ -467,7 +467,7 @@ static void free_buffer(struct videobuf_queue *vq, struct mx2_buffer *buf)
 	videobuf_waiton(vq, vb, 0, 0);
 
 	videobuf_dma_contig_free(vq, vb);
-	dev_dbg(&icd->dev, "%s freed\n", __func__);
+	dev_dbg(icd->parent, "%s freed\n", __func__);
 
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
@@ -481,7 +481,7 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
 			icd->current_fmt->host_fmt);
 	int ret = 0;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	if (bytes_per_line < 0)
@@ -533,12 +533,12 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
 	unsigned long flags;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -611,27 +611,27 @@ static void mx2_videobuf_release(struct videobuf_queue *vq,
 				 struct videobuf_buffer *vb)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
 	unsigned long flags;
 
 #ifdef DEBUG
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	switch (vb->state) {
 	case VIDEOBUF_ACTIVE:
-		dev_info(&icd->dev, "%s (active)\n", __func__);
+		dev_info(icd->parent, "%s (active)\n", __func__);
 		break;
 	case VIDEOBUF_QUEUED:
-		dev_info(&icd->dev, "%s (queued)\n", __func__);
+		dev_info(icd->parent, "%s (queued)\n", __func__);
 		break;
 	case VIDEOBUF_PREPARED:
-		dev_info(&icd->dev, "%s (prepared)\n", __func__);
+		dev_info(icd->parent, "%s (prepared)\n", __func__);
 		break;
 	default:
-		dev_info(&icd->dev, "%s (unknown) %d\n", __func__,
+		dev_info(icd->parent, "%s (unknown) %d\n", __func__,
 				vb->state);
 		break;
 	}
@@ -678,7 +678,7 @@ static struct videobuf_queue_ops mx2_videobuf_ops = {
 static void mx2_camera_init_videobuf(struct videobuf_queue *q,
 			      struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 
 	videobuf_queue_dma_contig_init(q, &mx2_videobuf_ops, pcdev->dev,
@@ -719,7 +719,7 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 		int bytesperline)
 {
 	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 
 	writel(pcdev->discard_buffer_dma,
@@ -772,7 +772,7 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
 		__u32 pixfmt)
 {
 	struct soc_camera_host *ici =
-		to_soc_camera_host(icd->dev.parent);
+		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	unsigned long camera_flags, common_flags;
 	int ret = 0;
@@ -891,7 +891,7 @@ static int mx2_camera_set_crop(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
+	dev_dbg(icd->parent, "Sensor cropped %dx%d\n",
 		mf.width, mf.height);
 
 	icd->user_width		= mf.width;
@@ -911,7 +911,7 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n",
+		dev_warn(icd->parent, "Format %x not found\n",
 				pix->pixelformat);
 		return -EINVAL;
 	}
@@ -951,7 +951,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1001,7 +1001,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	if (mf.field == V4L2_FIELD_ANY)
 		mf.field = V4L2_FIELD_NONE;
 	if (mf.field != V4L2_FIELD_NONE) {
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+		dev_err(icd->parent, "Field type %d unsupported.\n",
 				mf.field);
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 69b2d9d..a636799 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -195,7 +195,7 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 			unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
@@ -224,7 +224,7 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 static int mx3_videobuf_prepare(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
 	struct scatterlist *sg;
@@ -242,7 +242,7 @@ static int mx3_videobuf_prepare(struct vb2_buffer *vb)
 	new_size = bytes_per_line * icd->user_height;
 
 	if (vb2_plane_size(vb, 0) < new_size) {
-		dev_err(icd->dev.parent, "Buffer too small (%lu < %zu)\n",
+		dev_err(icd->parent, "Buffer too small (%lu < %zu)\n",
 			vb2_plane_size(vb, 0), new_size);
 		return -ENOBUFS;
 	}
@@ -284,7 +284,7 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 static void mx3_videobuf_queue(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 	struct dma_async_tx_descriptor *txd = buf->txd;
@@ -337,7 +337,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	spin_unlock_irq(&mx3_cam->lock);
 
 	cookie = txd->tx_submit(txd);
-	dev_dbg(icd->dev.parent, "Submitted cookie %d DMA 0x%08x\n",
+	dev_dbg(icd->parent, "Submitted cookie %d DMA 0x%08x\n",
 		cookie, sg_dma_address(&buf->sg));
 
 	if (cookie >= 0)
@@ -358,13 +358,13 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 static void mx3_videobuf_release(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 	struct dma_async_tx_descriptor *txd = buf->txd;
 	unsigned long flags;
 
-	dev_dbg(icd->dev.parent,
+	dev_dbg(icd->parent,
 		"Release%s DMA 0x%08x, queue %sempty\n",
 		mx3_cam->active == buf ? " active" : "", sg_dma_address(&buf->sg),
 		list_empty(&buf->queue) ? "" : "not ");
@@ -403,7 +403,7 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 static int mx3_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
 	struct dma_chan *chan;
@@ -499,7 +499,7 @@ static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
 
 	clk_enable(mx3_cam->clk);
 	rate = clk_round_rate(mx3_cam->clk, mx3_cam->mclk);
-	dev_dbg(icd->dev.parent, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
+	dev_dbg(icd->parent, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
 	if (rate)
 		clk_set_rate(mx3_cam->clk, rate);
 }
@@ -507,7 +507,7 @@ static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
 /* Called with .video_lock held */
 static int mx3_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 
 	if (mx3_cam->icd)
@@ -517,7 +517,7 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 
 	mx3_cam->icd = icd;
 
-	dev_info(icd->dev.parent, "MX3 Camera driver attached to camera %d\n",
+	dev_info(icd->parent, "MX3 Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	return 0;
@@ -526,7 +526,7 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 /* Called with .video_lock held */
 static void mx3_camera_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel **ichan = &mx3_cam->idmac_channel[0];
 
@@ -541,7 +541,7 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 
 	mx3_cam->icd = NULL;
 
-	dev_info(icd->dev.parent, "MX3 Camera driver detached from camera %d\n",
+	dev_info(icd->parent, "MX3 Camera driver detached from camera %d\n",
 		 icd->devnum);
 }
 
@@ -608,12 +608,12 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 				    const unsigned int depth)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
 
-	dev_dbg(icd->dev.parent, "request bus width %d bit: %d\n", depth, ret);
+	dev_dbg(icd->parent, "request bus width %d bit: %d\n", depth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -622,7 +622,7 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 
 	ret = soc_camera_bus_param_compatible(camera_flags, bus_flags);
 	if (ret < 0)
-		dev_warn(icd->dev.parent,
+		dev_warn(icd->parent,
 			 "Flags incompatible: camera %lx, host %lx\n",
 			 camera_flags, bus_flags);
 
@@ -676,7 +676,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 				  struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	int formats = 0, ret;
 	enum v4l2_mbus_pixelcode code;
 	const struct soc_mbus_pixelfmt *fmt;
@@ -688,7 +688,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
-		dev_warn(icd->dev.parent,
+		dev_warn(icd->parent,
 			 "Unsupported format code #%u: %d\n", idx, code);
 		return 0;
 	}
@@ -816,7 +816,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 			       struct v4l2_crop *a)
 {
 	struct v4l2_rect *rect = &a->c;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_mbus_framefmt mf;
@@ -849,7 +849,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 		configure_geometry(mx3_cam, mf.width, mf.height,
 				   icd->current_fmt->host_fmt);
 
-	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
+	dev_dbg(icd->parent, "Sensor cropped %dx%d\n",
 		mf.width, mf.height);
 
 	icd->user_width		= mf.width;
@@ -861,7 +861,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -871,13 +871,13 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n",
+		dev_warn(icd->parent, "Format %x not found\n",
 			 pix->pixelformat);
 		return -EINVAL;
 	}
 
 	stride_align(&pix->width);
-	dev_dbg(icd->dev.parent, "Set format %dx%d\n", pix->width, pix->height);
+	dev_dbg(icd->parent, "Set format %dx%d\n", pix->width, pix->height);
 
 	/*
 	 * Might have to perform a complete interface initialisation like in
@@ -913,7 +913,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
-	dev_dbg(icd->dev.parent, "Sensor set %dx%d\n", pix->width, pix->height);
+	dev_dbg(icd->parent, "Sensor set %dx%d\n", pix->width, pix->height);
 
 	return ret;
 }
@@ -930,7 +930,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -962,7 +962,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	case V4L2_FIELD_NONE:
 		break;
 	default:
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+		dev_err(icd->parent, "Field type %d unsupported.\n",
 			mf.field);
 		ret = -EINVAL;
 	}
@@ -996,7 +996,7 @@ static int mx3_camera_querycap(struct soc_camera_host *ici,
 
 static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
 	u32 dw, sens_conf;
@@ -1004,7 +1004,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	int buswidth;
 	int ret;
 	const struct soc_camera_format_xlate *xlate;
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 
 	fmt = soc_mbus_get_fmtdesc(icd->current_fmt->code);
 	if (!fmt)
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index e7cfc85..571ff84 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -208,7 +208,7 @@ static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	struct soc_camera_device *icd = vq->priv_data;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 			icd->current_fmt->host_fmt);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 
 	if (bytes_per_line < 0)
@@ -222,7 +222,7 @@ static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
 		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
 
-	dev_dbg(icd->dev.parent,
+	dev_dbg(icd->parent,
 			"%s: count=%d, size=%d\n", __func__, *count, *size);
 
 	return 0;
@@ -241,7 +241,7 @@ static void free_buffer(struct videobuf_queue *vq, struct omap1_cam_buf *buf,
 		videobuf_dma_contig_free(vq, vb);
 	} else {
 		struct soc_camera_device *icd = vq->priv_data;
-		struct device *dev = icd->dev.parent;
+		struct device *dev = icd->parent;
 		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
 
 		videobuf_dma_unmap(dev, dma);
@@ -258,7 +258,7 @@ static int omap1_videobuf_prepare(struct videobuf_queue *vq,
 	struct omap1_cam_buf *buf = container_of(vb, struct omap1_cam_buf, vb);
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 			icd->current_fmt->host_fmt);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	int ret;
 
@@ -490,7 +490,7 @@ static void omap1_videobuf_queue(struct videobuf_queue *vq,
 						struct videobuf_buffer *vb)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	struct omap1_cam_buf *buf;
 	u32 mode;
@@ -519,7 +519,7 @@ static void omap1_videobuf_queue(struct videobuf_queue *vq,
 	pcdev->active = buf;
 	pcdev->ready = NULL;
 
-	dev_dbg(icd->dev.parent,
+	dev_dbg(icd->parent,
 		"%s: capture not active, setup FIFO, start DMA\n", __func__);
 	mode = CAM_READ_CACHE(pcdev, MODE) & ~THRESHOLD_MASK;
 	mode |= THRESHOLD_LEVEL(pcdev->vb_mode) << THRESHOLD_SHIFT;
@@ -543,8 +543,8 @@ static void omap1_videobuf_release(struct videobuf_queue *vq,
 	struct omap1_cam_buf *buf =
 			container_of(vb, struct omap1_cam_buf, vb);
 	struct soc_camera_device *icd = vq->priv_data;
-	struct device *dev = icd->dev.parent;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
 
 	switch (vb->state) {
@@ -573,7 +573,7 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 {
 	struct omap1_cam_buf *buf = pcdev->active;
 	struct videobuf_buffer *vb;
-	struct device *dev = pcdev->icd->dev.parent;
+	struct device *dev = pcdev->icd->parent;
 
 	if (WARN_ON(!buf)) {
 		suspend_capture(pcdev);
@@ -799,7 +799,7 @@ out:
 static irqreturn_t cam_isr(int irq, void *data)
 {
 	struct omap1_cam_dev *pcdev = data;
-	struct device *dev = pcdev->icd->dev.parent;
+	struct device *dev = pcdev->icd->parent;
 	struct omap1_cam_buf *buf = pcdev->active;
 	u32 it_status;
 	unsigned long flags;
@@ -909,7 +909,7 @@ static void sensor_reset(struct omap1_cam_dev *pcdev, bool reset)
  */
 static int omap1_cam_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
@@ -952,14 +952,14 @@ static int omap1_cam_add_device(struct soc_camera_device *icd)
 
 	pcdev->icd = icd;
 
-	dev_dbg(icd->dev.parent, "OMAP1 Camera driver attached to camera %d\n",
+	dev_dbg(icd->parent, "OMAP1 Camera driver attached to camera %d\n",
 			icd->devnum);
 	return 0;
 }
 
 static void omap1_cam_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
@@ -985,7 +985,7 @@ static void omap1_cam_remove_device(struct soc_camera_device *icd)
 
 	pcdev->icd = NULL;
 
-	dev_dbg(icd->dev.parent,
+	dev_dbg(icd->parent,
 		"OMAP1 Camera driver detached from camera %d\n", icd->devnum);
 }
 
@@ -1070,7 +1070,7 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 		unsigned int idx, struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	int formats = 0, ret;
 	enum v4l2_mbus_pixelcode code;
 	const struct soc_mbus_pixelfmt *fmt;
@@ -1222,9 +1222,9 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 	struct v4l2_rect *rect = &crop->c;
 	const struct soc_camera_format_xlate *xlate = icd->current_fmt;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
-	struct device *dev = icd->dev.parent;
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
@@ -1270,8 +1270,8 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
-	struct device *dev = icd->dev.parent;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_mbus_framefmt mf;
@@ -1326,7 +1326,7 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %#x not found\n",
+		dev_warn(icd->parent, "Format %#x not found\n",
 			 pix->pixelformat);
 		return -EINVAL;
 	}
@@ -1362,7 +1362,7 @@ static int omap1_cam_mmap_mapper(struct videobuf_queue *q,
 				  struct vm_area_struct *vma)
 {
 	struct soc_camera_device *icd = q->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	int ret;
 
@@ -1377,17 +1377,17 @@ static int omap1_cam_mmap_mapper(struct videobuf_queue *q,
 static void omap1_cam_init_videobuf(struct videobuf_queue *q,
 				     struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 
 	if (!sg_mode)
 		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
-				icd->dev.parent, &pcdev->lock,
+				icd->parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
 	else
 		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
-				icd->dev.parent, &pcdev->lock,
+				icd->parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
 
@@ -1440,9 +1440,9 @@ static int omap1_cam_querycap(struct soc_camera_host *ici,
 static int omap1_cam_set_bus_param(struct soc_camera_device *icd,
 		__u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
-	struct device *dev = icd->dev.parent;
 	const struct soc_camera_format_xlate *xlate;
 	const struct soc_mbus_pixelfmt *fmt;
 	unsigned long camera_flags, common_flags;
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 0cea0cf..9ce2fa0 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -1031,16 +1031,9 @@ static int ov2640_video_probe(struct soc_camera_device *icd,
 	const char *devname;
 	int ret;
 
-	/*
-	 * we must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
-		dev_err(&client->dev, "Parent missing or invalid!\n");
-		ret = -ENODEV;
-		goto err;
-	}
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/*
 	 * check and show product ID and manufacturer ID
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 48895ef..397870f 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -1032,13 +1032,9 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 	u8                  pid, ver;
 	const char         *devname;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/*
 	 * check and show product ID and manufacturer ID
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 5173ac4..3681a6f 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -657,16 +657,9 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 	const char	*devname;
 	int		ret = 0;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
-		dev_err(&client->dev, "Parent missing or invalid!\n");
-		ret = -ENODEV;
-		goto err;
-	}
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/*
 	 * check and show product ID and manufacturer ID
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index ede48f2..edd1ffc 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -898,16 +898,9 @@ static int ov9740_video_probe(struct soc_camera_device *icd,
 	u8 modelhi, modello;
 	int ret;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
-		dev_err(&client->dev, "Parent missing or invalid!\n");
-		ret = -ENODEV;
-		goto err;
-	}
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/*
 	 * check and show product ID and manufacturer ID
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index e0231a2..dd62251 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -247,7 +247,7 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
-	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
 
 	*size = bytes_per_line * icd->user_height;
 
@@ -262,13 +262,13 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int i;
 
 	BUG_ON(in_interrupt());
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 
 	/*
@@ -429,7 +429,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		struct videobuf_buffer *vb, enum v4l2_field field)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
@@ -636,11 +636,11 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d active=%p\n",
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d active=%p\n",
 		__func__, vb, vb->baddr, vb->bsize, pcdev->active);
 
 	list_add_tail(&vb->queue, &pcdev->capture);
@@ -658,7 +658,7 @@ static void pxa_videobuf_release(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 #ifdef DEBUG
 	struct soc_camera_device *icd = vq->priv_data;
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -843,7 +843,7 @@ static struct videobuf_queue_ops pxa_videobuf_ops = {
 static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 			      struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
 	/*
@@ -972,7 +972,7 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
  */
 static int pxa_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
 	if (pcdev->icd)
@@ -982,7 +982,7 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 
 	pcdev->icd = icd;
 
-	dev_info(icd->dev.parent, "PXA Camera driver attached to camera %d\n",
+	dev_info(icd->parent, "PXA Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	return 0;
@@ -991,12 +991,12 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 /* Called with .video_lock held */
 static void pxa_camera_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
 	BUG_ON(icd != pcdev->icd);
 
-	dev_info(icd->dev.parent, "PXA Camera driver detached from camera %d\n",
+	dev_info(icd->parent, "PXA Camera driver detached from camera %d\n",
 		 icd->devnum);
 
 	/* disable capture, disable interrupts */
@@ -1057,7 +1057,7 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 				  unsigned long flags, __u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	unsigned long dw, bpp;
@@ -1152,7 +1152,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 
 static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
 	int ret;
@@ -1210,7 +1210,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 				    unsigned char buswidth)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
@@ -1247,7 +1247,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 				  struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	int formats = 0, ret;
 	struct pxa_cam *cam;
 	enum v4l2_mbus_pixelcode code;
@@ -1335,9 +1335,9 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 			       struct v4l2_crop *a)
 {
 	struct v4l2_rect *rect = &a->c;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	struct device *dev = icd->dev.parent;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_sense sense = {
 		.master_clock = pcdev->mclk,
@@ -1379,7 +1379,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 			return ret;
 
 		if (pxa_camera_check_frame(mf.width, mf.height)) {
-			dev_warn(icd->dev.parent,
+			dev_warn(icd->parent,
 				 "Inconsistent state. Use S_FMT to repair\n");
 			return -EINVAL;
 		}
@@ -1406,9 +1406,9 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	struct device *dev = icd->dev.parent;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate = NULL;
 	struct soc_camera_sense sense = {
@@ -1485,7 +1485,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1522,7 +1522,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		break;
 	default:
 		/* TODO: support interlaced at least in pass-through mode */
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+		dev_err(icd->parent, "Field type %d unsupported.\n",
 			mf.field);
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 57e11b6..847ccc0 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1364,10 +1364,9 @@ static int rj54n1_video_probe(struct soc_camera_device *icd,
 	int data1, data2;
 	int ret;
 
-	/* This could be a BUG_ON() or a WARN_ON(), or remove it completely */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/* Read out the chip version register */
 	data1 = reg_read(client, RJ54N1_DEV_CODE);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 6d574ca..a5367de 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -207,7 +207,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 
 
 	if (2 != success) {
-		dev_warn(&icd->dev, "soft reset time out\n");
+		dev_warn(icd->pdev, "soft reset time out\n");
 		return -EIO;
 	}
 
@@ -222,7 +222,7 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
@@ -244,7 +244,7 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			*count = pcdev->video_limit / PAGE_ALIGN(sizes[0]);
 	}
 
-	dev_dbg(icd->dev.parent, "count=%d, size=%lu\n", *count, sizes[0]);
+	dev_dbg(icd->parent, "count=%d, size=%lu\n", *count, sizes[0]);
 
 	return 0;
 }
@@ -353,7 +353,7 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 
 	buf = to_ceu_vb(vb);
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
 	/* Added list head initialization on alloc */
@@ -373,7 +373,7 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 	size = icd->user_height * bytes_per_line;
 
 	if (vb2_plane_size(vb, 0) < size) {
-		dev_err(icd->dev.parent, "Buffer too small (%lu < %lu)\n",
+		dev_err(icd->parent, "Buffer too small (%lu < %lu)\n",
 			vb2_plane_size(vb, 0), size);
 		return -ENOBUFS;
 	}
@@ -386,11 +386,11 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
+	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
 	spin_lock_irq(&pcdev->lock);
@@ -411,7 +411,7 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
@@ -439,7 +439,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 {
 	struct soc_camera_device *icd = container_of(q, struct soc_camera_device, vb2_vidq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct list_head *buf_head, *tmp;
 
@@ -518,7 +518,7 @@ static struct v4l2_subdev *find_csi2(struct sh_mobile_ceu_dev *pcdev)
 /* Called with .video_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct v4l2_subdev *csi2_sd;
 	int ret;
@@ -526,7 +526,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	dev_info(icd->dev.parent,
+	dev_info(icd->parent,
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
 
@@ -550,7 +550,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 /* Called with .video_lock held */
 static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
 
@@ -572,7 +572,7 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 
 	pm_runtime_put_sync(ici->v4l2_dev.dev);
 
-	dev_info(icd->dev.parent,
+	dev_info(icd->parent,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
 		 icd->devnum);
 
@@ -612,14 +612,14 @@ static u16 calc_scale(unsigned int src, unsigned int *dst)
 /* rect is guaranteed to not exceed the scaled camera rectangle */
 static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	unsigned int height, width, cdwdr_width, in_width, in_height;
 	unsigned int left_offset, top_offset;
 	u32 camor;
 
-	dev_geo(icd->dev.parent, "Crop %ux%u@%u:%u\n",
+	dev_geo(icd->parent, "Crop %ux%u@%u:%u\n",
 		icd->user_width, icd->user_height, cam->ceu_left, cam->ceu_top);
 
 	left_offset	= cam->ceu_left;
@@ -676,7 +676,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	/* Set CAMOR, CAPWR, CFSZR, take care of CDWDR */
 	camor = left_offset | (top_offset << 16);
 
-	dev_geo(icd->dev.parent,
+	dev_geo(icd->parent,
 		"CAMOR 0x%x, CAPWR 0x%x, CFSZR 0x%x, CDWDR 0x%x\n", camor,
 		(in_height << 16) | in_width, (height << 16) | width,
 		cdwdr_width);
@@ -724,7 +724,7 @@ static void capture_restore(struct sh_mobile_ceu_dev *pcdev, u32 capsr)
 static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 				       __u32 pixfmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int ret;
 	unsigned long camera_flags, common_flags, value;
@@ -833,7 +833,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	sh_mobile_ceu_set_rect(icd);
 	mdelay(1);
 
-	dev_geo(icd->dev.parent, "CFLCR 0x%x\n", pcdev->cflcr);
+	dev_geo(icd->parent, "CFLCR 0x%x\n", pcdev->cflcr);
 	ceu_write(pcdev, CFLCR, pcdev->cflcr);
 
 	/*
@@ -856,7 +856,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CDOCR, value);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
 
-	dev_dbg(icd->dev.parent, "S_FMT successful for %c%c%c%c %ux%u\n",
+	dev_dbg(icd->parent, "S_FMT successful for %c%c%c%c %ux%u\n",
 		pixfmt & 0xff, (pixfmt >> 8) & 0xff,
 		(pixfmt >> 16) & 0xff, (pixfmt >> 24) & 0xff,
 		icd->user_width, icd->user_height);
@@ -870,7 +870,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
 				       unsigned char buswidth)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	unsigned long camera_flags, common_flags;
 
@@ -928,7 +928,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 				     struct soc_camera_format_xlate *xlate)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int ret, k, n;
@@ -1271,7 +1271,7 @@ static int client_s_fmt(struct soc_camera_device *icd,
 {
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
 	unsigned int max_width, max_height;
 	struct v4l2_cropcap cap;
@@ -1340,7 +1340,7 @@ static int client_scale(struct soc_camera_device *icd,
 			bool ceu_can_scale)
 {
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	struct v4l2_mbus_framefmt mf_tmp = *mf;
 	unsigned int scale_h, scale_v;
 	int ret;
@@ -1390,13 +1390,13 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 				  struct v4l2_crop *a)
 {
 	struct v4l2_rect *rect = &a->c;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct v4l2_crop cam_crop;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_rect *cam_rect = &cam_crop.c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->dev.parent;
 	struct v4l2_mbus_framefmt mf;
 	unsigned int scale_cam_h, scale_cam_v, scale_ceu_h, scale_ceu_v,
 		out_width, out_height;
@@ -1538,7 +1538,7 @@ static void calculate_client_output(struct soc_camera_device *icd,
 		struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf)
 {
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct device *dev = icd->dev.parent;
+	struct device *dev = icd->parent;
 	struct v4l2_rect *cam_subrect = &cam->subrect;
 	unsigned int scale_v, scale_h;
 
@@ -1582,12 +1582,12 @@ static void calculate_client_output(struct soc_camera_device *icd,
 static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->parent;
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_mbus_framefmt mf;
-	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
 	const struct soc_camera_format_xlate *xlate;
 	/* Keep Compiler Happy */
@@ -1711,12 +1711,12 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	int width, height;
 	int ret;
 
-	dev_geo(icd->dev.parent, "TRY_FMT(pix=0x%x, %ux%u)\n",
+	dev_geo(icd->parent, "TRY_FMT(pix=0x%x, %ux%u)\n",
 		 pixfmt, pix->width, pix->height);
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1763,7 +1763,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 							 try_mbus_fmt, &mf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
-				dev_err(icd->dev.parent,
+				dev_err(icd->parent,
 					"FIXME: client try_fmt() = %d\n", ret);
 				return ret;
 			}
@@ -1775,7 +1775,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			pix->height = height;
 	}
 
-	dev_geo(icd->dev.parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
+	dev_geo(icd->parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
 		__func__, ret, pix->pixelformat, pix->width, pix->height);
 
 	return ret;
@@ -1785,7 +1785,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 				      struct v4l2_crop *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	u32 out_width = icd->user_width, out_height = icd->user_height;
 	int ret;
@@ -1797,13 +1797,13 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 	/* Stop the client */
 	ret = v4l2_subdev_call(sd, video, s_stream, 0);
 	if (ret < 0)
-		dev_warn(icd->dev.parent,
+		dev_warn(icd->parent,
 			 "Client failed to stop the stream: %d\n", ret);
 	else
 		/* Do the crop, if it fails, there's nothing more we can do */
 		sh_mobile_ceu_set_crop(icd, a);
 
-	dev_geo(icd->dev.parent, "Output after crop: %ux%u\n", icd->user_width, icd->user_height);
+	dev_geo(icd->parent, "Output after crop: %ux%u\n", icd->user_width, icd->user_height);
 
 	if (icd->user_width != out_width || icd->user_height != out_height) {
 		struct v4l2_format f = {
@@ -1870,7 +1870,7 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
 				  struct v4l2_control *ctrl)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	u32 val;
 
@@ -1886,7 +1886,7 @@ static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
 static int sh_mobile_ceu_set_ctrl(struct soc_camera_device *icd,
 				  struct v4l2_control *ctrl)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0df31b5..5bdfe7e 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -60,14 +60,14 @@ static int soc_camera_power_set(struct soc_camera_device *icd,
 		ret = regulator_bulk_enable(icl->num_regulators,
 					    icl->regulators);
 		if (ret < 0) {
-			dev_err(&icd->dev, "Cannot enable regulators\n");
+			dev_err(icd->pdev, "Cannot enable regulators\n");
 			return ret;
 		}
 
 		if (icl->power)
 			ret = icl->power(icd->pdev, power_on);
 		if (ret < 0) {
-			dev_err(&icd->dev,
+			dev_err(icd->pdev,
 				"Platform failed to power-on the camera.\n");
 
 			regulator_bulk_disable(icl->num_regulators,
@@ -79,7 +79,7 @@ static int soc_camera_power_set(struct soc_camera_device *icd,
 		if (icl->power)
 			ret = icl->power(icd->pdev, 0);
 		if (ret < 0) {
-			dev_err(&icd->dev,
+			dev_err(icd->pdev,
 				"Platform failed to power-off the camera.\n");
 			return ret;
 		}
@@ -87,7 +87,7 @@ static int soc_camera_power_set(struct soc_camera_device *icd,
 		ret = regulator_bulk_disable(icl->num_regulators,
 					     icl->regulators);
 		if (ret < 0) {
-			dev_err(&icd->dev, "Cannot disable regulators\n");
+			dev_err(icd->pdev, "Cannot disable regulators\n");
 			return ret;
 		}
 	}
@@ -147,11 +147,11 @@ EXPORT_SYMBOL(soc_camera_apply_sensor_flags);
 static int soc_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	dev_dbg(&icd->dev, "TRY_FMT(%c%c%c%c, %ux%u)\n",
+	dev_dbg(icd->pdev, "TRY_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
 	pix->bytesperline = 0;
@@ -237,7 +237,7 @@ static int soc_camera_enum_fsizes(struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	return ici->ops->enum_fsizes(icd, fsize);
 }
@@ -247,7 +247,7 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 {
 	int ret;
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -274,7 +274,7 @@ static int soc_camera_querybuf(struct file *file, void *priv,
 			       struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -288,7 +288,7 @@ static int soc_camera_qbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -305,7 +305,7 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -322,7 +322,7 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	unsigned int i, fmts = 0, raw_fmts = 0;
 	int ret;
 	enum v4l2_mbus_pixelcode code;
@@ -356,7 +356,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	if (!icd->user_formats)
 		return -ENOMEM;
 
-	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
+	dev_dbg(icd->pdev, "Found %d supported formats.\n", fmts);
 
 	/* Second pass - actually fill data formats */
 	fmts = 0;
@@ -388,7 +388,7 @@ egfmt:
 /* Always entered with .video_lock held */
 static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	if (ici->ops->put_formats)
 		ici->ops->put_formats(icd);
@@ -402,11 +402,11 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 static int soc_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	dev_dbg(&icd->dev, "S_FMT(%c%c%c%c, %ux%u)\n",
+	dev_dbg(icd->pdev, "S_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
 	/* We always call try_fmt() before set_fmt() or set_crop() */
@@ -419,7 +419,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 		return ret;
 	} else if (!icd->current_fmt ||
 		   icd->current_fmt->host_fmt->fourcc != pix->pixelformat) {
-		dev_err(&icd->dev,
+		dev_err(icd->pdev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
 	}
@@ -433,7 +433,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	if (ici->ops->init_videobuf)
 		icd->vb_vidq.field = pix->field;
 
-	dev_dbg(&icd->dev, "set width: %d height: %d\n",
+	dev_dbg(icd->pdev, "set width: %d height: %d\n",
 		icd->user_width, icd->user_height);
 
 	/* set physical bus parameters */
@@ -443,9 +443,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct soc_camera_device *icd = container_of(vdev->parent,
-						     struct soc_camera_device,
-						     dev);
+	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct soc_camera_host *ici;
 	int ret;
@@ -454,10 +452,10 @@ static int soc_camera_open(struct file *file)
 		/* No device driver attached */
 		return -ENODEV;
 
-	ici = to_soc_camera_host(icd->dev.parent);
+	ici = to_soc_camera_host(icd->parent);
 
 	if (!try_module_get(ici->ops->owner)) {
-		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
+		dev_err(icd->pdev, "Couldn't lock capture bus driver.\n");
 		return -EINVAL;
 	}
 
@@ -488,7 +486,7 @@ static int soc_camera_open(struct file *file)
 
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
-			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
+			dev_err(icd->pdev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
 		}
 
@@ -517,7 +515,7 @@ static int soc_camera_open(struct file *file)
 	}
 
 	file->private_data = icd;
-	dev_dbg(&icd->dev, "camera device open\n");
+	dev_dbg(icd->pdev, "camera device open\n");
 
 	return 0;
 
@@ -542,7 +540,7 @@ epower:
 static int soc_camera_close(struct file *file)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	icd->use_count--;
 	if (!icd->use_count) {
@@ -563,7 +561,7 @@ static int soc_camera_close(struct file *file)
 
 	module_put(ici->ops->owner);
 
-	dev_dbg(&icd->dev, "camera device close\n");
+	dev_dbg(icd->pdev, "camera device close\n");
 
 	return 0;
 }
@@ -574,7 +572,7 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 	struct soc_camera_device *icd = file->private_data;
 	int err = -EINVAL;
 
-	dev_err(&icd->dev, "camera device read not implemented\n");
+	dev_err(icd->pdev, "camera device read not implemented\n");
 
 	return err;
 }
@@ -582,10 +580,10 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	int err;
 
-	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+	dev_dbg(icd->pdev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
 
 	if (icd->streamer != file)
 		return -EBUSY;
@@ -595,7 +593,7 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 	else
 		err = vb2_mmap(&icd->vb2_vidq, vma);
 
-	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
+	dev_dbg(icd->pdev, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
 		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
 		err);
@@ -606,13 +604,13 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	if (icd->streamer != file)
 		return -EBUSY;
 
 	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream)) {
-		dev_err(&icd->dev, "Trying to poll with no queued buffers!\n");
+		dev_err(icd->pdev, "Trying to poll with no queued buffers!\n");
 		return POLLERR;
 	}
 
@@ -652,15 +650,15 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	WARN_ON(priv != file->private_data);
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_warn(&icd->dev, "Wrong buf-type %d\n", f->type);
+		dev_warn(icd->pdev, "Wrong buf-type %d\n", f->type);
 		return -EINVAL;
 	}
 
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	if (is_streaming(to_soc_camera_host(icd->dev.parent), icd)) {
-		dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
+	if (is_streaming(to_soc_camera_host(icd->parent), icd)) {
+		dev_err(icd->pdev, "S_FMT denied: queue initialised\n");
 		return -EBUSY;
 	}
 
@@ -709,7 +707,7 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	pix->field		= icd->field;
 	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
 	pix->colorspace		= icd->colorspace;
-	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
+	dev_dbg(icd->pdev, "current_fmt->fourcc: 0x%08x\n",
 		icd->current_fmt->host_fmt->fourcc);
 	return 0;
 }
@@ -718,7 +716,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 			       struct v4l2_capability *cap)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -730,7 +728,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 			       enum v4l2_buf_type i)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
 
@@ -759,7 +757,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 {
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -787,7 +785,7 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qc)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	int i;
 
 	WARN_ON(priv != file->private_data);
@@ -818,7 +816,7 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 			     struct v4l2_control *ctrl)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
 
@@ -837,7 +835,7 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
 			     struct v4l2_control *ctrl)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
 
@@ -856,7 +854,7 @@ static int soc_camera_cropcap(struct file *file, void *fh,
 			      struct v4l2_cropcap *a)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	return ici->ops->cropcap(icd, a);
 }
@@ -865,7 +863,7 @@ static int soc_camera_g_crop(struct file *file, void *fh,
 			     struct v4l2_crop *a)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	int ret;
 
 	ret = ici->ops->get_crop(icd, a);
@@ -882,7 +880,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 			     struct v4l2_crop *a)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_rect *rect = &a->c;
 	struct v4l2_crop current_crop;
 	int ret;
@@ -890,7 +888,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	dev_dbg(&icd->dev, "S_CROP(%ux%u@%u:%u)\n",
+	dev_dbg(icd->pdev, "S_CROP(%ux%u@%u:%u)\n",
 		rect->width, rect->height, rect->left, rect->top);
 
 	/* If get_crop fails, we'll let host and / or client drivers decide */
@@ -898,7 +896,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 
 	/* Prohibit window size change with initialised buffers */
 	if (ret < 0) {
-		dev_err(&icd->dev,
+		dev_err(icd->pdev,
 			"S_CROP denied: getting current crop failed\n");
 	} else if ((a->c.width == current_crop.c.width &&
 		    a->c.height == current_crop.c.height) ||
@@ -908,7 +906,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	} else if (ici->ops->set_livecrop) {
 		ret = ici->ops->set_livecrop(icd, a);
 	} else {
-		dev_err(&icd->dev,
+		dev_err(icd->pdev,
 			"S_CROP denied: queue initialised and sizes differ\n");
 		ret = -EBUSY;
 	}
@@ -920,7 +918,7 @@ static int soc_camera_g_parm(struct file *file, void *fh,
 			     struct v4l2_streamparm *a)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	if (ici->ops->get_parm)
 		return ici->ops->get_parm(icd, a);
@@ -932,7 +930,7 @@ static int soc_camera_s_parm(struct file *file, void *fh,
 			     struct v4l2_streamparm *a)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	if (ici->ops->set_parm)
 		return ici->ops->set_parm(icd, a);
@@ -969,6 +967,8 @@ static int soc_camera_s_register(struct file *file, void *fh,
 }
 #endif
 
+static int soc_camera_probe(struct soc_camera_device *icd);
+
 /* So far this function cannot fail */
 static void scan_add_host(struct soc_camera_host *ici)
 {
@@ -979,15 +979,9 @@ static void scan_add_host(struct soc_camera_host *ici)
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
 			int ret;
-			icd->dev.parent = ici->v4l2_dev.dev;
-			dev_set_name(&icd->dev, "%u-%u", icd->iface,
-				     icd->devnum);
-			ret = device_register(&icd->dev);
-			if (ret < 0) {
-				icd->dev.parent = NULL;
-				dev_err(&icd->dev,
-					"Cannot register device: %d\n", ret);
-			}
+
+			icd->parent = ici->v4l2_dev.dev;
+			ret = soc_camera_probe(icd);
 		}
 	}
 
@@ -999,12 +993,12 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 			       struct soc_camera_link *icl)
 {
 	struct i2c_client *client;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
 	struct v4l2_subdev *subdev;
 
 	if (!adap) {
-		dev_err(&icd->dev, "Cannot get I2C adapter #%d. No driver?\n",
+		dev_err(icd->pdev, "Cannot get I2C adapter #%d. No driver?\n",
 			icl->i2c_adapter_id);
 		goto ei2cga;
 	}
@@ -1019,7 +1013,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	client = v4l2_get_subdevdata(subdev);
 
 	/* Use to_i2c_client(dev) to recover the i2c client */
-	dev_set_drvdata(&icd->dev, &client->dev);
+	icd->control = &client->dev;
 
 	return 0;
 ei2cnd:
@@ -1033,7 +1027,8 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 	struct i2c_client *client =
 		to_i2c_client(to_soc_camera_control(icd));
 	struct i2c_adapter *adap = client->adapter;
-	dev_set_drvdata(&icd->dev, NULL);
+
+	icd->control = NULL;
 	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
 	i2c_unregister_device(client);
 	i2c_put_adapter(adap);
@@ -1046,17 +1041,16 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 static int soc_camera_video_start(struct soc_camera_device *icd);
 static int video_dev_create(struct soc_camera_device *icd);
 /* Called during host-driver probe */
-static int soc_camera_probe(struct device *dev)
+static int soc_camera_probe(struct soc_camera_device *icd)
 {
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici = to_soc_camera_host(dev->parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct device *control = NULL;
 	struct v4l2_subdev *sd;
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
-	dev_info(dev, "Probing %s\n", dev_name(dev));
+	dev_info(icd->pdev, "Probing %s\n", dev_name(icd->pdev));
 
 	ret = regulator_bulk_get(icd->pdev, icl->num_regulators,
 				 icl->regulators);
@@ -1092,7 +1086,7 @@ static int soc_camera_probe(struct device *dev)
 		if (icl->module_name)
 			ret = request_module(icl->module_name);
 
-		ret = icl->add_device(icl, &icd->dev);
+		ret = icl->add_device(icd);
 		if (ret < 0)
 			goto eadddev;
 
@@ -1103,7 +1097,7 @@ static int soc_camera_probe(struct device *dev)
 		control = to_soc_camera_control(icd);
 		if (!control || !control->driver || !dev_get_drvdata(control) ||
 		    !try_module_get(control->driver->owner)) {
-			icl->del_device(icl);
+			icl->del_device(icd);
 			goto enodrv;
 		}
 	}
@@ -1137,11 +1131,6 @@ static int soc_camera_probe(struct device *dev)
 		icd->field		= mf.field;
 	}
 
-	/* Do we have to sysfs_remove_link() before device_unregister()? */
-	if (sysfs_create_link(&icd->dev.kobj, &to_soc_camera_control(icd)->kobj,
-			      "control"))
-		dev_warn(&icd->dev, "Failed creating the control symlink\n");
-
 	ici->ops->remove(icd);
 
 	soc_camera_power_set(icd, icl, 0);
@@ -1157,7 +1146,7 @@ eiufmt:
 	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
-		icl->del_device(icl);
+		icl->del_device(icd);
 		module_put(control->driver->owner);
 	}
 enodrv:
@@ -1177,13 +1166,12 @@ ereg:
  * This is called on device_unregister, which only means we have to disconnect
  * from the host, but not remove ourselves from the device list
  */
-static int soc_camera_remove(struct device *dev)
+static int soc_camera_remove(struct soc_camera_device *icd)
 {
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct video_device *vdev = icd->vdev;
 
-	BUG_ON(!dev->parent);
+	BUG_ON(!icd->parent);
 
 	if (vdev) {
 		video_unregister_device(vdev);
@@ -1193,10 +1181,9 @@ static int soc_camera_remove(struct device *dev)
 	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
-		struct device_driver *drv = to_soc_camera_control(icd) ?
-			to_soc_camera_control(icd)->driver : NULL;
+		struct device_driver *drv = to_soc_camera_control(icd)->driver;
 		if (drv) {
-			icl->del_device(icl);
+			icl->del_device(icd);
 			module_put(drv->owner);
 		}
 	}
@@ -1207,22 +1194,6 @@ static int soc_camera_remove(struct device *dev)
 	return 0;
 }
 
-static struct bus_type soc_camera_bus_type = {
-	.name		= "soc-camera",
-	.probe		= soc_camera_probe,
-	.remove		= soc_camera_remove,
-};
-
-static struct device_driver ic_drv = {
-	.name	= "camera",
-	.bus	= &soc_camera_bus_type,
-	.owner	= THIS_MODULE,
-};
-
-static void dummy_release(struct device *dev)
-{
-}
-
 static int default_cropcap(struct soc_camera_device *icd,
 			   struct v4l2_cropcap *a)
 {
@@ -1281,13 +1252,6 @@ static int default_enum_fsizes(struct soc_camera_device *icd,
 	return 0;
 }
 
-static void soc_camera_device_init(struct device *dev, void *pdata)
-{
-	dev->platform_data	= pdata;
-	dev->bus		= &soc_camera_bus_type;
-	dev->release		= dummy_release;
-}
-
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	struct soc_camera_host *ix;
@@ -1353,24 +1317,9 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 	mutex_lock(&list_lock);
 
 	list_del(&ici->list);
-
-	list_for_each_entry(icd, &devices, list) {
-		if (icd->iface == ici->nr) {
-			void *pdata = icd->dev.platform_data;
-			/* The bus->remove will be called */
-			device_unregister(&icd->dev);
-			/*
-			 * Not before device_unregister(), .remove
-			 * needs parent to call ici->ops->remove().
-			 * If the host module is loaded again, device_register()
-			 * would complain "already initialised," since 2.6.32
-			 * this is also needed to prevent use-after-free of the
-			 * device private data.
-			 */
-			memset(&icd->dev, 0, sizeof(icd->dev));
-			soc_camera_device_init(&icd->dev, pdata);
-		}
-	}
+	list_for_each_entry(icd, &devices, list)
+		if (icd->iface == ici->nr && to_soc_camera_control(icd))
+			soc_camera_remove(icd);
 
 	mutex_unlock(&list_lock);
 
@@ -1412,11 +1361,6 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 	return 0;
 }
 
-static void soc_camera_device_unregister(struct soc_camera_device *icd)
-{
-	list_del(&icd->list);
-}
-
 static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_querycap	 = soc_camera_querycap,
 	.vidioc_g_fmt_vid_cap    = soc_camera_g_fmt_vid_cap,
@@ -1451,7 +1395,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 
 static int video_dev_create(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct video_device *vdev = video_device_alloc();
 
 	if (!vdev)
@@ -1459,7 +1403,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
-	vdev->parent		= &icd->dev;
+	vdev->parent		= icd->pdev;
 	vdev->current_norm	= V4L2_STD_UNKNOWN;
 	vdev->fops		= &soc_camera_fops;
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
@@ -1480,7 +1424,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 	const struct device_type *type = icd->vdev->dev.type;
 	int ret;
 
-	if (!icd->dev.parent)
+	if (!icd->parent)
 		return -ENODEV;
 
 	if (!icd->ops ||
@@ -1490,7 +1434,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 
 	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
-		dev_err(&icd->dev, "video_register_device failed: %d\n", ret);
+		dev_err(icd->pdev, "video_register_device failed: %d\n", ret);
 		return ret;
 	}
 
@@ -1514,6 +1458,7 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	icd->iface = icl->bus_id;
+	icd->link = icl;
 	icd->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, icd);
 
@@ -1521,8 +1466,6 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto escdevreg;
 
-	soc_camera_device_init(&icd->dev, icl);
-
 	icd->user_width		= DEFAULT_WIDTH;
 	icd->user_height	= DEFAULT_HEIGHT;
 
@@ -1546,7 +1489,7 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 	if (!icd)
 		return -EINVAL;
 
-	soc_camera_device_unregister(icd);
+	list_del(&icd->list);
 
 	kfree(icd);
 
@@ -1563,31 +1506,12 @@ static struct platform_driver __refdata soc_camera_pdrv = {
 
 static int __init soc_camera_init(void)
 {
-	int ret = bus_register(&soc_camera_bus_type);
-	if (ret)
-		return ret;
-	ret = driver_register(&ic_drv);
-	if (ret)
-		goto edrvr;
-
-	ret = platform_driver_probe(&soc_camera_pdrv, soc_camera_pdrv_probe);
-	if (ret)
-		goto epdr;
-
-	return 0;
-
-epdr:
-	driver_unregister(&ic_drv);
-edrvr:
-	bus_unregister(&soc_camera_bus_type);
-	return ret;
+	return platform_driver_probe(&soc_camera_pdrv, soc_camera_pdrv_probe);
 }
 
 static void __exit soc_camera_exit(void)
 {
 	platform_driver_unregister(&soc_camera_pdrv);
-	driver_unregister(&ic_drv);
-	bus_unregister(&soc_camera_bus_type);
 }
 
 module_init(soc_camera_init);
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index bf406e8..8069cd6 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -146,7 +146,7 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	if (!p)
 		return -EINVAL;
 
-	if (!p->dev) {
+	if (!p->icd) {
 		dev_err(&pdev->dev,
 			"Platform has not set soc_camera_device pointer!\n");
 		return -EINVAL;
@@ -156,16 +156,16 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	icd = to_soc_camera_dev(p->dev);
+	icd = p->icd;
 
 	/* soc-camera convention: control's drvdata points to the subdev */
 	platform_set_drvdata(pdev, &priv->subdev);
 	/* Set the control device reference */
-	dev_set_drvdata(&icd->dev, &pdev->dev);
+	icd->control = &pdev->dev;
 
 	icd->ops = &soc_camera_platform_ops;
 
-	ici = to_soc_camera_host(icd->dev.parent);
+	ici = to_soc_camera_host(icd->parent);
 
 	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, p);
@@ -188,7 +188,7 @@ static int soc_camera_platform_remove(struct platform_device *pdev)
 {
 	struct soc_camera_platform_priv *priv = get_priv(pdev);
 	struct soc_camera_platform_info *p = pdev->dev.platform_data;
-	struct soc_camera_device *icd = to_soc_camera_dev(p->dev);
+	struct soc_camera_device *icd = p->icd;
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	icd->ops = NULL;
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index a722f66..742482e 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -836,13 +836,9 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	struct tw9910_priv *priv = to_tw9910(client);
 	s32 id;
 
-	/*
-	 * We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant.
-	 */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
+	/* We must have a parent by now. And it cannot be a wrong one. */
+	BUG_ON(!icd->parent ||
+	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index c31d55b..7582952 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -21,11 +21,14 @@
 #include <media/v4l2-device.h>
 
 struct file;
+struct soc_camera_link;
 
 struct soc_camera_device {
 	struct list_head list;		/* list of all registered devices */
-	struct device dev;
+	struct soc_camera_link *link;
 	struct device *pdev;		/* Platform device */
+	struct device *parent;		/* Camera host device */
+	struct device *control;		/* E.g., the i2c client */
 	s32 user_width;
 	s32 user_height;
 	u32 bytesperline;		/* for padding, zero if unused */
@@ -127,8 +130,8 @@ struct soc_camera_link {
 	 * For non-I2C devices platform has to provide methods to add a device
 	 * to the system and to remove it
 	 */
-	int (*add_device)(struct soc_camera_link *, struct device *);
-	void (*del_device)(struct soc_camera_link *);
+	int (*add_device)(struct soc_camera_device *);
+	void (*del_device)(struct soc_camera_device *);
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -142,12 +145,6 @@ struct soc_camera_link {
 	void (*free_bus)(struct soc_camera_link *);
 };
 
-static inline struct soc_camera_device *to_soc_camera_dev(
-	const struct device *dev)
-{
-	return container_of(dev, struct soc_camera_device, dev);
-}
-
 static inline struct soc_camera_host *to_soc_camera_host(
 	const struct device *dev)
 {
@@ -159,13 +156,13 @@ static inline struct soc_camera_host *to_soc_camera_host(
 static inline struct soc_camera_link *to_soc_camera_link(
 	const struct soc_camera_device *icd)
 {
-	return icd->dev.platform_data;
+	return icd->link;
 }
 
 static inline struct device *to_soc_camera_control(
 	const struct soc_camera_device *icd)
 {
-	return dev_get_drvdata(&icd->dev);
+	return icd->control;
 }
 
 static inline struct v4l2_subdev *soc_camera_to_subdev(
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 6d7a4fd..74f0fa1 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -21,7 +21,7 @@ struct soc_camera_platform_info {
 	unsigned long format_depth;
 	struct v4l2_mbus_framefmt format;
 	unsigned long bus_param;
-	struct device *dev;
+	struct soc_camera_device *icd;
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 };
 
@@ -30,8 +30,7 @@ static inline void soc_camera_platform_release(struct platform_device **pdev)
 	*pdev = NULL;
 }
 
-static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
-					  struct device *dev,
+static inline int soc_camera_platform_add(struct soc_camera_device *icd,
 					  struct platform_device **pdev,
 					  struct soc_camera_link *plink,
 					  void (*release)(struct device *dev),
@@ -40,7 +39,7 @@ static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
 	struct soc_camera_platform_info *info = plink->priv;
 	int ret;
 
-	if (icl != plink)
+	if (icd->link != plink)
 		return -ENODEV;
 
 	if (*pdev)
@@ -50,7 +49,7 @@ static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
 	if (!*pdev)
 		return -ENOMEM;
 
-	info->dev = dev;
+	info->icd = icd;
 
 	(*pdev)->dev.platform_data = info;
 	(*pdev)->dev.release = release;
@@ -59,17 +58,17 @@ static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
 	if (ret < 0) {
 		platform_device_put(*pdev);
 		*pdev = NULL;
-		info->dev = NULL;
+		info->icd = NULL;
 	}
 
 	return ret;
 }
 
-static inline void soc_camera_platform_del(const struct soc_camera_link *icl,
+static inline void soc_camera_platform_del(const struct soc_camera_device *icd,
 					   struct platform_device *pdev,
 					   const struct soc_camera_link *plink)
 {
-	if (icl != plink || !pdev)
+	if (icd->link != plink || !pdev)
 		return;
 
 	platform_device_unregister(pdev);
-- 
1.7.2.5

