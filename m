Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59533 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933420AbcLIQ7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 11:59:22 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v2 2/7] [media] coda: add i.MX6 VDOA driver
Date: Fri,  9 Dec 2016 17:58:58 +0100
Message-Id: <20161209165903.1293-3-m.tretter@pengutronix.de>
In-Reply-To: <20161209165903.1293-1-m.tretter@pengutronix.de>
References: <20161209165903.1293-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

The i.MX6 Video Data Order Adapter's (VDOA) sole purpose is to convert
from a custom macroblock tiled format produced by the CODA960 decoder
into linear formats that can be used for scanout.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/media/platform/Kconfig         |   3 +
 drivers/media/platform/coda/Makefile   |   1 +
 drivers/media/platform/coda/imx-vdoa.c | 335 +++++++++++++++++++++++++++++++++
 drivers/media/platform/coda/imx-vdoa.h |  58 ++++++
 4 files changed, 397 insertions(+)
 create mode 100644 drivers/media/platform/coda/imx-vdoa.c
 create mode 100644 drivers/media/platform/coda/imx-vdoa.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ce4a96f..41e007f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -162,6 +162,9 @@ config VIDEO_CODA
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
 
+config VIDEO_IMX_VDOA
+	def_tristate VIDEO_CODA if SOC_IMX6Q || COMPILE_TEST
+
 config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
index 9342ac5..8582843 100644
--- a/drivers/media/platform/coda/Makefile
+++ b/drivers/media/platform/coda/Makefile
@@ -3,3 +3,4 @@ ccflags-y += -I$(src)
 coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-jpeg.o
 
 obj-$(CONFIG_VIDEO_CODA) += coda.o
+obj-$(CONFIG_VIDEO_IMX_VDOA) += imx-vdoa.o
diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
new file mode 100644
index 0000000..36ceffb
--- /dev/null
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -0,0 +1,335 @@
+/*
+ * i.MX6 Video Data Order Adapter (VDOA)
+ *
+ * Copyright (C) 2014 Philipp Zabel
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+
+#include "imx-vdoa.h"
+
+#define VDOA_NAME "imx-vdoa"
+
+#define VDOAC		0x00
+#define VDOASRR		0x04
+#define VDOAIE		0x08
+#define VDOAIST		0x0c
+#define VDOAFP		0x10
+#define VDOAIEBA00	0x14
+#define VDOAIEBA01	0x18
+#define VDOAIEBA02	0x1c
+#define VDOAIEBA10	0x20
+#define VDOAIEBA11	0x24
+#define VDOAIEBA12	0x28
+#define VDOASL		0x2c
+#define VDOAIUBO	0x30
+#define VDOAVEBA0	0x34
+#define VDOAVEBA1	0x38
+#define VDOAVEBA2	0x3c
+#define VDOAVUBO	0x40
+#define VDOASR		0x44
+
+#define VDOAC_ISEL		BIT(6)
+#define VDOAC_PFS		BIT(5)
+#define VDOAC_SO		BIT(4)
+#define VDOAC_SYNC		BIT(3)
+#define VDOAC_NF		BIT(2)
+#define VDOAC_BNDM_MASK		0x3
+#define VDOAC_BAND_HEIGHT_8	0x0
+#define VDOAC_BAND_HEIGHT_16	0x1
+#define VDOAC_BAND_HEIGHT_32	0x2
+
+#define VDOASRR_START		BIT(1)
+#define VDOASRR_SWRST		BIT(0)
+
+#define VDOAIE_EITERR		BIT(1)
+#define VDOAIE_EIEOT		BIT(0)
+
+#define VDOAIST_TERR		BIT(1)
+#define VDOAIST_EOT		BIT(0)
+
+#define VDOAFP_FH_MASK		(0x1fff << 16)
+#define VDOAFP_FW_MASK		(0x3fff)
+
+#define VDOASL_VSLY_MASK	(0x3fff << 16)
+#define VDOASL_ISLY_MASK	(0x7fff)
+
+#define VDOASR_ERRW		BIT(4)
+#define VDOASR_EOB		BIT(3)
+#define VDOASR_CURRENT_FRAME	(0x3 << 1)
+#define VDOASR_CURRENT_BUFFER	BIT(1)
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+struct vdoa_data {
+	struct vdoa_ctx		*curr_ctx;
+	struct device		*dev;
+	struct clk		*vdoa_clk;
+	void __iomem		*regs;
+	int			irq;
+};
+
+struct vdoa_q_data {
+	unsigned int	width;
+	unsigned int	height;
+	unsigned int	bytesperline;
+	unsigned int	sizeimage;
+	u32		pixelformat;
+};
+
+struct vdoa_ctx {
+	struct vdoa_data	*vdoa;
+	struct completion	completion;
+	struct vdoa_q_data	q_data[2];
+};
+
+static irqreturn_t vdoa_irq_handler(int irq, void *data)
+{
+	struct vdoa_data *vdoa = data;
+	struct vdoa_ctx *curr_ctx;
+	u32 val;
+
+	/* Disable interrupts */
+	writel(0, vdoa->regs + VDOAIE);
+
+	curr_ctx = vdoa->curr_ctx;
+	if (!curr_ctx) {
+		dev_dbg(vdoa->dev,
+			"Instance released before the end of transaction\n");
+		return IRQ_HANDLED;
+	}
+
+	val = readl(vdoa->regs + VDOAIST);
+	writel(val, vdoa->regs + VDOAIST);
+	if (val & VDOAIST_TERR) {
+		val = readl(vdoa->regs + VDOASR) & VDOASR_ERRW;
+		dev_err(vdoa->dev, "AXI %s error\n", val ? "write" : "read");
+	} else if (!(val & VDOAIST_EOT)) {
+		dev_warn(vdoa->dev, "Spurious interrupt\n");
+	}
+	complete(&curr_ctx->completion);
+
+	return IRQ_HANDLED;
+}
+
+void vdoa_device_run(struct vdoa_ctx *ctx, dma_addr_t dst, dma_addr_t src)
+{
+	struct vdoa_q_data *src_q_data, *dst_q_data;
+	struct vdoa_data *vdoa = ctx->vdoa;
+	u32 val;
+
+	vdoa->curr_ctx = ctx;
+
+	src_q_data = &ctx->q_data[V4L2_M2M_SRC];
+	dst_q_data = &ctx->q_data[V4L2_M2M_DST];
+
+	/* Progressive, no sync, 1 frame per run */
+	if (dst_q_data->pixelformat == V4L2_PIX_FMT_YUYV)
+		val = VDOAC_PFS;
+	else
+		val = 0;
+	writel(val, vdoa->regs + VDOAC);
+
+	writel(dst_q_data->height << 16 | dst_q_data->width,
+	       vdoa->regs + VDOAFP);
+
+	val = dst;
+	writel(val, vdoa->regs + VDOAIEBA00);
+
+	writel(src_q_data->bytesperline << 16 | dst_q_data->bytesperline,
+	       vdoa->regs + VDOASL);
+
+	if (dst_q_data->pixelformat == V4L2_PIX_FMT_NV12 ||
+	    dst_q_data->pixelformat == V4L2_PIX_FMT_NV21)
+		val = dst_q_data->bytesperline * dst_q_data->height;
+	else
+		val = 0;
+	writel(val, vdoa->regs + VDOAIUBO);
+
+	val = src;
+	writel(val, vdoa->regs + VDOAVEBA0);
+	val = src_q_data->bytesperline * src_q_data->height;
+	writel(val, vdoa->regs + VDOAVUBO);
+
+	/* Enable interrupts and start transfer */
+	writel(VDOAIE_EITERR | VDOAIE_EIEOT, vdoa->regs + VDOAIE);
+	writel(VDOASRR_START, vdoa->regs + VDOASRR);
+}
+EXPORT_SYMBOL(vdoa_device_run);
+
+int vdoa_wait_for_completion(struct vdoa_ctx *ctx)
+{
+	struct vdoa_data *vdoa = ctx->vdoa;
+
+	if (!wait_for_completion_timeout(&ctx->completion,
+					 msecs_to_jiffies(300))) {
+		dev_err(vdoa->dev,
+			"Timeout waiting for transfer result\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(vdoa_wait_for_completion);
+
+struct vdoa_ctx *vdoa_context_create(struct vdoa_data *vdoa)
+{
+	struct vdoa_ctx *ctx;
+	int err;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	err = clk_prepare_enable(vdoa->vdoa_clk);
+	if (err) {
+		kfree(ctx);
+		return NULL;
+	}
+
+	init_completion(&ctx->completion);
+	ctx->vdoa = vdoa;
+
+	return ctx;
+}
+EXPORT_SYMBOL(vdoa_context_create);
+
+void vdoa_context_destroy(struct vdoa_ctx *ctx)
+{
+	struct vdoa_data *vdoa = ctx->vdoa;
+
+	clk_disable_unprepare(vdoa->vdoa_clk);
+	kfree(ctx);
+}
+EXPORT_SYMBOL(vdoa_context_destroy);
+
+int vdoa_context_configure(struct vdoa_ctx *ctx,
+			   unsigned int width, unsigned int height,
+			   u32 pixelformat)
+{
+	struct vdoa_q_data *src_q_data;
+	struct vdoa_q_data *dst_q_data;
+
+	if (width < 16 || width  > 8192 || width % 16 != 0 ||
+	    height < 16 || height > 4096 || height % 16 != 0)
+		return -EINVAL;
+
+	if (pixelformat != V4L2_PIX_FMT_YUYV &&
+	    pixelformat != V4L2_PIX_FMT_NV12)
+		return -EINVAL;
+
+	/* If no context is passed, only check if the format is valid */
+	if (!ctx)
+		return 0;
+
+	src_q_data = &ctx->q_data[V4L2_M2M_SRC];
+	dst_q_data = &ctx->q_data[V4L2_M2M_DST];
+
+	src_q_data->width = width;
+	src_q_data->height = height;
+	src_q_data->bytesperline = width;
+	src_q_data->sizeimage = src_q_data->bytesperline * height * 3 / 2;
+
+	dst_q_data->width = width;
+	dst_q_data->height = height;
+	dst_q_data->pixelformat = pixelformat;
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+		dst_q_data->bytesperline = width * 2;
+		dst_q_data->sizeimage = dst_q_data->bytesperline * height;
+		break;
+	case V4L2_PIX_FMT_NV12:
+	default:
+		dst_q_data->bytesperline = width;
+		dst_q_data->sizeimage =
+			dst_q_data->bytesperline * height * 3 / 2;
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(vdoa_context_configure);
+
+static int vdoa_probe(struct platform_device *pdev)
+{
+	struct vdoa_data *vdoa;
+	struct resource *res;
+
+	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+
+	vdoa = devm_kzalloc(&pdev->dev, sizeof(*vdoa), GFP_KERNEL);
+	if (!vdoa)
+		return -ENOMEM;
+
+	vdoa->dev = &pdev->dev;
+
+	vdoa->vdoa_clk = devm_clk_get(vdoa->dev, NULL);
+	if (IS_ERR(vdoa->vdoa_clk)) {
+		dev_err(vdoa->dev, "Failed to get clock\n");
+		return PTR_ERR(vdoa->vdoa_clk);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	vdoa->regs = devm_ioremap_resource(vdoa->dev, res);
+	if (IS_ERR(vdoa->regs))
+		return PTR_ERR(vdoa->regs);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	vdoa->irq = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
+					vdoa_irq_handler, IRQF_ONESHOT,
+					"vdoa", vdoa);
+	if (vdoa->irq < 0) {
+		dev_err(vdoa->dev, "Failed to get irq\n");
+		return vdoa->irq;
+	}
+
+	platform_set_drvdata(pdev, vdoa);
+
+	return 0;
+}
+
+static int vdoa_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct of_device_id vdoa_dt_ids[] = {
+	{ .compatible = "fsl,imx6q-vdoa" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, vdoa_dt_ids);
+
+static struct platform_driver vdoa_driver = {
+	.probe		= vdoa_probe,
+	.remove		= vdoa_remove,
+	.driver		= {
+		.name	= VDOA_NAME,
+		.of_match_table = vdoa_dt_ids,
+	},
+};
+
+module_platform_driver(vdoa_driver);
+
+MODULE_DESCRIPTION("Video Data Order Adapter");
+MODULE_AUTHOR("Philipp Zabel <philipp.zabel@gmail.com>");
+MODULE_ALIAS("platform:imx-vdoa");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/coda/imx-vdoa.h b/drivers/media/platform/coda/imx-vdoa.h
new file mode 100644
index 0000000..967576b
--- /dev/null
+++ b/drivers/media/platform/coda/imx-vdoa.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2016 Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef IMX_VDOA_H
+#define IMX_VDOA_H
+
+struct vdoa_data;
+struct vdoa_ctx;
+
+#if (defined CONFIG_VIDEO_IMX_VDOA || defined CONFIG_VIDEO_IMX_VDOA_MODULE)
+
+struct vdoa_ctx *vdoa_context_create(struct vdoa_data *vdoa);
+int vdoa_context_configure(struct vdoa_ctx *ctx,
+			   unsigned int width, unsigned int height,
+			   u32 pixelformat);
+void vdoa_context_destroy(struct vdoa_ctx *ctx);
+
+void vdoa_device_run(struct vdoa_ctx *ctx, dma_addr_t dst, dma_addr_t src);
+int vdoa_wait_for_completion(struct vdoa_ctx *ctx);
+
+#else
+
+static inline struct vdoa_ctx *vdoa_context_create(struct vdoa_data *vdoa)
+{
+	return NULL;
+}
+
+static inline int vdoa_context_configure(struct vdoa_ctx *ctx,
+					 unsigned int width,
+					 unsigned int height,
+					 u32 pixelformat)
+{
+	return 0;
+}
+
+static inline void vdoa_context_destroy(struct vdoa_ctx *ctx) { };
+
+static inline void vdoa_device_run(struct vdoa_ctx *ctx,
+				   dma_addr_t dst, dma_addr_t src) { };
+
+static inline int vdoa_wait_for_completion(struct vdoa_ctx *ctx)
+{
+	return 0;
+};
+
+#endif
+
+#endif /* IMX_VDOA_H */
-- 
2.10.2

