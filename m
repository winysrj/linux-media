Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15HkkVR007244
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:46 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m15HkF8k016693
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:15 -0500
Date: Tue, 5 Feb 2008 18:46:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802051830360.5882@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/6] V4L2 soc_camera driver for PXA27x processors
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

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

This patch adds a driver for the Quick Capture Interface on the PXA270.
It is based on the original driver from Intel, but has been re-worked
multiple times since then, now for the first time it supports the
V4L2 API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

 arch/arm/mach-pxa/devices.c         |   32 ++
 drivers/media/video/Kconfig         |    7 +
 drivers/media/video/Makefile        |    1 +
 drivers/media/video/pxa_camera.c    |  937 +++++++++++++++++++++++++++++++++++
 include/asm-arm/arch-pxa/camera.h   |   48 ++
 include/asm-arm/arch-pxa/pxa-regs.h |   94 ++++
 6 files changed, 1119 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/pxa_camera.c
 create mode 100644 include/asm-arm/arch-pxa/camera.h

diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
index bfccb80..3838aab 100644
--- a/arch/arm/mach-pxa/devices.c
+++ b/arch/arm/mach-pxa/devices.c
@@ -11,6 +11,7 @@
 #include <asm/arch/irda.h>
 #include <asm/arch/i2c.h>
 #include <asm/arch/ohci.h>
+#include <asm/arch/camera.h>
 
 #include "devices.h"
 
@@ -540,6 +541,37 @@ struct platform_device pxa27x_device_ssp3 = {
 	.resource	= pxa27x_resource_ssp3,
 	.num_resources	= ARRAY_SIZE(pxa27x_resource_ssp3),
 };
+
+static struct resource pxa27x_resource_camera[] = {
+	[0] = {
+		.start	= 0x50000000,
+		.end	= 0x50000fff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_CAMERA,
+		.end	= IRQ_CAMERA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static u64 pxa27x_dma_mask_camera = DMA_BIT_MASK(32);
+
+static struct platform_device pxa27x_device_camera = {
+	.name		= "pxa27x-camera",
+	.id		= 0, /* This is used to put cameras on this interface */
+	.dev		= {
+		.dma_mask      		= &pxa27x_dma_mask_camera,
+		.coherent_dma_mask	= 0xffffffff,
+	},
+	.num_resources	= ARRAY_SIZE(pxa27x_resource_camera),
+	.resource	= pxa27x_resource_camera,
+};
+
+void __init pxa_set_camera_info(struct pxacamera_platform_data *info)
+{
+	pxa_register_device(&pxa27x_device_camera, info);
+}
 #endif /* CONFIG_PXA27x || CONFIG_PXA3xx */
 
 #ifdef CONFIG_PXA3xx
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ba1e3ac..36a333a 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -845,4 +845,11 @@ config SOC_CAMERA
 	  over a bus like PCI or USB. For example some i2c camera connected
 	  directly to the data bus of an SoC.
 
+config VIDEO_PXA27x
+	tristate "PXA27x Quick Capture Interface driver"
+	depends on VIDEO_DEV && PXA27x
+	select SOC_CAMERA
+	---help---
+	  This is a v4l2 driver for the PXA27x Quick Capture Interface
+
 endif # VIDEO_CAPTURE_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index bfc1457..fa04fa0 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -135,6 +135,7 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
 obj-$(CONFIG_SOC_CAMERA)	+= soc_camera.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
new file mode 100644
index 0000000..2347040
--- /dev/null
+++ b/drivers/media/video/pxa_camera.c
@@ -0,0 +1,937 @@
+/*
+ * V4L2 Driver for PXA camera host
+ *
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <asm/io.h>
+
+#include <linux/init.h>
+#include <linux/module.h>
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
+#include <media/soc_camera.h>
+
+#include <linux/videodev2.h>
+
+#include <asm/dma.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/camera.h>
+
+#define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
+#define PXA_CAM_DRV_NAME "pxa27x-camera"
+
+#define CICR0_IRQ_MASK (CICR0_TOM | CICR0_RDAVM | CICR0_FEM | CICR0_EOLM | \
+			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
+			CICR0_EOFM | CICR0_FOM)
+
+static DEFINE_MUTEX(camera_lock);
+
+/*
+ * Structures
+ */
+
+/* buffer for one video frame */
+struct pxa_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer vb;
+
+	const struct soc_camera_data_format        *fmt;
+
+	/* our descriptor list needed for the PXA DMA engine */
+	dma_addr_t		sg_dma;
+	struct pxa_dma_desc	*sg_cpu;
+	size_t			sg_size;
+	int			inwork;
+};
+
+struct pxa_framebuffer_queue {
+	dma_addr_t		sg_last_dma;
+	struct pxa_dma_desc	*sg_last_cpu;
+};
+
+struct pxa_camera_dev {
+	struct device		*dev;
+	/* PXA27x is only supposed to handle one camera on its Quick Capture
+	 * interface. If anyone ever builds hardware to enable more than
+	 * one camera, they will have to modify this driver too */
+	struct soc_camera_device *icd;
+	struct clk		*clk;
+
+	unsigned int		irq;
+	void __iomem		*base;
+	unsigned int		dma_chan_y;
+
+	enum v4l2_buf_type	type;
+
+	struct pxacamera_platform_data *pdata;
+	struct resource		*res;
+	unsigned long		platform_flags;
+	unsigned long		platform_mclk_10khz;
+
+	struct list_head	capture;
+
+	spinlock_t		lock;
+
+	int			dma_running;
+
+	struct pxa_buffer	*active;
+};
+
+static const char *pxa_cam_driver_description = "PXA_Camera";
+
+static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
+
+/*
+ *  Videobuf operations
+ */
+static int
+pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
+		   unsigned int *size)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+
+	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+
+	*size = icd->width * icd->height * ((icd->current_fmt->depth + 7) >> 3);
+
+	if (0 == *count)
+		*count = 32;
+	while (*size * *count > vid_limit * 1024 * 1024)
+		(*count)--;
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
+
+	BUG_ON(in_interrupt());
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+		&buf->vb, buf->vb.baddr, buf->vb.bsize);
+
+	/* This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE */
+	videobuf_waiton(&buf->vb, 0, 0);
+	videobuf_dma_unmap(vq, dma);
+	videobuf_dma_free(dma);
+
+	if (buf->sg_cpu)
+		dma_free_coherent(pcdev->dev, buf->sg_size, buf->sg_cpu,
+				  buf->sg_dma);
+	buf->sg_cpu = NULL;
+
+	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int
+pxa_videobuf_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
+						enum v4l2_field field)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
+	int i, ret;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+		vb, vb->baddr, vb->bsize);
+
+	/* Added list head initialization on alloc */
+	WARN_ON(!list_empty(&vb->queue));
+
+#ifdef DEBUG
+	/* This can be useful if you want to see if we actually fill
+	 * the buffer with something */
+	memset((void *)vb->baddr, 0xaa, vb->bsize);
+#endif
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
+		unsigned int size = vb->size;
+		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret)
+			goto fail;
+
+		if (buf->sg_cpu)
+			dma_free_coherent(pcdev->dev, buf->sg_size, buf->sg_cpu,
+					  buf->sg_dma);
+
+		buf->sg_size = (dma->sglen + 1) * sizeof(struct pxa_dma_desc);
+		buf->sg_cpu = dma_alloc_coherent(pcdev->dev, buf->sg_size,
+						 &buf->sg_dma, GFP_KERNEL);
+		if (!buf->sg_cpu) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		dev_dbg(&icd->dev, "nents=%d size: %d sg=0x%p\n",
+			dma->sglen, size, dma->sglist);
+		for (i = 0; i < dma->sglen; i++) {
+			struct scatterlist *sg = dma->sglist;
+			unsigned int dma_len = sg_dma_len(&sg[i]), xfer_len;
+
+			/* CIBR0 */
+			buf->sg_cpu[i].dsadr = pcdev->res->start + 0x28;
+			buf->sg_cpu[i].dtadr = sg_dma_address(&sg[i]);
+			/* PXA270 Developer's Manual 27.4.4.1:
+			 * round up to 8 bytes */
+			xfer_len = (min(dma_len, size) + 7) & ~7;
+			if (xfer_len & 7)
+				dev_err(&icd->dev, "Unaligned buffer: "
+					"dma_len %u, size %u\n", dma_len, size);
+			buf->sg_cpu[i].dcmd = DCMD_FLOWSRC | DCMD_BURST8 |
+				DCMD_INCTRGADDR | xfer_len;
+			size -= dma_len;
+			buf->sg_cpu[i].ddadr = buf->sg_dma + (i + 1) *
+					sizeof(struct pxa_dma_desc);
+		}
+		buf->sg_cpu[dma->sglen - 1].ddadr = DDADR_STOP;
+		buf->sg_cpu[dma->sglen - 1].dcmd |= DCMD_ENDIRQEN;
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
+static void
+pxa_videobuf_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
+	struct pxa_buffer *active = pcdev->active;
+	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+	int nents = dma->sglen;
+	unsigned long flags;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+		vb, vb->baddr, vb->bsize);
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	list_add_tail(&vb->queue, &pcdev->capture);
+
+	vb->state = VIDEOBUF_ACTIVE;
+
+	if (!pcdev->active) {
+		CIFR |= CIFR_RESET_F;
+		DDADR(pcdev->dma_chan_y) = buf->sg_dma;
+		DCSR(pcdev->dma_chan_y) = DCSR_RUN;
+		pcdev->active = buf;
+		CICR0 |= CICR0_ENB;
+	} else {
+		struct videobuf_dmabuf *active_dma =
+			videobuf_to_dma(&active->vb);
+		/* Stop DMA engine */
+		DCSR(pcdev->dma_chan_y) = 0;
+
+		/* Add the descriptors we just initialized to the currently
+		 * running chain
+		 */
+		active->sg_cpu[active_dma->sglen - 1].ddadr = buf->sg_dma;
+
+		/* Setup a dummy descriptor with the DMA engines current
+		 * state
+		 */
+		/* CIBR0 */
+		buf->sg_cpu[nents].dsadr = pcdev->res->start + 0x28;
+		buf->sg_cpu[nents].dtadr = DTADR(pcdev->dma_chan_y);
+		buf->sg_cpu[nents].dcmd = DCMD(pcdev->dma_chan_y);
+
+		if (DDADR(pcdev->dma_chan_y) == DDADR_STOP) {
+			/* The DMA engine is on the last descriptor, set the
+			 * next descriptors address to the descriptors
+			 * we just initialized
+			 */
+			buf->sg_cpu[nents].ddadr = buf->sg_dma;
+		} else {
+			buf->sg_cpu[nents].ddadr = DDADR(pcdev->dma_chan_y);
+		}
+
+		/* The next descriptor is the dummy descriptor */
+		DDADR(pcdev->dma_chan_y) = buf->sg_dma + nents *
+			sizeof(struct pxa_dma_desc);
+
+#ifdef DEBUG
+		if (CISR & CISR_IFO_0) {
+			dev_warn(pcdev->dev, "FIFO overrun\n");
+			DDADR(pcdev->dma_chan_y) = pcdev->active->sg_dma;
+
+			CICR0 &= ~CICR0_ENB;
+			CIFR |= CIFR_RESET_F;
+			DCSR(pcdev->dma_chan_y) = DCSR_RUN;
+			CICR0 |= CICR0_ENB;
+		} else
+#endif
+			DCSR(pcdev->dma_chan_y) = DCSR_RUN;
+	}
+
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
+}
+
+static void pxa_videobuf_release(struct videobuf_queue *vq,
+				 struct videobuf_buffer *vb)
+{
+	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
+#ifdef DEBUG
+	struct soc_camera_device *icd = vq->priv_data;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+		vb, vb->baddr, vb->bsize);
+
+	switch (vb->state) {
+	case VIDEOBUF_ACTIVE:
+		dev_dbg(&icd->dev, "%s (active)\n", __FUNCTION__);
+		break;
+	case VIDEOBUF_QUEUED:
+		dev_dbg(&icd->dev, "%s (queued)\n", __FUNCTION__);
+		break;
+	case VIDEOBUF_PREPARED:
+		dev_dbg(&icd->dev, "%s (prepared)\n", __FUNCTION__);
+		break;
+	default:
+		dev_dbg(&icd->dev, "%s (unknown)\n", __FUNCTION__);
+		break;
+	}
+#endif
+
+	free_buffer(vq, buf);
+}
+
+static void pxa_camera_dma_irq_y(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	struct pxa_buffer *buf;
+	unsigned long flags;
+	unsigned int status;
+	struct videobuf_buffer *vb;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	status = DCSR(pcdev->dma_chan_y);
+	if (status & DCSR_BUSERR) {
+		dev_err(pcdev->dev, "%s: Bus Error\n", __FUNCTION__);
+		DCSR(pcdev->dma_chan_y) |= DCSR_BUSERR;
+		goto out;
+	}
+
+	if (!(status & DCSR_ENDINTR)) {
+		dev_err(pcdev->dev, "%s: unknown dma interrupt source. "
+			"status: 0x%08x\n", __FUNCTION__, status);
+		goto out;
+	}
+
+	DCSR(pcdev->dma_chan_y) |= DCSR_ENDINTR;
+
+	if (!pcdev->active) {
+		dev_err(pcdev->dev, "%s: no active buf\n", __FUNCTION__);
+		goto out;
+	}
+
+	vb = &pcdev->active->vb;
+	buf = container_of(vb, struct pxa_buffer, vb);
+	WARN_ON(buf->inwork || list_empty(&vb->queue));
+	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+		vb, vb->baddr, vb->bsize);
+
+	/* _init is used to debug races, see comment in pxa_is_reqbufs() */
+	list_del_init(&vb->queue);
+	vb->state = VIDEOBUF_DONE;
+	do_gettimeofday(&vb->ts);
+	vb->field_count++;
+	wake_up(&vb->done);
+
+	if (list_empty(&pcdev->capture)) {
+		pcdev->active = NULL;
+		DCSR(pcdev->dma_chan_y) = 0;
+		CICR0 &= ~CICR0_ENB;
+		goto out;
+	}
+
+	pcdev->active = list_entry(pcdev->capture.next, struct pxa_buffer,
+				   vb.queue);
+
+out:
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+static struct videobuf_queue_ops pxa_video_ops = {
+	.buf_setup      = pxa_videobuf_setup,
+	.buf_prepare    = pxa_videobuf_prepare,
+	.buf_queue      = pxa_videobuf_queue,
+	.buf_release    = pxa_videobuf_release,
+};
+
+static int mclk_get_divisor(struct pxa_camera_dev *pcdev)
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
+	dev_dbg(pcdev->dev, "LCD clock %lukHz, target freq %dkHz, "
+		"divisor %lu\n", lcdclk * 10, mclk_10khz * 10, div);
+
+	return div;
+}
+
+static void pxa_is_activate(struct pxa_camera_dev *pcdev)
+{
+	struct pxacamera_platform_data *pdata = pcdev->pdata;
+	u32 cicr4 = 0;
+
+	dev_dbg(pcdev->dev, "Registered platform device at %p data %p\n",
+		pcdev, pdata);
+
+	if (pdata && pdata->init) {
+		dev_dbg(pcdev->dev, "%s: Init gpios\n", __FUNCTION__);
+		pdata->init(pcdev->dev);
+	}
+
+	if (pdata && pdata->power) {
+		dev_dbg(pcdev->dev, "%s: Power on camera\n", __FUNCTION__);
+		pdata->power(pcdev->dev, 1);
+	}
+
+	if (pdata && pdata->reset) {
+		dev_dbg(pcdev->dev, "%s: Releasing camera reset\n",
+			__FUNCTION__);
+		pdata->reset(pcdev->dev, 1);
+	}
+
+	CICR0 = 0x3FF;   /* disable all interrupts */
+
+	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		cicr4 |= CICR4_PCLK_EN;
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		cicr4 |= CICR4_MCLK_EN;
+	if (pcdev->platform_flags & PXA_CAMERA_PCP)
+		cicr4 |= CICR4_PCP;
+	if (pcdev->platform_flags & PXA_CAMERA_HSP)
+		cicr4 |= CICR4_HSP;
+	if (pcdev->platform_flags & PXA_CAMERA_VSP)
+		cicr4 |= CICR4_VSP;
+
+	CICR4 = mclk_get_divisor(pcdev) | cicr4;
+
+	clk_enable(pcdev->clk);
+}
+
+static void pxa_is_deactivate(struct pxa_camera_dev *pcdev)
+{
+	struct pxacamera_platform_data *board = pcdev->pdata;
+
+	clk_disable(pcdev->clk);
+
+	if (board && board->reset) {
+		dev_dbg(pcdev->dev, "%s: Asserting camera reset\n",
+			__FUNCTION__);
+		board->reset(pcdev->dev, 0);
+	}
+
+	if (board && board->power) {
+		dev_dbg(pcdev->dev, "%s: Power off camera\n", __FUNCTION__);
+		board->power(pcdev->dev, 0);
+	}
+}
+
+static irqreturn_t pxa_camera_irq(int irq, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	unsigned int status = CISR;
+
+	dev_dbg(pcdev->dev, "Camera interrupt status 0x%x\n", status);
+
+	CISR = status;
+
+	return IRQ_HANDLED;
+}
+
+/* The following two functions absolutely depend on the fact, that
+ * there can be only one camera on PXA quick capture interface */
+static int pxa_is_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	int ret;
+
+	mutex_lock(&camera_lock);
+
+	if (pcdev->icd) {
+		ret = -EBUSY;
+		goto ebusy;
+	}
+
+	dev_info(&icd->dev, "PXA Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	pxa_is_activate(pcdev);
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
+static void pxa_is_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+
+	BUG_ON(icd != pcdev->icd);
+
+	dev_info(&icd->dev, "PXA Camera driver detached from camera %d\n",
+		 icd->devnum);
+
+	/* disable capture, disable interrupts */
+	CICR0 = 0x3ff;
+	/* Stop DMA engine */
+	DCSR(pcdev->dma_chan_y) = 0;
+
+	icd->ops->release(icd);
+
+	pxa_is_deactivate(pcdev);
+
+	pcdev->icd = NULL;
+}
+
+static int pxa_is_set_capture_format(struct soc_camera_device *icd,
+				     __u32 pixfmt, struct v4l2_rect *rect)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	unsigned int datawidth = 0, dw, bpp;
+	u32 cicr0, cicr4 = 0;
+	int ret;
+
+	/* If requested data width is supported by the platform, use it */
+	switch (icd->cached_datawidth) {
+	case 10:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
+			datawidth = IS_DATAWIDTH_10;
+		break;
+	case 9:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
+			datawidth = IS_DATAWIDTH_9;
+		break;
+	case 8:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
+			datawidth = IS_DATAWIDTH_8;
+	}
+	if (!datawidth)
+		return -EINVAL;
+
+	ret = icd->ops->set_capture_format(icd, pixfmt, rect,
+			datawidth |
+			(pcdev->platform_flags & PXA_CAMERA_MASTER ?
+			 IS_MASTER : 0) |
+			(pcdev->platform_flags & PXA_CAMERA_HSP ?
+			 0 : IS_HSYNC_ACTIVE_HIGH) |
+			(pcdev->platform_flags & PXA_CAMERA_VSP ?
+			 0 : IS_VSYNC_ACTIVE_HIGH) |
+			(pcdev->platform_flags & PXA_CAMERA_PCP ?
+			 0 : IS_PCLK_SAMPLE_RISING));
+	if (ret < 0)
+		return ret;
+
+	/* Datawidth is now guaranteed to be equal to one of the three values.
+	 * We fix bit-per-pixel equal to data-width... */
+	switch (datawidth) {
+	case IS_DATAWIDTH_10:
+		icd->cached_datawidth = 10;
+		dw = 4;
+		bpp = 0x40;
+		break;
+	case IS_DATAWIDTH_9:
+		icd->cached_datawidth = 9;
+		dw = 3;
+		bpp = 0x20;
+		break;
+	default:
+		/* Actually it can only be 8 now,
+		 * default is just to silence compiler warnings */
+	case IS_DATAWIDTH_8:
+		icd->cached_datawidth = 8;
+		dw = 2;
+		bpp = 0;
+	}
+
+	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		cicr4 |= CICR4_PCLK_EN;
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		cicr4 |= CICR4_MCLK_EN;
+	if (pcdev->platform_flags & PXA_CAMERA_PCP)
+		cicr4 |= CICR4_PCP;
+	if (pcdev->platform_flags & PXA_CAMERA_HSP)
+		cicr4 |= CICR4_HSP;
+	if (pcdev->platform_flags & PXA_CAMERA_VSP)
+		cicr4 |= CICR4_VSP;
+
+	cicr0 = CICR0;
+	if (cicr0 & CICR0_ENB)
+		CICR0 = cicr0 & ~CICR0_ENB;
+	CICR1 = CICR1_PPL_VAL(rect->width - 1) | bpp | dw;
+	CICR2 = 0;
+	CICR3 = CICR3_LPF_VAL(rect->height - 1) |
+		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
+	CICR4 = mclk_get_divisor(pcdev) | cicr4;
+
+	/* CIF interrupts are not used, only DMA */
+	CICR0 = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
+			0 : (CICR0_SL_CAP_EN | CICR0_SIM_SP)) |
+		CICR0_DMAEN | CICR0_IRQ_MASK | (cicr0 & CICR0_ENB);
+
+	return 0;
+}
+
+static int pxa_is_try_fmt_cap(struct soc_camera_host *ici,
+			      struct v4l2_format *f)
+{
+	/* limit to pxa hardware capabilities */
+	if (f->fmt.pix.height < 32)
+		f->fmt.pix.height = 32;
+	if (f->fmt.pix.height > 2048)
+		f->fmt.pix.height = 2048;
+	if (f->fmt.pix.width < 48)
+		f->fmt.pix.width = 48;
+	if (f->fmt.pix.width > 2048)
+		f->fmt.pix.width = 2048;
+	f->fmt.pix.width &= ~0x01;
+
+	return 0;
+}
+
+static int pxa_is_reqbufs(struct soc_camera_file *icf,
+			  struct v4l2_requestbuffers *p)
+{
+	int i;
+
+	/* This is for locking debugging only. I removed spinlocks and now I
+	 * check whether .prepare is ever called on a linked buffer, or whether
+	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
+	 * it hadn't triggered */
+	for (i = 0; i < p->count; i++) {
+		struct pxa_buffer *buf = container_of(icf->vb_vidq.bufs[i],
+						      struct pxa_buffer, vb);
+		buf->inwork = 0;
+		INIT_LIST_HEAD(&buf->vb.queue);
+	}
+
+	return 0;
+}
+
+static unsigned int pxa_is_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct pxa_buffer *buf;
+
+	buf = list_entry(icf->vb_vidq.stream.next, struct pxa_buffer,
+			 vb.stream);
+
+	poll_wait(file, &buf->vb.done, pt);
+
+	if (buf->vb.state == VIDEOBUF_DONE ||
+	    buf->vb.state == VIDEOBUF_ERROR)
+		return POLLIN|POLLRDNORM;
+
+	return 0;
+}
+
+static int pxa_is_querycap(struct soc_camera_host *ici,
+			   struct v4l2_capability *cap)
+{
+	/* cap->name is set by the firendly caller:-> */
+	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
+	cap->version = PXA_CAM_VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+/* Should beallocated dynamically too, but we have only one. */
+static struct soc_camera_host pxa_soc_camera_host = {
+	.drv_name		= PXA_CAM_DRV_NAME,
+	.vbq_ops		= &pxa_video_ops,
+	.add			= pxa_is_add_device,
+	.remove			= pxa_is_remove_device,
+	.msize			= sizeof(struct pxa_buffer),
+	.set_capture_format	= pxa_is_set_capture_format,
+	.try_fmt_cap		= pxa_is_try_fmt_cap,
+	.reqbufs		= pxa_is_reqbufs,
+	.poll			= pxa_is_poll,
+	.querycap		= pxa_is_querycap,
+};
+
+static int pxa_camera_probe(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev;
+	struct resource *res;
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
+	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "%s: Could not allocate pcdev\n",
+			__FUNCTION__);
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	pcdev->clk = clk_get(&pdev->dev, "CAMCLK");
+	if (IS_ERR(pcdev->clk)) {
+		err = PTR_ERR(pcdev->clk);
+		goto exit_kfree;
+	}
+
+	dev_set_drvdata(&pdev->dev, pcdev);
+	pcdev->res = res;
+
+	pcdev->pdata = pdev->dev.platform_data;
+	pcdev->platform_flags = pcdev->pdata->flags;
+	if (!pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
+			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10)) {
+		/* Platform hasn't set available data widths. This is bad.
+		 * Warn and use a default. */
+		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
+			 "data widths, using default 10 bit\n");
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
+	}
+	pcdev->platform_mclk_10khz = pcdev->pdata->mclk_10khz;
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
+				PXA_CAM_DRV_NAME)) {
+		err = -EBUSY;
+		goto exit_clk;
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
+	pcdev->dma_chan_y = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
+					    pxa_camera_dma_irq_y, pcdev);
+	if (pcdev->dma_chan_y < 0) {
+		dev_err(pcdev->dev, "Can't request DMA for Y\n");
+		err = -ENOMEM;
+		goto exit_iounmap;
+	}
+	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chan_y);
+
+	DRCMR68 = pcdev->dma_chan_y  | DRCMR_MAPVLD;
+
+	/* request irq */
+	err = request_irq(pcdev->irq, pxa_camera_irq, 0, PXA_CAM_DRV_NAME,
+			  pcdev);
+	if (err) {
+		dev_err(pcdev->dev, "Camera interrupt register failed \n");
+		goto exit_free_dma;
+	}
+
+	pxa_soc_camera_host.priv	= pcdev;
+	pxa_soc_camera_host.dev.parent	= &pdev->dev;
+	pxa_soc_camera_host.nr		= pdev->id;
+	err = soc_camera_host_register(&pxa_soc_camera_host, THIS_MODULE);
+	if (err)
+		goto exit_free_irq;
+
+	return 0;
+
+exit_free_irq:
+	free_irq(pcdev->irq, pcdev);
+exit_free_dma:
+	pxa_free_dma(pcdev->dma_chan_y);
+exit_iounmap:
+	iounmap(base);
+exit_release:
+	release_mem_region(res->start, res->end - res->start + 1);
+exit_clk:
+	clk_put(pcdev->clk);
+exit_kfree:
+	kfree(pcdev);
+exit:
+	return err;
+}
+
+static int __devexit pxa_camera_remove(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	clk_put(pcdev->clk);
+
+	pxa_free_dma(pcdev->dma_chan_y);
+	free_irq(pcdev->irq, pcdev);
+
+	soc_camera_host_unregister(&pxa_soc_camera_host);
+
+	iounmap(pcdev->base);
+
+	res = pcdev->res;
+	release_mem_region(res->start, res->end - res->start + 1);
+
+	kfree(pcdev);
+
+	dev_info(&pdev->dev, "%s: PXA Camera driver unloaded\n", __FUNCTION__);
+
+	return 0;
+}
+
+/*
+ * Suspend the Camera Module.
+ */
+static int pxa_camera_suspend(struct platform_device *pdev, pm_message_t level)
+{
+	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+
+	dev_info(&pdev->dev, "camera suspend\n");
+	disable_irq(pcdev->irq);
+	return 0;
+}
+
+/*
+ * Resume the Camera Module.
+ */
+static int pxa_camera_resume(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+
+	dev_info(&pdev->dev, "camera resume\n");
+	enable_irq(pcdev->irq);
+
+/* 	if (pcdev) {	*/ /* FIXME: dev in use? */
+/* 		DRCMR68 = pcdev->dma_chan_y  | DRCMR_MAPVLD; */
+/* 		DRCMR69 = pcdev->dma_chan_cb | DRCMR_MAPVLD; */
+/* 		DRCMR70 = pcdev->dma_chan_cr | DRCMR_MAPVLD; */
+/* 	} */
+
+	return 0;
+}
+
+
+static struct platform_driver pxa_camera_driver = {
+	.driver 	= {
+		.name	= PXA_CAM_DRV_NAME,
+	},
+	.probe		= pxa_camera_probe,
+	.remove		= __exit_p(pxa_camera_remove),
+	.suspend	= pxa_camera_suspend,
+	.resume		= pxa_camera_resume,
+};
+
+
+static int __devinit pxa_camera_init(void)
+{
+	return platform_driver_register(&pxa_camera_driver);
+}
+
+static void __exit pxa_camera_exit(void)
+{
+	return platform_driver_unregister(&pxa_camera_driver);
+}
+
+module_init(pxa_camera_init);
+module_exit(pxa_camera_exit);
+
+MODULE_DESCRIPTION("PXA27x SoC Camera Host driver");
+MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL");
diff --git a/include/asm-arm/arch-pxa/camera.h b/include/asm-arm/arch-pxa/camera.h
new file mode 100644
index 0000000..39516ce
--- /dev/null
+++ b/include/asm-arm/arch-pxa/camera.h
@@ -0,0 +1,48 @@
+/*
+    camera.h - PXA camera driver header file
+
+    Copyright (C) 2003, Intel Corporation
+    Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#ifndef __ASM_ARCH_CAMERA_H_
+#define __ASM_ARCH_CAMERA_H_
+
+#define PXA_CAMERA_MASTER	1
+#define PXA_CAMERA_DATAWIDTH_4	2
+#define PXA_CAMERA_DATAWIDTH_5	4
+#define PXA_CAMERA_DATAWIDTH_8	8
+#define PXA_CAMERA_DATAWIDTH_9	0x10
+#define PXA_CAMERA_DATAWIDTH_10	0x20
+#define PXA_CAMERA_PCLK_EN	0x40
+#define PXA_CAMERA_MCLK_EN	0x80
+#define PXA_CAMERA_PCP		0x100
+#define PXA_CAMERA_HSP		0x200
+#define PXA_CAMERA_VSP		0x400
+
+struct pxacamera_platform_data {
+	int (*init)(struct device *);
+	int (*power)(struct device *, int);
+	int (*reset)(struct device *, int);
+
+	unsigned long flags;
+	unsigned long mclk_10khz;
+};
+
+extern void pxa_set_camera_info(struct pxacamera_platform_data *);
+
+#endif /* __ASM_ARCH_CAMERA_H_ */
diff --git a/include/asm-arm/arch-pxa/pxa-regs.h b/include/asm-arm/arch-pxa/pxa-regs.h
index ac175b4..8dd9334 100644
--- a/include/asm-arm/arch-pxa/pxa-regs.h
+++ b/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1245,19 +1245,26 @@
 #define GPIO10_RTCCLK		10	/* real time clock (1 Hz) */
 #define GPIO11_3_6MHz		11	/* 3.6 MHz oscillator out */
 #define GPIO12_32KHz		12	/* 32 kHz out */
+#define GPIO12_CIF_DD7		12	/* Capture Interface D7 (PXA27x) */
 #define GPIO13_MBGNT		13	/* memory controller grant */
 #define GPIO14_MBREQ		14	/* alternate bus master request */
 #define GPIO15_nCS_1		15	/* chip select 1 */
 #define GPIO16_PWM0		16	/* PWM0 output */
 #define GPIO17_PWM1		17	/* PWM1 output */
+#define GPIO17_CIF_DD6		17	/* Capture Interface D6 (PXA27x) */
 #define GPIO18_RDY		18	/* Ext. Bus Ready */
 #define GPIO19_DREQ1		19	/* External DMA Request */
 #define GPIO20_DREQ0		20	/* External DMA Request */
 #define GPIO23_SCLK		23	/* SSP clock */
+#define GPIO23_CIF_MCLK		23	/* Capture Interface MCLK (PXA27x) */
 #define GPIO24_SFRM		24	/* SSP Frame */
+#define GPIO24_CIF_FV		24	/* Capture Interface FV (PXA27x) */
 #define GPIO25_STXD		25	/* SSP transmit */
+#define GPIO25_CIF_LV		25	/* Capture Interface LV (PXA27x) */
 #define GPIO26_SRXD		26	/* SSP receive */
+#define GPIO26_CIF_PCLK		26	/* Capture Interface PCLK (PXA27x) */
 #define GPIO27_SEXTCLK		27	/* SSP ext_clk */
+#define GPIO27_CIF_DD0		27	/* Capture Interface D0 (PXA27x) */
 #define GPIO28_BITCLK		28	/* AC97/I2S bit_clk */
 #define GPIO29_SDATA_IN		29	/* AC97 Sdata_in0 / I2S Sdata_in */
 #define GPIO30_SDATA_OUT	30	/* AC97/I2S Sdata_out */
@@ -1278,28 +1285,40 @@
 #define GPIO41_FFRTS		41	/* FFUART request to send */
 #define GPIO42_BTRXD		42	/* BTUART receive data */
 #define GPIO42_HWRXD		42	/* HWUART receive data */
+#define GPIO42_CIF_MCLK		42	/* Capture interface MCLK (PXA27x) */
 #define GPIO43_BTTXD		43	/* BTUART transmit data */
 #define GPIO43_HWTXD		43	/* HWUART transmit data */
+#define GPIO43_CIF_FV		43	/* Capture interface FV (PXA27x) */
 #define GPIO44_BTCTS		44	/* BTUART clear to send */
 #define GPIO44_HWCTS		44	/* HWUART clear to send */
+#define GPIO44_CIF_LV		44	/* Capture interface LV (PXA27x) */
 #define GPIO45_BTRTS		45	/* BTUART request to send */
 #define GPIO45_HWRTS		45	/* HWUART request to send */
 #define GPIO45_AC97_SYSCLK	45	/* AC97 System Clock */
+#define GPIO45_CIF_PCLK		45	/* Capture interface PCLK (PXA27x) */
 #define GPIO46_ICPRXD		46	/* ICP receive data */
 #define GPIO46_STRXD		46	/* STD_UART receive data */
 #define GPIO47_ICPTXD		47	/* ICP transmit data */
 #define GPIO47_STTXD		47	/* STD_UART transmit data */
+#define GPIO47_CIF_DD0		47	/* Capture interface D0 (PXA27x) */
 #define GPIO48_nPOE		48	/* Output Enable for Card Space */
+#define GPIO48_CIF_DD5		48	/* Capture interface D5 (PXA27x) */
 #define GPIO49_nPWE		49	/* Write Enable for Card Space */
 #define GPIO50_nPIOR		50	/* I/O Read for Card Space */
+#define GPIO50_CIF_DD3		50	/* Capture interface D3 (PXA27x) */
 #define GPIO51_nPIOW		51	/* I/O Write for Card Space */
+#define GPIO51_CIF_DD2		51	/* Capture interface D2 (PXA27x) */
 #define GPIO52_nPCE_1		52	/* Card Enable for Card Space */
+#define GPIO52_CIF_DD4		52	/* Capture interface D4 (PXA27x) */
 #define GPIO53_nPCE_2		53	/* Card Enable for Card Space */
 #define GPIO53_MMCCLK		53	/* MMC Clock */
+#define GPIO53_CIF_MCLK		53	/* Capture interface MCLK (PXA27x) */
 #define GPIO54_MMCCLK		54	/* MMC Clock */
 #define GPIO54_pSKTSEL		54	/* Socket Select for Card Space */
 #define GPIO54_nPCE_2		54	/* Card Enable for Card Space (PXA27x) */
+#define GPIO54_CIF_PCLK		54	/* Capture interface PCLK (PXA27x) */
 #define GPIO55_nPREG		55	/* Card Address bit 26 */
+#define GPIO55_CIF_DD1		55	/* Capture interface D1 (PXA27x) */
 #define GPIO56_nPWAIT		56	/* Wait signal for Card Space */
 #define GPIO57_nIOIS16		57	/* Bus Width select for I/O Card Space */
 #define GPIO58_LDD_0		58	/* LCD data pin 0 */
@@ -1334,11 +1353,28 @@
 #define GPIO79_nCS_3		79	/* chip select 3 */
 #define GPIO80_nCS_4		80	/* chip select 4 */
 #define GPIO81_NSCLK		81	/* NSSP clock */
+#define GPIO81_CIF_DD0		81	/* Capture Interface D0 (PXA27x) */
 #define GPIO82_NSFRM		82	/* NSSP Frame */
+#define GPIO82_CIF_DD5		82	/* Capture Interface D5 (PXA27x) */
 #define GPIO83_NSTXD		83	/* NSSP transmit */
+#define GPIO83_CIF_DD4		83	/* Capture Interface D4 (PXA27x) */
 #define GPIO84_NSRXD		84	/* NSSP receive */
+#define GPIO84_CIF_FV		84	/* Capture Interface FV (PXA27x) */
 #define GPIO85_nPCE_1		85	/* Card Enable for Card Space (PXA27x) */
+#define GPIO85_CIF_LV		85	/* Capture Interface LV (PXA27x) */
+#define GPIO90_CIF_DD4		90	/* Capture Interface DD4 (PXA27x) */
+#define GPIO91_CIF_DD5		91	/* Capture Interface DD5 (PXA27x) */
 #define GPIO92_MMCDAT0		92	/* MMC DAT0 (PXA27x) */
+#define GPIO93_CIF_DD6		93	/* Capture interface D6 (PXA27x) */
+#define GPIO94_CIF_DD5		94	/* Capture interface D5 (PXA27x) */
+#define GPIO95_CIF_DD4		95	/* Capture interface D4 (PXA27x) */
+#define GPIO98_CIF_DD0		98	/* Capture interface D0 (PXA27x) */
+#define GPIO103_CIF_DD3		103	/* Capture interface D3 (PXA27x) */
+#define GPIO104_CIF_DD2		104	/* Capture interface D2 (PXA27x) */
+#define GPIO105_CIF_DD1		105	/* Capture interface D1 (PXA27x) */
+#define GPIO106_CIF_DD9		106	/* Capture interface D9 (PXA27x) */
+#define GPIO107_CIF_DD8		107	/* Capture interface D8 (PXA27x) */
+#define GPIO108_CIF_DD7		108	/* Capture interface D7 (PXA27x) */
 #define GPIO102_nPCE_1		102	/* PCMCIA (PXA27x) */
 #define GPIO109_MMCDAT1		109	/* MMC DAT1 (PXA27x) */
 #define GPIO110_MMCDAT2		110	/* MMC DAT2 (PXA27x) */
@@ -1348,6 +1384,9 @@
 #define GPIO112_MMCCMD		112	/* MMC CMD (PXA27x) */
 #define GPIO113_I2S_SYSCLK	113	/* I2S System Clock (PXA27x) */
 #define GPIO113_AC97_RESET_N	113	/* AC97 NRESET on (PXA27x) */
+#define GPIO114_CIF_DD1		114	/* Capture interface D1 (PXA27x) */
+#define GPIO115_CIF_DD3		115	/* Capture interface D3 (PXA27x) */
+#define GPIO116_CIF_DD2		116	/* Capture interface D2 (PXA27x) */
 
 /* GPIO alternate function mode & direction */
 
@@ -1373,19 +1412,26 @@
 #define GPIO10_RTCCLK_MD	(10 | GPIO_ALT_FN_1_OUT)
 #define GPIO11_3_6MHz_MD	(11 | GPIO_ALT_FN_1_OUT)
 #define GPIO12_32KHz_MD		(12 | GPIO_ALT_FN_1_OUT)
+#define GPIO12_CIF_DD7_MD	(12 | GPIO_ALT_FN_2_IN)
 #define GPIO13_MBGNT_MD		(13 | GPIO_ALT_FN_2_OUT)
 #define GPIO14_MBREQ_MD		(14 | GPIO_ALT_FN_1_IN)
 #define GPIO15_nCS_1_MD		(15 | GPIO_ALT_FN_2_OUT)
 #define GPIO16_PWM0_MD		(16 | GPIO_ALT_FN_2_OUT)
 #define GPIO17_PWM1_MD		(17 | GPIO_ALT_FN_2_OUT)
+#define GPIO17_CIF_DD6_MD	(17 | GPIO_ALT_FN_2_IN)
 #define GPIO18_RDY_MD		(18 | GPIO_ALT_FN_1_IN)
 #define GPIO19_DREQ1_MD		(19 | GPIO_ALT_FN_1_IN)
 #define GPIO20_DREQ0_MD		(20 | GPIO_ALT_FN_1_IN)
+#define GPIO23_CIF_MCLK_MD	(23 | GPIO_ALT_FN_1_OUT)
 #define GPIO23_SCLK_MD		(23 | GPIO_ALT_FN_2_OUT)
+#define GPIO24_CIF_FV_MD	(24 | GPIO_ALT_FN_1_OUT)
 #define GPIO24_SFRM_MD		(24 | GPIO_ALT_FN_2_OUT)
+#define GPIO25_CIF_LV_MD	(25 | GPIO_ALT_FN_1_OUT)
 #define GPIO25_STXD_MD		(25 | GPIO_ALT_FN_2_OUT)
 #define GPIO26_SRXD_MD		(26 | GPIO_ALT_FN_1_IN)
+#define GPIO26_CIF_PCLK_MD	(26 | GPIO_ALT_FN_2_IN)
 #define GPIO27_SEXTCLK_MD	(27 | GPIO_ALT_FN_1_IN)
+#define GPIO27_CIF_DD0_MD	(27 | GPIO_ALT_FN_3_IN)
 #define GPIO28_BITCLK_AC97_MD	(28 | GPIO_ALT_FN_1_IN)
 #define GPIO28_BITCLK_IN_I2S_MD	(28 | GPIO_ALT_FN_2_IN)
 #define GPIO28_BITCLK_OUT_I2S_MD	(28 | GPIO_ALT_FN_1_OUT)
@@ -1410,34 +1456,46 @@
 #define GPIO40_FFDTR_MD		(40 | GPIO_ALT_FN_2_OUT)
 #define GPIO41_FFRTS_MD		(41 | GPIO_ALT_FN_2_OUT)
 #define GPIO42_BTRXD_MD		(42 | GPIO_ALT_FN_1_IN)
+#define GPIO42_CIF_MCLK_MD	(42 | GPIO_ALT_FN_3_OUT)
 #define GPIO42_HWRXD_MD		(42 | GPIO_ALT_FN_3_IN)
 #define GPIO43_BTTXD_MD		(43 | GPIO_ALT_FN_2_OUT)
+#define GPIO43_CIF_FV_MD	(43 | GPIO_ALT_FN_3_OUT)
 #define GPIO43_HWTXD_MD		(43 | GPIO_ALT_FN_3_OUT)
 #define GPIO44_BTCTS_MD		(44 | GPIO_ALT_FN_1_IN)
 #define GPIO44_HWCTS_MD		(44 | GPIO_ALT_FN_3_IN)
+#define GPIO44_CIF_LV_MD	(44 | GPIO_ALT_FN_3_OUT)
 #define GPIO45_BTRTS_MD		(45 | GPIO_ALT_FN_2_OUT)
 #define GPIO45_HWRTS_MD		(45 | GPIO_ALT_FN_3_OUT)
 #define GPIO45_SYSCLK_AC97_MD		(45 | GPIO_ALT_FN_1_OUT)
+#define GPIO45_CIF_PCLK_MD	(45 | GPIO_ALT_FN_3_IN)
 #define GPIO46_ICPRXD_MD	(46 | GPIO_ALT_FN_1_IN)
 #define GPIO46_STRXD_MD		(46 | GPIO_ALT_FN_2_IN)
 #define GPIO47_ICPTXD_MD	(47 | GPIO_ALT_FN_2_OUT)
 #define GPIO47_STTXD_MD		(47 | GPIO_ALT_FN_1_OUT)
+#define GPIO47_CIF_DD0_MD	(47 | GPIO_ALT_FN_1_IN)
 #define GPIO48_nPOE_MD		(48 | GPIO_ALT_FN_2_OUT)
+#define GPIO48_CIF_DD5_MD	(48 | GPIO_ALT_FN_1_IN)
 #define GPIO48_HWTXD_MD         (48 | GPIO_ALT_FN_1_OUT)
 #define GPIO48_nPOE_MD          (48 | GPIO_ALT_FN_2_OUT)
 #define GPIO49_HWRXD_MD		(49 | GPIO_ALT_FN_1_IN)
 #define GPIO49_nPWE_MD		(49 | GPIO_ALT_FN_2_OUT)
 #define GPIO50_nPIOR_MD		(50 | GPIO_ALT_FN_2_OUT)
+#define GPIO50_CIF_DD3_MD	(50 | GPIO_ALT_FN_1_IN)
 #define GPIO50_HWCTS_MD         (50 | GPIO_ALT_FN_1_IN)
 #define GPIO51_HWRTS_MD         (51 | GPIO_ALT_FN_1_OUT)
 #define GPIO51_nPIOW_MD		(51 | GPIO_ALT_FN_2_OUT)
+#define GPIO51_CIF_DD2_MD	(51 | GPIO_ALT_FN_1_IN)
 #define GPIO52_nPCE_1_MD	(52 | GPIO_ALT_FN_2_OUT)
+#define GPIO52_CIF_DD4_MD	(52 | GPIO_ALT_FN_1_IN)
 #define GPIO53_nPCE_2_MD	(53 | GPIO_ALT_FN_2_OUT)
 #define GPIO53_MMCCLK_MD	(53 | GPIO_ALT_FN_1_OUT)
+#define GPIO53_CIF_MCLK_MD	(53 | GPIO_ALT_FN_2_OUT)
 #define GPIO54_MMCCLK_MD	(54 | GPIO_ALT_FN_1_OUT)
 #define GPIO54_nPCE_2_MD	(54 | GPIO_ALT_FN_2_OUT)
 #define GPIO54_pSKTSEL_MD	(54 | GPIO_ALT_FN_2_OUT)
+#define GPIO54_CIF_PCLK_MD	(54 | GPIO_ALT_FN_3_IN)
 #define GPIO55_nPREG_MD		(55 | GPIO_ALT_FN_2_OUT)
+#define GPIO55_CIF_DD1_MD	(55 | GPIO_ALT_FN_1_IN)
 #define GPIO56_nPWAIT_MD	(56 | GPIO_ALT_FN_1_IN)
 #define GPIO57_nIOIS16_MD	(57 | GPIO_ALT_FN_1_IN)
 #define GPIO58_LDD_0_MD		(58 | GPIO_ALT_FN_2_OUT)
@@ -1474,16 +1532,33 @@
 #define GPIO80_nCS_4_MD		(80 | GPIO_ALT_FN_2_OUT)
 #define GPIO81_NSSP_CLK_OUT 	(81 | GPIO_ALT_FN_1_OUT)
 #define GPIO81_NSSP_CLK_IN  	(81 | GPIO_ALT_FN_1_IN)
+#define GPIO81_CIF_DD0_MD	(81 | GPIO_ALT_FN_2_IN)
 #define GPIO82_NSSP_FRM_OUT 	(82 | GPIO_ALT_FN_1_OUT)
 #define GPIO82_NSSP_FRM_IN  	(82 | GPIO_ALT_FN_1_IN)
+#define GPIO82_CIF_DD5_MD	(82 | GPIO_ALT_FN_3_IN)
 #define GPIO83_NSSP_TX      	(83 | GPIO_ALT_FN_1_OUT)
 #define GPIO83_NSSP_RX      	(83 | GPIO_ALT_FN_2_IN)
+#define GPIO83_CIF_DD4_MD	(83 | GPIO_ALT_FN_3_IN)
 #define GPIO84_NSSP_TX      	(84 | GPIO_ALT_FN_1_OUT)
 #define GPIO84_NSSP_RX      	(84 | GPIO_ALT_FN_2_IN)
+#define GPIO84_CIF_FV_MD	(84 | GPIO_ALT_FN_3_OUT)
 #define GPIO85_nPCE_1_MD	(85 | GPIO_ALT_FN_1_OUT)
+#define GPIO85_CIF_LV_MD	(85 | GPIO_ALT_FN_3_OUT)
+#define GPIO90_CIF_DD4_MD	(90 | GPIO_ALT_FN_3_IN)
+#define GPIO91_CIF_DD5_MD	(91 | GPIO_ALT_FN_3_IN)
 #define GPIO92_MMCDAT0_MD	(92 | GPIO_ALT_FN_1_OUT)
+#define GPIO93_CIF_DD6_MD	(93 | GPIO_ALT_FN_2_IN)
+#define GPIO94_CIF_DD5_MD	(94 | GPIO_ALT_FN_2_IN)
+#define GPIO95_CIF_DD4_MD	(95 | GPIO_ALT_FN_2_IN)
+#define GPIO98_CIF_DD0_MD	(98 | GPIO_ALT_FN_2_IN)
 #define GPIO102_nPCE_1_MD	(102 | GPIO_ALT_FN_1_OUT)
+#define GPIO103_CIF_DD3_MD	(103 | GPIO_ALT_FN_1_IN)
 #define GPIO104_pSKTSEL_MD	(104 | GPIO_ALT_FN_1_OUT)
+#define GPIO104_CIF_DD2_MD	(104 | GPIO_ALT_FN_1_IN)
+#define GPIO105_CIF_DD1_MD	(105 | GPIO_ALT_FN_1_IN)
+#define GPIO106_CIF_DD9_MD	(106 | GPIO_ALT_FN_1_IN)
+#define GPIO107_CIF_DD8_MD	(107 | GPIO_ALT_FN_1_IN)
+#define GPIO108_CIF_DD7_MD	(108 | GPIO_ALT_FN_1_IN)
 #define GPIO109_MMCDAT1_MD	(109 | GPIO_ALT_FN_1_OUT)
 #define GPIO110_MMCDAT2_MD	(110 | GPIO_ALT_FN_1_OUT)
 #define GPIO110_MMCCS0_MD	(110 | GPIO_ALT_FN_1_OUT)
@@ -1938,6 +2013,11 @@
 #define CICR0_ENB	(1 << 28)	/* Camera interface enable */
 #define CICR0_DIS	(1 << 27)	/* Camera interface disable */
 #define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
+#define CICR0_SIM_MP	(0 << 24)
+#define CICR0_SIM_SP	(1 << 24)
+#define CICR0_SIM_MS	(2 << 24)
+#define CICR0_SIM_EP	(3 << 24)
+#define CICR0_SIM_ES	(4 << 24)
 #define CICR0_TOM	(1 << 9)	/* Time-out mask */
 #define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
 #define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
@@ -1988,6 +2068,20 @@
 #define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
 #define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
 
+#define CICR1_DW_VAL(x)		((x) & CICR1_DW)		/* Data bus width */
+#define CICR1_PPL_VAL(x)	(((x) << 15) & CICR1_PPL)	/* Pixels per line */
+
+#define CICR2_BLW_VAL(x)	(((x) << 24) & CICR2_BLW)	/* Beginning-of-line pixel clock wait count */
+#define CICR2_ELW_VAL(x)	(((x) << 16) & CICR2_ELW)	/* End-of-line pixel clock wait count */
+#define CICR2_HSW_VAL(x)	(((x) << 10) & CICR2_HSW)	/* Horizontal sync pulse width */
+#define CICR2_BFPW_VAL(x)	(((x) << 3) & CICR2_BFPW)	/* Beginning-of-frame pixel clock wait count */
+#define CICR2_FSW_VAL(x)	(((x) << 0) & CICR2_FSW)	/* Frame stabilization wait count */
+
+#define CICR3_BFW_VAL(x)	(((x) << 24) & CICR3_BFW)	/* Beginning-of-frame line clock wait count  */
+#define CICR3_EFW_VAL(x)	(((x) << 16) & CICR3_EFW)	/* End-of-frame line clock wait count */
+#define CICR3_VSW_VAL(x)	(((x) << 11) & CICR3_VSW)	/* Vertical sync pulse width */
+#define CICR3_LPF_VAL(x)	(((x) << 0) & CICR3_LPF)	/* Lines per frame */
+
 #define CISR_FTO	(1 << 15)	/* FIFO time-out */
 #define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
 #define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
-- 
1.5.3.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
