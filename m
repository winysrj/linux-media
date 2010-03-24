Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.plextek.co.uk ([62.254.222.163]:54963 "EHLO
	mailgate.plextek.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0CXLfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 07:35:40 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: SOC camera port for ov7675/ov2640 on i.MX25
Date: Wed, 24 Mar 2010 11:25:47 -0000
Message-ID: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF2F1B@plextek3.plextek.lan>
From: "Adam Sutton" <aps@plextek.co.uk>
To: <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm just beginning a Linux based project running on a Freescale i.MX25.
One of 
my jobs is to write a camera driver for the sensor we're going to be
using 
(Omnivision 7675). However at present I only have access to an ov2640
attached 
to a Freescale 3stack development board. I thought it would be a useful
and 
interesting exercise to port the driver provided by Freescale to the new

soc_camera framework.

I've written the ov2640 driver, using a variety of other drivers as
references 
and I'm using the mx25_camera host driver (with a few mods) posted by
Arno 
Euteneuer. After getting over some basic setup/config problems I've now
got as 
far as the mx25_camera loading and this then auto loading the ov2640.
This 
correctly probes the I2C and detects the sensor.

However I've now come up against a problem that I'm unsure of how to
solve and 
I'm not sure whether its a case of my not properly following the current

framework. soc_camera_probe() is called and detects the the
soc_camera_link 
object contains board information and therefore calls
soc_camera_init_i2c() this 
in turn calls v4l2_i2c_new_subdev_board() which then attempts to create
a new 
i2c_client (i2c_new_device()) and it is at this point things fail.

Because an i2c_client already exists (auto created from the static board
info 
registered by the platform configuration), the one passed into the
probe() 
routine of my chip driver, the i2c_new_device() call fails as it believe
the 
device is busy as a client already exists for that I2C address.

I can only assume that there is something wrong with the way I've set
things up 
/ used the framework. However I've compared it to several other modules
and 
can't see any obvious faults (although its not obvious which drivers
represent 
the current "preferred" approach).

I should say that I'm using a 2.6.31 based kernel (provided by
Freescale) into 
which I've grafted the 2.6.33 media drivers (and obvious dependencies)
so I 
guess something about this graft could be causing the problem. Though I
cannot 
see what from looking at other changes.

I've pasted in the 4 files I think I relevant to what I'm doing:
drivers/media/video/mx25_camera.c
drivers/media/video/ov2640.c
arch/arm/mach-mx25/devices_merlin.c // extract only
arch/arm/mach-mx25/mx25_merlin.c // extract only

This is my first time posting to the mailing list so apologies if this
is not 
the standard way of doing things.

I'd be grateful for any help.

Regards,
Adam

diff -Nuar a/devices_merlin.c b/devices_merlin.c
--- a/devices_merlin.c	1970-01-01 00:00:00.000000000 +0000
+++ b/devices_merlin.c	2010-03-24 11:16:22.000000000 +0000
@@ -0,0 +1,42 @@
+#if (defined CONFIG_VIDEO_MX25) || (defined CONFIG_VIDEO_MX25_MODULE)
+static u64 csi_dmamask = 0xffffffff;
+
+/* TODO: does this belong here or in the board spec?
+ * AND do we need a separate devices.c file? This doesn't seem to be
standard 
practice?
+ */
+static struct mx25_camera_pdata camera_pdata = {
+  .flags = MX25_CAMERA_DATAWIDTH_8 | MX25_CAMERA_DATAWIDTH_10 | 
MX25_CAMERA_DATAWIDTH_16,
+  .mclk_10khz = 2400,
+};
+
+static struct resource mx25_csi_resources[] = {
+	{
+	       .start = 0x53FF8000,
+	       .end = 0x53FFBFFF,
+	       .flags = IORESOURCE_MEM,
+	}, {
+	       .start = 17,
+	       .end = 17,
+	       .flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device mx25_csi_device = {
+	.name = "mx25-camera",
+	.id = 0,
+	.dev = {
+			.coherent_dma_mask = 0xffffffff,
+			.dma_mask = &csi_dmamask,
+      .platform_data = &camera_pdata,
+		},
+	.num_resources = ARRAY_SIZE(mx25_csi_resources),
+	.resource = mx25_csi_resources,
+};
+static inline void mxc_init_csi(void)
+{
+  printk("%s: working\n", __func__);
+	if (platform_device_register(&mx25_csi_device) < 0)
+		dev_err(&mx25_csi_device.dev,
+			"Unable to register mx25 csi device\n");
+}
+#endif
diff -Nuar a/mx25_camera.c b/mx25_camera.c
--- a/mx25_camera.c	1970-01-01 00:00:00.000000000 +0000
+++ b/mx25_camera.c	2010-03-24 10:59:14.000000000 +0000
@@ -0,0 +1,1006 @@
+/*
+ * V4L2 Driver for i.MX25 camera (CSI) host
+ *
+ * Copyright (C) 2009, Arno Euteneuer <arno.euteneuer <at> toptica.com>
+ *
+ * Based on i.MXL/i.MXL camera (CSI) host driver
+ * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas <at>
teltonika.lt>
+ * Copyright (C) 2009, Darius Augulis <augulis.darius <at> gmail.com>
+ *
+ * Based on PXA SoC camera driver
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel <at>
pengutronix.de>
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
+#include <linux/sched.h>
+#include <linux/time.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+
+#include <media/soc_camera.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf-dma-contig.h>
+#include <media/soc_mediabus.h>
+
+#include <mach/dma-mx1-mx2.h>
+#include <mach/hardware.h>
+#include <mach/mx25_camera.h>
+
+/* TODO: best way to handle this? */
+extern void gpio_sensor_active(void);
+extern void gpio_sensor_inactive(void);
+
+/*
+ * CSI registers
+ */
+#define CSICR1		0x00			/* CSI Control Register
1 */
+#define CSICR2		0x04			/* CSI Control Register
2 */
+#define CSICR3		0x08			/* CSI Control Register
3 */
+#define CSIRXR		0x10			/* CSI RxFIFO Register
*/
+#define CSIRXCNT	0x14
+#define CSISR		0x18			/* CSI Status Register
*/
+
+#define CSIDMASA_FB1		0x28	/* framebuffer FB1 start address
*/
+#define CSIDMASA_FB2		0x2c
+#define CSIFBUF_PARA		0x30	/* framebuffer stride register
*/
+#define CSIIMAG_PARA		0x34	/* frame size register for DMA
*/
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
+	struct videobuf_buffer   vb;
+  enum v4l2_mbus_pixelcode code;
+};
+
+/*
+ * i.MX25 is only supposed to handle one camera on its Camera Sensor
+ * Interface. If anyone ever builds hardware to enable more than
+ * one camera, they will have to modify this driver to
+ */
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
+static int mx25_videobuf_setup(struct videobuf_queue *vq, unsigned int
*count,
+			      unsigned int *size)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+
icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+ 
+	*size = bytes_per_line * icd->user_height;
+
+	if (!*count)
+		*count = 32;
+
+	while (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		(*count)--;
+
+	dev_dbg(&icd->dev,
+			"width=%d, height=%d, depth=%d, count=%d,
size=%d\n",
+			icd->user_width, icd->user_height,
icd->current_fmt-
>host_fmt->bits_per_sample,
+			*count, *size);
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct mx25_buffer
*buf)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct videobuf_buffer *vb = &buf->vb;
+
+	BUG_ON(in_interrupt());
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	/* This waits until this buffer is out of danger, i.e., until it
is no
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
+	struct mx25_buffer *buf = container_of(vb, struct mx25_buffer,
vb);
+	int ret;
+  int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+
icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	/* Added list head initialization on alloc */
+	WARN_ON(!list_empty(&vb->queue));
+
+	BUG_ON(NULL == icd->current_fmt);
+
+	if (buf->code	!= icd->current_fmt->code ||
+	    vb->width	!= icd->user_width ||
+	    vb->height	!= icd->user_height ||
+	    vb->field	!= field) {
+		buf->code	= icd->current_fmt->code;
+		vb->width	= icd->user_width;
+		vb->height	= icd->user_height;
+		vb->field	= field;
+		vb->state	= VIDEOBUF_NEEDS_INIT;
+	}
+
+	vb->size = bytes_per_line * vb->height;
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
+	/* fist check for start-of-frame in order not to miss some
pixels */
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
+		printk(KERN_ERR "%s: DMA End IRQ with no active
buffer!\n",
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
+	/* _init is used to debug races, see comment in
pxa_camera_reqbufs() */
+	list_del_init(&vb->queue);
+	vb->state = VIDEOBUF_DONE;
+	do_gettimeofday(&vb->ts);
+	vb->field_count++;
+
+	wake_up(&vb->done);
+
+	if (list_empty(&pcdev->capture)) {
+		/* this was the last available buffer, i.e our work is
done */
+		pcdev->active = NULL;
+		spin_unlock_irqrestore(&pcdev->lock, flags);
+		return IRQ_HANDLED;
+	}
+
+	/* use the next available buffer */
+
+	pcdev->active = list_entry(pcdev->capture.next, struct
mx25_buffer,
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
+						struct videobuf_buffer
*vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+	struct mx25_buffer *buf = container_of(vb, struct mx25_buffer,
vb);
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
+		writel((width << 16) + height, pcdev->base +
CSIIMAG_PARA);
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
+	struct mx25_buffer *buf = container_of(vb, struct mx25_buffer,
vb);
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
+	struct soc_camera_host *ici =
to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+
+	videobuf_queue_dma_contig_init(q, &mx25_videobuf_ops,
icd->dev.parent,
+					&pcdev->lock,
+					V4L2_BUF_TYPE_VIDEO_CAPTURE,
+					V4L2_FIELD_NONE,
+					sizeof(struct mx25_buffer),
icd);
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
+	/* We verify platform_mclk_10khz != 0, so if anyone breaks it,
here
+	 * they get a nice Oops */
+	div = (lcdclk / mclk) / 2;
+
+	dev_dbg(pcdev->icd->dev.parent, "System clock %lukHz, target
freq %dkHz, 
"
+		"divisor %lu\n", lcdclk / 1000, mclk / 1000, div);
+
+	return div;
+}
+
+static void mx25_camera_activate(struct mx25_camera_dev *pcdev)
+{
+	unsigned int temp, csicr = 0;
+	int ret;
+	dev_dbg(pcdev->icd->dev.parent, "Activate device\n");
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
+  /* TODO: activate */
+  gpio_sensor_active();
+
+}
+
+static void mx25_camera_deactivate(struct mx25_camera_dev *pcdev)
+{
+	dev_dbg(pcdev->icd->dev.parent, "Deactivate device\n");
+
+	/* disable interrupts etc. */
+	writel(0, pcdev->csicr1);
+
+	/* Stop DMA engine etc.*/
+	writel(0, pcdev->base + CSICR3);
+
+	printk(KERN_INFO "%s: clock disabled\n", __func__);
+	clk_disable(pcdev->clk);
+
+  /* TODO: deactivate */
+  gpio_sensor_inactive();
+}
+
+/* The following two functions absolutely depend on the fact, that
+ * there can be only one camera on i.MX25  camera sensor interface */
+static int mx25_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici =
to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+	int ret = 0;
+
+	if (pcdev->icd) {
+		ret = -EBUSY;
+		goto ebusy;
+	}
+
+	dev_info(icd->dev.parent, "MX25 Camera driver attached to camera
%d\n",
+		 icd->devnum);
+
+	mx25_camera_activate(pcdev);
+  printk("%s: camera activated\n", __func__);
+
+	pcdev->icd = icd;
+
+ebusy:
+	return ret;
+}
+
+static void mx25_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici =
to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+
+	BUG_ON(icd != pcdev->icd);
+
+
+	dev_info(icd->dev.parent, "MX25 Camera driver detached from
camera 
%d\n",
+		 icd->devnum);
+
+	mx25_camera_deactivate(pcdev);
+
+	pcdev->icd = NULL;
+}
+
+static int mx25_camera_set_crop(struct soc_camera_device *icd,
+			       struct v4l2_crop *a)
+{
+  struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+	return v4l2_subdev_call(sd, video, s_crop, a);
+}
+
+
+
+static int mx25_camera_set_bus_param(struct soc_camera_device *icd
+		, __u32 pixfmt)
+{
+	struct soc_camera_host *ici =
to_soc_camera_host(icd->dev.parent);
+	struct mx25_camera_dev *pcdev = ici->priv;
+	unsigned long camera_flags, common_flags, width_flags;
+	unsigned int csicr;
+	int ret;
+
+	const struct soc_camera_format_xlate *xlate;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(icd->dev.parent, "Format %x not found\n",
pixfmt);
+		return -EINVAL;
+	}
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+		common_flags =
soc_camera_bus_param_compatible(camera_flags,
+
CSI_BUS_FLAGS);
+	if (!common_flags)
+		return -EINVAL;
+
+	/* Make choises, based on platform choice */
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+			if (!pcdev->pdata ||
+			     pcdev->pdata->flags &
MX25_CAMERA_VSYNC_HIGH)
+				common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+			else
+				common_flags &=
~SOCAM_VSYNC_ACTIVE_HIGH;
+	}
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+		(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+			if (!pcdev->pdata ||
+			     pcdev->pdata->flags &
MX25_CAMERA_PCLK_RISING)
+				common_flags &=
~SOCAM_PCLK_SAMPLE_FALLING;
+			else
+				common_flags &=
~SOCAM_PCLK_SAMPLE_RISING;
+	}
+
+	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
+		(common_flags & SOCAM_DATA_ACTIVE_LOW)) {
+			if (!pcdev->pdata ||
+			     pcdev->pdata->flags &
MX25_CAMERA_DATA_HIGH)
+				common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
+			else
+				common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
+	}
+
+	width_flags = common_flags & SOCAM_DATAWIDTH_MASK;
+
+	switch (xlate->host_fmt->bits_per_sample) {
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
+  struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	int ret, buswidth;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(icd->dev.parent, "Format %x not found\n", pix-
>pixelformat);
+		return -EINVAL;
+	}
+
+  buswidth = xlate->host_fmt->bits_per_sample;
+	if (buswidth > 8) {
+		dev_warn(icd->dev.parent,
+			 "bits-per-sample %d for format %x
unsupported\n",
+			 buswidth, pix->pixelformat);
+		return -EINVAL;
+  }
+
+  mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	if (mf.code != xlate->code)
+		return -EINVAL;
+
+	pix->width		= mf.width;
+	pix->height		= mf.height;
+	pix->field		= mf.field;
+	pix->colorspace		= mf.colorspace;
+	icd->current_fmt	= xlate;
+
+	return ret;
+}
+
+static int mx25_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	int ret;
+	/* TODO: limit to mx25 hardware capabilities */
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(icd->dev.parent, "Format %x not found\n",
+			 pix->pixelformat);
+		return -EINVAL;
+	}
+
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	/* limit to sensor capabilities */
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	pix->width	= mf.width;
+	pix->height	= mf.height;
+	pix->field	= mf.field;
+	pix->colorspace	= mf.colorspace;
+
+	return 0;
+}
+
+static int mx25_camera_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
+{
+	int i;
+
+	for (i = 0; i < p->count; i++) {
+		struct mx25_buffer *buf =
container_of(icf->vb_vidq.bufs[i],
+						      struct
mx25_buffer, vb);
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
+static int __devinit mx25_camera_probe(struct platform_device *pdev)
+{
+	struct mx25_camera_dev *pcdev;
+	struct resource *res;
+	struct clk *clk;
+	void __iomem *base;
+	unsigned int irq;
+	int err = 0;
+printk("%s: start\n", __func__);
+
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!res || (int)irq <= 0) {
+		printk(KERN_ERR "device problem: resource :%lx irq:%d\n"
+				, (long unsigned int) res, irq);
+		err = -ENODEV;
+		goto exit;
+	}
+printk("%s: irq sorted\n", __func__);
+
+	clk = clk_get(NULL, "csi_clk");/*&pdev->dev, NULL);*/
+	if (IS_ERR(clk)) {
+		err = PTR_ERR(clk);
+		goto exit;
+	}
+printk("%s: got clk\n", __func__);
+
+	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+		err = -ENOMEM;
+		goto exit_put_clk;
+	}
+printk("%s: pcdev allocated\n", __func__);
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
+			 "mclk_10khz == 0! Please, fix your platform
data. "
+			 "Using default 20MHz\n");
+		pcdev->mclk = 20000000;
+	}
+printk("%s: mclk init\n", __func__);
+
+	INIT_LIST_HEAD(&pcdev->capture);
+	spin_lock_init(&pcdev->lock);
+
+	/*
+	 * Request the regions.
+	 */
+	if (!request_mem_region(res->start, resource_size(res),
DRIVER_NAME)) {
+		err = -EBUSY;
+		goto exit_kfree;
+	}
+printk("%s: got mem region\n", __func__);
+
+	base = ioremap(res->start, resource_size(res));
+	if (!base) {
+		err = -ENOMEM;
+		goto exit_release;
+	}
+printk("%s: io remapped\n", __func__);
+	pcdev->irq    = irq;
+	pcdev->base   = base;
+	pcdev->csicr1 = base + CSICR1;
+	pcdev->csicr2 = base + CSICR2;
+	pcdev->csicr3 = base + CSICR3;
+	pcdev->csisr  = base + CSISR;
+
+	err = request_irq(irq, mx25_camera_irq_handler, 0 , DRIVER_NAME,
pcdev);
+	if (err) {
+		dev_err(&pdev->dev, "can't get irq%d: %d\n", irq, err);
+		goto exit_iounmap;
+	}
+printk("%s: got irq\n", __func__);
+
+	pcdev->soc_host.drv_name = DRIVER_NAME;
+	pcdev->soc_host.ops		 = &mx25_soc_camera_host_ops;
+	pcdev->soc_host.priv	 = pcdev;
+	pcdev->soc_host.v4l2_dev.dev = &pdev->dev;
+	pcdev->soc_host.nr		 = pdev->id;
+	err = soc_camera_host_register(&pcdev->soc_host);
+	if (err)
+		goto exit_iounmap;
+
+printk("%s: host resgistered\n", __func__);
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
+static int __devexit mx25_camera_remove(struct platform_device *pdev)
+{
+	struct soc_camera_host *soc_host =
to_soc_camera_host(&pdev->dev);
+	struct mx25_camera_dev *pcdev = container_of(soc_host,
+					struct mx25_camera_dev,
soc_host);
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
+			& ~(CSICR3_DMA_REQ_EN_RFF |
CSICR3_DMA_REQ_EN_SFF);
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
+    .owner = THIS_MODULE,
+	},
+  .probe    = mx25_camera_probe,
+	.remove		= mx25_camera_remove,
+};
+
+static int __init mx25_camera_init(void)
+{
+	return platform_driver_register(&mx25_camera_driver);//, 
mx25_camera_probe);
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
+MODULE_AUTHOR("Arno Euteneuer <arno.euteneuer <at> toptica.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -Nuar a/mx25_merlin.c b/mx25_merlin.c
--- a/mx25_merlin.c	1970-01-01 00:00:00.000000000 +0000
+++ b/mx25_merlin.c	2010-03-24 11:17:02.000000000 +0000
@@ -0,0 +1,39 @@
+#if (defined CONFIG_VIDEO_MX25) || (defined CONFIG_VIDEO_MX25_MODULE)
+static struct soc_camera_link iclink =
+{
+  .bus_id         = 0,
+  .i2c_adapter_id = 0,
+  .module_name    = "ov2640",
+#if 0
+  .board_info  = &mxc_i2c_board_info[2],
+#endif
+};
+
+static struct platform_device mx25_merlin_camera =
+{
+  .name = "soc-camera-pdrv",  
+  .id   = 0,
+  .dev  = {
+    .platform_data = &iclink,
+  },
+};
+
+#endif /* CONFIG_VIDEO_MX25 */
+
+static struct i2c_board_info mxc_i2c_board_info[] __initdata = {
+	{
+	 .type = "sgtl5000-i2c",
+	 .addr = 0x0a,
+	 },
+	{
+	 .type = "ak5702-i2c",
+	 .addr = 0x13,
+	 },
+  { I2C_BOARD_INFO("ov2640", 0x30),
+#if (defined CONFIG_VIDEO_MX25) || (defined CONFIG_VIDEO_MX25_MODULE)
+    .platform_data = (void *)&mx25_merlin_camera,
+#else
+    .platform_data = (void *)&camera_data,
+#endif
+  },
+};
diff -Nuar a/ov2640.c b/ov2640.c
--- a/ov2640.c	1970-01-01 00:00:00.000000000 +0000
+++ b/ov2640.c	2010-03-24 10:59:14.000000000 +0000
@@ -0,0 +1,687 @@
+/*
+ * A V4L2 driver for OmniVision OV2640 cameras.
+ *
+ * Copyright 2010 Plextek Ltd <aps@plextek.co.uk>
+ *   Inspiration taken from OV7670 driver by Jonathan Corbet
+ *   and the OV2640 driver from Freescale
+ *
+ * This file may be distributed under the terms of the GNU General
+ * Public License, version 2.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-i2c-drv.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/soc_camera.h>
+
+/*
------------------------------------------------------------------------
*/
+// Miscellaneous
+/*
------------------------------------------------------------------------
*/
+
+static int debug;
+
+/*
------------------------------------------------------------------------
*/
+// Registers
+/*
------------------------------------------------------------------------
*/
+
+#define REG_MIDH	0x1c	/* Manuf. ID high */
+#define REG_MIDL	0x1d	/* Manuf. ID low */
+#define REG_PID		0x0a	/* Product ID MSB */
+#define REG_VER		0x0b	/* Product ID LSB */
+#define REG_RADLMT 0xff /* Register Bank Select */
+#define  RADLMT_DSP 0x00 /*   DSP */
+#define  RADLMT_SEN 0x01 /*   Sensor */
+#define REG_IMGMODE 0xda /* Image Mode */
+#define  IMGMODE_YUV422 0x00
+#define  IMGMODE_YUV_LE 0x00
+#define  IMGMODE_YUV_BE 0x01
+#define  IMGMODE_RGB565 0x08
+#define  IMGMODE_JPEG   0x10
+#define REG_CLKRC   0x11 /* Clock Rate Control */
+#define   CLKRC_INTDBL 0x80
+#define   CLK_SCALE    0x1f
+
+/* Default settings - Omnivision magic numbers (from Freescale driver)
*/
+struct regval_list {
+	u8  reg;
+	u8  val;
+	int delay_ms;
+};
+
+static struct regval_list ov2640_setting_800_600[] = {
+#ifdef CONFIG_MACH_MX25_3DS
+	{0xff, 0x01, 0}, {0x12, 0x80, 5}, {0xff, 0x00, 0}, {0x2c, 0xff,
0},
+	{0x2e, 0xdf, 0}, {0xff, 0x01, 0}, {0x3c, 0x32, 0}, {0x11, 0x00,
0},
+	{0x09, 0x02, 0}, {0x04, 0x28, 0}, {0x13, 0xe5, 0}, {0x14, 0x48,
0},
+	{0x2c, 0x0c, 0}, {0x33, 0x78, 0}, {0x3a, 0x33, 0}, {0x3b, 0xfb,
0},
+	{0x3e, 0x00, 0}, {0x43, 0x11, 0}, {0x16, 0x10, 0}, {0x39, 0x92,
0},
+	{0x35, 0xda, 0}, {0x22, 0x1a, 0}, {0x37, 0xc3, 0}, {0x23, 0x00,
0},
+	{0x34, 0xc0, 0}, {0x36, 0x1a, 0}, {0x06, 0x88, 0}, {0x07, 0xc0,
0},
+	{0x0d, 0x87, 0}, {0x0e, 0x41, 0}, {0x4c, 0x00, 0},
+	{0x48, 0x00, 0}, {0x5b, 0x00, 0}, {0x42, 0x03, 0}, {0x4a, 0x81,
0},
+	{0x21, 0x99, 0}, {0x24, 0x40, 0}, {0x25, 0x38, 0}, {0x26, 0x82,
0},
+	{0x5c, 0x00, 0}, {0x63, 0x00, 0}, {0x46, 0x22, 0}, {0x0c, 0x3c,
0},
+	{0x61, 0x70, 0}, {0x62, 0x80, 0}, {0x7c, 0x05, 0}, {0x20, 0x80,
0},
+	{0x28, 0x30, 0}, {0x6c, 0x00, 0}, {0x6d, 0x80, 0}, {0x6e, 0x00,
0},
+	{0x70, 0x02, 0}, {0x71, 0x94, 0}, {0x73, 0xc1, 0}, {0x12, 0x40,
0},
+	{0x17, 0x11, 0}, {0x18, 0x43, 0}, {0x19, 0x00, 0}, {0x1a, 0x4b,
0},
+	{0x32, 0x09, 0}, {0x37, 0xc0, 0}, {0x4f, 0xca, 0}, {0x50, 0xa8,
0},
+	{0x5a, 0x23, 0}, {0x6d, 0x00, 0}, {0x3d, 0x38, 0}, {0xff, 0x00,
0},
+	{0xe5, 0x7f, 0}, {0xf9, 0xc0, 0}, {0x41, 0x24, 0}, {0xe0, 0x14,
0},
+	{0x76, 0xff, 0}, {0x33, 0xa0, 0}, {0x42, 0x20, 0}, {0x43, 0x18,
0},
+	{0x4c, 0x00, 0}, {0x87, 0xd5, 0}, {0x88, 0x3f, 0}, {0xd7, 0x01,
0},
+	{0xd9, 0x10, 0}, {0xd3, 0x82, 0}, {0xc8, 0x08, 0}, {0xc9, 0x80,
0},
+	{0x7c, 0x00, 0}, {0x7d, 0x00, 0}, {0x7c, 0x03, 0}, {0x7d, 0x48,
0},
+	{0x7d, 0x48, 0}, {0x7c, 0x08, 0}, {0x7d, 0x20, 0}, {0x7d, 0x10,
0},
+	{0x7d, 0x0e, 0}, {0x90, 0x00, 0}, {0x91, 0x0e, 0}, {0x91, 0x1a,
0},
+	{0x91, 0x31, 0}, {0x91, 0x5a, 0}, {0x91, 0x69, 0}, {0x91, 0x75,
0},
+	{0x91, 0x7e, 0}, {0x91, 0x88, 0}, {0x91, 0x8f, 0}, {0x91, 0x96,
0},
+	{0x91, 0xa3, 0}, {0x91, 0xaf, 0}, {0x91, 0xc4, 0}, {0x91, 0xd7,
0},
+	{0x91, 0xe8, 0}, {0x91, 0x20, 0}, {0x92, 0x00, 0}, {0x93, 0x06,
0},
+	{0x93, 0xe3, 0}, {0x93, 0x05, 0}, {0x93, 0x05, 0}, {0x93, 0x00,
0},
+	{0x93, 0x04, 0}, {0x93, 0x00, 0}, {0x93, 0x00, 0}, {0x93, 0x00,
0},
+	{0x93, 0x00, 0}, {0x93, 0x00, 0}, {0x93, 0x00, 0}, {0x93, 0x00,
0},
+	{0x96, 0x00, 0}, {0x97, 0x08, 0}, {0x97, 0x19, 0}, {0x97, 0x02,
0},
+	{0x97, 0x0c, 0}, {0x97, 0x24, 0}, {0x97, 0x30, 0}, {0x97, 0x28,
0},
+	{0x97, 0x26, 0}, {0x97, 0x02, 0}, {0x97, 0x98, 0}, {0x97, 0x80,
0},
+	{0x97, 0x00, 0}, {0x97, 0x00, 0}, {0xc3, 0xed, 0}, {0xa4, 0x00,
0},
+	{0xa8, 0x00, 0}, {0xc5, 0x11, 0}, {0xc6, 0x51, 0}, {0xbf, 0x80,
0},
+	{0xc7, 0x10, 0}, {0xb6, 0x66, 0}, {0xb8, 0xa5, 0}, {0xb7, 0x64,
0},
+	{0xb9, 0x7c, 0}, {0xb3, 0xaf, 0}, {0xb4, 0x97, 0}, {0xb5, 0xff,
0},
+	{0xb0, 0xc5, 0}, {0xb1, 0x94, 0}, {0xb2, 0x0f, 0}, {0xc4, 0x5c,
0},
+	{0xc0, 0x64, 0}, {0xc1, 0x4b, 0}, {0x8c, 0x00, 0}, {0x86, 0x3d,
0},
+	{0x50, 0x00, 0}, {0x51, 0xc8, 0}, {0x52, 0x96, 0}, {0x53, 0x00,
0},
+	{0x54, 0x00, 0}, {0x55, 0x00, 0}, {0x5a, 0xc8, 0}, {0x5b, 0x96,
0},
+	{0x5c, 0x00, 0}, {0xd3, 0x82, 0}, {0xc3, 0xed, 0}, {0x7f, 0x00,
0},
+	{0xda, 0x00, 0}, {0xe5, 0x1f, 0}, {0xe1, 0x67, 0}, {0xe0, 0x00,
0},
+	{0xdd, 0x7f, 0}, {0x05, 0x00, 0}, {0xff, 0x00, 0}, {0xe0, 0x04,
0},
+	{0xc0, 0x64, 0}, {0xc1, 0x4b, 0}, {0x8c, 0x00, 0}, {0x86, 0x3d,
0},
+	{0x50, 0x00, 0}, {0x51, 0xc8, 0}, {0x52, 0x96, 0}, {0x53, 0x00,
0},
+	{0x54, 0x00, 0}, {0x55, 0x00, 0}, {0x5a, 0xa0, 0}, {0x5b, 0x78,
0},
+	{0x5c, 0x00, 0}, {0xd3, 0x82, 0}, {0xe0, 0x00, 1000}
+#else
+	{0xff, 0, 0}, {0xff, 1, 0}, {0x12, 0x80, 1}, {0xff, 00, 0},
+	{0x2c, 0xff, 0}, {0x2e, 0xdf, 0}, {0xff, 0x1, 0}, {0x3c, 0x32,
0},
+	{0x11, 0x01, 0}, {0x09, 0x00, 0}, {0x04, 0x28, 0}, {0x13, 0xe5,
0},
+	{0x14, 0x48, 0}, {0x2c, 0x0c, 0}, {0x33, 0x78, 0}, {0x3a, 0x33,
0},
+	{0x3b, 0xfb, 0}, {0x3e, 0x00, 0}, {0x43, 0x11, 0}, {0x16, 0x10,
0},
+	{0x39, 0x92, 0}, {0x35, 0xda, 0}, {0x22, 0x1a, 0}, {0x37, 0xc3,
0},
+	{0x23, 0x00, 0}, {0x34, 0xc0, 0}, {0x36, 0x1a, 0}, {0x06, 0x88,
0},
+	{0x07, 0xc0, 0}, {0x0d, 0x87, 0}, {0x0e, 0x41, 0}, {0x4c, 0x00,
0},
+	{0x4a, 0x81, 0}, {0x21, 0x99, 0}, {0x24, 0x40, 0}, {0x25, 0x38,
0},
+	{0x26, 0x82, 0}, {0x5c, 0x00, 0}, {0x63, 0x00, 0}, {0x46, 0x22,
0},
+	{0x0c, 0x3c, 0}, {0x5d, 0x55, 0}, {0x5e, 0x7d, 0}, {0x5f, 0x7d,
0},
+	{0x60, 0x55, 0}, {0x61, 0x70, 0}, {0x62, 0x80, 0}, {0x7c, 0x05,
0},
+	{0x20, 0x80, 0}, {0x28, 0x30, 0}, {0x6c, 0x00, 0}, {0x6d, 0x80,
0},
+	{0x6e, 00, 0}, {0x70, 0x02, 0}, {0x71, 0x94, 0}, {0x73, 0xc1,
0},
+	{0x12, 0x40, 0}, {0x17, 0x11, 0}, {0x18, 0x43, 0}, {0x19, 0x00,
0},
+	{0x1a, 0x4b, 0}, {0x32, 0x09, 0}, {0x37, 0xc0, 0}, {0x4f, 0xca,
0},
+	{0x50, 0xa8, 0}, {0x6d, 0x00, 0}, {0x3d, 0x38, 0}, {0xff, 0x00,
0},
+	{0xe5, 0x7f, 0}, {0xf9, 0xc0, 0}, {0x41, 0x24, 0}, {0x44, 0x06,
0},
+	{0xe0, 0x14, 0}, {0x76, 0xff, 0}, {0x33, 0xa0, 0}, {0x42, 0x20,
0},
+	{0x43, 0x18, 0}, {0x4c, 0x00, 0}, {0x87, 0xd0, 0}, {0x88, 0x3f,
0},
+	{0xd7, 0x03, 0}, {0xd9, 0x10, 0}, {0xd3, 0x82, 0}, {0xc8, 0x08,
0},
+	{0xc9, 0x80, 0}, {0x7c, 0x00, 0}, {0x7d, 0x00, 0}, {0x7c, 0x03,
0},
+	{0x7d, 0x48, 0}, {0x7d, 0x48, 0}, {0x7c, 0x08, 0}, {0x7d, 0x20,
0},
+	{0x7d, 0x10, 0}, {0x7d, 0x0e, 0}, {0x90, 0x00, 0}, {0x91, 0x0e,
0},
+	{0x91, 0x1a, 0}, {0x91, 0x31, 0}, {0x91, 0x5a, 0}, {0x91, 0x69,
0},
+	{0x91, 0x75, 0}, {0x91, 0x7e, 0}, {0x91, 0x88, 0}, {0x91, 0x8f,
0},
+	{0x91, 0x96, 0}, {0x91, 0xa3, 0}, {0x91, 0xaf, 0}, {0x91, 0xc4,
0},
+	{0x91, 0xd7, 0}, {0x91, 0xe8, 0}, {0x91, 0x20, 0}, {0x92, 0x00,
0},
+	{0x93, 0x06, 0}, {0x93, 0xe3, 0}, {0x93, 0x03, 0}, {0x93, 0x03,
0},
+	{0x93, 0x00, 0}, {0x93, 0x02, 0}, {0x93, 0x00, 0}, {0x93, 0x00,
0},
+	{0x93, 0x00, 0}, {0x93, 0x00, 0}, {0x93, 0x00, 0}, {0x93, 0x00,
0},
+	{0x93, 0x00, 0}, {0x96, 0x00, 0}, {0x97, 0x08, 0}, {0x97, 0x19,
0},
+	{0x97, 0x02, 0}, {0x97, 0x0c, 0}, {0x97, 0x24, 0}, {0x97, 0x30,
0},
+	{0x97, 0x28, 0}, {0x97, 0x26, 0}, {0x97, 0x02, 0}, {0x97, 0x98,
0},
+	{0x97, 0x80, 0}, {0x97, 0x00, 0}, {0x97, 0x00, 0}, {0xa4, 0x00,
0},
+	{0xa8, 0x00, 0}, {0xc5, 0x11, 0}, {0xc6, 0x51, 0}, {0xbf, 0x80,
0},
+	{0xc7, 0x10, 0}, {0xb6, 0x66, 0}, {0xb8, 0xa5, 0}, {0xb7, 0x64,
0},
+	{0xb9, 0x7c, 0}, {0xb3, 0xaf, 0}, {0xb4, 0x97, 0}, {0xb5, 0xff,
0},
+	{0xb0, 0xc5, 0}, {0xb1, 0x94, 0}, {0xb2, 0x0f, 0}, {0xc4, 0x5c,
0},
+	{0xa6, 0x00, 0}, {0xa7, 0x20, 0}, {0xa7, 0xd8, 0}, {0xa7, 0x1b,
0},
+	{0xa7, 0x31, 0}, {0xa7, 0x00, 0}, {0xa7, 0x18, 0}, {0xa7, 0x20,
0},
+	{0xa7, 0xd8, 0}, {0xa7, 0x19, 0}, {0xa7, 0x31, 0}, {0xa7, 0x00,
0},
+	{0xa7, 0x18, 0}, {0xa7, 0x20, 0}, {0xa7, 0xd8, 0}, {0xa7, 0x19,
0},
+	{0xa7, 0x31, 0}, {0xa7, 0x00, 0}, {0xa7, 0x18, 0}, {0xc0, 0x64,
0},
+	{0xc1, 0x4b, 0}, {0x86, 0x1d, 0}, {0x50, 0x00, 0}, {0x51, 0xc8,
0},
+	{0x52, 0x96, 0}, {0x53, 0x00, 0}, {0x54, 0x00, 0}, {0x55, 0x00,
0},
+	{0x57, 0x00, 0}, {0x5a, 0xc8, 0}, {0x5b, 0x96, 0}, {0x5c, 0x00,
0},
+	{0xc3, 0xef, 0}, {0x7f, 0x00, 0}, {0xda, 0x01, 0}, {0xe5, 0x1f,
0},
+	{0xe1, 0x67, 0}, {0xe0, 0x00, 0}, {0xdd, 0x7f, 0}, {0x05, 0x00,
0}
+#endif
+  ,{0xff, 0xff, 0}
+};
+
+/*
+ * Low-level register I/O.
+ */
+static int ov2640_read
+  ( struct v4l2_subdev *sd, unsigned char reg, unsigned char *val )
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret >= 0) {
+		*val = (unsigned char)ret;
+		ret  = 0;
+	}
+	return ret;
+}
+
+static int ov2640_write
+  ( struct v4l2_subdev *sd, unsigned char reg, unsigned char val )
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = i2c_smbus_write_byte_data(client, reg, val);
+	return ret;
+}
+
+/*
+ * Write a list of register settings; ff/ff stops the process.
+ */
+static int ov2640_write_array
+  ( struct v4l2_subdev *sd, struct regval_list *vals )
+{
+	while (vals->reg != 0xff || vals->val != 0xff) {
+		int ret = ov2640_write(sd, vals->reg, vals->val);
+		if (ret < 0) return ret;
+    if ( vals->delay_ms > 0 )
+      msleep(vals->delay_ms);
+		vals++;
+	}
+	return 0;
+}
+
+/*
------------------------------------------------------------------------
*/
+// Output formats
+/*
------------------------------------------------------------------------
*/
+
+struct ov2640_datafmt
+{
+  enum   v4l2_mbus_pixelcode code;
+  enum   v4l2_colorspace     colorspace;
+  struct regval_list*        regs;
+};
+
+static struct regval_list ov2640_setting_uyvy[] =
+{
+#if 0 // default
+  { REG_RADLMT,  RADLMT_DSP, 0 },
+  { REG_IMGMODE, IMGMODE_YUV422 | IMGMODE_YUV_BE },
+  { 0xd7, 0x1b,  0 },
+#endif
+  { 0xff, 0xff,  -1 },
+};
+
+static struct regval_list ov2640_setting_rgb565[] =
+{
+  { REG_RADLMT,  RADLMT_DSP, 0 },
+  { REG_IMGMODE, IMGMODE_RGB565, 0 },
+  { 0xd7, 0x03,  0 },
+  { 0xff, 0xff,  -1 },
+};
+
+static struct regval_list ov2640_setting_yuyv[] =
+{
+  { REG_RADLMT,  RADLMT_DSP, 0 },
+  { REG_IMGMODE, IMGMODE_YUV422 | IMGMODE_YUV_LE },
+  { 0xd7, 0x1b,  0 },
+  { 0xff, 0xff,  -1 },
+};
+
+static const struct ov2640_datafmt ov2640_fmts[] =
+{
+  {
+    .code       = V4L2_MBUS_FMT_YUYV8_2X8_BE,
+    .colorspace = V4L2_COLORSPACE_SRGB,
+    .regs       = ov2640_setting_uyvy
+  },
+  {
+    .code       = V4L2_MBUS_FMT_RGB565_2X8_LE,
+    .colorspace = V4L2_COLORSPACE_SRGB,
+    .regs       = ov2640_setting_rgb565,
+  },
+  {
+    .code       = V4L2_MBUS_FMT_YUYV8_2X8_LE,
+    .colorspace = V4L2_COLORSPACE_SRGB,
+    .regs       = ov2640_setting_yuyv
+  },
+};
+
+/*
------------------------------------------------------------------------
*/
+// Private Data
+/*
------------------------------------------------------------------------
*/
+
+struct ov2640_info
+{
+	struct       v4l2_subdev    sd;   /* Sub-device info */
+	const struct ov2640_datafmt *fmt; /* Current fmt */
+};
+
+static inline struct ov2640_info *to_ov2640
+  ( struct v4l2_subdev *sd )
+{
+	return container_of(sd, struct ov2640_info, sd);
+}
+
+/*
------------------------------------------------------------------------
*/
+// Utilities
+/*
------------------------------------------------------------------------
*/
+
+#if 0
+static int ov2640_reset(struct v4l2_subdev *sd, u32 val)
+{
+	ov2640_write(sd, REG_COM7, COM7_RESET);
+	msleep(1);
+	return 0;
+}
+#endif
+
+static int ov2640_init(struct v4l2_subdev *sd, u32 val)
+{
+	return ov2640_write_array(sd, ov2640_setting_800_600);
+}
+
+/*
+ * Detect chip type (make sure its ov2640)
+ */
+static int ov2640_video_probe ( struct v4l2_subdev *sd )
+{
+	unsigned char v;
+	int ret;
+
+	ret = ov2640_init(sd, 0);
+	if (ret < 0)
+		return ret;
+	ret = ov2640_read(sd, REG_MIDH, &v);
+	if (ret < 0)
+		return ret;
+	if (v != 0x7f) /* OV manuf. id. */
+		return -ENODEV;
+	ret = ov2640_read(sd, REG_MIDL, &v);
+	if (ret < 0)
+		return ret;
+	if (v != 0xa2)
+		return -ENODEV;
+	/*
+	 * OK, we know we have an OmniVision chip...but which one?
+	 */
+	ret = ov2640_read(sd, REG_PID, &v);
+	if (ret < 0)
+		return ret;
+	if (v != 0x26) /* Product Family */
+		return -ENODEV;
+	ret = ov2640_read(sd, REG_VER, &v);
+	if (ret < 0)
+		return ret;
+	if (v != 0x42)  /* Product Version */
+		return -ENODEV;
+	return 0;
+}
+
+/*
------------------------------------------------------------------------
*/
+// SOC Ops
+/*
------------------------------------------------------------------------
*/
+
+static const struct v4l2_queryctrl ov2640_controls[] =
+{
+};
+
+static unsigned long ov2640_query_bus_param
+  ( struct soc_camera_device *icd )
+{
+  return 0;
+}
+
+static int ov2640_set_bus_param
+  ( struct soc_camera_device *icd, unsigned long flags )
+{
+  return 0;
+}
+
+/*
------------------------------------------------------------------------
*/
+// Subdev Video Ops
+/*
------------------------------------------------------------------------
*/
+
+/* Start/Stop streaming */
+static int ov2640_s_stream ( struct v4l2_subdev *sd, int enable )
+{
+	return 0;
+}
+
+/* Enumerate formats */
+static int ov2640_enum_fmt
+	( struct v4l2_subdev *sd, int index, enum v4l2_mbus_pixelcode
*code )
+{
+	if ( (unsigned int)index >= ARRAY_SIZE(ov2640_fmts) )
+		return -EINVAL;
+	*code = ov2640_fmts[index].code;
+  return 0;
+}
+
+/* Internal try format that returns the idx of the selected format */
+static int ov2640_try_fmt_internal
+	( struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf, int*
idxout )
+{
+  int idx;
+
+  // TODO: can support other YUV formats in compressed JPEG
+  //       but not yet included here
+
+  /* Find format (default to 0) */
+  for ( idx = 0; idx < ARRAY_SIZE(ov2640_fmts); idx++ ) {
+    if ( ov2640_fmts[idx].code == mf->code ) {
+      break;
+    }
+  }
+  if ( idx >= ARRAY_SIZE(ov2640_fmts) ) {
+    idx = 0;
+  }
+
+  /* TODO: currently fixed */
+	mf->field      = V4L2_FIELD_NONE;
+  mf->width      = 800;
+  mf->height     = 600;
+
+  /* Update format details */
+  mf->code       = ov2640_fmts[idx].code;
+  mf->colorspace = ov2640_fmts[idx].colorspace;
+
+  /* Return index */
+  if ( idxout ) *idxout = idx;
+
+  return 0;
+}
+  
+
+/* Try format */
+static int ov2640_try_fmt
+	( struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf )
+{
+  return ov2640_try_fmt_internal(sd, mf, NULL);
+}
+
+/* Set format */
+static int ov2640_s_fmt
+	( struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf )
+{
+  int ret;
+  int idx;
+  struct ov2640_info *info;
+
+  /* Determine the actual format to use */
+  ov2640_try_fmt_internal(sd, mf, &idx);
+
+  /* Set defaults for 800x600 */
+  ret = ov2640_write_array(sd, ov2640_setting_800_600); // magic!
+  if ( ret ) return ret;
+
+  /* Set format specific */
+  ret = ov2640_write_array(sd, ov2640_fmts[idx].regs);
+  if ( ret ) return ret;
+
+  /* Update current format */
+  info = to_ov2640(sd);
+  info->fmt = &ov2640_fmts[idx];
+  
+	return ret;
+}
+
+/* Get crop capability */
+static int ov2640_cropcap
+	( struct v4l2_subdev *sd, struct v4l2_cropcap* a )
+{
+	return 0;
+}
+
+/* Get a crop */
+static int ov2640_g_crop
+	( struct v4l2_subdev *sd, struct v4l2_crop *a )
+{
+	return 0;
+}
+
+/*
------------------------------------------------------------------------
*/
+// Subdev Core Ops
+/*
------------------------------------------------------------------------
*/
+
+static int ov2640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control
*ctrl)
+{
+#if 0
+	struct i2c_client  *client = v4l2_get_subdevdata(sd);
+	struct ov2640_info *info   =
container_of(i2c_get_clientdata(client),
+	                                          struct ov2640_info,
sd);
+
+	/* TODO: what do we support? */
+	switch (ctrl->id) {
+	}
+#endif
+	return -EINVAL;
+}
+
+static int ov2640_s_ctrl
+	( struct v4l2_subdev *sd, struct v4l2_control *ctrl )
+{
+#if 0
+	struct i2c_client  *client = v4l2_get_subdevdata(sd);
+	struct ov2640_info *info   =
container_of(i2c_get_clientdata(client),
+	                                          struct ov2640_info,
sd);
+
+	/* TODO: what do we support? */
+	switch (ctrl->id) {
+	}
+#endif
+
+	return -EINVAL;
+}
+
+static int ov2640_g_chip_ident(struct v4l2_subdev *sd,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip,
V4L2_IDENT_OV2640, 0);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov2640_g_register
+	( struct v4l2_subdev *sd, struct v4l2_dbg_register *reg )
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	unsigned char val = 0;
+	int ret;
+
+	if (!v4l2_chip_match_i2c_client(client, (r)->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = ov2640_read(sd, reg->reg & 0xff, &val);
+	if ( ret )
+		return ret;
+
+	reg->val  = val;
+	reg->size = 1;
+	return ret;
+}
+
+static int ov2640_s_register(struct v4l2_subdev *sd, struct
v4l2_dbg_register 
*reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, (r)->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ov2640_write(sd, reg->reg & 0xff, reg->val & 0xff);
+	return 0;
+}
+#endif
+
+/*
------------------------------------------------------------------------
*/
+// Operations Specs
+/*
------------------------------------------------------------------------
*/
+
+static struct soc_camera_ops ov2640_ops =
+{
+#if 0 // TODO: implement power control
+	.suspend         = ov2640_suspend,
+	.resume          = ov2640_resume,
+#endif
+	.query_bus_param = ov2640_query_bus_param,
+	.set_bus_param   = ov2640_set_bus_param,
+	.controls        = ov2640_controls,
+	.num_controls    = ARRAY_SIZE(ov2640_controls),
+};
+
+static const struct v4l2_subdev_core_ops ov2640_core_ops =
+{
+	.g_chip_ident = ov2640_g_chip_ident,
+	.g_ctrl       = ov2640_g_ctrl,
+	.s_ctrl       = ov2640_s_ctrl,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register   = ov2640_g_register,
+	.s_register   = ov2640_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_video_ops ov2640_video_ops = {
+	.enum_mbus_fmt = ov2640_enum_fmt,
+	.try_mbus_fmt  = ov2640_try_fmt,
+  .s_mbus_fmt    = ov2640_s_fmt,
+  .cropcap       = ov2640_cropcap,
+  .g_crop        = ov2640_g_crop,
+  .s_stream      = ov2640_s_stream,
+#if 0
+	.g_mbus_fmt    = ov2640_g_fmt
+	.s_crop        = ov2640_s_crop,
+#endif // Need to decide exactly what we need to support
+#if 0 // previously included?
+	.s_parm        = ov2640_s_parm,
+	.g_parm        = ov2640_g_parm,
+#endif
+};
+
+static const struct v4l2_subdev_ops ov2640_subdev_ops =
+{
+	.core  = &ov2640_core_ops,
+	.video = &ov2640_video_ops,
+};
+
+/*
------------------------------------------------------------------------
*/
+// I2C Device Spec
+/*
------------------------------------------------------------------------
*/
+
+/* Find device */
+static int ov2640_probe
+  ( struct i2c_client *client, const struct i2c_device_id *id )
+{
+	int ret = 0;
+	struct ov2640_info *info;
+  struct soc_camera_device *icd;
+  struct soc_camera_link *icl;
+	struct v4l2_subdev *sd;
+
+  /* Check adapter support */
+  if ( !i2c_check_functionality(client->adapter,
+          I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA) )
{
+		dev_err(&client->dev, "I2C does not supported require 
functions");
+    return -EIO;
+  }
+
+  /* Setup SOC */
+  icd = client->dev.platform_data;
+  if ( !icd ) {
+    dev_err(&client->dev, "Missing soc-camera data!\n");
+    return -EINVAL;
+  }
+  icl = to_soc_camera_link(icd);
+  if ( !icl ) {
+    dev_err(&client->dev, "Missing platform_data for driver!\n");
+    return -EINVAL;
+  }
+
+  /* Create private data */
+	info = kzalloc(sizeof(struct ov2640_info), GFP_KERNEL);
+	if (!info) {
+    dev_err(&client->dev, "Failed to allocate priv data!\n");
+		return -ENOMEM;
+  }
+
+  /* Register subdevice */
+	sd = &info->sd;
+	v4l2_i2c_subdev_init(sd, client, &ov2640_subdev_ops);
+
+  /* Check chip type */
+  icd->ops = &ov2640_ops;
+	ret      = ov2640_video_probe(sd);
+	if (ret) {
+    icd->ops = NULL;
+    i2c_set_clientdata(client, NULL);
+		v4l2_dbg(1, debug, sd,
+		        "chip found @ 0x%x (%s) is not an ov2640
chip.\n",
+		        client->addr << 1, client->adapter->name);
+		kfree(info);
+	} else {
+  	v4l2_info(sd, "chip found @ 0x%02x (%s)\n",
+		         client->addr << 1, client->adapter->name);
+
+    /* Configure priv data */
+	  info->fmt = &ov2640_fmts[0];
+  }
+
+	return ret;
+}
+
+// Removed
+static int ov2640_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+  v4l2_dbg(1, debug, sd, "removing ov2640 adapter on address 0x%x\n",
+	         client->addr << 1);          
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_ov2640(sd));
+	return 0;
+}
+
+static const struct i2c_device_id ov2640_id[] =
+{
+	{ "ov2640", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ov2640_id);
+
+/* Note: name of this variable is defined in v4l2-i2c-drv.h */
+static struct v4l2_i2c_driver_data v4l2_i2c_data =
+{
+	.name     = "ov2640",
+	.probe    = ov2640_probe,
+	.remove   = ov2640_remove,
+	.id_table = ov2640_id,
+};
+
+/*
------------------------------------------------------------------------
*/
+// Module Spec
+/*
------------------------------------------------------------------------
*/
+
+/**
+ * Note: we don't need to specify module_init/exit routines, these are
+ * handled by the v4l2-i2c-drv.h (as this is a standard V4L2 I2C
subdev)
+ */
+
+/* Basic Info */
+MODULE_AUTHOR("Adam Sutton <aps@plextek.co.uk>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision ov2640 sensors");
+MODULE_LICENSE("GPL");
+
+/* Parameters */
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Debug level (0-1)");
======================================================== Plextek Limited 
Registered Address: London Road, Great Chesterford, Essex, CB10 1NY, UK 
Company Registration No. 2305889 
VAT Registration No. GB 918 4425 15
Tel: +44 1799 533 200. Fax: +44 1799 533 201 Web: http://www.plextek.com 
Electronics Design and Consultancy 
======================================================== 

