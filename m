Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABGvd5o000876
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:57:39 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mABGuinN002643
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:57:06 -0500
Date: Tue, 11 Nov 2008 17:56:56 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811111738010.4565@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811111744490.4565@axis700.grange>
References: <Pine.LNX.4.64.0811111738010.4565@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 2/3] soc-camera: camera host driver for i.MX3x SoCs
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

Tested with 8 bit Bayer and 8 bit monochrome video.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
diff --git a/arch/arm/plat-mxc/include/mach/mx3_camera.h b/arch/arm/plat-mxc/include/mach/mx3_camera.h
new file mode 100644
index 0000000..ed0e8d6
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/mx3_camera.h
@@ -0,0 +1,43 @@
+/*
+ * mx3_camera.h - i.MX3x camera driver header file
+ *
+ * Copyright (C) 2008, Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __ASM_ARCH_CAMERA_H_
+#define __ASM_ARCH_CAMERA_H_
+
+#define MX3_CAMERA_CLK_SRC	1
+#define MX3_CAMERA_EXT_VSYNC	2
+#define MX3_CAMERA_DP		4
+#define MX3_CAMERA_PCP		8
+#define MX3_CAMERA_HSP		0x10
+#define MX3_CAMERA_VSP		0x20
+#define MX3_CAMERA_DATAWIDTH_4	0x40
+#define MX3_CAMERA_DATAWIDTH_8	0x80
+#define MX3_CAMERA_DATAWIDTH_10	0x100
+#define MX3_CAMERA_DATAWIDTH_15	0x200
+
+#define MX3_CAMERA_DATAWIDTH_MASK (MX3_CAMERA_DATAWIDTH_4 | MX3_CAMERA_DATAWIDTH_8 | \
+				   MX3_CAMERA_DATAWIDTH_10 | MX3_CAMERA_DATAWIDTH_15)
+
+struct mx3_camera_pdata {
+	unsigned long flags;
+	unsigned long mclk_10khz;
+};
+
+#endif
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 7b363da..9be61ba 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -770,6 +770,13 @@ config VIDEO_SH_MOBILE_CEU
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface
 
+config VIDEO_MX3
+	tristate "i.MX3x Camera Sensor Interface driver"
+	depends on VIDEO_DEV && ARCH_MX3 && SOC_CAMERA
+	select VIDEOBUF_DMA_CONTIG
+	---help---
+	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
+
 #
 # USB Multimedia device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc6698e..c7d142c 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -127,9 +127,10 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
-obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
+obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
-obj-$(CONFIG_SOC_CAMERA)	+= soc_camera.o
+obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
new file mode 100644
index 0000000..97f31bc
--- /dev/null
+++ b/drivers/media/video/mx3_camera.c
@@ -0,0 +1,1118 @@
+/*
+ * V4L2 Driver for i.MX3x camera host
+ *
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf-dma-contig.h>
+#include <media/soc_camera.h>
+
+#include <mach/ipu.h>
+#include <mach/mx3_camera.h>
+
+#define MX3_CAM_DRV_NAME "mx3-camera"
+
+/* CMOS Sensor Interface Registers */
+#define CSI_REG_START		0x60
+
+#define CSI_SENS_CONF		(0x60 - CSI_REG_START)
+#define CSI_SENS_FRM_SIZE	(0x64 - CSI_REG_START)
+#define CSI_ACT_FRM_SIZE	(0x68 - CSI_REG_START)
+#define CSI_OUT_FRM_CTRL	(0x6C - CSI_REG_START)
+#define CSI_TST_CTRL		(0x70 - CSI_REG_START)
+#define CSI_CCIR_CODE_1		(0x74 - CSI_REG_START)
+#define CSI_CCIR_CODE_2		(0x78 - CSI_REG_START)
+#define CSI_CCIR_CODE_3		(0x7C - CSI_REG_START)
+#define CSI_FLASH_STROBE_1	(0x80 - CSI_REG_START)
+#define CSI_FLASH_STROBE_2	(0x84 - CSI_REG_START)
+
+#define CSI_SENS_CONF_VSYNC_POL_SHIFT		0
+#define CSI_SENS_CONF_HSYNC_POL_SHIFT		1
+#define CSI_SENS_CONF_DATA_POL_SHIFT		2
+#define CSI_SENS_CONF_PIX_CLK_POL_SHIFT		3
+#define CSI_SENS_CONF_SENS_PRTCL_SHIFT		4
+#define CSI_SENS_CONF_SENS_CLKSRC_SHIFT		7
+#define CSI_SENS_CONF_DATA_FMT_SHIFT		8
+#define CSI_SENS_CONF_DATA_WIDTH_SHIFT		10
+#define CSI_SENS_CONF_EXT_VSYNC_SHIFT		15
+#define CSI_SENS_CONF_DIVRATIO_SHIFT		16
+
+#define CSI_SENS_CONF_DATA_FMT_RGB_YUV444	(0UL << CSI_SENS_CONF_DATA_FMT_SHIFT)
+#define CSI_SENS_CONF_DATA_FMT_YUV422		(2UL << CSI_SENS_CONF_DATA_FMT_SHIFT)
+#define CSI_SENS_CONF_DATA_FMT_BAYER		(3UL << CSI_SENS_CONF_DATA_FMT_SHIFT)
+
+/* Protect camera add / remove operations */
+static DEFINE_MUTEX(camera_lock);
+
+#define MAX_VIDEO_MEM 16
+
+struct mx3_camera_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer			vb;
+	const struct soc_camera_data_format	*fmt;
+
+	/* One descriptot per scatterlist (per frame) */
+	struct dma_async_tx_descriptor		*txd;
+
+	/* We have to "build" a scatterlist ourselves - one element per frame */
+	struct scatterlist			sg;
+};
+
+struct mx3_camera_dev {
+	struct device		*dev;
+	/* i.MX3x is only supposed to handle one camera on its Quick Capture
+	 * interface. If anyone ever builds hardware to enable more than
+	 * one camera, they will have to modify this driver too */
+	struct soc_camera_device *icd;
+	struct clk		*clk;
+
+	unsigned int		irq;
+	void __iomem		*base;
+
+	struct mx3_camera_pdata	*pdata;
+
+	unsigned long		platform_flags;
+	unsigned long		platform_mclk_10khz;
+
+	struct list_head	capture;
+
+	bool			chan_rq;	/* Synchronise */
+
+	spinlock_t		lock;		/* Protects video buffer lists */
+
+	struct mx3_camera_buffer *active;
+
+	/* IDMAC / dmaengine interface */
+	struct idmac_client	idmac_client;
+	struct dma_slave	dma_slave;
+	struct idmac_channel_rq	idmac_channel[1];	/* We need one channel */
+
+	struct soc_camera_host	soc_host;
+};
+
+static u32 csi_reg_read(struct mx3_camera_dev *mx3, off_t reg)
+{
+	return __raw_readl(mx3->base + reg);
+}
+
+static void csi_reg_write(struct mx3_camera_dev *mx3, u32 value, off_t reg)
+{
+	__raw_writel(value, mx3->base + reg);
+}
+
+static void mx3_cam_dma_done(void *arg)
+{
+	struct idmac_tx_desc *tx_desc = to_tx_desc(arg);
+	struct dma_chan *chan = tx_desc->txd.chan;
+	struct idmac_channel *ichannel = to_idmac_chan(chan);
+	struct idmac_client *iclient = ichannel->iclient;
+	struct mx3_camera_dev *mx3_cam = container_of(iclient, struct mx3_camera_dev,
+						      idmac_client);
+	struct videobuf_buffer *vb = &mx3_cam->active->vb;
+	unsigned long flags;
+
+	list_del(&vb->queue);
+	vb->state = VIDEOBUF_DONE;
+	do_gettimeofday(&vb->ts);
+	vb->field_count++;
+	wake_up(&vb->done);
+
+	spin_lock_irqsave(&mx3_cam->lock, flags);
+	if (list_empty(&mx3_cam->capture)) {
+		mx3_cam->active = NULL;
+		spin_unlock_irqrestore(&mx3_cam->lock, flags);
+
+		/*
+		 * stop capture - without further buffers IPU_CHA_BUF0_RDY will
+		 * not get updated
+		 */
+		return;
+	}
+
+	mx3_cam->active = list_entry(mx3_cam->capture.next,
+				     struct mx3_camera_buffer, vb.queue);
+	mx3_cam->active->vb.state = VIDEOBUF_ACTIVE;
+	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct mx3_camera_buffer *buf)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct videobuf_buffer *vb = &buf->vb;
+	struct dma_async_tx_descriptor *txd = buf->txd;
+
+	BUG_ON(in_interrupt());
+
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
+		vb, vb->baddr, vb->bsize);
+
+	/*
+	 * This waits until this buffer is out of danger, i.e., until it is no
+	 * longer in STATE_QUEUED or STATE_ACTIVE
+	 */
+	videobuf_waiton(vb, 0, 0);
+	txd->tx_free(txd);
+	videobuf_dma_contig_free(vq, vb);
+	buf->txd = NULL;
+
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+/*
+ * Videobuf operations
+ */
+
+/* Calculate the __buffer__ (not data) size and number of buffers */
+static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
+			      unsigned int *size)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	/*
+	 * bits-per-pixel (depth) as specified in camera's pixel format does
+	 * not necessarily match what the camera interface writes to RAM, but
+	 * it should be good enough for now.
+	 */
+	unsigned int bpp = DIV_ROUND_UP(icd->current_fmt->depth, 8);
+
+	*size = icd->width * icd->height * bpp;
+
+	if (!*count)
+		*count = 32;
+
+	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
+		*count = MAX_VIDEO_MEM * 1024 * 1024 / *size;
+
+	return 0;
+}
+
+static int mx3_videobuf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	struct mx3_camera_buffer *buf =
+		container_of(vb, struct mx3_camera_buffer, vb);
+	size_t new_size = icd->width * icd->height *
+		((icd->current_fmt->depth + 7) >> 3);
+	int ret;
+
+	BUG_ON(!icd->current_fmt);
+
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
+
+	if (buf->fmt	!= icd->current_fmt ||
+	    vb->width	!= icd->width ||
+	    vb->height	!= icd->height ||
+	    vb->field	!= field) {
+		buf->fmt	= icd->current_fmt;
+		vb->width	= icd->width;
+		vb->height	= icd->height;
+		vb->field	= field;
+		if (vb->state != VIDEOBUF_NEEDS_INIT)
+			free_buffer(vq, buf);
+	}
+
+	if (vb->baddr && vb->bsize < new_size) {
+		/* User provided buffer, but it is too small */
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		struct idmac_channel *ichan = mx3_cam->idmac_channel[0].ichannel;
+		struct scatterlist *sg = &buf->sg;
+
+		/*
+		 * The total size of video-buffers that will be allocated / mapped.
+		 * *size that we calculated in videobuf_setup gets assigned to
+		 * vb->bsize, and now we use the same calculation to get vb->size.
+		 */
+		vb->size = new_size;
+
+		/* This actually (allocates and) maps buffers */
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret)
+			goto fail;
+
+		/*
+		 * We will have to configure the IDMAC channel. It has two slots
+		 * for DMA buffers, we shall enter the first two buffers there,
+		 * and then submit new buffers in DMA-ready interrupts
+		 */
+		sg_init_table(sg, 1);
+		sg_dma_address(sg)	= videobuf_to_dma_contig(vb);
+		sg_dma_len(sg)		= vb->size;
+
+		buf->txd = ichan->dma_chan.device->device_prep_slave_sg(
+			&ichan->dma_chan, sg, 1, DMA_FROM_DEVICE,
+			DMA_PREP_INTERRUPT);
+		if (!buf->txd)
+			goto fail;
+
+		buf->txd->callback_param	= buf->txd;
+		buf->txd->callback		= mx3_cam_dma_done;
+
+		vb->state = VIDEOBUF_PREPARED;
+	}
+
+	return 0;
+
+fail:
+	free_buffer(vq, buf);
+out:
+	return ret;
+}
+
+static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
+{
+	/* Add more formats as need arises and test possibilities appear... */
+	switch (fourcc) {
+	case V4L2_PIX_FMT_RGB565:
+		return IPU_PIX_FMT_RGB565;
+	case V4L2_PIX_FMT_RGB24:
+		return IPU_PIX_FMT_RGB24;
+	case V4L2_PIX_FMT_RGB332:
+		return IPU_PIX_FMT_RGB332;
+	case V4L2_PIX_FMT_YUV422P:
+		return IPU_PIX_FMT_YVU422P;
+	default:
+		return IPU_PIX_FMT_GENERIC;
+	}
+}
+
+static void mx3_videobuf_queue(struct videobuf_queue *vq,
+			       struct videobuf_buffer *vb)
+{
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	struct mx3_camera_buffer *buf =
+		container_of(vb, struct mx3_camera_buffer, vb);
+	struct dma_async_tx_descriptor *txd = buf->txd;
+	struct idmac_channel *ichan = to_idmac_chan(txd->chan);
+	struct idmac_video_param *video = &ichan->params.video;
+	const struct soc_camera_data_format *data_fmt = icd->current_fmt;
+	dma_cookie_t cookie;
+	unsigned long flags;
+
+	/* This is the configuration of one sg-element */
+	video->out_pixel_fmt	= fourcc_to_ipu_pix(data_fmt->fourcc);
+	video->out_width	= icd->width;
+	video->out_height	= icd->height;
+	video->out_stride	= icd->width;
+
+#ifdef DEBUG
+	/* helps to see what DMA actually has written */
+	memset((void *)vb->baddr, 0xaa, vb->bsize);
+#endif
+
+	spin_lock_irqsave(&mx3_cam->lock, flags);
+
+	list_add_tail(&vb->queue, &mx3_cam->capture);
+
+	if (!mx3_cam->active) {
+		mx3_cam->active = buf;
+		vb->state = VIDEOBUF_ACTIVE;
+	} else {
+		vb->state = VIDEOBUF_QUEUED;
+	}
+
+	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+
+	cookie = txd->tx_submit(txd);
+	if (cookie >= 0)
+		return;
+
+	vb->state = VIDEOBUF_PREPARED;
+
+	spin_lock_irqsave(&mx3_cam->lock, flags);
+
+	list_del(&vb->queue);
+
+	if (mx3_cam->active == buf)
+		mx3_cam->active = NULL;
+
+	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+}
+
+static void mx3_videobuf_release(struct videobuf_queue *vq,
+				 struct videobuf_buffer *vb)
+{
+	struct mx3_camera_buffer *buf =
+		container_of(vb, struct mx3_camera_buffer, vb);
+
+	free_buffer(vq, buf);
+}
+
+static struct videobuf_queue_ops mx3_videobuf_ops = {
+	.buf_setup      = mx3_videobuf_setup,
+	.buf_prepare    = mx3_videobuf_prepare,
+	.buf_queue      = mx3_videobuf_queue,
+	.buf_release    = mx3_videobuf_release,
+};
+
+static void mx3_camera_init_videobuf(struct videobuf_queue *q,
+				     struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+
+	videobuf_queue_dma_contig_init(q, &mx3_videobuf_ops, mx3_cam->dev,
+				       &mx3_cam->lock,
+				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				       V4L2_FIELD_NONE,
+				       sizeof(struct mx3_camera_buffer), icd);
+}
+
+/* First part of ipu_csi_init_interface() */
+static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
+				struct soc_camera_device *icd)
+{
+	u32 conf;
+	long rate;
+
+	/* Set default size: ipu_csi_set_window_size() */
+	csi_reg_write(mx3_cam, (640 - 1) | ((480 - 1) << 16), CSI_ACT_FRM_SIZE);
+	/* ...and position to 0:0: ipu_csi_set_window_pos() */
+	conf = csi_reg_read(mx3_cam, CSI_OUT_FRM_CTRL) & 0xffff0000;
+	csi_reg_write(mx3_cam, conf, CSI_OUT_FRM_CTRL);
+
+	/* We use only gated clock synchronisation mode so far */
+	conf = 0 << CSI_SENS_CONF_SENS_PRTCL_SHIFT;
+
+	/* Set generic data, platform-biggest bus-width */
+	conf |= CSI_SENS_CONF_DATA_FMT_BAYER;
+
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
+		conf |= 3 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10)
+		conf |= 2 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8)
+		conf |= 1 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+	else/* if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4)*/
+		conf |= 0 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+
+	if (mx3_cam->platform_flags & MX3_CAMERA_CLK_SRC)
+		conf |= 1 << CSI_SENS_CONF_SENS_CLKSRC_SHIFT;
+	if (mx3_cam->platform_flags & MX3_CAMERA_EXT_VSYNC)
+		conf |= 1 << CSI_SENS_CONF_EXT_VSYNC_SHIFT;
+	if (mx3_cam->platform_flags & MX3_CAMERA_DP)
+		conf |= 1 << CSI_SENS_CONF_DATA_POL_SHIFT;
+	if (mx3_cam->platform_flags & MX3_CAMERA_PCP)
+		conf |= 1 << CSI_SENS_CONF_PIX_CLK_POL_SHIFT;
+	if (mx3_cam->platform_flags & MX3_CAMERA_HSP)
+		conf |= 1 << CSI_SENS_CONF_HSYNC_POL_SHIFT;
+	if (mx3_cam->platform_flags & MX3_CAMERA_VSP)
+		conf |= 1 << CSI_SENS_CONF_VSYNC_POL_SHIFT;
+
+	/* ipu_csi_init_interface() */
+	csi_reg_write(mx3_cam, conf, CSI_SENS_CONF);
+
+	clk_enable(mx3_cam->clk);
+	rate = clk_round_rate(mx3_cam->clk,
+			      mx3_cam->platform_mclk_10khz * 10000);
+	dev_dbg(&icd->dev, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
+	if (rate)
+		clk_set_rate(mx3_cam->clk, rate);
+}
+
+static int mx3_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	int ret = 0;
+
+	/* Have to register / unregister to really release the DMA-channel... */
+	dma_async_client_register(&mx3_cam->idmac_client.dma_client);
+
+	mutex_lock(&camera_lock);
+
+	if (mx3_cam->icd) {
+		ret = -EBUSY;
+		goto ebusy;
+	}
+
+	mx3_camera_activate(mx3_cam, icd);
+
+	mx3_cam->icd = icd;
+
+ebusy:
+	mutex_unlock(&camera_lock);
+
+	if (!ret)
+		dev_info(&icd->dev, "MX3 Camera driver attached to camera %d\n",
+			 icd->devnum);
+	else
+		dma_async_client_unregister(&mx3_cam->idmac_client.dma_client);
+
+	return ret;
+}
+
+static void mx3_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	struct idmac_channel *ichan = mx3_cam->idmac_channel->ichannel;
+
+	BUG_ON(icd != mx3_cam->icd);
+
+	if (ichan)
+		/*
+		 * We do not use dma_chan_cleanup(), because it would put the
+		 * kref, instead, we call dma_chan_put() in mx3_dma_event()
+		 * on DMA_RESOURCE_REMOVED
+		 */
+		ichan->dma_chan.device->device_free_chan_resources(&ichan->dma_chan);
+
+	dma_async_client_unregister(&mx3_cam->idmac_client.dma_client);
+
+	mutex_lock(&camera_lock);
+
+	clk_disable(mx3_cam->clk);
+
+	mx3_cam->icd = NULL;
+
+	mutex_unlock(&camera_lock);
+
+	dev_info(&icd->dev, "MX3 Camera driver detached from camera %d\n",
+		 icd->devnum);
+}
+
+static bool channel_change_requested(struct mx3_camera_dev *mx3_cam,
+				    __u32 pixfmt)
+{
+	struct idmac_channel *ichan = mx3_cam->idmac_channel[0].ichannel;
+
+	/* So far only one configuration is supported */
+	return !ichan || ichan->dma_chan.chan_id != IDMAC_IC_7;
+}
+
+static int test_platform_param(struct mx3_camera_dev *mx3_cam,
+			       unsigned char buswidth, unsigned long *flags)
+{
+	/*
+	 * Platform specified synchronization and pixel clock polarities are
+	 * only a recommendation and are only used during probing. MX3x
+	 * camera interface only works in master mode, i.e., uses HSYNC and
+	 * VSYNC signals from the sensor
+	 */
+	*flags = SOCAM_MASTER |
+		SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_HSYNC_ACTIVE_LOW |
+		SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_VSYNC_ACTIVE_LOW |
+		SOCAM_PCLK_SAMPLE_RISING |
+		SOCAM_PCLK_SAMPLE_FALLING |
+		SOCAM_DATA_ACTIVE_HIGH |
+		SOCAM_DATA_ACTIVE_LOW;
+
+	/* If requested data width is supported by the platform, use it or any
+	 * possible loewr value - i.MX31 is smart enough to schift bits */
+	switch (buswidth) {
+	case 15:
+		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_10 |
+			SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
+		break;
+	case 10:
+		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_8 |
+			SOCAM_DATAWIDTH_4;
+		break;
+	case 8:
+		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
+		break;
+	case 4:
+		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4))
+			return -EINVAL;
+		*flags |= SOCAM_DATAWIDTH_4;
+		break;
+	default:
+		dev_info(mx3_cam->dev, "Unsupported bus width %d\n", buswidth);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
+				    const struct soc_camera_data_format *fmt)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	unsigned long bus_flags, camera_flags;
+	int ret = test_platform_param(mx3_cam, fmt->depth, &bus_flags);
+
+	dev_dbg(&ici->dev, "requested bus width %d bit: %d\n", fmt->depth, ret);
+
+	if (ret < 0)
+		return ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	ret = soc_camera_bus_param_compatible(camera_flags, bus_flags);
+	if (ret < 0)
+		dev_warn(&icd->dev, "Flags incompatible: camera %lx, host %lx\n",
+			 camera_flags, bus_flags);
+
+	return ret;
+}
+
+static int mx3_camera_set_fmt(struct soc_camera_device *icd,
+			      __u32 pixfmt, struct v4l2_rect *rect)
+{
+	const struct soc_camera_data_format *cam_fmt = NULL; /* shut up compiler */
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	struct idmac_channel_rq *ichrq = &mx3_cam->idmac_channel[0];
+	struct dma_client *client = &mx3_cam->idmac_client.dma_client;
+	u32 ctrl, width_field, height_field;
+	int ret;
+
+	/*
+	 * TODO: find a suitable supported by the SoC output format, check
+	 * whether the sensor supports one of acceptable input formats.
+	 */
+	if (pixfmt) {
+		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		if (!cam_fmt)
+			return -EINVAL;
+	}
+
+	/*
+	 * We now know pixel formats and can decide upon DMA-channel(s)
+	 * So far only direct camera-to-memory is supported
+	 */
+	if (pixfmt && channel_change_requested(mx3_cam, cam_fmt->fourcc)) {
+		if (ichrq->ichannel)
+			/*
+			 * This doesn't really work yet. dmaengine.c has to be
+			 * fixed. Effort is underway to improve the situation.
+			 */
+			dma_chan_cleanup(&ichrq->ichannel->dma_chan.refcount);
+
+		/* We have to use IDMAC_IC_7 for Bayer / generic data */
+		ichrq->channel			 = IDMAC_IC_7;
+		ichrq->ichannel			 = NULL;
+
+		mx3_cam->idmac_client.channels	 = mx3_cam->idmac_channel;
+		mx3_cam->idmac_client.n_channels = 1;
+
+		/*
+		 * We do not want any channel-offers when we are not
+		 * requesting them, and now we configured which channel(s)
+		 * we want.
+		 */
+		mx3_cam->chan_rq = true;
+
+		dma_async_client_chan_request(client);
+
+		mx3_cam->chan_rq = false;
+
+		/*
+		 * We do not wait for asynchronous chanel allocation. If it
+		 * didn't work synchronously - abort
+		 */
+		if (!ichrq->ichannel || ichrq->ichannel->status != IPU_CHANNEL_GRANTED)
+			return -EBUSY;
+	}
+
+	/*
+	 * Might have to perform a complete interface initialisation like in
+	 * ipu_csi_init_interface() in mxc_v4l2_s_param(). Also consider
+	 * mxc_v4l2_s_fmt()
+	 */
+
+	/* Setup frame size... */
+	width_field = rect->width - 1;
+	height_field = rect->height - 1;
+	csi_reg_write(mx3_cam, width_field | (height_field << 16), CSI_SENS_FRM_SIZE);
+
+	csi_reg_write(mx3_cam, width_field << 16, CSI_FLASH_STROBE_1);
+	csi_reg_write(mx3_cam, (height_field << 16) | 0x22, CSI_FLASH_STROBE_2);
+
+	csi_reg_write(mx3_cam, width_field | (height_field << 16), CSI_ACT_FRM_SIZE);
+
+	/* ...and position */
+	ctrl = csi_reg_read(mx3_cam, CSI_OUT_FRM_CTRL) & 0xffff0000;
+	/* Sensor does the cropping */
+	csi_reg_write(mx3_cam, ctrl | 0 | (0 << 8), CSI_OUT_FRM_CTRL);
+
+	/*
+	 * No need to free resources here if we fail, we'll see if we need to
+	 * do this next time we are called
+	 */
+
+	ret = icd->ops->set_fmt(icd, pixfmt, rect);
+	if (pixfmt && !ret)
+		icd->current_fmt = cam_fmt;
+
+	return ret;
+}
+
+static int mx3_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	const struct soc_camera_data_format *cam_fmt;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	/*
+	 * TODO: find a suitable supported by the SoC output format, check
+	 * whether the sensor supports one of acceptable input formats.
+	 */
+	cam_fmt = soc_camera_format_by_fourcc(icd, pix->pixelformat);
+	if (!cam_fmt)
+		return -EINVAL;
+
+	ret = mx3_camera_try_bus_param(icd, cam_fmt);
+	if (ret < 0)
+		return ret;
+
+	/* limit to MX3 hardware capabilities */
+	if (pix->height > 4096)
+		pix->height = 4096;
+	if (pix->width > 4096)
+		pix->width = 4096;
+
+	pix->bytesperline = pix->width *
+		DIV_ROUND_UP(cam_fmt->depth, 8);
+	pix->sizeimage = pix->height * pix->bytesperline;
+
+	/* limit to sensor capabilities */
+	ret = icd->ops->try_fmt(icd, f);
+
+	return ret;
+}
+
+static int mx3_camera_enum_fmt(struct soc_camera_device *icd,
+			       struct v4l2_fmtdesc *f)
+{
+	const struct soc_camera_data_format *format;
+
+	if (f->index >= icd->num_formats)
+		return -EINVAL;
+
+	format = &icd->formats[f->index];
+
+	strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+
+	return 0;
+}
+
+static int mx3_camera_reqbufs(struct soc_camera_file *icf,
+			      struct v4l2_requestbuffers *p)
+{
+	return 0;
+}
+
+static unsigned int mx3_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_file *icf = file->private_data;
+
+	return videobuf_poll_stream(file, &icf->vb_vidq, pt);
+}
+
+static int mx3_camera_querycap(struct soc_camera_host *ici,
+			       struct v4l2_capability *cap)
+{
+	/* cap->name is set by the firendly caller:-> */
+	strlcpy(cap->card, "i.MX3x Camera", sizeof(cap->card));
+	cap->version = KERNEL_VERSION(0, 2, 2);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	unsigned long bus_flags, camera_flags, common_flags;
+	u32 dw, sens_conf;
+	int ret = test_platform_param(mx3_cam, icd->buswidth, &bus_flags);
+
+	dev_dbg(&ici->dev, "requested bus width %d bit: %d\n",
+		icd->buswidth, ret);
+
+	if (ret < 0)
+		return ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
+	if (!common_flags)
+		return -EINVAL;
+
+	/* Make choices, based on platform preferences */
+	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+		if (mx3_cam->platform_flags & MX3_CAMERA_HSP)
+			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+		if (mx3_cam->platform_flags & MX3_CAMERA_VSP)
+			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_DATA_ACTIVE_LOW)) {
+		if (mx3_cam->platform_flags & MX3_CAMERA_DP)
+			common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+		if (mx3_cam->platform_flags & MX3_CAMERA_PCP)
+			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+		else
+			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+	}
+
+	/* Make the camera work in widest platform-approved mode, we'll take
+	 * care of the rest */
+	common_flags &= ~SOCAM_DATAWIDTH_MASK;
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
+		common_flags |= SOCAM_DATAWIDTH_15;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10)
+		common_flags |= SOCAM_DATAWIDTH_10;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8)
+		common_flags |= SOCAM_DATAWIDTH_8;
+	else/* if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4)*/
+		common_flags |= SOCAM_DATAWIDTH_4;
+
+	ret = icd->ops->set_bus_param(icd, common_flags);
+	if (ret < 0)
+		return ret;
+
+	sens_conf = csi_reg_read(mx3_cam, CSI_SENS_CONF) &
+		~((1 << CSI_SENS_CONF_VSYNC_POL_SHIFT) |
+		  (1 << CSI_SENS_CONF_HSYNC_POL_SHIFT) |
+		  (1 << CSI_SENS_CONF_DATA_POL_SHIFT) |
+		  (1 << CSI_SENS_CONF_PIX_CLK_POL_SHIFT) |
+		  /*(3 << CSI_SENS_CONF_SENS_PRTCL_SHIFT) |*/
+		  (3 << CSI_SENS_CONF_DATA_FMT_SHIFT) |
+		  (3 << CSI_SENS_CONF_DATA_WIDTH_SHIFT));
+
+	/* TODO: Support RGB and YUV formats */
+
+	/* This has been set in mx3_camera_activate(), but we clear it above */
+	sens_conf |= CSI_SENS_CONF_DATA_FMT_BAYER;
+
+	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
+		sens_conf |= 1 << CSI_SENS_CONF_PIX_CLK_POL_SHIFT;
+	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
+		sens_conf |= 1 << CSI_SENS_CONF_HSYNC_POL_SHIFT;
+	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
+		sens_conf |= 1 << CSI_SENS_CONF_VSYNC_POL_SHIFT;
+	if (common_flags & SOCAM_DATA_ACTIVE_LOW)
+		sens_conf |= 1 << CSI_SENS_CONF_DATA_POL_SHIFT;
+
+	/* Just do what we're asked to do */
+	switch (icd->buswidth) {
+	case 4:
+		dw = 0 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+		break;
+	case 8:
+		dw = 1 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+		break;
+	case 10:
+		dw = 2 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+		break;
+	default:
+		/*
+		 * Actually it can only be 15 now, default is just to silence
+		 * compiler warnings
+		 */
+	case 15:
+		dw = 3 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
+	}
+
+	csi_reg_write(mx3_cam, sens_conf | dw, CSI_SENS_CONF);
+
+	dev_dbg(&ici->dev, "Set SENS_CONF to %x\n", sens_conf | dw);
+
+	return 0;
+}
+
+static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= mx3_camera_add_device,
+	.remove		= mx3_camera_remove_device,
+#ifdef CONFIG_PM
+	.suspend	= mx3_camera_suspend,
+	.resume		= mx3_camera_resume,
+#endif
+	.set_fmt	= mx3_camera_set_fmt,
+	.try_fmt	= mx3_camera_try_fmt,
+	.enum_fmt	= mx3_camera_enum_fmt,
+	.init_videobuf	= mx3_camera_init_videobuf,
+	.reqbufs	= mx3_camera_reqbufs,
+	.poll		= mx3_camera_poll,
+	.querycap	= mx3_camera_querycap,
+	.set_bus_param	= mx3_camera_set_bus_param,
+};
+
+static enum dma_state_client mx3_dma_event(struct dma_client *client,
+		struct dma_chan *chan, enum dma_state state)
+{
+	enum dma_state_client ack = DMA_NAK;
+	struct idmac_client *iclient = to_idmac_client(client);
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct mx3_camera_dev *mx3_cam = container_of(iclient, struct mx3_camera_dev,
+						      idmac_client);
+	int i;
+
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		dev_dbg(chan->device->dev, "Offered channel %x\n", chan->chan_id);
+
+		if (mx3_cam->chan_rq) {
+			dma_chan_get(&ichan->dma_chan);
+			mx3_cam->chan_rq = false;
+			ack = DMA_ACK;
+			break;
+		}
+		/*
+		 * ipu_idmac.c is aware of the problem, that it doesn't really
+		 * get to know, whether the client has acepted its channel offer
+		 * or not, and it doesn't do any allocations / initialisations
+		 * in its .device_alloc_chan_resources(), so, we just exit here
+		 */
+		break;
+	case DMA_RESOURCE_REMOVED:
+		/*
+		 * we rely on fixed dmaengine.c. Otherwise have to check
+		 * DMA-device (controller)
+		 */
+		for (i = 0; i < iclient->n_channels; i++)
+			if (iclient->channels[i].channel == ichan->dma_chan.chan_id &&
+			    ichan->status == IPU_CHANNEL_FREE_PENDING) {
+				ichan->status = IPU_CHANNEL_FREE;
+				dma_chan_put(&ichan->dma_chan);
+				ack = DMA_ACK;
+				dev_dbg(chan->device->dev, "Removing channel %x@%d status %d\n",
+					chan->chan_id, i, ichan->status);
+				break;
+			}
+		break;
+	default:
+		dev_info(chan->device->dev, "Unhandled event %u on channel %x\n",
+			 state, ichan->dma_chan.chan_id);
+		break;
+	}
+
+	return ack;
+}
+
+static irqreturn_t csi_eof_irq(int irq, void *dev_id)
+{
+	/*
+	 * We don't seem to need this IRQ, might just remove request_irq
+	 * completely
+	 */
+	disable_irq(irq);
+
+	return IRQ_HANDLED;
+}
+
+static int mx3_camera_probe(struct platform_device *pdev)
+{
+	struct mx3_camera_dev *mx3_cam;
+	struct resource *res;
+	void __iomem *base;
+	int err = 0;
+	struct soc_camera_host *soc_host;
+	struct dma_client *client;
+	struct dma_slave *slave;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENODEV;
+		goto egetres;
+	}
+
+	mx3_cam = vmalloc(sizeof(*mx3_cam));
+	if (!mx3_cam) {
+		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
+		err = -ENOMEM;
+		goto ealloc;
+	}
+	memset(mx3_cam, 0, sizeof(*mx3_cam));
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		goto egetirq;
+
+	mx3_cam->irq = err;
+
+	err = request_irq(mx3_cam->irq, csi_eof_irq, 0, "csi", mx3_cam);
+	if (err < 0)
+		goto ereqirq;
+
+	mx3_cam->clk = clk_get(&pdev->dev, "csi_clk");
+	if (IS_ERR(mx3_cam->clk)) {
+		err = PTR_ERR(mx3_cam->clk);
+		goto eclkget;
+	}
+
+	dev_set_drvdata(&pdev->dev, mx3_cam);
+
+	mx3_cam->pdata = pdev->dev.platform_data;
+	mx3_cam->platform_flags = mx3_cam->pdata->flags;
+	if (!(mx3_cam->platform_flags & (MX3_CAMERA_DATAWIDTH_4 |
+			MX3_CAMERA_DATAWIDTH_8 | MX3_CAMERA_DATAWIDTH_10 |
+			MX3_CAMERA_DATAWIDTH_15))) {
+		/* Platform hasn't set available data widths. This is bad.
+		 * Warn and use a default. */
+		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
+			 "data widths, using default 8 bit\n");
+		mx3_cam->platform_flags |= MX3_CAMERA_DATAWIDTH_8;
+	}
+	mx3_cam->platform_mclk_10khz = mx3_cam->pdata->mclk_10khz;
+	if (!mx3_cam->platform_mclk_10khz) {
+		dev_warn(&pdev->dev,
+			 "mclk_10khz == 0! Please, fix your platform data. "
+			 "Using default 20MHz\n");
+		mx3_cam->platform_mclk_10khz = 2000;
+	}
+
+	/* list of video-buffers */
+	INIT_LIST_HEAD(&mx3_cam->capture);
+	mx3_cam->chan_rq = false;
+	spin_lock_init(&mx3_cam->lock);
+
+	base = ioremap(res->start, res->end - res->start + 1);
+	if (!base) {
+		err = -ENOMEM;
+		goto eioremap;
+	}
+
+	/*
+	 * Freescale: IPU_IRQ_PRP_ENC_OUT_EOF or IPU_IRQ_PRP_ENC_ROT_OUT_EOF
+	 * if rotated
+	 */
+	mx3_cam->base	= base;
+	mx3_cam->dev	= &pdev->dev;
+
+	/* IDMAC interface */
+	client		= &mx3_cam->idmac_client.dma_client;
+	slave		= &mx3_cam->dma_slave;
+
+	slave->dev	= &pdev->dev;
+
+	client->slave	= slave;
+	/*
+	 * Callback is only really needed for channel matching per
+	 * DMA_RESOURCE_AVAILABLE, otherwise print an error in it.
+	 */
+	client->event_callback = mx3_dma_event;
+	dma_cap_set(DMA_SLAVE, client->cap_mask);
+
+	soc_host		= &mx3_cam->soc_host;
+	soc_host->drv_name	= MX3_CAM_DRV_NAME;
+	soc_host->ops		= &mx3_soc_camera_host_ops;
+	soc_host->priv		= mx3_cam;
+	soc_host->dev.parent	= &pdev->dev;
+	soc_host->nr		= pdev->id;
+	err = soc_camera_host_register(soc_host);
+	if (err)
+		goto ecamhostreg;
+
+	return 0;
+
+ecamhostreg:
+	iounmap(base);
+eioremap:
+	clk_put(mx3_cam->clk);
+eclkget:
+	free_irq(mx3_cam->irq, mx3_cam);
+ereqirq:
+egetirq:
+	vfree(mx3_cam);
+ealloc:
+egetres:
+	return err;
+}
+
+static int __devexit mx3_camera_remove(struct platform_device *pdev)
+{
+	struct mx3_camera_dev *mx3_cam = platform_get_drvdata(pdev);
+
+	clk_put(mx3_cam->clk);
+
+	soc_camera_host_unregister(&mx3_cam->soc_host);
+
+	iounmap(mx3_cam->base);
+
+	free_irq(mx3_cam->irq, mx3_cam);
+
+	vfree(mx3_cam);
+
+	dev_info(&pdev->dev, "i.MX3x Camera driver unloaded\n");
+
+	return 0;
+}
+
+static struct platform_driver mx3_camera_driver = {
+	.driver 	= {
+		.name	= MX3_CAM_DRV_NAME,
+	},
+	.probe		= mx3_camera_probe,
+	.remove		= __exit_p(mx3_camera_remove),
+};
+
+
+static int __devinit mx3_camera_init(void)
+{
+	return platform_driver_register(&mx3_camera_driver);
+}
+
+static void __exit mx3_camera_exit(void)
+{
+	platform_driver_unregister(&mx3_camera_driver);
+}
+
+module_init(mx3_camera_init);
+module_exit(mx3_camera_exit);
+
+MODULE_DESCRIPTION("i.MX3x SoC Camera Host driver");
+MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index a63f7fb..7093e85 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -160,12 +160,16 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 #define SOCAM_HSYNC_ACTIVE_LOW		(1 << 3)
 #define SOCAM_VSYNC_ACTIVE_HIGH		(1 << 4)
 #define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)
-#define SOCAM_DATAWIDTH_8		(1 << 6)
-#define SOCAM_DATAWIDTH_9		(1 << 7)
-#define SOCAM_DATAWIDTH_10		(1 << 8)
-#define SOCAM_DATAWIDTH_16		(1 << 9)
-#define SOCAM_PCLK_SAMPLE_RISING	(1 << 10)
-#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 11)
+#define SOCAM_DATAWIDTH_4		(1 << 6)
+#define SOCAM_DATAWIDTH_8		(1 << 7)
+#define SOCAM_DATAWIDTH_9		(1 << 8)
+#define SOCAM_DATAWIDTH_10		(1 << 9)
+#define SOCAM_DATAWIDTH_15		(1 << 10)
+#define SOCAM_DATAWIDTH_16		(1 << 11)
+#define SOCAM_PCLK_SAMPLE_RISING	(1 << 12)
+#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
+#define SOCAM_DATA_ACTIVE_HIGH		(1 << 14)
+#define SOCAM_DATA_ACTIVE_LOW		(1 << 15)
 
 #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_9 | \
 			      SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_16)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
