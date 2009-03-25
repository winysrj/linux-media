Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33753 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbZCYJRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 05:17:38 -0400
Received: by fxm2 with SMTP id 2so2646019fxm.37
        for <linux-media@vger.kernel.org>; Wed, 25 Mar 2009 02:17:34 -0700 (PDT)
Message-ID: <49C9F62C.3000801@gmail.com>
Date: Wed, 25 Mar 2009 11:15:24 +0200
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: linux-arm-kernel@lists.arm.linux.org.uk
CC: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org
Subject: [PATCH V2 5/9] New drivers for MXC: add CSI support for MX1
Content-Type: multipart/mixed;
 boundary="------------010205040007040702080000"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010205040007040702080000
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit






--------------010205040007040702080000
Content-Type: text/plain;
 name="patch-csi-imx"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-csi-imx"

From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Driver for i.MX1/L camera (CSI) host.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

Index: linux-2.6.29/drivers/media/video/imx_camera.c
===================================================================
--- /dev/null
+++ linux-2.6.29/drivers/media/video/imx_camera.c
@@ -0,0 +1,872 @@
+/*
+ * V4L2 Driver for i.MX camera (CSI) host
+ *
+ * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ *
+ * Based on PXA SoC camera driver
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/time.h>
+#include <linux/version.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf-dma-contig.h>
+#include <media/soc_camera.h>
+
+#include <linux/videodev2.h>
+
+#include <asm/dma.h>
+#include <asm/fiq.h>
+#include <mach/hardware.h>
+#include <mach/dma-mx1-mx2.h>
+#include <mach/camera.h>
+
+/*
+ * CSI registers
+ */
+
+#define DMA_DIMR	0x08	/* Interrupt mask Register */
+#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
+
+#define CSICR1		0x00	/* CSI Control Register 1 */
+#define CSISR		0x08	/* CSI Status Register */
+#define CSIRXR		0x10	/* CSI RxFIFO Register */
+
+#define CSICR1_RXFF_LEVEL(x)	(((x) & 0x3) << 19)
+#define CSICR1_SOF_POL		(1 << 17)
+#define CSICR1_SOF_INTEN	(1 << 16)
+#define CSICR1_MCLKDIV(x)	(((x) & 0xf) << 12)
+#define CSICR1_MCLKEN		(1 << 9)
+#define CSICR1_FCC		(1 << 8)
+#define CSICR1_BIG_ENDIAN	(1 << 7)
+#define CSICR1_CLR_RXFIFO	(1 << 5)
+#define CSICR1_GCLK_MODE	(1 << 4)
+#define CSICR1_REDGE		(1 << 1)
+#define CSICR1_EN		(1 << 0)
+
+#define CSISR_SFF_OR_INT	(1 << 25)
+#define CSISR_RFF_OR_INT	(1 << 24)
+#define CSISR_STATFF_INT	(1 << 21)
+#define CSISR_RXFF_INT		(1 << 18)
+#define CSISR_SOF_INT		(1 << 16)
+#define CSISR_DRDY		(1 << 0)
+
+#define VERSION_CODE KERNEL_VERSION(0, 0, 1)
+#define DRIVER_NAME "imx-csi"
+
+#define CSI_IRQ_MASK (CSISR_SFF_OR_INT | CSISR_RFF_OR_INT | CSISR_STATFF_INT | \
+		      CSISR_RXFF_INT | CSISR_SOF_INT)
+
+#define CSI_BUS_FLAGS (SOCAM_MASTER | SOCAM_HSYNC_ACTIVE_HIGH | \
+		       SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW | \
+		       SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING | \
+		       SOCAM_DATAWIDTH_8)
+
+static DEFINE_MUTEX(camera_lock);
+
+static int mclk;
+
+/*
+ * Structures
+ */
+
+/* buffer for one video frame */
+struct imx_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer vb;
+
+	const struct soc_camera_data_format        *fmt;
+
+	int			inwork;
+};
+
+struct imx_camera_dev {
+	struct device		*dev;
+	/* i.MX is only supposed to handle one camera on its Camera Sensor
+	 * Interface. If anyone ever builds hardware to enable more than
+	 * one camera, they will have to modify this driver too */
+	struct soc_camera_device *icd;
+
+	unsigned int		irq;
+	void __iomem		*base;
+
+	int			dma_chan;
+
+	struct imxcamera_platform_data *pdata;
+	struct resource		*res;
+	struct clk		*clk;
+	unsigned long		platform_mclk_10khz;
+
+	struct list_head	capture;
+
+	spinlock_t		lock;
+
+	struct imx_buffer	*active;
+};
+
+static const char *imx_cam_driver_description = "i.MX_Camera";
+
+/*
+ *  Videobuf operations
+ */
+static int imx_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
+			      unsigned int *size)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+
+	*size = icd->width * icd->height *
+		((icd->current_fmt->depth + 7) >> 3);
+
+	if (0 == *count)
+		*count = 32;
+
+	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct imx_buffer *buf)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+
+	BUG_ON(in_interrupt());
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		&buf->vb, buf->vb.baddr, buf->vb.bsize);
+
+	/* This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE */
+	videobuf_waiton(&buf->vb, 0, 0);
+	videobuf_dma_contig_free(vq, &buf->vb);
+
+	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int imx_videobuf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct imx_buffer *buf = container_of(vb, struct imx_buffer, vb);
+	int ret;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	/* Added list head initialization on alloc */
+	WARN_ON(!list_empty(&vb->queue));
+
+	BUG_ON(NULL == icd->current_fmt);
+
+	/* I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours */
+	buf->inwork = 1;
+
+	if (buf->fmt	!= icd->current_fmt ||
+	    vb->width	!= icd->width ||
+	    vb->height	!= icd->height ||
+	    vb->field	!= field) {
+		buf->fmt	= icd->current_fmt;
+		vb->width	= icd->width;
+		vb->height	= icd->height;
+		vb->field	= field;
+		vb->state	= VIDEOBUF_NEEDS_INIT;
+	}
+
+	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
+	if (0 != vb->baddr && vb->bsize < vb->size) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret)
+			goto fail;
+
+		vb->state = VIDEOBUF_PREPARED;
+	}
+
+	buf->inwork = 0;
+
+	return 0;
+
+fail:
+	free_buffer(vq, buf);
+out:
+	buf->inwork = 0;
+	return ret;
+}
+
+static int imx_camera_setup_dma(struct imx_camera_dev *pcdev)
+{
+	struct videobuf_buffer *vbuf = &pcdev->active->vb;
+	int ret;
+
+	if (unlikely(!pcdev->active)) {
+		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
+		return -EFAULT;
+	}
+
+	/* setup sg list for future DMA */
+	ret = imx_dma_setup_single(pcdev->dma_chan,
+		videobuf_to_dma_contig(vbuf),
+		vbuf->size, pcdev->res->start +
+		CSIRXR, DMA_MODE_READ);
+	if(unlikely(ret))
+		dev_err(pcdev->dev, "Failed to setup DMA sg list\n");
+
+	return ret;
+}
+
+static void imx_videobuf_queue(struct videobuf_queue *vq,
+			       struct videobuf_buffer *vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct imx_camera_dev *pcdev = ici->priv;
+	struct imx_buffer *buf = container_of(vb, struct imx_buffer, vb);
+	unsigned long flags;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	list_add_tail(&vb->queue, &pcdev->capture);
+
+	vb->state = VIDEOBUF_ACTIVE;
+
+	if (!pcdev->active) {
+		pcdev->active = buf;
+
+		/* setup sg list for future DMA */
+		if (!imx_camera_setup_dma(pcdev)) {
+			unsigned int temp;
+			/* enable SOF irq */
+			temp = __raw_readl(pcdev->base + CSICR1) |
+						  CSICR1_SOF_INTEN;
+			__raw_writel(temp, pcdev->base + CSICR1);
+		}
+	}
+
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+static void imx_videobuf_release(struct videobuf_queue *vq,
+				 struct videobuf_buffer *vb)
+{
+	struct imx_buffer *buf = container_of(vb, struct imx_buffer, vb);
+#ifdef DEBUG
+	struct soc_camera_device *icd = vq->priv_data;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	switch (vb->state) {
+	case VIDEOBUF_ACTIVE:
+		dev_dbg(&icd->dev, "%s (active)\n", __func__);
+		break;
+	case VIDEOBUF_QUEUED:
+		dev_dbg(&icd->dev, "%s (queued)\n", __func__);
+		break;
+	case VIDEOBUF_PREPARED:
+		dev_dbg(&icd->dev, "%s (prepared)\n", __func__);
+		break;
+	default:
+		dev_dbg(&icd->dev, "%s (unknown)\n", __func__);
+		break;
+	}
+#endif
+
+	free_buffer(vq, buf);
+}
+
+static inline void imx_camera_wakeup(struct imx_camera_dev *pcdev,
+			      struct videobuf_buffer *vb,
+			      struct imx_buffer *buf)
+{
+	/* _init is used to debug races, see comment in imx_camera_reqbufs() */
+	list_del_init(&vb->queue);
+	vb->state = VIDEOBUF_DONE;
+	do_gettimeofday(&vb->ts);
+	vb->field_count++;
+	wake_up(&vb->done);
+
+	if (list_empty(&pcdev->capture)) {
+		pcdev->active = NULL;
+		return;
+	}
+
+	pcdev->active = list_entry(pcdev->capture.next,
+				   struct imx_buffer, vb.queue);
+
+	/* setup sg list for future DMA */
+	if (likely(!imx_camera_setup_dma(pcdev))) {
+		unsigned int temp;
+
+		/* enable SOF irq */
+		temp = __raw_readl(pcdev->base + CSICR1) | CSICR1_SOF_INTEN;
+		__raw_writel(temp, pcdev->base + CSICR1);
+	}
+}
+
+static void imx_camera_dma_irq(int channel, void *data)
+{
+	struct imx_camera_dev *pcdev = data;
+	struct imx_buffer *buf;
+	unsigned long flags;
+	struct videobuf_buffer *vb;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	imx_dma_disable(channel);
+
+	if (unlikely(!pcdev->active)) {
+		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
+		goto out;
+	}
+
+	vb = &pcdev->active->vb;
+	buf = container_of(vb, struct imx_buffer, vb);
+	WARN_ON(buf->inwork || list_empty(&vb->queue));
+	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	imx_camera_wakeup(pcdev, vb, buf);
+
+out:
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+static struct videobuf_queue_ops imx_videobuf_ops = {
+	.buf_setup      = imx_videobuf_setup,
+	.buf_prepare    = imx_videobuf_prepare,
+	.buf_queue      = imx_videobuf_queue,
+	.buf_release    = imx_videobuf_release,
+};
+
+static void imx_camera_init_videobuf(struct videobuf_queue *q,
+				     struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct imx_camera_dev *pcdev = ici->priv;
+
+	videobuf_queue_dma_contig_init(q, &imx_videobuf_ops, pcdev->dev,
+				       &pcdev->lock,
+				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				       V4L2_FIELD_NONE,
+				       sizeof(struct imx_buffer), icd);
+}
+
+static int mclk_get_divisor(struct imx_camera_dev *pcdev)
+{
+	unsigned int mclk_10khz = pcdev->platform_mclk_10khz;
+	unsigned long div;
+	unsigned long lcdclk;
+
+	lcdclk = clk_get_rate(pcdev->clk) / 10000;
+
+	/* We verify platform_mclk_10khz != 0, so if anyone breaks it, here
+	 * they get a nice Oops */
+	div = (lcdclk + 2 * mclk_10khz - 1) / (2 * mclk_10khz) - 1;
+
+	dev_dbg(pcdev->dev, "System clock %lukHz, target freq %dkHz, "
+		"divisor %lu\n", lcdclk * 10, mclk_10khz * 10, div);
+
+	return div;
+}
+
+static void imx_camera_activate(struct imx_camera_dev *pcdev)
+{
+	struct imxcamera_platform_data *pdata = pcdev->pdata;
+	unsigned int csicr1 = CSICR1_EN;
+
+	dev_dbg(pcdev->dev, "Registered platform device at %p\n",
+		pcdev);
+
+	if (pdata && pdata->init) {
+		dev_dbg(pcdev->dev, "%s: Init gpios\n", __func__);
+		pdata->init(pcdev->dev);
+	}
+
+	if (pdata && pdata->power) {
+		dev_dbg(pcdev->dev, "%s: Power on camera\n", __func__);
+		pdata->power(pcdev->dev, 1);
+	}
+
+	clk_enable(pcdev->clk);
+
+	/* enable CSI before doing anything else */
+	__raw_writel(csicr1, pcdev->base + CSICR1);
+
+	csicr1 |= CSICR1_MCLKEN | CSICR1_FCC | CSICR1_GCLK_MODE;
+	csicr1 |= CSICR1_MCLKDIV(mclk_get_divisor(pcdev));
+	csicr1 |= CSICR1_RXFF_LEVEL(2); /* 16 words */
+
+	__raw_writel(csicr1, pcdev->base + CSICR1);
+
+	if (pdata && pdata->reset) {
+		dev_dbg(pcdev->dev, "%s: Releasing camera reset\n",
+			__func__);
+		pdata->reset(pcdev->dev, 1);
+	}
+}
+
+static void imx_camera_deactivate(struct imx_camera_dev *pcdev)
+{
+	struct imxcamera_platform_data *board = pcdev->pdata;
+
+	/* Disable all CSI interface */
+	__raw_writel(0x00, pcdev->base + CSICR1);
+
+	clk_disable(pcdev->clk);
+
+	if (board && board->reset) {
+		dev_dbg(pcdev->dev, "%s: Asserting camera reset\n",
+			__func__);
+		board->reset(pcdev->dev, 0);
+	}
+
+	if (board && board->power) {
+		dev_dbg(pcdev->dev, "%s: Power off camera\n", __func__);
+		board->power(pcdev->dev, 0);
+	}
+
+	if (board && board->exit) {
+		dev_dbg(pcdev->dev, "%s: Release gpios\n", __func__);
+		board->exit(pcdev->dev);
+	}
+}
+
+/* The following two functions absolutely depend on the fact, that
+ * there can be only one camera on i.MX camera sensor interface */
+static int imx_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct imx_camera_dev *pcdev = ici->priv;
+	int ret;
+
+	mutex_lock(&camera_lock);
+
+	if (pcdev->icd) {
+		ret = -EBUSY;
+		goto ebusy;
+	}
+
+	dev_info(&icd->dev, "i.MX Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	imx_camera_activate(pcdev);
+	ret = icd->ops->init(icd);
+
+	if (!ret)
+		pcdev->icd = icd;
+
+ebusy:
+	mutex_unlock(&camera_lock);
+
+	return ret;
+}
+
+static void imx_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct imx_camera_dev *pcdev = ici->priv;
+	unsigned int csicr1;
+
+	BUG_ON(icd != pcdev->icd);
+
+	/* disable interrupts */
+	csicr1 = __raw_readl(pcdev->base + CSICR1) & ~CSI_IRQ_MASK;
+	__raw_writel(csicr1, pcdev->base + CSICR1);
+
+	/* Stop DMA engine */
+	imx_dma_disable(pcdev->dma_chan);
+
+	dev_info(&icd->dev, "i.MX Camera driver detached from camera %d\n",
+		 icd->devnum);
+
+	icd->ops->release(icd);
+
+	imx_camera_deactivate(pcdev);
+
+	pcdev->icd = NULL;
+}
+
+static int imx_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct imx_camera_dev *pcdev = ici->priv;
+	unsigned long camera_flags, common_flags;
+	unsigned int csicr1;
+	int ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	common_flags = soc_camera_bus_param_compatible(camera_flags,
+						       CSI_BUS_FLAGS);
+	if (!common_flags)
+		return -EINVAL;
+
+	if (!(common_flags & SOCAM_DATAWIDTH_8)) {
+		dev_warn(&icd->dev, "Camera sensor doesn't support 8-bit bus "
+				    "width\n");
+		/* set it so sensor set_bus_param could fail */
+		common_flags |= SOCAM_DATAWIDTH_8;
+	}
+
+	icd->buswidth = 8;
+
+	/* Make choises, based on platform defaults */
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW))
+		common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING))
+		common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+
+	ret = icd->ops->set_bus_param(icd, common_flags);
+	if (ret < 0)
+		return ret;
+
+	csicr1 = __raw_readl(pcdev->base + CSICR1);
+
+	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
+		csicr1 |= CSICR1_REDGE;
+	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
+		csicr1 |= CSICR1_SOF_POL;
+
+	__raw_writel(csicr1, pcdev->base + CSICR1);
+
+	return 0;
+}
+
+static int imx_camera_set_fmt(struct soc_camera_device *icd,
+			      __u32 pixfmt, struct v4l2_rect *rect)
+{
+	return icd->ops->set_fmt(icd, pixfmt, rect);
+}
+
+static int imx_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	/* TODO: limit to imx hardware capabilities */
+
+	/* limit to sensor capabilities */
+	return icd->ops->try_fmt(icd, f);
+}
+
+static int imx_camera_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
+{
+	int i;
+
+	/* This is for locking debugging only. I removed spinlocks and now I
+	 * check whether .prepare is ever called on a linked buffer, or whether
+	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
+	 * it hadn't triggered */
+	for (i = 0; i < p->count; i++) {
+		struct imx_buffer *buf = container_of(icf->vb_vidq.bufs[i],
+						      struct imx_buffer, vb);
+		buf->inwork = 0;
+		INIT_LIST_HEAD(&buf->vb.queue);
+	}
+
+	return 0;
+}
+
+static unsigned int imx_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct imx_buffer *buf;
+
+	buf = list_entry(icf->vb_vidq.stream.next, struct imx_buffer,
+			 vb.stream);
+
+	poll_wait(file, &buf->vb.done, pt);
+
+	if (buf->vb.state == VIDEOBUF_DONE ||
+	    buf->vb.state == VIDEOBUF_ERROR)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static int imx_camera_querycap(struct soc_camera_host *ici,
+			       struct v4l2_capability *cap)
+{
+	/* cap->name is set by the firendly caller:-> */
+	strlcpy(cap->card, imx_cam_driver_description, sizeof(cap->card));
+	cap->version = VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static struct soc_camera_host_ops imx_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= imx_camera_add_device,
+	.remove		= imx_camera_remove_device,
+	.set_fmt	= imx_camera_set_fmt,
+	.try_fmt	= imx_camera_try_fmt,
+	.init_videobuf	= imx_camera_init_videobuf,
+	.reqbufs	= imx_camera_reqbufs,
+	.poll		= imx_camera_poll,
+	.querycap	= imx_camera_querycap,
+	.set_bus_param	= imx_camera_set_bus_param,
+};
+
+/* Should be allocated dynamically too, but we have only one. */
+static struct soc_camera_host imx_soc_camera_host = {
+	.drv_name		= DRIVER_NAME,
+	.ops			= &imx_soc_camera_host_ops,
+};
+
+static struct fiq_handler fh = {
+	.name	= "csi_sof"
+};
+
+static int __init imx_camera_probe(struct platform_device *pdev)
+{
+	struct imx_camera_dev *pcdev;
+	struct resource *res;
+	struct pt_regs regs;
+	struct clk *clk;
+	void __iomem *base;
+	unsigned int irq;
+	int err = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!res || !irq) {
+		err = -ENODEV;
+		goto exit;
+	}
+
+	clk = clk_get(&pdev->dev, "csi_clk");
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		goto exit;
+	}
+
+	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	dev_set_drvdata(&pdev->dev, pcdev);
+	pcdev->res = res;
+	pcdev->clk = clk;
+
+	pcdev->pdata = pdev->dev.platform_data;
+
+	if (pcdev->pdata)
+		pcdev->platform_mclk_10khz = pcdev->pdata->mclk_10khz;
+	else
+		dev_warn(&pdev->dev, "No platform data provided!\n");
+
+	/* override if user entered mclk frequency as module param */
+	if (mclk)
+		pcdev->platform_mclk_10khz = mclk / 10000;
+
+	if (!pcdev->platform_mclk_10khz) {
+		dev_warn(&pdev->dev,
+			 "mclk_10khz == 0! Please, fix your platform data. "
+			 "Using default 20MHz\n");
+		pcdev->platform_mclk_10khz = 2000;
+	}
+
+	INIT_LIST_HEAD(&pcdev->capture);
+	spin_lock_init(&pcdev->lock);
+
+	/*
+	 * Request the regions.
+	 */
+	if (!request_mem_region(res->start, res->end - res->start + 1,
+				DRIVER_NAME)) {
+		err = -EBUSY;
+		goto exit_kfree;
+	}
+
+	base = ioremap(res->start, res->end - res->start + 1);
+	if (!base) {
+		err = -ENOMEM;
+		goto exit_release;
+	}
+	pcdev->irq = irq;
+	pcdev->base = base;
+	pcdev->dev = &pdev->dev;
+
+	/* request dma */
+	pcdev->dma_chan = imx_dma_request_by_prio(DRIVER_NAME, DMA_PRIO_HIGH);
+	if (pcdev->dma_chan < 0) {
+		dev_err(pcdev->dev, "Can't request DMA for i.MX CSI\n");
+		err = -ENOMEM;
+		goto exit_iounmap;
+	}
+	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chan);
+
+	imx_dma_setup_handlers(pcdev->dma_chan, imx_camera_dma_irq, NULL,
+			       pcdev);
+
+	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
+			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
+	/* burst length : 16 words = 64 bytes */
+	imx_dma_config_burstlen(pcdev->dma_chan, 0);
+
+	/* request irq */
+	err = claim_fiq(&fh);
+	if (err) {
+		dev_err(pcdev->dev, "Camera interrupt register failed \n");
+		goto exit_free_dma;
+	}
+
+	set_fiq_handler(&imx_camera_sof_fiq_start, &imx_camera_sof_fiq_end -
+						   &imx_camera_sof_fiq_start);
+
+	regs.ARM_r8 = DMA_BASE + DMA_DIMR;
+	regs.ARM_r9 = DMA_BASE + DMA_CCR(pcdev->dma_chan);
+	regs.ARM_r10 = (long)pcdev->base + CSICR1;
+	regs.ARM_fp = (long)pcdev->base + CSISR;
+	regs.ARM_sp = 1 << pcdev->dma_chan;
+	set_fiq_regs(&regs);
+
+	mxc_set_irq_fiq(irq, 1);
+	enable_fiq(irq);
+
+	imx_soc_camera_host.priv	= pcdev;
+	imx_soc_camera_host.dev.parent	= &pdev->dev;
+	imx_soc_camera_host.nr		= pdev->id;
+	err = soc_camera_host_register(&imx_soc_camera_host);
+	if (err)
+		goto exit_free_irq;
+
+	dev_info(&pdev->dev, "i.MX Camera driver loaded\n");
+
+	return 0;
+
+exit_free_irq:
+	disable_fiq(irq);
+	mxc_set_irq_fiq(irq, 0);
+	release_fiq(&fh);
+exit_free_dma:
+	imx_dma_free(pcdev->dma_chan);
+exit_iounmap:
+	iounmap(base);
+exit_release:
+	release_mem_region(res->start, res->end - res->start + 1);
+exit_kfree:
+	kfree(pcdev);
+exit:
+	return err;
+}
+
+static int __exit imx_camera_remove(struct platform_device *pdev)
+{
+	struct imx_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	imx_dma_free(pcdev->dma_chan);
+	disable_fiq(pcdev->irq);
+	mxc_set_irq_fiq(pcdev->irq, 0);
+	release_fiq(&fh);
+
+	soc_camera_host_unregister(&imx_soc_camera_host);
+
+	iounmap(pcdev->base);
+
+	res = pcdev->res;
+	release_mem_region(res->start, res->end - res->start + 1);
+
+	kfree(pcdev);
+
+	dev_info(&pdev->dev, "i.MX Camera driver unloaded\n");
+
+	return 0;
+}
+
+static int imx_camera_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct imx_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct imxcamera_platform_data *pdata = pcdev->pdata;
+
+	if (pcdev->active)
+		return -EBUSY;
+
+	if (pdata && pdata->power) {
+		dev_dbg(pcdev->dev, "%s: Power off camera\n", __func__);
+		pdata->power(pcdev->dev, 0);
+	}
+
+	return 0;
+}
+
+static int imx_camera_resume(struct platform_device *pdev)
+{
+	struct imx_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct imxcamera_platform_data *pdata = pcdev->pdata;
+
+	if (pdata && pdata->power) {
+		dev_dbg(pcdev->dev, "%s: Power on camera\n", __func__);
+		pdata->power(pcdev->dev, 1);
+	}
+
+	return 0;
+}
+
+static struct platform_driver imx_camera_driver = {
+	.driver 	= {
+		.name	= DRIVER_NAME,
+	},
+	.remove		= __exit_p(imx_camera_remove),
+	.suspend	= imx_camera_suspend,
+	.resume		= imx_camera_resume,
+};
+
+static int __init imx_camera_init(void)
+{
+	return platform_driver_probe(&imx_camera_driver, imx_camera_probe);
+}
+
+static void __exit imx_camera_exit(void)
+{
+	return platform_driver_unregister(&imx_camera_driver);
+}
+
+module_init(imx_camera_init);
+module_exit(imx_camera_exit);
+
+MODULE_DESCRIPTION("i.MX SoC Camera Host driver");
+MODULE_AUTHOR("Paulius Zaleckas <paulius.zaleckas@teltonika.lt>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
+
+module_param(mclk, int, 0);
+MODULE_PARM_DESC(mclk, "MCLK value in Hz");
Index: linux-2.6.29/drivers/media/video/Kconfig
===================================================================
--- linux-2.6.29.orig/drivers/media/video/Kconfig
+++ linux-2.6.29/drivers/media/video/Kconfig
@@ -929,4 +929,13 @@ config USB_S2255
 
 endif # V4L_USB_DRIVERS
 
+config VIDEO_IMX
+	tristate "i.MX CMOS Sensor Interface driver"
+	depends on VIDEO_DEV && ARCH_MX1
+	select FIQ
+	select SOC_CAMERA
+	select VIDEOBUF_DMA_CONTIG
+	---help---
+	  This is a v4l2 driver for the i.MX CMOS Sensor Interface
+
 endif # VIDEO_CAPTURE_DRIVERS
Index: linux-2.6.29/drivers/media/video/Makefile
===================================================================
--- linux-2.6.29.orig/drivers/media/video/Makefile
+++ linux-2.6.29/drivers/media/video/Makefile
@@ -134,6 +134,7 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_VIDEO_IMX)		+= imx_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
Index: linux-2.6.29/arch/arm/mach-mx1/Makefile
===================================================================
--- linux-2.6.29.orig/arch/arm/mach-mx1/Makefile
+++ linux-2.6.29/arch/arm/mach-mx1/Makefile
@@ -4,7 +4,7 @@
 
 # Object file lists.
 
-obj-y			+= generic.o clock.o devices.o
+obj-y			+= generic.o clock.o devices.o ksym_mx1.o
 
 # Power management
 obj-$(CONFIG_PM)		+= pm.o
@@ -13,5 +13,10 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 CFLAGS_pm.o += -DDEBUG
 endif
 
+# Support for CMOS sensor interface
+ifdef CONFIG_VIDEO_IMX
+obj-y	+= imx_camera_fiq.o
+endif
+
 # Specific board support
 obj-$(CONFIG_ARCH_MX1ADS) += mx1ads.o
Index: linux-2.6.29/arch/arm/plat-mxc/include/mach/memory.h
===================================================================
--- linux-2.6.29.orig/arch/arm/plat-mxc/include/mach/memory.h
+++ linux-2.6.29/arch/arm/plat-mxc/include/mach/memory.h
@@ -19,4 +19,12 @@
 #define PHYS_OFFSET		UL(0x80000000)
 #endif
 
+#if defined(CONFIG_VIDEO_IMX) || defined(CONFIG_VIDEO_IMX_MODULE)
+/*
+ * Increase size of DMA-consistent memory region.
+ * This is required for i.MX camera driver to capture at least four VGA frames.
+ */
+#define CONSISTENT_DMA_SIZE SZ_8M
+#endif /* CONFIG_VIDEO_IMX */
+
 #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
Index: linux-2.6.29/arch/arm/plat-mxc/include/mach/camera.h
===================================================================
--- /dev/null
+++ linux-2.6.29/arch/arm/plat-mxc/include/mach/camera.h
@@ -0,0 +1,27 @@
+/*
+ * camera.h - i.MX camera driver header file
+ *
+ * Copyright (c) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ *
+ * Based on PXA camera.h file:
+ * Copyright (C) 2003, Intel Corporation
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __ASM_ARCH_CAMERA_H_
+#define __ASM_ARCH_CAMERA_H_
+
+extern unsigned char imx_camera_sof_fiq_start, imx_camera_sof_fiq_end;
+
+struct imxcamera_platform_data {
+	int (*init)(struct device *);
+	int (*exit)(struct device *);
+	int (*power)(struct device *, int);
+	int (*reset)(struct device *, int);
+
+	unsigned long mclk_10khz;
+};
+
+#endif /* __ASM_ARCH_CAMERA_H_ */
Index: linux-2.6.29/arch/arm/mach-mx1/imx_camera_fiq.S
===================================================================
--- /dev/null
+++ linux-2.6.29/arch/arm/mach-mx1/imx_camera_fiq.S
@@ -0,0 +1,35 @@
+/*
+ *  Copyright (C) 2008 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ *
+ *  Based on linux/arch/arm/lib/floppydma.S
+ *      Copyright (C) 1995, 1996 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+		.text
+		.global	imx_camera_sof_fiq_end
+		.global	imx_camera_sof_fiq_start
+imx_camera_sof_fiq_start:
+		@ enable dma
+		ldr	r12, [r9]
+		orr	r12, r12, #0x00000001
+		str	r12, [r9]
+		@ unmask DMA interrupt
+		ldr	r12, [r8]
+		bic	r12, r12, r13
+		str	r12, [r8]
+		@ disable SOF interrupt
+		ldr	r12, [r10]
+		bic	r12, r12, #0x00010000
+		str	r12, [r10]
+		@ clear SOF flag
+		mov	r12, #0x00010000
+		str	r12, [r11]
+		@ return from FIQ
+		subs	pc, lr, #4
+imx_camera_sof_fiq_end:
Index: linux-2.6.29/arch/arm/mach-mx1/ksym_mx1.c
===================================================================
--- /dev/null
+++ linux-2.6.29/arch/arm/mach-mx1/ksym_mx1.c
@@ -0,0 +1,23 @@
+/*
+ * Exported ksyms of ARCH_MX1
+ *
+ * Copyright (C) 2008, Darius Augulis <augulis.darius@gmail.com>
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+
+
+#if defined(CONFIG_VIDEO_IMX) || defined(CONFIG_VIDEO_IMX_MODULE)
+#include <mach/camera.h>
+
+/* IMX camera FIQ handler */
+EXPORT_SYMBOL(imx_camera_sof_fiq_start);
+EXPORT_SYMBOL(imx_camera_sof_fiq_end);
+#endif

--------------010205040007040702080000--
