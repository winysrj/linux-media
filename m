Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34556 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2FSOLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 10:11:47 -0400
Received: by weyu7 with SMTP id u7so4445612wey.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 07:11:45 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
	fabio.estevam@freescale.com, shawn.guo@linaro.org,
	dirk.behme@googlemail.com, r.schwebel@pengutronix.de
Subject: [RFC] Support for 'Coda' video codec IP.
Date: Tue, 19 Jun 2012 16:11:34 +0200
Message-Id: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the video encoder present
in the i.MX27. It currently support encoding in H.264 and
in MPEG4 SP. It's working properly in a Visstrim SM10 platform.
It uses V4L2-mem2mem framework.

A public git repository is available too:
git://github.com/jmartinc/video_visstrim.git

The current approach assumes two separate files for both encoding
and decoding, but only the former has been implemented. We have no
intention to implement decoding but it shouldn't be difficult to 
integrate by a third party.

A generic 'coda' name has been chosen so that it can implement all
models used in i.MX27, i.MX51... chips. [1].

TODO:
 - Get rid of 'runtime' structure.
 - Prepare a generic layer to make easy the access to different models
 of 'Coda' as discussed here[2].
 - Remove IDR frame bugfix as long as Freescale provides an update for
 the coda embedded in the i.MX27.


[1] http://www.chipsnmedia.com/product/product01_2.htm
[2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg47505.html

---
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7561eca..ce2914b 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -306,6 +306,7 @@ config MACH_IMX27_VISSTRIM_M10
 	bool "Vista Silicon i.MX27 Visstrim_m10"
 	select SOC_IMX27
 	select IMX_HAVE_PLATFORM_GPIO_KEYS
+	select IMX_HAVE_PLATFORM_CODA
 	select IMX_HAVE_PLATFORM_IMX_I2C
 	select IMX_HAVE_PLATFORM_IMX_SSI
 	select IMX_HAVE_PLATFORM_IMX_UART
diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
index 28537a5..f2d9672 100644
--- a/arch/arm/mach-imx/devices-imx27.h
+++ b/arch/arm/mach-imx/devices-imx27.h
@@ -17,6 +17,10 @@ extern const struct imx_fsl_usb2_udc_data imx27_fsl_usb2_udc_data;
 #define imx27_add_fsl_usb2_udc(pdata)	\
 	imx_add_fsl_usb2_udc(&imx27_fsl_usb2_udc_data, pdata)
 
+extern const struct imx_imx27_coda_data imx27_coda_data;
+#define imx27_add_coda(pdata)	\
+	imx_add_imx27_coda(&imx27_coda_data, pdata)
+
 extern const struct imx_imx2_wdt_data imx27_imx2_wdt_data;
 #define imx27_add_imx2_wdt(pdata)	\
 	imx_add_imx2_wdt(&imx27_imx2_wdt_data)
diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
index cb3e3ee..6b46cee 100644
--- a/arch/arm/plat-mxc/devices/Kconfig
+++ b/arch/arm/plat-mxc/devices/Kconfig
@@ -15,7 +15,11 @@ config IMX_HAVE_PLATFORM_GPIO_KEYS
 
 config IMX_HAVE_PLATFORM_IMX21_HCD
 	bool
-	
+
+config IMX_HAVE_PLATFORM_IMX27_CODA
+	bool
+	default y if SOC_IMX27
+
 config IMX_HAVE_PLATFORM_IMX2_WDT
 	bool
 
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index c11ac84..76f3195 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_FSL_USB2_UDC) += platform-fsl-usb2-udc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_GPIO_KEYS) += platform-gpio_keys.o
 obj-y += platform-gpio-mxc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX21_HCD) += platform-imx21-hcd.o
+obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX27_CODA) += platform-imx27-coda.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT) += platform-imx2-wdt.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_IMXDI_RTC) += platform-imxdi_rtc.o
 obj-y += platform-imx-dma.o
diff --git a/arch/arm/plat-mxc/devices/platform-imx27-coda.c b/arch/arm/plat-mxc/devices/platform-imx27-coda.c
new file mode 100644
index 0000000..9236482
--- /dev/null
+++ b/arch/arm/plat-mxc/devices/platform-imx27-coda.c
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2012 Vista Silicon
+ * Javier Martin <javier.martin@vista-silicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+
+#include <mach/hardware.h>
+#include <mach/devices-common.h>
+#include <linux/coda_codec.h>
+
+#ifdef CONFIG_SOC_IMX27
+const struct imx_imx27_coda_data imx27_coda_data __initconst = {
+	.iobase = MX27_VPU_BASE_ADDR,
+	.iosize = SZ_512,
+	.irq = MX27_INT_VPU,
+};
+#endif
+
+struct platform_device *__init imx_add_imx27_coda(
+		const struct imx_imx27_coda_data *data,
+		const struct coda_platform_data *pdata)
+{
+	struct resource res[] = {
+		{
+			.start = data->iobase,
+			.end = data->iobase + data->iosize - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = data->irq,
+			.end = data->irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+	return imx_add_platform_device_dmamask("coda", 0, res, 2, pdata,
+					sizeof(*pdata), DMA_BIT_MASK(32));
+}
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index 1b2258d..4d8c457 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -83,6 +83,16 @@ struct platform_device *__init imx_add_imx21_hcd(
 		const struct imx_imx21_hcd_data *data,
 		const struct mx21_usbh_platform_data *pdata);
 
+#include <linux/coda_codec.h>
+struct imx_imx27_coda_data {
+	resource_size_t iobase;
+	resource_size_t iosize;
+	resource_size_t irq;
+};
+struct platform_device *__init imx_add_imx27_coda(
+		const struct imx_imx27_coda_data *data,
+		const struct coda_platform_data *pdata);
+
 struct imx_imx2_wdt_data {
 	int id;
 	resource_size_t iobase;
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce1e7ba..e209fcd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1185,6 +1185,24 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
+config VIDEO_CODA
+	tristate "Chips&Media Coda multi-standard codec IP"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	---help---
+	   Coda is a range of video codec IPs that supports 
+	   H.264, MPEG-4, and other video formats.
+
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a6282a3..8ee18a1 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -108,6 +108,7 @@ obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_MEYE) += meye.o
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
+obj-$(CONFIG_VIDEO_CODA) += coda/
 obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
diff --git a/drivers/media/video/coda/Makefile b/drivers/media/video/coda/Makefile
new file mode 100644
index 0000000..bea014a
--- /dev/null
+++ b/drivers/media/video/coda/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_CODA) := coda.o
+coda-y += coda_main.o
+coda-y += coda_enc.o
diff --git a/drivers/media/video/coda/coda_common.h b/drivers/media/video/coda/coda_common.h
new file mode 100644
index 0000000..3729db3
--- /dev/null
+++ b/drivers/media/video/coda/coda_common.h
@@ -0,0 +1,208 @@
+/*
+ * linux/drivers/media/video/coda/coda_common.h
+ *
+ * Copyright (C) 2012 Vista Silicon SL
+ *    Javier Martin <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _CODA_COMMON_H_
+#define _CODA_COMMON_H_
+
+#include <media/v4l2-device.h>
+#include <asm/io.h>
+#include "coda_regs.h"
+
+extern int coda_debug;
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+enum coda_fmt_type {
+	CODA_FMT_ENC,
+	CODA_FMT_RAW,
+};
+
+enum coda_inst_type {
+	CODA_INST_INVALID,
+	CODA_INST_ENCODER,
+};
+
+enum coda_node_type {
+	CODA_NODE_INVALID = -1,
+	CODA_NODE_ENCODER = 0,
+};
+
+struct coda_fmt {
+	char *name;
+	u32 fourcc;
+	enum coda_fmt_type type;
+};
+
+/* Per-queue, driver-specific private data */
+struct coda_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		sizeimage;
+	struct coda_fmt	*fmt;
+};
+
+struct coda_aux_buf {
+	void			*vaddr;
+	dma_addr_t		paddr;
+};
+
+struct coda_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd_enc;
+	struct platform_device	*plat_dev;
+
+	void __iomem		*regs_base;
+	struct clk		*clk;
+	int			irq;
+
+	struct coda_aux_buf	enc_codebuf;
+	struct coda_aux_buf	enc_workbuf;
+	struct coda_aux_buf	enc_parabuf;
+
+	spinlock_t		irqlock;
+	struct mutex		dev_mutex;
+	struct v4l2_m2m_dev	*m2m_enc_dev;
+	struct vb2_alloc_ctx	*alloc_enc_ctx;
+};
+
+struct coda_enc_params {
+	u8			h264_intra_qp;
+	u8			h264_inter_qp;
+	u8			mpeg4_intra_qp;
+	u8			mpeg4_inter_qp;
+	u8			gop_size;
+	int			codec_mode;
+	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
+	u32			framerate;
+	u16			bitrate;
+	u32			slice_max_mb;
+};
+
+struct framebuffer {
+	u32	y;
+	u32	cb;
+	u32	cr;
+};
+
+#define CODA_ENC_OUTPUT_BUFS	4
+#define CODA_ENC_CAPTURE_BUFS	2
+
+/* TODO: some data of this structure can be removed */
+struct coda_enc_runtime {
+	/* old EncOpenParam vpuParams */
+	unsigned int	pic_width;
+	unsigned int	pic_height;
+	u32		bitstream_buf;	/* Seems to be pointer to compressed buffer */
+	u32		bitstream_buf_size;
+	u32		bitstream_format; /* This is probably redundant (q_data->fmt->fourcc) */
+	int		initial_delay;	/* This is fixed to 0 */
+	int		vbv_buffer_size; /* This is fixed to 0 */
+	int		enable_autoskip; /* This is fixed to 1 */
+	int		intra_refresh; /* This is fixed to 0 */
+	int		gamma; /* This is fixed to 4096 */
+	int		maxqp; /* This is fixed to 0 */
+	/* old EncInfo structure inside dev->encInfo (pEncInfo->openParam = *pop) */
+	u32		stream_rd_ptr; /* This can be safely removed (use bitstream_buf instead) */
+	u32		stream_buf_start_addr; /* This can be removed (use bitstream_buf instead) */
+	u32		stream_buf_size; /* This can be removed (use bitstream_buf_size) instead */
+	u32		stream_buf_end_addr; /* This can be just dropped */
+	struct framebuffer frame_buf_pool[CODA_ENC_OUTPUT_BUFS]; /* Can be removed if we write to parabuf directly */
+	int		initial_info_obtained; /* This probably can be removed (framework protects) */
+	int		num_frame_buffers; /* This can be removed */
+	int		stride; /* This can be removed later */
+	struct framebuffer source_frame; /* This is only used to pass data to 'encoder_submit' */
+	int		quant_param; /* idem */
+	int		force_ipicture; /* idem */
+	int		skip_picture; /* idem */
+	int		all_inter_mb; /* idem */
+	u32		pic_stream_buffer_addr; /* idem */
+	int		pic_stream_buffer_size; /* idem */
+	/* headers */
+	char		vpu_header[3][64];
+	int		vpu_header_size[3];
+};
+
+struct coda_ctx {
+	struct coda_dev		*dev;
+	int				aborting;
+	int				rawstreamon;
+	int				compstreamon;
+	u32				isequence;
+	struct coda_q_data		q_data[2];
+	enum coda_inst_type		inst_type;
+	struct coda_enc_params	enc_params;
+	struct coda_enc_runtime	runtime;
+	struct v4l2_m2m_ctx		*m2m_ctx;
+	struct v4l2_ctrl_handler	ctrls;
+	struct v4l2_fh			fh;
+	struct vb2_buffer		*reference;
+	int				gopcounter;
+};
+
+static inline void coda_write(struct coda_dev *dev, u32 data, u32 reg)
+{
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
+	writel(data, dev->regs_base + reg);
+}
+
+static inline unsigned int coda_read(struct coda_dev *dev, u32 reg)
+{
+	u32 data;
+	data = readl(dev->regs_base + reg);
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
+	return data;
+}
+
+static inline unsigned long coda_isbusy(struct coda_dev *dev) {
+	return coda_read(dev, CODA_REG_BIT_BUSY);
+}
+
+static inline int coda_is_initialized(struct coda_dev *dev) {
+	return (coda_read(dev, CODA_REG_BIT_CUR_PC) != 0);
+}
+
+static void coda_command_async(struct coda_dev *dev, int codec_mode,
+				  int cmd)
+{
+	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
+	/* TODO: 0 for the first instance of (encoder-decoder), 1 for the second one
+	 *(except firmware which is always 0) */
+	coda_write(dev, 0, CODA_REG_BIT_RUN_INDEX);
+	coda_write(dev, codec_mode, CODA_REG_BIT_RUN_COD_STD);
+	coda_write(dev, cmd, CODA_REG_BIT_RUN_COMMAND);
+}
+
+static int coda_command_sync(struct coda_dev *dev, int codec_mode,
+				int cmd)
+{
+	unsigned int timeout = 100000;
+
+	coda_command_async(dev, codec_mode, cmd);
+	while (coda_isbusy(dev)) {
+	if (timeout-- == 0)
+		return -ETIMEDOUT;
+	};
+	return 0;
+}
+
+struct coda_q_data *get_q_data(struct coda_ctx *ctx,
+					 enum v4l2_buf_type type);
+
+#define fh_to_ctx(__fh) container_of(__fh, struct coda_ctx, fh)
+
+#endif
diff --git a/drivers/media/video/coda/coda_enc.c b/drivers/media/video/coda/coda_enc.c
new file mode 100644
index 0000000..a280839
--- /dev/null
+++ b/drivers/media/video/coda/coda_enc.c
@@ -0,0 +1,1130 @@
+/*
+ * CodaDx6 multi-standard codec IP
+ *
+ * Copyright (C) 2012 Vista Silicon S.L.
+ *    Javier Martin, <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/irq.h>
+
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "coda_common.h"
+#include "coda_enc.h"
+
+#define CODA_ENC_MAX_WIDTH		720
+#define CODA_ENC_MAX_HEIGHT		576
+#define CODA_ENC_MAX_FRAME_SIZE	0x90000
+#define FMO_SLICE_SAVE_BUF_SIZE         (32)
+
+#define MIN_W 176
+#define MIN_H 144
+#define MAX_W 720
+#define MAX_H 576
+
+#define S_ALIGN		1 /* multiple of 2 */
+#define W_ALIGN		1 /* multiple of 2 */
+#define H_ALIGN		1 /* multiple of 2 */
+
+static struct coda_fmt formats[] = {
+        {
+                .name = "YUV 4:2:0 Planar",
+                .fourcc = V4L2_PIX_FMT_YUV420,
+                .type = CODA_FMT_RAW,
+        },
+        {
+                .name = "H264 Encoded Stream",
+                .fourcc = V4L2_PIX_FMT_H264,
+                .type = CODA_FMT_ENC,
+        },
+        {
+                .name = "MPEG4 Encoded Stream",
+                .fourcc = V4L2_PIX_FMT_MPEG4,
+                .type = CODA_FMT_ENC,
+        },
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct coda_fmt *find_format(struct v4l2_format *f)
+{
+	struct coda_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (k == NUM_FORMATS)
+		return NULL;
+
+	return &formats[k];
+}
+
+/*
+ * V4L2 ioctl() operations.
+ */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, CODA_ENC_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, CODA_ENC_NAME, sizeof(cap->card) - 1);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+			  | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int enum_fmt(struct v4l2_fmtdesc *f, enum coda_fmt_type type)
+{
+	struct coda_fmt *fmt;
+	int i, num = 0;
+	
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].type == type) {
+			if (num == f->index)
+				break;
+			++num;
+		}
+	}
+
+	if (i < NUM_FORMATS) {
+		fmt = &formats[i];
+		strlcpy(f->description, fmt->name, sizeof(f->description) - 1);
+		f->pixelformat = fmt->fourcc;
+		return 0;
+	}
+
+	/* Format not found */
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(f, CODA_FMT_ENC);
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(f, CODA_FMT_RAW);
+}
+
+static int vidioc_g_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct coda_q_data *q_data;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, f->type);
+
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
+		f->fmt.pix.width	= q_data->width;
+		f->fmt.pix.height	= q_data->height;
+		f->fmt.pix.bytesperline = q_data->width * 3 / 2;
+	} else { /* encoded formats h.264/mpeg4 */
+		f->fmt.pix.width	= 0;
+		f->fmt.pix.height	= 0;
+		f->fmt.pix.bytesperline = q_data->sizeimage;
+	}
+	f->fmt.pix.sizeimage	= q_data->sizeimage;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_try_fmt(struct v4l2_format *f)
+{
+	enum v4l2_field field;
+
+	if (!find_format(f))
+		return -EINVAL;
+
+	field = f->fmt.pix.field;
+	if (field == V4L2_FIELD_ANY)
+		field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != field)
+		return -EINVAL;
+
+	/* V4L2 specification suggests the driver corrects the format struct
+	 * if any of the dimensions is unsupported */
+	f->fmt.pix.field = field;
+
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
+		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
+				      W_ALIGN, &f->fmt.pix.height,
+				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+		f->fmt.pix.bytesperline = f->fmt.pix.width * 3 / 2;
+		f->fmt.pix.sizeimage = f->fmt.pix.height *
+					f->fmt.pix.bytesperline;
+	} else { /*encoded formats h.264/mpeg4 */
+		f->fmt.pix.bytesperline = CODA_ENC_MAX_FRAME_SIZE;
+		f->fmt.pix.sizeimage = CODA_ENC_MAX_FRAME_SIZE;
+	}
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct coda_fmt *fmt;
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	fmt = find_format(f);
+	if (!fmt || !(fmt->type == CODA_FMT_ENC)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(f);
+}
+
+static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct coda_fmt *fmt;
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	fmt = find_format(f);
+	if (!fmt || !(fmt->type == CODA_FMT_RAW)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(f);
+}
+
+static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
+{
+	struct coda_q_data *q_data;
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, f->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = vidioc_try_fmt(f);
+	if (ret)
+		return ret;
+
+	q_data->fmt		= find_format(f);
+	if (q_data->fmt->fourcc == V4L2_PIX_FMT_YUV420) {
+		q_data->width		= f->fmt.pix.width;
+		q_data->height		= f->fmt.pix.height;
+		q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
+	} else { /* encoded format h.264/mpeg-4 */
+		q_data->sizeimage = CODA_ENC_MAX_FRAME_SIZE;
+	}
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
+		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+
+	ret = vidioc_try_fmt_vid_cap(file, fh_to_ctx(priv), f);
+	if (ret)
+		return ret;
+
+	return vidioc_s_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+
+	ret = vidioc_try_fmt_vid_out(file, fh_to_ctx(priv), f);
+	if (ret)
+		return ret;
+
+	return vidioc_s_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	int ret;
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+	
+	ret = v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+	return ret;
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		if (a->parm.output.timeperframe.numerator != 1) {
+			v4l2_err(&ctx->dev->v4l2_dev,
+				 "FPS numerator must be 1\n");
+			return -EINVAL;
+		}
+		ctx->enc_params.framerate =
+					a->parm.output.timeperframe.denominator;
+	} else {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Setting FPS is only possible for the output queue\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		a->parm.output.timeperframe.denominator =
+					ctx->enc_params.framerate;
+		a->parm.output.timeperframe.numerator = 1;
+	} else {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Getting FPS is only possible for the output queue\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops coda_enc_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
+
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out	= vidioc_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
+
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+
+	.vidioc_s_parm		= vidioc_s_parm,
+	.vidioc_g_parm		= vidioc_g_parm,
+};
+
+const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void)
+{
+	return &coda_enc_ioctl_ops;
+}
+
+/*
+ * Mem-to-mem operations.
+ */
+
+int coda_enc_isr(struct coda_dev *dev)
+{
+	struct coda_ctx *ctx;
+	struct vb2_buffer *src_buf, *dst_buf, *tmp_buf;
+
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_enc_dev);
+	if (ctx == NULL) {
+		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
+		return IRQ_HANDLED;
+	}
+
+	if (ctx->aborting) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "task has been aborted\n");
+		return IRQ_HANDLED;
+	}
+
+	if (coda_isbusy(ctx->dev)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "coda is still busy!!!!\n");
+		return IRQ_NONE;
+	}
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+
+	/* coda_encoder_get_results */
+	{
+	u32 tmp1, tmp2;
+
+	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
+	tmp1 = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
+	tmp2 = coda_read(dev, CODA_REG_BIT_WR_PTR_0);
+	/* Calculate bytesused field */
+	if (dst_buf->v4l2_buf.sequence == 0) {
+		dst_buf->v4l2_planes[0].bytesused = (tmp2 - tmp1) + ctx->runtime.vpu_header_size[0] +
+							ctx->runtime.vpu_header_size[1] +
+							ctx->runtime.vpu_header_size[2];
+	} else {
+		dst_buf->v4l2_planes[0].bytesused = (tmp2 - tmp1);
+	}
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n", tmp2-tmp1);
+	coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
+	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
+	}
+
+	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
+		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+	} else {
+		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+	}
+
+	/* Free previous reference picture if available */
+	if (ctx->reference) {
+		v4l2_m2m_buf_done(ctx->reference, VB2_BUF_STATE_DONE);
+		ctx->reference = NULL;
+	}
+
+	/* 
+	 * For the last frame of the gop we don't need to save
+	 * a reference picture.
+	 */
+	v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	tmp_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	if (ctx->gopcounter == 0) {
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+	} else {
+		ctx->reference = tmp_buf;
+	}
+
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+
+	ctx->gopcounter--;
+	if (ctx->gopcounter < 0)
+		ctx->gopcounter = ctx->enc_params.gop_size - 1;
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		"job finished: encoding frame (%d) (%s)\n",
+		dst_buf->v4l2_buf.sequence,
+		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
+		"KEYFRAME" : "PFRAME");
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_enc_dev, ctx->m2m_ctx);
+	
+	return IRQ_HANDLED;
+}
+
+static void coda_device_run(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_q_data *q_data_src, *q_data_dst;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct coda_dev *dev = ctx->dev;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+
+	src_buf->v4l2_buf.sequence = ctx->isequence;
+	dst_buf->v4l2_buf.sequence = ctx->isequence;
+	ctx->isequence++;
+
+	/* 
+	 * Workaround coda firmware BUG that only marks the first
+	 * frame as IDR. This is a problem for some decoders that can't
+	 * recover when a frame is lost.
+	 */
+	if (src_buf->v4l2_buf.sequence % ctx->enc_params.gop_size) {
+		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+	} else {
+		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+	}
+
+	ctx->runtime.source_frame.y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	ctx->runtime.source_frame.cb = ctx->runtime.source_frame.y +
+				q_data_src->width * q_data_src->height;
+	ctx->runtime.source_frame.cr = ctx->runtime.source_frame.cb +
+				q_data_src->width / 2 * q_data_src->height / 2;
+
+	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
+		ctx->runtime.force_ipicture = 1;
+		if (ctx->enc_params.codec_mode == CODA_MODE_ENCODE_H264) {
+			ctx->runtime.quant_param = ctx->enc_params.h264_intra_qp;
+		} else {
+			ctx->runtime.quant_param = ctx->enc_params.mpeg4_intra_qp;
+		}
+	} else {
+		ctx->runtime.force_ipicture = 0;
+		if (ctx->enc_params.codec_mode == CODA_MODE_ENCODE_H264) {
+			ctx->runtime.quant_param = ctx->enc_params.h264_inter_qp;
+		} else {
+			ctx->runtime.quant_param = ctx->enc_params.mpeg4_inter_qp;
+		}
+	}
+	ctx->runtime.skip_picture = 0;
+	ctx->runtime.all_inter_mb = 0;
+
+	/*
+	 * Copy headers at the beginning of the first frame for H.264 only.
+	 * In MPEG4 they are already copied by the coda.
+	 */
+	if (src_buf->v4l2_buf.sequence == 0) {
+		ctx->runtime.pic_stream_buffer_addr =
+			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
+			ctx->runtime.vpu_header_size[0] +
+			ctx->runtime.vpu_header_size[1] +
+			ctx->runtime.vpu_header_size[2];
+		ctx->runtime.pic_stream_buffer_size = CODA_ENC_MAX_FRAME_SIZE -
+			ctx->runtime.vpu_header_size[0] -
+			ctx->runtime.vpu_header_size[1] -
+			ctx->runtime.vpu_header_size[2];
+		memcpy(vb2_plane_vaddr(dst_buf, 0),
+		       &ctx->runtime.vpu_header[0][0], ctx->runtime.vpu_header_size[0]);
+		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->runtime.vpu_header_size[0],
+		       &ctx->runtime.vpu_header[1][0], ctx->runtime.vpu_header_size[1]);
+		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->runtime.vpu_header_size[0] + ctx->runtime.vpu_header_size[1],
+		       &ctx->runtime.vpu_header[2][0], ctx->runtime.vpu_header_size[2]);
+	} else {
+		ctx->runtime.pic_stream_buffer_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+		ctx->runtime.pic_stream_buffer_size = CODA_ENC_MAX_FRAME_SIZE;
+	}
+	
+	/* coda_encoder_submit */
+	{
+		coda_write(dev, 0, CODA_CMD_ENC_PIC_ROT_MODE);
+		coda_write(dev, ctx->runtime.quant_param, CODA_CMD_ENC_PIC_QS);
+		
+		if (ctx->runtime.skip_picture) {
+			coda_write(dev, 1, CODA_CMD_ENC_PIC_OPTION);
+		} else {
+			coda_write(dev, ctx->runtime.source_frame.y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
+			coda_write(dev, ctx->runtime.source_frame.cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
+			coda_write(dev, ctx->runtime.source_frame.cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
+			coda_write(dev, (ctx->runtime.all_inter_mb << 5) | (ctx->runtime.force_ipicture << 1 & 0x2), CODA_CMD_ENC_PIC_OPTION);
+		}
+
+		coda_write(dev, ctx->runtime.pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
+		coda_write(dev, ctx->runtime.pic_stream_buffer_size / 1024, CODA_CMD_ENC_PIC_BB_SIZE);
+		coda_command_async(dev, ctx->enc_params.codec_mode, CODA_COMMAND_PIC_RUN);
+	}
+}
+
+static int coda_job_ready(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+
+	/* 
+	 * For both 'P' and 'key' frame cases 1 picture
+	 * and 1 frame are needed.
+	 */
+	if (!(v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) >= 1) ||
+		!(v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) >= 1)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: not enough video buffers.\n");
+		return 0;
+	}
+
+	/* For P frames a reference picture is needed too */
+	if ((ctx->gopcounter != (ctx->enc_params.gop_size - 1)) && (!ctx->reference)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: reference picture not available.\n");
+		return 0;
+	}
+
+	if (coda_isbusy(ctx->dev)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: coda is still busy.\n");
+		return 0;
+	}
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			"job ready\n");
+	return 1;
+}
+
+static void coda_job_abort(void *priv)
+{
+	struct coda_ctx *ctx = priv;
+	struct coda_dev *dev = ctx->dev;
+
+	ctx->aborting = 1;
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		 "Aborting task\n");
+	
+	v4l2_m2m_job_finish(dev->m2m_enc_dev, ctx->m2m_ctx);
+}
+
+static void coda_lock(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_dev *pcdev = ctx->dev;
+	mutex_lock(&pcdev->dev_mutex);
+}
+
+static void coda_unlock(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_dev *pcdev = ctx->dev;
+	mutex_unlock(&pcdev->dev_mutex);
+}
+
+static struct v4l2_m2m_ops coda_enc_m2m_ops = {
+	.device_run	= coda_device_run,
+	.job_ready	= coda_job_ready,
+	.job_abort	= coda_job_abort,
+	.lock		= coda_lock,
+	.unlock		= coda_unlock,
+};
+
+struct v4l2_m2m_ops *get_enc_m2m_ops(void)
+{
+	return &coda_enc_m2m_ops;
+}
+
+void set_enc_default_params(struct coda_ctx *ctx) {
+	ctx->enc_params.codec_mode = CODA_MODE_INVALID;
+	ctx->enc_params.framerate = 30;
+	ctx->reference = NULL;
+	ctx->aborting = 0;
+
+	/* Default formats for output and input queues */
+	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
+	ctx->q_data[V4L2_M2M_DST].fmt = &formats[1];
+}
+
+/*
+ * Queue operations
+ */
+static int coda_enc_queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
+	unsigned int size;
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		*nbuffers = CODA_ENC_OUTPUT_BUFS;
+		if (fmt)
+			size = fmt->fmt.pix.width *
+				fmt->fmt.pix.height * 3 / 2;
+		else
+			size = CODA_ENC_MAX_WIDTH *
+				CODA_ENC_MAX_HEIGHT * 3 / 2;
+	} else {
+		*nbuffers = CODA_ENC_CAPTURE_BUFS;
+		size = CODA_ENC_MAX_FRAME_SIZE;
+	}
+	
+	*nplanes = 1;
+	sizes[0] = size;
+
+	alloc_ctxs[0] = ctx->dev->alloc_enc_ctx;
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		 "get %d buffer(s) of size %d each.\n", *nbuffers, size);
+
+	return 0;
+}
+
+static int coda_enc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct coda_q_data *q_data;
+
+	q_data = get_q_data(ctx, vb->vb2_queue->type);
+
+	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+		v4l2_warn(&ctx->dev->v4l2_dev, "%s data will not fit into"
+			"plane (%lu < %lu)\n", __func__, vb2_plane_size(vb, 0),
+			(long)q_data->sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+
+	return 0;
+}
+
+static void coda_enc_buf_queue(struct vb2_buffer *vb)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static void coda_wait_prepare(struct vb2_queue *q)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	coda_unlock(ctx);
+}
+
+static void coda_wait_finish(struct vb2_queue *q)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	coda_lock(ctx);
+}
+
+static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	struct coda_dev *dev = ctx->dev;
+
+	if (count < 1)
+		return -EINVAL;
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		ctx->rawstreamon = 1;
+	} else {
+		ctx->compstreamon = 1;
+	}
+
+	if (ctx->rawstreamon & ctx->compstreamon) {
+		struct coda_q_data *q_data_src, *q_data_dst;
+		struct vb2_buffer *buf;
+		struct vb2_queue *vq;
+		u32 value;
+		int i = 0;
+
+		ctx->gopcounter = ctx->enc_params.gop_size - 1;
+
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		ctx->runtime.pic_width = q_data_src->width;
+		ctx->runtime.pic_height = q_data_src->height;
+		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		ctx->runtime.bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
+		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		ctx->runtime.bitstream_buf_size = q_data_dst->sizeimage;
+		ctx->runtime.bitstream_format = q_data_dst->fmt->fourcc;
+		ctx->runtime.initial_delay = 0;
+		ctx->runtime.vbv_buffer_size = 0;
+		ctx->runtime.enable_autoskip = 1;
+		ctx->runtime.intra_refresh = 0;
+		ctx->runtime.gamma = 4096;
+		ctx->runtime.maxqp = 0;
+
+		if (!coda_is_initialized(dev)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "coda is not initialized.\n");
+			return -EFAULT;
+		}
+
+		/* coda_encoder_init */
+		{
+		
+		if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) {
+			ctx->enc_params.codec_mode = CODA_MODE_ENCODE_H264;
+		} else if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_MPEG4) {
+			ctx->enc_params.codec_mode = CODA_MODE_ENCODE_M4S2;
+		}
+
+		ctx->runtime.stream_rd_ptr = ctx->runtime.bitstream_buf;
+		ctx->runtime.stream_buf_start_addr = ctx->runtime.bitstream_buf;
+		ctx->runtime.stream_buf_size = ctx->runtime.bitstream_buf_size;
+		ctx->runtime.stream_buf_end_addr = ctx->runtime.bitstream_buf +
+						ctx->runtime.bitstream_buf_size;
+		ctx->runtime.initial_info_obtained = 0;
+
+		coda_write(dev, ctx->runtime.stream_rd_ptr, CODA_REG_BIT_RD_PTR_0);
+		coda_write(dev, ctx->runtime.stream_buf_start_addr, CODA_REG_BIT_WR_PTR_0);
+		value = coda_read(dev, CODA_REG_BIT_STREAM_CTRL);
+		value &= 0xffe7;
+		value |= 3 << 3;
+		coda_write(dev, value, CODA_REG_BIT_STREAM_CTRL);
+		}
+
+		/* walk the src ready list and store buffer phys addresses  */
+		vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		for (i = 0; i < vq->num_buffers; i++) {
+			buf = vq->bufs[i];
+			ctx->runtime.frame_buf_pool[i].y = vb2_dma_contig_plane_dma_addr(buf, 0);
+			ctx->runtime.frame_buf_pool[i].cb = ctx->runtime.frame_buf_pool[i].y +
+				q_data_src->width * q_data_src->height;
+			ctx->runtime.frame_buf_pool[i].cr = ctx->runtime.frame_buf_pool[i].cb +
+				q_data_src->width / 2 * q_data_src->height / 2;
+		}
+		ctx->runtime.num_frame_buffers = vq->num_buffers;
+		ctx->runtime.stride = q_data_src->width;
+		
+		/* coda_encoder_configure */
+		{
+		u32 data;
+
+		coda_write(dev, 0xFFFF4C00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
+
+		/* Could set rotation here if needed */
+		data = (ctx->runtime.pic_width & CODA_PICWIDTH_MASK) << CODA_PICWIDTH_OFFSET;
+		data |= (ctx->runtime.pic_height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
+		coda_write(dev, data, CODA_CMD_ENC_SEQ_SRC_SIZE);
+		coda_write(dev, ctx->enc_params.framerate, CODA_CMD_ENC_SEQ_SRC_F_RATE);
+
+		if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_MPEG4) {
+			coda_write(dev, CODA_ENCODE_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
+			data  = (0 & CODA_MP4PARAM_VERID_MASK) << CODA_MP4PARAM_VERID_OFFSET;
+			data |= (0 & CODA_MP4PARAM_INTRADCVLCTHR_MASK) << CODA_MP4PARAM_INTRADCVLCTHR_OFFSET;
+			data |= (0 & CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK) << CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET;
+			data |=  0 & CODA_MP4PARAM_DATAPARTITIONENABLE_MASK;
+			coda_write(dev, data, CODA_CMD_ENC_SEQ_MP4_PARA);
+		} else if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) {
+			coda_write(dev, CODA_ENCODE_H264, CODA_CMD_ENC_SEQ_COD_STD);
+			data  = (0 & CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET;
+			data |= (0 & CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET;
+			data |= (0 & CODA_264PARAM_DISABLEDEBLK_MASK) << CODA_264PARAM_DISABLEDEBLK_OFFSET;
+			data |= (0 & CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK) << CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET;
+			data |=  0 & CODA_264PARAM_CHROMAQPOFFSET_MASK;
+			coda_write(dev, data, CODA_CMD_ENC_SEQ_264_PARA);
+		}
+
+		data  = (ctx->enc_params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
+		data |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
+		if (ctx->enc_params.slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB)
+			data |=  1 & CODA_SLICING_MODE_MASK;
+		coda_write(dev, data, CODA_CMD_ENC_SEQ_SLICE_MODE);
+		data  =  ctx->enc_params.gop_size & CODA_GOP_SIZE_MASK;
+		coda_write(dev, data, CODA_CMD_ENC_SEQ_GOP_SIZE);
+		
+		if (ctx->enc_params.bitrate) {
+			/* Rate control enabled */
+			data  = ((!ctx->runtime.enable_autoskip) & CODA_RATECONTROL_AUTOSKIP_MASK) << CODA_RATECONTROL_AUTOSKIP_OFFSET;
+			data |= (ctx->runtime.initial_delay & CODA_RATECONTROL_INITIALDELAY_MASK) << CODA_RATECONTROL_INITIALDELAY_OFFSET;
+			data |= (ctx->enc_params.bitrate & CODA_RATECONTROL_BITRATE_MASK) << CODA_RATECONTROL_BITRATE_OFFSET;
+			data |=  1 & CODA_RATECONTROL_ENABLE_MASK;
+		} else {
+			data = 0;
+		}
+		coda_write(dev, data, CODA_CMD_ENC_SEQ_RC_PARA);
+
+		coda_write(dev, ctx->runtime.vbv_buffer_size, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
+		coda_write(dev, ctx->runtime.intra_refresh, CODA_CMD_ENC_SEQ_INTRA_REFRESH);
+
+		coda_write(dev, ctx->runtime.stream_buf_start_addr, CODA_CMD_ENC_SEQ_BB_START);
+		coda_write(dev, ctx->runtime.stream_buf_size / 1024, CODA_CMD_ENC_SEQ_BB_SIZE);
+
+		if (ctx->runtime.maxqp) {
+			/* adjust qp if they are above the maximum */
+			if ((ctx->runtime.bitstream_format == V4L2_PIX_FMT_MPEG4) && (ctx->runtime.maxqp > 31)) ctx->runtime.maxqp = 31;  
+			if ((ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) && (ctx->runtime.maxqp > 51)) ctx->runtime.maxqp = 51;
+			data = (ctx->runtime.maxqp & CODA_QPMAX_MASK) << CODA_QPMAX_OFFSET;
+			coda_write(dev, data, CODA_CMD_ENC_SEQ_RC_QP_MAX);
+		}
+    
+		if (ctx->runtime.gamma) {
+			/* set default gamma if not set */
+			if (ctx->runtime.gamma > 32768) ctx->runtime.gamma = 32768;
+			data = (ctx->runtime.gamma & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET;
+			coda_write(dev, data, CODA_CMD_ENC_SEQ_RC_GAMMA);
+		}
+
+		data  = (ctx->runtime.gamma > 0) << CODA_OPTION_GAMMA_OFFSET;
+		data |= (ctx->runtime.maxqp > 0) << CODA_OPTION_LIMITQP_OFFSET;
+		data |= (0 & CODA_OPTION_SLICEREPORT_MASK) << CODA_OPTION_SLICEREPORT_OFFSET;
+		coda_write(dev, data, CODA_CMD_ENC_SEQ_OPTION);
+
+		if (ctx->enc_params.codec_mode == CODA_MODE_ENCODE_H264) {
+			data  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
+			data |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
+			data |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
+			coda_write(dev, data, CODA_CMD_ENC_SEQ_FMO);
+		}
+
+		if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_SEQ_INIT)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0)
+			return -EFAULT;
+
+		/* Let the codec know the addresses of the frame buffers */
+		for (i = 0; i < ctx->runtime.num_frame_buffers; i++) {
+			u32 *p;
+
+			p = ctx->dev->enc_parabuf.vaddr;
+			p[i * 3] = ctx->runtime.frame_buf_pool[i].y;
+			p[i * 3 + 1] = ctx->runtime.frame_buf_pool[i].cb;
+			p[i * 3 + 2] = ctx->runtime.frame_buf_pool[i].cr;
+		}
+		coda_write(dev, ctx->runtime.num_frame_buffers, CODA_CMD_SET_FRAME_BUF_NUM);
+		coda_write(dev, ctx->runtime.stride, CODA_CMD_SET_FRAME_BUF_STRIDE);
+		if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_SET_FRAME_BUF)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		ctx->runtime.initial_info_obtained = 1;
+		}
+
+		/* Save stream headers */
+		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) {
+			/* Get SPS in the first frame and copy it to an intermediate buffer TODO: copy directly */
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_H264_SPS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+				return -ETIMEDOUT;
+			}
+			ctx->runtime.vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) - 
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->runtime.vpu_header[0][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[0]);
+
+			/* Get PPS in the first frame and copy it to an intermediate buffer TODO: copy directly*/
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_H264_PPS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+				return -ETIMEDOUT;
+			}
+			ctx->runtime.vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) - 
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->runtime.vpu_header[1][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[1]);
+			ctx->runtime.vpu_header_size[2] = 0;
+		} else { /* MPEG4 */
+			/* Get VOS in the first frame and copy it to an intermediate buffer TODO: copy directly */
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev,  ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_MP4V_VOS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+				return -ETIMEDOUT;
+			}
+			ctx->runtime.vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) - 
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->runtime.vpu_header[0][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[0]);
+
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_MP4V_VIS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
+				return -ETIMEDOUT;
+			}
+			ctx->runtime.vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->runtime.vpu_header[1][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[1]);
+
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_MP4V_VOL, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
+				return -ETIMEDOUT;
+			}
+			ctx->runtime.vpu_header_size[2] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->runtime.vpu_header[2][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[2]);
+		}
+	}
+	return 0;
+}
+
+static int coda_stop_streaming(struct vb2_queue *q)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	struct coda_dev *dev = ctx->dev;
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "%s: output\n", __func__);
+		ctx->rawstreamon = 0;
+	} else {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "%s: capture\n", __func__);
+		ctx->compstreamon = 0;
+	}
+
+	if (!ctx->rawstreamon & !ctx->compstreamon) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "%s: sent command 'SEQ_END' to coda\n", __func__);
+		if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_SEQ_END)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SEQ_END failed\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+static struct vb2_ops coda_enc_qops = {
+	.queue_setup		= coda_enc_queue_setup,
+	.buf_prepare		= coda_enc_buf_prepare,
+	.buf_queue		= coda_enc_buf_queue,
+	.wait_prepare		= coda_wait_prepare,
+	.wait_finish		= coda_wait_finish,
+	.start_streaming	= coda_start_streaming,
+	.stop_streaming		= coda_stop_streaming,
+};
+
+struct vb2_ops *get_enc_qops(void)
+{
+	return &coda_enc_qops;
+}
+
+static int coda_enc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct coda_ctx *ctx =
+			container_of(ctrl->handler, struct coda_ctx, ctrls);
+	
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		ctx->enc_params.bitrate = ctrl->val / 1000;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		ctx->enc_params.gop_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
+		ctx->enc_params.h264_intra_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
+		ctx->enc_params.h264_inter_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
+		ctx->enc_params.mpeg4_intra_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
+		ctx->enc_params.mpeg4_inter_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+		ctx->enc_params.slice_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
+		ctx->enc_params.slice_max_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		break;
+	default:
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Invalid control, id=%d, val=%d\n",
+			ctrl->id, ctrl->val);
+		return -EINVAL;
+	}
+	
+	return 0;
+}
+
+static struct v4l2_ctrl_ops coda_enc_ctrl_ops = {
+	.s_ctrl = coda_enc_s_ctrl,
+};
+
+int coda_enc_ctrls_setup(struct coda_ctx *ctx)
+{
+	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
+
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 25);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 25);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
+		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
+		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_enc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
+		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
+
+	return v4l2_ctrl_handler_setup(&ctx->ctrls);
+}
diff --git a/drivers/media/video/coda/coda_enc.h b/drivers/media/video/coda/coda_enc.h
new file mode 100644
index 0000000..09b61f4
--- /dev/null
+++ b/drivers/media/video/coda/coda_enc.h
@@ -0,0 +1,26 @@
+/*
+ * linux/drivers/media/video/coda/coda_enc.h
+ *
+ * Copyright (C) 2012 Vista Silicon SL
+ *    Javier Martin <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _CODA_ENC_H_
+#define _CODA_ENC_H_
+
+#define CODA_ENC_NAME	"coda-enc"
+
+const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
+struct v4l2_m2m_ops *get_enc_m2m_ops(void);
+void set_enc_default_params(struct coda_ctx *ctx);
+struct vb2_ops *get_enc_qops(void);
+int coda_enc_ctrls_setup(struct coda_ctx *ctx);
+int coda_enc_isr(struct coda_dev *dev);
+
+#endif
diff --git a/drivers/media/video/coda/coda_main.c b/drivers/media/video/coda/coda_main.c
new file mode 100644
index 0000000..6d0b403
--- /dev/null
+++ b/drivers/media/video/coda/coda_main.c
@@ -0,0 +1,513 @@
+/*
+ * CodaDx6 multi-standard codec IP
+ *
+ * Copyright (C) 2012 Vista Silicon S.L.
+ *    Javier Martin, <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/coda_codec.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "coda_common.h"
+#include "coda_regs.h"
+#include "coda_enc.h"
+
+#define CODA_NAME		"coda"
+
+#define CODA_FMO_BUF_SIZE	32
+#define CODA_CODE_BUF_SIZE	(64 * 1024)
+#define CODA_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
+#define CODA_PARA_BUF_SIZE	(10 * 1024)
+#define CODA_ISRAM_SIZE	(2048 * 2)
+
+#define CODA_SUPPORTED_PRODUCT_ID	0xf001
+#define CODA_SUPPORTED_MAJOR		2
+#define CODA_SUPPORTED_MINOR		2
+#define CODA_SUPPORTED_RELEASE	5
+
+int coda_debug = 3;
+module_param(coda_debug, int, 0);
+MODULE_PARM_DESC(coda_debug, "Debug level (0-1)");
+
+struct coda_q_data *get_q_data(struct coda_ctx *ctx,
+					 enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &(ctx->q_data[V4L2_M2M_SRC]);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &(ctx->q_data[V4L2_M2M_DST]);
+	default:
+		BUG();
+	}
+	return NULL;
+}
+
+static enum coda_node_type coda_get_node_type(struct file *file)
+{
+	struct video_device *vfd = video_devdata(file);
+
+	if (vfd->index == 0)
+		return CODA_NODE_ENCODER;
+	else /* decoder not supported */
+		return CODA_NODE_INVALID;
+}
+
+static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct coda_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	if (ctx->inst_type == CODA_INST_ENCODER) {
+		src_vq->ops = get_enc_qops();
+	} else {
+		v4l2_err(&ctx->dev->v4l2_dev, "Instance not supported\n");
+		return -EINVAL;
+	}
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	if (ctx->inst_type == CODA_INST_ENCODER) {
+		dst_vq->ops = get_enc_qops();
+	} else {
+		v4l2_err(&ctx->dev->v4l2_dev, "Instance not supported\n");
+		return -EINVAL;
+	}
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int coda_open(struct file *file)
+{
+	struct coda_dev *dev = video_drvdata(file);
+	struct coda_ctx *ctx = NULL;
+	int ret = 0;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+	ctx->dev = dev;
+
+	if (coda_get_node_type(file) == CODA_NODE_ENCODER) {
+		ctx->inst_type = CODA_INST_ENCODER;
+		set_enc_default_params(ctx);
+		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_enc_dev, ctx,
+						 &coda_queue_init);
+		if (IS_ERR(ctx->m2m_ctx)) {
+			int ret = PTR_ERR(ctx->m2m_ctx);
+			
+			printk("%s return error (%d)\n", __func__, ret);
+			goto err;
+		}
+		ret = coda_enc_ctrls_setup(ctx);
+		if (ret) {
+			v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
+
+			goto err;
+		}
+	} else {
+		v4l2_err(&dev->v4l2_dev, "node type not supported\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ctx->fh.ctrl_handler = &ctx->ctrls;
+
+	clk_enable(dev->clk);
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %p\n",
+		 ctx);
+
+	return 0;
+
+err:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	return ret;
+}
+
+static int coda_release(struct file *file)
+{
+	struct coda_dev *dev = video_drvdata(file);
+	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
+		 ctx);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_ctrl_handler_free(&ctx->ctrls);
+	clk_disable(dev->clk);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int coda_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+static int coda_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations coda_fops = {
+	.owner		= THIS_MODULE,
+	.open		= coda_open,
+	.release	= coda_release,
+	.poll		= coda_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= coda_mmap,
+};
+
+static irqreturn_t coda_irq_handler(int irq, void *data)
+{
+	struct coda_dev *dev = data;
+
+	printk("%s!!\n", __func__);
+
+	/* read status register to attend the IRQ */
+	coda_read(dev, CODA_REG_BIT_INT_STATUS);
+	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
+		      CODA_REG_BIT_INT_CLEAR);
+
+	return coda_enc_isr(dev);
+}
+
+static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
+{
+	u16 product, major, minor, release;
+	u32 data;
+	u16 *p;
+	int i;
+
+	clk_enable(dev->clk);
+
+	/* Copy the whole firmware image to the code buffer */
+	memcpy(dev->enc_codebuf.vaddr, fw->data, fw->size);
+	/*
+	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
+	 * This memory seems to be big-endian here, which is weird, since
+	 * the internal ARM processor of the coda is little endian.
+	 * Data in this SRAM survives a reboot.
+	 */
+	p = (u16 *)fw->data;
+	for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
+		data = CODA_DOWN_ADDRESS_SET(i) |
+			CODA_DOWN_DATA_SET(p[i ^ 1]);
+		coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
+	}
+	release_firmware(fw);
+
+	/* Tell the BIT where to find everything it needs */
+	coda_write(dev, dev->enc_workbuf.paddr,
+		      CODA_REG_BIT_WORK_BUF_ADDR);
+	coda_write(dev, dev->enc_parabuf.paddr,
+		      CODA_REG_BIT_PARA_BUF_ADDR);
+	coda_write(dev, dev->enc_codebuf.paddr,
+		      CODA_REG_BIT_CODE_BUF_ADDR);
+	coda_write(dev, 0, CODA_REG_BIT_CODE_RUN);
+
+	/* Set default values */
+	coda_write(dev, CODA_STREAM_UNDOCUMENTED,
+		      CODA_REG_BIT_STREAM_CTRL);
+	coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
+	coda_write(dev, CODA_INT_INTERRUPT_ENABLE,
+		      CODA_REG_BIT_INT_ENABLE);
+
+	/* Reset VPU and start processor */
+	data = coda_read(dev, CODA_REG_BIT_CODE_RESET);
+	data |= CODA_REG_RESET_ENABLE;
+	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
+	udelay(10);
+	data &= ~CODA_REG_RESET_ENABLE;
+	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
+	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
+
+	/* Load firmware */
+	coda_write(dev, 0, CODA_CMD_FIRMWARE_VERNUM);
+	if (coda_command_sync(dev, 0, CODA_COMMAND_FIRMWARE_GET)) {
+		v4l2_err(&dev->v4l2_dev, "firmware get command error\n");
+		return -EIO;
+	}
+
+	/* Check we are compatible with the loaded firmware */
+	data = coda_read(dev, CODA_CMD_FIRMWARE_VERNUM);
+	product = CODA_FIRMWARE_PRODUCT(data);
+	major = CODA_FIRMWARE_MAJOR(data);
+	minor = CODA_FIRMWARE_MINOR(data);
+	release = CODA_FIRMWARE_RELEASE(data);
+
+	if ((product != CODA_SUPPORTED_PRODUCT_ID) ||
+	    (major != CODA_SUPPORTED_MAJOR) ||
+	    (minor != CODA_SUPPORTED_MINOR) ||
+	    (release != CODA_SUPPORTED_RELEASE)) {
+		v4l2_err(&dev->v4l2_dev, "Wrong firmware:\n product = 0x%04X\n"
+			" major = %d\n minor = %d\n release = %d\n",
+			product, major, minor, release);
+		return -EINVAL;
+	}
+
+	clk_disable(dev->clk);
+
+	v4l2_info(&dev->v4l2_dev, "Initialized. Fw version: %u.%u.%u.%u", product, major, minor, release);
+
+	return 0;
+}
+
+static void coda_fw_callback(const struct firmware *fw, void *context)
+{
+	struct coda_dev *dev = context;
+	struct platform_device *pdev = dev->plat_dev;
+	struct coda_platform_data *pdata = pdev->dev.platform_data;
+	struct video_device *vfd;
+	int ret;
+
+	if (!fw) {
+		v4l2_err(&dev->v4l2_dev, "firmware request '%s' failed\n",
+			 pdata->firmware);
+		return;
+	}
+
+	ret = coda_hw_init(dev, fw);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
+		return;
+	}
+
+	/* Encoder device */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		return;
+	}
+
+	vfd->fops	= &coda_fops,
+	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
+	vfd->release	= video_device_release,
+	vfd->lock	= &dev->dev_mutex;
+	vfd->v4l2_dev	= &dev->v4l2_dev;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", CODA_ENC_NAME);
+	dev->vfd_enc = vfd;
+	video_set_drvdata(vfd, dev);
+
+	dev->alloc_enc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(dev->alloc_enc_ctx)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
+		goto rel_vdev;
+	}
+
+	dev->m2m_enc_dev = v4l2_m2m_init(get_enc_m2m_ops());
+	if (IS_ERR(dev->m2m_enc_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
+		goto rel_ctx;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto rel_m2m_enc;
+	}
+	v4l2_info(&dev->v4l2_dev, "encoder registered as /dev/video%d\n", vfd->num);
+
+	return;
+
+rel_m2m_enc:
+	v4l2_m2m_release(dev->m2m_enc_dev);
+rel_ctx:
+	vb2_dma_contig_cleanup_ctx(dev->alloc_enc_ctx);
+rel_vdev:
+	video_device_release(vfd);
+
+	return;
+}
+
+static int __devinit coda_probe(struct platform_device *pdev)
+{
+	struct coda_platform_data *pdata;
+	struct coda_dev *dev;
+	struct resource *res;
+	unsigned int bufsize;
+	int ret;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "Invalid platform data\n");
+		return -EINVAL;
+	}
+
+	dev = kzalloc(sizeof *dev, GFP_KERNEL);
+	if (!dev) {
+		dev_err(&pdev->dev, "Not enough memory for %s\n",
+			CODA_NAME);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&dev->irqlock);
+
+	dev->plat_dev = pdev;
+	if (!dev->plat_dev) {
+		dev_err(&pdev->dev, "No platform data specified\n");
+		ret = -ENODEV;
+		goto free_dev;
+	}
+
+	dev->clk = clk_get(&pdev->dev, "vpu");
+	if (IS_ERR(dev->clk)) {
+		ret = PTR_ERR(dev->clk);
+		goto free_dev;
+	}
+
+	/* Get  memory for physical registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region resource\n");
+		ret = -ENOENT;
+		goto free_clk;
+	}
+
+	if (devm_request_mem_region(&pdev->dev, res->start,
+			resource_size(res), CODA_NAME) == NULL) {
+		dev_err(&pdev->dev, "failed to request memory region\n");
+		ret = -ENOENT;
+		goto free_clk;
+	}
+	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
+				      resource_size(res));
+	if (!dev->regs_base) {
+		dev_err(&pdev->dev, "failed to ioremap address region\n");
+		ret = -ENOENT;
+		goto free_clk;
+	}
+
+	/* IRQ */
+	dev->irq = platform_get_irq(pdev, 0);
+	if (dev->irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq resource\n");
+		ret = -ENOENT;
+		goto free_clk;
+	}
+
+	if (devm_request_irq(&pdev->dev, dev->irq, coda_irq_handler,
+		0, CODA_NAME, dev) < 0) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		ret = -ENOENT;
+		goto free_clk;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto free_clk;
+
+	mutex_init(&dev->dev_mutex);
+
+	/* Encoder */
+	/* allocate auxiliary buffers for the BIT processor */
+	bufsize = CODA_CODE_BUF_SIZE + CODA_WORK_BUF_SIZE +
+		CODA_PARA_BUF_SIZE;
+	dev->enc_codebuf.vaddr = dma_alloc_coherent(&pdev->dev, bufsize,
+						    &dev->enc_codebuf.paddr,
+						    GFP_KERNEL);
+	if (!dev->enc_codebuf.vaddr) {
+		dev_err(&pdev->dev, "failed to allocate aux buffers\n");
+		ret = -ENOMEM;
+		goto free_clk;
+	}
+
+	dev->enc_workbuf.vaddr = dev->enc_codebuf.vaddr + CODA_CODE_BUF_SIZE;
+	dev->enc_workbuf.paddr = dev->enc_codebuf.paddr + CODA_CODE_BUF_SIZE;
+	dev->enc_parabuf.vaddr = dev->enc_workbuf.vaddr + CODA_WORK_BUF_SIZE;
+	dev->enc_parabuf.paddr = dev->enc_workbuf.paddr + CODA_WORK_BUF_SIZE;
+
+
+	return request_firmware_nowait(THIS_MODULE, true, pdata->firmware,
+			&pdev->dev, GFP_KERNEL, dev, coda_fw_callback);
+
+free_clk:
+	clk_put(dev->clk);
+free_dev:
+	kfree(dev);
+	return ret;
+}
+
+static int coda_remove(struct platform_device *pdev)
+{
+	struct coda_dev *dev = platform_get_drvdata(pdev);
+	unsigned int bufsize = CODA_CODE_BUF_SIZE + CODA_WORK_BUF_SIZE +
+				CODA_PARA_BUF_SIZE;
+
+	video_unregister_device(dev->vfd_enc);
+	v4l2_m2m_release(dev->m2m_enc_dev);
+	vb2_dma_contig_cleanup_ctx(dev->alloc_enc_ctx);
+	video_device_release(dev->vfd_enc);
+	dma_free_coherent(&pdev->dev, bufsize, &dev->enc_codebuf.vaddr,
+			  dev->enc_codebuf.paddr);
+	clk_put(dev->clk);
+	kfree(dev);
+
+	return 0;
+}
+
+static struct platform_driver coda_driver = {
+	.probe	= coda_probe,
+	.remove	= __devexit_p(coda_remove),
+	.driver	= {
+		.name	= CODA_NAME,
+		.owner	= THIS_MODULE,
+		/* TODO: pm ops? */
+	},
+};
+
+module_platform_driver(coda_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com>");
+MODULE_DESCRIPTION("CodaDx6 multi-standard codec V4L2 driver");
diff --git a/drivers/media/video/coda/coda_regs.h b/drivers/media/video/coda/coda_regs.h
new file mode 100644
index 0000000..f6442c4
--- /dev/null
+++ b/drivers/media/video/coda/coda_regs.h
@@ -0,0 +1,223 @@
+/*
+ * linux/drivers/media/video/coda/coda_regs.h
+ *
+ * Copyright (C) 2012 Vista Silicon SL
+ *    Javier Martin <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _REGS_CODA_H_
+#define _REGS_CODA_H_
+
+/* HW registers */
+#define CODA_REG_BIT_CODE_RUN		0x000
+#define		CODA_REG_RUN_ENABLE		(1 << 0)
+#define CODA_REG_BIT_CODE_DOWN		0x004
+/* Internal SRAM short address in the BIT */
+#define 	CODA_DOWN_ADDRESS_SET(x)	(((x) & 0xffff) << 16)
+#define		CODA_DOWN_DATA_SET(x)	((x) & 0xffff)
+#define CODA_REG_BIT_HOST_IN_REQ		0x008
+#define CODA_REG_BIT_INT_CLEAR		0x00C
+#define		CODA_REG_BIT_INT_CLEAR_SET	0x1
+#define CODA_REG_BIT_INT_STATUS		0x010
+#define CODA_REG_BIT_CODE_RESET		0x014
+#define		CODA_REG_RESET_ENABLE	(1 << 0)
+#define CODA_REG_BIT_CUR_PC			0x018
+
+/* Static SW registers */
+#define CODA_REG_BIT_CODE_BUF_ADDR		0x100
+#define CODA_REG_BIT_WORK_BUF_ADDR		0x104
+#define CODA_REG_BIT_PARA_BUF_ADDR		0x108
+#define CODA_REG_BIT_STREAM_CTRL		0x10C
+#define		CODA_STREAM_UNDOCUMENTED	(1 << 2)
+		/* Stream Full Empty Check Disable */
+#define 	CODA_STREAM_CHKDIS_OFFSET	(1 << 1)
+		/* Stream Endianess */
+#define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
+#define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
+		/* Image Endianess */
+#define 	CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
+#define CODA_REG_BIT_RD_PTR_0              0x120
+#define CODA_REG_BIT_WR_PTR_0              0x124
+#define CODA_REG_BIT_SEARCH_RAM_BASE_ADDR  0x140
+#define CODA_REG_BIT_BUSY			0x160
+#define 	CODA_REG_BIT_BUSY_FLAG	1
+#define CODA_REG_BIT_RUN_COMMAND           0x164
+#define 	CODA_COMMAND_SEQ_INIT                         1
+#define 	CODA_COMMAND_SEQ_END                          2
+#define 	CODA_COMMAND_PIC_RUN                          3
+#define 	CODA_COMMAND_SET_FRAME_BUF                    4
+#define 	CODA_COMMAND_ENCODE_HEADER                    5
+#define 	CODA_COMMAND_ENC_PARA_SET                     6
+#define 	CODA_COMMAND_DEC_PARA_SET                     7
+#define 	CODA_COMMAND_DEC_BUF_FLUSH                    8
+#define 	CODA_COMMAND_RC_CHANGE_PARAMETER              9
+#define 	CODA_COMMAND_FIRMWARE_GET                     0xf
+#define CODA_REG_BIT_RUN_INDEX		0x168
+#define		CODA_INDEX_SET(x)		((x) & 0x3)
+#define CODA_REG_BIT_RUN_COD_STD		0x16C
+#define 	CODA_MODE_DECODE_M4S2	0
+#define 	CODA_MODE_ENCODE_M4S2	1
+#define 	CODA_MODE_DECODE_H264	2
+#define 	CODA_MODE_ENCODE_H264	3
+#define 	CODA_MODE_DECODE_WVC1	4
+#define 	CODA_MODE_INVALID		0xffff
+#define CODA_REG_BIT_INT_ENABLE		0x170
+#define		CODA_INT_INTERRUPT_ENABLE	(1 << 3)
+
+/*
+ * Commands' mailbox:
+ * registers with offsets in the range 0x180-0x1D0
+ * have different meaning depending on the command being
+ * issued.
+ */
+/* Encoder Sequence Initialization */
+#define CODA_CMD_ENC_SEQ_BB_START          0x180
+#define CODA_CMD_ENC_SEQ_BB_SIZE           0x184
+#define CODA_CMD_ENC_SEQ_OPTION            0x188
+#define 	CODA_OPTION_GAMMA_OFFSET                      7
+#define 	CODA_OPTION_GAMMA_MASK                        0x01
+#define 	CODA_OPTION_LIMITQP_OFFSET                    6
+#define 	CODA_OPTION_LIMITQP_MASK                      0x01
+#define 	CODA_OPTION_RCINTRAQP_OFFSET                  5
+#define 	CODA_OPTION_RCINTRAQP_MASK                    0x01
+#define 	CODA_OPTION_FMO_OFFSET                        4
+#define 	CODA_OPTION_FMO_MASK                          0x01
+// /* There is no bit 3 */
+// #define 	CODA_OPTION_AUD_OFFSET                        2
+// #define 	CODA_OPTION_AUD_MASK                          0x01
+#define 	CODA_OPTION_SLICEREPORT_OFFSET                1
+#define 	CODA_OPTION_SLICEREPORT_MASK                  0x01
+// /* There is no bit 0 */
+#define CODA_CMD_ENC_SEQ_COD_STD           0x18C
+#define 	CODA_ENCODE_MPEG4                             0
+#define 	CODA_ENCODE_H263                              1
+#define 	CODA_ENCODE_H264                              2
+#define CODA_CMD_ENC_SEQ_SRC_SIZE          0x190
+#define 	CODA_PICWIDTH_OFFSET                          10
+#define 	CODA_PICWIDTH_MASK                            0x3ff
+#define 	CODA_PICHEIGHT_OFFSET                         0
+#define 	CODA_PICHEIGHT_MASK                           0x3ff
+#define CODA_CMD_ENC_SEQ_SRC_F_RATE        0x194
+#define CODA_CMD_ENC_SEQ_MP4_PARA          0x198
+#define 	CODA_MP4PARAM_VERID_OFFSET                    6
+#define 	CODA_MP4PARAM_VERID_MASK                      0x01
+/* intra_dc_vlc_thr in MPEG-4 part 2 standard: unsigned [0:7] */
+#define 	CODA_MP4PARAM_INTRADCVLCTHR_OFFSET            2
+#define 	CODA_MP4PARAM_INTRADCVLCTHR_MASK              0x07
+#define 	CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET      1
+#define 	CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK        0x01
+#define 	CODA_MP4PARAM_DATAPARTITIONENABLE_OFFSET      0
+#define 	CODA_MP4PARAM_DATAPARTITIONENABLE_MASK        0x01
+// #define CODA_CMD_ENC_SEQ_263_PARA          0x19C
+// #define 	CODA_263PARAM_ANNEXJENABLE_OFFSET             2
+// #define 	CODA_263PARAM_ANNEXJENABLE_MASK               0x01
+// #define 	CODA_263PARAM_ANNEXKENABLE_OFFSET             1
+// #define 	CODA_263PARAM_ANNEXKENABLE_MASK               0x01
+// #define 	CODA_263PARAM_ANNEXTENABLE_OFFSET             0
+// #define 	CODA_263PARAM_ANNEXTENABLE_MASK               0x01
+#define CODA_CMD_ENC_SEQ_264_PARA          0x1A0
+/* deblk_filter_offset_alpha: signed [-6:6] */
+#define 	CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET    12
+#define 	CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK      0x0f
+/* deblk_filter_offset_beta: signed [-6:6] */
+#define 	CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET   8
+#define 	CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK     0x0f
+#define 	CODA_264PARAM_DISABLEDEBLK_OFFSET             6
+#define 	CODA_264PARAM_DISABLEDEBLK_MASK               0x01
+#define 	CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET 5
+#define 	CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK   0x01
+/* chroma_qp_offset: signed [-12:12] */
+#define 	CODA_264PARAM_CHROMAQPOFFSET_OFFSET           0
+#define 	CODA_264PARAM_CHROMAQPOFFSET_MASK             0x1f
+#define CODA_CMD_ENC_SEQ_SLICE_MODE        0x1A4
+/* Slice size */
+#define 	CODA_SLICING_SIZE_OFFSET                      2
+#define 	CODA_SLICING_SIZE_MASK                        0x3fffffff
+/* Unit used for slice size: 0 = bits per slice, 1 = Macroblocks per slice */
+#define 	CODA_SLICING_UNIT_OFFSET                      1
+#define 	CODA_SLICING_UNIT_MASK                        0x01
+/* Slicing mode: 0 = One slice per picture, 1 = Multiple slices per picture */
+#define 	CODA_SLICING_MODE_OFFSET                      0
+#define 	CODA_SLICING_MODE_MASK                        0x01
+#define CODA_CMD_ENC_SEQ_GOP_SIZE          0x1A8
+/* GOP Size: 0 = Only first picture is Intra, 1 = All pictures are Intra
+             n from 2 to 60 = One picture out of n is Intra */
+#define 	CODA_GOP_SIZE_OFFSET                          0
+#define 	CODA_GOP_SIZE_MASK                            0x3f
+#define CODA_CMD_ENC_SEQ_RC_PARA           0x1AC
+/* Disable autoskip: 1 = Do not skip a frame if bitstream is bigger than specified */
+#define 	CODA_RATECONTROL_AUTOSKIP_OFFSET              31
+#define 	CODA_RATECONTROL_AUTOSKIP_MASK                0x01
+/* Initial delay: time in ms to fill the VBV buffer */
+#define 	CODA_RATECONTROL_INITIALDELAY_OFFSET          16
+#define 	CODA_RATECONTROL_INITIALDELAY_MASK            0x7f
+/* Bitrate: in kilobits per seconds */
+#define 	CODA_RATECONTROL_BITRATE_OFFSET               1
+#define 	CODA_RATECONTROL_BITRATE_MASK                 0x7f
+#define 	CODA_RATECONTROL_ENABLE_OFFSET                0
+#define 	CODA_RATECONTROL_ENABLE_MASK                  0x01
+#define CODA_CMD_ENC_SEQ_RC_BUF_SIZE       0x1B0
+#define CODA_CMD_ENC_SEQ_INTRA_REFRESH     0x1B4
+#define CODA_CMD_ENC_SEQ_FMO               0x1B8
+/* Flexible Macroblock Ordering type: 0 = interleaved, 1 = dispersed */
+#define 	CODA_FMOPARAM_TYPE_OFFSET                     4
+#define 	CODA_FMOPARAM_TYPE_MASK                       1
+/* Flexible Macroblock Ordering Slice Number: unsigned [2:8] */
+#define 	CODA_FMOPARAM_SLICENUM_OFFSET                 0
+#define 	CODA_FMOPARAM_SLICENUM_MASK                   0x0f
+// #define CODA_CMD_ENC_SEQ_INTRA_QP          0x1BC
+#define CODA_CMD_ENC_SEQ_RC_QP_MAX         0x1C8
+/* QP: from 1 to 51 in H.264 */
+#define 	CODA_QPMAX_OFFSET                             0
+#define 	CODA_QPMAX_MASK                               0x3f
+#define CODA_CMD_ENC_SEQ_RC_GAMMA          0x1CC
+#define 	CODA_GAMMA_OFFSET                             0
+#define 	CODA_GAMMA_MASK                               0xffff
+#define CODA_RET_ENC_SEQ_SUCCESS           0x1C0
+
+// /* Encoder Picture Run */
+#define CODA_CMD_ENC_PIC_SRC_ADDR_Y        0x180
+#define CODA_CMD_ENC_PIC_SRC_ADDR_CB       0x184
+#define CODA_CMD_ENC_PIC_SRC_ADDR_CR       0x188
+#define CODA_CMD_ENC_PIC_QS                0x18C
+#define CODA_CMD_ENC_PIC_ROT_MODE          0x190
+#define CODA_CMD_ENC_PIC_OPTION            0x194
+#define CODA_CMD_ENC_PIC_BB_START          0x198
+#define CODA_CMD_ENC_PIC_BB_SIZE           0x19C
+#define CODA_RET_ENC_PIC_TYPE              0x1C4
+#define CODA_RET_ENC_PIC_SLICE_NUM         0x1CC
+#define CODA_RET_ENC_PIC_FLAG              0x1D0
+
+/* Set Frame Buffer */
+#define CODA_CMD_SET_FRAME_BUF_NUM         0x180
+#define CODA_CMD_SET_FRAME_BUF_STRIDE      0x184
+
+/* Encoder Header */
+#define CODA_CMD_ENC_HEADER_CODE           0x180
+#define 	CODA_GAMMA_OFFSET                             0
+#define 	CODA_HEADER_H264_SPS                          0
+#define 	CODA_HEADER_H264_PPS                          1
+#define 	CODA_HEADER_MP4V_VOL                          0
+#define 	CODA_HEADER_MP4V_VOS                          1
+#define 	CODA_HEADER_MP4V_VIS                          2
+#define CODA_CMD_ENC_HEADER_BB_START       0x184
+#define CODA_CMD_ENC_HEADER_BB_SIZE        0x188
+
+// /* Set Encoder Parameter */
+// #define CODA_CMD_ENC_PARA_SET_TYPE         0x180
+// #define CODA_RET_ENC_PARA_SET_SIZE         0x1c0
+// 
+/* Get Version */
+#define CODA_CMD_FIRMWARE_VERNUM		0x1c0
+#define		CODA_FIRMWARE_PRODUCT(x)	(((x) >> 16) & 0xffff)
+#define		CODA_FIRMWARE_MAJOR(x)	(((x) >> 12) & 0x0f)
+#define		CODA_FIRMWARE_MINOR(x)	(((x) >> 8) & 0x0f)
+#define		CODA_FIRMWARE_RELEASE(x)	((x) & 0xff)
+
+#endif
diff --git a/drivers/media/video/m2m-deinterlace.c b/drivers/media/video/m2m-deinterlace.c
new file mode 100644
index 0000000..5253bcd
--- /dev/null
+++ b/drivers/media/video/m2m-deinterlace.c
@@ -0,0 +1,1183 @@
+/*
+ * Support eMMa-PrP through mem2mem framework.
+ *
+ * eMMa-PrP is a piece of HW that allows fetching buffers
+ * from one memory location and do several operations on
+ * them such as scaling or format conversion giving, as a result
+ * a new processed buffer in another memory location.
+ *
+ * Based on mem2mem_testdev.c by Pawel Osciak.
+ *
+ * Copyright (c) 2011 Vista Silicon S.L.
+ * Javier Martin <javier.martin@vista-silicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+// #define DEBUG
+
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
+
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#define MEM2MEM_TEST_MODULE_NAME "mem2mem-deinterlace"
+
+MODULE_DESCRIPTION("mem2mem device which supports eMMa-PrP present in mx2 SoCs");
+MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.1");
+
+static bool debug = false;
+module_param(debug, bool, 0644);
+
+#define MIN_W 32
+#define MIN_H 32
+#define MAX_W 2040
+#define MAX_H 2046
+
+#define W_ALIGN_MASK_YUV420	0x07 /* multiple of 8 */
+#define W_ALIGN_MASK_OTHERS	0x03 /* multiple of 4 */
+#define H_ALIGN_MASK		0x01 /* multiple of 2 */
+
+/* Flags that indicate a format can be used for capture/output */
+#define MEM2MEM_CAPTURE	(1 << 0)
+#define MEM2MEM_OUTPUT	(1 << 1)
+
+#define MEM2MEM_NAME		"m2m-deinterlace"
+
+/* In bytes, per queue */
+#define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
+
+#define dprintk(dev, fmt, arg...) \
+	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+
+#define DST_QUEUE_OFF_BASE	(1 << 30)
+
+/* EMMA PrP */
+#define PRP_CNTL                        0x00
+#define PRP_INTR_CNTL                   0x04
+#define PRP_INTRSTATUS                  0x08
+#define PRP_SOURCE_Y_PTR                0x0c
+#define PRP_SOURCE_CB_PTR               0x10
+#define PRP_SOURCE_CR_PTR               0x14
+#define PRP_DEST_RGB1_PTR               0x18
+#define PRP_DEST_RGB2_PTR               0x1c
+#define PRP_DEST_Y_PTR                  0x20
+#define PRP_DEST_CB_PTR                 0x24
+#define PRP_DEST_CR_PTR                 0x28
+#define PRP_SRC_FRAME_SIZE              0x2c
+#define PRP_DEST_CH1_LINE_STRIDE        0x30
+#define PRP_SRC_PIXEL_FORMAT_CNTL       0x34
+#define PRP_CH1_PIXEL_FORMAT_CNTL       0x38
+#define PRP_CH1_OUT_IMAGE_SIZE          0x3c
+#define PRP_CH2_OUT_IMAGE_SIZE          0x40
+#define PRP_SRC_LINE_STRIDE             0x44
+#define PRP_CSC_COEF_012                0x48
+#define PRP_CSC_COEF_345                0x4c
+#define PRP_CSC_COEF_678                0x50
+#define PRP_CH1_RZ_HORI_COEF1           0x54
+#define PRP_CH1_RZ_HORI_COEF2           0x58
+#define PRP_CH1_RZ_HORI_VALID           0x5c
+#define PRP_CH1_RZ_VERT_COEF1           0x60
+#define PRP_CH1_RZ_VERT_COEF2           0x64
+#define PRP_CH1_RZ_VERT_VALID           0x68
+#define PRP_CH2_RZ_HORI_COEF1           0x6c
+#define PRP_CH2_RZ_HORI_COEF2           0x70
+#define PRP_CH2_RZ_HORI_VALID           0x74
+#define PRP_CH2_RZ_VERT_COEF1           0x78
+#define PRP_CH2_RZ_VERT_COEF2           0x7c
+#define PRP_CH2_RZ_VERT_VALID           0x80
+
+#define PRP_CNTL_CH1EN          (1 << 0)
+#define PRP_CNTL_CH2EN          (1 << 1)
+#define PRP_CNTL_CSIEN          (1 << 2)
+#define PRP_CNTL_DATA_IN_YUV420 (0 << 3)
+#define PRP_CNTL_DATA_IN_YUV422 (1 << 3)
+#define PRP_CNTL_DATA_IN_RGB16  (2 << 3)
+#define PRP_CNTL_DATA_IN_RGB32  (3 << 3)
+#define PRP_CNTL_CH1_OUT_RGB8   (0 << 5)
+#define PRP_CNTL_CH1_OUT_RGB16  (1 << 5)
+#define PRP_CNTL_CH1_OUT_RGB32  (2 << 5)
+#define PRP_CNTL_CH1_OUT_YUV422 (3 << 5)
+#define PRP_CNTL_CH2_OUT_YUV420 (0 << 7)
+#define PRP_CNTL_CH2_OUT_YUV422 (1 << 7)
+#define PRP_CNTL_CH2_OUT_YUV444 (2 << 7)
+#define PRP_CNTL_CH1_LEN        (1 << 9)
+#define PRP_CNTL_CH2_LEN        (1 << 10)
+#define PRP_CNTL_SKIP_FRAME     (1 << 11)
+#define PRP_CNTL_SWRST          (1 << 12)
+#define PRP_CNTL_CLKEN          (1 << 13)
+#define PRP_CNTL_WEN            (1 << 14)
+#define PRP_CNTL_CH1BYP         (1 << 15)
+#define PRP_CNTL_IN_TSKIP(x)    ((x) << 16)
+#define PRP_CNTL_CH1_TSKIP(x)   ((x) << 19)
+#define PRP_CNTL_CH2_TSKIP(x)   ((x) << 22)
+#define PRP_CNTL_INPUT_FIFO_LEVEL(x)    ((x) << 25)
+#define PRP_CNTL_RZ_FIFO_LEVEL(x)       ((x) << 27)
+#define PRP_CNTL_CH2B1EN        (1 << 29)
+#define PRP_CNTL_CH2B2EN        (1 << 30)
+#define PRP_CNTL_CH2FEN         (1 << 31)
+
+#define PRP_SIZE_HEIGHT(x)	(x)
+#define PRP_SIZE_WIDTH(x)	((x) << 16)
+
+/* IRQ Enable and status register */
+#define PRP_INTR_RDERR          (1 << 0)
+#define PRP_INTR_CH1WERR        (1 << 1)
+#define PRP_INTR_CH2WERR        (1 << 2)
+#define PRP_INTR_CH1FC          (1 << 3)
+#define PRP_INTR_CH2FC          (1 << 5)
+#define PRP_INTR_LBOVF          (1 << 7)
+#define PRP_INTR_CH2OVF         (1 << 8)
+
+#define PRP_INTR_ST_RDERR	(1 << 0)
+#define PRP_INTR_ST_CH1WERR	(1 << 1)
+#define PRP_INTR_ST_CH2WERR	(1 << 2)
+#define PRP_INTR_ST_CH2B2CI	(1 << 3)
+#define PRP_INTR_ST_CH2B1CI	(1 << 4)
+#define PRP_INTR_ST_CH1B2CI	(1 << 5)
+#define PRP_INTR_ST_CH1B1CI	(1 << 6)
+#define PRP_INTR_ST_LBOVF	(1 << 7)
+#define PRP_INTR_ST_CH2OVF	(1 << 8)
+
+struct emmaprp_fmt {
+	char	*name;
+	u32	fourcc;
+	enum v4l2_field field;
+	/* Types the format can be used for */
+	u32	types;
+};
+
+static struct emmaprp_fmt formats[] = {
+	{
+		.name	= "YUV 4:2:0 Planar",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.field	= V4L2_FIELD_NONE,
+		.types	= MEM2MEM_CAPTURE,
+	},
+	{
+		.name	= "YUV 4:2:0 Planar",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.field	= V4L2_FIELD_SEQ_TB,
+		.types	= MEM2MEM_OUTPUT,
+	},
+};
+
+/* Per-queue, driver-specific private data */
+struct emmaprp_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		sizeimage;
+	struct emmaprp_fmt	*fmt;
+};
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+enum {
+	YUV420_DMA_Y_ODD,
+	YUV420_DMA_Y_EVEN,
+	YUV420_DMA_U_ODD,
+	YUV420_DMA_U_EVEN,
+	YUV420_DMA_V_ODD,
+	YUV420_DMA_V_EVEN,
+};
+// static void emmaprp_dma_task(unsigned long data);
+//
+// static unsigned long my_tasklet_data;
+//
+// DECLARE_TASKLET( my_tasklet, emmaprp_dma_task,
+// 		 (unsigned long) &my_tasklet_data );
+
+/* Source and destination queue data */
+static struct emmaprp_q_data q_data[2];
+
+static struct emmaprp_q_data *get_q_data(enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &q_data[V4L2_M2M_SRC];
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &q_data[V4L2_M2M_DST];
+	default:
+		BUG();
+	}
+	return NULL;
+}
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct emmaprp_fmt *find_format(struct v4l2_format *f)
+{
+	struct emmaprp_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &formats[k];
+		if ((fmt->types == f->type) &&
+			(fmt->fourcc == f->fmt.pix.pixelformat))
+			break;
+	}
+
+	if (k == NUM_FORMATS)
+		return NULL;
+
+	return &formats[k];
+}
+
+struct emmaprp_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd;
+
+	atomic_t		busy;
+	struct mutex		dev_mutex;
+	spinlock_t		irqlock;
+
+	struct dma_chan		*dma_chan;
+
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct vb2_alloc_ctx	*alloc_ctx;
+};
+
+struct emmaprp_ctx {
+	struct emmaprp_dev	*dev;
+
+	/* Abort requested by m2m */
+	int			aborting;
+	dma_cookie_t		cookie;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+};
+
+/*
+ * mem2mem callbacks
+ */
+static int emmaprp_job_ready(void *priv)
+{
+	struct emmaprp_ctx *ctx = priv;
+	struct emmaprp_dev *pcdev = ctx->dev;
+
+//printk("%s\n", __func__);
+	if ((v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) > 0)
+	    && (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) > 0)
+	    && (atomic_read(&ctx->dev->busy) == 0)) {
+//printk("%s: task ready to run\n", __func__);
+		return 1;
+	}
+
+	dprintk(pcdev, "Task not ready to run\n");
+
+	return 0;
+}
+
+static void emmaprp_job_abort(void *priv)
+{
+	struct emmaprp_ctx *ctx = priv;
+	struct emmaprp_dev *pcdev = ctx->dev;
+
+	ctx->aborting = 1;
+
+	dprintk(pcdev, "Aborting task\n");
+
+	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
+}
+
+static void emmaprp_lock(void *priv)
+{
+	struct emmaprp_ctx *ctx = priv;
+	struct emmaprp_dev *pcdev = ctx->dev;
+	mutex_lock(&pcdev->dev_mutex);
+}
+
+static void emmaprp_unlock(void *priv)
+{
+	struct emmaprp_ctx *ctx = priv;
+	struct emmaprp_dev *pcdev = ctx->dev;
+	mutex_unlock(&pcdev->dev_mutex);
+}
+
+static void dma_callback(void *data)
+{
+	struct emmaprp_ctx *curr_ctx = data;
+	struct emmaprp_dev *pcdev = curr_ctx->dev;
+	struct vb2_buffer *src_vb, *dst_vb;
+
+// 	printk("%s: all transfers ended!!\n", __func__);
+	atomic_set(&pcdev->busy, 0);
+
+	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+	dst_vb->v4l2_buf.sequence = src_vb->v4l2_buf.sequence;
+	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+
+// irq_ok:
+	//printk("%s: job_finish\n", __func__);
+	v4l2_m2m_job_finish(pcdev->m2m_dev, curr_ctx->m2m_ctx);
+
+}
+
+static void emmaprp_issue_dma(struct emmaprp_ctx *ctx, int op)
+{
+	struct emmaprp_q_data *s_q_data, *d_q_data;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct emmaprp_dev *pcdev = ctx->dev;
+	struct dma_chan *chan = pcdev->dma_chan;
+	struct dma_device *dmadev = chan->device;
+	struct dma_async_tx_descriptor *tx;
+	struct dma_interleaved_template *xt;
+	unsigned int s_width, s_height;
+	unsigned int d_width, d_height;
+	unsigned int d_size, s_size;
+	dma_addr_t p_in, p_out;
+	enum dma_ctrl_flags flags;
+
+	xt = kzalloc(sizeof(struct dma_async_tx_descriptor)
+			+ sizeof(struct data_chunk), GFP_KERNEL);
+	if (!xt)
+		printk("MALLOC ERROR!!!!!\n");
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+	s_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	s_width	= s_q_data->width;
+	s_height = s_q_data->height;
+	s_size = s_width * s_height;
+
+	d_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	d_width = d_q_data->width;
+	d_height = d_q_data->height;
+	d_size = d_width * d_height;
+
+	/* FIXME: try/set_fmt must adjust this properly */
+	BUG_ON(d_size != s_size);
+	//printk("%s 6\n", __func__);
+	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	if (!p_in || !p_out) {
+		v4l2_err(&pcdev->v4l2_dev,
+			 "Acquiring kernel pointers to buffers failed\n");
+		return;
+	}
+
+	//printk("%s p_in = %p, p_out = %p\n", __func__, p_in, p_out);
+	switch (op) {
+		case YUV420_DMA_Y_ODD:
+			//printk("%s: YUV420_DMA_Y_ODD\n", __func__);
+// 			printk("%s: s_width = %d\n", __func__, s_width);
+			xt->numf = s_height / 2;
+			xt->sgl[0].size = s_width;
+			xt->sgl[0].icg = s_width;
+			xt->src_start = p_in;
+			xt->dst_start = p_out;
+			break;
+		case YUV420_DMA_Y_EVEN:
+			//printk("%s: YUV420_DMA_Y_EVEN\n", __func__);
+			xt->numf = s_height / 2;
+			xt->sgl[0].size = s_width;
+			xt->sgl[0].icg = s_width;
+			xt->src_start = p_in + s_size / 2;
+			xt->dst_start = p_out + s_width;
+			break;
+		case YUV420_DMA_U_ODD:
+			//printk("%s: YUV420_DMA_U_ODD\n", __func__);
+			xt->numf = s_height / 4;
+			xt->sgl[0].size = s_width / 2;
+			xt->sgl[0].icg = s_width / 2;
+			xt->src_start = p_in + s_size;
+			xt->dst_start = p_out + s_size;
+			break;
+		case YUV420_DMA_U_EVEN:
+			//printk("%s: YUV420_DMA_U_EVEN\n", __func__);
+			xt->numf = s_height / 4;
+			xt->sgl[0].size = s_width / 2;
+			xt->sgl[0].icg = s_width / 2;
+			xt->src_start = p_in + (9 * s_size) / 8;
+			xt->dst_start = p_out + s_size + s_width / 2;
+			break;
+		case YUV420_DMA_V_ODD:
+			//printk("%s: YUV420_DMA_V_ODD\n", __func__);
+			xt->numf = s_height / 4;
+			xt->sgl[0].size = s_width / 2;
+			xt->sgl[0].icg = s_width / 2;
+			xt->src_start = p_in + (5 * s_size) / 4;
+			xt->dst_start = p_out + (5 * s_size) / 4;
+			break;
+		case YUV420_DMA_V_EVEN:
+		default:
+			//printk("%s: YUV420_DMA_V_EVEN\n", __func__);
+			xt->numf = s_height / 4;
+			xt->sgl[0].size = s_width / 2;
+			xt->sgl[0].icg = s_width / 2;
+			xt->src_start = p_in + (11 * s_size) / 8;
+			xt->dst_start = p_out + (5 * s_size) / 4 + s_width / 2;
+			break;
+	}
+	//printk("%s 8\n", __func__);
+	/* Common parameters for al transfers */
+// 	xt.sgl[0].size = chunk.size;
+// 	xt.sgl[0].icg = chunk.icg;
+	xt->frame_size = 1;
+	xt->dir = DMA_MEM_TO_MEM;
+	xt->src_sgl = false;
+	xt->dst_sgl = true;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
+		DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP;
+// 	printk("%s: 3 ctx = %p \n", __func__, ctx);
+	tx = dmadev->device_prep_interleaved_dma(chan, xt, flags);
+// 	tx = dmadev->device_prep_interleaved_dma(chan, NULL, flags);
+	if (tx == NULL) {
+		v4l2_warn(&pcdev->v4l2_dev, "DMA interleaved prep error\n");
+		printk("%s: lolz ctx = %p \n", __func__, ctx);
+		return;
+	}
+//        tx = dmadev->device_prep_dma_memcpy(chan, p_out, p_in, s_size * 3/2, flags);
+//        if (tx == NULL) {
+//                v4l2_warn(&pcdev->v4l2_dev,
+//                          "DMA prep error with src=0x%x dst=0x%x len=%d\n",
+//                          p_in, p_out, s_size * 3/2);
+//                return;
+//        }
+// 	//printk("%s 9\n", __func__);
+// printk("%s: 4 ctx = %p\n", __func__, ctx);
+	if (op == YUV420_DMA_V_EVEN) {
+		tx->callback = dma_callback;
+		tx->callback_param = ctx;
+	}
+// printk("%s: 5 ctx = %p\n", __func__, ctx);
+	ctx->cookie = dmaengine_submit(tx);
+// printk("%s: 6 ctx = %p\n", __func__, ctx);
+	//printk("%s 10\n", __func__);
+	if (dma_submit_error(ctx->cookie)) {
+		v4l2_warn(&pcdev->v4l2_dev,
+			  "DMA submit error %d with src=0x%x dst=0x%x len=0x%x\n",
+			  ctx->cookie, p_in, p_out, s_size * 3/2);
+		return;
+	}
+// printk("%s: 7 ctx = %p\n", __func__, ctx);
+	//printk("%s 11\n", __func__);
+	dma_async_issue_pending(chan);
+// // 	while (1) {
+// // 		if (dma_async_memcpy_complete(chan, ctx->cookie, NULL, NULL))
+// // 			break;
+// // 		else
+// // 			schedule();
+// // 	}
+// 		if (irqs_disabled())
+// 			printk("%s: IRQS DISABLED!!\n", __func__);
+// 	dma_sync_wait(chan, ctx->cookie);
+// 	printk("%s 12 ctx = %p\n", __func__, ctx);
+	kfree(xt);
+}
+
+// static void emmaprp_dma_task(unsigned long data)
+// {
+// 	struct emmaprp_dev *pcdev = (struct emmaprp_dev *)my_tasklet_data;
+// 	struct dma_chan *chan = pcdev->dma_chan;
+// 	struct vb2_buffer *src_vb, *dst_vb;
+// 	struct emmaprp_ctx *curr_ctx;
+//
+// 	//printk("%s: pcdev: %p\n", __func__, pcdev);
+// 	//printk("%s: pcdev->m2m_dev: %p\n", __func__, pcdev->m2m_dev);
+// 	//printk("%s: my_tasklet_data = %p\n", __func__, my_tasklet_data);
+// // 	curr_ctx = v4l2_m2m_get_curr_priv(pcdev->m2m_dev);
+// // 	if (NULL == curr_ctx) {
+// // 		printk(KERN_ERR
+// // 			"Instance released before the end of transaction\n");
+// // 		return;
+// // 	}
+//
+// 	if (curr_ctx->aborting)
+// 		return; /*FIXME*/
+// printk("%s: 1\n", __func__);
+// 	emmaprp_issue_dma(curr_ctx, YUV420_DMA_Y_ODD);
+// printk("%s: 2\n", __func__);
+// 	emmaprp_issue_dma(curr_ctx, YUV420_DMA_Y_EVEN);
+// printk("%s: 3\n", __func__);
+// 	emmaprp_issue_dma(curr_ctx, YUV420_DMA_U_ODD);
+// printk("%s: 4\n", __func__);
+// 	emmaprp_issue_dma(curr_ctx, YUV420_DMA_U_EVEN);
+// printk("%s: 5\n", __func__);
+// 	emmaprp_issue_dma(curr_ctx, YUV420_DMA_V_ODD);
+// printk("%s: 6\n", __func__);
+// 	emmaprp_issue_dma(curr_ctx, YUV420_DMA_V_EVEN);
+// printk("%s: 7\n", __func__);
+// 	dma_async_issue_pending(chan);
+// printk("%s: 8\n", __func__);
+// }
+
+static void emmaprp_device_run(void *priv)
+{
+	struct emmaprp_ctx *ctx = priv;
+	struct emmaprp_dev *pcdev = ctx->dev;
+	struct dma_chan *chan = pcdev->dma_chan;
+
+	atomic_set(&ctx->dev->busy, 1);
+
+	//printk("%s: pcdev = %p\n", __func__, pcdev);
+	//printk("%s: pcdev->m2m_dev = %p\n", __func__, pcdev->m2m_dev);
+
+// 	my_tasklet_data = (unsigned long)pcdev;
+	//printk("%s: my_tasklet_data = %p\n", __func__, my_tasklet_data);
+// 	tasklet_schedule(&my_tasklet);
+// 	emmaprp_dma_task((unsigned long) pcdev);
+// printk("%s: 1 ctx = %p\n", __func__, ctx);
+	emmaprp_issue_dma(ctx, YUV420_DMA_Y_ODD);
+// printk("%s: 2 ctx = %p\n", __func__, ctx);
+	emmaprp_issue_dma(ctx, YUV420_DMA_Y_EVEN);
+// printk("%s: 3 ctx = %p\n", __func__, ctx);
+	emmaprp_issue_dma(ctx, YUV420_DMA_U_ODD);
+// printk("%s: 4 ctx = %p\n", __func__, ctx);
+	emmaprp_issue_dma(ctx, YUV420_DMA_U_EVEN);
+// printk("%s: 5 ctx = %p\n", __func__, ctx);
+	emmaprp_issue_dma(ctx, YUV420_DMA_V_ODD);
+// printk("%s: 6 ctx = %p\n", __func__, ctx);
+	emmaprp_issue_dma(ctx, YUV420_DMA_V_EVEN);
+// printk("%s: 7 ctx = %p\n", __func__, ctx);
+	dma_async_issue_pending(chan);
+// printk("%s: 8 ctx = %p\n", __func__, ctx);
+}
+
+/*
+ * video ioctls
+ */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+			  | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
+{
+	int i, num;
+	struct emmaprp_fmt *fmt;
+
+	num = 0;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		if (formats[i].types & type) {
+			/* index-th format of type type found ? */
+			if (num == f->index)
+				break;
+			/* Correct type but haven't reached our index yet,
+			 * just increment per-type index */
+			++num;
+		}
+	}
+
+	if (i < NUM_FORMATS) {
+		/* Format found */
+		fmt = &formats[i];
+		strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+		f->pixelformat = fmt->fourcc;
+		return 0;
+	}
+
+	/* Format not found */
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(f, MEM2MEM_CAPTURE);
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(f, MEM2MEM_OUTPUT);
+}
+
+static int vidioc_g_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct emmaprp_q_data *q_data;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(f->type);
+
+	f->fmt.pix.width	= q_data->width;
+	f->fmt.pix.height	= q_data->height;
+	f->fmt.pix.field	= q_data->fmt->field;
+	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
+	f->fmt.pix.bytesperline = q_data->width * 3 / 2;
+	f->fmt.pix.sizeimage	= q_data->sizeimage;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(priv, f);
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(priv, f);
+}
+
+static int vidioc_try_fmt(struct v4l2_format *f, struct emmaprp_fmt *fmt)
+{
+	struct emmaprp_q_data *q_data = get_q_data(f->type);
+	enum v4l2_field field = q_data->fmt->field;
+
+	/* V4L2 specification suggests the driver corrects the format struct
+	 * if any of the dimensions is unsupported */
+	f->fmt.pix.field = field;
+
+	if (f->fmt.pix.height < MIN_H)
+		f->fmt.pix.height = MIN_H;
+	else if (f->fmt.pix.height > MAX_H)
+		f->fmt.pix.height = MAX_H;
+
+	if (f->fmt.pix.width < MIN_W)
+		f->fmt.pix.width = MIN_W;
+	else if (f->fmt.pix.width > MAX_W)
+		f->fmt.pix.width = MAX_W;
+
+	f->fmt.pix.height &= ~H_ALIGN_MASK;
+	f->fmt.pix.width &= ~W_ALIGN_MASK_YUV420;
+	f->fmt.pix.bytesperline = f->fmt.pix.width * 3 / 2;
+
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct emmaprp_fmt *fmt;
+	struct emmaprp_ctx *ctx = priv;
+
+	fmt = find_format(f);
+	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct emmaprp_fmt *fmt;
+	struct emmaprp_ctx *ctx = priv;
+
+	fmt = find_format(f);
+	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_s_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
+{
+	struct emmaprp_q_data *q_data;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(f->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	q_data->fmt		= find_format(f);
+	q_data->width		= f->fmt.pix.width;
+	q_data->height		= f->fmt.pix.height;
+	q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
+
+	dprintk(ctx->dev,
+		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
+		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+
+	ret = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+	return vidioc_s_fmt(priv, f);
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+
+	ret = vidioc_try_fmt_vid_out(file, priv, f);
+	if (ret)
+		return ret;
+
+	return vidioc_s_fmt(priv, f);
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct emmaprp_ctx *ctx = priv;
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+int v4l2_m2m_querybuf_custom(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret = 0;
+	unsigned int i;
+	struct vb2_buffer *vb;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_querybuf(vq, buf);
+
+	vb = vq->bufs[buf->index];
+	buf->m.offset = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (!buf->m.offset)
+		return -ENOMEM;
+	vb->v4l2_planes[0].m.mem_offset = buf->m.offset;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
+		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			for (i = 0; i < buf->length; ++i)
+				buf->m.planes[i].m.mem_offset
+					|= DST_QUEUE_OFF_BASE;
+		} else {
+			buf->m.offset |= DST_QUEUE_OFF_BASE;
+		}
+	}
+
+	return ret;
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct emmaprp_ctx *ctx = priv;
+
+	return v4l2_m2m_querybuf_custom(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct emmaprp_ctx *ctx = priv;
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct emmaprp_ctx *ctx = priv;
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct emmaprp_ctx *ctx = priv;
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct emmaprp_ctx *ctx = priv;
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
+
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out	= vidioc_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
+
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+};
+
+
+/*
+ * Queue operations
+ */
+struct vb2_dc_conf {
+	struct device           *dev;
+};
+
+static int emmaprp_queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vq);
+	struct emmaprp_q_data *q_data;
+	unsigned int size, count = *nbuffers;
+
+	q_data = get_q_data(vq->type);
+
+	size = q_data->width * q_data->height * 3 / 2;
+
+	while (size * count > MEM2MEM_VID_MEM_LIMIT)
+		(count)--;
+
+	*nplanes = 1;
+	*nbuffers = count;
+	sizes[0] = size;
+
+	alloc_ctxs[0] = ctx->dev->alloc_ctx;
+
+	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
+
+	return 0;
+}
+
+static int emmaprp_buf_prepare(struct vb2_buffer *vb)
+{
+	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct emmaprp_q_data *q_data;
+
+	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+
+	q_data = get_q_data(vb->vb2_queue->type);
+
+	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+		dprintk(ctx->dev, "%s data will not fit into plane"
+				  "(%lu < %lu)\n", __func__,
+				  vb2_plane_size(vb, 0),
+				  (long)q_data->sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+
+	return 0;
+}
+
+static void emmaprp_buf_queue(struct vb2_buffer *vb)
+{
+	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static struct vb2_ops emmaprp_qops = {
+	.queue_setup	 = emmaprp_queue_setup,
+	.buf_prepare	 = emmaprp_buf_prepare,
+	.buf_queue	 = emmaprp_buf_queue,
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct emmaprp_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &emmaprp_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &emmaprp_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+
+	return vb2_queue_init(dst_vq);
+}
+
+/*
+ * File operations
+ */
+static int emmaprp_open(struct file *file)
+{
+	struct emmaprp_dev *pcdev = video_drvdata(file);
+	struct emmaprp_ctx *ctx = NULL;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	file->private_data = ctx;
+	ctx->dev = pcdev;
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx, &queue_init);
+
+	if (IS_ERR(ctx->m2m_ctx)) {
+		int ret = PTR_ERR(ctx->m2m_ctx);
+
+		kfree(ctx);
+		return ret;
+	}
+
+	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
+
+	return 0;
+}
+
+static int emmaprp_release(struct file *file)
+{
+	struct emmaprp_dev *pcdev = video_drvdata(file);
+	struct emmaprp_ctx *ctx = file->private_data;
+
+	dprintk(pcdev, "Releasing instance %p\n", ctx);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int emmaprp_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct emmaprp_ctx *ctx = file->private_data;
+
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+int v4l2_m2m_mmap_custom(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct vm_area_struct *vma)
+{
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	struct vb2_queue *vq;
+
+	if (!(offset & DST_QUEUE_OFF_BASE)) {
+		vq = v4l2_m2m_get_src_vq(m2m_ctx);
+	} else {
+		vq = v4l2_m2m_get_dst_vq(m2m_ctx);
+		vma->vm_pgoff &= ~(DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
+	}
+
+	return vb2_mmap(vq, vma);
+}
+
+static int emmaprp_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct emmaprp_ctx *ctx = file->private_data;
+
+	return v4l2_m2m_mmap_custom(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations emmaprp_fops = {
+	.owner		= THIS_MODULE,
+	.open		= emmaprp_open,
+	.release	= emmaprp_release,
+	.poll		= emmaprp_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= emmaprp_mmap,
+};
+
+static struct video_device emmaprp_videodev = {
+	.name		= MEM2MEM_NAME,
+	.fops		= &emmaprp_fops,
+	.ioctl_ops	= &emmaprp_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+};
+
+static struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= emmaprp_device_run,
+	.job_ready	= emmaprp_job_ready,
+	.job_abort	= emmaprp_job_abort,
+	.lock		= emmaprp_lock,
+	.unlock		= emmaprp_unlock,
+};
+
+static int emmaprp_probe(struct platform_device *pdev)
+{
+	struct emmaprp_dev *pcdev;
+	struct video_device *vfd;
+	dma_cap_mask_t mask;
+	int ret = 0;
+
+	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
+	if (!pcdev)
+		return -ENOMEM;
+
+	spin_lock_init(&pcdev->irqlock);
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_INTERLEAVE, mask);
+	pcdev->dma_chan = dma_request_channel(mask, NULL, pcdev);
+	if (!pcdev->dma_chan)
+		goto free_dev;
+	//printk("%s: dma channel: %d\n", __func__, pcdev->dma_chan->chan_id);
+	if (!dma_has_cap(DMA_INTERLEAVE, pcdev->dma_chan->device->cap_mask)) {
+		v4l2_err(&pcdev->v4l2_dev, "DMA does not support INTERLEAVE\n");
+		goto rel_dma;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
+	if (ret)
+		goto rel_dma;
+
+	atomic_set(&pcdev->busy, 0);
+	mutex_init(&pcdev->dev_mutex);
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+
+	*vfd = emmaprp_videodev;
+	vfd->lock = &pcdev->dev_mutex;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to register video device\n");
+		goto rel_vdev;
+	}
+
+	video_set_drvdata(vfd, pcdev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", emmaprp_videodev.name);
+	pcdev->vfd = vfd;
+	v4l2_info(&pcdev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
+			" Device registered as /dev/video%d\n", vfd->num);
+
+	platform_set_drvdata(pdev, pcdev);
+
+	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx)) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
+		ret = PTR_ERR(pcdev->alloc_ctx);
+		goto err_ctx;
+	}
+
+	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(pcdev->m2m_dev)) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(pcdev->m2m_dev);
+		goto err_m2m;
+	}
+
+	q_data[V4L2_M2M_SRC].fmt = &formats[1];
+	q_data[V4L2_M2M_DST].fmt = &formats[0];
+
+	return 0;
+
+	v4l2_m2m_release(pcdev->m2m_dev);
+err_m2m:
+	video_unregister_device(pcdev->vfd);
+err_ctx:
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+rel_vdev:
+	video_device_release(vfd);
+unreg_dev:
+	v4l2_device_unregister(&pcdev->v4l2_dev);
+rel_dma:
+	dma_release_channel(pcdev->dma_chan);
+free_dev:
+	kfree(pcdev);
+
+	return ret;
+}
+
+static int emmaprp_remove(struct platform_device *pdev)
+{
+	struct emmaprp_dev *pcdev =
+		(struct emmaprp_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&pcdev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
+	v4l2_m2m_release(pcdev->m2m_dev);
+	video_unregister_device(pcdev->vfd);
+	v4l2_device_unregister(&pcdev->v4l2_dev);
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+	dma_release_channel(pcdev->dma_chan);
+	kfree(pcdev);
+
+	return 0;
+}
+
+static struct platform_driver emmaprp_pdrv = {
+	.probe		= emmaprp_probe,
+	.remove		= emmaprp_remove,
+	.driver		= {
+		.name	= MEM2MEM_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static void __exit emmaprp_exit(void)
+{
+	platform_driver_unregister(&emmaprp_pdrv);
+}
+
+static int __init emmaprp_init(void)
+{
+	return platform_driver_register(&emmaprp_pdrv);
+}
+
+module_init(emmaprp_init);
+module_exit(emmaprp_exit);
+
diff --git a/include/linux/coda_codec.h b/include/linux/coda_codec.h
new file mode 100644
index 0000000..8093b22
--- /dev/null
+++ b/include/linux/coda_codec.h
@@ -0,0 +1,9 @@
+
+#ifndef _CODA_CODEC_H
+#define _CODA_CODEC_H
+
+struct coda_platform_data {
+	char	*firmware;
+};
+
+#endif
\ No newline at end of file
