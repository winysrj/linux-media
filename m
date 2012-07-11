Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48291 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755233Ab2GKOYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 10:24:22 -0400
From: Albert Wang <twang13@marvell.com>
To: g.liakhovetski@gmx.de, corbet@lwn.net
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH 1/7] media: mmp_camera: Add V4l2 camera driver for Marvell PXA910/PXA688/PXA2128 CCIC
Date: Wed, 11 Jul 2012 22:22:29 +0800
Message-Id: <1342016549-23084-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v4l2 camera driver is based on soc-camera and videobuf2 framework
Support Marvell MMP Soc family TD-PXA910/MMP2-PXA688/MMP3-PXA2128 CCIC
Support Dual CCIC controllers on PXA688/PXA2128
Support MIPI-CSI2 mode and DVP-Parallel mode

Change-Id: I0d6156e29a278108dfb26dc1e891ca069e31666c
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 arch/arm/mach-mmp/include/mach/camera.h    |   21 +
 arch/arm/mach-mmp/include/mach/regs-apmu.h |    7 +-
 drivers/media/video/Kconfig                |    9 +
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/mmp_camera.c           | 1134 ++++++++++++++++++++++++++++
 drivers/media/video/mmp_camera.h           |  241 ++++++
 6 files changed, 1412 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/camera.h
 create mode 100644 drivers/media/video/mmp_camera.c
 create mode 100644 drivers/media/video/mmp_camera.h

diff --git a/arch/arm/mach-mmp/include/mach/camera.h b/arch/arm/mach-mmp/include/mach/camera.h
new file mode 100644
index 0000000..d13cd91
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/camera.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_ARCH_CAMERA_H__
+#define __ASM_ARCH_CAMERA_H__
+
+struct mmp_cam_pdata {
+	struct clk *clk[3];	/* CCIC_GATE, CCIC_RST, CCIC_DBG clocks */
+	char *name;
+	int clk_enabled;
+	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
+	int bus_type;
+	int mipi_enabled;	/* MIPI enabled flag */
+	int lane;		/* ccic used lane number; 0 means DVP mode */
+	int dma_burst;
+	int mclk_min;
+	int mclk_src;
+	int mclk_div;
+	int (*init_clk)(struct device *dev, int init);
+	void (*enable_clk)(struct device *dev, int on);
+};
+
+#endif
+
diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h b/arch/arm/mach-mmp/include/mach/regs-apmu.h
index 8447ac6..5616340 100644
--- a/arch/arm/mach-mmp/include/mach/regs-apmu.h
+++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
@@ -19,7 +19,12 @@
 /* Clock Reset Control */
 #define APMU_IRE	APMU_REG(0x048)
 #define APMU_LCD	APMU_REG(0x04c)
-#define APMU_CCIC	APMU_REG(0x050)
+#define APMU_CCIC_GATE	APMU_REG(0x028)
+#define APMU_CCIC_RST	APMU_REG(0x050)
+#define APMU_CCIC_DBG	APMU_REG(0x088)
+#define APMU_CCIC2_GATE APMU_REG(0x118)
+#define APMU_CCIC2_RST	APMU_REG(0x0f4)
+#define APMU_CCIC2_DBG	APMU_REG(0x088)
 #define APMU_SDH0	APMU_REG(0x054)
 #define APMU_SDH1	APMU_REG(0x058)
 #define APMU_USB	APMU_REG(0x05c)
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce1e7ba..244d418 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1087,6 +1087,15 @@ config VIDEO_PXA27x
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
+config VIDEO_MMP
+	tristate "Marvell MMP CCIC driver based on SOC_CAMERA"
+	depends on VIDEO_DEV && SOC_CAMERA
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  This is a v4l2 driver for the Marvell PXA910/PXA688/PXA2128 CCIC
+	  To compile this driver as a module, choose M here: the module will
+	  be called mmp_camera.
+
 config VIDEO_SH_MOBILE_CSI2
 	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a6282a3..12defa7 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -178,6 +178,7 @@ obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
 obj-$(CONFIG_VIDEO_MX2)			+= mx2_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
+obj-$(CONFIG_VIDEO_MMP) 		+= mmp_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
diff --git a/drivers/media/video/mmp_camera.c b/drivers/media/video/mmp_camera.c
new file mode 100644
index 0000000..2e6cc5c
--- /dev/null
+++ b/drivers/media/video/mmp_camera.c
@@ -0,0 +1,1134 @@
+/*
+ * V4L2 Driver for Marvell Mobile SoC PXA910/PXA688/PXA2128 CCIC
+ * (CMOS Camera Interface Controller)
+ *
+ * This driver is based on soc_camera and videobuf2 framework,
+ * but part of the low level register function is base on cafe-driver.c
+ *
+ * Copyright 2006 One Laptop Per Child Association, Inc.
+ * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
+ *
+ * Copyright (C) 2011-2012, Marvell International Ltd.
+ *	Kassey Lee <ygli@marvell.com>
+ *	Angela Wan <jwan@marvell.com>
+ *	Albert Wang <twang13@marvell.com>
+ *	Lei Wen <leiwen@marvell.com>
+ *	Fangsuo Wu <fswu@marvell.com>
+ *	Sarah Zhang <xiazh@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
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
+#include <linux/version.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/videodev2.h>
+
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-chip-ident.h>
+
+#include <mach/regs-apmu.h>
+#include <mach/camera.h>
+
+#include "mmp_camera.h"
+
+#define MMP_CAM_DRV_NAME "mmp-camera"
+
+static const struct soc_mbus_pixelfmt ccic_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.name = "YUV422PACKED",
+		.bits_per_sample = 8,
+		.packing = SOC_MBUS_PACKING_2X8_PADLO,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.name = "YUV422PLANAR",
+		.bits_per_sample = 8,
+		.packing = SOC_MBUS_PACKING_2X8_PADLO,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.name = "YUV420PLANAR",
+		.bits_per_sample = 12,
+		.packing = SOC_MBUS_PACKING_NONE,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.name = "YVU420PLANAR",
+		.bits_per_sample = 12,
+		.packing = SOC_MBUS_PACKING_NONE,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+};
+
+static void ccic_config_phy(struct mmp_camera_dev *pcdev, int enable)
+{
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+	struct device *dev = &pcdev->pdev->dev;
+
+	if (pdata->bus_type == V4L2_MBUS_CSI2_LANES && enable) {
+		dev_dbg(dev, "camera: DPHY3=0x%x, DPHY5=0x%x, DPHY6=0x%x\n",
+			pdata->dphy[0], pdata->dphy[1], pdata->dphy[2]);
+		ccic_reg_write(pcdev, REG_CSI2_DPHY3, pdata->dphy[0]);
+		ccic_reg_write(pcdev, REG_CSI2_DPHY6, pdata->dphy[2]);
+		ccic_reg_write(pcdev, REG_CSI2_DPHY5, pdata->dphy[1]);
+		if (pdata->mipi_enabled == 0) {
+			/*
+			 * 0x41 actives 1 lane
+			 * 0x43 actives 2 lanes
+			 */
+			if (pdata->lane == 1)
+				ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x41);
+			else if (pdata->lane == 2)
+				ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x43);
+			pdata->mipi_enabled = 1;
+		}
+	} else {
+		ccic_reg_write(pcdev, REG_CSI2_DPHY3, 0x0);
+		ccic_reg_write(pcdev, REG_CSI2_DPHY6, 0x0);
+		ccic_reg_write(pcdev, REG_CSI2_DPHY5, 0x0);
+		ccic_reg_write(pcdev, REG_CSI2_CTRL0, 0x0);
+		pdata->mipi_enabled = 0;
+	}
+}
+
+static void ccic_enable_clk(struct mmp_camera_dev *pcdev)
+{
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+	struct device *dev = &pcdev->pdev->dev;
+	int ctrl1 = 0;
+
+	pdata->enable_clk(&pcdev->pdev->dev, 1);
+	ccic_reg_write(pcdev, REG_CLKCTRL,
+			(pdata->mclk_src << 29) | pdata->mclk_div);
+	dev_dbg(dev, "camera: set sensor mclk = %d MHz\n", pdata->mclk_min);
+
+	switch (pdata->dma_burst) {
+	case 128:
+		ctrl1 |= C1_DMAB128;
+		break;
+	case 256:
+		ctrl1 |= C1_DMAB256;
+		break;
+	}
+	ccic_reg_write(pcdev, REG_CTRL1, ctrl1 | C1_RESERVED | C1_DMAPOSTED);
+	if (pdata->bus_type != V4L2_MBUS_CSI2_LANES)
+		ccic_reg_write(pcdev, REG_CTRL3, 0x4);
+}
+
+static void ccic_disable_clk(struct mmp_camera_dev *pcdev)
+{
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+
+	ccic_reg_write(pcdev, REG_CLKCTRL, 0x0);
+	/*
+	 * Bit[5:1] reserved and should not be changed
+	 */
+	ccic_reg_write(pcdev, REG_CTRL1, C1_RESERVED);
+	pdata->enable_clk(&pcdev->pdev->dev, 0);
+}
+
+static int ccic_config_image(struct mmp_camera_dev *pcdev)
+{
+	struct v4l2_pix_format *fmt = &pcdev->pix_format;
+	struct device *dev = &pcdev->pdev->dev;
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
+	int ret = 0;
+
+	dev_dbg(dev, "camera: bytesperline = %d; height = %d\n",
+		fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
+	imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
+	imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
+
+	if (fmt->pixelformat == V4L2_PIX_FMT_YUV420
+		|| fmt->pixelformat == V4L2_PIX_FMT_YVU420)
+		imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
+	else if (fmt->pixelformat == V4L2_PIX_FMT_JPEG)
+		imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
+
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+		widthy = fmt->width * 2;
+		widthuv = fmt->width * 2;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		widthy = fmt->width * 2;
+		widthuv = 0;
+		break;
+	case V4L2_PIX_FMT_JPEG:
+		widthy = fmt->bytesperline;
+		widthuv = fmt->bytesperline;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		widthy = fmt->width;
+		widthuv = fmt->width / 2;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		widthy = fmt->width;
+		widthuv = fmt->width / 2;
+		break;
+	default:
+		break;
+	}
+
+	ccic_reg_write(pcdev, REG_IMGPITCH, widthuv << 16 | widthy);
+	ccic_reg_write(pcdev, REG_IMGSIZE, imgsz_h | imgsz_w);
+	ccic_reg_write(pcdev, REG_IMGOFFSET, 0x0);
+
+	/*
+	 * Tell the controller about the image format we are using.
+	 */
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_420PL | C0_YUVE_YVYU, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_UYVY, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_JPEG:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_RGB444:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB, C0_DF_MASK);
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		ccic_reg_write_mask(pcdev, REG_CTRL0,
+			C0_DF_RGB | C0_RGBF_565 | C0_RGB5_BGGR, C0_DF_MASK);
+		break;
+	default:
+		dev_err(dev, "camera: unknown format: %c\n", fmt->pixelformat);
+		break;
+	}
+
+	/*
+	 * Make sure it knows we want to use hsync/vsync.
+	 */
+	ccic_reg_write_mask(pcdev, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
+	/*
+	 * This field controls the generation of EOF(DVP only)
+	 */
+	if (pdata->bus_type != V4L2_MBUS_CSI2_LANES)
+		ccic_reg_set_bit(pcdev, REG_CTRL0,
+				C0_EOF_VSYNC | C0_VEDGE_CTRL);
+
+	return ret;
+}
+
+static void ccic_frameirq_enable(struct mmp_camera_dev *pcdev)
+{
+	ccic_reg_write(pcdev, REG_IRQSTAT, FRAMEIRQS_EOF);
+	ccic_reg_write(pcdev, REG_IRQSTAT, FRAMEIRQS_SOF);
+	ccic_reg_set_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
+	ccic_reg_set_bit(pcdev, REG_IRQMASK, FRAMEIRQS_SOF);
+}
+
+static void ccic_frameirq_disable(struct mmp_camera_dev *pcdev)
+{
+	ccic_reg_clear_bit(pcdev, REG_IRQMASK, FRAMEIRQS_EOF);
+	ccic_reg_clear_bit(pcdev, REG_IRQMASK, FRAMEIRQS_SOF);
+}
+
+static void ccic_start(struct mmp_camera_dev *pcdev)
+{
+	ccic_reg_set_bit(pcdev, REG_CTRL0, C0_ENABLE);
+}
+
+static void ccic_stop(struct mmp_camera_dev *pcdev)
+{
+	ccic_reg_clear_bit(pcdev, REG_CTRL0, C0_ENABLE);
+}
+
+static void ccic_stop_dma(struct mmp_camera_dev *pcdev)
+{
+	ccic_stop(pcdev);
+	ccic_frameirq_disable(pcdev);
+}
+
+static void ccic_power_up(struct mmp_camera_dev *pcdev)
+{
+	ccic_reg_clear_bit(pcdev, REG_CTRL1, C1_PWRDWN);
+}
+
+static void ccic_power_down(struct mmp_camera_dev *pcdev)
+{
+	ccic_reg_set_bit(pcdev, REG_CTRL1, C1_PWRDWN);
+}
+
+/*
+ * Fetch buffer from list, if single mode, we reserve the last buffer
+ * until new buffer is got, or fetch directly
+ */
+static void mmp_set_contig_buffer(struct mmp_camera_dev *pcdev, int frame)
+{
+	struct mmp_buffer *buf;
+	struct v4l2_pix_format *fmt = &pcdev->pix_format;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	if (list_empty(&pcdev->buffers)) {
+		/*
+		 * If there are no available buffers, go into single mode
+		 */
+		buf = pcdev->vb_bufs[frame ^ 0x1];
+		set_bit(CF_SINGLE_BUF, &pcdev->flags);
+		pcdev->frame_state.singles++;
+	} else {
+		/*
+		 * OK, we have a buffer we can use.
+		 */
+		buf = list_first_entry(&pcdev->buffers, struct mmp_buffer,
+					queue);
+		list_del_init(&buf->queue);
+		clear_bit(CF_SINGLE_BUF, &pcdev->flags);
+	}
+
+	pcdev->vb_bufs[frame] = buf;
+	ccic_reg_write(pcdev, REG_Y0BAR + (frame << 2), buf->yuv_p.y);
+	if (fmt->pixelformat == V4L2_PIX_FMT_YUV422P
+			|| fmt->pixelformat == V4L2_PIX_FMT_YUV420
+			|| fmt->pixelformat == V4L2_PIX_FMT_YVU420) {
+		ccic_reg_write(pcdev, REG_U0BAR + (frame << 2), buf->yuv_p.u);
+		ccic_reg_write(pcdev, REG_V0BAR + (frame << 2), buf->yuv_p.v);
+	}
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+}
+
+static void mmp_dma_setup(struct mmp_camera_dev *pcdev)
+{
+	int frame;
+
+	pcdev->nbufs = MAX_DMA_BUFS;
+	for (frame = 0; frame < pcdev->nbufs; frame++)
+		mmp_set_contig_buffer(pcdev, frame);
+
+	/*
+	 * CCIC use Two Buffers mode
+	 */
+	if (pcdev->nbufs == 2)
+		ccic_reg_set_bit(pcdev, REG_CTRL1, C1_TWOBUFS);
+}
+
+void ccic_ctlr_reset(struct mmp_camera_dev *pcdev)
+{
+	unsigned long val;
+
+	/*
+	 * Used CCIC2
+	 */
+	if (pcdev->pdev->id) {
+		val = readl(APMU_CCIC2_RST);
+		writel(val & ~0x2, APMU_CCIC2_RST);
+		writel(val | 0x2, APMU_CCIC2_RST);
+	}
+
+	val = readl(APMU_CCIC_RST);
+	writel(val & ~0x2, APMU_CCIC_RST);
+	writel(val | 0x2, APMU_CCIC_RST);
+}
+
+/*
+ * Get everything ready, and start grabbing frames.
+ */
+static int mmp_read_setup(struct mmp_camera_dev *pcdev)
+{
+	ccic_config_phy(pcdev, 1);
+	ccic_frameirq_enable(pcdev);
+	mmp_dma_setup(pcdev);
+	ccic_start(pcdev);
+	pcdev->state = S_STREAMING;
+
+	return 0;
+}
+
+static int mmp_videobuf_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
+			u32 *count, u32 *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct soc_camera_device *icd = container_of(vq,
+			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+			icd->current_fmt->host_fmt);
+
+	int minbufs = 2;
+	if (*count < minbufs)
+		*count = minbufs;
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*num_planes = 1;
+	sizes[0] = pcdev->pix_format.sizeimage;
+	alloc_ctxs[0] = pcdev->vb_alloc_ctx;
+	dev_dbg(&pcdev->pdev->dev, "count = %d, size = %u\n", *count, sizes[0]);
+
+	return 0;
+}
+
+static int mmp_videobuf_prepare(struct vb2_buffer *vb)
+{
+	struct soc_camera_device *icd = container_of(vb->vb2_queue,
+			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct mmp_buffer *buf = container_of(vb, struct mmp_buffer, vb_buf);
+	unsigned long size;
+	unsigned long flags = 0;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+			icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	dev_dbg(&pcdev->pdev->dev, "%s; (vb = 0x%p), 0x%p, %lu\n", __func__,
+		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	/*
+	 * Added list head initialization on alloc
+	 */
+	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+	BUG_ON(NULL == icd->current_fmt);
+	size = vb2_plane_size(vb, 0);
+	vb2_set_plane_payload(vb, 0, size);
+
+	return 0;
+}
+
+static void mmp_videobuf_queue(struct vb2_buffer *vb)
+{
+	struct soc_camera_device *icd = container_of(vb->vb2_queue,
+			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct mmp_buffer *buf = container_of(vb, struct mmp_buffer, vb_buf);
+	unsigned long flags = 0;
+	int start;
+	dma_addr_t dma_handle;
+	u32 base_size = icd->user_width * icd->user_height;
+
+	mutex_lock(&pcdev->s_mutex);
+	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
+	BUG_ON(!dma_handle);
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	/*
+	 * Wait until two buffers already queued to the list
+	 * then start DMA
+	 */
+	start = (pcdev->state == S_BUFWAIT) && !list_empty(&pcdev->buffers);
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+
+	if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV422P) {
+		buf->yuv_p.y = dma_handle;
+		buf->yuv_p.u = buf->yuv_p.y + base_size;
+		buf->yuv_p.v = buf->yuv_p.u + base_size / 2;
+	} else if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YUV420) {
+		buf->yuv_p.y = dma_handle;
+		buf->yuv_p.u = buf->yuv_p.y + base_size;
+		buf->yuv_p.v = buf->yuv_p.u + base_size / 4;
+	} else if (pcdev->pix_format.pixelformat == V4L2_PIX_FMT_YVU420) {
+		buf->yuv_p.y = dma_handle;
+		buf->yuv_p.v = buf->yuv_p.y + base_size;
+		buf->yuv_p.u = buf->yuv_p.v + base_size / 4;
+	} else {
+		buf->yuv_p.y = dma_handle;
+	}
+
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	list_add_tail(&buf->queue, &pcdev->buffers);
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+
+	if (start)
+		mmp_read_setup(pcdev);
+	mutex_unlock(&pcdev->s_mutex);
+}
+
+static void mmp_videobuf_cleanup(struct vb2_buffer *vb)
+{
+	struct mmp_buffer *buf = container_of(vb, struct mmp_buffer, vb_buf);
+	struct soc_camera_device *icd = container_of(vb->vb2_queue,
+			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	/*
+	 * queue list must be initialized before del
+	 */
+	if (buf->list_init_flag)
+		list_del_init(&buf->queue);
+	buf->list_init_flag = 0;
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+}
+
+/*
+ * only the list that queued could be initialized
+ */
+static int mmp_videobuf_init(struct vb2_buffer *vb)
+{
+	struct mmp_buffer *buf = container_of(vb, struct mmp_buffer, vb_buf);
+	INIT_LIST_HEAD(&buf->queue);
+	buf->list_init_flag = 1;
+
+	return 0;
+}
+
+static int mmp_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct soc_camera_device *icd = container_of(vq,
+			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	unsigned long flags = 0;
+	int ret = 0, frame;
+
+	mutex_lock(&pcdev->s_mutex);
+	if (count < 2) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (pcdev->state != S_IDLE) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Videobuf2 sneakily hoards all the buffers and won't
+	 * give them to us until *after* streaming starts.  But
+	 * we can't actually start streaming until we have a
+	 * destination.  So go into a wait state and hope they
+	 * give us buffers soon.
+	 */
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	if (list_empty(&pcdev->buffers)) {
+		pcdev->state = S_BUFWAIT;
+		spin_unlock_irqrestore(&pcdev->list_lock, flags);
+		ret = 0;
+		goto out_unlock;
+	}
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+	ret = mmp_read_setup(pcdev);
+out_unlock:
+	for (frame = 0; frame < pcdev->nbufs; frame++)
+		clear_bit(CF_FRAME_SOF0 + frame, &pcdev->flags);
+	mutex_unlock(&pcdev->s_mutex);
+
+	return ret;
+}
+
+static int mmp_stop_streaming(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = container_of(vq,
+			struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	unsigned long flags = 0;
+	int ret = 0;
+
+	mutex_lock(&pcdev->s_mutex);
+	if (pcdev->state == S_BUFWAIT) {
+		/* They never gave us buffers */
+		pcdev->state = S_IDLE;
+		goto out_unlock;
+	}
+
+	if (pcdev->state != S_STREAMING) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ccic_stop_dma(pcdev);
+	pcdev->state = S_IDLE;
+	ccic_ctlr_reset(pcdev);
+
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	INIT_LIST_HEAD(&pcdev->buffers);
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+out_unlock:
+	mutex_unlock(&pcdev->s_mutex);
+
+	return ret;
+}
+
+static struct vb2_ops mmp_videobuf_ops = {
+	.queue_setup		= mmp_videobuf_setup,
+	.buf_prepare		= mmp_videobuf_prepare,
+	.buf_queue		= mmp_videobuf_queue,
+	.buf_cleanup		= mmp_videobuf_cleanup,
+	.buf_init		= mmp_videobuf_init,
+	.start_streaming	= mmp_start_streaming,
+	.stop_streaming		= mmp_stop_streaming,
+	.wait_prepare		= soc_camera_unlock,
+	.wait_finish		= soc_camera_lock,
+};
+
+static int mmp_camera_init_videobuf(struct vb2_queue *q,
+			struct soc_camera_device *icd)
+{
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_USERPTR | VB2_MMAP;
+	q->drv_priv = icd;
+	q->ops = &mmp_videobuf_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct mmp_buffer);
+
+	return vb2_queue_init(q);
+}
+
+/*
+ * Hand a completed buffer back to user space.
+ */
+static void mmp_buffer_done(struct mmp_camera_dev *pcdev,
+			int frame, struct vb2_buffer *vbuf)
+{
+	vbuf->v4l2_buf.bytesused = pcdev->pix_format.sizeimage;
+	vb2_set_plane_payload(vbuf, 0, pcdev->pix_format.sizeimage);
+	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+}
+
+/*
+ * Interrupt handler stuff
+ */
+static inline void mmp_frame_complete(struct mmp_camera_dev *pcdev, int frame)
+{
+	struct mmp_buffer *buf;
+	unsigned long flags = 0;
+
+	pcdev->frame_state.frames++;
+	/*
+	 * "This should never happen"
+	 */
+	if (pcdev->state != S_STREAMING)
+		return;
+
+	spin_lock_irqsave(&pcdev->list_lock, flags);
+	buf = pcdev->vb_bufs[frame];
+	if (!test_bit(CF_SINGLE_BUF, &pcdev->flags)) {
+		pcdev->frame_state.delivered++;
+		mmp_buffer_done(pcdev, frame, &buf->vb_buf);
+	}
+	spin_unlock_irqrestore(&pcdev->list_lock, flags);
+	mmp_set_contig_buffer(pcdev, frame);
+}
+
+static irqreturn_t mmp_camera_frameirq(int irq, void *data)
+{
+	struct mmp_camera_dev *pcdev = data;
+	u32 irqs, frame;
+
+	irqs = ccic_reg_read(pcdev, REG_IRQSTAT);
+	if (!(irqs & FRAMEIRQS))
+		return IRQ_NONE;
+
+	/*
+	 * Disable camera frame irq
+	 */
+	ccic_reg_write(pcdev, REG_IRQSTAT, irqs);
+
+	for (frame = 0; frame < pcdev->nbufs; frame++)
+		if (irqs & (IRQ_SOF0 << frame))
+			set_bit(CF_FRAME_SOF0 + frame, &pcdev->flags);
+
+	for (frame = 0; frame < pcdev->nbufs; frame++)
+		if (irqs & (IRQ_EOF0 << frame) &&
+			test_bit(CF_FRAME_SOF0 + frame, &pcdev->flags)) {
+			mmp_frame_complete(pcdev, frame);
+			clear_bit(CF_FRAME_SOF0 + frame, &pcdev->flags);
+		}
+
+	return IRQ_HANDLED;
+}
+
+static int mmp_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	int ret = 0;
+
+	if (pcdev->icd)
+		return -EBUSY;
+
+	pcdev->frame_state.frames = 0;
+	pcdev->frame_state.singles = 0;
+	pcdev->frame_state.delivered = 0;
+
+	pcdev->icd = icd;
+	pcdev->state = S_IDLE;
+	ccic_power_up(pcdev);
+	ccic_enable_clk(pcdev);
+	ccic_stop(pcdev);
+	/*
+	 * Mask all interrupts.
+	 */
+	ccic_reg_write(pcdev, REG_IRQMASK, 0);
+	ret = v4l2_subdev_call(sd, core, init, 0);
+	/*
+	 * When v4l2_subdev_call return -ENOIOCTLCMD,
+	 * means No ioctl command
+	 */
+	if ((ret < 0) && (ret != -ENOIOCTLCMD) && (ret != -ENODEV)) {
+		dev_info(icd->parent,
+			"camera: Failed to initialize subdev: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void mmp_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+
+	BUG_ON(icd != pcdev->icd);
+
+	dev_err(&pcdev->pdev->dev,
+		"Release %d frames, %d singles, %d delivered\n",
+		pcdev->frame_state.frames, pcdev->frame_state.singles,
+		pcdev->frame_state.delivered);
+	ccic_config_phy(pcdev, 0);
+	ccic_disable_clk(pcdev);
+	ccic_power_down(pcdev);
+	pcdev->icd = NULL;
+}
+
+static int mmp_camera_set_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct device *dev = &pcdev->pdev->dev;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_config cfg;
+	int ret = 0;
+
+	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
+	if (ret < 0) {
+		dev_err(dev, "%s %d\n", __func__, __LINE__);
+		return ret;
+	}
+
+	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
+	if (ret < 0) {
+		dev_err(dev, "%s %d\n", __func__, __LINE__);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int mmp_camera_set_fmt(struct soc_camera_device *icd,
+			struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+	struct device *dev = &pcdev->pdev->dev;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate = NULL;
+	struct v4l2_mbus_framefmt mf;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_frame_interval inter;
+	int ret = 0;
+
+	dev_dbg(dev, "camera: set_fmt: %c, width = %u, height = %u\n",
+		pix->pixelformat, pix->width, pix->height);
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_err(dev, "camera: format: %c not found\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	mf.width = pix->width;
+	mf.height = pix->height;
+	mf.field = V4L2_FIELD_NONE;
+	mf.colorspace = pix->colorspace;
+	mf.code = xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	if (ret < 0) {
+		dev_err(dev, "camera: set_fmt failed %d\n", __LINE__);
+		return ret;
+	}
+
+	if (mf.code != xlate->code) {
+		dev_err(dev, "camera: wrong code %s %d\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+
+	/*
+	 * To get frame_rate
+	 */
+	inter.pad = pdata->mclk_min;
+	ret = v4l2_subdev_call(sd, video, g_frame_interval, &inter);
+	if (ret < 0) {
+		dev_err(dev, "camera: Can't get frame rate %s %d\n",
+			__func__, __LINE__);
+		pcdev->frame_rate = 0;
+	} else
+		pcdev->frame_rate =
+			inter.interval.numerator / inter.interval.denominator;
+
+	pix->width = mf.width;
+	pix->height = mf.height;
+	pix->field = mf.field;
+	pix->colorspace = mf.colorspace;
+	pcdev->pix_format.sizeimage = pix->sizeimage;
+	icd->current_fmt = xlate;
+
+	memcpy(&(pcdev->pix_format), pix, sizeof(struct v4l2_pix_format));
+	ret = ccic_config_image(pcdev);
+
+	return ret;
+}
+
+static int mmp_camera_try_fmt(struct soc_camera_device *icd,
+			struct v4l2_format *f)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct device *dev = &pcdev->pdev->dev;
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	__u32 pixfmt = pix->pixelformat;
+	int ret = 0;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_err(dev, "camera: format: %c not found\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
+						xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+		/*
+		 * Todo: soc_camera_try_fmt could clear
+		 * sizeimage, we can't get the value from
+		 * userspace, just hard coding
+		 */
+		pix->bytesperline = 2048;
+	} else
+		pix->sizeimage = pix->height * pix->bytesperline;
+
+	/*
+	 * limit to sensor capabilities
+	 */
+	mf.width = pix->width;
+	mf.height = pix->height;
+	mf.field = V4L2_FIELD_NONE;
+	mf.colorspace = pix->colorspace;
+	mf.code = xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	pix->width = mf.width;
+	pix->height = mf.height;
+	pix->colorspace = mf.colorspace;
+
+	switch (mf.field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		pix->field = V4L2_FIELD_NONE;
+		break;
+	default:
+		dev_err(dev, "camera: Field type %d unsupported.\n", mf.field);
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static unsigned int mmp_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_device *icd = file->private_data;
+
+	return vb2_poll(&icd->vb2_vidq, file, pt);
+}
+
+static int mmp_camera_querycap(struct soc_camera_host *ici,
+			struct v4l2_capability *cap)
+{
+	struct v4l2_dbg_chip_ident id;
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct soc_camera_device *icd = pcdev->icd;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = &pcdev->pdev->dev;
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+	int ret = 0;
+
+	cap->version = KERNEL_VERSION(0, 0, 5);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	ret = v4l2_subdev_call(sd, core, g_chip_ident, &id);
+	if (ret < 0) {
+		dev_err(dev, "%s %d\n", __func__, __LINE__);
+		return ret;
+	}
+
+	strcpy(cap->card, pdata->name);
+	strcpy(cap->driver, (const char *)id.ident);
+
+	return 0;
+}
+
+static int mmp_camera_set_parm(struct soc_camera_device *icd,
+			struct v4l2_streamparm *para)
+{
+	return 0;
+}
+
+static int mmp_camera_get_formats(struct soc_camera_device *icd, u32 idx,
+			struct soc_camera_format_xlate  *xlate)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mmp_camera_dev *pcdev = ici->priv;
+	struct device *dev = &pcdev->pdev->dev;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
+	int formats = 0, ret = 0, i;
+
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/*
+		 * No more formats
+		 */
+		return 0;
+
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(dev, "camera: Invalid format #%u: %d\n", idx, code);
+		return 0;
+	}
+
+	switch (code) {
+	/*
+	 * Refer to mbus_fmt struct
+	 */
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		/*
+		 * Add support for YUV420 and YUV422P
+		 */
+		formats = ARRAY_SIZE(ccic_formats);
+		if (xlate) {
+			for (i = 0; i < ARRAY_SIZE(ccic_formats); i++) {
+				xlate->host_fmt = &ccic_formats[i];
+				xlate->code = code;
+				xlate++;
+			}
+		}
+		return formats;
+	case V4L2_MBUS_FMT_JPEG_1X8:
+		if (xlate)
+			dev_err(dev, "camera: Providing format: %s\n",
+				fmt->name);
+		break;
+	default:
+		/*
+		 * camera controller can not support
+		 * this format, which might supported by the sensor
+		 */
+		dev_warn(dev, "camera: Not support fmt: %s\n", fmt->name);
+		return 0;
+	}
+
+	formats++;
+	if (xlate) {
+		xlate->host_fmt = fmt;
+		xlate->code = code;
+		xlate++;
+	}
+
+	return formats;
+}
+
+static struct soc_camera_host_ops mmp_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= mmp_camera_add_device,
+	.remove		= mmp_camera_remove_device,
+	.set_fmt	= mmp_camera_set_fmt,
+	.try_fmt	= mmp_camera_try_fmt,
+	.set_parm	= mmp_camera_set_parm,
+	.init_videobuf2	= mmp_camera_init_videobuf,
+	.poll		= mmp_camera_poll,
+	.querycap	= mmp_camera_querycap,
+	.set_bus_param	= mmp_camera_set_bus_param,
+	.get_formats	= mmp_camera_get_formats,
+};
+
+static int __devinit mmp_camera_probe(struct platform_device *pdev)
+{
+	struct mmp_camera_dev *pcdev;
+	struct mmp_cam_pdata *pdata;
+	struct resource *res;
+	void __iomem *base;
+	int irq;
+	int err = 0;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata || !pdata->init_clk || !pdata->enable_clk)
+		return -EINVAL;
+
+	dev_info(&pdev->dev, "camera: probing CCIC%d\n", pdev->id + 1);
+
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "camera: Could not allocate pcdev\n");
+		return -ENOMEM;
+	}
+
+	pcdev->pdev = pdev;
+
+	err = pdata->init_clk(&pdev->dev, 1);
+	if (err)
+		goto exit_clk;
+
+	INIT_LIST_HEAD(&pcdev->buffers);
+
+	spin_lock_init(&pcdev->list_lock);
+	mutex_init(&pcdev->s_mutex);
+
+	/*
+	 * Request the regions and ioremap
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!base) {
+		dev_err(&pdev->dev,
+			"camera: Failed to request and remap io memory\n");
+		return -ENXIO;
+	}
+
+	pcdev->res = res;
+	pcdev->base = base;
+
+	/*
+	 * Request irq
+	 */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "camera: Failed to get irq resource\n");
+		return -ENXIO;
+	}
+
+	pcdev->irq = irq;
+	err = devm_request_irq(&pdev->dev, pcdev->irq, mmp_camera_frameirq,
+				IRQF_SHARED, MMP_CAM_DRV_NAME, pcdev);
+	if (err) {
+		dev_err(&pdev->dev, "camera: Interrupt request failed\n");
+		goto exit_clk;
+	}
+
+	ccic_enable_clk(pcdev);
+	pcdev->soc_host.drv_name = MMP_CAM_DRV_NAME;
+	pcdev->soc_host.ops = &mmp_soc_camera_host_ops;
+	pcdev->soc_host.priv = pcdev;
+	pcdev->soc_host.v4l2_dev.dev = &pdev->dev;
+	pcdev->soc_host.nr = pdev->id;
+	pcdev->vb_alloc_ctx = (struct vb2_alloc_ctx *)
+				vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->vb_alloc_ctx)) {
+		err = PTR_ERR(pcdev->vb_alloc_ctx);
+		goto exit_clk;
+	}
+
+	err = soc_camera_host_register(&pcdev->soc_host);
+	if (err)
+		goto exit_free_ctx;
+
+	return 0;
+
+exit_free_ctx:
+	vb2_dma_contig_cleanup_ctx(pcdev->vb_alloc_ctx);
+exit_clk:
+	pdata->init_clk(&pdev->dev, 0);
+
+	return err;
+}
+
+static int __devexit mmp_camera_remove(struct platform_device *pdev)
+{
+
+	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
+	struct mmp_camera_dev *pcdev = container_of(soc_host,
+			struct mmp_camera_dev, soc_host);
+	struct mmp_cam_pdata *pdata = pcdev->pdev->dev.platform_data;
+
+	pdata->init_clk(&pdev->dev, 0);
+	ccic_power_down(pcdev);
+	soc_camera_host_unregister(soc_host);
+	vb2_dma_contig_cleanup_ctx(pcdev->vb_alloc_ctx);
+	pcdev->vb_alloc_ctx = NULL;
+	dev_info(&pdev->dev, "camera: MMP Camera driver unloaded\n");
+
+	return 0;
+}
+
+static struct platform_driver mmp_camera_driver = {
+	.driver = {
+		.name = MMP_CAM_DRV_NAME,
+	},
+	.probe = mmp_camera_probe,
+	.remove = __devexit_p(mmp_camera_remove),
+};
+
+module_platform_driver(mmp_camera_driver);
+
+MODULE_DESCRIPTION("Marvell MMP CMOS Camera Interface Controller driver");
+MODULE_AUTHOR("Kassey Lee <ygli@marvell.com>");
+MODULE_AUTHOR("Angela Wan <jwan@marvell.com>");
+MODULE_AUTHOR("Albert Wang <twang13@marvell.com>");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("Video");
+
diff --git a/drivers/media/video/mmp_camera.h b/drivers/media/video/mmp_camera.h
new file mode 100644
index 0000000..106892a
--- /dev/null
+++ b/drivers/media/video/mmp_camera.h
@@ -0,0 +1,241 @@
+/*
+ * Register definitions for the m88alp01 camera interface.
+ * Offsets in bytes as given in the spec.
+ *
+ * Copyright 2006 One Laptop Per Child Association, Inc.
+ * Written by Jonathan Corbet <corbet@lwn.net>
+ *
+ * Copyright (C) 2011-2012, Marvell International Ltd.
+ * Modified by Kassey Lee <ygli@marvell.com>
+ *	       Albert Wang <twang13@marvell.com>
+ *
+ * This file may be distributed under the terms of the GNU General
+ * Public License, version 2.
+ */
+#ifndef __MMP_CAMERA_H
+#define __MMP_CAMERA_H
+
+/*
+ * Y.U.V. reg define
+ */
+#define REG_Y0BAR	0x00
+#define REG_Y1BAR	0x04
+#define REG_Y2BAR	0x08
+#define REG_U0BAR	0x0c
+#define REG_U1BAR	0x10
+#define REG_U2BAR	0x14
+#define REG_V0BAR	0x18
+#define REG_V1BAR	0x1C
+#define REG_V2BAR	0x20
+
+/*
+ * MIPI enable
+ */
+#define REG_CSI2_CTRL0	0x100
+#define REG_CSI2_DPHY3  0x12c
+#define REG_CSI2_DPHY5  0x134
+#define REG_CSI2_DPHY6  0x138
+
+#define REG_IMGPITCH	0x24	/* Image pitch register */
+#define   IMGP_YP_SHFT	  2		/* Y pitch params */
+#define   IMGP_YP_MASK	  0x00003ffc	/* Y pitch field */
+#define   IMGP_UVP_SHFT   18		/* UV pitch (planar) */
+#define   IMGP_UVP_MASK   0x3ffc0000
+
+#define REG_IRQSTATRAW	0x28	/* RAW IRQ Status */
+
+#define REG_IRQMASK	0x2c	/* IRQ mask - same bits as IRQSTAT */
+
+#define REG_IRQSTAT	0x30	/* IRQ status / clear */
+#define   IRQ_EOF0	  0x00000001	/* End of frame 0 */
+#define   IRQ_EOF1	  0x00000002	/* End of frame 1 */
+#define   IRQ_EOF2	  0x00000004	/* End of frame 2 */
+#define   IRQ_SOF0	  0x00000008	/* Start of frame 0 */
+#define   IRQ_SOF1	  0x00000010	/* Start of frame 1 */
+#define   IRQ_SOF2	  0x00000020	/* Start of frame 2 */
+#define   IRQ_OVERFLOW	  0x00000040	/* FIFO overflow */
+#define   FRAMEIRQS_EOF   (IRQ_EOF0 | IRQ_EOF1 | IRQ_EOF2)
+#define   FRAMEIRQS_SOF   (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)
+#define   FRAMEIRQS	  (IRQ_EOF0 | IRQ_EOF1 | IRQ_EOF2 | \
+			   IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)
+#define   ALLIRQS	  (FRAMEIRQS | IRQ_OVERFLOW)
+
+#define REG_IMGSIZE	0x34	/* Image size */
+#define  IMGSZ_V_MASK	  0x1fff0000
+#define  IMGSZ_V_SHIFT	  16
+#define  IMGSZ_H_MASK	  0x00003fff
+
+#define REG_IMGOFFSET	0x38	/* IMage offset */
+
+#define REG_CTRL0	0x3c	/* Control 0 */
+#define   C0_ENABLE	  0x00000001	/* Makes the whole thing go */
+/* Mask for all the format bits */
+#define   C0_DF_MASK	  0x00fffffc    /* Bits 2-23 */
+/* RGB ordering */
+#define   C0_RGB4_RGBX	  0x00000000
+#define   C0_RGB4_XRGB	  0x00000004
+#define   C0_RGB4_BGRX	  0x00000008
+#define   C0_RGB4_XBGR	  0x0000000c
+#define   C0_RGB5_RGGB	  0x00000000
+#define   C0_RGB5_GRBG	  0x00000004
+#define   C0_RGB5_GBRG	  0x00000008
+#define   C0_RGB5_BGGR	  0x0000000c
+/* Spec has two fields for DIN and DOUT, but they must match, so
+   combine them here. */
+#define   C0_DF_YUV	  0x00000000    /* Data is YUV */
+#define   C0_DF_RGB	  0x000000a0	/* Data is RGB */
+#define   C0_DF_BAYER	  0x00000140	/* Data is Bayer */
+/* 8-8-8 must be missing from the below - ask */
+#define   C0_RGBF_565	  0x00000000
+#define   C0_RGBF_444	  0x00000800
+#define   C0_RGB_BGR	  0x00001000	/* Blue comes first */
+#define   C0_YUV_PLANAR   0x00000000	/* YUV 422 planar format */
+#define   C0_YUV_PACKED   0x00008000	/* YUV 422 packed format */
+#define   C0_YUV_420PL	  0x0000a000	/* YUV 420 planar format */
+/* Think that 420 packed must be 111 - ask */
+#define   C0_YUVE_YUYV	  0x00000000	/* Y1CbY0Cr */
+#define   C0_YUVE_YVYU	  0x00010000	/* Y1CrY0Cb */
+#define   C0_YUVE_VYUY	  0x00020000	/* CrY1CbY0 */
+#define   C0_YUVE_UYVY	  0x00030000	/* CbY1CrY0 */
+#define   C0_YUVE_XYUV	  0x00000000    /* 420: .YUV */
+#define   C0_YUVE_XYVU	  0x00010000	/* 420: .YVU */
+#define   C0_YUVE_XUVY	  0x00020000	/* 420: .UVY */
+#define   C0_YUVE_XVUY	  0x00030000	/* 420: .VUY */
+/* Bayer bits 18,19 if needed */
+#define   C0_HPOL_LOW	  0x01000000	/* HSYNC polarity active low */
+#define   C0_VPOL_LOW	  0x02000000	/* VSYNC polarity active low */
+#define   C0_VCLK_LOW	  0x04000000	/* VCLK on falling edge */
+#define   C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
+#define   C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
+#define   C0_SIF_HVSYNC   0x00000000	/* Use H/VSYNC */
+#define   C0_SOF_NOSYNC   0x40000000	/* Use inband active signaling */
+#define   C0_EOF_VSYNC	  0x00400000	/* Generate EOF by VSYNC */
+#define   C0_VEDGE_CTRL   0x00800000	/* Detecting falling edge of VSYNC */
+
+#define REG_CTRL1	0x40	/* Control 1 */
+#define   C1_RESERVED	  0x0000003c	/* Reserved and shouldn't be changed */
+#define   C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
+#define   C1_ALPHA_SHFT   20
+#define   C1_DMAB64	  0x00000000	/* 64-byte DMA burst */
+#define   C1_DMAB128	  0x02000000	/* 128-byte DMA burst */
+#define   C1_DMAB256	  0x04000000	/* 256-byte DMA burst */
+#define   C1_DMAB_MASK	  0x06000000
+#define   C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
+#define   C1_PWRDWN	  0x10000000	/* Power down */
+#define   C1_DMAPOSTED	  0x40000000	/* DMA Posted Select */
+
+#define REG_CTRL3	0x1ec	/* CCIC parallel mode */
+
+#define REG_LNNUM	0x60	/* Lines num DMA filled */
+
+#define REG_CLKCTRL	0x88	/* Clock control */
+#define   CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */
+
+/*
+ * Indicate flags for CCIC frame buffer state
+ * 0	- No available buffer, will enter signle buffer mode
+ * 1:3	- Normal mode, indicate which frame buffer is used in CCIC
+ */
+#define CF_SINGLE_BUF	0
+#define CF_FRAME_SOF0	1
+
+/*
+ * CCIC can support at most 3 frame buffers
+ * 2	- Use Two Buffers mode
+ * 3	- Use Three Buffers mode
+ */
+#define MAX_DMA_BUFS	2
+
+/*
+ * Basic frame states
+ */
+struct mmp_frame_state {
+	int frames;
+	int singles;
+	int delivered;
+};
+
+struct yuv_pointer_t {
+	dma_addr_t y;
+	dma_addr_t u;
+	dma_addr_t v;
+};
+
+/*
+ * buffer for one video frame
+ */
+struct mmp_buffer {
+	/*
+	 * common v4l buffer stuff -- must be first
+	 */
+	struct vb2_buffer vb_buf;
+	struct yuv_pointer_t yuv_p;
+	struct list_head queue;
+	struct page *page;
+	size_t bsize;
+	int list_init_flag;
+};
+
+enum mmp_camera_state {
+	S_IDLE,		/* Just hanging around */
+	S_STREAMING,	/* Streaming data */
+	S_BUFWAIT	/* streaming requested but no buffers yet */
+};
+
+struct mmp_camera_dev {
+	struct soc_camera_host soc_host;
+	struct soc_camera_device *icd;
+	unsigned int irq;
+	void __iomem *base;
+	struct platform_device *pdev;
+	struct resource *res;
+	struct list_head buffers;	/* Available frames */
+	spinlock_t list_lock;
+	struct mutex s_mutex;		/* Access to this structure */
+	struct v4l2_pix_format pix_format;
+	unsigned long flags;		/* Indicate frame buffer state */
+	struct mmp_frame_state frame_state;
+	enum mmp_camera_state state;
+	struct mmp_buffer *vb_bufs[MAX_DMA_BUFS];
+	unsigned int nbufs;		/* How many bufs are used for ccic */
+	struct vb2_alloc_ctx *vb_alloc_ctx;
+	int frame_rate;
+};
+
+/*
+ * Device register I/O
+ */
+static inline u32 ccic_reg_read(struct mmp_camera_dev *pcdev, unsigned int reg)
+{
+	return ioread32(pcdev->base + reg);
+}
+
+static inline void ccic_reg_write(struct mmp_camera_dev *pcdev,
+			unsigned int reg, u32 val)
+{
+	iowrite32(val, pcdev->base + reg);
+}
+
+static inline void ccic_reg_write_mask(struct mmp_camera_dev *pcdev,
+			unsigned int reg, u32 val, u32 mask)
+{
+	u32 v = ccic_reg_read(pcdev, reg);
+
+	v = (v & ~mask) | (val & mask);
+	ccic_reg_write(pcdev, reg, v);
+}
+
+static inline void ccic_reg_set_bit(struct mmp_camera_dev *pcdev,
+			unsigned int reg, u32 val)
+{
+	ccic_reg_write_mask(pcdev, reg, val, val);
+}
+
+static inline void ccic_reg_clear_bit(struct mmp_camera_dev *pcdev,
+			unsigned int reg, u32 val)
+{
+	ccic_reg_write_mask(pcdev, reg, 0, val);
+}
+
+#endif
+
-- 
1.7.0.4

