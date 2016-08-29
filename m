Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:54040 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756001AbcH2R4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 13:56:33 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 13/13] media: platform: pxa_camera: move pxa_camera out of soc_camera
Date: Mon, 29 Aug 2016 19:55:58 +0200
Message-Id: <1472493358-24618-14-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the conversion to a v4l2 standalone device is finished, move
pxa_camera one directory up and finish severing any dependency to
soc_camera.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/Kconfig                 |    8 +
 drivers/media/platform/Makefile                |    1 +
 drivers/media/platform/pxa_camera.c            | 2096 ++++++++++++++++++++++++
 drivers/media/platform/soc_camera/Kconfig      |    8 -
 drivers/media/platform/soc_camera/Makefile     |    1 -
 drivers/media/platform/soc_camera/pxa_camera.c | 2096 ------------------------
 6 files changed, 2105 insertions(+), 2105 deletions(-)
 create mode 100644 drivers/media/platform/pxa_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/pxa_camera.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f25344bc7912..299af1977d61 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -91,6 +91,14 @@ config VIDEO_OMAP3_DEBUG
 	---help---
 	  Enable debug messages on OMAP 3 camera controller driver.
 
+config VIDEO_PXA27x
+	tristate "PXA27x Quick Capture Interface driver"
+	depends on VIDEO_DEV && PXA27x && HAS_DMA
+	select VIDEOBUF2_DMA_SG
+	select SG_SPLIT
+	---help---
+	  This is a v4l2 driver for the PXA27x Quick Capture Interface
+
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 21771c1a13fb..e38918bbe0d0 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
+obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o soc_camera/soc_mediabus.o
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
new file mode 100644
index 000000000000..868c6ad4784c
--- /dev/null
+++ b/drivers/media/platform/pxa_camera.c
@@ -0,0 +1,2096 @@
+/*
+ * V4L2 Driver for PXA camera host
+ *
+ * Copyright (C) 2006, Sascha Hauer, Pengutronix
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ * Copyright (C) 2016, Robert Jarzmik <robert.jarzmik@free.fr>
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
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/of.h>
+#include <linux/time.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma/pxa-dma.h>
+
+#include <media/v4l2-async.h>
+#include <media/v4l2-clk.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-of.h>
+
+#include <media/drv-intf/soc_mediabus.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include <linux/videodev2.h>
+
+#include <linux/platform_data/media/camera-pxa.h>
+
+#define PXA_CAM_VERSION "0.0.6"
+#define PXA_CAM_DRV_NAME "pxa27x-camera"
+
+#define DEFAULT_WIDTH	640
+#define DEFAULT_HEIGHT	480
+
+/* Camera Interface */
+#define CICR0		0x0000
+#define CICR1		0x0004
+#define CICR2		0x0008
+#define CICR3		0x000C
+#define CICR4		0x0010
+#define CISR		0x0014
+#define CIFR		0x0018
+#define CITOR		0x001C
+#define CIBR0		0x0028
+#define CIBR1		0x0030
+#define CIBR2		0x0038
+
+#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
+#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
+#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
+#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
+#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
+#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
+#define CICR0_TOM	(1 << 9)	/* Time-out mask */
+#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
+#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
+#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
+#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
+#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
+#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
+#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
+#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
+#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
+
+#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
+#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
+#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
+#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
+#define CICR1_RGB_F	(1 << 11)	/* RGB format */
+#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
+#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
+#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
+#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
+#define CICR1_DW	(0x7 << 0)	/* Data width mask */
+
+#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
+					   wait count mask */
+#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
+					   wait count mask */
+#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
+#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
+					   wait count mask */
+#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
+					   wait count mask */
+
+#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
+					   wait count mask */
+#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
+					   wait count mask */
+#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
+#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
+					   wait count mask */
+#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
+
+#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
+#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
+#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
+#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
+#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
+#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
+#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
+#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
+
+#define CISR_FTO	(1 << 15)	/* FIFO time-out */
+#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
+#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
+#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
+#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
+#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
+#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
+#define CISR_EOL	(1 << 8)	/* End of line */
+#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
+#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
+#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
+#define CISR_SOF	(1 << 4)	/* Start of frame */
+#define CISR_EOF	(1 << 3)	/* End of frame */
+#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
+#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
+#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
+
+#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
+#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
+#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
+#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
+#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
+#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
+#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
+#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
+
+#define CICR0_SIM_MP	(0 << 24)
+#define CICR0_SIM_SP	(1 << 24)
+#define CICR0_SIM_MS	(2 << 24)
+#define CICR0_SIM_EP	(3 << 24)
+#define CICR0_SIM_ES	(4 << 24)
+
+#define CICR1_DW_VAL(x)   ((x) & CICR1_DW)	    /* Data bus width */
+#define CICR1_PPL_VAL(x)  (((x) << 15) & CICR1_PPL) /* Pixels per line */
+#define CICR1_COLOR_SP_VAL(x)	(((x) << 3) & CICR1_COLOR_SP)	/* color space */
+#define CICR1_RGB_BPP_VAL(x)	(((x) << 7) & CICR1_RGB_BPP)	/* bpp for rgb */
+#define CICR1_RGBT_CONV_VAL(x)	(((x) << 29) & CICR1_RGBT_CONV)	/* rgbt conv */
+
+#define CICR2_BLW_VAL(x)  (((x) << 24) & CICR2_BLW) /* Beginning-of-line pixel clock wait count */
+#define CICR2_ELW_VAL(x)  (((x) << 16) & CICR2_ELW) /* End-of-line pixel clock wait count */
+#define CICR2_HSW_VAL(x)  (((x) << 10) & CICR2_HSW) /* Horizontal sync pulse width */
+#define CICR2_BFPW_VAL(x) (((x) << 3) & CICR2_BFPW) /* Beginning-of-frame pixel clock wait count */
+#define CICR2_FSW_VAL(x)  (((x) << 0) & CICR2_FSW)  /* Frame stabilization wait count */
+
+#define CICR3_BFW_VAL(x)  (((x) << 24) & CICR3_BFW) /* Beginning-of-frame line clock wait count  */
+#define CICR3_EFW_VAL(x)  (((x) << 16) & CICR3_EFW) /* End-of-frame line clock wait count */
+#define CICR3_VSW_VAL(x)  (((x) << 11) & CICR3_VSW) /* Vertical sync pulse width */
+#define CICR3_LPF_VAL(x)  (((x) << 0) & CICR3_LPF)  /* Lines per frame */
+
+#define CICR0_IRQ_MASK (CICR0_TOM | CICR0_RDAVM | CICR0_FEM | CICR0_EOLM | \
+			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
+			CICR0_EOFM | CICR0_FOM)
+
+#define sensor_call(cam, o, f, args...) \
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
+
+/*
+ * Structures
+ */
+enum pxa_camera_active_dma {
+	DMA_Y = 0x1,
+	DMA_U = 0x2,
+	DMA_V = 0x4,
+};
+
+/* buffer for one video frame */
+struct pxa_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer		vbuf;
+	struct list_head		queue;
+	u32	code;
+	int				nb_planes;
+	/* our descriptor lists for Y, U and V channels */
+	struct dma_async_tx_descriptor	*descs[3];
+	dma_cookie_t			cookie[3];
+	struct scatterlist		*sg[3];
+	int				sg_len[3];
+	size_t				plane_sizes[3];
+	int				inwork;
+	enum pxa_camera_active_dma	active_dma;
+};
+
+struct pxa_camera_dev {
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
+	/*
+	 * PXA27x is only supposed to handle one camera on its Quick Capture
+	 * interface. If anyone ever builds hardware to enable more than
+	 * one camera, they will have to modify this driver too
+	 */
+	struct clk		*clk;
+
+	unsigned int		irq;
+	void __iomem		*base;
+
+	int			channels;
+	struct dma_chan		*dma_chans[3];
+
+	struct pxacamera_platform_data *pdata;
+	struct resource		*res;
+	unsigned long		platform_flags;
+	unsigned long		ciclk;
+	unsigned long		mclk;
+	u32			mclk_divisor;
+	struct v4l2_clk		*mclk_clk;
+	u16			width_flags;	/* max 10 bits */
+
+	struct list_head	capture;
+
+	spinlock_t		lock;
+	struct mutex		mlock;
+	unsigned int		buf_sequence;
+
+	struct pxa_buffer	*active;
+	struct tasklet_struct	task_eof;
+
+	u32			save_cicr[5];
+};
+
+struct pxa_cam {
+	unsigned long flags;
+};
+
+static const char *pxa_cam_driver_description = "PXA_Camera";
+
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
+{
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
+
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
+}
+
+/*
+ *  Videobuf operations
+ */
+static struct pxa_buffer *vb2_to_pxa_buffer(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	return container_of(vbuf, struct pxa_buffer, vbuf);
+}
+
+static struct device *pcdev_to_dev(struct pxa_camera_dev *pcdev)
+{
+	return pcdev->v4l2_dev.dev;
+}
+
+static struct pxa_camera_dev *v4l2_dev_to_pcdev(struct v4l2_device *v4l2_dev)
+{
+	return container_of(v4l2_dev, struct pxa_camera_dev, v4l2_dev);
+}
+
+static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
+			       enum pxa_camera_active_dma act_dma);
+
+static void pxa_camera_dma_irq_y(void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+
+	pxa_camera_dma_irq(pcdev, DMA_Y);
+}
+
+static void pxa_camera_dma_irq_u(void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+
+	pxa_camera_dma_irq(pcdev, DMA_U);
+}
+
+static void pxa_camera_dma_irq_v(void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+
+	pxa_camera_dma_irq(pcdev, DMA_V);
+}
+
+/**
+ * pxa_init_dma_channel - init dma descriptors
+ * @pcdev: pxa camera device
+ * @vb: videobuffer2 buffer
+ * @dma: dma video buffer
+ * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
+ * @cibr: camera Receive Buffer Register
+ *
+ * Prepares the pxa dma descriptors to transfer one camera channel.
+ *
+ * Returns 0 if success or -ENOMEM if no memory is available
+ */
+static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
+				struct pxa_buffer *buf, int channel,
+				struct scatterlist *sg, int sglen)
+{
+	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
+	struct dma_async_tx_descriptor *tx;
+
+	tx = dmaengine_prep_slave_sg(dma_chan, sg, sglen, DMA_DEV_TO_MEM,
+				     DMA_PREP_INTERRUPT | DMA_CTRL_REUSE);
+	if (!tx) {
+		dev_err(pcdev_to_dev(pcdev),
+			"dmaengine_prep_slave_sg failed\n");
+		goto fail;
+	}
+
+	tx->callback_param = pcdev;
+	switch (channel) {
+	case 0:
+		tx->callback = pxa_camera_dma_irq_y;
+		break;
+	case 1:
+		tx->callback = pxa_camera_dma_irq_u;
+		break;
+	case 2:
+		tx->callback = pxa_camera_dma_irq_v;
+		break;
+	}
+
+	buf->descs[channel] = tx;
+	return 0;
+fail:
+	dev_dbg(pcdev_to_dev(pcdev),
+		"%s (vb=%p) dma_tx=%p\n",
+		__func__, buf, tx);
+
+	return -ENOMEM;
+}
+
+static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
+				    struct pxa_buffer *buf)
+{
+	buf->active_dma = DMA_Y;
+	if (buf->nb_planes == 3)
+		buf->active_dma |= DMA_U | DMA_V;
+}
+
+/**
+ * pxa_dma_start_channels - start DMA channel for active buffer
+ * @pcdev: pxa camera device
+ *
+ * Initialize DMA channels to the beginning of the active video buffer, and
+ * start these channels.
+ */
+static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
+{
+	int i;
+	struct pxa_buffer *active;
+
+	active = pcdev->active;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		dev_dbg(pcdev_to_dev(pcdev),
+			"%s (channel=%d)\n", __func__, i);
+		dma_async_issue_pending(pcdev->dma_chans[i]);
+	}
+}
+
+static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
+{
+	int i;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		dev_dbg(pcdev_to_dev(pcdev),
+			"%s (channel=%d)\n", __func__, i);
+		dmaengine_terminate_all(pcdev->dma_chans[i]);
+	}
+}
+
+static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
+				 struct pxa_buffer *buf)
+{
+	int i;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		buf->cookie[i] = dmaengine_submit(buf->descs[i]);
+		dev_dbg(pcdev_to_dev(pcdev),
+			"%s (channel=%d) : submit vb=%p cookie=%d\n",
+			__func__, i, buf, buf->descs[i]->cookie);
+	}
+}
+
+/**
+ * pxa_camera_start_capture - start video capturing
+ * @pcdev: camera device
+ *
+ * Launch capturing. DMA channels should not be active yet. They should get
+ * activated at the end of frame interrupt, to capture only whole frames, and
+ * never begin the capture of a partial frame.
+ */
+static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
+{
+	unsigned long cicr0;
+
+	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
+	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
+	/* Enable End-Of-Frame Interrupt */
+	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
+	cicr0 &= ~CICR0_EOFM;
+	__raw_writel(cicr0, pcdev->base + CICR0);
+}
+
+static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
+{
+	unsigned long cicr0;
+
+	pxa_dma_stop_channels(pcdev);
+
+	cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
+	__raw_writel(cicr0, pcdev->base + CICR0);
+
+	pcdev->active = NULL;
+	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
+}
+
+static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
+			      struct pxa_buffer *buf,
+			      enum vb2_buffer_state state)
+{
+	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
+	list_del_init(&buf->queue);
+	vb->timestamp = ktime_get_ns();
+	vbuf->sequence = pcdev->buf_sequence++;
+	vbuf->field = V4L2_FIELD_NONE;
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	dev_dbg(pcdev_to_dev(pcdev), "%s dequeud buffer (buf=0x%p)\n",
+		__func__, buf);
+
+	if (list_empty(&pcdev->capture)) {
+		pxa_camera_stop_capture(pcdev);
+		return;
+	}
+
+	pcdev->active = list_entry(pcdev->capture.next,
+				   struct pxa_buffer, queue);
+}
+
+/**
+ * pxa_camera_check_link_miss - check missed DMA linking
+ * @pcdev: camera device
+ *
+ * The DMA chaining is done with DMA running. This means a tiny temporal window
+ * remains, where a buffer is queued on the chain, while the chain is already
+ * stopped. This means the tailed buffer would never be transferred by DMA.
+ * This function restarts the capture for this corner case, where :
+ *  - DADR() == DADDR_STOP
+ *  - a videobuffer is queued on the pcdev->capture list
+ *
+ * Please check the "DMA hot chaining timeslice issue" in
+ *   Documentation/video4linux/pxa_camera.txt
+ *
+ * Context: should only be called within the dma irq handler
+ */
+static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
+				       dma_cookie_t last_submitted,
+				       dma_cookie_t last_issued)
+{
+	bool is_dma_stopped = last_submitted != last_issued;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		"%s : top queued buffer=%p, is_dma_stopped=%d\n",
+		__func__, pcdev->active, is_dma_stopped);
+
+	if (pcdev->active && is_dma_stopped)
+		pxa_camera_start_capture(pcdev);
+}
+
+static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
+			       enum pxa_camera_active_dma act_dma)
+{
+	struct pxa_buffer *buf, *last_buf;
+	unsigned long flags;
+	u32 camera_status, overrun;
+	int chan;
+	enum dma_status last_status;
+	dma_cookie_t last_issued;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	camera_status = __raw_readl(pcdev->base + CISR);
+	dev_dbg(pcdev_to_dev(pcdev), "camera dma irq, cisr=0x%x dma=%d\n",
+		camera_status, act_dma);
+	overrun = CISR_IFO_0;
+	if (pcdev->channels == 3)
+		overrun |= CISR_IFO_1 | CISR_IFO_2;
+
+	/*
+	 * pcdev->active should not be NULL in DMA irq handler.
+	 *
+	 * But there is one corner case : if capture was stopped due to an
+	 * overrun of channel 1, and at that same channel 2 was completed.
+	 *
+	 * When handling the overrun in DMA irq for channel 1, we'll stop the
+	 * capture and restart it (and thus set pcdev->active to NULL). But the
+	 * DMA irq handler will already be pending for channel 2. So on entering
+	 * the DMA irq handler for channel 2 there will be no active buffer, yet
+	 * that is normal.
+	 */
+	if (!pcdev->active)
+		goto out;
+
+	buf = pcdev->active;
+	WARN_ON(buf->inwork || list_empty(&buf->queue));
+
+	/*
+	 * It's normal if the last frame creates an overrun, as there
+	 * are no more DMA descriptors to fetch from QCI fifos
+	 */
+	switch (act_dma) {
+	case DMA_U:
+		chan = 1;
+		break;
+	case DMA_V:
+		chan = 2;
+		break;
+	default:
+		chan = 0;
+		break;
+	}
+	last_buf = list_entry(pcdev->capture.prev,
+			      struct pxa_buffer, queue);
+	last_status = dma_async_is_tx_complete(pcdev->dma_chans[chan],
+					       last_buf->cookie[chan],
+					       NULL, &last_issued);
+	if (camera_status & overrun &&
+	    last_status != DMA_COMPLETE) {
+		dev_dbg(pcdev_to_dev(pcdev), "FIFO overrun! CISR: %x\n",
+			camera_status);
+		pxa_camera_stop_capture(pcdev);
+		list_for_each_entry(buf, &pcdev->capture, queue)
+			pxa_dma_add_tail_buf(pcdev, buf);
+		pxa_camera_start_capture(pcdev);
+		goto out;
+	}
+	buf->active_dma &= ~act_dma;
+	if (!buf->active_dma) {
+		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_DONE);
+		pxa_camera_check_link_miss(pcdev, last_buf->cookie[chan],
+					   last_issued);
+	}
+
+out:
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+static u32 mclk_get_divisor(struct platform_device *pdev,
+			    struct pxa_camera_dev *pcdev)
+{
+	unsigned long mclk = pcdev->mclk;
+	u32 div;
+	unsigned long lcdclk;
+
+	lcdclk = clk_get_rate(pcdev->clk);
+	pcdev->ciclk = lcdclk;
+
+	/* mclk <= ciclk / 4 (27.4.2) */
+	if (mclk > lcdclk / 4) {
+		mclk = lcdclk / 4;
+		dev_warn(pcdev_to_dev(pcdev),
+			 "Limiting master clock to %lu\n", mclk);
+	}
+
+	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
+	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
+
+	/* If we're not supplying MCLK, leave it at 0 */
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		pcdev->mclk = lcdclk / (2 * (div + 1));
+
+	dev_dbg(pcdev_to_dev(pcdev), "LCD clock %luHz, target freq %luHz, divisor %u\n",
+		lcdclk, mclk, div);
+
+	return div;
+}
+
+static void recalculate_fifo_timeout(struct pxa_camera_dev *pcdev,
+				     unsigned long pclk)
+{
+	/* We want a timeout > 1 pixel time, not ">=" */
+	u32 ciclk_per_pixel = pcdev->ciclk / pclk + 1;
+
+	__raw_writel(ciclk_per_pixel, pcdev->base + CITOR);
+}
+
+static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
+{
+	u32 cicr4 = 0;
+
+	/* disable all interrupts */
+	__raw_writel(0x3ff, pcdev->base + CICR0);
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
+	__raw_writel(pcdev->mclk_divisor | cicr4, pcdev->base + CICR4);
+
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		/* Initialise the timeout under the assumption pclk = mclk */
+		recalculate_fifo_timeout(pcdev, pcdev->mclk);
+	else
+		/* "Safe default" - 13MHz */
+		recalculate_fifo_timeout(pcdev, 13000000);
+
+	clk_prepare_enable(pcdev->clk);
+}
+
+static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
+{
+	clk_disable_unprepare(pcdev->clk);
+}
+
+static void pxa_camera_eof(unsigned long arg)
+{
+	struct pxa_camera_dev *pcdev = (struct pxa_camera_dev *)arg;
+	unsigned long cifr;
+	struct pxa_buffer *buf;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		"Camera interrupt status 0x%x\n",
+		__raw_readl(pcdev->base + CISR));
+
+	/* Reset the FIFOs */
+	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+	__raw_writel(cifr, pcdev->base + CIFR);
+
+	pcdev->active = list_first_entry(&pcdev->capture,
+					 struct pxa_buffer, queue);
+	buf = pcdev->active;
+	pxa_videobuf_set_actdma(pcdev, buf);
+
+	pxa_dma_start_channels(pcdev);
+}
+
+static irqreturn_t pxa_camera_irq(int irq, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	unsigned long status, cicr0;
+
+	status = __raw_readl(pcdev->base + CISR);
+	dev_dbg(pcdev_to_dev(pcdev),
+		"Camera interrupt status 0x%lx\n", status);
+
+	if (!status)
+		return IRQ_NONE;
+
+	__raw_writel(status, pcdev->base + CISR);
+
+	if (status & CISR_EOF) {
+		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
+		__raw_writel(cicr0, pcdev->base + CICR0);
+		tasklet_schedule(&pcdev->task_eof);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int test_platform_param(struct pxa_camera_dev *pcdev,
+			       unsigned char buswidth, unsigned long *flags)
+{
+	/*
+	 * Platform specified synchronization and pixel clock polarities are
+	 * only a recommendation and are only used during probing. The PXA270
+	 * quick capture interface supports both.
+	 */
+	*flags = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
+		  V4L2_MBUS_MASTER : V4L2_MBUS_SLAVE) |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		V4L2_MBUS_DATA_ACTIVE_HIGH |
+		V4L2_MBUS_PCLK_SAMPLE_RISING |
+		V4L2_MBUS_PCLK_SAMPLE_FALLING;
+
+	/* If requested data width is supported by the platform, use it */
+	if ((1 << (buswidth - 1)) & pcdev->width_flags)
+		return 0;
+
+	return -EINVAL;
+}
+
+static void pxa_camera_setup_cicr(struct pxa_camera_dev *pcdev,
+				  unsigned long flags, __u32 pixfmt)
+{
+	unsigned long dw, bpp;
+	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0, y_skip_top;
+	int ret = sensor_call(pcdev, sensor, g_skip_top_lines, &y_skip_top);
+
+	if (ret < 0)
+		y_skip_top = 0;
+
+	/*
+	 * Datawidth is now guaranteed to be equal to one of the three values.
+	 * We fix bit-per-pixel equal to data-width...
+	 */
+	switch (pcdev->current_fmt->host_fmt->bits_per_sample) {
+	case 10:
+		dw = 4;
+		bpp = 0x40;
+		break;
+	case 9:
+		dw = 3;
+		bpp = 0x20;
+		break;
+	default:
+		/*
+		 * Actually it can only be 8 now,
+		 * default is just to silence compiler warnings
+		 */
+	case 8:
+		dw = 2;
+		bpp = 0;
+	}
+
+	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		cicr4 |= CICR4_PCLK_EN;
+	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
+		cicr4 |= CICR4_MCLK_EN;
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		cicr4 |= CICR4_PCP;
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		cicr4 |= CICR4_HSP;
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		cicr4 |= CICR4_VSP;
+
+	cicr0 = __raw_readl(pcdev->base + CICR0);
+	if (cicr0 & CICR0_ENB)
+		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
+
+	cicr1 = CICR1_PPL_VAL(pcdev->current_pix.width - 1) | bpp | dw;
+
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_YUV422P:
+		pcdev->channels = 3;
+		cicr1 |= CICR1_YCBCR_F;
+		/*
+		 * Normally, pxa bus wants as input UYVY format. We allow all
+		 * reorderings of the YUV422 format, as no processing is done,
+		 * and the YUV stream is just passed through without any
+		 * transformation. Note that UYVY is the only format that
+		 * should be used if pxa framebuffer Overlay2 is used.
+		 */
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+		cicr1 |= CICR1_COLOR_SP_VAL(2);
+		break;
+	case V4L2_PIX_FMT_RGB555:
+		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
+			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
+		break;
+	}
+
+	cicr2 = 0;
+	cicr3 = CICR3_LPF_VAL(pcdev->current_pix.height - 1) |
+		CICR3_BFW_VAL(min((u32)255, y_skip_top));
+	cicr4 |= pcdev->mclk_divisor;
+
+	__raw_writel(cicr1, pcdev->base + CICR1);
+	__raw_writel(cicr2, pcdev->base + CICR2);
+	__raw_writel(cicr3, pcdev->base + CICR3);
+	__raw_writel(cicr4, pcdev->base + CICR4);
+
+	/* CIF interrupts are not used, only DMA */
+	cicr0 = (cicr0 & CICR0_ENB) | (pcdev->platform_flags & PXA_CAMERA_MASTER ?
+		CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP));
+	cicr0 |= CICR0_DMAEN | CICR0_IRQ_MASK;
+	__raw_writel(cicr0, pcdev->base + CICR0);
+}
+
+/*
+ * Videobuf2 section
+ */
+static void pxa_buffer_cleanup(struct pxa_buffer *buf)
+{
+	int i;
+
+	for (i = 0; i < 3 && buf->descs[i]; i++) {
+		dmaengine_desc_free(buf->descs[i]);
+		kfree(buf->sg[i]);
+		buf->descs[i] = NULL;
+		buf->sg[i] = NULL;
+		buf->sg_len[i] = 0;
+		buf->plane_sizes[i] = 0;
+	}
+	buf->nb_planes = 0;
+}
+
+static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
+			   struct pxa_buffer *buf)
+{
+	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	int nb_channels = pcdev->channels;
+	int i, ret = 0;
+	unsigned long size = vb2_plane_size(vb, 0);
+
+	switch (nb_channels) {
+	case 1:
+		buf->plane_sizes[0] = size;
+		break;
+	case 3:
+		buf->plane_sizes[0] = size / 2;
+		buf->plane_sizes[1] = size / 4;
+		buf->plane_sizes[2] = size / 4;
+		break;
+	default:
+		return -EINVAL;
+	};
+	buf->nb_planes = nb_channels;
+
+	ret = sg_split(sgt->sgl, sgt->nents, 0, nb_channels,
+		       buf->plane_sizes, buf->sg, buf->sg_len, GFP_KERNEL);
+	if (ret < 0) {
+		dev_err(pcdev_to_dev(pcdev),
+			"sg_split failed: %d\n", ret);
+		return ret;
+	}
+	for (i = 0; i < nb_channels; i++) {
+		ret = pxa_init_dma_channel(pcdev, buf, i,
+					   buf->sg[i], buf->sg_len[i]);
+		if (ret) {
+			pxa_buffer_cleanup(buf);
+			return ret;
+		}
+	}
+	INIT_LIST_HEAD(&buf->queue);
+
+	return ret;
+}
+
+static void pxac_vb2_cleanup(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p)\n", __func__, vb);
+	pxa_buffer_cleanup(buf);
+}
+
+static void pxac_vb2_queue(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
+		pcdev->active);
+
+	list_add_tail(&buf->queue, &pcdev->capture);
+
+	pxa_dma_add_tail_buf(pcdev, buf);
+}
+
+/*
+ * Please check the DMA prepared buffer structure in :
+ *   Documentation/video4linux/pxa_camera.txt
+ * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
+ * modification while DMA chain is running will work anyway.
+ */
+static int pxac_vb2_prepare(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	int ret = 0;
+
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s (vb=%p) nb_channels=%d size=%lu\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
+
+	WARN_ON(!pcdev->current_fmt);
+
+#ifdef DEBUG
+	/*
+	 * This can be useful if you want to see if we actually fill
+	 * the buffer with something
+	 */
+	for (i = 0; i < vb->num_planes; i++)
+		memset((void *)vb2_plane_vaddr(vb, i),
+		       0xaa, vb2_get_plane_payload(vb, i));
+#endif
+
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
+	buf->inwork = 0;
+	pxa_videobuf_set_actdma(pcdev, buf);
+
+	return ret;
+}
+
+static int pxac_vb2_init(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(nb_channels=%d)\n",
+		__func__, pcdev->channels);
+
+	return pxa_buffer_init(pcdev, buf);
+}
+
+static int pxac_vb2_queue_setup(struct vb2_queue *vq,
+				unsigned int *nbufs,
+				unsigned int *num_planes, unsigned int sizes[],
+				struct device *alloc_devs[])
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+	int size = pcdev->current_pix.sizeimage;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
+		__func__, vq, *nbufs, *num_planes, size);
+	/*
+	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
+	 * format, even if there are 3 planes Y, U and V, we reply there is only
+	 * one plane, containing Y, U and V data, one after the other.
+	 */
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*num_planes = 1;
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		sizes[0] = size;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!*nbufs)
+		*nbufs = 1;
+
+	return 0;
+}
+
+static int pxac_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+
+	dev_dbg(pcdev_to_dev(pcdev), "%s(count=%d) active=%p\n",
+		__func__, count, pcdev->active);
+
+	pcdev->buf_sequence = 0;
+	if (!pcdev->active)
+		pxa_camera_start_capture(pcdev);
+
+	return 0;
+}
+
+static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+	struct pxa_buffer *buf, *tmp;
+
+	dev_dbg(pcdev_to_dev(pcdev), "%s active=%p\n",
+		__func__, pcdev->active);
+	pxa_camera_stop_capture(pcdev);
+
+	list_for_each_entry_safe(buf, tmp, &pcdev->capture, queue)
+		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_ERROR);
+}
+
+static struct vb2_ops pxac_vb2_ops = {
+	.queue_setup		= pxac_vb2_queue_setup,
+	.buf_init		= pxac_vb2_init,
+	.buf_prepare		= pxac_vb2_prepare,
+	.buf_queue		= pxac_vb2_queue,
+	.buf_cleanup		= pxac_vb2_cleanup,
+	.start_streaming	= pxac_vb2_start_streaming,
+	.stop_streaming		= pxac_vb2_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
+{
+	int ret;
+	struct vb2_queue *vq = &pcdev->vb2_vq;
+
+	memset(vq, 0, sizeof(*vq));
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	vq->drv_priv = pcdev;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->buf_struct_size = sizeof(struct pxa_buffer);
+	vq->dev = pcdev->v4l2_dev.dev;
+
+	vq->ops = &pxac_vb2_ops;
+	vq->mem_ops = &vb2_dma_sg_memops;
+	vq->lock = &pcdev->mlock;
+
+	ret = vb2_queue_init(vq);
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
+
+	return ret;
+}
+
+/*
+ * Video ioctls section
+ */
+static int pxa_camera_set_bus_param(struct pxa_camera_dev *pcdev)
+{
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	u32 pixfmt = pcdev->current_fmt->host_fmt->fourcc;
+	unsigned long bus_flags, common_flags;
+	int ret;
+
+	ret = test_platform_param(pcdev,
+				  pcdev->current_fmt->host_fmt->bits_per_sample,
+				  &bus_flags);
+	if (ret < 0)
+		return ret;
+
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  bus_flags);
+		if (!common_flags) {
+			dev_warn(pcdev_to_dev(pcdev),
+				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
+				 cfg.flags, bus_flags);
+			return -EINVAL;
+		}
+	} else if (ret != -ENOIOCTLCMD) {
+		return ret;
+	} else {
+		common_flags = bus_flags;
+	}
+
+	pcdev->channels = 1;
+
+	/* Make choises, based on platform preferences */
+	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
+		if (pcdev->platform_flags & PXA_CAMERA_HSP)
+			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
+	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
+		if (pcdev->platform_flags & PXA_CAMERA_VSP)
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
+	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
+		if (pcdev->platform_flags & PXA_CAMERA_PCP)
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
+		else
+			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
+	}
+
+	cfg.flags = common_flags;
+	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		dev_dbg(pcdev_to_dev(pcdev),
+			"camera s_mbus_config(0x%lx) returned %d\n",
+			common_flags, ret);
+		return ret;
+	}
+
+	pxa_camera_setup_cicr(pcdev, common_flags, pixfmt);
+
+	return 0;
+}
+
+static int pxa_camera_try_bus_param(struct pxa_camera_dev *pcdev,
+				    unsigned char buswidth)
+{
+	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	unsigned long bus_flags, common_flags;
+	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
+
+	if (ret < 0)
+		return ret;
+
+	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
+	if (!ret) {
+		common_flags = soc_mbus_config_compatible(&cfg,
+							  bus_flags);
+		if (!common_flags) {
+			dev_warn(pcdev_to_dev(pcdev),
+				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
+				 cfg.flags, bus_flags);
+			return -EINVAL;
+		}
+	} else if (ret == -ENOIOCTLCMD) {
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static const struct soc_mbus_pixelfmt pxa_camera_formats[] = {
+	{
+		.fourcc			= V4L2_PIX_FMT_YUV422P,
+		.name			= "Planar YUV422 16 bit",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PLANAR_2Y_U_V,
+	},
+};
+
+/* This will be corrected as we get more formats */
+static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
+{
+	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
+}
+
+static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
+				  unsigned int idx,
+				  struct soc_camera_format_xlate *xlate)
+{
+	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
+	int formats = 0, ret;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.index = idx,
+	};
+	const struct soc_mbus_pixelfmt *fmt;
+
+	ret = sensor_call(pcdev, pad, enum_mbus_code, NULL, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
+
+	fmt = soc_mbus_get_fmtdesc(code.code);
+	if (!fmt) {
+		dev_err(pcdev_to_dev(pcdev),
+			"Invalid format code #%u: %d\n", idx, code.code);
+		return 0;
+	}
+
+	/* This also checks support for the requested bits-per-sample */
+	ret = pxa_camera_try_bus_param(pcdev, fmt->bits_per_sample);
+	if (ret < 0)
+		return 0;
+
+	switch (code.code) {
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+		formats++;
+		if (xlate) {
+			xlate->host_fmt	= &pxa_camera_formats[0];
+			xlate->code	= code.code;
+			xlate++;
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s using code %d\n",
+				pxa_camera_formats[0].name, code.code);
+		}
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+		if (xlate)
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s packed\n",
+				fmt->name);
+		break;
+	default:
+		if (!pxa_camera_packing_supported(fmt))
+			return 0;
+		if (xlate)
+			dev_dbg(pcdev_to_dev(pcdev),
+				"Providing format %s in pass-through mode\n",
+				fmt->name);
+	}
+
+	/* Generic pass-through */
+	formats++;
+	if (xlate) {
+		xlate->host_fmt	= fmt;
+		xlate->code	= code.code;
+		xlate++;
+	}
+
+	return formats;
+}
+
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
+{
+	kfree(pcdev->user_formats);
+}
+
+static int pxa_camera_check_frame(u32 width, u32 height)
+{
+	/* limit to pxa hardware capabilities */
+	return height < 32 || height > 2048 || width < 48 || width > 2048 ||
+		(width & 0x01);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int pxac_vidioc_g_register(struct file *file, void *priv,
+				  struct v4l2_dbg_register *reg)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(file);
+
+	if (reg->reg > CIBR2)
+		return -ERANGE;
+
+	reg->val = __raw_readl(pcdev->base + reg->reg);
+	reg->size = sizeof(__u32);
+	return 0;
+}
+
+static int pxac_vidioc_s_register(struct file *file, void *priv,
+				  const struct v4l2_dbg_register *reg)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(file);
+
+	if (reg->reg > CIBR2)
+		return -ERANGE;
+	if (reg->size != sizeof(__u32))
+		return -EINVAL;
+	__raw_writel(reg->val, pcdev->base + reg->reg);
+	return 0;
+}
+#endif
+
+static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_mbus_pixelfmt *format;
+	unsigned int idx;
+
+	for (idx = 0; pcdev->user_formats[idx].code; idx++);
+	if (f->index >= idx)
+		return -EINVAL;
+
+	format = pcdev->user_formats[f->index].host_fmt;
+	f->pixelformat = format->fourcc;
+	return 0;
+}
+
+static int pxac_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
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
+}
+
+static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
+				      struct v4l2_format *f)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(filp);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
+	__u32 pixfmt = pix->pixelformat;
+	int ret;
+
+	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
+	if (!xlate) {
+		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
+		return -EINVAL;
+	}
+
+	/*
+	 * Limit to pxa hardware capabilities.  YUV422P planar format requires
+	 * images size to be a multiple of 16 bytes.  If not, zeros will be
+	 * inserted between Y and U planes, and U and V planes, which violates
+	 * the YUV422P standard.
+	 */
+	v4l_bound_align_image(&pix->width, 48, 2048, 1,
+			      &pix->height, 32, 2048, 0,
+			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
+
+	v4l2_fill_mbus_format(mf, pix, xlate->code);
+	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
+	if (ret < 0)
+		return ret;
+
+	v4l2_fill_pix_format(pix, mf);
+
+	/* Only progressive video supported so far */
+	switch (mf->field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		pix->field = V4L2_FIELD_NONE;
+		break;
+	default:
+		/* TODO: support interlaced at least in pass-through mode */
+		dev_err(pcdev_to_dev(pcdev), "Field type %d unsupported.\n",
+			mf->field);
+		return -EINVAL;
+	}
+
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
+}
+
+static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
+				    struct v4l2_format *f)
+{
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
+
+	ret = pxa_camera_set_bus_param(pcdev);
+	return ret;
+}
+
+static int pxac_vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
+	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
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
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register		= pxac_vidioc_g_register,
+	.vidioc_s_register		= pxac_vidioc_s_register,
+#endif
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
+/*
+ * Driver probe, remove, suspend and resume operations
+ */
+static int pxa_camera_suspend(struct device *dev)
+{
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
+	int i = 0, ret = 0;
+
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR1);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR2);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
+	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
+
+	if (pcdev->sensor) {
+		ret = sensor_call(pcdev, core, s_power, 0);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+	}
+
+	return ret;
+}
+
+static int pxa_camera_resume(struct device *dev)
+{
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
+	int i = 0, ret = 0;
+
+	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
+	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
+
+	if (pcdev->sensor) {
+		ret = sensor_call(pcdev, core, s_power, 1);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+	}
+
+	/* Restart frame capture if active buffer exists */
+	if (!ret && pcdev->active)
+		pxa_camera_start_capture(pcdev);
+
+	return ret;
+}
+
+static int pxa_camera_pdata_from_dt(struct device *dev,
+				    struct pxa_camera_dev *pcdev,
+				    struct v4l2_async_subdev *asd)
+{
+	u32 mclk_rate;
+	struct device_node *remote, *np = dev->of_node;
+	struct v4l2_of_endpoint ep;
+	int err = of_property_read_u32(np, "clock-frequency",
+				       &mclk_rate);
+	if (!err) {
+		pcdev->platform_flags |= PXA_CAMERA_MCLK_EN;
+		pcdev->mclk = mclk_rate;
+	}
+
+	np = of_graph_get_next_endpoint(np, NULL);
+	if (!np) {
+		dev_err(dev, "could not find endpoint\n");
+		return -EINVAL;
+	}
+
+	err = v4l2_of_parse_endpoint(np, &ep);
+	if (err) {
+		dev_err(dev, "could not parse endpoint\n");
+		goto out;
+	}
+
+	switch (ep.bus.parallel.bus_width) {
+	case 4:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_4;
+		break;
+	case 5:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_5;
+		break;
+	case 8:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_8;
+		break;
+	case 9:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_9;
+		break;
+	case 10:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
+		break;
+	default:
+		break;
+	}
+
+	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
+		pcdev->platform_flags |= PXA_CAMERA_MASTER;
+	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		pcdev->platform_flags |= PXA_CAMERA_HSP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		pcdev->platform_flags |= PXA_CAMERA_VSP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN | PXA_CAMERA_PCP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
+
+	asd->match_type = V4L2_ASYNC_MATCH_OF;
+	remote = of_graph_get_remote_port(np);
+	if (remote) {
+		asd->match.of.node = remote;
+		of_node_put(remote);
+	} else {
+		dev_notice(dev, "no remote for %s\n", of_node_full_name(np));
+	}
+
+out:
+	of_node_put(np);
+
+	return err;
+}
+
+static int pxa_camera_probe(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev;
+	struct resource *res;
+	void __iomem *base;
+	struct dma_slave_config config = {
+		.src_addr_width = 0,
+		.src_maxburst = 8,
+		.direction = DMA_DEV_TO_MEM,
+	};
+	dma_cap_mask_t mask;
+	struct pxad_param params;
+	char clk_name[V4L2_CLK_NAME_SIZE];
+	int irq;
+	int err = 0, i;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!res || irq < 0)
+		return -ENODEV;
+
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
+	if (!pcdev) {
+		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+		return -ENOMEM;
+	}
+
+	pcdev->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pcdev->clk))
+		return PTR_ERR(pcdev->clk);
+
+	pcdev->res = res;
+
+	pcdev->pdata = pdev->dev.platform_data;
+	if (&pdev->dev.of_node && !pcdev->pdata) {
+		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
+	} else {
+		pcdev->platform_flags = pcdev->pdata->flags;
+		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
+		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
+		pcdev->asd.match.i2c.adapter_id =
+			pcdev->pdata->sensor_i2c_adapter_id;
+		pcdev->asd.match.i2c.address = pcdev->pdata->sensor_i2c_address;
+	}
+	if (err < 0)
+		return err;
+
+	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
+			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
+		/*
+		 * Platform hasn't set available data widths. This is bad.
+		 * Warn and use a default.
+		 */
+		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
+			 "data widths, using default 10 bit\n");
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
+	}
+	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
+		pcdev->width_flags = 1 << 7;
+	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
+		pcdev->width_flags |= 1 << 8;
+	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
+		pcdev->width_flags |= 1 << 9;
+	if (!pcdev->mclk) {
+		dev_warn(&pdev->dev,
+			 "mclk == 0! Please, fix your platform data. "
+			 "Using default 20MHz\n");
+		pcdev->mclk = 20000000;
+	}
+
+	pcdev->mclk_divisor = mclk_get_divisor(pdev, pcdev);
+
+	INIT_LIST_HEAD(&pcdev->capture);
+	spin_lock_init(&pcdev->lock);
+	mutex_init(&pcdev->mlock);
+
+	/*
+	 * Request the regions.
+	 */
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	pcdev->irq = irq;
+	pcdev->base = base;
+
+	/* request dma */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+
+	params.prio = 0;
+	params.drcmr = 68;
+	pcdev->dma_chans[0] =
+		dma_request_slave_channel_compat(mask, pxad_filter_fn,
+						 &params, &pdev->dev, "CI_Y");
+	if (!pcdev->dma_chans[0]) {
+		dev_err(&pdev->dev, "Can't request DMA for Y\n");
+		return -ENODEV;
+	}
+
+	params.drcmr = 69;
+	pcdev->dma_chans[1] =
+		dma_request_slave_channel_compat(mask, pxad_filter_fn,
+						 &params, &pdev->dev, "CI_U");
+	if (!pcdev->dma_chans[1]) {
+		dev_err(&pdev->dev, "Can't request DMA for Y\n");
+		goto exit_free_dma_y;
+	}
+
+	params.drcmr = 70;
+	pcdev->dma_chans[2] =
+		dma_request_slave_channel_compat(mask, pxad_filter_fn,
+						 &params, &pdev->dev, "CI_V");
+	if (!pcdev->dma_chans[2]) {
+		dev_err(&pdev->dev, "Can't request DMA for V\n");
+		goto exit_free_dma_u;
+	}
+
+	for (i = 0; i < 3; i++) {
+		config.src_addr = pcdev->res->start + CIBR0 + i * 8;
+		err = dmaengine_slave_config(pcdev->dma_chans[i], &config);
+		if (err < 0) {
+			dev_err(&pdev->dev, "dma slave config failed: %d\n",
+				err);
+			goto exit_free_dma;
+		}
+	}
+
+	/* request irq */
+	err = devm_request_irq(&pdev->dev, pcdev->irq, pxa_camera_irq, 0,
+			       PXA_CAM_DRV_NAME, pcdev);
+	if (err) {
+		dev_err(&pdev->dev, "Camera interrupt register failed\n");
+		goto exit_free_dma;
+	}
+
+	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
+
+	pxa_camera_activate(pcdev);
+
+	dev_set_drvdata(&pdev->dev, pcdev);
+	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
+	if (err)
+		goto exit_free_dma;
+
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
+
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
+exit_free_dma:
+	dma_release_channel(pcdev->dma_chans[2]);
+exit_free_dma_u:
+	dma_release_channel(pcdev->dma_chans[1]);
+exit_free_dma_y:
+	dma_release_channel(pcdev->dma_chans[0]);
+	return err;
+}
+
+static int pxa_camera_remove(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev = dev_get_drvdata(&pdev->dev);
+
+	pxa_camera_deactivate(pcdev);
+	dma_release_channel(pcdev->dma_chans[0]);
+	dma_release_channel(pcdev->dma_chans[1]);
+	dma_release_channel(pcdev->dma_chans[2]);
+
+	v4l2_clk_unregister(pcdev->mclk_clk);
+	v4l2_device_unregister(&pcdev->v4l2_dev);
+
+	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
+
+	return 0;
+}
+
+static const struct dev_pm_ops pxa_camera_pm = {
+	.suspend	= pxa_camera_suspend,
+	.resume		= pxa_camera_resume,
+};
+
+static const struct of_device_id pxa_camera_of_match[] = {
+	{ .compatible = "marvell,pxa270-qci", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pxa_camera_of_match);
+
+static struct platform_driver pxa_camera_driver = {
+	.driver		= {
+		.name	= PXA_CAM_DRV_NAME,
+		.pm	= &pxa_camera_pm,
+		.of_match_table = of_match_ptr(pxa_camera_of_match),
+	},
+	.probe		= pxa_camera_probe,
+	.remove		= pxa_camera_remove,
+};
+
+module_platform_driver(pxa_camera_driver);
+
+MODULE_DESCRIPTION("PXA27x SoC Camera Host driver");
+MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(PXA_CAM_VERSION);
+MODULE_ALIAS("platform:" PXA_CAM_DRV_NAME);
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 0bf33ccf9a1e..ede2b5e2f3b2 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -17,14 +17,6 @@ config SOC_CAMERA_PLATFORM
 	help
 	  This is a generic SoC camera platform driver, useful for testing
 
-config VIDEO_PXA27x
-	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && HAS_DMA
-	select VIDEOBUF2_DMA_SG
-	select SG_SPLIT
-	---help---
-	  This is a v4l2 driver for the PXA27x Quick Capture Interface
-
 config VIDEO_RCAR_VIN_OLD
 	tristate "R-Car Video Input (VIN) support (DEPRECATED)"
 	depends on VIDEO_DEV && SOC_CAMERA
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index 7703cb7ce456..0109a65a2775 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 
 # soc-camera host drivers have to be linked after camera drivers
 obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
-obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_RCAR_VIN_OLD)	+= rcar_vin.o
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
deleted file mode 100644
index 868c6ad4784c..000000000000
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ /dev/null
@@ -1,2096 +0,0 @@
-/*
- * V4L2 Driver for PXA camera host
- *
- * Copyright (C) 2006, Sascha Hauer, Pengutronix
- * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- * Copyright (C) 2016, Robert Jarzmik <robert.jarzmik@free.fr>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/dma-mapping.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/moduleparam.h>
-#include <linux/of.h>
-#include <linux/time.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/dmaengine.h>
-#include <linux/dma-mapping.h>
-#include <linux/dma/pxa-dma.h>
-
-#include <media/v4l2-async.h>
-#include <media/v4l2-clk.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-of.h>
-
-#include <media/drv-intf/soc_mediabus.h>
-#include <media/videobuf2-dma-sg.h>
-
-#include <linux/videodev2.h>
-
-#include <linux/platform_data/media/camera-pxa.h>
-
-#define PXA_CAM_VERSION "0.0.6"
-#define PXA_CAM_DRV_NAME "pxa27x-camera"
-
-#define DEFAULT_WIDTH	640
-#define DEFAULT_HEIGHT	480
-
-/* Camera Interface */
-#define CICR0		0x0000
-#define CICR1		0x0004
-#define CICR2		0x0008
-#define CICR3		0x000C
-#define CICR4		0x0010
-#define CISR		0x0014
-#define CIFR		0x0018
-#define CITOR		0x001C
-#define CIBR0		0x0028
-#define CIBR1		0x0030
-#define CIBR2		0x0038
-
-#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
-#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
-#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
-#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
-#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
-#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
-#define CICR0_TOM	(1 << 9)	/* Time-out mask */
-#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
-#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
-#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
-#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
-#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
-#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
-#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
-#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
-#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
-
-#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
-#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
-#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
-#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
-#define CICR1_RGB_F	(1 << 11)	/* RGB format */
-#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
-#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
-#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
-#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
-#define CICR1_DW	(0x7 << 0)	/* Data width mask */
-
-#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
-					   wait count mask */
-#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
-					   wait count mask */
-#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
-#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
-					   wait count mask */
-#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
-					   wait count mask */
-
-#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
-					   wait count mask */
-#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
-					   wait count mask */
-#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
-#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
-					   wait count mask */
-#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
-
-#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
-#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
-#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
-#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
-#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
-#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
-#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
-#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
-
-#define CISR_FTO	(1 << 15)	/* FIFO time-out */
-#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
-#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
-#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
-#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
-#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
-#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
-#define CISR_EOL	(1 << 8)	/* End of line */
-#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
-#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
-#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
-#define CISR_SOF	(1 << 4)	/* Start of frame */
-#define CISR_EOF	(1 << 3)	/* End of frame */
-#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
-#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
-#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
-
-#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
-#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
-#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
-#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
-#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
-#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
-#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
-#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
-
-#define CICR0_SIM_MP	(0 << 24)
-#define CICR0_SIM_SP	(1 << 24)
-#define CICR0_SIM_MS	(2 << 24)
-#define CICR0_SIM_EP	(3 << 24)
-#define CICR0_SIM_ES	(4 << 24)
-
-#define CICR1_DW_VAL(x)   ((x) & CICR1_DW)	    /* Data bus width */
-#define CICR1_PPL_VAL(x)  (((x) << 15) & CICR1_PPL) /* Pixels per line */
-#define CICR1_COLOR_SP_VAL(x)	(((x) << 3) & CICR1_COLOR_SP)	/* color space */
-#define CICR1_RGB_BPP_VAL(x)	(((x) << 7) & CICR1_RGB_BPP)	/* bpp for rgb */
-#define CICR1_RGBT_CONV_VAL(x)	(((x) << 29) & CICR1_RGBT_CONV)	/* rgbt conv */
-
-#define CICR2_BLW_VAL(x)  (((x) << 24) & CICR2_BLW) /* Beginning-of-line pixel clock wait count */
-#define CICR2_ELW_VAL(x)  (((x) << 16) & CICR2_ELW) /* End-of-line pixel clock wait count */
-#define CICR2_HSW_VAL(x)  (((x) << 10) & CICR2_HSW) /* Horizontal sync pulse width */
-#define CICR2_BFPW_VAL(x) (((x) << 3) & CICR2_BFPW) /* Beginning-of-frame pixel clock wait count */
-#define CICR2_FSW_VAL(x)  (((x) << 0) & CICR2_FSW)  /* Frame stabilization wait count */
-
-#define CICR3_BFW_VAL(x)  (((x) << 24) & CICR3_BFW) /* Beginning-of-frame line clock wait count  */
-#define CICR3_EFW_VAL(x)  (((x) << 16) & CICR3_EFW) /* End-of-frame line clock wait count */
-#define CICR3_VSW_VAL(x)  (((x) << 11) & CICR3_VSW) /* Vertical sync pulse width */
-#define CICR3_LPF_VAL(x)  (((x) << 0) & CICR3_LPF)  /* Lines per frame */
-
-#define CICR0_IRQ_MASK (CICR0_TOM | CICR0_RDAVM | CICR0_FEM | CICR0_EOLM | \
-			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
-			CICR0_EOFM | CICR0_FOM)
-
-#define sensor_call(cam, o, f, args...) \
-	v4l2_subdev_call(cam->sensor, o, f, ##args)
-
-/*
- * Format handling
- */
-/**
- * struct soc_camera_format_xlate - match between host and sensor formats
- * @code: code of a sensor provided format
- * @host_fmt: host format after host translation from code
- *
- * Host and sensor translation structure. Used in table of host and sensor
- * formats matchings in soc_camera_device. A host can override the generic list
- * generation by implementing get_formats(), and use it for format checks and
- * format setup.
- */
-struct soc_camera_format_xlate {
-	u32 code;
-	const struct soc_mbus_pixelfmt *host_fmt;
-};
-
-/*
- * Structures
- */
-enum pxa_camera_active_dma {
-	DMA_Y = 0x1,
-	DMA_U = 0x2,
-	DMA_V = 0x4,
-};
-
-/* buffer for one video frame */
-struct pxa_buffer {
-	/* common v4l buffer stuff -- must be first */
-	struct vb2_v4l2_buffer		vbuf;
-	struct list_head		queue;
-	u32	code;
-	int				nb_planes;
-	/* our descriptor lists for Y, U and V channels */
-	struct dma_async_tx_descriptor	*descs[3];
-	dma_cookie_t			cookie[3];
-	struct scatterlist		*sg[3];
-	int				sg_len[3];
-	size_t				plane_sizes[3];
-	int				inwork;
-	enum pxa_camera_active_dma	active_dma;
-};
-
-struct pxa_camera_dev {
-	struct v4l2_device	v4l2_dev;
-	struct video_device	vdev;
-	struct v4l2_async_notifier notifier;
-	struct vb2_queue	vb2_vq;
-	struct v4l2_subdev	*sensor;
-	struct soc_camera_format_xlate *user_formats;
-	const struct soc_camera_format_xlate *current_fmt;
-	struct v4l2_pix_format	current_pix;
-
-	struct v4l2_async_subdev asd;
-	struct v4l2_async_subdev *asds[1];
-
-	/*
-	 * PXA27x is only supposed to handle one camera on its Quick Capture
-	 * interface. If anyone ever builds hardware to enable more than
-	 * one camera, they will have to modify this driver too
-	 */
-	struct clk		*clk;
-
-	unsigned int		irq;
-	void __iomem		*base;
-
-	int			channels;
-	struct dma_chan		*dma_chans[3];
-
-	struct pxacamera_platform_data *pdata;
-	struct resource		*res;
-	unsigned long		platform_flags;
-	unsigned long		ciclk;
-	unsigned long		mclk;
-	u32			mclk_divisor;
-	struct v4l2_clk		*mclk_clk;
-	u16			width_flags;	/* max 10 bits */
-
-	struct list_head	capture;
-
-	spinlock_t		lock;
-	struct mutex		mlock;
-	unsigned int		buf_sequence;
-
-	struct pxa_buffer	*active;
-	struct tasklet_struct	task_eof;
-
-	u32			save_cicr[5];
-};
-
-struct pxa_cam {
-	unsigned long flags;
-};
-
-static const char *pxa_cam_driver_description = "PXA_Camera";
-
-/*
- * Format translation functions
- */
-const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
-	struct soc_camera_format_xlate *user_formats, unsigned int fourcc)
-{
-	unsigned int i;
-
-	for (i = 0; user_formats[i].code; i++)
-		if (user_formats[i].host_fmt->fourcc == fourcc)
-			return user_formats + i;
-	return NULL;
-}
-
-static struct soc_camera_format_xlate *soc_mbus_build_fmts_xlate(
-	struct v4l2_device *v4l2_dev, struct v4l2_subdev *subdev,
-	int (*get_formats)(struct v4l2_device *, unsigned int,
-			   struct soc_camera_format_xlate *xlate))
-{
-	unsigned int i, fmts = 0, raw_fmts = 0;
-	int ret;
-	struct v4l2_subdev_mbus_code_enum code = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct soc_camera_format_xlate *user_formats;
-
-	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
-		raw_fmts++;
-		code.index++;
-	}
-
-	/*
-	 * First pass - only count formats this host-sensor
-	 * configuration can provide
-	 */
-	for (i = 0; i < raw_fmts; i++) {
-		ret = get_formats(v4l2_dev, i, NULL);
-		if (ret < 0)
-			return ERR_PTR(ret);
-		fmts += ret;
-	}
-
-	if (!fmts)
-		return ERR_PTR(-ENXIO);
-
-	user_formats = kcalloc(fmts + 1, sizeof(*user_formats), GFP_KERNEL);
-	if (!user_formats)
-		return ERR_PTR(-ENOMEM);
-
-	/* Second pass - actually fill data formats */
-	fmts = 0;
-	for (i = 0; i < raw_fmts; i++) {
-		ret = get_formats(v4l2_dev, i, user_formats + fmts);
-		if (ret < 0)
-			goto egfmt;
-		fmts += ret;
-	}
-	user_formats[fmts].code = 0;
-
-	return user_formats;
-egfmt:
-	kfree(user_formats);
-	return ERR_PTR(ret);
-}
-
-/*
- *  Videobuf operations
- */
-static struct pxa_buffer *vb2_to_pxa_buffer(struct vb2_buffer *vb)
-{
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-
-	return container_of(vbuf, struct pxa_buffer, vbuf);
-}
-
-static struct device *pcdev_to_dev(struct pxa_camera_dev *pcdev)
-{
-	return pcdev->v4l2_dev.dev;
-}
-
-static struct pxa_camera_dev *v4l2_dev_to_pcdev(struct v4l2_device *v4l2_dev)
-{
-	return container_of(v4l2_dev, struct pxa_camera_dev, v4l2_dev);
-}
-
-static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
-			       enum pxa_camera_active_dma act_dma);
-
-static void pxa_camera_dma_irq_y(void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-
-	pxa_camera_dma_irq(pcdev, DMA_Y);
-}
-
-static void pxa_camera_dma_irq_u(void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-
-	pxa_camera_dma_irq(pcdev, DMA_U);
-}
-
-static void pxa_camera_dma_irq_v(void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-
-	pxa_camera_dma_irq(pcdev, DMA_V);
-}
-
-/**
- * pxa_init_dma_channel - init dma descriptors
- * @pcdev: pxa camera device
- * @vb: videobuffer2 buffer
- * @dma: dma video buffer
- * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
- * @cibr: camera Receive Buffer Register
- *
- * Prepares the pxa dma descriptors to transfer one camera channel.
- *
- * Returns 0 if success or -ENOMEM if no memory is available
- */
-static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
-				struct pxa_buffer *buf, int channel,
-				struct scatterlist *sg, int sglen)
-{
-	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
-	struct dma_async_tx_descriptor *tx;
-
-	tx = dmaengine_prep_slave_sg(dma_chan, sg, sglen, DMA_DEV_TO_MEM,
-				     DMA_PREP_INTERRUPT | DMA_CTRL_REUSE);
-	if (!tx) {
-		dev_err(pcdev_to_dev(pcdev),
-			"dmaengine_prep_slave_sg failed\n");
-		goto fail;
-	}
-
-	tx->callback_param = pcdev;
-	switch (channel) {
-	case 0:
-		tx->callback = pxa_camera_dma_irq_y;
-		break;
-	case 1:
-		tx->callback = pxa_camera_dma_irq_u;
-		break;
-	case 2:
-		tx->callback = pxa_camera_dma_irq_v;
-		break;
-	}
-
-	buf->descs[channel] = tx;
-	return 0;
-fail:
-	dev_dbg(pcdev_to_dev(pcdev),
-		"%s (vb=%p) dma_tx=%p\n",
-		__func__, buf, tx);
-
-	return -ENOMEM;
-}
-
-static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
-				    struct pxa_buffer *buf)
-{
-	buf->active_dma = DMA_Y;
-	if (buf->nb_planes == 3)
-		buf->active_dma |= DMA_U | DMA_V;
-}
-
-/**
- * pxa_dma_start_channels - start DMA channel for active buffer
- * @pcdev: pxa camera device
- *
- * Initialize DMA channels to the beginning of the active video buffer, and
- * start these channels.
- */
-static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
-{
-	int i;
-	struct pxa_buffer *active;
-
-	active = pcdev->active;
-
-	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev_to_dev(pcdev),
-			"%s (channel=%d)\n", __func__, i);
-		dma_async_issue_pending(pcdev->dma_chans[i]);
-	}
-}
-
-static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
-{
-	int i;
-
-	for (i = 0; i < pcdev->channels; i++) {
-		dev_dbg(pcdev_to_dev(pcdev),
-			"%s (channel=%d)\n", __func__, i);
-		dmaengine_terminate_all(pcdev->dma_chans[i]);
-	}
-}
-
-static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
-				 struct pxa_buffer *buf)
-{
-	int i;
-
-	for (i = 0; i < pcdev->channels; i++) {
-		buf->cookie[i] = dmaengine_submit(buf->descs[i]);
-		dev_dbg(pcdev_to_dev(pcdev),
-			"%s (channel=%d) : submit vb=%p cookie=%d\n",
-			__func__, i, buf, buf->descs[i]->cookie);
-	}
-}
-
-/**
- * pxa_camera_start_capture - start video capturing
- * @pcdev: camera device
- *
- * Launch capturing. DMA channels should not be active yet. They should get
- * activated at the end of frame interrupt, to capture only whole frames, and
- * never begin the capture of a partial frame.
- */
-static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
-{
-	unsigned long cicr0;
-
-	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
-	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
-	/* Enable End-Of-Frame Interrupt */
-	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
-	cicr0 &= ~CICR0_EOFM;
-	__raw_writel(cicr0, pcdev->base + CICR0);
-}
-
-static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
-{
-	unsigned long cicr0;
-
-	pxa_dma_stop_channels(pcdev);
-
-	cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
-	__raw_writel(cicr0, pcdev->base + CICR0);
-
-	pcdev->active = NULL;
-	dev_dbg(pcdev_to_dev(pcdev), "%s\n", __func__);
-}
-
-static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
-			      struct pxa_buffer *buf,
-			      enum vb2_buffer_state state)
-{
-	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-
-	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
-	list_del_init(&buf->queue);
-	vb->timestamp = ktime_get_ns();
-	vbuf->sequence = pcdev->buf_sequence++;
-	vbuf->field = V4L2_FIELD_NONE;
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
-	dev_dbg(pcdev_to_dev(pcdev), "%s dequeud buffer (buf=0x%p)\n",
-		__func__, buf);
-
-	if (list_empty(&pcdev->capture)) {
-		pxa_camera_stop_capture(pcdev);
-		return;
-	}
-
-	pcdev->active = list_entry(pcdev->capture.next,
-				   struct pxa_buffer, queue);
-}
-
-/**
- * pxa_camera_check_link_miss - check missed DMA linking
- * @pcdev: camera device
- *
- * The DMA chaining is done with DMA running. This means a tiny temporal window
- * remains, where a buffer is queued on the chain, while the chain is already
- * stopped. This means the tailed buffer would never be transferred by DMA.
- * This function restarts the capture for this corner case, where :
- *  - DADR() == DADDR_STOP
- *  - a videobuffer is queued on the pcdev->capture list
- *
- * Please check the "DMA hot chaining timeslice issue" in
- *   Documentation/video4linux/pxa_camera.txt
- *
- * Context: should only be called within the dma irq handler
- */
-static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
-				       dma_cookie_t last_submitted,
-				       dma_cookie_t last_issued)
-{
-	bool is_dma_stopped = last_submitted != last_issued;
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		"%s : top queued buffer=%p, is_dma_stopped=%d\n",
-		__func__, pcdev->active, is_dma_stopped);
-
-	if (pcdev->active && is_dma_stopped)
-		pxa_camera_start_capture(pcdev);
-}
-
-static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
-			       enum pxa_camera_active_dma act_dma)
-{
-	struct pxa_buffer *buf, *last_buf;
-	unsigned long flags;
-	u32 camera_status, overrun;
-	int chan;
-	enum dma_status last_status;
-	dma_cookie_t last_issued;
-
-	spin_lock_irqsave(&pcdev->lock, flags);
-
-	camera_status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(pcdev_to_dev(pcdev), "camera dma irq, cisr=0x%x dma=%d\n",
-		camera_status, act_dma);
-	overrun = CISR_IFO_0;
-	if (pcdev->channels == 3)
-		overrun |= CISR_IFO_1 | CISR_IFO_2;
-
-	/*
-	 * pcdev->active should not be NULL in DMA irq handler.
-	 *
-	 * But there is one corner case : if capture was stopped due to an
-	 * overrun of channel 1, and at that same channel 2 was completed.
-	 *
-	 * When handling the overrun in DMA irq for channel 1, we'll stop the
-	 * capture and restart it (and thus set pcdev->active to NULL). But the
-	 * DMA irq handler will already be pending for channel 2. So on entering
-	 * the DMA irq handler for channel 2 there will be no active buffer, yet
-	 * that is normal.
-	 */
-	if (!pcdev->active)
-		goto out;
-
-	buf = pcdev->active;
-	WARN_ON(buf->inwork || list_empty(&buf->queue));
-
-	/*
-	 * It's normal if the last frame creates an overrun, as there
-	 * are no more DMA descriptors to fetch from QCI fifos
-	 */
-	switch (act_dma) {
-	case DMA_U:
-		chan = 1;
-		break;
-	case DMA_V:
-		chan = 2;
-		break;
-	default:
-		chan = 0;
-		break;
-	}
-	last_buf = list_entry(pcdev->capture.prev,
-			      struct pxa_buffer, queue);
-	last_status = dma_async_is_tx_complete(pcdev->dma_chans[chan],
-					       last_buf->cookie[chan],
-					       NULL, &last_issued);
-	if (camera_status & overrun &&
-	    last_status != DMA_COMPLETE) {
-		dev_dbg(pcdev_to_dev(pcdev), "FIFO overrun! CISR: %x\n",
-			camera_status);
-		pxa_camera_stop_capture(pcdev);
-		list_for_each_entry(buf, &pcdev->capture, queue)
-			pxa_dma_add_tail_buf(pcdev, buf);
-		pxa_camera_start_capture(pcdev);
-		goto out;
-	}
-	buf->active_dma &= ~act_dma;
-	if (!buf->active_dma) {
-		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_DONE);
-		pxa_camera_check_link_miss(pcdev, last_buf->cookie[chan],
-					   last_issued);
-	}
-
-out:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
-}
-
-static u32 mclk_get_divisor(struct platform_device *pdev,
-			    struct pxa_camera_dev *pcdev)
-{
-	unsigned long mclk = pcdev->mclk;
-	u32 div;
-	unsigned long lcdclk;
-
-	lcdclk = clk_get_rate(pcdev->clk);
-	pcdev->ciclk = lcdclk;
-
-	/* mclk <= ciclk / 4 (27.4.2) */
-	if (mclk > lcdclk / 4) {
-		mclk = lcdclk / 4;
-		dev_warn(pcdev_to_dev(pcdev),
-			 "Limiting master clock to %lu\n", mclk);
-	}
-
-	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
-	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
-
-	/* If we're not supplying MCLK, leave it at 0 */
-	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
-		pcdev->mclk = lcdclk / (2 * (div + 1));
-
-	dev_dbg(pcdev_to_dev(pcdev), "LCD clock %luHz, target freq %luHz, divisor %u\n",
-		lcdclk, mclk, div);
-
-	return div;
-}
-
-static void recalculate_fifo_timeout(struct pxa_camera_dev *pcdev,
-				     unsigned long pclk)
-{
-	/* We want a timeout > 1 pixel time, not ">=" */
-	u32 ciclk_per_pixel = pcdev->ciclk / pclk + 1;
-
-	__raw_writel(ciclk_per_pixel, pcdev->base + CITOR);
-}
-
-static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
-{
-	u32 cicr4 = 0;
-
-	/* disable all interrupts */
-	__raw_writel(0x3ff, pcdev->base + CICR0);
-
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		cicr4 |= CICR4_PCLK_EN;
-	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
-		cicr4 |= CICR4_MCLK_EN;
-	if (pcdev->platform_flags & PXA_CAMERA_PCP)
-		cicr4 |= CICR4_PCP;
-	if (pcdev->platform_flags & PXA_CAMERA_HSP)
-		cicr4 |= CICR4_HSP;
-	if (pcdev->platform_flags & PXA_CAMERA_VSP)
-		cicr4 |= CICR4_VSP;
-
-	__raw_writel(pcdev->mclk_divisor | cicr4, pcdev->base + CICR4);
-
-	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
-		/* Initialise the timeout under the assumption pclk = mclk */
-		recalculate_fifo_timeout(pcdev, pcdev->mclk);
-	else
-		/* "Safe default" - 13MHz */
-		recalculate_fifo_timeout(pcdev, 13000000);
-
-	clk_prepare_enable(pcdev->clk);
-}
-
-static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
-{
-	clk_disable_unprepare(pcdev->clk);
-}
-
-static void pxa_camera_eof(unsigned long arg)
-{
-	struct pxa_camera_dev *pcdev = (struct pxa_camera_dev *)arg;
-	unsigned long cifr;
-	struct pxa_buffer *buf;
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		"Camera interrupt status 0x%x\n",
-		__raw_readl(pcdev->base + CISR));
-
-	/* Reset the FIFOs */
-	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-	__raw_writel(cifr, pcdev->base + CIFR);
-
-	pcdev->active = list_first_entry(&pcdev->capture,
-					 struct pxa_buffer, queue);
-	buf = pcdev->active;
-	pxa_videobuf_set_actdma(pcdev, buf);
-
-	pxa_dma_start_channels(pcdev);
-}
-
-static irqreturn_t pxa_camera_irq(int irq, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	unsigned long status, cicr0;
-
-	status = __raw_readl(pcdev->base + CISR);
-	dev_dbg(pcdev_to_dev(pcdev),
-		"Camera interrupt status 0x%lx\n", status);
-
-	if (!status)
-		return IRQ_NONE;
-
-	__raw_writel(status, pcdev->base + CISR);
-
-	if (status & CISR_EOF) {
-		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
-		__raw_writel(cicr0, pcdev->base + CICR0);
-		tasklet_schedule(&pcdev->task_eof);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static int test_platform_param(struct pxa_camera_dev *pcdev,
-			       unsigned char buswidth, unsigned long *flags)
-{
-	/*
-	 * Platform specified synchronization and pixel clock polarities are
-	 * only a recommendation and are only used during probing. The PXA270
-	 * quick capture interface supports both.
-	 */
-	*flags = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
-		  V4L2_MBUS_MASTER : V4L2_MBUS_SLAVE) |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_HSYNC_ACTIVE_LOW |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_VSYNC_ACTIVE_LOW |
-		V4L2_MBUS_DATA_ACTIVE_HIGH |
-		V4L2_MBUS_PCLK_SAMPLE_RISING |
-		V4L2_MBUS_PCLK_SAMPLE_FALLING;
-
-	/* If requested data width is supported by the platform, use it */
-	if ((1 << (buswidth - 1)) & pcdev->width_flags)
-		return 0;
-
-	return -EINVAL;
-}
-
-static void pxa_camera_setup_cicr(struct pxa_camera_dev *pcdev,
-				  unsigned long flags, __u32 pixfmt)
-{
-	unsigned long dw, bpp;
-	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0, y_skip_top;
-	int ret = sensor_call(pcdev, sensor, g_skip_top_lines, &y_skip_top);
-
-	if (ret < 0)
-		y_skip_top = 0;
-
-	/*
-	 * Datawidth is now guaranteed to be equal to one of the three values.
-	 * We fix bit-per-pixel equal to data-width...
-	 */
-	switch (pcdev->current_fmt->host_fmt->bits_per_sample) {
-	case 10:
-		dw = 4;
-		bpp = 0x40;
-		break;
-	case 9:
-		dw = 3;
-		bpp = 0x20;
-		break;
-	default:
-		/*
-		 * Actually it can only be 8 now,
-		 * default is just to silence compiler warnings
-		 */
-	case 8:
-		dw = 2;
-		bpp = 0;
-	}
-
-	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
-		cicr4 |= CICR4_PCLK_EN;
-	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
-		cicr4 |= CICR4_MCLK_EN;
-	if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
-		cicr4 |= CICR4_PCP;
-	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
-		cicr4 |= CICR4_HSP;
-	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-		cicr4 |= CICR4_VSP;
-
-	cicr0 = __raw_readl(pcdev->base + CICR0);
-	if (cicr0 & CICR0_ENB)
-		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
-
-	cicr1 = CICR1_PPL_VAL(pcdev->current_pix.width - 1) | bpp | dw;
-
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_YUV422P:
-		pcdev->channels = 3;
-		cicr1 |= CICR1_YCBCR_F;
-		/*
-		 * Normally, pxa bus wants as input UYVY format. We allow all
-		 * reorderings of the YUV422 format, as no processing is done,
-		 * and the YUV stream is just passed through without any
-		 * transformation. Note that UYVY is the only format that
-		 * should be used if pxa framebuffer Overlay2 is used.
-		 */
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-		cicr1 |= CICR1_COLOR_SP_VAL(2);
-		break;
-	case V4L2_PIX_FMT_RGB555:
-		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
-			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
-		break;
-	case V4L2_PIX_FMT_RGB565:
-		cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
-		break;
-	}
-
-	cicr2 = 0;
-	cicr3 = CICR3_LPF_VAL(pcdev->current_pix.height - 1) |
-		CICR3_BFW_VAL(min((u32)255, y_skip_top));
-	cicr4 |= pcdev->mclk_divisor;
-
-	__raw_writel(cicr1, pcdev->base + CICR1);
-	__raw_writel(cicr2, pcdev->base + CICR2);
-	__raw_writel(cicr3, pcdev->base + CICR3);
-	__raw_writel(cicr4, pcdev->base + CICR4);
-
-	/* CIF interrupts are not used, only DMA */
-	cicr0 = (cicr0 & CICR0_ENB) | (pcdev->platform_flags & PXA_CAMERA_MASTER ?
-		CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP));
-	cicr0 |= CICR0_DMAEN | CICR0_IRQ_MASK;
-	__raw_writel(cicr0, pcdev->base + CICR0);
-}
-
-/*
- * Videobuf2 section
- */
-static void pxa_buffer_cleanup(struct pxa_buffer *buf)
-{
-	int i;
-
-	for (i = 0; i < 3 && buf->descs[i]; i++) {
-		dmaengine_desc_free(buf->descs[i]);
-		kfree(buf->sg[i]);
-		buf->descs[i] = NULL;
-		buf->sg[i] = NULL;
-		buf->sg_len[i] = 0;
-		buf->plane_sizes[i] = 0;
-	}
-	buf->nb_planes = 0;
-}
-
-static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
-			   struct pxa_buffer *buf)
-{
-	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
-	int nb_channels = pcdev->channels;
-	int i, ret = 0;
-	unsigned long size = vb2_plane_size(vb, 0);
-
-	switch (nb_channels) {
-	case 1:
-		buf->plane_sizes[0] = size;
-		break;
-	case 3:
-		buf->plane_sizes[0] = size / 2;
-		buf->plane_sizes[1] = size / 4;
-		buf->plane_sizes[2] = size / 4;
-		break;
-	default:
-		return -EINVAL;
-	};
-	buf->nb_planes = nb_channels;
-
-	ret = sg_split(sgt->sgl, sgt->nents, 0, nb_channels,
-		       buf->plane_sizes, buf->sg, buf->sg_len, GFP_KERNEL);
-	if (ret < 0) {
-		dev_err(pcdev_to_dev(pcdev),
-			"sg_split failed: %d\n", ret);
-		return ret;
-	}
-	for (i = 0; i < nb_channels; i++) {
-		ret = pxa_init_dma_channel(pcdev, buf, i,
-					   buf->sg[i], buf->sg_len[i]);
-		if (ret) {
-			pxa_buffer_cleanup(buf);
-			return ret;
-		}
-	}
-	INIT_LIST_HEAD(&buf->queue);
-
-	return ret;
-}
-
-static void pxac_vb2_cleanup(struct vb2_buffer *vb)
-{
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vb=%p)\n", __func__, vb);
-	pxa_buffer_cleanup(buf);
-}
-
-static void pxac_vb2_queue(struct vb2_buffer *vb)
-{
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
-		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
-		pcdev->active);
-
-	list_add_tail(&buf->queue, &pcdev->capture);
-
-	pxa_dma_add_tail_buf(pcdev, buf);
-}
-
-/*
- * Please check the DMA prepared buffer structure in :
- *   Documentation/video4linux/pxa_camera.txt
- * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
- * modification while DMA chain is running will work anyway.
- */
-static int pxac_vb2_prepare(struct vb2_buffer *vb)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	int ret = 0;
-
-	switch (pcdev->channels) {
-	case 1:
-	case 3:
-		vb2_set_plane_payload(vb, 0, pcdev->current_pix.sizeimage);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s (vb=%p) nb_channels=%d size=%lu\n",
-		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
-
-	WARN_ON(!pcdev->current_fmt);
-
-#ifdef DEBUG
-	/*
-	 * This can be useful if you want to see if we actually fill
-	 * the buffer with something
-	 */
-	for (i = 0; i < vb->num_planes; i++)
-		memset((void *)vb2_plane_vaddr(vb, i),
-		       0xaa, vb2_get_plane_payload(vb, i));
-#endif
-
-	/*
-	 * I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours
-	 */
-	buf->inwork = 0;
-	pxa_videobuf_set_actdma(pcdev, buf);
-
-	return ret;
-}
-
-static int pxac_vb2_init(struct vb2_buffer *vb)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(nb_channels=%d)\n",
-		__func__, pcdev->channels);
-
-	return pxa_buffer_init(pcdev, buf);
-}
-
-static int pxac_vb2_queue_setup(struct vb2_queue *vq,
-				unsigned int *nbufs,
-				unsigned int *num_planes, unsigned int sizes[],
-				struct device *alloc_devs[])
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-	int size = pcdev->current_pix.sizeimage;
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
-		__func__, vq, *nbufs, *num_planes, size);
-	/*
-	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
-	 * format, even if there are 3 planes Y, U and V, we reply there is only
-	 * one plane, containing Y, U and V data, one after the other.
-	 */
-	if (*num_planes)
-		return sizes[0] < size ? -EINVAL : 0;
-
-	*num_planes = 1;
-	switch (pcdev->channels) {
-	case 1:
-	case 3:
-		sizes[0] = size;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (!*nbufs)
-		*nbufs = 1;
-
-	return 0;
-}
-
-static int pxac_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-
-	dev_dbg(pcdev_to_dev(pcdev), "%s(count=%d) active=%p\n",
-		__func__, count, pcdev->active);
-
-	pcdev->buf_sequence = 0;
-	if (!pcdev->active)
-		pxa_camera_start_capture(pcdev);
-
-	return 0;
-}
-
-static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-	struct pxa_buffer *buf, *tmp;
-
-	dev_dbg(pcdev_to_dev(pcdev), "%s active=%p\n",
-		__func__, pcdev->active);
-	pxa_camera_stop_capture(pcdev);
-
-	list_for_each_entry_safe(buf, tmp, &pcdev->capture, queue)
-		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_ERROR);
-}
-
-static struct vb2_ops pxac_vb2_ops = {
-	.queue_setup		= pxac_vb2_queue_setup,
-	.buf_init		= pxac_vb2_init,
-	.buf_prepare		= pxac_vb2_prepare,
-	.buf_queue		= pxac_vb2_queue,
-	.buf_cleanup		= pxac_vb2_cleanup,
-	.start_streaming	= pxac_vb2_start_streaming,
-	.stop_streaming		= pxac_vb2_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
-};
-
-static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
-{
-	int ret;
-	struct vb2_queue *vq = &pcdev->vb2_vq;
-
-	memset(vq, 0, sizeof(*vq));
-	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
-	vq->drv_priv = pcdev;
-	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	vq->buf_struct_size = sizeof(struct pxa_buffer);
-	vq->dev = pcdev->v4l2_dev.dev;
-
-	vq->ops = &pxac_vb2_ops;
-	vq->mem_ops = &vb2_dma_sg_memops;
-	vq->lock = &pcdev->mlock;
-
-	ret = vb2_queue_init(vq);
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
-
-	return ret;
-}
-
-/*
- * Video ioctls section
- */
-static int pxa_camera_set_bus_param(struct pxa_camera_dev *pcdev)
-{
-	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
-	u32 pixfmt = pcdev->current_fmt->host_fmt->fourcc;
-	unsigned long bus_flags, common_flags;
-	int ret;
-
-	ret = test_platform_param(pcdev,
-				  pcdev->current_fmt->host_fmt->bits_per_sample,
-				  &bus_flags);
-	if (ret < 0)
-		return ret;
-
-	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
-	if (!ret) {
-		common_flags = soc_mbus_config_compatible(&cfg,
-							  bus_flags);
-		if (!common_flags) {
-			dev_warn(pcdev_to_dev(pcdev),
-				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
-				 cfg.flags, bus_flags);
-			return -EINVAL;
-		}
-	} else if (ret != -ENOIOCTLCMD) {
-		return ret;
-	} else {
-		common_flags = bus_flags;
-	}
-
-	pcdev->channels = 1;
-
-	/* Make choises, based on platform preferences */
-	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
-		if (pcdev->platform_flags & PXA_CAMERA_HSP)
-			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
-		else
-			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
-	}
-
-	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
-	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
-		if (pcdev->platform_flags & PXA_CAMERA_VSP)
-			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
-		else
-			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
-	}
-
-	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
-	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
-		if (pcdev->platform_flags & PXA_CAMERA_PCP)
-			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
-		else
-			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
-	}
-
-	cfg.flags = common_flags;
-	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		dev_dbg(pcdev_to_dev(pcdev),
-			"camera s_mbus_config(0x%lx) returned %d\n",
-			common_flags, ret);
-		return ret;
-	}
-
-	pxa_camera_setup_cicr(pcdev, common_flags, pixfmt);
-
-	return 0;
-}
-
-static int pxa_camera_try_bus_param(struct pxa_camera_dev *pcdev,
-				    unsigned char buswidth)
-{
-	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
-	unsigned long bus_flags, common_flags;
-	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
-
-	if (ret < 0)
-		return ret;
-
-	ret = sensor_call(pcdev, video, g_mbus_config, &cfg);
-	if (!ret) {
-		common_flags = soc_mbus_config_compatible(&cfg,
-							  bus_flags);
-		if (!common_flags) {
-			dev_warn(pcdev_to_dev(pcdev),
-				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
-				 cfg.flags, bus_flags);
-			return -EINVAL;
-		}
-	} else if (ret == -ENOIOCTLCMD) {
-		ret = 0;
-	}
-
-	return ret;
-}
-
-static const struct soc_mbus_pixelfmt pxa_camera_formats[] = {
-	{
-		.fourcc			= V4L2_PIX_FMT_YUV422P,
-		.name			= "Planar YUV422 16 bit",
-		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
-		.layout			= SOC_MBUS_LAYOUT_PLANAR_2Y_U_V,
-	},
-};
-
-/* This will be corrected as we get more formats */
-static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
-{
-	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
-		(fmt->bits_per_sample == 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
-		(fmt->bits_per_sample > 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
-}
-
-static int pxa_camera_get_formats(struct v4l2_device *v4l2_dev,
-				  unsigned int idx,
-				  struct soc_camera_format_xlate *xlate)
-{
-	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
-	int formats = 0, ret;
-	struct v4l2_subdev_mbus_code_enum code = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.index = idx,
-	};
-	const struct soc_mbus_pixelfmt *fmt;
-
-	ret = sensor_call(pcdev, pad, enum_mbus_code, NULL, &code);
-	if (ret < 0)
-		/* No more formats */
-		return 0;
-
-	fmt = soc_mbus_get_fmtdesc(code.code);
-	if (!fmt) {
-		dev_err(pcdev_to_dev(pcdev),
-			"Invalid format code #%u: %d\n", idx, code.code);
-		return 0;
-	}
-
-	/* This also checks support for the requested bits-per-sample */
-	ret = pxa_camera_try_bus_param(pcdev, fmt->bits_per_sample);
-	if (ret < 0)
-		return 0;
-
-	switch (code.code) {
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		formats++;
-		if (xlate) {
-			xlate->host_fmt	= &pxa_camera_formats[0];
-			xlate->code	= code.code;
-			xlate++;
-			dev_dbg(pcdev_to_dev(pcdev),
-				"Providing format %s using code %d\n",
-				pxa_camera_formats[0].name, code.code);
-		}
-	case MEDIA_BUS_FMT_VYUY8_2X8:
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-	case MEDIA_BUS_FMT_YVYU8_2X8:
-	case MEDIA_BUS_FMT_RGB565_2X8_LE:
-	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
-		if (xlate)
-			dev_dbg(pcdev_to_dev(pcdev),
-				"Providing format %s packed\n",
-				fmt->name);
-		break;
-	default:
-		if (!pxa_camera_packing_supported(fmt))
-			return 0;
-		if (xlate)
-			dev_dbg(pcdev_to_dev(pcdev),
-				"Providing format %s in pass-through mode\n",
-				fmt->name);
-	}
-
-	/* Generic pass-through */
-	formats++;
-	if (xlate) {
-		xlate->host_fmt	= fmt;
-		xlate->code	= code.code;
-		xlate++;
-	}
-
-	return formats;
-}
-
-static int pxa_camera_build_formats(struct pxa_camera_dev *pcdev)
-{
-	struct soc_camera_format_xlate *xlate;
-
-	xlate = soc_mbus_build_fmts_xlate(&pcdev->v4l2_dev, pcdev->sensor,
-					  pxa_camera_get_formats);
-	if (IS_ERR(xlate))
-		return PTR_ERR(xlate);
-
-	pcdev->user_formats = xlate;
-	return 0;
-}
-
-static void pxa_camera_destroy_formats(struct pxa_camera_dev *pcdev)
-{
-	kfree(pcdev->user_formats);
-}
-
-static int pxa_camera_check_frame(u32 width, u32 height)
-{
-	/* limit to pxa hardware capabilities */
-	return height < 32 || height > 2048 || width < 48 || width > 2048 ||
-		(width & 0x01);
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int pxac_vidioc_g_register(struct file *file, void *priv,
-				  struct v4l2_dbg_register *reg)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(file);
-
-	if (reg->reg > CIBR2)
-		return -ERANGE;
-
-	reg->val = __raw_readl(pcdev->base + reg->reg);
-	reg->size = sizeof(__u32);
-	return 0;
-}
-
-static int pxac_vidioc_s_register(struct file *file, void *priv,
-				  const struct v4l2_dbg_register *reg)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(file);
-
-	if (reg->reg > CIBR2)
-		return -ERANGE;
-	if (reg->size != sizeof(__u32))
-		return -EINVAL;
-	__raw_writel(reg->val, pcdev->base + reg->reg);
-	return 0;
-}
-#endif
-
-static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
-					struct v4l2_fmtdesc *f)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	const struct soc_mbus_pixelfmt *format;
-	unsigned int idx;
-
-	for (idx = 0; pcdev->user_formats[idx].code; idx++);
-	if (f->index >= idx)
-		return -EINVAL;
-
-	format = pcdev->user_formats[f->index].host_fmt;
-	f->pixelformat = format->fourcc;
-	return 0;
-}
-
-static int pxac_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
-				    struct v4l2_format *f)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-
-	pix->width		= pcdev->current_pix.width;
-	pix->height		= pcdev->current_pix.height;
-	pix->bytesperline	= pcdev->current_pix.bytesperline;
-	pix->sizeimage		= pcdev->current_pix.sizeimage;
-	pix->field		= pcdev->current_pix.field;
-	pix->pixelformat	= pcdev->current_fmt->host_fmt->fourcc;
-	pix->colorspace		= pcdev->current_pix.colorspace;
-	dev_dbg(pcdev_to_dev(pcdev), "current_fmt->fourcc: 0x%08x\n",
-		pcdev->current_fmt->host_fmt->fourcc);
-	return 0;
-}
-
-static int pxac_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
-				      struct v4l2_format *f)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_pad_config pad_cfg;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_TRY,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-	__u32 pixfmt = pix->pixelformat;
-	int ret;
-
-	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats, pixfmt);
-	if (!xlate) {
-		dev_warn(pcdev_to_dev(pcdev), "Format %x not found\n", pixfmt);
-		return -EINVAL;
-	}
-
-	/*
-	 * Limit to pxa hardware capabilities.  YUV422P planar format requires
-	 * images size to be a multiple of 16 bytes.  If not, zeros will be
-	 * inserted between Y and U planes, and U and V planes, which violates
-	 * the YUV422P standard.
-	 */
-	v4l_bound_align_image(&pix->width, 48, 2048, 1,
-			      &pix->height, 32, 2048, 0,
-			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-
-	v4l2_fill_mbus_format(mf, pix, xlate->code);
-	ret = sensor_call(pcdev, pad, set_fmt, &pad_cfg, &format);
-	if (ret < 0)
-		return ret;
-
-	v4l2_fill_pix_format(pix, mf);
-
-	/* Only progressive video supported so far */
-	switch (mf->field) {
-	case V4L2_FIELD_ANY:
-	case V4L2_FIELD_NONE:
-		pix->field = V4L2_FIELD_NONE;
-		break;
-	default:
-		/* TODO: support interlaced at least in pass-through mode */
-		dev_err(pcdev_to_dev(pcdev), "Field type %d unsupported.\n",
-			mf->field);
-		return -EINVAL;
-	}
-
-	ret = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
-	if (ret < 0)
-		return ret;
-
-	pix->bytesperline = ret;
-	ret = soc_mbus_image_size(xlate->host_fmt, pix->bytesperline,
-				  pix->height);
-	if (ret < 0)
-		return ret;
-
-	pix->sizeimage = ret;
-	return 0;
-}
-
-static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
-				    struct v4l2_format *f)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	unsigned long flags;
-	int ret, is_busy;
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		"s_fmt_vid_cap(pix=%dx%d:%x)\n",
-		pix->width, pix->height, pix->pixelformat);
-
-	spin_lock_irqsave(&pcdev->lock, flags);
-	is_busy = pcdev->active || vb2_is_busy(&pcdev->vb2_vq);
-	spin_unlock_irqrestore(&pcdev->lock, flags);
-
-	if (is_busy)
-		return -EBUSY;
-
-	ret = pxac_vidioc_try_fmt_vid_cap(filp, priv, f);
-	if (ret)
-		return ret;
-
-	xlate = soc_mbus_xlate_by_fourcc(pcdev->user_formats,
-					 pix->pixelformat);
-	v4l2_fill_mbus_format(&format.format, pix, xlate->code);
-	ret = sensor_call(pcdev, pad, set_fmt, NULL, &format);
-	if (ret < 0) {
-		dev_warn(pcdev_to_dev(pcdev),
-			 "Failed to configure for format %x\n",
-			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(pix->width, pix->height)) {
-		dev_warn(pcdev_to_dev(pcdev),
-			 "Camera driver produced an unsupported frame %dx%d\n",
-			 pix->width, pix->height);
-		return -EINVAL;
-	}
-
-	pcdev->current_fmt = xlate;
-	pcdev->current_pix = *pix;
-
-	ret = pxa_camera_set_bus_param(pcdev);
-	return ret;
-}
-
-static int pxac_vidioc_querycap(struct file *file, void *priv,
-				struct v4l2_capability *cap)
-{
-	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
-	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-
-	return 0;
-}
-
-static int pxac_vidioc_enum_input(struct file *file, void *priv,
-				  struct v4l2_input *i)
-{
-	if (i->index > 0)
-		return -EINVAL;
-
-	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(i->name, "Camera", sizeof(i->name));
-
-	return 0;
-}
-
-static int pxac_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
-{
-	*i = 0;
-
-	return 0;
-}
-
-static int pxac_vidioc_s_input(struct file *file, void *priv, unsigned int i)
-{
-	if (i > 0)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int pxac_fops_camera_open(struct file *filp)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	int ret;
-
-	mutex_lock(&pcdev->mlock);
-	ret = v4l2_fh_open(filp);
-	if (ret < 0)
-		goto out;
-
-	ret = sensor_call(pcdev, core, s_power, 1);
-	if (ret)
-		v4l2_fh_release(filp);
-out:
-	mutex_unlock(&pcdev->mlock);
-	return ret;
-}
-
-static int pxac_fops_camera_release(struct file *filp)
-{
-	struct pxa_camera_dev *pcdev = video_drvdata(filp);
-	int ret;
-
-	ret = vb2_fop_release(filp);
-	if (ret < 0)
-		return ret;
-
-	mutex_lock(&pcdev->mlock);
-	ret = sensor_call(pcdev, core, s_power, 0);
-	mutex_unlock(&pcdev->mlock);
-
-	return ret;
-}
-
-static const struct v4l2_file_operations pxa_camera_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pxac_fops_camera_open,
-	.release	= pxac_fops_camera_release,
-	.read		= vb2_fop_read,
-	.poll		= vb2_fop_poll,
-	.mmap		= vb2_fop_mmap,
-	.unlocked_ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
-	.vidioc_querycap		= pxac_vidioc_querycap,
-
-	.vidioc_enum_input		= pxac_vidioc_enum_input,
-	.vidioc_g_input			= pxac_vidioc_g_input,
-	.vidioc_s_input			= pxac_vidioc_s_input,
-
-	.vidioc_enum_fmt_vid_cap	= pxac_vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap		= pxac_vidioc_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap		= pxac_vidioc_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap		= pxac_vidioc_try_fmt_vid_cap,
-
-	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
-	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
-	.vidioc_querybuf		= vb2_ioctl_querybuf,
-	.vidioc_qbuf			= vb2_ioctl_qbuf,
-	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
-	.vidioc_expbuf			= vb2_ioctl_expbuf,
-	.vidioc_streamon		= vb2_ioctl_streamon,
-	.vidioc_streamoff		= vb2_ioctl_streamoff,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register		= pxac_vidioc_g_register,
-	.vidioc_s_register		= pxac_vidioc_s_register,
-#endif
-};
-
-static struct v4l2_clk_ops pxa_camera_mclk_ops = {
-};
-
-static const struct video_device pxa_camera_videodev_template = {
-	.name = "pxa-camera",
-	.minor = -1,
-	.fops = &pxa_camera_fops,
-	.ioctl_ops = &pxa_camera_ioctl_ops,
-	.release = video_device_release_empty,
-	.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING,
-};
-
-static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
-		     struct v4l2_subdev *subdev,
-		     struct v4l2_async_subdev *asd)
-{
-	int err;
-	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
-	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
-	struct video_device *vdev = &pcdev->vdev;
-	struct v4l2_pix_format *pix = &pcdev->current_pix;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-
-	dev_info(pcdev_to_dev(pcdev), "%s(): trying to bind a device\n",
-		 __func__);
-	mutex_lock(&pcdev->mlock);
-	*vdev = pxa_camera_videodev_template;
-	vdev->v4l2_dev = v4l2_dev;
-	vdev->lock = &pcdev->mlock;
-	pcdev->sensor = subdev;
-	pcdev->vdev.queue = &pcdev->vb2_vq;
-	pcdev->vdev.v4l2_dev = &pcdev->v4l2_dev;
-	pcdev->vdev.ctrl_handler = subdev->ctrl_handler;
-	video_set_drvdata(&pcdev->vdev, pcdev);
-
-	err = pxa_camera_build_formats(pcdev);
-	if (err) {
-		dev_err(pcdev_to_dev(pcdev), "building formats failed: %d\n",
-			err);
-		goto out;
-	}
-
-	pcdev->current_fmt = pcdev->user_formats;
-	pix->field = V4L2_FIELD_NONE;
-	pix->width = DEFAULT_WIDTH;
-	pix->height = DEFAULT_HEIGHT;
-	pix->bytesperline =
-		soc_mbus_bytes_per_line(pix->width,
-					pcdev->current_fmt->host_fmt);
-	pix->sizeimage =
-		soc_mbus_image_size(pcdev->current_fmt->host_fmt,
-				    pix->bytesperline, pix->height);
-	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
-	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
-	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
-	if (err)
-		goto out;
-
-	v4l2_fill_pix_format(pix, mf);
-	pr_info("%s(): colorspace=0x%x pixfmt=0x%x\n",
-		__func__, pix->colorspace, pix->pixelformat);
-
-	err = pxa_camera_init_videobuf2(pcdev);
-	if (err)
-		goto out;
-
-	err = video_register_device(&pcdev->vdev, VFL_TYPE_GRABBER, -1);
-	if (err) {
-		v4l2_err(v4l2_dev, "register video device failed: %d\n", err);
-		pcdev->sensor = NULL;
-	} else {
-		dev_info(pcdev_to_dev(pcdev),
-			 "PXA Camera driver attached to camera %s\n",
-			 subdev->name);
-	}
-out:
-	mutex_unlock(&pcdev->mlock);
-	return err;
-}
-
-static void pxa_camera_sensor_unbind(struct v4l2_async_notifier *notifier,
-		     struct v4l2_subdev *subdev,
-		     struct v4l2_async_subdev *asd)
-{
-	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(notifier->v4l2_dev);
-
-	mutex_lock(&pcdev->mlock);
-	dev_info(pcdev_to_dev(pcdev),
-		 "PXA Camera driver detached from camera %s\n",
-		 subdev->name);
-
-	/* disable capture, disable interrupts */
-	__raw_writel(0x3ff, pcdev->base + CICR0);
-
-	/* Stop DMA engine */
-	pxa_dma_stop_channels(pcdev);
-
-	pxa_camera_destroy_formats(pcdev);
-	video_unregister_device(&pcdev->vdev);
-	pcdev->sensor = NULL;
-
-	mutex_unlock(&pcdev->mlock);
-}
-
-/*
- * Driver probe, remove, suspend and resume operations
- */
-static int pxa_camera_suspend(struct device *dev)
-{
-	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
-	int i = 0, ret = 0;
-
-	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
-	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR1);
-	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR2);
-	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
-	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
-
-	if (pcdev->sensor) {
-		ret = sensor_call(pcdev, core, s_power, 0);
-		if (ret == -ENOIOCTLCMD)
-			ret = 0;
-	}
-
-	return ret;
-}
-
-static int pxa_camera_resume(struct device *dev)
-{
-	struct pxa_camera_dev *pcdev = dev_get_drvdata(dev);
-	int i = 0, ret = 0;
-
-	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
-	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
-	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
-	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
-	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
-
-	if (pcdev->sensor) {
-		ret = sensor_call(pcdev, core, s_power, 1);
-		if (ret == -ENOIOCTLCMD)
-			ret = 0;
-	}
-
-	/* Restart frame capture if active buffer exists */
-	if (!ret && pcdev->active)
-		pxa_camera_start_capture(pcdev);
-
-	return ret;
-}
-
-static int pxa_camera_pdata_from_dt(struct device *dev,
-				    struct pxa_camera_dev *pcdev,
-				    struct v4l2_async_subdev *asd)
-{
-	u32 mclk_rate;
-	struct device_node *remote, *np = dev->of_node;
-	struct v4l2_of_endpoint ep;
-	int err = of_property_read_u32(np, "clock-frequency",
-				       &mclk_rate);
-	if (!err) {
-		pcdev->platform_flags |= PXA_CAMERA_MCLK_EN;
-		pcdev->mclk = mclk_rate;
-	}
-
-	np = of_graph_get_next_endpoint(np, NULL);
-	if (!np) {
-		dev_err(dev, "could not find endpoint\n");
-		return -EINVAL;
-	}
-
-	err = v4l2_of_parse_endpoint(np, &ep);
-	if (err) {
-		dev_err(dev, "could not parse endpoint\n");
-		goto out;
-	}
-
-	switch (ep.bus.parallel.bus_width) {
-	case 4:
-		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_4;
-		break;
-	case 5:
-		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_5;
-		break;
-	case 8:
-		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_8;
-		break;
-	case 9:
-		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_9;
-		break;
-	case 10:
-		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
-		break;
-	default:
-		break;
-	}
-
-	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
-		pcdev->platform_flags |= PXA_CAMERA_MASTER;
-	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
-		pcdev->platform_flags |= PXA_CAMERA_HSP;
-	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
-		pcdev->platform_flags |= PXA_CAMERA_VSP;
-	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
-		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN | PXA_CAMERA_PCP;
-	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
-		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
-
-	asd->match_type = V4L2_ASYNC_MATCH_OF;
-	remote = of_graph_get_remote_port(np);
-	if (remote) {
-		asd->match.of.node = remote;
-		of_node_put(remote);
-	} else {
-		dev_notice(dev, "no remote for %s\n", of_node_full_name(np));
-	}
-
-out:
-	of_node_put(np);
-
-	return err;
-}
-
-static int pxa_camera_probe(struct platform_device *pdev)
-{
-	struct pxa_camera_dev *pcdev;
-	struct resource *res;
-	void __iomem *base;
-	struct dma_slave_config config = {
-		.src_addr_width = 0,
-		.src_maxburst = 8,
-		.direction = DMA_DEV_TO_MEM,
-	};
-	dma_cap_mask_t mask;
-	struct pxad_param params;
-	char clk_name[V4L2_CLK_NAME_SIZE];
-	int irq;
-	int err = 0, i;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (!res || irq < 0)
-		return -ENODEV;
-
-	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
-	if (!pcdev) {
-		dev_err(&pdev->dev, "Could not allocate pcdev\n");
-		return -ENOMEM;
-	}
-
-	pcdev->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pcdev->clk))
-		return PTR_ERR(pcdev->clk);
-
-	pcdev->res = res;
-
-	pcdev->pdata = pdev->dev.platform_data;
-	if (&pdev->dev.of_node && !pcdev->pdata) {
-		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
-	} else {
-		pcdev->platform_flags = pcdev->pdata->flags;
-		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
-		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
-		pcdev->asd.match.i2c.adapter_id =
-			pcdev->pdata->sensor_i2c_adapter_id;
-		pcdev->asd.match.i2c.address = pcdev->pdata->sensor_i2c_address;
-	}
-	if (err < 0)
-		return err;
-
-	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
-			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
-		/*
-		 * Platform hasn't set available data widths. This is bad.
-		 * Warn and use a default.
-		 */
-		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
-			 "data widths, using default 10 bit\n");
-		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
-	}
-	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
-		pcdev->width_flags = 1 << 7;
-	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
-		pcdev->width_flags |= 1 << 8;
-	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
-		pcdev->width_flags |= 1 << 9;
-	if (!pcdev->mclk) {
-		dev_warn(&pdev->dev,
-			 "mclk == 0! Please, fix your platform data. "
-			 "Using default 20MHz\n");
-		pcdev->mclk = 20000000;
-	}
-
-	pcdev->mclk_divisor = mclk_get_divisor(pdev, pcdev);
-
-	INIT_LIST_HEAD(&pcdev->capture);
-	spin_lock_init(&pcdev->lock);
-	mutex_init(&pcdev->mlock);
-
-	/*
-	 * Request the regions.
-	 */
-	base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	pcdev->irq = irq;
-	pcdev->base = base;
-
-	/* request dma */
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	dma_cap_set(DMA_PRIVATE, mask);
-
-	params.prio = 0;
-	params.drcmr = 68;
-	pcdev->dma_chans[0] =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &params, &pdev->dev, "CI_Y");
-	if (!pcdev->dma_chans[0]) {
-		dev_err(&pdev->dev, "Can't request DMA for Y\n");
-		return -ENODEV;
-	}
-
-	params.drcmr = 69;
-	pcdev->dma_chans[1] =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &params, &pdev->dev, "CI_U");
-	if (!pcdev->dma_chans[1]) {
-		dev_err(&pdev->dev, "Can't request DMA for Y\n");
-		goto exit_free_dma_y;
-	}
-
-	params.drcmr = 70;
-	pcdev->dma_chans[2] =
-		dma_request_slave_channel_compat(mask, pxad_filter_fn,
-						 &params, &pdev->dev, "CI_V");
-	if (!pcdev->dma_chans[2]) {
-		dev_err(&pdev->dev, "Can't request DMA for V\n");
-		goto exit_free_dma_u;
-	}
-
-	for (i = 0; i < 3; i++) {
-		config.src_addr = pcdev->res->start + CIBR0 + i * 8;
-		err = dmaengine_slave_config(pcdev->dma_chans[i], &config);
-		if (err < 0) {
-			dev_err(&pdev->dev, "dma slave config failed: %d\n",
-				err);
-			goto exit_free_dma;
-		}
-	}
-
-	/* request irq */
-	err = devm_request_irq(&pdev->dev, pcdev->irq, pxa_camera_irq, 0,
-			       PXA_CAM_DRV_NAME, pcdev);
-	if (err) {
-		dev_err(&pdev->dev, "Camera interrupt register failed\n");
-		goto exit_free_dma;
-	}
-
-	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
-
-	pxa_camera_activate(pcdev);
-
-	dev_set_drvdata(&pdev->dev, pcdev);
-	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
-	if (err)
-		goto exit_free_dma;
-
-	pcdev->asds[0] = &pcdev->asd;
-	pcdev->notifier.subdevs = pcdev->asds;
-	pcdev->notifier.num_subdevs = 1;
-	pcdev->notifier.bound = pxa_camera_sensor_bound;
-	pcdev->notifier.unbind = pxa_camera_sensor_unbind;
-
-	if (!of_have_populated_dt())
-		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
-
-	err = pxa_camera_init_videobuf2(pcdev);
-	if (err)
-		goto exit_free_v4l2dev;
-
-	if (pcdev->mclk) {
-		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
-				  pcdev->asd.match.i2c.adapter_id,
-				  pcdev->asd.match.i2c.address);
-
-		pcdev->mclk_clk = v4l2_clk_register(&pxa_camera_mclk_ops,
-						    clk_name, NULL);
-		if (IS_ERR(pcdev->mclk_clk))
-			return PTR_ERR(pcdev->mclk_clk);
-	}
-
-	err = v4l2_async_notifier_register(&pcdev->v4l2_dev, &pcdev->notifier);
-	if (err)
-		goto exit_free_clk;
-
-	return 0;
-exit_free_clk:
-	v4l2_clk_unregister(pcdev->mclk_clk);
-exit_free_v4l2dev:
-	v4l2_device_unregister(&pcdev->v4l2_dev);
-exit_free_dma:
-	dma_release_channel(pcdev->dma_chans[2]);
-exit_free_dma_u:
-	dma_release_channel(pcdev->dma_chans[1]);
-exit_free_dma_y:
-	dma_release_channel(pcdev->dma_chans[0]);
-	return err;
-}
-
-static int pxa_camera_remove(struct platform_device *pdev)
-{
-	struct pxa_camera_dev *pcdev = dev_get_drvdata(&pdev->dev);
-
-	pxa_camera_deactivate(pcdev);
-	dma_release_channel(pcdev->dma_chans[0]);
-	dma_release_channel(pcdev->dma_chans[1]);
-	dma_release_channel(pcdev->dma_chans[2]);
-
-	v4l2_clk_unregister(pcdev->mclk_clk);
-	v4l2_device_unregister(&pcdev->v4l2_dev);
-
-	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
-
-	return 0;
-}
-
-static const struct dev_pm_ops pxa_camera_pm = {
-	.suspend	= pxa_camera_suspend,
-	.resume		= pxa_camera_resume,
-};
-
-static const struct of_device_id pxa_camera_of_match[] = {
-	{ .compatible = "marvell,pxa270-qci", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, pxa_camera_of_match);
-
-static struct platform_driver pxa_camera_driver = {
-	.driver		= {
-		.name	= PXA_CAM_DRV_NAME,
-		.pm	= &pxa_camera_pm,
-		.of_match_table = of_match_ptr(pxa_camera_of_match),
-	},
-	.probe		= pxa_camera_probe,
-	.remove		= pxa_camera_remove,
-};
-
-module_platform_driver(pxa_camera_driver);
-
-MODULE_DESCRIPTION("PXA27x SoC Camera Host driver");
-MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(PXA_CAM_VERSION);
-MODULE_ALIAS("platform:" PXA_CAM_DRV_NAME);
-- 
2.1.4

