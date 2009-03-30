Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46218 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZC3PzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 11:55:22 -0400
Received: by bwz17 with SMTP id 17so1981390bwz.37
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 08:55:18 -0700 (PDT)
From: Darius Augulis <augulis.darius@gmail.com>
Subject: [RFC PATCH V2] Add camera (CSI) driver for MX1
To: linux-media@vger.kernel.org
Cc: paulius.zaleckas@teltonika.lt, g.liakhovetski@gmx.de,
	s.hauer@pengutronix.de
Date: Mon, 30 Mar 2009 17:53:10 +0300
Message-ID: <20090330145310.20826.77060.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

 arch/arm/mach-mx1/Makefile                  |    7 
 arch/arm/mach-mx1/ksym_mx1.c                |   20 +
 arch/arm/mach-mx1/mx1_camera_fiq.S          |   35 +
 arch/arm/plat-mxc/include/mach/memory.h     |    8 
 arch/arm/plat-mxc/include/mach/mx1_camera.h |   39 +
 drivers/media/video/Kconfig                 |    9 
 drivers/media/video/Makefile                |    1 
 drivers/media/video/mx1_camera.c            |  838 +++++++++++++++++++++++++++
 8 files changed, 955 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-mx1/ksym_mx1.c
 create mode 100644 arch/arm/mach-mx1/mx1_camera_fiq.S
 create mode 100644 arch/arm/plat-mxc/include/mach/mx1_camera.h
 create mode 100644 drivers/media/video/mx1_camera.c


diff --git a/arch/arm/mach-mx1/Makefile b/arch/arm/mach-mx1/Makefile
index b969719..4fbdbbd 100644
--- a/arch/arm/mach-mx1/Makefile
+++ b/arch/arm/mach-mx1/Makefile
@@ -4,7 +4,12 @@
 
 # Object file lists.
 
-obj-y			+= generic.o clock.o devices.o
+obj-y			+= generic.o clock.o devices.o ksym_mx1.o
+
+# Support for CMOS sensor interface
+ifdef CONFIG_VIDEO_MX1
+obj-y	+= mx1_camera_fiq.o
+endif
 
 # Specific board support
 obj-$(CONFIG_ARCH_MX1ADS) += mx1ads.o
diff --git a/arch/arm/mach-mx1/ksym_mx1.c b/arch/arm/mach-mx1/ksym_mx1.c
new file mode 100644
index 0000000..d771b2c
--- /dev/null
+++ b/arch/arm/mach-mx1/ksym_mx1.c
@@ -0,0 +1,20 @@
+/*
+ * Exported ksyms of ARCH_MX1
+ *
+ * Copyright (C) 2008, Darius Augulis <augulis.darius@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+
+#if defined(CONFIG_VIDEO_MX1) || defined(CONFIG_VIDEO_MX1_MODULE)
+#include <mach/mx1_camera.h>
+
+/* IMX camera FIQ handler */
+EXPORT_SYMBOL(mx1_camera_sof_fiq_start);
+EXPORT_SYMBOL(mx1_camera_sof_fiq_end);
+#endif
diff --git a/arch/arm/mach-mx1/mx1_camera_fiq.S b/arch/arm/mach-mx1/mx1_camera_fiq.S
new file mode 100644
index 0000000..9c69aa6
--- /dev/null
+++ b/arch/arm/mach-mx1/mx1_camera_fiq.S
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
+		.global	mx1_camera_sof_fiq_end
+		.global	mx1_camera_sof_fiq_start
+mx1_camera_sof_fiq_start:
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
+mx1_camera_sof_fiq_end:
diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
index 0b80839..c6f2170 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -19,4 +19,12 @@
 #define PHYS_OFFSET		UL(0x80000000)
 #endif
 
+#if defined(CONFIG_VIDEO_MX1) || defined(CONFIG_VIDEO_MX1_MODULE)
+/*
+ * Increase size of DMA-consistent memory region.
+ * This is required for i.MX camera driver to capture at least four VGA frames.
+ */
+#define CONSISTENT_DMA_SIZE SZ_8M
+#endif /* CONFIG_VIDEO_MX1 */
+
 #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
diff --git a/arch/arm/plat-mxc/include/mach/mx1_camera.h b/arch/arm/plat-mxc/include/mach/mx1_camera.h
new file mode 100644
index 0000000..1bf03e8
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/mx1_camera.h
@@ -0,0 +1,39 @@
+/*
+ * mx1_camera.h - i.MX1/i.MXL camera driver header file
+ *
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
+#define MX1_CAMERA_DP		1
+#define MX1_CAMERA_PCP		2
+#define MX1_CAMERA_VSP		4
+
+extern unsigned char mx1_camera_sof_fiq_start, mx1_camera_sof_fiq_end;
+
+/**
+ * struct mx1_camera_pdata - i.MX1/i.MXL camera platform data
+ * @init:	Init board resources
+ * @exit:	Release board resources
+ * @mclk_10khz:	master clock frequency in 10kHz units
+ * @flags:	MX1 camera platform flags
+ */
+struct mx1_camera_pdata {
+	int (*init)(struct device *);
+	int (*exit)(struct device *);
+	unsigned long mclk_10khz;
+	unsigned long flags;
+};
+
+#endif /* __ASM_ARCH_CAMERA_H_ */
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 58abbe3..e5eeb4a 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -746,6 +746,14 @@ config SOC_CAMERA_OV772X
 	help
 	  This is a ov772x camera driver
 
+config VIDEO_MX1
+	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
+	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
+	select FIQ
+	select VIDEOBUF_DMA_CONTIG
+	---help---
+	  This is a v4l2 driver for the i.MX1/i.MXL CMOS Sensor Interface
+
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
 	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
@@ -906,5 +914,4 @@ config USB_S2255
 	  This driver can be compiled as a module, called s2255drv.
 
 endif # V4L_USB_DRIVERS
-
 endif # VIDEO_CAPTURE_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 08765d8..7c0bd6e 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -134,6 +134,7 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
new file mode 100644
index 0000000..86f8d89
--- /dev/null
+++ b/drivers/media/video/mx1_camera.c
@@ -0,0 +1,838 @@
+/*
+ * V4L2 Driver for i.MXL/i.MXL camera (CSI) host
+ *
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
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
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
+#include <asm/dma.h>
+#include <asm/fiq.h>
+#include <mach/dma-mx1-mx2.h>
+#include <mach/hardware.h>
+#include <mach/mx1_camera.h>
+
+/*
+ * CSI registers
+ */
+#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
+#define DMA_DIMR	0x08			/* Interrupt mask Register */
+#define CSICR1		0x00			/* CSI Control Register 1 */
+#define CSISR		0x08			/* CSI Status Register */
+#define CSIRXR		0x10			/* CSI RxFIFO Register */
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
+#define CSICR1_DATA_POL		(1 << 2)
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
+#define DRIVER_NAME "mx1-camera"
+
+#define CSI_IRQ_MASK	(CSISR_SFF_OR_INT | CSISR_RFF_OR_INT | \
+			CSISR_STATFF_INT | CSISR_RXFF_INT | CSISR_SOF_INT)
+
+#define CSI_BUS_FLAGS	(SOCAM_MASTER | SOCAM_HSYNC_ACTIVE_HIGH | \
+			SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW | \
+			SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING | \
+			SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_LOW | \
+			SOCAM_DATAWIDTH_8)
+
+/*
+ * Structures
+ */
+
+/* buffer for one video frame */
+struct mx1_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer vb;
+	const struct soc_camera_data_format *fmt;
+	int inwork;
+};
+
+/* i.MX is only supposed to handle one camera on its Camera Sensor
+ * Interface. If anyone ever builds hardware to enable more than
+ * one camera, they will have to modify this driver too */
+struct mx1_camera_dev {
+	struct soc_camera_device	*icd;
+	struct mx1_camera_pdata		*pdata;
+	struct mx1_buffer		*active;
+	struct device			*dev;
+	struct resource			*res;
+	struct clk			*clk;
+	struct list_head		capture;
+
+	void __iomem			*base;
+	int				dma_chan;
+	unsigned int			irq;
+	unsigned long			mclk;
+
+	spinlock_t			lock;
+};
+
+/*
+ *  Videobuf operations
+ */
+static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
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
+	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct mx1_buffer *buf)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct videobuf_buffer *vb = &buf->vb;
+
+	BUG_ON(in_interrupt());
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, buf->vb.baddr, buf->vb.bsize);
+
+	/* This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE */
+	videobuf_waiton(vb, 0, 0);
+	videobuf_dma_contig_free(vq, vb);
+
+	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int mx1_videobuf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
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
+	if	(buf->fmt	!= icd->current_fmt ||
+		vb->width	!= icd->width ||
+		vb->height	!= icd->height ||
+		vb->field	!= field) {
+			buf->fmt	= icd->current_fmt;
+			vb->width	= icd->width;
+			vb->height	= icd->height;
+			vb->field	= field;
+			vb->state	= VIDEOBUF_NEEDS_INIT;
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
+static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
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
+	if (unlikely(ret))
+		dev_err(pcdev->dev, "Failed to setup DMA sg list\n");
+
+	return ret;
+}
+
+static void mx1_videobuf_queue(struct videobuf_queue *vq,
+						struct videobuf_buffer *vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx1_camera_dev *pcdev = ici->priv;
+	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	list_add_tail(&vb->queue, &pcdev->capture);
+
+	vb->state = VIDEOBUF_ACTIVE;
+
+	if (!pcdev->active) {
+		pcdev->active = buf;
+
+		/* setup sg list for future DMA */
+		if (!mx1_camera_setup_dma(pcdev)) {
+			unsigned int temp;
+			/* enable SOF irq */
+			temp = __raw_readl(pcdev->base + CSICR1) |
+							CSICR1_SOF_INTEN;
+			__raw_writel(temp, pcdev->base + CSICR1);
+		}
+	}
+}
+
+static void mx1_videobuf_release(struct videobuf_queue *vq,
+				 struct videobuf_buffer *vb)
+{
+	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
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
+static void mx1_camera_wakeup(struct mx1_camera_dev *pcdev,
+			      struct videobuf_buffer *vb,
+			      struct mx1_buffer *buf)
+{
+	/* _init is used to debug races, see comment in mx1_camera_reqbufs() */
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
+				   struct mx1_buffer, vb.queue);
+
+	/* setup sg list for future DMA */
+	if (likely(!mx1_camera_setup_dma(pcdev))) {
+		unsigned int temp;
+
+		/* enable SOF irq */
+		temp = __raw_readl(pcdev->base + CSICR1) | CSICR1_SOF_INTEN;
+		__raw_writel(temp, pcdev->base + CSICR1);
+	}
+}
+
+static void mx1_camera_dma_irq(int channel, void *data)
+{
+	struct mx1_camera_dev *pcdev = data;
+	struct mx1_buffer *buf;
+	struct videobuf_buffer *vb;
+
+	imx_dma_disable(channel);
+
+	if (unlikely(!pcdev->active)) {
+		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
+		return;
+	}
+
+	vb = &pcdev->active->vb;
+	buf = container_of(vb, struct mx1_buffer, vb);
+	WARN_ON(buf->inwork || list_empty(&vb->queue));
+	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	mx1_camera_wakeup(pcdev, vb, buf);
+}
+
+static struct videobuf_queue_ops mx1_videobuf_ops = {
+	.buf_setup	= mx1_videobuf_setup,
+	.buf_prepare	= mx1_videobuf_prepare,
+	.buf_queue	= mx1_videobuf_queue,
+	.buf_release	= mx1_videobuf_release,
+};
+
+static void mx1_camera_init_videobuf(struct videobuf_queue *q,
+				     struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx1_camera_dev *pcdev = ici->priv;
+
+	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, pcdev->dev,
+					&pcdev->lock,
+					V4L2_BUF_TYPE_VIDEO_CAPTURE,
+					V4L2_FIELD_NONE,
+					sizeof(struct mx1_buffer), icd);
+}
+
+static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
+{
+	unsigned int mclk = pcdev->mclk;
+	unsigned long div;
+	unsigned long lcdclk;
+
+	lcdclk = clk_get_rate(pcdev->clk);
+
+	/* We verify platform_mclk_10khz != 0, so if anyone breaks it, here
+	 * they get a nice Oops */
+	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
+
+	dev_dbg(pcdev->dev, "System clock %lukHz, target freq %dkHz, "
+		"divisor %lu\n", lcdclk / 1000, mclk / 1000, div);
+
+	return div;
+}
+
+static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
+{
+	struct mx1_camera_pdata *pdata = pcdev->pdata;
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
+}
+
+static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
+{
+	struct mx1_camera_pdata *board = pcdev->pdata;
+
+	/* Disable all CSI interface */
+	__raw_writel(0x00, pcdev->base + CSICR1);
+
+	clk_disable(pcdev->clk);
+
+	if (board && board->exit) {
+		dev_dbg(pcdev->dev, "%s: Release gpios\n", __func__);
+		board->exit(pcdev->dev);
+	}
+}
+
+/* The following two functions absolutely depend on the fact, that
+ * there can be only one camera on i.MX camera sensor interface */
+static int mx1_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx1_camera_dev *pcdev = ici->priv;
+	int ret;
+
+	if (pcdev->icd) {
+		ret = -EBUSY;
+		goto ebusy;
+	}
+
+	dev_info(&icd->dev, "i.MX Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	mx1_camera_activate(pcdev);
+	ret = icd->ops->init(icd);
+
+	if (!ret)
+		pcdev->icd = icd;
+
+ebusy:
+	return ret;
+}
+
+static void mx1_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx1_camera_dev *pcdev = ici->priv;
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
+	mx1_camera_deactivate(pcdev);
+
+	pcdev->icd = NULL;
+}
+
+#ifdef CONFIG_PM
+static int mx1_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx1_camera_dev *pcdev = ici->priv;
+
+	if (pcdev->active)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int mx1_camera_resume(struct soc_camera_device *icd)
+{
+	return 0;
+}
+#else
+#define mx1_camera_suspend NULL
+#define mx1_camera_resume NULL
+#endif
+
+static int mx1_camera_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_rect *rect)
+{
+	return icd->ops->set_crop(icd, rect);
+}
+
+static int mx1_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx1_camera_dev *pcdev = ici->priv;
+	unsigned long camera_flags, common_flags;
+	unsigned int csicr1;
+	int ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	/* MX1 supports only 8bit buswidth */
+	common_flags = soc_camera_bus_param_compatible(camera_flags,
+							       CSI_BUS_FLAGS);
+	if (!common_flags)
+		return -EINVAL;
+
+	icd->buswidth = 8;
+
+	/* Make choises, based on platform choice */
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+			if (pcdev->pdata->flags & MX1_CAMERA_VSP)
+				common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+			else
+				common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+		(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+		if (pcdev->pdata->flags & MX1_CAMERA_PCP)
+			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+		else
+			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+	}
+
+	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
+		(common_flags & SOCAM_DATA_ACTIVE_LOW)) {
+		if (pcdev->pdata->flags & MX1_CAMERA_DP)
+			common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
+	}
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
+	if (common_flags & SOCAM_DATA_ACTIVE_LOW)
+		csicr1 |= CSICR1_DATA_POL;
+
+	__raw_writel(csicr1, pcdev->base + CSICR1);
+
+	return 0;
+}
+
+static int mx1_camera_set_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pix->pixelformat);
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
+static int mx1_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	/* TODO: limit to mx1 hardware capabilities */
+
+	/* limit to sensor capabilities */
+	return icd->ops->try_fmt(icd, f);
+}
+
+static int mx1_camera_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
+{
+	int i;
+
+	/* This is for locking debugging only. I removed spinlocks and now I
+	 * check whether .prepare is ever called on a linked buffer, or whether
+	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
+	 * it hadn't triggered */
+	for (i = 0; i < p->count; i++) {
+		struct mx1_buffer *buf = container_of(icf->vb_vidq.bufs[i],
+						      struct mx1_buffer, vb);
+		buf->inwork = 0;
+		INIT_LIST_HEAD(&buf->vb.queue);
+	}
+
+	return 0;
+}
+
+static unsigned int mx1_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+	struct mx1_buffer *buf;
+
+	buf = list_entry(icf->vb_vidq.stream.next, struct mx1_buffer,
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
+static int mx1_camera_querycap(struct soc_camera_host *ici,
+			       struct v4l2_capability *cap)
+{
+	/* cap->name is set by the friendly caller:-> */
+	strlcpy(cap->card, "i.MX1/i.MXL Camera", sizeof(cap->card));
+	cap->version = VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static struct soc_camera_host_ops mx1_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= mx1_camera_add_device,
+	.remove		= mx1_camera_remove_device,
+	.suspend	= mx1_camera_suspend,
+	.resume		= mx1_camera_resume,
+	.set_bus_param	= mx1_camera_set_bus_param,
+	.set_crop	= mx1_camera_set_crop,
+	.set_fmt	= mx1_camera_set_fmt,
+	.try_fmt	= mx1_camera_try_fmt,
+	.init_videobuf	= mx1_camera_init_videobuf,
+	.reqbufs	= mx1_camera_reqbufs,
+	.poll		= mx1_camera_poll,
+	.querycap	= mx1_camera_querycap,
+};
+
+/* Should be allocated dynamically too, but we have only one. */
+static struct soc_camera_host mx1_soc_camera_host = {
+	.drv_name	= DRIVER_NAME,
+	.ops		= &mx1_soc_camera_host_ops,
+};
+
+static struct fiq_handler fh = {
+	.name		= "csi_sof"
+};
+
+static int __init mx1_camera_probe(struct platform_device *pdev)
+{
+	struct mx1_camera_dev *pcdev;
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
+	pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
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
+	pcdev->irq = irq;
+	pcdev->base = base;
+	pcdev->dev = &pdev->dev;
+
+	/* request dma */
+	pcdev->dma_chan = imx_dma_request_by_prio(DRIVER_NAME, DMA_PRIO_HIGH);
+	if (pcdev->dma_chan < 0) {
+		dev_err(pcdev->dev, "Can't request DMA for i.MX CSI\n");
+		err = -EBUSY;
+		goto exit_iounmap;
+	}
+	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chan);
+
+	imx_dma_setup_handlers(pcdev->dma_chan, mx1_camera_dma_irq, NULL,
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
+	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
+						   &mx1_camera_sof_fiq_start);
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
+	mx1_soc_camera_host.priv	= pcdev;
+	mx1_soc_camera_host.dev.parent	= &pdev->dev;
+	mx1_soc_camera_host.nr		= pdev->id;
+	err = soc_camera_host_register(&mx1_soc_camera_host);
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
+	release_mem_region(res->start, resource_size(res));
+exit_kfree:
+	kfree(pcdev);
+exit:
+	return err;
+}
+
+static int __exit mx1_camera_remove(struct platform_device *pdev)
+{
+	struct mx1_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	imx_dma_free(pcdev->dma_chan);
+	disable_fiq(pcdev->irq);
+	mxc_set_irq_fiq(pcdev->irq, 0);
+	release_fiq(&fh);
+
+	soc_camera_host_unregister(&mx1_soc_camera_host);
+
+	iounmap(pcdev->base);
+
+	res = pcdev->res;
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(pcdev);
+
+	dev_info(&pdev->dev, "i.MX Camera driver unloaded\n");
+
+	return 0;
+}
+
+static struct platform_driver mx1_camera_driver = {
+	.driver 	= {
+		.name	= DRIVER_NAME,
+	},
+	.remove		= __exit_p(mx1_camera_remove),
+};
+
+static int __init mx1_camera_init(void)
+{
+	return platform_driver_probe(&mx1_camera_driver, mx1_camera_probe);
+}
+
+static void __exit mx1_camera_exit(void)
+{
+	return platform_driver_unregister(&mx1_camera_driver);
+}
+
+module_init(mx1_camera_init);
+module_exit(mx1_camera_exit);
+
+MODULE_DESCRIPTION("i.MX1/i.MXL SoC Camera Host driver");
+MODULE_AUTHOR("Paulius Zaleckas <paulius.zaleckas@teltonika.lt>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);

