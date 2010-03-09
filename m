Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o298nAfL031548
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 03:49:10 -0500
Received: from gateway.tuioptics.com (gateway.tuioptics.com [213.183.22.85])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o298mrJE023806
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 03:48:55 -0500
Received: from tomcat.toptica.com (localhost [127.0.0.1])
	by gateway.tuioptics.com (8.13.6/8.13.6/SuSE Linux 0.8) with ESMTP id
	o298mr3Z007492
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 09:48:53 +0100
Date: Tue, 9 Mar 2010 09:46:26 +0100
From: Arno Euteneuer <arno.euteneuer@toptica.com>
To: video4linux-list@redhat.com
Message-ID: <4B960AE2.3090803@toptica.com>
Subject: soc-camera driver for i.MX25
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
I wrote a soc-camera driver for the i.MX25 which seems to work well on my setup 
with a monochrome mt9m001 camera chip if I use the full resolution of 10bits x 
1280 x 1024 and up to three buffers. However, reducing the frame size to e.g. 
640 x 480 leads to corrupted pictures sometimes when using multiple buffers. 
Using only one buffer for single shots seems to work always.
Unfortunately for my application I don't need streaming at all and single shots 
is all I need, which is why I will have to stop working on this topic soon and 
focus on my user space problem again. Furthermore I will not be able to test it 
with other camera chips.
Nevertheless I would like to contribute my work. Maybe somebody is interested or 
even is able to improve it.
The patch is against kernel 2.6.31 (sorry).

Regards,
Arno


diff --git a/arch/arm/plat-mxc/include/mach/memory.h 
b/arch/arm/plat-mxc/include/mach/memory.h
index 6065e00..5cb9ac1 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -22,6 +22,8 @@
  #endif
  #elif defined CONFIG_ARCH_MX3
  #define PHYS_OFFSET		UL(0x80000000)
+#elif defined CONFIG_ARCH_MX25
+#define PHYS_OFFSET		UL(0x80000000)
  #endif

  #if defined(CONFIG_MX1_VIDEO)
@@ -40,4 +42,12 @@
  #define CONSISTENT_DMA_SIZE SZ_8M
  #endif /* CONFIG_MX3_VIDEO */

+#if defined(CONFIG_MX25_VIDEO)
+/*
+ * Increase size of DMA-consistent memory region.
+ * This is required for mx25 camera driver to capture at least two QXGA frames.
+ */
+#define CONSISTENT_DMA_SIZE SZ_8M
+#endif /* CONFIG_MX25_VIDEO */
+
  #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
diff --git a/arch/arm/plat-mxc/include/mach/mx25_camera.h 
b/arch/arm/plat-mxc/include/mach/mx25_camera.h
new file mode 100644
index 0000000..3dc3219
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/mx25_camera.h
@@ -0,0 +1,39 @@
+/*
+ * mx25_camera.h - i.MX25 driver header file
+ * Copyright (C) 2009, Arno Euteneuer <arno.euteneuer@toptica.com>
+ *
+ * Based on i.MXL/i.MXL camera (CSI) host driver
+ * Copyright (c) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
+ *
+ * Based on PXA camera.h file:
+ * Copyright (C) 2003, Intel Corporation
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_CAMERA_H_
+#define __ASM_ARCH_CAMERA_H_
+
+#define MX25_CAMERA_DATA_HIGH	1
+#define MX25_CAMERA_PCLK_RISING	2
+#define MX25_CAMERA_VSYNC_HIGH	4
+#define MX25_CAMERA_DATAWIDTH_8		8
+#define MX25_CAMERA_DATAWIDTH_10	16
+#define MX25_CAMERA_DATAWIDTH_16	32
+
+
+/**
+ * struct mx1_camera_pdata - i.MX25/i.MXL camera platform data
+ * @mclk_10khz:	master clock frequency in 10kHz units
+ * @flags:	MX25 camera platform flags
+ */
+struct mx25_camera_pdata {
+	unsigned long mclk_10khz;
+	unsigned long flags;
+};
+
+#endif /* __ASM_ARCH_CAMERA_H_ */
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index dcf9fa9..c81285e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -784,6 +784,18 @@ config VIDEO_MX1
  	---help---
  	  This is a v4l2 driver for the i.MX1/i.MXL CMOS Sensor Interface

+
+config MX25_VIDEO
+	bool
+
+config VIDEO_MX25
+	tristate "i.MX25 CMOS Sensor Interface driver"
+	depends on VIDEO_DEV && ARCH_MX25 && SOC_CAMERA
+	select VIDEOBUF_DMA_CONTIG
+	select MX25_VIDEO
+	---help---
+	  This is a v4l2 driver for the i.MX25 CMOS Sensor Interface
+
  config MX3_VIDEO
  	bool

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 9f2e321..3b992af 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -150,6 +150,7 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
  obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
  # soc-camera host drivers have to be linked after camera drivers
  obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
+obj-$(CONFIG_VIDEO_MX25)		+= mx25_camera.o
  obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
  obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
diff --git a/drivers/media/video/mx25_camera.c b/drivers/media/video/mx25_camera.c
new file mode 100644
index 0000000..0a7a91a
--- /dev/null
+++ b/drivers/media/video/mx25_camera.c
@@ -0,0 +1,925 @@
+/*
+ * V4L2 Driver for i.MX25 camera (CSI) host
+ *
+ * Copyright (C) 2009, Arno Euteneuer <arno.euteneuer@toptica.com>
+ *
+ * Based on i.MXL/i.MXL camera (CSI) host driver
+ * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
+ * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
+ *
+ * Based on PXA SoC camera driver
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+
+#include <media/soc_camera.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf-dma-contig.h>
+
+#include <mach/dma-mx1-mx2.h>
+#include <mach/hardware.h>
+#include <mach/mx25_camera.h>
+
+
+/*
+ * CSI registers
+ */
+#define CSICR1		0x00			/* CSI Control Register 1 */
+#define CSICR2		0x04			/* CSI Control Register 2 */
+#define CSICR3		0x08			/* CSI Control Register 3 */
+#define CSIRXR		0x10			/* CSI RxFIFO Register */
+#define CSIRXCNT	0x14
+#define CSISR		0x18			/* CSI Status Register */
+
+#define CSIDMASA_FB1		0x28	/* framebuffer FB1 start address */
+#define CSIDMASA_FB2		0x2c
+#define CSIFBUF_PARA		0x30	/* framebuffer stride register */
+#define CSIIMAG_PARA		0x34	/* frame size register for DMA */
+
+#define CSICR1_EOF_INT_EN	(1 << 29)
+#define CSICR1_RXFF_INTEN	(1 << 18)
+#define CSICR1_SOF_POL		(1 << 17)
+#define CSICR1_SOF_INTEN	(1 << 16)
+#define CSICR1_MCLKDIV(x)	(((x) & 0xf) << 12)
+#define CSICR1_HSYNC_POL	(1 << 11)
+#define CSICR1_MCLKEN		(1 << 9)
+#define CSICR1_FCC			(1 << 8)
+#define CSICR1_BIG_ENDIAN	(1 << 7)
+#define CSICR1_CLR_RXFIFO	(1 << 5)
+#define CSICR1_GCLK_MODE	(1 << 4)
+#define CSICR1_DATA_POL		(1 << 2)
+#define CSICR1_REDGE		(1 << 1)
+#define CSICR1_PIXEL_BIT	(1 << 0)
+
+#define CSISR_SFF_OR_INT		(1 << 25)
+#define CSISR_RFF_OR_INT		(1 << 24)
+#define CSISR_DMA_TSF_DONE_SFF	(1 << 22)
+#define CSISR_STATFF_INT		(1 << 21)
+#define CSISR_DMA_TSF_DONE_FB2	(1 << 20)
+#define CSISR_DMA_TSF_DONE_FB1	(1 << 19)
+#define CSISR_RXFF_INT			(1 << 18)
+#define CSISR_EOF_INT			(1 << 17)
+#define CSISR_SOF_INT			(1 << 16)
+#define CSISR_F2_INT			(1 << 15)
+#define CSISR_F1_INT			(1 << 14)
+#define CSISR_COF_INT			(1 << 13)
+#define CSISR_HRESP_ERR_INT		(1 << 7)
+#define CSISR_ECC_INT			(1 << 1)
+#define CSISR_DRDY				(1 << 0)
+
+#define CSICR2_DMA_BURST_TYPE_RFF	30
+#define DMA_BURST_TYPE_MASK		(3 << CSICR2_DMA_BURST_TYPE_RFF)
+#define DMA_BURST_TYPE_INCR8	(0 << CSICR2_DMA_BURST_TYPE_RFF)
+#define DMA_BURST_TYPE_INCR4	(1 << CSICR2_DMA_BURST_TYPE_RFF)
+#define DMA_BURST_TYPE_INCR16	(3 << CSICR2_DMA_BURST_TYPE_RFF)
+
+#define CSICR3_FRMCNT_RST		(1 << 15)
+#define CSICR3_DMA_REFLASH_RFF	(1 << 14)
+#define CSICR3_DMA_REQ_EN_RFF	(1 << 12)
+#define CSICR3_DMA_REQ_EN_SFF	(1 << 11)
+#define CSICR3_16BIT_SENSOR		(1 << 3)
+#define CSICR3_RXFF_LEVEL(x)	(((x) & 0x07) << 4)
+
+
+
+
+#define VERSION_CODE KERNEL_VERSION(0, 0, 1)
+#define DRIVER_NAME "mx25-camera"
+
+#define CSI_IRQ_MASK	(CSISR_SFF_OR_INT | CSISR_RFF_OR_INT \
+		| CSISR_DMA_TSF_DONE_SFF | CSISR_STATFF_INT \
+		| CSISR_DMA_TSF_DONE_FB2 | CSISR_DMA_TSF_DONE_FB1 \
+		| CSISR_RXFF_INT | CSISR_EOF_INT \
+		| CSISR_SOF_INT	| CSISR_F2_INT \
+		| CSISR_F1_INT | CSISR_COF_INT \
+		| CSISR_HRESP_ERR_INT | CSISR_ECC_INT)
+
+#define CSI_BUS_FLAGS	(SOCAM_MASTER \
+		| SOCAM_HSYNC_ACTIVE_HIGH \
+		| SOCAM_VSYNC_ACTIVE_HIGH \
+		| SOCAM_VSYNC_ACTIVE_LOW \
+		| SOCAM_PCLK_SAMPLE_RISING \
+		| SOCAM_PCLK_SAMPLE_FALLING \
+		| SOCAM_DATA_ACTIVE_HIGH \
+		| SOCAM_DATA_ACTIVE_LOW \
+		| SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_10 \
+		| SOCAM_DATAWIDTH_16)
+
+#define MAX_VIDEO_MEM 8	/* Video memory limit in megabytes */
+/* see /arch/arm/plat-mxc/include/mach/memory.h */
+
+/* buffer for one video frame */
+struct mx25_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer vb;
+	const struct soc_camera_data_format *fmt;
+};
+
+/* i.MX25 is only supposed to handle one camera on its Camera Sensor
+ * Interface. If anyone ever builds hardware to enable more than
+ * one camera, they will have to modify this driver too */
+struct mx25_camera_dev {
+	struct soc_camera_host		soc_host;
+	struct soc_camera_device	*icd;
+	struct mx25_camera_pdata	*pdata;
+	struct mx25_buffer		*active;
+	struct resource			*res;
+	struct clk				*clk;
+	struct list_head		capture;
+
+	void __iomem			*base;
+	void __iomem			*csicr1;
+	void __iomem			*csicr2;
+	void __iomem			*csicr3;
+	void __iomem			*csisr;
+	unsigned int			irq;
+	unsigned long			mclk;
+
+	spinlock_t			lock;
+};
+
+/*
+ *  Videobuf operations
+ */
+static int mx25_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
+			      unsigned int *size)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+
+	*size = icd->width * icd->height *
+		((icd->current_fmt->depth + 7) >> 3);
+
+	if (!*count)
+		*count = 32;
+
+	while (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		(*count)--;
+
+	dev_dbg(&icd->dev,
+			"width=%d, height=%d, depth=%d,count=%d, size=%d\n",
+			icd->width, icd->height, icd->current_fmt->depth,
+			*count, *size);
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct mx25_buffer *buf)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct videobuf_buffer *vb = &buf->vb;
+
+	BUG_ON(in_interrupt());
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	/* This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE */
+	videobuf_waiton(vb, 0, 0);
+	videobuf_dma_contig_free(vq, vb);
+
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int mx25_videobuf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct mx25_buffer *buf = container_of(vb, struct mx25_buffer, vb);
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
+	if (0 != vb->baddr && vb->bsize < vb->size)
+		return -EINVAL;
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret)
+			goto fail;
+
+		vb->state = VIDEOBUF_PREPARED;
+	}
+
+	return 0;
+
+fail:
+	free_buffer(vq, buf);
+	return ret;
+}
+
+
+static irqreturn_t mx25_camera_irq_handler(int irq, void *dev_id)
+{
+	struct mx25_camera_dev *pcdev = dev_id;
+	struct videobuf_buffer *vb;
+	struct mx25_buffer *buf;
+	unsigned long flags;
+	u32 width, height, temp;
+	u32 fbaddr;
+
+	/* fist check for start-of-frame in order not to miss some pixels */
+	if (likely(readl(pcdev->csisr) & CSISR_SOF_INT)) {
+
+		/* clear FIFO buffer etc. .. */
+		writel((readl(pcdev->csicr1) & ~CSICR1_SOF_INTEN)
+					| CSICR1_CLR_RXFIFO
+					| CSISR_DMA_TSF_DONE_FB1
+					, pcdev->csicr1);
+
+		/* enable DMA ... */
+		writel(readl(pcdev->csicr3)
+				| CSICR3_DMA_REQ_EN_RFF
+				, pcdev->csicr3);
+		writel(CSISR_SOF_INT, pcdev->csisr);
+		return IRQ_HANDLED;
+	}
+
+	/* at this point the frame should be in memory */
+	/* so disable DMA quickly in order not to overwrite buffer */
+
+	temp = readl(pcdev->csicr3);
+	writel(temp	& ~CSICR3_DMA_REQ_EN_RFF, pcdev->csicr3);
+
+	temp = readl(pcdev->csisr);
+	writel(CSISR_DMA_TSF_DONE_FB1, pcdev->csisr);
+
+	if (!(temp & CSISR_DMA_TSF_DONE_FB1)) {
+		printk(KERN_INFO "%s: unexpected camera IRQ!\n",
+				__func__);
+		return IRQ_HANDLED;
+	}
+	if (!pcdev->active) {
+		printk(KERN_ERR "%s: DMA End IRQ with no active buffer!\n",
+				__func__);
+		return IRQ_HANDLED;
+	}
+
+	temp = readl(pcdev->csicr1) & ~CSI_IRQ_MASK;
+	writel(temp, pcdev->csicr1);
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	vb = &pcdev->active->vb;
+	buf = container_of(vb, struct mx25_buffer, vb);
+	WARN_ON(list_empty(&vb->queue));
+
+	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
+	list_del_init(&vb->queue);
+	vb->state = VIDEOBUF_DONE;
+	do_gettimeofday(&vb->ts);
+	vb->field_count++;
+
+	wake_up(&vb->done);
+
+	if (list_empty(&pcdev->capture)) {
+		/* this was the last available buffer, i.e our work is done */
+		pcdev->active = NULL;
+		spin_unlock_irqrestore(&pcdev->lock, flags);
+		return IRQ_HANDLED;
+	}
+
+	/* use the next available buffer */
+
+	pcdev->active = list_entry(pcdev->capture.next, struct mx25_buffer,
+				   vb.queue);
+
+	vb = &pcdev->active->vb;
+	vb->state = VIDEOBUF_ACTIVE;
+
+
+	/* set new frame buffer properties */
+	fbaddr = videobuf_to_dma_contig(vb);
+	writel(fbaddr, pcdev->base + CSIDMASA_FB1);
+
+	/* configure frame parameters for DMA */
+	width = vb->width;
+	height = vb->height;
+	writel((width << 16) + height, pcdev->base + CSIIMAG_PARA);
+
+	/* reset DMA controller */
+	temp = readl(pcdev->csicr3) & ~CSICR3_DMA_REQ_EN_RFF;
+	temp |= CSICR3_DMA_REFLASH_RFF;
+	writel(temp, pcdev->csicr3);
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
+	temp = readl(pcdev->csicr1);
+	writel(0xffffffff, pcdev->csisr);
+	writel(temp | CSICR1_SOF_INTEN, pcdev->csicr1);
+
+	return IRQ_HANDLED;
+}
+
+
+static void mx25_videobuf_queue(struct videobuf_queue *vq,
+						struct videobuf_buffer *vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+	struct mx25_buffer *buf = container_of(vb, struct mx25_buffer, vb);
+	unsigned long flags;
+	u32 width, height, temp;
+	u32 fbaddr;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d \n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+	list_add_tail(&vb->queue, &pcdev->capture);
+
+	vb->state = VIDEOBUF_ACTIVE;
+
+	if (!pcdev->active) {
+		pcdev->active = buf;
+
+		/* set frame buffer address */
+		fbaddr = videobuf_to_dma_contig(vb);
+
+		BUG_ON(fbaddr & 0x3);  /* must be word aligned */
+
+		writel(fbaddr, pcdev->base + CSIDMASA_FB1);
+
+		/* configure frame parameters for DMA */
+		width = vb->width;
+		height = vb->height;
+		writel((width << 16) + height, pcdev->base + CSIIMAG_PARA);
+
+		/* reset DMA controller */
+		temp = readl(pcdev->csicr3) & ~CSICR3_DMA_REQ_EN_RFF;
+		writel(temp, pcdev->csicr3);
+
+		temp |= CSICR3_DMA_REFLASH_RFF;
+		writel(temp, pcdev->csicr3);
+
+		/* disable all CSI interrupts */
+		temp = readl(pcdev->csicr1) & ~CSI_IRQ_MASK;
+		writel(temp, pcdev->csicr1);
+
+		writel(0xffffffff, pcdev->csisr);
+		writel(temp | CSICR1_SOF_INTEN, pcdev->csicr1);
+
+	}
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+
+
+static void mx25_videobuf_release(struct videobuf_queue *vq,
+				 struct videobuf_buffer *vb)
+{
+	struct mx25_buffer *buf = container_of(vb, struct mx25_buffer, vb);
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
+
+static struct videobuf_queue_ops mx25_videobuf_ops = {
+	.buf_setup	= mx25_videobuf_setup,
+	.buf_prepare	= mx25_videobuf_prepare,
+	.buf_queue	= mx25_videobuf_queue,
+	.buf_release	= mx25_videobuf_release,
+};
+
+static void mx25_camera_init_videobuf(struct videobuf_queue *q,
+				     struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+
+	videobuf_queue_dma_contig_init(q, &mx25_videobuf_ops, ici->dev,
+					&pcdev->lock,
+					V4L2_BUF_TYPE_VIDEO_CAPTURE,
+					V4L2_FIELD_NONE,
+					sizeof(struct mx25_buffer), icd);
+}
+
+static int mclk_get_divisor(struct mx25_camera_dev *pcdev)
+{
+	unsigned int mclk = pcdev->mclk;
+	unsigned long div;
+	unsigned long lcdclk;
+
+	lcdclk = clk_get_rate(pcdev->clk);
+
+	/* We verify platform_mclk_10khz != 0, so if anyone breaks it, here
+	 * they get a nice Oops */
+	div = (lcdclk / mclk) / 2;
+
+	dev_dbg(pcdev->soc_host.dev, "System clock %lukHz, target freq %dkHz, "
+		"divisor %lu\n", lcdclk / 1000, mclk / 1000, div);
+
+	return div;
+}
+
+static void mx25_camera_activate(struct mx25_camera_dev *pcdev)
+{
+	unsigned int temp, csicr = 0;
+	int ret;
+	dev_dbg(pcdev->soc_host.dev, "Activate device\n");
+
+	ret = clk_enable(pcdev->clk);
+
+	csicr |= CSICR1_MCLKEN | CSICR1_GCLK_MODE | CSICR1_CLR_RXFIFO;
+	csicr |= CSICR1_MCLKDIV(mclk_get_divisor(pcdev));
+	writel(csicr, pcdev->csicr1);
+
+	csicr = readl(pcdev->csicr3);
+	/* TODO: how do I choose a reasonable watermark level */
+	csicr |= CSICR3_RXFF_LEVEL(4); /* 32 words */
+	writel(csicr, pcdev->csicr3);
+
+	/* FB2 address will not be used by this driver */
+	/* TODO: make use of FB2 for better streaming performance */
+	writel(0, pcdev->base + CSIDMASA_FB2);
+
+	/* reset frame buffer stride */
+	writel(0x00, pcdev->base + CSIFBUF_PARA);
+
+	/* configure DMA burst type according to errata IMX25RMAD*/
+	temp = readl(pcdev->csicr2) & ~DMA_BURST_TYPE_MASK;
+	temp |= DMA_BURST_TYPE_INCR8;
+	writel(temp, pcdev->csicr2);
+
+}
+
+static void mx25_camera_deactivate(struct mx25_camera_dev *pcdev)
+{
+	dev_dbg(pcdev->soc_host.dev, "Deactivate device\n");
+
+	/* disable interrupts etc. */
+	writel(0, pcdev->csicr1);
+
+	/* Stop DMA engine etc.*/
+	writel(0, pcdev->base + CSICR3);
+
+	printk(KERN_INFO "%s: clock disabled\n", __func__);
+	clk_disable(pcdev->clk);
+}
+
+/* The following two functions absolutely depend on the fact, that
+ * there can be only one camera on i.MX25  camera sensor interface */
+static int mx25_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+	int ret;
+
+	if (pcdev->icd) {
+		ret = -EBUSY;
+		goto ebusy;
+	}
+
+	dev_info(&icd->dev, "MX25 Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	mx25_camera_activate(pcdev);
+	ret = icd->ops->init(icd);
+
+	if (!ret)
+		pcdev->icd = icd;
+
+ebusy:
+	return ret;
+}
+
+static void mx25_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+
+	BUG_ON(icd != pcdev->icd);
+
+
+	dev_info(&icd->dev, "MX25 Camera driver detached from camera %d\n",
+		 icd->devnum);
+
+	icd->ops->release(icd);
+
+	mx25_camera_deactivate(pcdev);
+
+	pcdev->icd = NULL;
+}
+
+static int mx25_camera_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_rect *rect)
+{
+	return icd->ops->set_crop(icd, rect);
+}
+
+
+
+static int mx25_camera_set_bus_param(struct soc_camera_device *icd
+		, __u32 pixfmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+	unsigned long camera_flags, common_flags, width_flags;
+	unsigned int csicr;
+	int ret;
+
+	const struct soc_camera_format_xlate *xlate;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(ici->dev, "Format %x not found\n", pixfmt);
+		return -EINVAL;
+	}
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+		common_flags = soc_camera_bus_param_compatible(camera_flags,
+							       CSI_BUS_FLAGS);
+	if (!common_flags)
+		return -EINVAL;
+
+	/* Make choises, based on platform choice */
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+			if (!pcdev->pdata ||
+			     pcdev->pdata->flags & MX25_CAMERA_VSYNC_HIGH)
+				common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+			else
+				common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+	}
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+		(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+			if (!pcdev->pdata ||
+			     pcdev->pdata->flags & MX25_CAMERA_PCLK_RISING)
+				common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+			else
+				common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+	}
+
+	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
+		(common_flags & SOCAM_DATA_ACTIVE_LOW)) {
+			if (!pcdev->pdata ||
+			     pcdev->pdata->flags & MX25_CAMERA_DATA_HIGH)
+				common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
+			else
+				common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
+	}
+
+	width_flags = common_flags & SOCAM_DATAWIDTH_MASK;
+
+	switch (xlate->host_fmt->depth) {
+	case  8:
+		width_flags &= SOCAM_DATAWIDTH_8;
+		break;
+	case 10:
+		width_flags &= SOCAM_DATAWIDTH_10;
+		break;
+	case 16:
+		width_flags &= SOCAM_DATAWIDTH_16;
+		break;
+	default:
+		width_flags = 0;
+	}
+	common_flags = (common_flags & ~SOCAM_DATAWIDTH_MASK) |
+			width_flags;
+	ret = icd->ops->set_bus_param(icd, common_flags);
+	if (ret < 0)
+		return ret;
+
+	csicr = readl(pcdev->csicr1);
+
+	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
+		csicr |= CSICR1_REDGE;
+	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
+		csicr |= CSICR1_SOF_POL;
+	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)
+		csicr |= CSICR1_HSYNC_POL;
+	if (common_flags & SOCAM_DATA_ACTIVE_LOW)
+		csicr |= CSICR1_DATA_POL;
+
+	if (common_flags & SOCAM_DATAWIDTH_10)
+		csicr |= CSICR1_PIXEL_BIT;
+	else
+		csicr &= ~CSICR1_PIXEL_BIT;
+
+	writel(csicr, pcdev->csicr1);
+
+	csicr = readl(pcdev->csicr3);
+	if (common_flags & SOCAM_DATAWIDTH_16)
+		csicr |= CSICR3_16BIT_SENSOR;
+	else
+		csicr &= ~CSICR3_16BIT_SENSOR;
+
+	writel(csicr, pcdev->csicr3);
+
+	return 0;
+}
+
+static int mx25_camera_set_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(ici->dev, "Format %x not found\n", pix->pixelformat);
+		return -EINVAL;
+	}
+
+	ret = icd->ops->set_fmt(icd, f);
+	if (!ret) {
+		icd->buswidth = xlate->buswidth;
+		icd->current_fmt = xlate->host_fmt;
+	}
+
+	return ret;
+}
+
+static int mx25_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	/* TODO: limit to mx25 hardware capabilities */
+
+	/* limit to sensor capabilities */
+	return icd->ops->try_fmt(icd, f);
+}
+
+static int mx25_camera_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
+{
+	int i;
+
+	for (i = 0; i < p->count; i++) {
+		struct mx25_buffer *buf = container_of(icf->vb_vidq.bufs[i],
+						      struct mx25_buffer, vb);
+		INIT_LIST_HEAD(&buf->vb.queue);
+	}
+
+	return 0;
+}
+
+static unsigned int mx25_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct mx25_buffer *buf;
+
+	buf = list_entry(icf->vb_vidq.stream.next, struct mx25_buffer,
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
+static int mx25_camera_querycap(struct soc_camera_host *ici,
+			       struct v4l2_capability *cap)
+{
+	/* cap->name is set by the friendly caller:-> */
+	strlcpy(cap->card, "i.MX25_Camera", sizeof(cap->card));
+	cap->version = VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static struct soc_camera_host_ops mx25_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= mx25_camera_add_device,
+	.remove		= mx25_camera_remove_device,
+	.set_bus_param	= mx25_camera_set_bus_param,
+	.set_crop	= mx25_camera_set_crop,
+	.set_fmt	= mx25_camera_set_fmt,
+	.try_fmt	= mx25_camera_try_fmt,
+	.init_videobuf	= mx25_camera_init_videobuf,
+	.reqbufs	= mx25_camera_reqbufs,
+	.poll		= mx25_camera_poll,
+	.querycap	= mx25_camera_querycap,
+};
+
+
+static int __init mx25_camera_probe(struct platform_device *pdev)
+{
+	struct mx25_camera_dev *pcdev;
+	struct resource *res;
+	struct clk *clk;
+	void __iomem *base;
+	unsigned int irq;
+	int err = 0;
+
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!res || !irq) {
+		printk(KERN_ERR "device problem: resource :%lx irq:%d\n"
+				, (long unsigned int) res, irq);
+		err = -ENODEV;
+		goto exit;
+	}
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		goto exit;
+	}
+
+	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+		err = -ENOMEM;
+		goto exit_put_clk;
+	}
+
+	pcdev->res = res;
+	pcdev->clk = clk;
+
+	pcdev->pdata = pdev->dev.platform_data;
+
+	if (pcdev->pdata)
+		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
+
+	if (!pcdev->mclk) {
+		dev_warn(&pdev->dev,
+			 "mclk_10khz == 0! Please, fix your platform data. "
+			 "Using default 20MHz\n");
+		pcdev->mclk = 20000000;
+	}
+
+	INIT_LIST_HEAD(&pcdev->capture);
+	spin_lock_init(&pcdev->lock);
+
+	/*
+	 * Request the regions.
+	 */
+	if (!request_mem_region(res->start, resource_size(res), DRIVER_NAME)) {
+		err = -EBUSY;
+		goto exit_kfree;
+	}
+
+	base = ioremap(res->start, resource_size(res));
+	if (!base) {
+		err = -ENOMEM;
+		goto exit_release;
+	}
+	pcdev->irq    = irq;
+	pcdev->base   = base;
+	pcdev->csicr1 = base + CSICR1;
+	pcdev->csicr2 = base + CSICR2;
+	pcdev->csicr3 = base + CSICR3;
+	pcdev->csisr  = base + CSISR;
+
+	err = request_irq(irq, mx25_camera_irq_handler, 0 , DRIVER_NAME, pcdev);
+	if (err) {
+		dev_err(&pdev->dev, "can't get irq%d: %d\n", irq, err);
+		goto exit_iounmap;
+	}
+
+	pcdev->soc_host.drv_name = DRIVER_NAME;
+	pcdev->soc_host.ops		 = &mx25_soc_camera_host_ops;
+	pcdev->soc_host.priv	 = pcdev;
+	pcdev->soc_host.dev		 = &pdev->dev;
+	pcdev->soc_host.nr		 = pdev->id;
+	err = soc_camera_host_register(&pcdev->soc_host);
+	if (err)
+		goto exit_iounmap;
+
+	dev_info(&pdev->dev, "MX25 Camera driver loaded\n");
+
+	return 0;
+
+exit_iounmap:
+	iounmap(base);
+exit_release:
+	release_mem_region(res->start, resource_size(res));
+exit_kfree:
+	kfree(pcdev);
+exit_put_clk:
+	clk_put(clk);
+exit:
+	return err;
+}
+
+static int __exit mx25_camera_remove(struct platform_device *pdev)
+{
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct mx25_camera_dev *pcdev = container_of(soc_host,
+					struct mx25_camera_dev, soc_host);
+	struct resource *res;
+	u32 csicr;
+
+	free_irq(pcdev->irq, pcdev);
+
+	/* disable interrupts */
+	csicr = readl(pcdev->csicr1) & ~CSI_IRQ_MASK;
+	writel(csicr, pcdev->csicr1);
+
+	/* Stop DMA engine */
+	csicr = readl(pcdev->base + CSICR3)
+			& ~(CSICR3_DMA_REQ_EN_RFF | CSICR3_DMA_REQ_EN_SFF);
+	writel(csicr, pcdev->base + CSICR3);
+
+	clk_put(pcdev->clk);
+
+	soc_camera_host_unregister(soc_host);
+
+	iounmap(pcdev->base);
+
+	res = pcdev->res;
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(pcdev);
+
+	dev_info(&pdev->dev, "MX25 Camera driver unloaded\n");
+
+	return 0;
+}
+
+static struct platform_driver mx25_camera_driver = {
+	.driver 	= {
+		.name	= DRIVER_NAME,
+	},
+	.remove		= __exit_p(mx25_camera_remove),
+};
+
+static int __init mx25_camera_init(void)
+{
+	return platform_driver_probe(&mx25_camera_driver, mx25_camera_probe);
+}
+
+static void __exit mx25_camera_exit(void)
+{
+	return platform_driver_unregister(&mx25_camera_driver);
+}
+
+module_init(mx25_camera_init);
+module_exit(mx25_camera_exit);
+
+MODULE_DESCRIPTION("i.MX25 SoC Camera Host driver");
+MODULE_AUTHOR("Arno Euteneuer <arno.euteneuer@toptica.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
