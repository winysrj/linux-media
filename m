Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60673 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751524AbZG2PS1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:18:27 -0400
Date: Wed, 29 Jul 2009 17:18:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>, m-karicheri2@ti.com,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH 3/4] soc-camera: Use video device object for output in host
 drivers
In-Reply-To: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
Message-ID: <Pine.LNX.4.64.0907291658590.4983@axis700.grange>
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx1_camera.c           |   38 ++++++++++--------
 drivers/media/video/mx3_camera.c           |   46 ++++++++++++---------
 drivers/media/video/pxa_camera.c           |   54 ++++++++++++++-----------
 drivers/media/video/sh_mobile_ceu_camera.c |   61 ++++++++++++++-------------
 4 files changed, 110 insertions(+), 89 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index e5439e4..9adc57a 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -135,7 +135,7 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	while (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
 		(*count)--;
 
-	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
 
 	return 0;
 }
@@ -147,7 +147,7 @@ static void free_buffer(struct videobuf_queue *vq, struct mx1_buffer *buf)
 
 	BUG_ON(in_interrupt());
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* This waits until this buffer is out of danger, i.e., until it is no
@@ -165,7 +165,7 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 	int ret;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* Added list head initialization on alloc */
@@ -216,10 +216,11 @@ out:
 static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 {
 	struct videobuf_buffer *vbuf = &pcdev->active->vb;
+	struct device *dev = pcdev->icd->dev.parent;
 	int ret;
 
 	if (unlikely(!pcdev->active)) {
-		dev_err(pcdev->icd->dev.parent, "DMA End IRQ with no active buffer\n");
+		dev_err(dev, "DMA End IRQ with no active buffer\n");
 		return -EFAULT;
 	}
 
@@ -229,7 +230,7 @@ static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 		vbuf->size, pcdev->res->start +
 		CSIRXR, DMA_MODE_READ);
 	if (unlikely(ret))
-		dev_err(pcdev->icd->dev.parent, "Failed to setup DMA sg list\n");
+		dev_err(dev, "Failed to setup DMA sg list\n");
 
 	return ret;
 }
@@ -243,7 +244,7 @@ static void mx1_videobuf_queue(struct videobuf_queue *vq,
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 	unsigned long flags;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -274,22 +275,23 @@ static void mx1_videobuf_release(struct videobuf_queue *vq,
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 #ifdef DEBUG
 	struct soc_camera_device *icd = vq->priv_data;
+	struct device *dev = icd->dev.parent;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	switch (vb->state) {
 	case VIDEOBUF_ACTIVE:
-		dev_dbg(&icd->dev, "%s (active)\n", __func__);
+		dev_dbg(dev, "%s (active)\n", __func__);
 		break;
 	case VIDEOBUF_QUEUED:
-		dev_dbg(&icd->dev, "%s (queued)\n", __func__);
+		dev_dbg(dev, "%s (queued)\n", __func__);
 		break;
 	case VIDEOBUF_PREPARED:
-		dev_dbg(&icd->dev, "%s (prepared)\n", __func__);
+		dev_dbg(dev, "%s (prepared)\n", __func__);
 		break;
 	default:
-		dev_dbg(&icd->dev, "%s (unknown)\n", __func__);
+		dev_dbg(dev, "%s (unknown)\n", __func__);
 		break;
 	}
 #endif
@@ -329,6 +331,7 @@ static void mx1_camera_wakeup(struct mx1_camera_dev *pcdev,
 static void mx1_camera_dma_irq(int channel, void *data)
 {
 	struct mx1_camera_dev *pcdev = data;
+	struct device *dev = pcdev->icd->dev.parent;
 	struct mx1_buffer *buf;
 	struct videobuf_buffer *vb;
 	unsigned long flags;
@@ -338,14 +341,14 @@ static void mx1_camera_dma_irq(int channel, void *data)
 	imx_dma_disable(channel);
 
 	if (unlikely(!pcdev->active)) {
-		dev_err(pcdev->icd->dev.parent, "DMA End IRQ with no active buffer\n");
+		dev_err(dev, "DMA End IRQ with no active buffer\n");
 		goto out;
 	}
 
 	vb = &pcdev->active->vb;
 	buf = container_of(vb, struct mx1_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
-	dev_dbg(pcdev->icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	mx1_camera_wakeup(pcdev, vb, buf);
@@ -385,8 +388,9 @@ static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
 	 * they get a nice Oops */
 	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
 
-	dev_dbg(pcdev->icd->dev.parent, "System clock %lukHz, target freq %dkHz, "
-		"divisor %lu\n", lcdclk / 1000, mclk / 1000, div);
+	dev_dbg(pcdev->icd->dev.parent,
+		"System clock %lukHz, target freq %dkHz, divisor %lu\n",
+		lcdclk / 1000, mclk / 1000, div);
 
 	return div;
 }
@@ -432,7 +436,7 @@ static int mx1_camera_add_device(struct soc_camera_device *icd)
 		goto ebusy;
 	}
 
-	dev_info(&icd->dev, "MX1 Camera driver attached to camera %d\n",
+	dev_info(icd->dev.parent, "MX1 Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	mx1_camera_activate(pcdev);
@@ -458,7 +462,7 @@ static void mx1_camera_remove_device(struct soc_camera_device *icd)
 	/* Stop DMA engine */
 	imx_dma_disable(pcdev->dma_chan);
 
-	dev_info(&icd->dev, "MX1 Camera driver detached from camera %d\n",
+	dev_info(icd->dev.parent, "MX1 Camera driver detached from camera %d\n",
 		 icd->devnum);
 
 	mx1_camera_deactivate(pcdev);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 8d43003..dd3ca7f 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -178,7 +178,7 @@ static void free_buffer(struct videobuf_queue *vq, struct mx3_camera_buffer *buf
 
 	BUG_ON(in_interrupt());
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/*
@@ -373,7 +373,8 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
 
 	cookie = txd->tx_submit(txd);
-	dev_dbg(&icd->dev, "Submitted cookie %d DMA 0x%08x\n", cookie, sg_dma_address(&buf->sg));
+	dev_dbg(icd->dev.parent, "Submitted cookie %d DMA 0x%08x\n",
+		cookie, sg_dma_address(&buf->sg));
 	if (cookie >= 0)
 		return;
 
@@ -401,9 +402,10 @@ static void mx3_videobuf_release(struct videobuf_queue *vq,
 		container_of(vb, struct mx3_camera_buffer, vb);
 	unsigned long flags;
 
-	dev_dbg(&icd->dev, "Release%s DMA 0x%08x (state %d), queue %sempty\n",
+	dev_dbg(icd->dev.parent,
+		"Release%s DMA 0x%08x (state %d), queue %sempty\n",
 		mx3_cam->active == buf ? " active" : "", sg_dma_address(&buf->sg),
-		 vb->state, list_empty(&vb->queue) ? "" : "not ");
+		vb->state, list_empty(&vb->queue) ? "" : "not ");
 	spin_lock_irqsave(&mx3_cam->lock, flags);
 	if ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED) &&
 	    !list_empty(&vb->queue)) {
@@ -483,7 +485,7 @@ static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
 
 	clk_enable(mx3_cam->clk);
 	rate = clk_round_rate(mx3_cam->clk, mx3_cam->mclk);
-	dev_dbg(&icd->dev, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
+	dev_dbg(icd->dev.parent, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
 	if (rate)
 		clk_set_rate(mx3_cam->clk, rate);
 }
@@ -501,7 +503,7 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 
 	mx3_cam->icd = icd;
 
-	dev_info(&icd->dev, "MX3 Camera driver attached to camera %d\n",
+	dev_info(icd->dev.parent, "MX3 Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	return 0;
@@ -525,7 +527,7 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 
 	mx3_cam->icd = NULL;
 
-	dev_info(&icd->dev, "MX3 Camera driver detached from camera %d\n",
+	dev_info(icd->dev.parent, "MX3 Camera driver detached from camera %d\n",
 		 icd->devnum);
 }
 
@@ -602,7 +604,8 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
 
-	dev_dbg(icd->dev.parent, "requested bus width %d bit: %d\n", depth, ret);
+	dev_dbg(icd->dev.parent, "requested bus width %d bit: %d\n",
+		depth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -611,7 +614,8 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 
 	ret = soc_camera_bus_param_compatible(camera_flags, bus_flags);
 	if (ret < 0)
-		dev_warn(&icd->dev, "Flags incompatible: camera %lx, host %lx\n",
+		dev_warn(icd->dev.parent,
+			 "Flags incompatible: camera %lx, host %lx\n",
 			 camera_flags, bus_flags);
 
 	return ret;
@@ -685,7 +689,8 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(icd->dev.parent, "Providing format %s using %s\n",
+			dev_dbg(icd->dev.parent,
+				"Providing format %s using %s\n",
 				mx3_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -697,7 +702,8 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(icd->dev.parent, "Providing format %s using %s\n",
+			dev_dbg(icd->dev.parent,
+				"Providing format %s using %s\n",
 				mx3_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -820,7 +826,8 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pix->pixelformat);
+		dev_warn(icd->dev.parent, "Format %x not found\n",
+			 pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -882,7 +889,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	if (field == V4L2_FIELD_ANY) {
 		pix->field = V4L2_FIELD_NONE;
 	} else if (field != V4L2_FIELD_NONE) {
-		dev_err(&icd->dev, "Field type %d unsupported.\n", field);
+		dev_err(icd->dev.parent, "Field type %d unsupported.\n", field);
 		return -EINVAL;
 	}
 
@@ -921,14 +928,15 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	u32 dw, sens_conf;
 	int ret = test_platform_param(mx3_cam, icd->buswidth, &bus_flags);
 	const struct soc_camera_format_xlate *xlate;
+	struct device *dev = icd->dev.parent;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	dev_dbg(icd->dev.parent, "requested bus width %d bit: %d\n",
+	dev_dbg(dev, "requested bus width %d bit: %d\n",
 		icd->buswidth, ret);
 
 	if (ret < 0)
@@ -937,10 +945,10 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	camera_flags = icd->ops->query_bus_param(icd);
 
 	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
+	dev_dbg(dev, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
 		camera_flags, bus_flags, common_flags);
 	if (!common_flags) {
-		dev_dbg(icd->dev.parent, "no common flags");
+		dev_dbg(dev, "no common flags");
 		return -EINVAL;
 	}
 
@@ -994,7 +1002,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	ret = icd->ops->set_bus_param(icd, common_flags);
 	if (ret < 0) {
-		dev_dbg(icd->dev.parent, "camera set_bus_param(%lx) returned %d\n",
+		dev_dbg(dev, "camera set_bus_param(%lx) returned %d\n",
 			common_flags, ret);
 		return ret;
 	}
@@ -1049,7 +1057,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	csi_reg_write(mx3_cam, sens_conf | dw, CSI_SENS_CONF);
 
-	dev_dbg(icd->dev.parent, "Set SENS_CONF to %x\n", sens_conf | dw);
+	dev_dbg(dev, "Set SENS_CONF to %x\n", sens_conf | dw);
 
 	return 0;
 }
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index fe7b3c8..4cc3ebc 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -244,7 +244,7 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 
-	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
 
 	*size = roundup(icd->rect_current.width * icd->rect_current.height *
 			((icd->current_fmt->depth + 7) >> 3), 8);
@@ -266,7 +266,7 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 
 	BUG_ON(in_interrupt());
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 
 	/* This waits until this buffer is out of danger, i.e., until it is no
@@ -547,7 +547,8 @@ static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
 	active = pcdev->active;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s (channel=%d) ddadr=%08x\n", __func__,
+		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+			"%s (channel=%d) ddadr=%08x\n", __func__,
 			i, active->dmas[i].sg_dma);
 		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
 		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
@@ -559,7 +560,8 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
 	int i;
 
 	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s (channel=%d)\n", __func__, i);
+		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+			"%s (channel=%d)\n", __func__, i);
 		DCSR(pcdev->dma_chans[i]) = 0;
 	}
 }
@@ -627,8 +629,8 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	unsigned long flags;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d active=%p\n", __func__,
-		vb, vb->baddr, vb->bsize, pcdev->active);
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d active=%p\n",
+		__func__, vb, vb->baddr, vb->bsize, pcdev->active);
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
@@ -649,22 +651,23 @@ static void pxa_videobuf_release(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 #ifdef DEBUG
 	struct soc_camera_device *icd = vq->priv_data;
+	struct device *dev = icd->dev.parent;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	switch (vb->state) {
 	case VIDEOBUF_ACTIVE:
-		dev_dbg(&icd->dev, "%s (active)\n", __func__);
+		dev_dbg(dev, "%s (active)\n", __func__);
 		break;
 	case VIDEOBUF_QUEUED:
-		dev_dbg(&icd->dev, "%s (queued)\n", __func__);
+		dev_dbg(dev, "%s (queued)\n", __func__);
 		break;
 	case VIDEOBUF_PREPARED:
-		dev_dbg(&icd->dev, "%s (prepared)\n", __func__);
+		dev_dbg(dev, "%s (prepared)\n", __func__);
 		break;
 	default:
-		dev_dbg(&icd->dev, "%s (unknown)\n", __func__);
+		dev_dbg(dev, "%s (unknown)\n", __func__);
 		break;
 	}
 #endif
@@ -935,7 +938,8 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	struct videobuf_buffer *vb;
 
 	status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Camera interrupt status 0x%lx\n", status);
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		"Camera interrupt status 0x%lx\n", status);
 
 	if (!status)
 		return IRQ_NONE;
@@ -975,7 +979,7 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 
 	pcdev->icd = icd;
 
-	dev_info(&icd->dev, "PXA Camera driver attached to camera %d\n",
+	dev_info(icd->dev.parent, "PXA Camera driver attached to camera %d\n",
 		 icd->devnum);
 
 	return 0;
@@ -989,7 +993,7 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 
 	BUG_ON(icd != pcdev->icd);
 
-	dev_info(&icd->dev, "PXA Camera driver detached from camera %d\n",
+	dev_info(icd->dev.parent, "PXA Camera driver detached from camera %d\n",
 		 icd->devnum);
 
 	/* disable capture, disable interrupts */
@@ -1235,7 +1239,7 @@ static int required_buswidth(const struct soc_camera_data_format *fmt)
 static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->dev.parent;
 	int formats = 0, buswidth, ret;
 
 	buswidth = required_buswidth(icd->formats + idx);
@@ -1255,7 +1259,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->v4l2_dev.dev, "Providing format %s using %s\n",
+			dev_dbg(dev, "Providing format %s using %s\n",
 				pxa_camera_formats[0].name,
 				icd->formats[idx].name);
 		}
@@ -1270,7 +1274,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = buswidth;
 			xlate++;
-			dev_dbg(ici->v4l2_dev.dev, "Providing format %s packed\n",
+			dev_dbg(dev, "Providing format %s packed\n",
 				icd->formats[idx].name);
 		}
 		break;
@@ -1282,7 +1286,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(ici->v4l2_dev.dev,
+			dev_dbg(dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -1297,6 +1301,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	struct v4l2_rect *rect = &a->c;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
+	struct device *dev = icd->dev.parent;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_sense sense = {
 		.master_clock = pcdev->mclk,
@@ -1313,11 +1318,11 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(ici->v4l2_dev.dev, "Failed to crop to %ux%u@%u:%u\n",
+		dev_warn(dev, "Failed to crop to %ux%u@%u:%u\n",
 			 rect->width, rect->height, rect->left, rect->top);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(ici->v4l2_dev.dev,
+			dev_err(dev,
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1333,6 +1338,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
+	struct device *dev = icd->dev.parent;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_data_format *cam_fmt = NULL;
 	const struct soc_camera_format_xlate *xlate = NULL;
@@ -1346,7 +1352,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
-		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pix->pixelformat);
+		dev_warn(dev, "Format %x not found\n", pix->pixelformat);
 		return -EINVAL;
 	}
 
@@ -1362,11 +1368,11 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	icd->sense = NULL;
 
 	if (ret < 0) {
-		dev_warn(ici->v4l2_dev.dev, "Failed to configure for format %x\n",
+		dev_warn(dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
-			dev_err(ici->v4l2_dev.dev,
+			dev_err(dev,
 				"pixel clock %lu set by the camera too high!",
 				sense.pixel_clock);
 			return -EIO;
@@ -1437,7 +1443,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	if (field == V4L2_FIELD_ANY) {
 		pix->field = V4L2_FIELD_NONE;
 	} else if (field != V4L2_FIELD_NONE) {
-		dev_err(&icd->dev, "Field type %d unsupported.\n", field);
+		dev_err(icd->dev.parent, "Field type %d unsupported.\n", field);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 1a5753e..c752adc 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -168,7 +168,7 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 			(*count)--;
 	}
 
-	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
 
 	return 0;
 }
@@ -178,7 +178,7 @@ static void free_buffer(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 
 	if (in_interrupt())
@@ -186,7 +186,7 @@ static void free_buffer(struct videobuf_queue *vq,
 
 	videobuf_waiton(&buf->vb, 0, 0);
 	videobuf_dma_contig_free(vq, &buf->vb);
-	dev_dbg(&icd->dev, "%s freed\n", __func__);
+	dev_dbg(icd->dev.parent, "%s freed\n", __func__);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
@@ -250,7 +250,7 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 
 	buf = container_of(vb, struct sh_mobile_ceu_buffer, vb);
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* Added list head initialization on alloc */
@@ -303,7 +303,7 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	unsigned long flags;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
+	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -395,7 +395,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	dev_info(&icd->dev,
+	dev_info(icd->dev.parent,
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
 
@@ -435,7 +435,7 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 
 	clk_disable(pcdev->clk);
 
-	dev_info(&icd->dev,
+	dev_info(icd->dev.parent,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
 		 icd->devnum);
 
@@ -501,7 +501,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 	left = size_src(rect->left, hscale);
 	top = size_src(rect->top, vscale);
 
-	dev_dbg(&icd->dev, "Left %u * 0x%x = %u, top %u * 0x%x = %u\n",
+	dev_dbg(icd->dev.parent, "Left %u * 0x%x = %u, top %u * 0x%x = %u\n",
 		rect->left, hscale, left, rect->top, vscale, top);
 
 	if (left > cam->camera_rect.left) {
@@ -518,7 +518,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 		top = cam->camera_rect.top;
 	}
 
-	dev_dbg(&icd->dev, "New left %u, top %u, offsets %u:%u\n",
+	dev_dbg(icd->dev.parent, "New left %u, top %u, offsets %u:%u\n",
 		rect->left, rect->top, left_offset, top_offset);
 
 	if (pcdev->image_mode) {
@@ -691,7 +691,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CDOCR, value);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
 
-	dev_dbg(&icd->dev, "S_FMT successful for %c%c%c%c %ux%u@%u:%u\n",
+	dev_dbg(icd->dev.parent, "S_FMT successful for %c%c%c%c %ux%u@%u:%u\n",
 		pixfmt & 0xff, (pixfmt >> 8) & 0xff,
 		(pixfmt >> 16) & 0xff, (pixfmt >> 24) & 0xff,
 		icd->rect_current.width, icd->rect_current.height,
@@ -748,7 +748,6 @@ static const struct soc_camera_data_format sh_mobile_ceu_formats[] = {
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
@@ -798,7 +797,8 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(ici->v4l2_dev.dev, "Providing format %s using %s\n",
+			dev_dbg(icd->dev.parent,
+				"Providing format %s using %s\n",
 				sh_mobile_ceu_formats[k].name,
 				icd->formats[idx].name);
 		}
@@ -811,7 +811,7 @@ add_single_format:
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(ici->v4l2_dev.dev,
+			dev_dbg(icd->dev.parent,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -874,19 +874,21 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	target = *cam_rect;
 
 	capsr = capture_save_reset(pcdev);
-	dev_dbg(&icd->dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
+	dev_dbg(icd->dev.parent, "CAPSR 0x%x, CFLCR 0x%x\n",
+		capsr, pcdev->cflcr);
 
 	/* First attempt - see if the client can deliver a perfect result */
 	ret = v4l2_subdev_call(sd, video, s_crop, &cam_crop);
 	if (!ret && !memcmp(&target, &cam_rect, sizeof(target))) {
-		dev_dbg(&icd->dev, "Camera S_CROP successful for %ux%u@%u:%u\n",
+		dev_dbg(icd->dev.parent,
+			"Camera S_CROP successful for %ux%u@%u:%u\n",
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 		goto ceu_set_rect;
 	}
 
 	/* Try to fix cropping, that camera hasn't managed to do */
-	dev_dbg(&icd->dev, "Fix camera S_CROP %d for %ux%u@%u:%u"
+	dev_dbg(icd->dev.parent, "Fix camera S_CROP %d for %ux%u@%u:%u"
 		" to %ux%u@%u:%u\n",
 		ret, cam_rect->width, cam_rect->height,
 		cam_rect->left, cam_rect->top,
@@ -937,7 +939,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 					    cam_rect->height, cam_max.top);
 
 		ret = v4l2_subdev_call(sd, video, s_crop, &cam_crop);
-		dev_dbg(&icd->dev, "Camera S_CROP %d for %ux%u@%u:%u\n",
+		dev_dbg(icd->dev.parent, "Camera S_CROP %d for %ux%u@%u:%u\n",
 			ret, cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
@@ -955,7 +957,8 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 		 */
 		*cam_rect = cam_max;
 		ret = v4l2_subdev_call(sd, video, s_crop, &cam_crop);
-		dev_dbg(&icd->dev, "Camera S_CROP %d for max %ux%u@%u:%u\n",
+		dev_dbg(icd->dev.parent,
+			"Camera S_CROP %d for max %ux%u@%u:%u\n",
 			ret, cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
@@ -983,7 +986,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	 * last before last close() _user_ rectangle, which can be different
 	 * from camera rectangle.
 	 */
-	dev_dbg(&icd->dev,
+	dev_dbg(icd->dev.parent,
 		"SH S_CROP from %ux%u@%u:%u to %ux%u@%u:%u, scale to %ux%u@%u:%u\n",
 		cam_rect->width, cam_rect->height, cam_rect->left, cam_rect->top,
 		target.width, target.height, target.left, target.top,
@@ -1041,14 +1044,15 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
 	pix->pixelformat = xlate->cam_fmt->fourcc;
 	ret = v4l2_subdev_call(sd, video, s_fmt, f);
 	pix->pixelformat = pixfmt;
-	dev_dbg(&icd->dev, "Camera %d fmt %ux%u, requested %ux%u, max %ux%u\n",
+	dev_dbg(icd->dev.parent,
+		"Camera %d fmt %ux%u, requested %ux%u, max %ux%u\n",
 		ret, pix->width, pix->height, width, height,
 		icd->rect_max.width, icd->rect_max.height);
 	if (ret < 0)
@@ -1088,12 +1092,12 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		pix->pixelformat = xlate->cam_fmt->fourcc;
 		ret = v4l2_subdev_call(sd, video, s_fmt, f);
 		pix->pixelformat = pixfmt;
-		dev_dbg(&icd->dev, "Camera scaled to %ux%u\n",
+		dev_dbg(icd->dev.parent, "Camera scaled to %ux%u\n",
 			pix->width, pix->height);
 		if (ret < 0) {
 			/* This shouldn't happen */
-			dev_err(&icd->dev, "Client failed to set format: %d\n",
-				ret);
+			dev_err(icd->dev.parent,
+				"Client failed to set format: %d\n", ret);
 			return ret;
 		}
 	}
@@ -1109,7 +1113,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	hscale = calc_scale(pix->width, &width);
 	vscale = calc_scale(pix->height, &height);
 
-	dev_dbg(&icd->dev, "W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
+	dev_dbg(icd->dev.parent, "W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
 		pix->width, hscale, width, pix->height, vscale, height);
 
 out:
@@ -1140,7 +1144,6 @@ out:
 static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
@@ -1150,7 +1153,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1196,7 +1199,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			ret = v4l2_subdev_call(sd, video, try_fmt, f);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
-				dev_err(&icd->dev,
+				dev_err(icd->dev.parent,
 					"FIXME: try_fmt() returned %d\n", ret);
 				pix->width = tmp_w;
 				pix->height = tmp_h;
@@ -1265,7 +1268,7 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 
 	videobuf_queue_dma_contig_init(q,
 				       &sh_mobile_ceu_videobuf_ops,
-				       ici->v4l2_dev.dev, &pcdev->lock,
+				       icd->dev.parent, &pcdev->lock,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       pcdev->is_interlaced ?
 				       V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE,
-- 
1.6.2.4

