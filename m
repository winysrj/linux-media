Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50016 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731848AbeHBVxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 17:53:34 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 6/6] media: add Rockchip VPU driver
Date: Thu,  2 Aug 2018 17:00:10 -0300
Message-Id: <20180802200010.24365-7-ezequiel@collabora.com>
In-Reply-To: <20180802200010.24365-1-ezequiel@collabora.com>
References: <20180802200010.24365-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a mem2mem driver for the VPU available on Rockchip SoCs.
Currently only JPEG encoding is supported, for RK3399 and RK3288
platforms.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 MAINTAINERS                                   |   7 +
 drivers/media/platform/Kconfig                |  13 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/rockchip/vpu/Makefile  |   8 +
 .../platform/rockchip/vpu/rk3288_vpu_hw.c     | 122 +++
 .../rockchip/vpu/rk3288_vpu_hw_jpege.c        | 154 ++++
 .../platform/rockchip/vpu/rk3288_vpu_regs.h   | 442 +++++++++++
 .../platform/rockchip/vpu/rk3399_vpu_hw.c     | 122 +++
 .../rockchip/vpu/rk3399_vpu_hw_jpege.c        | 181 +++++
 .../platform/rockchip/vpu/rk3399_vpu_regs.h   | 601 +++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu.h      | 272 +++++++
 .../platform/rockchip/vpu/rockchip_vpu_drv.c  | 404 ++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.c  | 715 ++++++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.h  |  25 +
 .../platform/rockchip/vpu/rockchip_vpu_hw.h   |  67 ++
 15 files changed, 3134 insertions(+)
 create mode 100644 drivers/media/platform/rockchip/vpu/Makefile
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0f2cce4b73d7..71b034160b51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12414,6 +12414,13 @@ S:	Maintained
 F:	drivers/media/platform/rockchip/rga/
 F:	Documentation/devicetree/bindings/media/rockchip-rga.txt
 
+ROCKCHIP VPU CODEC DRIVER
+M:	Ezequiel Garcia <ezequiel@collabora.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/rockchip/vpu/
+F:	Documentation/devicetree/bindings/media/rockchip-vpu.txt
+
 ROCKER DRIVER
 M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 9fa260090bf4..5b88d3de0490 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -448,6 +448,19 @@ config VIDEO_ROCKCHIP_RGA
 
 	  To compile this driver as a module choose m here.
 
+config VIDEO_ROCKCHIP_VPU
+	tristate "Rockchip VPU driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_ROCKCHIP || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  Support for the Video Processing Unit present on Rockchip SoC,
+	  which accelerates video and image encoding and decoding.
+	  To compile this driver as a module, choose M here: the module
+	  will be called rockchip-vpu.
+
 config VIDEO_TI_VPE
 	tristate "TI VPE (Video Processing Engine) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 2a9d82d1f984..513e8cef39ac 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_VIDEO_RENESAS_JPU)		+= rcar_jpu.o
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
 obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+= rockchip/rga/
+obj-$(CONFIG_VIDEO_ROCKCHIP_VPU)        += rockchip/vpu/
 
 obj-y	+= omap/
 
diff --git a/drivers/media/platform/rockchip/vpu/Makefile b/drivers/media/platform/rockchip/vpu/Makefile
new file mode 100644
index 000000000000..cab0123c49d4
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/Makefile
@@ -0,0 +1,8 @@
+obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
+
+rockchip-vpu-y += rockchip_vpu_drv.o \
+		rockchip_vpu_enc.o \
+		rk3288_vpu_hw.o \
+		rk3288_vpu_hw_jpege.o \
+		rk3399_vpu_hw.o \
+		rk3399_vpu_hw_jpege.o
diff --git a/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
new file mode 100644
index 000000000000..747a82b69820
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *	Jeffy Chen <jeffy.chen@rock-chips.com>
+ */
+
+#include <linux/clk.h>
+
+#include "rockchip_vpu.h"
+#include "rk3288_vpu_regs.h"
+
+#define RK3288_ACLK_MAX_FREQ (400 * 1000 * 1000)
+
+/*
+ * Supported formats.
+ */
+
+static const struct rockchip_vpu_fmt rk3288_vpu_enc_fmts[] = {
+	/* Source formats. */
+	{
+		.fourcc = V4L2_PIX_FMT_YUV420M,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 3,
+		.depth = { 8, 2, 2 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420P,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_NV12M,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 2,
+		.depth = { 8, 4 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420SP,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUYV,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 1,
+		.depth = { 16 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_YUYV422,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 1,
+		.depth = { 16 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_UYVY422,
+	},
+	/* Destination formats. */
+	{
+		.fourcc = V4L2_PIX_FMT_JPEG_RAW,
+		.codec_mode = RK_VPU_CODEC_JPEGE,
+		.num_planes = 1,
+		.frmsize = {
+			.min_width = 96,
+			.max_width = 8192,
+			.step_width = MB_DIM,
+			.min_height = 32,
+			.max_height = 8192,
+			.step_height = MB_DIM,
+		},
+	},
+};
+
+static irqreturn_t rk3288_vepu_irq(int irq, void *dev_id)
+{
+	struct rockchip_vpu_dev *vpu = dev_id;
+	u32 status = vepu_read(vpu, VEPU_REG_INTERRUPT);
+
+	vepu_write(vpu, 0, VEPU_REG_INTERRUPT);
+
+	if (status & VEPU_REG_INTERRUPT_FRAME_RDY) {
+		vepu_write(vpu, 0, VEPU_REG_AXI_CTRL);
+		rockchip_vpu_irq_done(vpu);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int rk3288_vpu_hw_init(struct rockchip_vpu_dev *vpu)
+{
+	/* Bump ACLK to max. possible freq. to improve performance. */
+	clk_set_rate(vpu->clocks[0], RK3288_ACLK_MAX_FREQ);
+	return 0;
+}
+
+static void rk3288_vpu_enc_reset(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+
+	vepu_write(vpu, VEPU_REG_INTERRUPT_DIS_BIT, VEPU_REG_INTERRUPT);
+	vepu_write(vpu, 0, VEPU_REG_ENC_CTRL);
+	vepu_write(vpu, 0, VEPU_REG_AXI_CTRL);
+}
+
+/*
+ * Supported codec ops.
+ */
+
+static const struct rockchip_vpu_codec_ops rk3288_vpu_codec_ops[] = {
+	[RK_VPU_CODEC_JPEGE] = {
+		.run = rk3288_vpu_jpege_run,
+		.done = rk3288_vpu_jpege_done,
+		.reset = rk3288_vpu_enc_reset,
+	},
+};
+
+/*
+ * VPU variant.
+ */
+
+const struct rockchip_vpu_variant rk3288_vpu_variant = {
+	.enc_offset = 0x0,
+	.enc_fmts = rk3288_vpu_enc_fmts,
+	.num_enc_fmts = ARRAY_SIZE(rk3288_vpu_enc_fmts),
+	.codec_ops = rk3288_vpu_codec_ops,
+	.vepu_irq = rk3288_vepu_irq,
+	.init = rk3288_vpu_hw_init,
+	.clk_names = {"aclk", "hclk"},
+	.num_clocks = 2
+};
diff --git a/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
new file mode 100644
index 000000000000..4cd263d2dedb
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ */
+
+#include <asm/unaligned.h>
+#include <media/v4l2-mem2mem.h>
+#include "rockchip_vpu.h"
+#include "rockchip_vpu_hw.h"
+#include "rk3288_vpu_regs.h"
+
+#define VEPU_JPEG_QUANT_TABLE_COUNT 16
+
+static void rk3288_vpu_set_src_img_ctrl(struct rockchip_vpu_dev *vpu,
+					struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *pix_fmt = &ctx->src_fmt;
+	u32 reg;
+
+	reg = VEPU_REG_IN_IMG_CTRL_ROW_LEN(pix_fmt->width)
+		| VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(0)
+		| VEPU_REG_IN_IMG_CTRL_OVRFLB_D4(0)
+		| VEPU_REG_IN_IMG_CTRL_FMT(ctx->vpu_src_fmt->enc_fmt);
+	vepu_write_relaxed(vpu, reg, VEPU_REG_IN_IMG_CTRL);
+}
+
+static void rk3288_vpu_jpege_set_buffers(struct rockchip_vpu_dev *vpu,
+					 struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *pix_fmt = &ctx->src_fmt;
+	struct vb2_buffer *buf;
+	dma_addr_t dst, src[3];
+	u32 dst_size;
+
+	WARN_ON(pix_fmt->num_planes > 3);
+
+	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	dst = vb2_dma_contig_plane_dma_addr(buf, 0);
+	dst_size = vb2_plane_size(buf, 0);
+
+	vepu_write_relaxed(vpu, dst, VEPU_REG_ADDR_OUTPUT_STREAM);
+	vepu_write_relaxed(vpu, dst_size, VEPU_REG_STR_BUF_LIMIT);
+
+	buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	if (pix_fmt->num_planes == 1) {
+		src[0] = vb2_dma_contig_plane_dma_addr(buf, 0);
+		/* single plane formats we supported are all interlaced */
+		src[1] = src[2] = src[0];
+	} else if (pix_fmt->num_planes == 2) {
+		src[PLANE_Y] = vb2_dma_contig_plane_dma_addr(buf, PLANE_Y);
+		src[PLANE_CR] = vb2_dma_contig_plane_dma_addr(buf, PLANE_CR);
+		src[PLANE_CB] = src[PLANE_CR];
+	} else {
+		src[PLANE_Y] = vb2_dma_contig_plane_dma_addr(buf, PLANE_Y);
+		src[PLANE_CR] = vb2_dma_contig_plane_dma_addr(buf, PLANE_CR);
+		src[PLANE_CB] = vb2_dma_contig_plane_dma_addr(buf, PLANE_CB);
+	}
+
+	vepu_write_relaxed(vpu, src[PLANE_Y], VEPU_REG_ADDR_IN_LUMA);
+	vepu_write_relaxed(vpu, src[PLANE_CR], VEPU_REG_ADDR_IN_CR);
+	vepu_write_relaxed(vpu, src[PLANE_CB], VEPU_REG_ADDR_IN_CB);
+}
+
+static void rk3288_vpu_jpege_set_qtables(struct rockchip_vpu_dev *vpu,
+		__be32 *luma_qtable, __be32 *chroma_qtable)
+{
+	u32 reg, i;
+
+	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
+		reg = get_unaligned_be32(&luma_qtable[i]);
+		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
+
+		reg = get_unaligned_be32(&chroma_qtable[i]);
+		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_CHROMA_QUAT(i));
+	}
+}
+
+void rk3288_vpu_jpege_run(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	__be32 *chroma_qtable = NULL;
+	__be32 *luma_qtable = NULL;
+	u32 reg;
+
+	if (ctx->vpu_dst_fmt->fourcc == V4L2_PIX_FMT_JPEG_RAW) {
+		struct v4l2_ctrl *ctrl;
+
+		ctrl = ctx->ctrls[ROCKCHIP_VPU_ENC_CTRL_Y_QUANT_TBL];
+		luma_qtable = (__be32 *)ctrl->p_cur.p;
+
+		ctrl = ctx->ctrls[ROCKCHIP_VPU_ENC_CTRL_C_QUANT_TBL];
+		chroma_qtable = (__be32 *)ctrl->p_cur.p;
+	}
+
+	/* Switch to JPEG encoder mode before writing registers */
+	vepu_write_relaxed(vpu, VEPU_REG_ENC_CTRL_ENC_MODE_JPEG,
+			   VEPU_REG_ENC_CTRL);
+
+	rk3288_vpu_set_src_img_ctrl(vpu, ctx);
+	rk3288_vpu_jpege_set_buffers(vpu, ctx);
+	if (luma_qtable && chroma_qtable)
+		rk3288_vpu_jpege_set_qtables(vpu, luma_qtable, chroma_qtable);
+
+	/* Make sure that all registers are written at this point. */
+	wmb();
+
+	/* Start the hardware. */
+	reg = VEPU_REG_AXI_CTRL_OUTPUT_SWAP16
+		| VEPU_REG_AXI_CTRL_INPUT_SWAP16
+		| VEPU_REG_AXI_CTRL_BURST_LEN(16)
+		| VEPU_REG_AXI_CTRL_OUTPUT_SWAP32
+		| VEPU_REG_AXI_CTRL_INPUT_SWAP32
+		| VEPU_REG_AXI_CTRL_OUTPUT_SWAP8
+		| VEPU_REG_AXI_CTRL_INPUT_SWAP8;
+	vepu_write(vpu, reg, VEPU_REG_AXI_CTRL);
+
+	reg = VEPU_REG_ENC_CTRL_WIDTH(MB_WIDTH(ctx->src_fmt.width))
+		| VEPU_REG_ENC_CTRL_HEIGHT(MB_HEIGHT(ctx->src_fmt.height))
+		| VEPU_REG_ENC_CTRL_ENC_MODE_JPEG
+		| VEPU_REG_ENC_PIC_INTRA
+		| VEPU_REG_ENC_CTRL_EN_BIT;
+	/* Kick the watchdog and start encoding */
+	schedule_delayed_work(&vpu->watchdog_work, msecs_to_jiffies(2000));
+	vepu_write_relaxed(vpu, reg, VEPU_REG_ENC_CTRL);
+}
+
+void rk3288_vpu_jpege_done(struct rockchip_vpu_ctx *ctx,
+			   enum vb2_buffer_state result)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	struct vb2_v4l2_buffer *src, *dst;
+
+	src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+	WARN_ON(!src);
+	WARN_ON(!dst);
+
+	src->sequence = ctx->sequence_out++;
+	dst->sequence = ctx->sequence_cap++;
+	dst->vb2_buf.planes[0].bytesused =
+		vepu_read(vpu, VEPU_REG_STR_BUF_LIMIT) / 8;
+	dst->field = src->field;
+	dst->timecode = src->timecode;
+	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
+	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+	v4l2_m2m_buf_done(src, result);
+	v4l2_m2m_buf_done(dst, result);
+	v4l2_m2m_job_finish(vpu->m2m_dev, ctx->fh.m2m_ctx);
+}
diff --git a/drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h b/drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
new file mode 100644
index 000000000000..7fa0262a3df3
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ */
+
+#ifndef RK3288_VPU_REGS_H_
+#define RK3288_VPU_REGS_H_
+
+/* Encoder registers. */
+#define VEPU_REG_INTERRUPT			0x004
+#define     VEPU_REG_INTERRUPT_FRAME_RDY	BIT(2)
+#define     VEPU_REG_INTERRUPT_DIS_BIT		BIT(1)
+#define     VEPU_REG_INTERRUPT_BIT		BIT(0)
+#define VEPU_REG_AXI_CTRL			0x008
+#define     VEPU_REG_AXI_CTRL_OUTPUT_SWAP16	BIT(15)
+#define     VEPU_REG_AXI_CTRL_INPUT_SWAP16	BIT(14)
+#define     VEPU_REG_AXI_CTRL_BURST_LEN(x)	((x) << 8)
+#define     VEPU_REG_AXI_CTRL_GATE_BIT		BIT(4)
+#define     VEPU_REG_AXI_CTRL_OUTPUT_SWAP32	BIT(3)
+#define     VEPU_REG_AXI_CTRL_INPUT_SWAP32	BIT(2)
+#define     VEPU_REG_AXI_CTRL_OUTPUT_SWAP8	BIT(1)
+#define     VEPU_REG_AXI_CTRL_INPUT_SWAP8	BIT(0)
+#define VEPU_REG_ADDR_OUTPUT_STREAM		0x014
+#define VEPU_REG_ADDR_OUTPUT_CTRL		0x018
+#define VEPU_REG_ADDR_REF_LUMA			0x01c
+#define VEPU_REG_ADDR_REF_CHROMA		0x020
+#define VEPU_REG_ADDR_REC_LUMA			0x024
+#define VEPU_REG_ADDR_REC_CHROMA		0x028
+#define VEPU_REG_ADDR_IN_LUMA			0x02c
+#define VEPU_REG_ADDR_IN_CB			0x030
+#define VEPU_REG_ADDR_IN_CR			0x034
+#define VEPU_REG_ENC_CTRL			0x038
+#define     VEPU_REG_ENC_CTRL_TIMEOUT_EN	BIT(31)
+#define     VEPU_REG_ENC_CTRL_NAL_MODE_BIT	BIT(29)
+#define     VEPU_REG_ENC_CTRL_WIDTH(w)		((w) << 19)
+#define     VEPU_REG_ENC_CTRL_HEIGHT(h)		((h) << 10)
+#define     VEPU_REG_ENC_PIC_INTER		(0x0 << 3)
+#define     VEPU_REG_ENC_PIC_INTRA		(0x1 << 3)
+#define     VEPU_REG_ENC_PIC_MVCINTER		(0x2 << 3)
+#define     VEPU_REG_ENC_CTRL_ENC_MODE_H264	(0x3 << 1)
+#define     VEPU_REG_ENC_CTRL_ENC_MODE_JPEG	(0x2 << 1)
+#define     VEPU_REG_ENC_CTRL_ENC_MODE_VP8	(0x1 << 1)
+#define     VEPU_REG_ENC_CTRL_EN_BIT		BIT(0)
+#define VEPU_REG_IN_IMG_CTRL			0x03c
+#define     VEPU_REG_IN_IMG_CTRL_ROW_LEN(x)	((x) << 12)
+#define     VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(x)	((x) << 10)
+#define     VEPU_REG_IN_IMG_CTRL_OVRFLB_D4(x)	((x) << 6)
+#define     VEPU_REG_IN_IMG_CTRL_FMT(x)		((x) << 2)
+#define VEPU_REG_ENC_CTRL0			0x040
+#define    VEPU_REG_ENC_CTRL0_INIT_QP(x)		((x) << 26)
+#define    VEPU_REG_ENC_CTRL0_SLICE_ALPHA(x)		((x) << 22)
+#define    VEPU_REG_ENC_CTRL0_SLICE_BETA(x)		((x) << 18)
+#define    VEPU_REG_ENC_CTRL0_CHROMA_QP_OFFSET(x)	((x) << 13)
+#define    VEPU_REG_ENC_CTRL0_FILTER_DIS(x)		((x) << 5)
+#define    VEPU_REG_ENC_CTRL0_IDR_PICID(x)		((x) << 1)
+#define    VEPU_REG_ENC_CTRL0_CONSTR_INTRA_PRED	BIT(0)
+#define VEPU_REG_ENC_CTRL1			0x044
+#define    VEPU_REG_ENC_CTRL1_PPS_ID(x)			((x) << 24)
+#define    VEPU_REG_ENC_CTRL1_INTRA_PRED_MODE(x)	((x) << 16)
+#define    VEPU_REG_ENC_CTRL1_FRAME_NUM(x)		((x))
+#define VEPU_REG_ENC_CTRL2			0x048
+#define    VEPU_REG_ENC_CTRL2_DEBLOCKING_FILETER_MODE(x)	((x) << 30)
+#define    VEPU_REG_ENC_CTRL2_H264_SLICE_SIZE(x)		((x) << 23)
+#define    VEPU_REG_ENC_CTRL2_DISABLE_QUARTER_PIXMV		BIT(22)
+#define    VEPU_REG_ENC_CTRL2_TRANS8X8_MODE_EN			BIT(21)
+#define    VEPU_REG_ENC_CTRL2_CABAC_INIT_IDC(x)			((x) << 19)
+#define    VEPU_REG_ENC_CTRL2_ENTROPY_CODING_MODE		BIT(18)
+#define    VEPU_REG_ENC_CTRL2_H264_INTER4X4_MODE		BIT(17)
+#define    VEPU_REG_ENC_CTRL2_H264_STREAM_MODE			BIT(16)
+#define    VEPU_REG_ENC_CTRL2_INTRA16X16_MODE(x)		((x))
+#define VEPU_REG_ENC_CTRL3			0x04c
+#define    VEPU_REG_ENC_CTRL3_MUTIMV_EN			BIT(30)
+#define    VEPU_REG_ENC_CTRL3_MV_PENALTY_1_4P(x)	((x) << 20)
+#define    VEPU_REG_ENC_CTRL3_MV_PENALTY_4P(x)		((x) << 10)
+#define    VEPU_REG_ENC_CTRL3_MV_PENALTY_1P(x)		((x))
+#define VEPU_REG_ENC_CTRL4			0x050
+#define    VEPU_REG_ENC_CTRL4_MV_PENALTY_16X8_8X16(x)	((x) << 20)
+#define    VEPU_REG_ENC_CTRL4_MV_PENALTY_8X8(x)		((x) << 10)
+#define    VEPU_REG_ENC_CTRL4_8X4_4X8(x)		((x))
+#define VEPU_REG_ENC_CTRL5			0x054
+#define    VEPU_REG_ENC_CTRL5_MACROBLOCK_PENALTY(x)	((x) << 24)
+#define    VEPU_REG_ENC_CTRL5_COMPLETE_SLICES(x)	((x) << 16)
+#define    VEPU_REG_ENC_CTRL5_INTER_MODE(x)		((x))
+#define VEPU_REG_STR_HDR_REM_MSB		0x058
+#define VEPU_REG_STR_HDR_REM_LSB		0x05c
+#define VEPU_REG_STR_BUF_LIMIT			0x060
+#define VEPU_REG_MAD_CTRL			0x064
+#define    VEPU_REG_MAD_CTRL_QP_ADJUST(x)	((x) << 28)
+#define    VEPU_REG_MAD_CTRL_MAD_THREDHOLD(x)	((x) << 22)
+#define    VEPU_REG_MAD_CTRL_QP_SUM_DIV2(x)	((x))
+#define VEPU_REG_ADDR_VP8_PROB_CNT		0x068
+#define VEPU_REG_QP_VAL				0x06c
+#define    VEPU_REG_QP_VAL_LUM(x)		((x) << 26)
+#define    VEPU_REG_QP_VAL_MAX(x)		((x) << 20)
+#define    VEPU_REG_QP_VAL_MIN(x)		((x) << 14)
+#define    VEPU_REG_QP_VAL_CHECKPOINT_DISTAN(x)	((x))
+#define VEPU_REG_VP8_QP_VAL(i)			(0x06c + ((i) * 0x4))
+#define VEPU_REG_CHECKPOINT(i)			(0x070 + ((i) * 0x4))
+#define     VEPU_REG_CHECKPOINT_CHECK0(x)	(((x) & 0xffff))
+#define     VEPU_REG_CHECKPOINT_CHECK1(x)	(((x) & 0xffff) << 16)
+#define     VEPU_REG_CHECKPOINT_RESULT(x)	((((x) >> (16 - 16 \
+						 * (i & 1))) & 0xffff) \
+						 * 32)
+#define VEPU_REG_CHKPT_WORD_ERR(i)		(0x084 + ((i) * 0x4))
+#define     VEPU_REG_CHKPT_WORD_ERR_CHK0(x)	(((x) & 0xffff))
+#define     VEPU_REG_CHKPT_WORD_ERR_CHK1(x)	(((x) & 0xffff) << 16)
+#define VEPU_REG_VP8_BOOL_ENC			0x08c
+#define VEPU_REG_CHKPT_DELTA_QP			0x090
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK0(x)	(((x) & 0x0f) << 0)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK1(x)	(((x) & 0x0f) << 4)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK2(x)	(((x) & 0x0f) << 8)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK3(x)	(((x) & 0x0f) << 12)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK4(x)	(((x) & 0x0f) << 16)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK5(x)	(((x) & 0x0f) << 20)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK6(x)	(((x) & 0x0f) << 24)
+#define VEPU_REG_VP8_CTRL0			0x090
+#define VEPU_REG_RLC_CTRL			0x094
+#define     VEPU_REG_RLC_CTRL_STR_OFFS_SHIFT	23
+#define     VEPU_REG_RLC_CTRL_STR_OFFS_MASK	(0x3f << 23)
+#define     VEPU_REG_RLC_CTRL_RLC_SUM(x)	((x))
+#define VEPU_REG_MB_CTRL			0x098
+#define     VEPU_REG_MB_CNT_OUT(x)		(((x) & 0xffff))
+#define     VEPU_REG_MB_CNT_SET(x)		(((x) & 0xffff) << 16)
+#define VEPU_REG_ADDR_NEXT_PIC			0x09c
+#define	VEPU_REG_JPEG_LUMA_QUAT(i)		(0x100 + ((i) * 0x4))
+#define	VEPU_REG_JPEG_CHROMA_QUAT(i)		(0x140 + ((i) * 0x4))
+#define VEPU_REG_STABILIZATION_OUTPUT		0x0A0
+#define VEPU_REG_ADDR_CABAC_TBL			0x0cc
+#define VEPU_REG_ADDR_MV_OUT			0x0d0
+#define VEPU_REG_RGB_YUV_COEFF(i)		(0x0d4 + ((i) * 0x4))
+#define VEPU_REG_RGB_MASK_MSB			0x0dc
+#define VEPU_REG_INTRA_AREA_CTRL		0x0e0
+#define VEPU_REG_CIR_INTRA_CTRL			0x0e4
+#define VEPU_REG_INTRA_SLICE_BITMAP(i)		(0x0e8 + ((i) * 0x4))
+#define VEPU_REG_ADDR_VP8_DCT_PART(i)		(0x0e8 + ((i) * 0x4))
+#define VEPU_REG_FIRST_ROI_AREA			0x0f0
+#define VEPU_REG_SECOND_ROI_AREA		0x0f4
+#define VEPU_REG_MVC_CTRL			0x0f8
+#define	VEPU_REG_MVC_CTRL_MV16X16_FAVOR(x)	((x) << 28)
+#define VEPU_REG_VP8_INTRA_PENALTY(i)		(0x100 + ((i) * 0x4))
+#define VEPU_REG_ADDR_VP8_SEG_MAP		0x11c
+#define VEPU_REG_VP8_SEG_QP(i)			(0x120 + ((i) * 0x4))
+#define VEPU_REG_DMV_4P_1P_PENALTY(i)		(0x180 + ((i) * 0x4))
+#define     VEPU_REG_DMV_4P_1P_PENALTY_BIT(x, i)	(x << i * 8)
+#define VEPU_REG_DMV_QPEL_PENALTY(i)		(0x200 + ((i) * 0x4))
+#define     VEPU_REG_DMV_QPEL_PENALTY_BIT(x, i)	(x << i * 8)
+#define VEPU_REG_VP8_CTRL1			0x280
+#define VEPU_REG_VP8_BIT_COST_GOLDEN		0x284
+#define VEPU_REG_VP8_LOOP_FLT_DELTA(i)		(0x288 + ((i) * 0x4))
+
+/* Decoder registers. */
+#define VDPU_REG_INTERRUPT			0x004
+#define     VDPU_REG_INTERRUPT_DEC_PIC_INF		BIT(24)
+#define     VDPU_REG_INTERRUPT_DEC_TIMEOUT		BIT(18)
+#define     VDPU_REG_INTERRUPT_DEC_SLICE_INT		BIT(17)
+#define     VDPU_REG_INTERRUPT_DEC_ERROR_INT		BIT(16)
+#define     VDPU_REG_INTERRUPT_DEC_ASO_INT		BIT(15)
+#define     VDPU_REG_INTERRUPT_DEC_BUFFER_INT		BIT(14)
+#define     VDPU_REG_INTERRUPT_DEC_BUS_INT		BIT(13)
+#define     VDPU_REG_INTERRUPT_DEC_RDY_INT		BIT(12)
+#define     VDPU_REG_INTERRUPT_DEC_IRQ			BIT(8)
+#define     VDPU_REG_INTERRUPT_DEC_IRQ_DIS		BIT(4)
+#define     VDPU_REG_INTERRUPT_DEC_E			BIT(0)
+#define VDPU_REG_CONFIG				0x008
+#define     VDPU_REG_CONFIG_DEC_AXI_RD_ID(x)		(((x) & 0xff) << 24)
+#define     VDPU_REG_CONFIG_DEC_TIMEOUT_E		BIT(23)
+#define     VDPU_REG_CONFIG_DEC_STRSWAP32_E		BIT(22)
+#define     VDPU_REG_CONFIG_DEC_STRENDIAN_E		BIT(21)
+#define     VDPU_REG_CONFIG_DEC_INSWAP32_E		BIT(20)
+#define     VDPU_REG_CONFIG_DEC_OUTSWAP32_E		BIT(19)
+#define     VDPU_REG_CONFIG_DEC_DATA_DISC_E		BIT(18)
+#define     VDPU_REG_CONFIG_TILED_MODE_MSB		BIT(17)
+#define     VDPU_REG_CONFIG_DEC_OUT_TILED_E		BIT(17)
+#define     VDPU_REG_CONFIG_DEC_LATENCY(x)		(((x) & 0x3f) << 11)
+#define     VDPU_REG_CONFIG_DEC_CLK_GATE_E		BIT(10)
+#define     VDPU_REG_CONFIG_DEC_IN_ENDIAN		BIT(9)
+#define     VDPU_REG_CONFIG_DEC_OUT_ENDIAN		BIT(8)
+#define     VDPU_REG_CONFIG_PRIORITY_MODE(x)		(((x) & 0x7) << 5)
+#define     VDPU_REG_CONFIG_TILED_MODE_LSB		BIT(7)
+#define     VDPU_REG_CONFIG_DEC_ADV_PRE_DIS		BIT(6)
+#define     VDPU_REG_CONFIG_DEC_SCMD_DIS		BIT(5)
+#define     VDPU_REG_CONFIG_DEC_MAX_BURST(x)		(((x) & 0x1f) << 0)
+#define VDPU_REG_DEC_CTRL0			0x00c
+#define     VDPU_REG_DEC_CTRL0_DEC_MODE(x)		(((x) & 0xf) << 28)
+#define     VDPU_REG_DEC_CTRL0_RLC_MODE_E		BIT(27)
+#define     VDPU_REG_DEC_CTRL0_SKIP_MODE		BIT(26)
+#define     VDPU_REG_DEC_CTRL0_DIVX3_E			BIT(25)
+#define     VDPU_REG_DEC_CTRL0_PJPEG_E			BIT(24)
+#define     VDPU_REG_DEC_CTRL0_PIC_INTERLACE_E		BIT(23)
+#define     VDPU_REG_DEC_CTRL0_PIC_FIELDMODE_E		BIT(22)
+#define     VDPU_REG_DEC_CTRL0_PIC_B_E			BIT(21)
+#define     VDPU_REG_DEC_CTRL0_PIC_INTER_E		BIT(20)
+#define     VDPU_REG_DEC_CTRL0_PIC_TOPFIELD_E		BIT(19)
+#define     VDPU_REG_DEC_CTRL0_FWD_INTERLACE_E		BIT(18)
+#define     VDPU_REG_DEC_CTRL0_SORENSON_E		BIT(17)
+#define     VDPU_REG_DEC_CTRL0_REF_TOPFIELD_E		BIT(16)
+#define     VDPU_REG_DEC_CTRL0_DEC_OUT_DIS		BIT(15)
+#define     VDPU_REG_DEC_CTRL0_FILTERING_DIS		BIT(14)
+#define     VDPU_REG_DEC_CTRL0_WEBP_E			BIT(13)
+#define     VDPU_REG_DEC_CTRL0_MVC_E			BIT(13)
+#define     VDPU_REG_DEC_CTRL0_PIC_FIXED_QUANT		BIT(13)
+#define     VDPU_REG_DEC_CTRL0_WRITE_MVS_E		BIT(12)
+#define     VDPU_REG_DEC_CTRL0_REFTOPFIRST_E		BIT(11)
+#define     VDPU_REG_DEC_CTRL0_SEQ_MBAFF_E		BIT(10)
+#define     VDPU_REG_DEC_CTRL0_PICORD_COUNT_E		BIT(9)
+#define     VDPU_REG_DEC_CTRL0_DEC_AHB_HLOCK_E		BIT(8)
+#define     VDPU_REG_DEC_CTRL0_DEC_AXI_WR_ID(x)		(((x) & 0xff) << 0)
+#define VDPU_REG_DEC_CTRL1			0x010
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_WIDTH(x)		(((x) & 0x1ff) << 23)
+#define     VDPU_REG_DEC_CTRL1_MB_WIDTH_OFF(x)		(((x) & 0xf) << 19)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_HEIGHT_P(x)	(((x) & 0xff) << 11)
+#define     VDPU_REG_DEC_CTRL1_MB_HEIGHT_OFF(x)		(((x) & 0xf) << 7)
+#define     VDPU_REG_DEC_CTRL1_ALT_SCAN_E		BIT(6)
+#define     VDPU_REG_DEC_CTRL1_TOPFIELDFIRST_E		BIT(5)
+#define     VDPU_REG_DEC_CTRL1_REF_FRAMES(x)		(((x) & 0x1f) << 0)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT(x)		(((x) & 0x7) << 3)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT(x)		(((x) & 0x7) << 0)
+#define     VDPU_REG_DEC_CTRL1_PIC_REFER_FLAG		BIT(0)
+#define VDPU_REG_DEC_CTRL2			0x014
+#define     VDPU_REG_DEC_CTRL2_STRM_START_BIT(x)	(((x) & 0x3f) << 26)
+#define     VDPU_REG_DEC_CTRL2_SYNC_MARKER_E		BIT(25)
+#define     VDPU_REG_DEC_CTRL2_TYPE1_QUANT_E		BIT(24)
+#define     VDPU_REG_DEC_CTRL2_CH_QP_OFFSET(x)		(((x) & 0x1f) << 19)
+#define     VDPU_REG_DEC_CTRL2_CH_QP_OFFSET2(x)		(((x) & 0x1f) << 14)
+#define     VDPU_REG_DEC_CTRL2_FIELDPIC_FLAG_E		BIT(0)
+#define     VDPU_REG_DEC_CTRL2_INTRADC_VLC_THR(x)	(((x) & 0x7) << 16)
+#define     VDPU_REG_DEC_CTRL2_VOP_TIME_INCR(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_DEC_CTRL2_DQ_PROFILE		BIT(24)
+#define     VDPU_REG_DEC_CTRL2_DQBI_LEVEL		BIT(23)
+#define     VDPU_REG_DEC_CTRL2_RANGE_RED_FRM_E		BIT(22)
+#define     VDPU_REG_DEC_CTRL2_FAST_UVMC_E		BIT(20)
+#define     VDPU_REG_DEC_CTRL2_TRANSDCTAB		BIT(17)
+#define     VDPU_REG_DEC_CTRL2_TRANSACFRM(x)		(((x) & 0x3) << 15)
+#define     VDPU_REG_DEC_CTRL2_TRANSACFRM2(x)		(((x) & 0x3) << 13)
+#define     VDPU_REG_DEC_CTRL2_MB_MODE_TAB(x)		(((x) & 0x7) << 10)
+#define     VDPU_REG_DEC_CTRL2_MVTAB(x)			(((x) & 0x7) << 7)
+#define     VDPU_REG_DEC_CTRL2_CBPTAB(x)		(((x) & 0x7) << 4)
+#define     VDPU_REG_DEC_CTRL2_2MV_BLK_PAT_TAB(x)	(((x) & 0x3) << 2)
+#define     VDPU_REG_DEC_CTRL2_4MV_BLK_PAT_TAB(x)	(((x) & 0x3) << 0)
+#define     VDPU_REG_DEC_CTRL2_QSCALE_TYPE		BIT(24)
+#define     VDPU_REG_DEC_CTRL2_CON_MV_E			BIT(4)
+#define     VDPU_REG_DEC_CTRL2_INTRA_DC_PREC(x)		(((x) & 0x3) << 2)
+#define     VDPU_REG_DEC_CTRL2_INTRA_VLC_TAB		BIT(1)
+#define     VDPU_REG_DEC_CTRL2_FRAME_PRED_DCT		BIT(0)
+#define     VDPU_REG_DEC_CTRL2_JPEG_QTABLES(x)		(((x) & 0x3) << 11)
+#define     VDPU_REG_DEC_CTRL2_JPEG_MODE(x)		(((x) & 0x7) << 8)
+#define     VDPU_REG_DEC_CTRL2_JPEG_FILRIGHT_E		BIT(7)
+#define     VDPU_REG_DEC_CTRL2_JPEG_STREAM_ALL		BIT(6)
+#define     VDPU_REG_DEC_CTRL2_CR_AC_VLCTABLE		BIT(5)
+#define     VDPU_REG_DEC_CTRL2_CB_AC_VLCTABLE		BIT(4)
+#define     VDPU_REG_DEC_CTRL2_CR_DC_VLCTABLE		BIT(3)
+#define     VDPU_REG_DEC_CTRL2_CB_DC_VLCTABLE		BIT(2)
+#define     VDPU_REG_DEC_CTRL2_CR_DC_VLCTABLE3		BIT(1)
+#define     VDPU_REG_DEC_CTRL2_CB_DC_VLCTABLE3		BIT(0)
+#define     VDPU_REG_DEC_CTRL2_STRM1_START_BIT(x)	(((x) & 0x3f) << 18)
+#define     VDPU_REG_DEC_CTRL2_HUFFMAN_E		BIT(17)
+#define     VDPU_REG_DEC_CTRL2_MULTISTREAM_E		BIT(16)
+#define     VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE(x)		(((x) & 0xff) << 8)
+#define     VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE(x)		(((x) & 0xff) << 0)
+#define     VDPU_REG_DEC_CTRL2_ALPHA_OFFSET(x)		(((x) & 0x1f) << 5)
+#define     VDPU_REG_DEC_CTRL2_BETA_OFFSET(x)		(((x) & 0x1f) << 0)
+#define VDPU_REG_DEC_CTRL3			0x018
+#define     VDPU_REG_DEC_CTRL3_START_CODE_E		BIT(31)
+#define     VDPU_REG_DEC_CTRL3_INIT_QP(x)		(((x) & 0x3f) << 25)
+#define     VDPU_REG_DEC_CTRL3_CH_8PIX_ILEAV_E		BIT(24)
+#define     VDPU_REG_DEC_CTRL3_STREAM_LEN_EXT(x)	(((x) & 0xff) << 24)
+#define     VDPU_REG_DEC_CTRL3_STREAM_LEN(x)		(((x) & 0xffffff) << 0)
+#define VDPU_REG_DEC_CTRL4			0x01c
+#define     VDPU_REG_DEC_CTRL4_CABAC_E			BIT(31)
+#define     VDPU_REG_DEC_CTRL4_BLACKWHITE_E		BIT(30)
+#define     VDPU_REG_DEC_CTRL4_DIR_8X8_INFER_E		BIT(29)
+#define     VDPU_REG_DEC_CTRL4_WEIGHT_PRED_E		BIT(28)
+#define     VDPU_REG_DEC_CTRL4_WEIGHT_BIPR_IDC(x)	(((x) & 0x3) << 26)
+#define     VDPU_REG_DEC_CTRL4_AVS_H264_H_EXT		BIT(25)
+#define     VDPU_REG_DEC_CTRL4_FRAMENUM_LEN(x)		(((x) & 0x1f) << 16)
+#define     VDPU_REG_DEC_CTRL4_FRAMENUM(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_DEC_CTRL4_BITPLANE0_E		BIT(31)
+#define     VDPU_REG_DEC_CTRL4_BITPLANE1_E		BIT(30)
+#define     VDPU_REG_DEC_CTRL4_BITPLANE2_E		BIT(29)
+#define     VDPU_REG_DEC_CTRL4_ALT_PQUANT(x)		(((x) & 0x1f) << 24)
+#define     VDPU_REG_DEC_CTRL4_DQ_EDGES(x)		(((x) & 0xf) << 20)
+#define     VDPU_REG_DEC_CTRL4_TTMBF			BIT(19)
+#define     VDPU_REG_DEC_CTRL4_PQINDEX(x)		(((x) & 0x1f) << 14)
+#define     VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT		BIT(13)
+#define     VDPU_REG_DEC_CTRL4_BILIN_MC_E		BIT(12)
+#define     VDPU_REG_DEC_CTRL4_UNIQP_E			BIT(11)
+#define     VDPU_REG_DEC_CTRL4_HALFQP_E			BIT(10)
+#define     VDPU_REG_DEC_CTRL4_TTFRM(x)			(((x) & 0x3) << 8)
+#define     VDPU_REG_DEC_CTRL4_2ND_BYTE_EMUL_E		BIT(7)
+#define     VDPU_REG_DEC_CTRL4_DQUANT_E			BIT(6)
+#define     VDPU_REG_DEC_CTRL4_VC1_ADV_E		BIT(5)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_FILDOWN_E		BIT(26)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_WDIV8		BIT(25)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_HDIV8		BIT(24)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_AH(x)		(((x) & 0xf) << 20)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_AL(x)		(((x) & 0xf) << 16)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_SS(x)		(((x) & 0xff) << 8)
+#define     VDPU_REG_DEC_CTRL4_PJPEG_SE(x)		(((x) & 0xff) << 0)
+#define     VDPU_REG_DEC_CTRL4_DCT1_START_BIT(x)	(((x) & 0x3f) << 26)
+#define     VDPU_REG_DEC_CTRL4_DCT2_START_BIT(x)	(((x) & 0x3f) << 20)
+#define     VDPU_REG_DEC_CTRL4_CH_MV_RES		BIT(13)
+#define     VDPU_REG_DEC_CTRL4_INIT_DC_MATCH0(x)	(((x) & 0x7) << 9)
+#define     VDPU_REG_DEC_CTRL4_INIT_DC_MATCH1(x)	(((x) & 0x7) << 6)
+#define     VDPU_REG_DEC_CTRL4_VP7_VERSION		BIT(5)
+#define VDPU_REG_DEC_CTRL5			0x020
+#define     VDPU_REG_DEC_CTRL5_CONST_INTRA_E		BIT(31)
+#define     VDPU_REG_DEC_CTRL5_FILT_CTRL_PRES		BIT(30)
+#define     VDPU_REG_DEC_CTRL5_RDPIC_CNT_PRES		BIT(29)
+#define     VDPU_REG_DEC_CTRL5_8X8TRANS_FLAG_E		BIT(28)
+#define     VDPU_REG_DEC_CTRL5_REFPIC_MK_LEN(x)		(((x) & 0x7ff) << 17)
+#define     VDPU_REG_DEC_CTRL5_IDR_PIC_E		BIT(16)
+#define     VDPU_REG_DEC_CTRL5_IDR_PIC_ID(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_DEC_CTRL5_MV_SCALEFACTOR(x)	(((x) & 0xff) << 24)
+#define     VDPU_REG_DEC_CTRL5_REF_DIST_FWD(x)		(((x) & 0x1f) << 19)
+#define     VDPU_REG_DEC_CTRL5_REF_DIST_BWD(x)		(((x) & 0x1f) << 14)
+#define     VDPU_REG_DEC_CTRL5_LOOP_FILT_LIMIT(x)	(((x) & 0xf) << 14)
+#define     VDPU_REG_DEC_CTRL5_VARIANCE_TEST_E		BIT(13)
+#define     VDPU_REG_DEC_CTRL5_MV_THRESHOLD(x)		(((x) & 0x7) << 10)
+#define     VDPU_REG_DEC_CTRL5_VAR_THRESHOLD(x)		(((x) & 0x3ff) << 0)
+#define     VDPU_REG_DEC_CTRL5_DIVX_IDCT_E		BIT(8)
+#define     VDPU_REG_DEC_CTRL5_DIVX3_SLICE_SIZE(x)	(((x) & 0xff) << 0)
+#define     VDPU_REG_DEC_CTRL5_PJPEG_REST_FREQ(x)	(((x) & 0xffff) << 0)
+#define     VDPU_REG_DEC_CTRL5_RV_PROFILE(x)		(((x) & 0x3) << 30)
+#define     VDPU_REG_DEC_CTRL5_RV_OSV_QUANT(x)		(((x) & 0x3) << 28)
+#define     VDPU_REG_DEC_CTRL5_RV_FWD_SCALE(x)		(((x) & 0x3fff) << 14)
+#define     VDPU_REG_DEC_CTRL5_RV_BWD_SCALE(x)		(((x) & 0x3fff) << 0)
+#define     VDPU_REG_DEC_CTRL5_INIT_DC_COMP0(x)		(((x) & 0xffff) << 16)
+#define     VDPU_REG_DEC_CTRL5_INIT_DC_COMP1(x)		(((x) & 0xffff) << 0)
+#define VDPU_REG_DEC_CTRL6			0x024
+#define     VDPU_REG_DEC_CTRL6_PPS_ID(x)		(((x) & 0xff) << 24)
+#define     VDPU_REG_DEC_CTRL6_REFIDX1_ACTIVE(x)	(((x) & 0x1f) << 19)
+#define     VDPU_REG_DEC_CTRL6_REFIDX0_ACTIVE(x)	(((x) & 0x1f) << 14)
+#define     VDPU_REG_DEC_CTRL6_POC_LENGTH(x)		(((x) & 0xff) << 0)
+#define     VDPU_REG_DEC_CTRL6_ICOMP0_E			BIT(24)
+#define     VDPU_REG_DEC_CTRL6_ISCALE0(x)		(((x) & 0xff) << 16)
+#define     VDPU_REG_DEC_CTRL6_ISHIFT0(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_DEC_CTRL6_STREAM1_LEN(x)		(((x) & 0xffffff) << 0)
+#define     VDPU_REG_DEC_CTRL6_PIC_SLICE_AM(x)		(((x) & 0x1fff) << 0)
+#define     VDPU_REG_DEC_CTRL6_COEFFS_PART_AM(x)	(((x) & 0xf) << 24)
+#define VDPU_REG_FWD_PIC(i)			(0x028 + ((i) * 0x4))
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F5(x)		(((x) & 0x1f) << 25)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F4(x)		(((x) & 0x1f) << 20)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F3(x)		(((x) & 0x1f) << 15)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F2(x)		(((x) & 0x1f) << 10)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F1(x)		(((x) & 0x1f) << 5)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F0(x)		(((x) & 0x1f) << 0)
+#define     VDPU_REG_FWD_PIC1_ICOMP1_E			BIT(24)
+#define     VDPU_REG_FWD_PIC1_ISCALE1(x)		(((x) & 0xff) << 16)
+#define     VDPU_REG_FWD_PIC1_ISHIFT1(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_FWD_PIC1_SEGMENT_BASE(x)		((x) << 0)
+#define     VDPU_REG_FWD_PIC1_SEGMENT_UPD_E		BIT(1)
+#define     VDPU_REG_FWD_PIC1_SEGMENT_E			BIT(0)
+#define VDPU_REG_DEC_CTRL7			0x02c
+#define     VDPU_REG_DEC_CTRL7_PINIT_RLIST_F15(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_DEC_CTRL7_PINIT_RLIST_F14(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_DEC_CTRL7_PINIT_RLIST_F13(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_DEC_CTRL7_PINIT_RLIST_F12(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_DEC_CTRL7_PINIT_RLIST_F11(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_DEC_CTRL7_PINIT_RLIST_F10(x)	(((x) & 0x1f) << 0)
+#define     VDPU_REG_DEC_CTRL7_ICOMP2_E			BIT(24)
+#define     VDPU_REG_DEC_CTRL7_ISCALE2(x)		(((x) & 0xff) << 16)
+#define     VDPU_REG_DEC_CTRL7_ISHIFT2(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_DEC_CTRL7_DCT3_START_BIT(x)	(((x) & 0x3f) << 24)
+#define     VDPU_REG_DEC_CTRL7_DCT4_START_BIT(x)	(((x) & 0x3f) << 18)
+#define     VDPU_REG_DEC_CTRL7_DCT5_START_BIT(x)	(((x) & 0x3f) << 12)
+#define     VDPU_REG_DEC_CTRL7_DCT6_START_BIT(x)	(((x) & 0x3f) << 6)
+#define     VDPU_REG_DEC_CTRL7_DCT7_START_BIT(x)	(((x) & 0x3f) << 0)
+#define VDPU_REG_ADDR_STR			0x030
+#define VDPU_REG_ADDR_DST			0x034
+#define VDPU_REG_ADDR_REF(i)			(0x038 + ((i) * 0x4))
+#define     VDPU_REG_ADDR_REF_FIELD_E			BIT(1)
+#define     VDPU_REG_ADDR_REF_TOPC_E			BIT(0)
+#define VDPU_REG_REF_PIC(i)			(0x078 + ((i) * 0x4))
+#define     VDPU_REG_REF_PIC_FILT_TYPE_E		BIT(31)
+#define     VDPU_REG_REF_PIC_FILT_SHARPNESS(x)	(((x) & 0x7) << 28)
+#define     VDPU_REG_REF_PIC_MB_ADJ_0(x)		(((x) & 0x7f) << 21)
+#define     VDPU_REG_REF_PIC_MB_ADJ_1(x)		(((x) & 0x7f) << 14)
+#define     VDPU_REG_REF_PIC_MB_ADJ_2(x)		(((x) & 0x7f) << 7)
+#define     VDPU_REG_REF_PIC_MB_ADJ_3(x)		(((x) & 0x7f) << 0)
+#define     VDPU_REG_REF_PIC_REFER1_NBR(x)		(((x) & 0xffff) << 16)
+#define     VDPU_REG_REF_PIC_REFER0_NBR(x)		(((x) & 0xffff) << 0)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_0(x)		(((x) & 0x3f) << 18)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_1(x)		(((x) & 0x3f) << 12)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_2(x)		(((x) & 0x3f) << 6)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_3(x)		(((x) & 0x3f) << 0)
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_0(x)	(((x) & 0x1f) << 27)
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_1(x)	(((x) & 0x1f) << 22)
+#define     VDPU_REG_REF_PIC_QUANT_0(x)			(((x) & 0x7ff) << 11)
+#define     VDPU_REG_REF_PIC_QUANT_1(x)			(((x) & 0x7ff) << 0)
+#define VDPU_REG_LT_REF				0x098
+#define VDPU_REG_VALID_REF			0x09c
+#define VDPU_REG_ADDR_QTABLE			0x0a0
+#define VDPU_REG_ADDR_DIR_MV			0x0a4
+#define VDPU_REG_BD_REF_PIC(i)			(0x0a8 + ((i) * 0x4))
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B2(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F2(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B1(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F1(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B0(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F0(x)	(((x) & 0x1f) << 0)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_2_M1(x)	(((x) & 0x3) << 10)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_2_4(x)		(((x) & 0x3) << 8)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_4_M1(x)	(((x) & 0x3) << 6)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_4_4(x)		(((x) & 0x3) << 4)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_6_M1(x)	(((x) & 0x3) << 2)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_6_4(x)		(((x) & 0x3) << 0)
+#define     VDPU_REG_BD_REF_PIC_QUANT_DELTA_2(x)	(((x) & 0x1f) << 27)
+#define     VDPU_REG_BD_REF_PIC_QUANT_DELTA_3(x)	(((x) & 0x1f) << 22)
+#define     VDPU_REG_BD_REF_PIC_QUANT_2(x)		(((x) & 0x7ff) << 11)
+#define     VDPU_REG_BD_REF_PIC_QUANT_3(x)		(((x) & 0x7ff) << 0)
+#define VDPU_REG_BD_P_REF_PIC			0x0bc
+#define     VDPU_REG_BD_P_REF_PIC_QUANT_DELTA_4(x)	(((x) & 0x1f) << 27)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F3(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F2(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F1(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F0(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_P_REF_PIC_BINIT_RLIST_B15(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_P_REF_PIC_BINIT_RLIST_F15(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_ERR_CONC			0x0c0
+#define     VDPU_REG_ERR_CONC_STARTMB_X(x)		(((x) & 0x1ff) << 23)
+#define     VDPU_REG_ERR_CONC_STARTMB_Y(x)		(((x) & 0xff) << 15)
+#define VDPU_REG_PRED_FLT			0x0c4
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_0(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_1(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_2(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_REF_BUF_CTRL			0x0cc
+#define     VDPU_REG_REF_BUF_CTRL_REFBU_E		BIT(31)
+#define     VDPU_REG_REF_BUF_CTRL_REFBU_THR(x)		(((x) & 0xfff) << 19)
+#define     VDPU_REG_REF_BUF_CTRL_REFBU_PICID(x)	(((x) & 0x1f) << 14)
+#define     VDPU_REG_REF_BUF_CTRL_REFBU_EVAL_E		BIT(13)
+#define     VDPU_REG_REF_BUF_CTRL_REFBU_FPARMOD_E	BIT(12)
+#define     VDPU_REG_REF_BUF_CTRL_REFBU_Y_OFFSET(x)	(((x) & 0x1ff) << 0)
+#define VDPU_REG_REF_BUF_CTRL2			0x0dc
+#define     VDPU_REG_REF_BUF_CTRL2_REFBU2_BUF_E		BIT(31)
+#define     VDPU_REG_REF_BUF_CTRL2_REFBU2_THR(x)	(((x) & 0xfff) << 19)
+#define     VDPU_REG_REF_BUF_CTRL2_REFBU2_PICID(x)	(((x) & 0x1f) << 14)
+#define     VDPU_REG_REF_BUF_CTRL2_APF_THRESHOLD(x)	(((x) & 0x3fff) << 0)
+
+#endif /* RK3288_VPU_REGS_H_ */
diff --git a/drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c b/drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
new file mode 100644
index 000000000000..93007b3dca7c
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *	Jeffy Chen <jeffy.chen@rock-chips.com>
+ */
+
+#include <linux/clk.h>
+
+#include "rockchip_vpu.h"
+#include "rk3399_vpu_regs.h"
+
+#define RK3399_ACLK_MAX_FREQ (400 * 1000 * 1000)
+
+/*
+ * Supported formats.
+ */
+
+static const struct rockchip_vpu_fmt rk3399_vpu_enc_fmts[] = {
+	/* Source formats. */
+	{
+		.fourcc = V4L2_PIX_FMT_YUV420M,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 3,
+		.depth = { 8, 2, 2 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420P,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_NV12M,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 2,
+		.depth = { 8, 4 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420SP,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUYV,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 1,
+		.depth = { 16 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_YUYV422,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 1,
+		.depth = { 16 },
+		.enc_fmt = RK3288_VPU_ENC_FMT_UYVY422,
+	},
+	/* Destination formats. */
+	{
+		.fourcc = V4L2_PIX_FMT_JPEG_RAW,
+		.codec_mode = RK_VPU_CODEC_JPEGE,
+		.num_planes = 1,
+		.frmsize = {
+			.min_width = 96,
+			.max_width = 8192,
+			.step_width = MB_DIM,
+			.min_height = 32,
+			.max_height = 8192,
+			.step_height = MB_DIM,
+		},
+	},
+};
+
+static irqreturn_t rk3399_vepu_irq(int irq, void *dev_id)
+{
+	struct rockchip_vpu_dev *vpu = dev_id;
+	u32 status = vepu_read(vpu, VEPU_REG_INTERRUPT);
+
+	vepu_write(vpu, 0, VEPU_REG_INTERRUPT);
+
+	if (status & VEPU_REG_INTERRUPT_BIT) {
+		vepu_write(vpu, 0, VEPU_REG_AXI_CTRL);
+		rockchip_vpu_irq_done(vpu);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int rk3399_vpu_hw_init(struct rockchip_vpu_dev *vpu)
+{
+	/* Bump ACLK to max. possible freq. to improve performance. */
+	clk_set_rate(vpu->clocks[0], RK3399_ACLK_MAX_FREQ);
+	return 0;
+}
+
+static void rk3399_vpu_enc_reset(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+
+	vepu_write(vpu, VEPU_REG_INTERRUPT_DIS_BIT, VEPU_REG_INTERRUPT);
+	vepu_write(vpu, 0, VEPU_REG_ENCODE_START);
+	vepu_write(vpu, 0, VEPU_REG_AXI_CTRL);
+}
+
+/*
+ * Supported codec ops.
+ */
+
+static const struct rockchip_vpu_codec_ops rk3399_vpu_codec_ops[] = {
+	[RK_VPU_CODEC_JPEGE] = {
+		.run = rk3399_vpu_jpege_run,
+		.done = rk3399_vpu_jpege_done,
+		.reset = rk3399_vpu_enc_reset,
+	},
+};
+
+/*
+ * VPU variant.
+ */
+
+const struct rockchip_vpu_variant rk3399_vpu_variant = {
+	.enc_offset = 0x0,
+	.enc_fmts = rk3399_vpu_enc_fmts,
+	.num_enc_fmts = ARRAY_SIZE(rk3399_vpu_enc_fmts),
+	.codec_ops = rk3399_vpu_codec_ops,
+	.vepu_irq = rk3399_vepu_irq,
+	.init = rk3399_vpu_hw_init,
+	.clk_names = {"aclk", "hclk"},
+	.num_clocks = 2
+};
diff --git a/drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c b/drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
new file mode 100644
index 000000000000..03a098f08924
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *
+ * JPEG encoder
+ * ------------
+ * The VPU JPEG encoder produces JPEG baseline sequential format.
+ * The quantization coefficients are 8-bit values, complying with
+ * the baseline specification. Therefore, it requires application-defined
+ * luma and chroma quantization tables. The hardware does entrophy
+ * encoding using internal Huffman tables, as specified in the JPEG
+ * specification.
+ *
+ * In other words, only the luma and chroma quantization tables are
+ * required as application-defined parameters for the encoding operation.
+ *
+ * Quantization luma table values are written to registers
+ * VEPU_swreg_0-VEPU_swreg_15, and chroma table values to
+ * VEPU_swreg_16-VEPU_swreg_31.
+ *
+ * JPEG zigzag order is expected on the quantization tables.
+ */
+
+#include <asm/unaligned.h>
+#include <media/v4l2-mem2mem.h>
+#include "rockchip_vpu.h"
+#include "rockchip_vpu_hw.h"
+#include "rk3399_vpu_regs.h"
+
+#define VEPU_JPEG_QUANT_TABLE_COUNT 16
+
+static void rk3399_vpu_set_src_img_ctrl(struct rockchip_vpu_dev *vpu,
+					struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *pix_fmt = &ctx->src_fmt;
+	u32 reg;
+
+	/* The pix fmt width/height are already MiB aligned
+	 * by .vidioc_s_fmt_vid_cap_mplane() callback
+	 */
+	reg = VEPU_REG_IN_IMG_CTRL_ROW_LEN(pix_fmt->width);
+	vepu_write_relaxed(vpu, reg, VEPU_REG_INPUT_LUMA_INFO);
+
+	reg = VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(0) |
+	      VEPU_REG_IN_IMG_CTRL_OVRFLB(0);
+	vepu_write_relaxed(vpu, reg, VEPU_REG_ENC_OVER_FILL_STRM_OFFSET);
+
+	reg = VEPU_REG_IN_IMG_CTRL_FMT(ctx->vpu_src_fmt->enc_fmt);
+	vepu_write_relaxed(vpu, reg, VEPU_REG_ENC_CTRL1);
+}
+
+static void rk3399_vpu_jpege_set_buffers(struct rockchip_vpu_dev *vpu,
+					 struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *pix_fmt = &ctx->src_fmt;
+	struct vb2_buffer *buf;
+	dma_addr_t dst, src[3];
+	u32 dst_size;
+
+	WARN_ON(pix_fmt->num_planes > 3);
+
+	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	dst = vb2_dma_contig_plane_dma_addr(buf, 0);
+	dst_size = vb2_plane_size(buf, 0);
+
+	vepu_write_relaxed(vpu, dst, VEPU_REG_ADDR_OUTPUT_STREAM);
+	vepu_write_relaxed(vpu, dst_size, VEPU_REG_STR_BUF_LIMIT);
+
+	buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	if (pix_fmt->num_planes == 1) {
+		src[0] = vb2_dma_contig_plane_dma_addr(buf, 0);
+		/* single plane formats we supported are all interlaced */
+		src[1] = src[2] = src[0];
+	} else if (pix_fmt->num_planes == 2) {
+		src[PLANE_Y] = vb2_dma_contig_plane_dma_addr(buf, PLANE_Y);
+		src[PLANE_CB] = vb2_dma_contig_plane_dma_addr(buf, PLANE_CB);
+		src[PLANE_CR] = src[PLANE_CB];
+	} else {
+		src[PLANE_Y] = vb2_dma_contig_plane_dma_addr(buf, PLANE_Y);
+		src[PLANE_CB] = vb2_dma_contig_plane_dma_addr(buf, PLANE_CB);
+		src[PLANE_CR] = vb2_dma_contig_plane_dma_addr(buf, PLANE_CR);
+	}
+
+	vepu_write_relaxed(vpu, src[PLANE_Y], VEPU_REG_ADDR_IN_LUMA);
+	vepu_write_relaxed(vpu, src[PLANE_CR], VEPU_REG_ADDR_IN_CR);
+	vepu_write_relaxed(vpu, src[PLANE_CB], VEPU_REG_ADDR_IN_CB);
+}
+
+static void rk3399_vpu_jpege_set_qtables(struct rockchip_vpu_dev *vpu,
+		__be32 *luma_qtable, __be32 *chroma_qtable)
+{
+	u32 reg, i;
+
+	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
+		reg = get_unaligned_be32(&luma_qtable[i]);
+		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
+
+		reg = get_unaligned_be32(&chroma_qtable[i]);
+		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_CHROMA_QUAT(i));
+	}
+}
+
+void rk3399_vpu_jpege_run(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	__be32 *chroma_qtable = NULL;
+	__be32 *luma_qtable = NULL;
+	u32 reg;
+
+	if (ctx->vpu_dst_fmt->fourcc == V4L2_PIX_FMT_JPEG_RAW) {
+		struct v4l2_ctrl *ctrl;
+
+		ctrl = ctx->ctrls[ROCKCHIP_VPU_ENC_CTRL_Y_QUANT_TBL];
+		luma_qtable = (__be32 *)ctrl->p_cur.p;
+
+		ctrl = ctx->ctrls[ROCKCHIP_VPU_ENC_CTRL_C_QUANT_TBL];
+		chroma_qtable = (__be32 *)ctrl->p_cur.p;
+	}
+
+	/* Switch to JPEG encoder mode before writing registers */
+	vepu_write(vpu, VEPU_REG_ENCODE_FORMAT_JPEG, VEPU_REG_ENCODE_START);
+
+	rk3399_vpu_set_src_img_ctrl(vpu, ctx);
+	rk3399_vpu_jpege_set_buffers(vpu, ctx);
+	if (luma_qtable && chroma_qtable)
+		rk3399_vpu_jpege_set_qtables(vpu, luma_qtable, chroma_qtable);
+
+	/* Make sure that all registers are written at this point. */
+	wmb();
+
+	reg = VEPU_REG_OUTPUT_SWAP32
+		| VEPU_REG_OUTPUT_SWAP16
+		| VEPU_REG_OUTPUT_SWAP8
+		| VEPU_REG_INPUT_SWAP8
+		| VEPU_REG_INPUT_SWAP16
+		| VEPU_REG_INPUT_SWAP32;
+	vepu_write(vpu, reg, VEPU_REG_DATA_ENDIAN);
+
+	reg = VEPU_REG_AXI_CTRL_BURST_LEN(16);
+	vepu_write(vpu, reg, VEPU_REG_AXI_CTRL);
+
+	reg = VEPU_REG_MB_WIDTH(MB_WIDTH(ctx->src_fmt.width))
+		| VEPU_REG_MB_HEIGHT(MB_HEIGHT(ctx->src_fmt.height))
+		| VEPU_REG_FRAME_TYPE_INTRA
+		| VEPU_REG_ENCODE_FORMAT_JPEG
+		| VEPU_REG_ENCODE_ENABLE;
+
+	/* Kick the watchdog and start encoding */
+	schedule_delayed_work(&vpu->watchdog_work, msecs_to_jiffies(2000));
+	vepu_write(vpu, reg, VEPU_REG_ENCODE_START);
+}
+
+void rk3399_vpu_jpege_done(struct rockchip_vpu_ctx *ctx,
+			enum vb2_buffer_state result)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	struct vb2_v4l2_buffer *src, *dst;
+
+	/* Generic done operation */
+	src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+	WARN_ON(!src);
+	WARN_ON(!dst);
+
+	src->sequence = ctx->sequence_out++;
+	dst->sequence = ctx->sequence_cap++;
+	dst->vb2_buf.planes[0].bytesused
+		= vepu_read(vpu, VEPU_REG_STR_BUF_LIMIT) / 8;
+	dst->field = src->field;
+	dst->timecode = src->timecode;
+	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
+	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+	v4l2_m2m_buf_done(src, result);
+	v4l2_m2m_buf_done(dst, result);
+	v4l2_m2m_job_finish(vpu->m2m_dev, ctx->fh.m2m_ctx);
+}
diff --git a/drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h b/drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
new file mode 100644
index 000000000000..04720517a8dc
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
@@ -0,0 +1,601 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *	Alpha Lin <alpha.lin@rock-chips.com>
+ */
+
+#ifndef RK3399_VPU_REGS_H_
+#define RK3399_VPU_REGS_H_
+
+/* Encoder registers. */
+#define VEPU_REG_VP8_QUT_1ST(i)			(0x000 + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_DC_Y2(x)			(((x) & 0x3fff) << 16)
+#define     VEPU_REG_VP8_QUT_DC_Y1(x)			(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_QUT_2ND(i)			(0x004 + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_AC_Y1(x)			(((x) & 0x3fff) << 16)
+#define     VEPU_REG_VP8_QUT_DC_CHR(x)			(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_QUT_3RD(i)			(0x008 + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_AC_CHR(x)			(((x) & 0x3fff) << 16)
+#define     VEPU_REG_VP8_QUT_AC_Y2(x)			(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_QUT_4TH(i)			(0x00c + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_ZB_DC_CHR(x)		(((x) & 0x1ff) << 18)
+#define     VEPU_REG_VP8_QUT_ZB_DC_Y2(x)		(((x) & 0x1ff) << 9)
+#define     VEPU_REG_VP8_QUT_ZB_DC_Y1(x)		(((x) & 0x1ff) << 0)
+#define VEPU_REG_VP8_QUT_5TH(i)			(0x010 + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_ZB_AC_CHR(x)		(((x) & 0x1ff) << 18)
+#define     VEPU_REG_VP8_QUT_ZB_AC_Y2(x)		(((x) & 0x1ff) << 9)
+#define     VEPU_REG_VP8_QUT_ZB_AC_Y1(x)		(((x) & 0x1ff) << 0)
+#define VEPU_REG_VP8_QUT_6TH(i)			(0x014 + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_RND_DC_CHR(x)		(((x) & 0xff) << 16)
+#define     VEPU_REG_VP8_QUT_RND_DC_Y2(x)		(((x) & 0xff) << 8)
+#define     VEPU_REG_VP8_QUT_RND_DC_Y1(x)		(((x) & 0xff) << 0)
+#define VEPU_REG_VP8_QUT_7TH(i)			(0x018 + ((i) * 0x24))
+#define     VEPU_REG_VP8_QUT_RND_AC_CHR(x)		(((x) & 0xff) << 16)
+#define     VEPU_REG_VP8_QUT_RND_AC_Y2(x)		(((x) & 0xff) << 8)
+#define     VEPU_REG_VP8_QUT_RND_AC_Y1(x)		(((x) & 0xff) << 0)
+#define VEPU_REG_VP8_QUT_8TH(i)			(0x01c + ((i) * 0x24))
+#define     VEPU_REG_VP8_SEG_FILTER_LEVEL(x)		(((x) & 0x3f) << 25)
+#define     VEPU_REG_VP8_DEQUT_DC_CHR(x)		(((x) & 0xff) << 17)
+#define     VEPU_REG_VP8_DEQUT_DC_Y2(x)			(((x) & 0x1ff) << 8)
+#define     VEPU_REG_VP8_DEQUT_DC_Y1(x)			(((x) & 0xff) << 0)
+#define VEPU_REG_VP8_QUT_9TH(i)			(0x020 + ((i) * 0x24))
+#define     VEPU_REG_VP8_DEQUT_AC_CHR(x)		(((x) & 0x1ff) << 18)
+#define     VEPU_REG_VP8_DEQUT_AC_Y2(x)			(((x) & 0x1ff) << 9)
+#define     VEPU_REG_VP8_DEQUT_AC_Y1(x)			(((x) & 0x1ff) << 0)
+#define VEPU_REG_ADDR_VP8_SEG_MAP		0x06c
+#define VEPU_REG_VP8_INTRA_4X4_PENALTY(i)	(0x070 + ((i) * 0x4))
+#define     VEPU_REG_VP8_INTRA_4X4_PENALTY_0(x)		(((x) & 0xfff) << 0)
+#define     VEPU_REG_VP8_INTRA_4x4_PENALTY_1(x)		(((x) & 0xfff) << 16)
+#define VEPU_REG_VP8_INTRA_16X16_PENALTY(i)	(0x084 + ((i) * 0x4))
+#define     VEPU_REG_VP8_INTRA_16X16_PENALTY_0(x)	(((x) & 0xfff) << 0)
+#define     VEPU_REG_VP8_INTRA_16X16_PENALTY_1(x)	(((x) & 0xfff) << 16)
+#define VEPU_REG_VP8_CONTROL			0x0a0
+#define     VEPU_REG_VP8_LF_MODE_DELTA_BPRED(x)		(((x) & 0x1f) << 24)
+#define     VEPU_REG_VP8_LF_REF_DELTA_INTRA_MB(x)	(((x) & 0x7f) << 16)
+#define     VEPU_REG_VP8_INTER_TYPE_BIT_COST(x)		(((x) & 0xfff) << 0)
+#define VEPU_REG_VP8_REF_FRAME_VAL		0x0a4
+#define     VEPU_REG_VP8_COEF_DMV_PENALTY(x)		(((x) & 0xfff) << 16)
+#define     VEPU_REG_VP8_REF_FRAME(x)			(((x) & 0xfff) << 0)
+#define VEPU_REG_VP8_LOOP_FILTER_REF_DELTA	0x0a8
+#define     VEPU_REG_VP8_LF_REF_DELTA_ALT_REF(x)	(((x) & 0x7f) << 16)
+#define     VEPU_REG_VP8_LF_REF_DELTA_LAST_REF(x)	(((x) & 0x7f) << 8)
+#define     VEPU_REG_VP8_LF_REF_DELTA_GOLDEN(x)		(((x) & 0x7f) << 0)
+#define VEPU_REG_VP8_LOOP_FILTER_MODE_DELTA	0x0ac
+#define     VEPU_REG_VP8_LF_MODE_DELTA_SPLITMV(x)	(((x) & 0x7f) << 16)
+#define     VEPU_REG_VP8_LF_MODE_DELTA_ZEROMV(x)	(((x) & 0x7f) << 8)
+#define     VEPU_REG_VP8_LF_MODE_DELTA_NEWMV(x)		(((x) & 0x7f) << 0)
+#define	VEPU_REG_JPEG_LUMA_QUAT(i)		(0x000 + ((i) * 0x4))
+#define	VEPU_REG_JPEG_CHROMA_QUAT(i)		(0x040 + ((i) * 0x4))
+#define VEPU_REG_INTRA_SLICE_BITMAP(i)		(0x0b0 + ((i) * 0x4))
+#define VEPU_REG_ADDR_VP8_DCT_PART(i)		(0x0b0 + ((i) * 0x4))
+#define VEPU_REG_INTRA_AREA_CTRL		0x0b8
+#define     VEPU_REG_INTRA_AREA_TOP(x)			(((x) & 0xff) << 24)
+#define     VEPU_REG_INTRA_AREA_BOTTOM(x)		(((x) & 0xff) << 16)
+#define     VEPU_REG_INTRA_AREA_LEFT(x)			(((x) & 0xff) << 8)
+#define     VEPU_REG_INTRA_AREA_RIGHT(x)		(((x) & 0xff) << 0)
+#define VEPU_REG_CIR_INTRA_CTRL			0x0bc
+#define     VEPU_REG_CIR_INTRA_FIRST_MB(x)		(((x) & 0xffff) << 16)
+#define     VEPU_REG_CIR_INTRA_INTERVAL(x)		(((x) & 0xffff) << 0)
+#define VEPU_REG_ADDR_IN_LUMA			0x0c0
+#define VEPU_REG_ADDR_IN_CB			0x0c4
+#define VEPU_REG_ADDR_IN_CR			0x0c8
+#define VEPU_REG_STR_HDR_REM_MSB		0x0cc
+#define VEPU_REG_STR_HDR_REM_LSB		0x0d0
+#define VEPU_REG_STR_BUF_LIMIT			0x0d4
+#define VEPU_REG_AXI_CTRL			0x0d8
+#define     VEPU_REG_AXI_CTRL_READ_ID(x)		(((x) & 0xff) << 24)
+#define     VEPU_REG_AXI_CTRL_WRITE_ID(x)		(((x) & 0xff) << 16)
+#define     VEPU_REG_AXI_CTRL_BURST_LEN(x)		(((x) & 0x3f) << 8)
+#define     VEPU_REG_AXI_CTRL_INCREMENT_MODE(x)		(((x) & 0x01) << 2)
+#define     VEPU_REG_AXI_CTRL_BIRST_DISCARD(x)		(((x) & 0x01) << 1)
+#define     VEPU_REG_AXI_CTRL_BIRST_DISABLE		BIT(0)
+#define VEPU_QP_ADJUST_MAD_DELTA_ROI		0x0dc
+#define     VEPU_REG_ROI_QP_DELTA_1			(((x) & 0xf) << 12)
+#define     VEPU_REG_ROI_QP_DELTA_2			(((x) & 0xf) << 8)
+#define     VEPU_REG_MAD_QP_ADJUSTMENT			(((x) & 0xf) << 0)
+#define VEPU_REG_ADDR_REF_LUMA			0x0e0
+#define VEPU_REG_ADDR_REF_CHROMA		0x0e4
+#define VEPU_REG_QP_SUM_DIV2			0x0e8
+#define     VEPU_REG_QP_SUM(x)				(((x) & 0x001fffff) * 2)
+#define VEPU_REG_ENC_CTRL0			0x0ec
+#define     VEPU_REG_DISABLE_QUARTER_PIXEL_MV		BIT(28)
+#define     VEPU_REG_DEBLOCKING_FILTER_MODE(x)		(((x) & 0x3) << 24)
+#define     VEPU_REG_CABAC_INIT_IDC(x)			(((x) & 0x3) << 21)
+#define     VEPU_REG_ENTROPY_CODING_MODE		BIT(20)
+#define     VEPU_REG_H264_TRANS8X8_MODE			BIT(17)
+#define     VEPU_REG_H264_INTER4X4_MODE			BIT(16)
+#define     VEPU_REG_H264_STREAM_MODE			BIT(15)
+#define     VEPU_REG_H264_SLICE_SIZE(x)			(((x) & 0x7f) << 8)
+#define VEPU_REG_ENC_OVER_FILL_STRM_OFFSET	0x0f0
+#define     VEPU_REG_STREAM_START_OFFSET(x)		(((x) & 0x3f) << 16)
+#define     VEPU_REG_SKIP_MACROBLOCK_PENALTY(x)		(((x) & 0xff) << 8)
+#define     VEPU_REG_IN_IMG_CTRL_OVRFLR_D4(x)		(((x) & 0x3) << 4)
+#define     VEPU_REG_IN_IMG_CTRL_OVRFLB(x)		(((x) & 0xf) << 0)
+#define VEPU_REG_INPUT_LUMA_INFO		0x0f4
+#define     VEPU_REG_IN_IMG_CHROMA_OFFSET(x)		(((x) & 0x7) << 20)
+#define     VEPU_REG_IN_IMG_LUMA_OFFSET(x)		(((x) & 0x7) << 16)
+#define     VEPU_REG_IN_IMG_CTRL_ROW_LEN(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_RLC_SUM			0x0f8
+#define     VEPU_REG_RLC_SUM_OUT(x)			(((x) & 0x007fffff) * 4)
+#define VEPU_REG_SPLIT_PENALTY_4X4		0x0f8
+#define	    VEPU_REG_VP8_SPLIT_PENALTY_4X4		(((x) & 0x1ff) << 19)
+#define VEPU_REG_ADDR_REC_LUMA			0x0fc
+#define VEPU_REG_ADDR_REC_CHROMA		0x100
+#define VEPU_REG_CHECKPOINT(i)			(0x104 + ((i) * 0x4))
+#define     VEPU_REG_CHECKPOINT_CHECK0(x)		(((x) & 0xffff))
+#define     VEPU_REG_CHECKPOINT_CHECK1(x)		(((x) & 0xffff) << 16)
+#define     VEPU_REG_CHECKPOINT_RESULT(x)		((((x) >> (16 - 16 \
+							 * (i & 1))) & 0xffff) \
+							 * 32)
+#define VEPU_REG_VP8_SEG0_QUANT_AC_Y1		0x104
+#define     VEPU_REG_VP8_SEG0_RND_AC_Y1(x)		(((x) & 0xff) << 23)
+#define     VEPU_REG_VP8_SEG0_ZBIN_AC_Y1(x)		(((x) & 0x1ff) << 14)
+#define     VEPU_REG_VP8_SEG0_QUT_AC_Y1(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_SEG0_QUANT_DC_Y2		0x108
+#define     VEPU_REG_VP8_SEG0_RND_DC_Y2(x)		(((x) & 0xff) << 23)
+#define     VEPU_REG_VP8_SEG0_ZBIN_DC_Y2(x)		(((x) & 0x1ff) << 14)
+#define     VEPU_REG_VP8_SEG0_QUT_DC_Y2(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_SEG0_QUANT_AC_Y2		0x10c
+#define     VEPU_REG_VP8_SEG0_RND_AC_Y2(x)		(((x) & 0xff) << 23)
+#define     VEPU_REG_VP8_SEG0_ZBIN_AC_Y2(x)		(((x) & 0x1ff) << 14)
+#define     VEPU_REG_VP8_SEG0_QUT_AC_Y2(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_SEG0_QUANT_DC_CHR		0x110
+#define     VEPU_REG_VP8_SEG0_RND_DC_CHR(x)		(((x) & 0xff) << 23)
+#define     VEPU_REG_VP8_SEG0_ZBIN_DC_CHR(x)		(((x) & 0x1ff) << 14)
+#define     VEPU_REG_VP8_SEG0_QUT_DC_CHR(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_SEG0_QUANT_AC_CHR		0x114
+#define     VEPU_REG_VP8_SEG0_RND_AC_CHR(x)		(((x) & 0xff) << 23)
+#define     VEPU_REG_VP8_SEG0_ZBIN_AC_CHR(x)		(((x) & 0x1ff) << 14)
+#define     VEPU_REG_VP8_SEG0_QUT_AC_CHR(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_VP8_SEG0_QUANT_DQUT		0x118
+#define     VEPU_REG_VP8_MV_REF_IDX1(x)			(((x) & 0x03) << 26)
+#define     VEPU_REG_VP8_SEG0_DQUT_DC_Y2(x)		(((x) & 0x1ff) << 17)
+#define     VEPU_REG_VP8_SEG0_DQUT_AC_Y1(x)		(((x) & 0x1ff) << 8)
+#define     VEPU_REG_VP8_SEG0_DQUT_DC_Y1(x)		(((x) & 0xff) << 0)
+#define VEPU_REG_CHKPT_WORD_ERR(i)		(0x118 + ((i) * 0x4))
+#define     VEPU_REG_CHKPT_WORD_ERR_CHK0(x)		(((x) & 0xffff))
+#define     VEPU_REG_CHKPT_WORD_ERR_CHK1(x)		(((x) & 0xffff) << 16)
+#define VEPU_REG_VP8_SEG0_QUANT_DQUT_1		0x11c
+#define     VEPU_REG_VP8_SEGMENT_MAP_UPDATE		BIT(30)
+#define     VEPU_REG_VP8_SEGMENT_EN			BIT(29)
+#define     VEPU_REG_VP8_MV_REF_IDX2_EN			BIT(28)
+#define     VEPU_REG_VP8_MV_REF_IDX2(x)			(((x) & 0x03) << 26)
+#define     VEPU_REG_VP8_SEG0_DQUT_AC_CHR(x)		(((x) & 0x1ff) << 17)
+#define     VEPU_REG_VP8_SEG0_DQUT_DC_CHR(x)		(((x) & 0xff) << 9)
+#define     VEPU_REG_VP8_SEG0_DQUT_AC_Y2(x)		(((x) & 0x1ff) << 0)
+#define VEPU_REG_VP8_BOOL_ENC_VALUE		0x120
+#define VEPU_REG_CHKPT_DELTA_QP			0x124
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK0(x)		(((x) & 0x0f) << 0)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK1(x)		(((x) & 0x0f) << 4)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK2(x)		(((x) & 0x0f) << 8)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK3(x)		(((x) & 0x0f) << 12)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK4(x)		(((x) & 0x0f) << 16)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK5(x)		(((x) & 0x0f) << 20)
+#define     VEPU_REG_CHKPT_DELTA_QP_CHK6(x)		(((x) & 0x0f) << 24)
+#define VEPU_REG_VP8_ENC_CTRL2			0x124
+#define     VEPU_REG_VP8_ZERO_MV_PENALTY_FOR_REF2(x)	(((x) & 0xff) << 24)
+#define     VEPU_REG_VP8_FILTER_SHARPNESS(x)		(((x) & 0x07) << 21)
+#define     VEPU_REG_VP8_FILTER_LEVEL(x)		(((x) & 0x3f) << 15)
+#define     VEPU_REG_VP8_DCT_PARTITION_CNT(x)		(((x) & 0x03) << 13)
+#define     VEPU_REG_VP8_BOOL_ENC_VALUE_BITS(x)		(((x) & 0x1f) << 8)
+#define     VEPU_REG_VP8_BOOL_ENC_RANGE(x)		(((x) & 0xff) << 0)
+#define VEPU_REG_ENC_CTRL1			0x128
+#define     VEPU_REG_MAD_THRESHOLD(x)			(((x) & 0x3f) << 24)
+#define     VEPU_REG_COMPLETED_SLICES(x)		(((x) & 0xff) << 16)
+#define     VEPU_REG_IN_IMG_CTRL_FMT(x)			(((x) & 0xf) << 4)
+#define     VEPU_REG_IN_IMG_ROTATE_MODE(x)		(((x) & 0x3) << 2)
+#define     VEPU_REG_SIZE_TABLE_PRESENT			BIT(0)
+#define VEPU_REG_INTRA_INTER_MODE		0x12c
+#define     VEPU_REG_INTRA16X16_MODE(x)			(((x) & 0xffff) << 16)
+#define     VEPU_REG_INTER_MODE(x)			(((x) & 0xffff) << 0)
+#define VEPU_REG_ENC_CTRL2			0x130
+#define     VEPU_REG_PPS_INIT_QP(x)			(((x) & 0x3f) << 26)
+#define     VEPU_REG_SLICE_FILTER_ALPHA(x)		(((x) & 0xf) << 22)
+#define     VEPU_REG_SLICE_FILTER_BETA(x)		(((x) & 0xf) << 18)
+#define     VEPU_REG_CHROMA_QP_OFFSET(x)		(((x) & 0x1f) << 13)
+#define     VEPU_REG_FILTER_DISABLE			BIT(5)
+#define     VEPU_REG_IDR_PIC_ID(x)			(((x) & 0xf) << 1)
+#define     VEPU_REG_CONSTRAINED_INTRA_PREDICTION	BIT(0)
+#define VEPU_REG_ADDR_OUTPUT_STREAM		0x134
+#define VEPU_REG_ADDR_OUTPUT_CTRL		0x138
+#define VEPU_REG_ADDR_NEXT_PIC			0x13c
+#define VEPU_REG_ADDR_MV_OUT			0x140
+#define VEPU_REG_ADDR_CABAC_TBL			0x144
+#define VEPU_REG_ROI1				0x148
+#define     VEPU_REG_ROI1_TOP_MB(x)			(((x) & 0xff) << 24)
+#define     VEPU_REG_ROI1_BOTTOM_MB(x)			(((x) & 0xff) << 16)
+#define     VEPU_REG_ROI1_LEFT_MB(x)			(((x) & 0xff) << 8)
+#define     VEPU_REG_ROI1_RIGHT_MB(x)			(((x) & 0xff) << 0)
+#define VEPU_REG_ROI2				0x14c
+#define     VEPU_REG_ROI2_TOP_MB(x)			(((x) & 0xff) << 24)
+#define     VEPU_REG_ROI2_BOTTOM_MB(x)			(((x) & 0xff) << 16)
+#define     VEPU_REG_ROI2_LEFT_MB(x)			(((x) & 0xff) << 8)
+#define     VEPU_REG_ROI2_RIGHT_MB(x)			(((x) & 0xff) << 0)
+#define VEPU_REG_STABLE_MATRIX(i)		(0x150 + ((i) * 0x4))
+#define VEPU_REG_STABLE_MOTION_SUM		0x174
+#define VEPU_REG_STABILIZATION_OUTPUT		0x178
+#define     VEPU_REG_STABLE_MIN_VALUE(x)		(((x) & 0xffffff) << 8)
+#define     VEPU_REG_STABLE_MODE_SEL(x)			(((x) & 0x3) << 6)
+#define     VEPU_REG_STABLE_HOR_GMV(x)			(((x) & 0x3f) << 0)
+#define VEPU_REG_RGB2YUV_CONVERSION_COEF1	0x17c
+#define     VEPU_REG_RGB2YUV_CONVERSION_COEFB(x)	(((x) & 0xffff) << 16)
+#define     VEPU_REG_RGB2YUV_CONVERSION_COEFA(x)	(((x) & 0xffff) << 0)
+#define VEPU_REG_RGB2YUV_CONVERSION_COEF2	0x180
+#define     VEPU_REG_RGB2YUV_CONVERSION_COEFE(x)	(((x) & 0xffff) << 16)
+#define     VEPU_REG_RGB2YUV_CONVERSION_COEFC(x)	(((x) & 0xffff) << 0)
+#define VEPU_REG_RGB2YUV_CONVERSION_COEF3	0x184
+#define     VEPU_REG_RGB2YUV_CONVERSION_COEFF(x)	(((x) & 0xffff) << 0)
+#define VEPU_REG_RGB_MASK_MSB			0x188
+#define     VEPU_REG_RGB_MASK_B_MSB(x)			(((x) & 0x1f) << 16)
+#define     VEPU_REG_RGB_MASK_G_MSB(x)			(((x) & 0x1f) << 8)
+#define     VEPU_REG_RGB_MASK_R_MSB(x)			(((x) & 0x1f) << 0)
+#define VEPU_REG_MV_PENALTY			0x18c
+#define     VEPU_REG_1MV_PENALTY(x)			(((x) & 0x3ff) << 21)
+#define     VEPU_REG_QMV_PENALTY(x)			(((x) & 0x3ff) << 11)
+#define     VEPU_REG_4MV_PENALTY(x)			(((x) & 0x3ff) << 1)
+#define     VEPU_REG_SPLIT_MV_MODE_EN			BIT(0)
+#define VEPU_REG_QP_VAL				0x190
+#define     VEPU_REG_H264_LUMA_INIT_QP(x)		(((x) & 0x3f) << 26)
+#define     VEPU_REG_H264_QP_MAX(x)			(((x) & 0x3f) << 20)
+#define     VEPU_REG_H264_QP_MIN(x)			(((x) & 0x3f) << 14)
+#define     VEPU_REG_H264_CHKPT_DISTANCE(x)		(((x) & 0xfff) << 0)
+#define VEPU_REG_VP8_SEG0_QUANT_DC_Y1		0x190
+#define     VEPU_REG_VP8_SEG0_RND_DC_Y1(x)		(((x) & 0xff) << 23)
+#define     VEPU_REG_VP8_SEG0_ZBIN_DC_Y1(x)		(((x) & 0x1ff) << 14)
+#define     VEPU_REG_VP8_SEG0_QUT_DC_Y1(x)		(((x) & 0x3fff) << 0)
+#define VEPU_REG_MVC_RELATE			0x198
+#define     VEPU_REG_ZERO_MV_FAVOR_D2(x)		(((x) & 0xf) << 20)
+#define     VEPU_REG_PENALTY_4X4MV(x)			(((x) & 0x1ff) << 11)
+#define     VEPU_REG_MVC_VIEW_ID(x)			(((x) & 0x7) << 8)
+#define     VEPU_REG_MVC_ANCHOR_PIC_FLAG		BIT(7)
+#define     VEPU_REG_MVC_PRIORITY_ID(x)			(((x) & 0x7) << 4)
+#define     VEPU_REG_MVC_TEMPORAL_ID(x)			(((x) & 0x7) << 1)
+#define     VEPU_REG_MVC_INTER_VIEW_FLAG		BIT(0)
+#define VEPU_REG_ENCODE_START			0x19c
+#define     VEPU_REG_MB_HEIGHT(x)			(((x) & 0x1ff) << 20)
+#define     VEPU_REG_MB_WIDTH(x)			(((x) & 0x1ff) << 8)
+#define     VEPU_REG_FRAME_TYPE_INTER			(0 << 6)
+#define     VEPU_REG_FRAME_TYPE_INTRA			(1 << 6)
+#define     VEPU_REG_FRAME_TYPE_MVCINTER		(2 << 6)
+#define     VEPU_REG_ENCODE_FORMAT_JPEG			(2 << 4)
+#define     VEPU_REG_ENCODE_FORMAT_H264			(3 << 4)
+#define     VEPU_REG_ENCODE_ENABLE			BIT(0)
+#define VEPU_REG_MB_CTRL			0x1a0
+#define     VEPU_REG_MB_CNT_OUT(x)			(((x) & 0xffff) << 16)
+#define     VEPU_REG_MB_CNT_SET(x)			(((x) & 0xffff) << 0)
+#define VEPU_REG_DATA_ENDIAN			0x1a4
+#define     VEPU_REG_INPUT_SWAP8			BIT(31)
+#define     VEPU_REG_INPUT_SWAP16			BIT(30)
+#define     VEPU_REG_INPUT_SWAP32			BIT(29)
+#define     VEPU_REG_OUTPUT_SWAP8			BIT(28)
+#define     VEPU_REG_OUTPUT_SWAP16			BIT(27)
+#define     VEPU_REG_OUTPUT_SWAP32			BIT(26)
+#define     VEPU_REG_TEST_IRQ				BIT(24)
+#define     VEPU_REG_TEST_COUNTER(x)			(((x) & 0xf) << 20)
+#define     VEPU_REG_TEST_REG				BIT(19)
+#define     VEPU_REG_TEST_MEMORY			BIT(18)
+#define     VEPU_REG_TEST_LEN(x)			(((x) & 0x3ffff) << 0)
+#define VEPU_REG_ENC_CTRL3			0x1a8
+#define     VEPU_REG_PPS_ID(x)				(((x) & 0xff) << 24)
+#define     VEPU_REG_INTRA_PRED_MODE(x)			(((x) & 0xff) << 16)
+#define     VEPU_REG_FRAME_NUM(x)			(((x) & 0xffff) << 0)
+#define VEPU_REG_ENC_CTRL4			0x1ac
+#define     VEPU_REG_MV_PENALTY_16X8_8X16(x)		(((x) & 0x3ff) << 20)
+#define     VEPU_REG_MV_PENALTY_8X8(x)			(((x) & 0x3ff) << 10)
+#define     VEPU_REG_MV_PENALTY_8X4_4X8(x)		(((x) & 0x3ff) << 0)
+#define VEPU_REG_ADDR_VP8_PROB_CNT		0x1b0
+#define VEPU_REG_INTERRUPT			0x1b4
+#define     VEPU_REG_INTERRUPT_NON			BIT(28)
+#define     VEPU_REG_MV_WRITE_EN			BIT(24)
+#define     VEPU_REG_RECON_WRITE_DIS			BIT(20)
+#define     VEPU_REG_INTERRUPT_SLICE_READY_EN		BIT(16)
+#define     VEPU_REG_CLK_GATING_EN			BIT(12)
+#define     VEPU_REG_INTERRUPT_TIMEOUT_EN		BIT(10)
+#define     VEPU_REG_INTERRUPT_RESET			BIT(9)
+#define     VEPU_REG_INTERRUPT_DIS_BIT			BIT(8)
+#define     VEPU_REG_INTERRUPT_TIMEOUT			BIT(6)
+#define     VEPU_REG_INTERRUPT_BUFFER_FULL		BIT(5)
+#define     VEPU_REG_INTERRUPT_BUS_ERROR		BIT(4)
+#define     VEPU_REG_INTERRUPT_FUSE			BIT(3)
+#define     VEPU_REG_INTERRUPT_SLICE_READY		BIT(2)
+#define     VEPU_REG_INTERRUPT_FRAME_READY		BIT(1)
+#define     VEPU_REG_INTERRUPT_BIT			BIT(0)
+#define VEPU_REG_DMV_PENALTY_TBL(i)		(0x1E0 + ((i) * 0x4))
+#define     VEPU_REG_DMV_PENALTY_TABLE_BIT(x, i)        (x << i * 8)
+#define VEPU_REG_DMV_Q_PIXEL_PENALTY_TBL(i)	(0x260 + ((i) * 0x4))
+#define     VEPU_REG_DMV_Q_PIXEL_PENALTY_TABLE_BIT(x, i)	(x << i * 8)
+
+/* vpu decoder register */
+#define VDPU_REG_DEC_CTRL0			0x0c8
+#define     VDPU_REG_REF_BUF_CTRL2_REFBU2_PICID(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_REF_BUF_CTRL2_REFBU2_THR(x)	(((x) & 0xfff) << 13)
+#define     VDPU_REG_CONFIG_TILED_MODE_LSB		BIT(12)
+#define     VDPU_REG_CONFIG_DEC_ADV_PRE_DIS		BIT(11)
+#define     VDPU_REG_CONFIG_DEC_SCMD_DIS		BIT(10)
+#define     VDPU_REG_DEC_CTRL0_SKIP_MODE		BIT(9)
+#define     VDPU_REG_DEC_CTRL0_FILTERING_DIS		BIT(8)
+#define     VDPU_REG_DEC_CTRL0_PIC_FIXED_QUANT		BIT(7)
+#define     VDPU_REG_CONFIG_DEC_LATENCY(x)		(((x) & 0x3f) << 1)
+#define     VDPU_REG_CONFIG_TILED_MODE_MSB(x)		BIT(0)
+#define     VDPU_REG_CONFIG_DEC_OUT_TILED_E		BIT(0)
+#define VDPU_REG_STREAM_LEN			0x0cc
+#define     VDPU_REG_DEC_CTRL3_INIT_QP(x)		(((x) & 0x3f) << 25)
+#define     VDPU_REG_DEC_STREAM_LEN_HI			BIT(24)
+#define     VDPU_REG_DEC_CTRL3_STREAM_LEN(x)		(((x) & 0xffffff) << 0)
+#define VDPU_REG_ERROR_CONCEALMENT		0x0d0
+#define     VDPU_REG_REF_BUF_CTRL2_APF_THRESHOLD(x)	(((x) & 0x3fff) << 17)
+#define     VDPU_REG_ERR_CONC_STARTMB_X(x)		(((x) & 0x1ff) << 8)
+#define     VDPU_REG_ERR_CONC_STARTMB_Y(x)		(((x) & 0xff) << 0)
+#define VDPU_REG_DEC_FORMAT			0x0d4
+#define     VDPU_REG_DEC_CTRL0_DEC_MODE(x)		(((x) & 0xf) << 0)
+#define VDPU_REG_DATA_ENDIAN			0x0d8
+#define     VDPU_REG_CONFIG_DEC_STRENDIAN_E		BIT(5)
+#define     VDPU_REG_CONFIG_DEC_STRSWAP32_E		BIT(4)
+#define     VDPU_REG_CONFIG_DEC_OUTSWAP32_E		BIT(3)
+#define     VDPU_REG_CONFIG_DEC_INSWAP32_E		BIT(2)
+#define     VDPU_REG_CONFIG_DEC_OUT_ENDIAN		BIT(1)
+#define     VDPU_REG_CONFIG_DEC_IN_ENDIAN		BIT(0)
+#define VDPU_REG_INTERRUPT			0x0dc
+#define     VDPU_REG_INTERRUPT_DEC_TIMEOUT		BIT(13)
+#define     VDPU_REG_INTERRUPT_DEC_ERROR_INT		BIT(12)
+#define     VDPU_REG_INTERRUPT_DEC_PIC_INF		BIT(10)
+#define     VDPU_REG_INTERRUPT_DEC_SLICE_INT		BIT(9)
+#define     VDPU_REG_INTERRUPT_DEC_ASO_INT		BIT(8)
+#define     VDPU_REG_INTERRUPT_DEC_BUFFER_INT		BIT(6)
+#define     VDPU_REG_INTERRUPT_DEC_BUS_INT		BIT(5)
+#define     VDPU_REG_INTERRUPT_DEC_RDY_INT		BIT(4)
+#define     VDPU_REG_INTERRUPT_DEC_IRQ_DIS		BIT(1)
+#define     VDPU_REG_INTERRUPT_DEC_IRQ			BIT(0)
+#define VDPU_REG_AXI_CTRL			0x0e0
+#define     VDPU_REG_AXI_DEC_SEL			BIT(23)
+#define     VDPU_REG_CONFIG_DEC_DATA_DISC_E		BIT(22)
+#define     VDPU_REG_PARAL_BUS_E(x)			BIT(21)
+#define     VDPU_REG_CONFIG_DEC_MAX_BURST(x)		(((x) & 0x1f) << 16)
+#define     VDPU_REG_DEC_CTRL0_DEC_AXI_WR_ID(x)		(((x) & 0xff) << 8)
+#define     VDPU_REG_CONFIG_DEC_AXI_RD_ID(x)		(((x) & 0xff) << 0)
+#define VDPU_REG_EN_FLAGS			0x0e4
+#define     VDPU_REG_AHB_HLOCK_E			BIT(31)
+#define     VDPU_REG_CACHE_E				BIT(29)
+#define     VDPU_REG_PREFETCH_SINGLE_CHANNEL_E		BIT(28)
+#define     VDPU_REG_INTRA_3_CYCLE_ENHANCE		BIT(27)
+#define     VDPU_REG_INTRA_DOUBLE_SPEED			BIT(26)
+#define     VDPU_REG_INTER_DOUBLE_SPEED			BIT(25)
+#define     VDPU_REG_DEC_CTRL3_START_CODE_E		BIT(22)
+#define     VDPU_REG_DEC_CTRL3_CH_8PIX_ILEAV_E		BIT(21)
+#define     VDPU_REG_DEC_CTRL0_RLC_MODE_E		BIT(20)
+#define     VDPU_REG_DEC_CTRL0_DIVX3_E			BIT(19)
+#define     VDPU_REG_DEC_CTRL0_PJPEG_E			BIT(18)
+#define     VDPU_REG_DEC_CTRL0_PIC_INTERLACE_E		BIT(17)
+#define     VDPU_REG_DEC_CTRL0_PIC_FIELDMODE_E		BIT(16)
+#define     VDPU_REG_DEC_CTRL0_PIC_B_E			BIT(15)
+#define     VDPU_REG_DEC_CTRL0_PIC_INTER_E		BIT(14)
+#define     VDPU_REG_DEC_CTRL0_PIC_TOPFIELD_E		BIT(13)
+#define     VDPU_REG_DEC_CTRL0_FWD_INTERLACE_E		BIT(12)
+#define     VDPU_REG_DEC_CTRL0_SORENSON_E		BIT(11)
+#define     VDPU_REG_DEC_CTRL0_WRITE_MVS_E		BIT(10)
+#define     VDPU_REG_DEC_CTRL0_REF_TOPFIELD_E		BIT(9)
+#define     VDPU_REG_DEC_CTRL0_REFTOPFIRST_E		BIT(8)
+#define     VDPU_REG_DEC_CTRL0_SEQ_MBAFF_E		BIT(7)
+#define     VDPU_REG_DEC_CTRL0_PICORD_COUNT_E		BIT(6)
+#define     VDPU_REG_CONFIG_DEC_TIMEOUT_E		BIT(5)
+#define     VDPU_REG_CONFIG_DEC_CLK_GATE_E		BIT(4)
+#define     VDPU_REG_DEC_CTRL0_DEC_OUT_DIS		BIT(2)
+#define     VDPU_REG_REF_BUF_CTRL2_REFBU2_BUF_E		BIT(1)
+#define     VDPU_REG_INTERRUPT_DEC_E			BIT(0)
+#define VDPU_REG_SOFT_RESET			0x0e8
+#define VDPU_REG_PRED_FLT			0x0ec
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_0(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_1(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_2(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_ADDITIONAL_CHROMA_ADDRESS	0x0f0
+#define VDPU_REG_ADDR_QTABLE			0x0f4
+#define VDPU_REG_DIRECT_MV_ADDR			0x0f8
+#define VDPU_REG_ADDR_DST			0x0fc
+#define VDPU_REG_ADDR_STR			0x100
+#define VDPU_REG_REFBUF_RELATED			0x104
+#define VDPU_REG_FWD_PIC(i)			(0x128 + ((i) * 0x4))
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F5(x)		(((x) & 0x1f) << 25)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F4(x)		(((x) & 0x1f) << 20)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F3(x)		(((x) & 0x1f) << 15)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F2(x)		(((x) & 0x1f) << 10)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F1(x)		(((x) & 0x1f) << 5)
+#define     VDPU_REG_FWD_PIC_PINIT_RLIST_F0(x)		(((x) & 0x1f) << 0)
+#define VDPU_REG_REF_PIC(i)			(0x130 + ((i) * 0x4))
+#define     VDPU_REG_REF_PIC_REFER1_NBR(x)		(((x) & 0xffff) << 16)
+#define     VDPU_REG_REF_PIC_REFER0_NBR(x)		(((x) & 0xffff) << 0)
+#define VDPU_REG_H264_ADDR_REF(i)			(0x150 + ((i) * 0x4))
+#define     VDPU_REG_ADDR_REF_FIELD_E			BIT(1)
+#define     VDPU_REG_ADDR_REF_TOPC_E			BIT(0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST0		0x190
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F5(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F4(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F3(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F2(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F1(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F0(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST1		0x194
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F11(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F10(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F9(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F8(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F7(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F6(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST2		0x198
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F15(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F14(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F13(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_F12(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST3		0x19c
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B5(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B4(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B3(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B2(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B1(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B0(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST4		0x1a0
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B11(x)	(((x) & 0x1f) << 25)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B10(x)	(((x) & 0x1f) << 20)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B9(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B8(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B7(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B6(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST5		0x1a4
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B15(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B14(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B13(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_REF_PIC_BINIT_RLIST_B12(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_INITIAL_REF_PIC_LIST6		0x1a8
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F3(x)	(((x) & 0x1f) << 15)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F2(x)	(((x) & 0x1f) << 10)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F1(x)	(((x) & 0x1f) << 5)
+#define     VDPU_REG_BD_P_REF_PIC_PINIT_RLIST_F0(x)	(((x) & 0x1f) << 0)
+#define VDPU_REG_LT_REF				0x1ac
+#define VDPU_REG_VALID_REF			0x1b0
+#define VDPU_REG_H264_PIC_MB_SIZE		0x1b8
+#define     VDPU_REG_DEC_CTRL2_CH_QP_OFFSET2(x)		(((x) & 0x1f) << 22)
+#define     VDPU_REG_DEC_CTRL2_CH_QP_OFFSET(x)		(((x) & 0x1f) << 17)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_HEIGHT_P(x)	(((x) & 0xff) << 9)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_WIDTH(x)		(((x) & 0x1ff) << 0)
+#define VDPU_REG_H264_CTRL			0x1bc
+#define     VDPU_REG_DEC_CTRL4_WEIGHT_BIPR_IDC(x)	(((x) & 0x3) << 16)
+#define     VDPU_REG_DEC_CTRL1_REF_FRAMES(x)		(((x) & 0x1f) << 0)
+#define VDPU_REG_CURRENT_FRAME			0x1c0
+#define     VDPU_REG_DEC_CTRL5_FILT_CTRL_PRES		BIT(31)
+#define     VDPU_REG_DEC_CTRL5_RDPIC_CNT_PRES		BIT(30)
+#define     VDPU_REG_DEC_CTRL4_FRAMENUM_LEN(x)		(((x) & 0x1f) << 16)
+#define     VDPU_REG_DEC_CTRL4_FRAMENUM(x)		(((x) & 0xffff) << 0)
+#define VDPU_REG_REF_FRAME			0x1c4
+#define     VDPU_REG_DEC_CTRL5_REFPIC_MK_LEN(x)		(((x) & 0x7ff) << 16)
+#define     VDPU_REG_DEC_CTRL5_IDR_PIC_ID(x)		(((x) & 0xffff) << 0)
+#define VDPU_REG_DEC_CTRL6			0x1c8
+#define     VDPU_REG_DEC_CTRL6_PPS_ID(x)		(((x) & 0xff) << 24)
+#define     VDPU_REG_DEC_CTRL6_REFIDX1_ACTIVE(x)	(((x) & 0x1f) << 19)
+#define     VDPU_REG_DEC_CTRL6_REFIDX0_ACTIVE(x)	(((x) & 0x1f) << 14)
+#define     VDPU_REG_DEC_CTRL6_POC_LENGTH(x)		(((x) & 0xff) << 0)
+#define VDPU_REG_ENABLE_FLAG			0x1cc
+#define     VDPU_REG_DEC_CTRL5_IDR_PIC_E		BIT(8)
+#define     VDPU_REG_DEC_CTRL4_DIR_8X8_INFER_E		BIT(7)
+#define     VDPU_REG_DEC_CTRL4_BLACKWHITE_E		BIT(6)
+#define     VDPU_REG_DEC_CTRL4_CABAC_E			BIT(5)
+#define     VDPU_REG_DEC_CTRL4_WEIGHT_PRED_E		BIT(4)
+#define     VDPU_REG_DEC_CTRL5_CONST_INTRA_E		BIT(3)
+#define     VDPU_REG_DEC_CTRL5_8X8TRANS_FLAG_E		BIT(2)
+#define     VDPU_REG_DEC_CTRL2_TYPE1_QUANT_E		BIT(1)
+#define     VDPU_REG_DEC_CTRL2_FIELDPIC_FLAG_E		BIT(0)
+#define VDPU_REG_VP8_PIC_MB_SIZE		0x1e0
+#define     VDPU_REG_DEC_PIC_MB_WIDTH(x)		(((x) & 0x1ff) << 23)
+#define	    VDPU_REG_DEC_MB_WIDTH_OFF(x)		(((x) & 0xf) << 19)
+#define	    VDPU_REG_DEC_PIC_MB_HEIGHT_P(x)		(((x) & 0xff) << 11)
+#define     VDPU_REG_DEC_MB_HEIGHT_OFF(x)		(((x) & 0xf) << 7)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT(x)		(((x) & 0x7) << 3)
+#define     VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT(x)		(((x) & 0x7) << 0)
+#define VDPU_REG_VP8_DCT_START_BIT		0x1e4
+#define     VDPU_REG_DEC_CTRL4_DCT1_START_BIT(x)	(((x) & 0x3f) << 26)
+#define     VDPU_REG_DEC_CTRL4_DCT2_START_BIT(x)	(((x) & 0x3f) << 20)
+#define     VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT		BIT(13)
+#define     VDPU_REG_DEC_CTRL4_BILIN_MC_E		BIT(12)
+#define VDPU_REG_VP8_CTRL0			0x1e8
+#define     VDPU_REG_DEC_CTRL2_STRM_START_BIT(x)	(((x) & 0x3f) << 26)
+#define     VDPU_REG_DEC_CTRL2_STRM1_START_BIT(x)	(((x) & 0x3f) << 18)
+#define     VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE(x)		(((x) & 0xff) << 8)
+#define     VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE(x)		(((x) & 0xff) << 0)
+#define VDPU_REG_VP8_DATA_VAL			0x1f0
+#define     VDPU_REG_DEC_CTRL6_COEFFS_PART_AM(x)	(((x) & 0xf) << 24)
+#define     VDPU_REG_DEC_CTRL6_STREAM1_LEN(x)		(((x) & 0xffffff) << 0)
+#define VDPU_REG_PRED_FLT7			0x1f4
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_5_1(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_5_2(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_5_3(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT8			0x1f8
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_6_0(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_6_1(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_6_2(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT9			0x1fc
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_6_3(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_7_0(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_7_1(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT10			0x200
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_7_2(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_7_3(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_2_M1(x)	(((x) & 0x3) << 10)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_2_4(x)		(((x) & 0x3) << 8)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_4_M1(x)	(((x) & 0x3) << 6)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_4_4(x)		(((x) & 0x3) << 4)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_6_M1(x)	(((x) & 0x3) << 2)
+#define     VDPU_REG_BD_REF_PIC_PRED_TAP_6_4(x)		(((x) & 0x3) << 0)
+#define VDPU_REG_FILTER_LEVEL			0x204
+#define     VDPU_REG_REF_PIC_LF_LEVEL_0(x)		(((x) & 0x3f) << 18)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_1(x)		(((x) & 0x3f) << 12)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_2(x)		(((x) & 0x3f) << 6)
+#define     VDPU_REG_REF_PIC_LF_LEVEL_3(x)		(((x) & 0x3f) << 0)
+#define VDPU_REG_VP8_QUANTER0			0x208
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_0(x)		(((x) & 0x1f) << 27)
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_1(x)		(((x) & 0x1f) << 22)
+#define     VDPU_REG_REF_PIC_QUANT_0(x)			(((x) & 0x7ff) << 11)
+#define     VDPU_REG_REF_PIC_QUANT_1(x)			(((x) & 0x7ff) << 0)
+#define VDPU_REG_VP8_ADDR_REF0			0x20c
+#define VDPU_REG_FILTER_MB_ADJ			0x210
+#define     VDPU_REG_REF_PIC_FILT_TYPE_E		BIT(31)
+#define     VDPU_REG_REF_PIC_FILT_SHARPNESS(x)		(((x) & 0x7) << 28)
+#define     VDPU_REG_FILT_MB_ADJ_0(x)			(((x) & 0x7f) << 21)
+#define     VDPU_REG_FILT_MB_ADJ_1(x)			(((x) & 0x7f) << 14)
+#define     VDPU_REG_FILT_MB_ADJ_2(x)			(((x) & 0x7f) << 7)
+#define     VDPU_REG_FILT_MB_ADJ_3(x)			(((x) & 0x7f) << 0)
+#define VDPU_REG_FILTER_REF_ADJ			0x214
+#define     VDPU_REG_REF_PIC_ADJ_0(x)			(((x) & 0x7f) << 21)
+#define     VDPU_REG_REF_PIC_ADJ_1(x)			(((x) & 0x7f) << 14)
+#define     VDPU_REG_REF_PIC_ADJ_2(x)			(((x) & 0x7f) << 7)
+#define     VDPU_REG_REF_PIC_ADJ_3(x)			(((x) & 0x7f) << 0)
+#define VDPU_REG_VP8_ADDR_REF2_5(i)		(0x218 + ((i) * 0x4))
+#define     VDPU_REG_VP8_GREF_SIGN_BIAS			BIT(0)
+#define     VDPU_REG_VP8_AREF_SIGN_BIAS			BIT(0)
+#define VDPU_REG_VP8_DCT_BASE(i)		(0x230 + ((i) * 0x4))
+#define VDPU_REG_VP8_ADDR_CTRL_PART		0x244
+#define VDPU_REG_VP8_ADDR_REF1			0x250
+#define VDPU_REG_VP8_SEGMENT_VAL		0x254
+#define     VDPU_REG_FWD_PIC1_SEGMENT_BASE(x)		((x) << 0)
+#define     VDPU_REG_FWD_PIC1_SEGMENT_UPD_E		BIT(1)
+#define     VDPU_REG_FWD_PIC1_SEGMENT_E			BIT(0)
+#define VDPU_REG_VP8_DCT_START_BIT2		0x258
+#define     VDPU_REG_DEC_CTRL7_DCT3_START_BIT(x)	(((x) & 0x3f) << 24)
+#define     VDPU_REG_DEC_CTRL7_DCT4_START_BIT(x)	(((x) & 0x3f) << 18)
+#define     VDPU_REG_DEC_CTRL7_DCT5_START_BIT(x)	(((x) & 0x3f) << 12)
+#define     VDPU_REG_DEC_CTRL7_DCT6_START_BIT(x)	(((x) & 0x3f) << 6)
+#define     VDPU_REG_DEC_CTRL7_DCT7_START_BIT(x)	(((x) & 0x3f) << 0)
+#define VDPU_REG_VP8_QUANTER1			0x25c
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_2(x)		(((x) & 0x1f) << 27)
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_3(x)		(((x) & 0x1f) << 22)
+#define     VDPU_REG_REF_PIC_QUANT_2(x)			(((x) & 0x7ff) << 11)
+#define     VDPU_REG_REF_PIC_QUANT_3(x)			(((x) & 0x7ff) << 0)
+#define VDPU_REG_VP8_QUANTER2			0x260
+#define     VDPU_REG_REF_PIC_QUANT_DELTA_4(x)		(((x) & 0x1f) << 27)
+#define     VDPU_REG_REF_PIC_QUANT_4(x)			(((x) & 0x7ff) << 11)
+#define     VDPU_REG_REF_PIC_QUANT_5(x)			(((x) & 0x7ff) << 0)
+#define VDPU_REG_PRED_FLT1			0x264
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_0_3(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_1_0(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_1_1(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT2			0x268
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_1_2(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_1_3(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_2_0(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT3			0x26c
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_2_1(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_2_2(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_2_3(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT4			0x270
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_3_0(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_3_1(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_3_2(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT5			0x274
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_3_3(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_4_0(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_4_1(x)	(((x) & 0x3ff) << 2)
+#define VDPU_REG_PRED_FLT6			0x278
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_4_2(x)	(((x) & 0x3ff) << 22)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_4_3(x)	(((x) & 0x3ff) << 12)
+#define     VDPU_REG_PRED_FLT_PRED_BC_TAP_5_0(x)	(((x) & 0x3ff) << 2)
+
+#endif /* RK3399_VPU_REGS_H_ */
diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu.h b/drivers/media/platform/rockchip/vpu/rockchip_vpu.h
new file mode 100644
index 000000000000..d68b1cbd05bf
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu.h
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ */
+
+#ifndef ROCKCHIP_VPU_COMMON_H_
+#define ROCKCHIP_VPU_COMMON_H_
+
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <linux/wait.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "rockchip_vpu_hw.h"
+
+#define ROCKCHIP_VPU_MAX_CLOCKS		2
+#define ROCKCHIP_VPU_MAX_CTRLS		2
+
+#define MB_DIM				16
+#define MB_WIDTH(x_size)		DIV_ROUND_UP(x_size, MB_DIM)
+#define MB_HEIGHT(y_size)		DIV_ROUND_UP(y_size, MB_DIM)
+#define SB_DIM				64
+#define SB_WIDTH(x_size)		DIV_ROUND_UP(x_size, SB_DIM)
+#define SB_HEIGHT(y_size)		DIV_ROUND_UP(y_size, SB_DIM)
+
+struct rockchip_vpu_ctx;
+struct rockchip_vpu_codec_ops;
+
+/**
+ * struct rockchip_vpu_variant - information about VPU hardware variant
+ *
+ * @enc_offset:			Offset from VPU base to encoder registers.
+ * @enc_fmts:			Encoder formats.
+ * @num_enc_fmts:		Number of encoder formats.
+ * @codec_ops:			Codec ops.
+ * @init:			Initialize hardware.
+ * @vepu_irq:			encoder interrupt handler
+ * @clocks:			array of clock names
+ * @num_clocks:			number of clocks in the array
+ */
+struct rockchip_vpu_variant {
+	unsigned int enc_offset;
+	const struct rockchip_vpu_fmt *enc_fmts;
+	unsigned int num_enc_fmts;
+	const struct rockchip_vpu_codec_ops *codec_ops;
+	int (*init)(struct rockchip_vpu_dev *vpu);
+	irqreturn_t (*vepu_irq)(int irq, void *priv);
+	const char *clk_names[ROCKCHIP_VPU_MAX_CLOCKS];
+	int num_clocks;
+};
+
+/*
+ * Indices of controls that need to be accessed directly, i.e. through
+ * p_cur.p pointer of their v4l2_ctrl structs.
+ */
+enum rockchip_vpu_enc_ctrl_id {
+	ROCKCHIP_VPU_ENC_CTRL_Y_QUANT_TBL = 0,
+	ROCKCHIP_VPU_ENC_CTRL_C_QUANT_TBL,
+};
+
+/**
+ * enum rockchip_vpu_codec_mode - codec operating mode.
+ * @RK_VPU_CODEC_NONE: No operating mode. Used for RAW video formats.
+ * @RK_VPU_CODEC_JPEGE:	JPEG encoder.
+ */
+enum rockchip_vpu_codec_mode {
+	RK_VPU_CODEC_NONE = -1,
+	RK_VPU_CODEC_JPEGE
+};
+
+/**
+ * enum rockchip_vpu_plane - indices of planes inside a VB2 buffer.
+ * @PLANE_Y:		Plane containing luminance data (also denoted as Y).
+ * @PLANE_CB_CR:	Plane containing interleaved chrominance data (also
+ *			denoted as CbCr).
+ * @PLANE_CB:		Plane containing CB part of chrominance data.
+ * @PLANE_CR:		Plane containing CR part of chrominance data.
+ */
+enum rockchip_vpu_plane {
+	PLANE_Y		= 0,
+	PLANE_CB_CR	= 1,
+	PLANE_CB	= 1,
+	PLANE_CR	= 2,
+};
+
+/**
+ * struct rockchip_vpu_dev - driver data
+ * @v4l2_dev:		V4L2 device to register video devices for.
+ * @vfd_enc:		Video device for encoder.
+ * @pdev:		Pointer to VPU platform device.
+ * @dev:		Pointer to device for convenient logging using
+ *			dev_ macros.
+ * @clocks:		Array of clock handles.
+ * @base:		Mapped address of VPU registers.
+ * @enc_base:		Mapped address of VPU encoder register for convenience.
+ * @vpu_mutex:		Mutex to synchronize V4L2 calls.
+ * @irqlock:		Spinlock to synchronize access to data structures
+ *			shared with interrupt handlers.
+ * @variant:		Hardware variant-specific parameters.
+ * @watchdog_work:	Delayed work for hardware timeout handling.
+ */
+struct rockchip_vpu_dev {
+	struct v4l2_device v4l2_dev;
+	struct v4l2_m2m_dev *m2m_dev;
+	struct video_device *vfd;
+	struct platform_device *pdev;
+	struct device *dev;
+	struct clk *clocks[ROCKCHIP_VPU_MAX_CLOCKS];
+	void __iomem *base;
+	void __iomem *enc_base;
+
+	struct mutex vpu_mutex;	/* video_device lock */
+	spinlock_t irqlock;
+	const struct rockchip_vpu_variant *variant;
+	struct delayed_work watchdog_work;
+};
+
+/**
+ * struct rockchip_vpu_ctx - Context (instance) private data.
+ *
+ * @dev:		VPU driver data to which the context belongs.
+ * @fh:			V4L2 file handler.
+ *
+ * @sequence_cap:       Sequence counter for capture queue
+ * @sequence_out:       Sequence counter for output queue
+ *
+ * @vpu_src_fmt:	Descriptor of active source format.
+ * @src_fmt:		V4L2 pixel format of active source format.
+ * @vpu_dst_fmt:	Descriptor of active destination format.
+ * @dst_fmt:		V4L2 pixel format of active destination format.
+ *
+ * @ctrls:		Array containing pointer to registered controls.
+ * @ctrl_handler:	Control handler used to register controls.
+ * @num_ctrls:		Number of registered controls.
+ *
+ * @codec_ops:		Set of operations related to codec mode.
+ */
+struct rockchip_vpu_ctx {
+	struct rockchip_vpu_dev *dev;
+	struct v4l2_fh fh;
+
+	u32 sequence_cap;
+	u32 sequence_out;
+
+	/* Format info */
+	const struct rockchip_vpu_fmt *vpu_src_fmt;
+	struct v4l2_pix_format_mplane src_fmt;
+	const struct rockchip_vpu_fmt *vpu_dst_fmt;
+	struct v4l2_pix_format_mplane dst_fmt;
+
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+	enum v4l2_xfer_func xfer_func;
+
+	/* Controls */
+	struct v4l2_ctrl *ctrls[ROCKCHIP_VPU_MAX_CTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	unsigned int num_ctrls;
+
+	const struct rockchip_vpu_codec_ops *codec_ops;
+};
+
+/**
+ * struct rockchip_vpu_fmt - information about supported video formats.
+ * @name:	Human readable name of the format.
+ * @fourcc:	FourCC code of the format. See V4L2_PIX_FMT_*.
+ * @codec_mode:	Codec mode related to this format. See
+ *		enum rockchip_vpu_codec_mode.
+ * @num_planes:	Number of planes used by this format.
+ * @depth:	Depth of each plane in bits per pixel.
+ * @enc_fmt:	Format identifier for encoder registers.
+ * @frmsize:	Supported range of frame sizes (only for bitstream formats).
+ */
+struct rockchip_vpu_fmt {
+	char *name;
+	u32 fourcc;
+	enum rockchip_vpu_codec_mode codec_mode;
+	int num_planes;
+	u8 depth[VIDEO_MAX_PLANES];
+	enum rockchip_vpu_enc_fmt enc_fmt;
+	struct v4l2_frmsize_stepwise frmsize;
+};
+
+/* Logging helpers */
+
+/**
+ * debug - Module parameter to control level of debugging messages.
+ *
+ * Level of debugging messages can be controlled by bits of module parameter
+ * called "debug". Meaning of particular bits is as follows:
+ *
+ * bit 0 - global information: mode, size, init, release
+ * bit 1 - each run start/result information
+ * bit 2 - contents of small controls from userspace
+ * bit 3 - contents of big controls from userspace
+ * bit 4 - detail fmt, ctrl, buffer q/dq information
+ * bit 5 - detail function enter/leave trace information
+ * bit 6 - register write/read information
+ */
+extern int rockchip_vpu_debug;
+
+#define vpu_debug(level, fmt, args...)				\
+	do {							\
+		if (rockchip_vpu_debug & BIT(level))		\
+			pr_info("%s:%d: " fmt,	                \
+				 __func__, __LINE__, ##args);	\
+	} while (0)
+
+#define vpu_err(fmt, args...)					\
+	pr_err("%s:%d: " fmt, __func__, __LINE__, ##args)
+
+static inline char *fmt2str(u32 fmt, char *str)
+{
+	char a = fmt & 0xFF;
+	char b = (fmt >> 8) & 0xFF;
+	char c = (fmt >> 16) & 0xFF;
+	char d = (fmt >> 24) & 0xFF;
+
+	sprintf(str, "%c%c%c%c", a, b, c, d);
+
+	return str;
+}
+
+/* Structure access helpers. */
+static inline struct rockchip_vpu_ctx *fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct rockchip_vpu_ctx, fh);
+}
+
+static inline unsigned int rockchip_vpu_rounded_luma_size(unsigned int w,
+							  unsigned int h)
+{
+	return round_up(w, MB_DIM) * round_up(h, MB_DIM);
+}
+
+int rockchip_vpu_enc_ctrls_setup(struct rockchip_vpu_ctx *ctx);
+
+/* Register accessors. */
+static inline void vepu_write_relaxed(struct rockchip_vpu_dev *vpu,
+				       u32 val, u32 reg)
+{
+	vpu_debug(6, "MARK: set reg[%03d]: %08x\n", reg / 4, val);
+	writel_relaxed(val, vpu->enc_base + reg);
+}
+
+static inline void vepu_write(struct rockchip_vpu_dev *vpu, u32 val, u32 reg)
+{
+	vpu_debug(6, "MARK: set reg[%03d]: %08x\n", reg / 4, val);
+	writel(val, vpu->enc_base + reg);
+}
+
+static inline u32 vepu_read(struct rockchip_vpu_dev *vpu, u32 reg)
+{
+	u32 val = readl(vpu->enc_base + reg);
+
+	vpu_debug(6, "MARK: get reg[%03d]: %08x\n", reg / 4, val);
+	return val;
+}
+
+#endif /* ROCKCHIP_VPU_COMMON_H_ */
diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c b/drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
new file mode 100644
index 000000000000..c7c0a6696ccd
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Collabora, Ltd.
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <linux/workqueue.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "rockchip_vpu.h"
+#include "rockchip_vpu_enc.h"
+#include "rockchip_vpu_hw.h"
+
+#define DRIVER_NAME "rockchip-vpu"
+
+int rockchip_vpu_debug;
+module_param_named(debug, rockchip_vpu_debug, int, 0644);
+MODULE_PARM_DESC(debug,
+		 "Debug level - higher value produces more verbose messages");
+
+void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu)
+{
+	struct rockchip_vpu_ctx *ctx =
+		(struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
+
+	/* Atomic watchdog cancel. The worker may still be
+	 * running after calling this.
+	 */
+	cancel_delayed_work(&vpu->watchdog_work);
+	if (ctx)
+		ctx->codec_ops->done(ctx, VB2_BUF_STATE_DONE);
+}
+
+void rockchip_vpu_watchdog(struct work_struct *work)
+{
+	struct rockchip_vpu_dev *vpu;
+	struct rockchip_vpu_ctx *ctx;
+
+	vpu = container_of(to_delayed_work(work),
+			   struct rockchip_vpu_dev, watchdog_work);
+	ctx = (struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
+	if (ctx) {
+		vpu_err("frame processing timed out!\n");
+		ctx->codec_ops->reset(ctx);
+		ctx->codec_ops->done(ctx, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static void device_run(void *priv)
+{
+	struct rockchip_vpu_ctx *ctx = priv;
+
+	ctx->codec_ops->run(ctx);
+}
+
+static struct v4l2_m2m_ops vpu_m2m_ops = {
+	.device_run = device_run,
+};
+
+static int
+queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+{
+	struct rockchip_vpu_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &rockchip_vpu_enc_queue_ops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
+			    DMA_ATTR_NO_KERNEL_MAPPING;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->vpu_mutex;
+	src_vq->dev = ctx->dev->v4l2_dev.dev;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &rockchip_vpu_enc_queue_ops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->dev->vpu_mutex;
+	dst_vq->dev = ctx->dev->v4l2_dev.dev;
+
+	return vb2_queue_init(dst_vq);
+}
+
+/*
+ * V4L2 file operations.
+ */
+
+static int rockchip_vpu_open(struct file *filp)
+{
+	struct rockchip_vpu_dev *vpu = video_drvdata(filp);
+	struct rockchip_vpu_ctx *ctx;
+	int ret;
+
+	/*
+	 * We do not need any extra locking here, because we operate only
+	 * on local data here, except reading few fields from dev, which
+	 * do not change through device's lifetime (which is guaranteed by
+	 * reference on module from open()) and V4L2 internal objects (such
+	 * as vdev and ctx->fh), which have proper locking done in respective
+	 * helper functions used here.
+	 */
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->dev = vpu;
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(vpu->m2m_dev, ctx, &queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		kfree(ctx);
+		return ret;
+	}
+	v4l2_fh_init(&ctx->fh, video_devdata(filp));
+	filp->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->colorspace = V4L2_COLORSPACE_JPEG,
+	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
+	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	ret = rockchip_vpu_enc_init(ctx);
+	if (ret) {
+		vpu_err("Failed to initialize encoder context\n");
+		goto err_fh_free;
+	}
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	return 0;
+
+err_fh_free:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	return ret;
+}
+
+static int rockchip_vpu_release(struct file *filp)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
+
+	/*
+	 * No need for extra locking because this was the last reference
+	 * to this file.
+	 */
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	rockchip_vpu_enc_exit(ctx);
+	kfree(ctx);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations rockchip_vpu_fops = {
+	.owner = THIS_MODULE,
+	.open = rockchip_vpu_open,
+	.release = rockchip_vpu_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+
+static const struct of_device_id of_rockchip_vpu_match[] = {
+	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
+	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, of_rockchip_vpu_match);
+
+static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
+{
+	struct video_device *vfd;
+	int ret;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&vpu->v4l2_dev, "Failed to allocate video device\n");
+		return -ENOMEM;
+	}
+
+	vpu->vfd = vfd;
+	vfd->fops = &rockchip_vpu_fops;
+	vfd->release = video_device_release;
+	vfd->lock = &vpu->vpu_mutex;
+	vfd->v4l2_dev = &vpu->v4l2_dev;
+	vfd->vfl_dir = VFL_DIR_M2M;
+	vfd->ioctl_ops = &rockchip_vpu_enc_ioctl_ops;
+	vfd->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", DRIVER_NAME);
+
+	video_set_drvdata(vfd, vpu);
+
+	vpu->m2m_dev = v4l2_m2m_init(&vpu_m2m_ops);
+	if (IS_ERR(vpu->m2m_dev)) {
+		v4l2_err(&vpu->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(vpu->m2m_dev);
+		goto err_dev_reg;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&vpu->v4l2_dev, "Failed to register video device\n");
+		goto err_m2m_rel;
+	}
+	return 0;
+
+err_m2m_rel:
+	v4l2_m2m_release(vpu->m2m_dev);
+err_dev_reg:
+	video_device_release(vfd);
+	return ret;
+}
+
+static int rockchip_vpu_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct rockchip_vpu_dev *vpu;
+	struct resource *res;
+	int i, ret;
+
+	vpu = devm_kzalloc(&pdev->dev, sizeof(*vpu), GFP_KERNEL);
+	if (!vpu)
+		return -ENOMEM;
+
+	vpu->dev = &pdev->dev;
+	vpu->pdev = pdev;
+	mutex_init(&vpu->vpu_mutex);
+	spin_lock_init(&vpu->irqlock);
+
+	match = of_match_node(of_rockchip_vpu_match, pdev->dev.of_node);
+	vpu->variant = match->data;
+
+	INIT_DELAYED_WORK(&vpu->watchdog_work, rockchip_vpu_watchdog);
+
+	for (i = 0; i < vpu->variant->num_clocks; i++) {
+		vpu->clocks[i] = devm_clk_get(&pdev->dev,
+					      vpu->variant->clk_names[i]);
+		if (IS_ERR(vpu->clocks[i])) {
+			dev_err(&pdev->dev, "failed to get clock: %s\n",
+				vpu->variant->clk_names[i]);
+			return PTR_ERR(vpu->clocks[i]);
+		}
+	}
+
+	res = platform_get_resource(vpu->pdev, IORESOURCE_MEM, 0);
+	vpu->base = devm_ioremap_resource(vpu->dev, res);
+	if (IS_ERR(vpu->base))
+		return PTR_ERR(vpu->base);
+	vpu->enc_base = vpu->base + vpu->variant->enc_offset;
+
+	ret = dma_set_coherent_mask(vpu->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(vpu->dev, "Could not set DMA coherent mask.\n");
+		return ret;
+	}
+
+	if (vpu->variant->vepu_irq) {
+		int irq;
+
+		irq = platform_get_irq_byname(vpu->pdev, "vepu");
+		if (irq <= 0) {
+			dev_err(vpu->dev, "Could not get vepu IRQ.\n");
+			return -ENXIO;
+		}
+
+		ret = devm_request_irq(vpu->dev, irq, vpu->variant->vepu_irq,
+				       0, dev_name(vpu->dev), vpu);
+		if (ret) {
+			dev_err(vpu->dev, "Could not request vepu IRQ.\n");
+			return ret;
+		}
+	}
+
+	ret = vpu->variant->init(vpu);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to init VPU hardware\n");
+		return ret;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, vpu);
+
+	pm_runtime_set_autosuspend_delay(vpu->dev, 100);
+	pm_runtime_use_autosuspend(vpu->dev);
+	pm_runtime_enable(vpu->dev);
+	pm_runtime_get_sync(vpu->dev);
+
+	ret = rockchip_vpu_video_device_register(vpu);
+	if (ret)
+		goto err_v4l2_dev_unreg;
+	return 0;
+
+err_v4l2_dev_unreg:
+	v4l2_device_unregister(&vpu->v4l2_dev);
+	pm_runtime_mark_last_busy(vpu->dev);
+	pm_runtime_put_autosuspend(vpu->dev);
+	pm_runtime_disable(vpu->dev);
+	return ret;
+}
+
+static int rockchip_vpu_remove(struct platform_device *pdev)
+{
+	struct rockchip_vpu_dev *vpu = platform_get_drvdata(pdev);
+
+	v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
+
+	video_unregister_device(vpu->vfd);
+	video_device_release(vpu->vfd);
+	v4l2_device_unregister(&vpu->v4l2_dev);
+	pm_runtime_mark_last_busy(vpu->dev);
+	pm_runtime_put_autosuspend(vpu->dev);
+	pm_runtime_disable(vpu->dev);
+
+	return 0;
+}
+
+static int __maybe_unused rockchip_vpu_runtime_suspend(struct device *dev)
+{
+	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
+	int i;
+
+	for (i = vpu->variant->num_clocks - 1; i >= 0; i--)
+		clk_disable_unprepare(vpu->clocks[i]);
+	return 0;
+}
+
+static int __maybe_unused rockchip_vpu_runtime_resume(struct device *dev)
+{
+	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < vpu->variant->num_clocks; i++) {
+		int ret;
+
+		ret = clk_prepare_enable(vpu->clocks[i]);
+		if (ret) {
+			while (--i >= 0)
+				clk_disable_unprepare(vpu->clocks[i]);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops rockchip_vpu_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(rockchip_vpu_runtime_suspend,
+			   rockchip_vpu_runtime_resume, NULL)
+};
+
+static struct platform_driver rockchip_vpu_driver = {
+	.probe = rockchip_vpu_probe,
+	.remove = rockchip_vpu_remove,
+	.driver = {
+		   .name = DRIVER_NAME,
+		   .of_match_table = of_match_ptr(of_rockchip_vpu_match),
+		   .pm = &rockchip_vpu_pm_ops,
+	},
+};
+module_platform_driver(rockchip_vpu_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Alpha Lin <Alpha.Lin@Rock-Chips.com>");
+MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
+MODULE_AUTHOR("Ezequiel Garcia <ezequiel@collabora.com>");
+MODULE_DESCRIPTION("Rockchip VPU codec driver");
diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
new file mode 100644
index 000000000000..c6f1c4b22545
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
@@ -0,0 +1,715 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Collabora, Ltd.
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *	Alpha Lin <Alpha.Lin@rock-chips.com>
+ *	Jeffy Chen <jeffy.chen@rock-chips.com>
+ *
+ * Copyright (C) 2018 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/videodev2.h>
+#include <linux/workqueue.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "rockchip_vpu.h"
+#include "rockchip_vpu_enc.h"
+#include "rockchip_vpu_hw.h"
+
+#define JPEG_MAX_BYTES_PER_PIXEL 2
+
+static const struct rockchip_vpu_fmt *
+rockchip_vpu_find_format(struct rockchip_vpu_dev *dev, u32 fourcc)
+{
+	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
+	unsigned int i;
+
+	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
+		if (formats[i].fourcc == fourcc)
+			return &formats[i];
+	}
+
+	return NULL;
+}
+
+static const struct rockchip_vpu_fmt *
+rockchip_vpu_get_default_fmt(struct rockchip_vpu_dev *dev, bool bitstream)
+{
+	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
+	unsigned int i;
+
+	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
+		if (bitstream == (formats[i].codec_mode != RK_VPU_CODEC_NONE))
+			return &formats[i];
+	}
+
+	/* There must be at least one raw and one coded format in the array. */
+	WARN_ON(i >= dev->variant->num_enc_fmts);
+	return NULL;
+}
+
+static const struct v4l2_ctrl_config controls[] = {
+	[ROCKCHIP_VPU_ENC_CTRL_Y_QUANT_TBL] = {
+		.id = V4L2_CID_JPEG_LUMA_QUANTIZATION,
+		.type = V4L2_CTRL_TYPE_U8,
+		.step = 1,
+		.def = 0x00,
+		.min = 0x00,
+		.max = 0xff,
+		.dims = { 8, 8 }
+	},
+	[ROCKCHIP_VPU_ENC_CTRL_C_QUANT_TBL] = {
+		.id = V4L2_CID_JPEG_CHROMA_QUANTIZATION,
+		.type = V4L2_CTRL_TYPE_U8,
+		.step = 1,
+		.def = 0x00,
+		.min = 0x00,
+		.max = 0xff,
+		.dims = { 8, 8 }
+	},
+};
+
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct rockchip_vpu_dev *vpu = video_drvdata(file);
+
+	strlcpy(cap->driver, vpu->dev->driver->name, sizeof(cap->driver));
+	strlcpy(cap->card, vpu->vfd->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform: %s",
+		 vpu->dev->driver->name);
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *prov,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	const struct rockchip_vpu_fmt *fmt;
+
+	if (fsize->index != 0) {
+		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
+				fsize->index);
+		return -EINVAL;
+	}
+
+	fmt = rockchip_vpu_find_format(dev, fsize->pixel_format);
+	if (!fmt) {
+		vpu_debug(0, "unsupported bitstream format (%08x)\n",
+				fsize->pixel_format);
+		return -EINVAL;
+	}
+
+	/* This only makes sense for codec formats */
+	if (fmt->codec_mode == RK_VPU_CODEC_NONE)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise = fmt->frmsize;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
+					  struct v4l2_fmtdesc *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	const struct rockchip_vpu_fmt *fmt;
+	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
+	int i, j = 0;
+
+	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
+		/* Skip uncompressed formats */
+		if (formats[i].codec_mode == RK_VPU_CODEC_NONE)
+			continue;
+		if (j == f->index) {
+			fmt = &formats[i];
+			f->pixelformat = fmt->fourcc;
+			return 0;
+		}
+		++j;
+	}
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
+					  struct v4l2_fmtdesc *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	const struct rockchip_vpu_fmt *fmt;
+	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
+	int i, j = 0;
+
+	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
+		if (formats[i].codec_mode != RK_VPU_CODEC_NONE)
+			continue;
+		if (j == f->index) {
+			fmt = &formats[i];
+			f->pixelformat = fmt->fourcc;
+			return 0;
+		}
+		++j;
+	}
+	return -EINVAL;
+}
+
+static int vidioc_g_fmt_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+
+	vpu_debug(4, "f->type = %d\n", f->type);
+
+	*pix_mp = ctx->src_fmt;
+	pix_mp->colorspace = ctx->colorspace;
+	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
+	pix_mp->xfer_func = ctx->xfer_func;
+	pix_mp->quantization = ctx->quantization;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+
+	vpu_debug(4, "f->type = %d\n", f->type);
+
+	*pix_mp = ctx->dst_fmt;
+	pix_mp->colorspace = ctx->colorspace;
+	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
+	pix_mp->xfer_func = ctx->xfer_func;
+	pix_mp->quantization = ctx->quantization;
+
+	return 0;
+}
+
+static void calculate_plane_sizes(const struct rockchip_vpu_fmt *fmt,
+				  struct v4l2_pix_format_mplane *pix_mp)
+{
+	unsigned int w = pix_mp->width;
+	unsigned int h = pix_mp->height;
+	int i;
+
+	for (i = 0; i < fmt->num_planes; ++i) {
+		memset(pix_mp->plane_fmt[i].reserved, 0,
+		       sizeof(pix_mp->plane_fmt[i].reserved));
+		pix_mp->plane_fmt[i].bytesperline = w * fmt->depth[i] / 8;
+		pix_mp->plane_fmt[i].sizeimage = h *
+					pix_mp->plane_fmt[i].bytesperline;
+	}
+}
+
+static int
+vidioc_try_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct rockchip_vpu_fmt *fmt;
+	char str[5];
+
+	vpu_debug(4, "%s\n", fmt2str(pix_mp->pixelformat, str));
+
+	fmt = rockchip_vpu_find_format(dev, pix_mp->pixelformat);
+	if (!fmt) {
+		fmt = rockchip_vpu_get_default_fmt(dev, true);
+		if (!fmt)
+			return -EINVAL;
+		f->fmt.pix.pixelformat = fmt->fourcc;
+	}
+
+	/* Limit to hardware min/max. */
+	pix_mp->width = clamp(pix_mp->width,
+			ctx->vpu_dst_fmt->frmsize.min_width,
+			ctx->vpu_dst_fmt->frmsize.max_width);
+	pix_mp->height = clamp(pix_mp->height,
+			ctx->vpu_dst_fmt->frmsize.min_height,
+			ctx->vpu_dst_fmt->frmsize.max_height);
+	pix_mp->num_planes = fmt->num_planes;
+
+	pix_mp->plane_fmt[0].sizeimage =
+		pix_mp->width * pix_mp->height * JPEG_MAX_BYTES_PER_PIXEL;
+	memset(pix_mp->plane_fmt[0].reserved, 0,
+	       sizeof(pix_mp->plane_fmt[0].reserved));
+	pix_mp->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int
+vidioc_try_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct rockchip_vpu_fmt *fmt;
+	char str[5];
+	unsigned long dma_align;
+	bool need_alignment;
+	int i;
+
+	vpu_debug(4, "%s\n", fmt2str(pix_mp->pixelformat, str));
+
+	fmt = rockchip_vpu_find_format(dev, pix_mp->pixelformat);
+	if (!fmt) {
+		fmt = rockchip_vpu_get_default_fmt(dev, false);
+		if (!fmt)
+			return -EINVAL;
+		f->fmt.pix.pixelformat = fmt->fourcc;
+	}
+
+	/* Limit to hardware min/max. */
+	pix_mp->width = clamp(pix_mp->width,
+			ctx->vpu_dst_fmt->frmsize.min_width,
+			ctx->vpu_dst_fmt->frmsize.max_width);
+	pix_mp->height = clamp(pix_mp->height,
+			ctx->vpu_dst_fmt->frmsize.min_height,
+			ctx->vpu_dst_fmt->frmsize.max_height);
+	/* Round up to macroblocks. */
+	pix_mp->width = round_up(pix_mp->width, MB_DIM);
+	pix_mp->height = round_up(pix_mp->height, MB_DIM);
+	pix_mp->num_planes = fmt->num_planes;
+	pix_mp->field = V4L2_FIELD_NONE;
+
+	vpu_debug(0, "OUTPUT codec mode: %d\n", fmt->codec_mode);
+	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
+		  pix_mp->width, pix_mp->height,
+		  MB_WIDTH(pix_mp->width),
+		  MB_HEIGHT(pix_mp->height));
+
+	/* Fill remaining fields */
+	calculate_plane_sizes(fmt, pix_mp);
+
+	dma_align = dma_get_cache_alignment();
+	need_alignment = false;
+	for (i = 0; i < fmt->num_planes; i++) {
+		if (!IS_ALIGNED(pix_mp->plane_fmt[i].sizeimage,
+				dma_align)) {
+			need_alignment = true;
+			break;
+		}
+	}
+	if (!need_alignment)
+		return 0;
+
+	pix_mp->height = round_up(pix_mp->height, dma_align * 4 / MB_DIM);
+	if (pix_mp->height > ctx->vpu_dst_fmt->frmsize.max_height) {
+		vpu_err("Aligned height higher than maximum.\n");
+		return -EINVAL;
+	}
+	/* Fill in remaining fields, again */
+	calculate_plane_sizes(fmt, pix_mp);
+	return 0;
+}
+
+static void rockchip_vpu_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
+					struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *fmt = &ctx->dst_fmt;
+
+	ctx->vpu_dst_fmt = rockchip_vpu_get_default_fmt(vpu, true);
+	if (!ctx->vpu_dst_fmt)
+		return;
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	fmt->width = ctx->vpu_dst_fmt->frmsize.min_width;
+	fmt->height = ctx->vpu_dst_fmt->frmsize.min_height;
+	fmt->pixelformat = ctx->vpu_dst_fmt->fourcc;
+	fmt->num_planes = ctx->vpu_dst_fmt->num_planes;
+	fmt->plane_fmt[0].sizeimage =
+		fmt->width * fmt->height * JPEG_MAX_BYTES_PER_PIXEL;
+
+	fmt->field = V4L2_FIELD_NONE;
+
+	fmt->colorspace = ctx->colorspace;
+	fmt->ycbcr_enc = ctx->ycbcr_enc;
+	fmt->xfer_func = ctx->xfer_func;
+	fmt->quantization = ctx->quantization;
+}
+
+static void rockchip_vpu_reset_src_fmt(struct rockchip_vpu_dev *vpu,
+					struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
+
+	ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(vpu, false);
+	if (!ctx->vpu_src_fmt)
+		return;
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	fmt->width = ctx->vpu_dst_fmt->frmsize.min_width;
+	fmt->height = ctx->vpu_dst_fmt->frmsize.min_height;
+	fmt->pixelformat = ctx->vpu_src_fmt->fourcc;
+	fmt->num_planes = ctx->vpu_src_fmt->num_planes;
+
+	fmt->field = V4L2_FIELD_NONE;
+
+	fmt->colorspace = ctx->colorspace;
+	fmt->ycbcr_enc = ctx->ycbcr_enc;
+	fmt->xfer_func = ctx->xfer_func;
+	fmt->quantization = ctx->quantization;
+
+	calculate_plane_sizes(ctx->vpu_src_fmt, fmt);
+}
+
+static int
+vidioc_s_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	struct vb2_queue *vq, *peer_vq;
+	int ret;
+
+	/* Change not allowed if queue is streaming. */
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+	ctx->colorspace = pix_mp->colorspace;
+	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
+	ctx->xfer_func = pix_mp->xfer_func;
+	ctx->quantization = pix_mp->quantization;
+
+	/*
+	 * Pixel format change is not allowed when the other queue has
+	 * buffers allocated.
+	 */
+	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	if (vb2_is_busy(peer_vq) &&
+	    pix_mp->pixelformat != ctx->src_fmt.pixelformat)
+		return -EBUSY;
+
+	ret = vidioc_try_fmt_out(file, priv, f);
+	if (ret)
+		return ret;
+
+	ctx->vpu_src_fmt = rockchip_vpu_find_format(vpu,
+		pix_mp->pixelformat);
+	ctx->src_fmt = *pix_mp;
+
+	return 0;
+}
+
+static int
+vidioc_s_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	struct vb2_queue *vq, *peer_vq;
+	int ret;
+
+	/* Change not allowed if queue is streaming. */
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+	ctx->colorspace = pix_mp->colorspace;
+	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
+	ctx->xfer_func = pix_mp->xfer_func;
+	ctx->quantization = pix_mp->quantization;
+
+	/*
+	 * Pixel format change is not allowed when the other queue has
+	 * buffers allocated.
+	 */
+	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+			V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	if (vb2_is_busy(peer_vq) &&
+	    pix_mp->pixelformat != ctx->dst_fmt.pixelformat)
+		return -EBUSY;
+
+	ret = vidioc_try_fmt_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	ctx->vpu_dst_fmt = rockchip_vpu_find_format(vpu, pix_mp->pixelformat);
+	ctx->dst_fmt = *pix_mp;
+
+	/*
+	 * Current raw format might have become invalid with newly
+	 * selected codec, so reset it to default just to be safe and
+	 * keep internal driver state sane. User is mandated to set
+	 * the raw format again after we return, so we don't need
+	 * anything smarter.
+	 */
+	rockchip_vpu_reset_src_fmt(vpu, ctx);
+
+	return 0;
+}
+
+const struct v4l2_ioctl_ops rockchip_vpu_enc_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+
+	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt_cap,
+	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt_out,
+	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt_out,
+	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt_cap,
+	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt_out,
+	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt_cap,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+
+	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
+
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+
+	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+};
+
+static int rockchip_vpu_out_queue_setup(struct rockchip_vpu_ctx *ctx,
+				  unsigned int *num_planes,
+				  unsigned int sizes[])
+{
+	int i;
+
+	if (*num_planes) {
+		if (*num_planes !=  ctx->vpu_src_fmt->num_planes)
+			return -EINVAL;
+		for (i = 0; i < ctx->vpu_src_fmt->num_planes; ++i)
+			if (sizes[i] < ctx->src_fmt.plane_fmt[i].sizeimage)
+				return -EINVAL;
+		return 0;
+	}
+
+	*num_planes = ctx->vpu_src_fmt->num_planes;
+	for (i = 0; i < ctx->vpu_src_fmt->num_planes; ++i) {
+		sizes[i] = ctx->src_fmt.plane_fmt[i].sizeimage;
+		vpu_debug(0, "output sizes[%d]: %d\n", i, sizes[i]);
+	}
+	return 0;
+}
+
+static int rockchip_vpu_cap_queue_setup(struct rockchip_vpu_ctx *ctx,
+				  unsigned int *num_planes,
+				  unsigned int sizes[])
+{
+	if (*num_planes) {
+		if (*num_planes != 1)
+			return -EINVAL;
+		if (sizes[0] < ctx->dst_fmt.plane_fmt[0].sizeimage)
+			return -EINVAL;
+		return 0;
+	}
+	*num_planes = ctx->vpu_dst_fmt->num_planes;
+	sizes[0] = ctx->dst_fmt.plane_fmt[0].sizeimage;
+	vpu_debug(0, "capture sizes[%d]: %d\n", 0, sizes[0]);
+	return 0;
+}
+
+static int rockchip_vpu_queue_setup(struct vb2_queue *vq,
+				  unsigned int *num_buffers,
+				  unsigned int *num_planes,
+				  unsigned int sizes[],
+				  struct device *alloc_devs[])
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
+	int ret;
+
+	*num_buffers = clamp_t(unsigned int,
+			*num_buffers, 1, VIDEO_MAX_FRAME);
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = rockchip_vpu_cap_queue_setup(ctx, num_planes, sizes);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = rockchip_vpu_out_queue_setup(ctx, num_planes, sizes);
+		break;
+
+	default:
+		vpu_err("invalid queue type: %d\n", vq->type);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
+	unsigned int sz;
+	int ret = 0;
+	int i;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		sz = ctx->dst_fmt.plane_fmt[0].sizeimage;
+
+		vpu_debug(4, "plane size: %ld, dst size: %d\n",
+			vb2_plane_size(vb, 0), sz);
+		if (vb2_plane_size(vb, 0) < sz) {
+			vpu_err("plane size is too small for capture\n");
+			ret = -EINVAL;
+		}
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (vbuf->field == V4L2_FIELD_ANY)
+			vbuf->field = V4L2_FIELD_NONE;
+		if (vbuf->field != V4L2_FIELD_NONE) {
+			vpu_debug(4, "%s: field %d not supported\n", __func__, vbuf->field);
+			return -EINVAL;
+		}
+		for (i = 0; i < ctx->vpu_src_fmt->num_planes; ++i) {
+			sz = ctx->src_fmt.plane_fmt[i].sizeimage;
+
+			vpu_debug(4, "plane %d size: %ld, sizeimage: %u\n", i,
+				vb2_plane_size(vb, i), sz);
+			if (vb2_plane_size(vb, i) < sz) {
+				vpu_err("size of plane %d is too small for output\n",
+					i);
+				ret = -EINVAL;
+				break;
+			}
+		}
+
+		break;
+
+	default:
+		vpu_err("invalid queue type: %d\n", vq->type);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static void rockchip_vpu_buf_queue(struct vb2_buffer *vb)
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+}
+
+static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
+	enum rockchip_vpu_codec_mode codec_mode;
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		ctx->sequence_out = 0;
+	else
+		ctx->sequence_cap = 0;
+
+	/* Set codec_ops for the chosen destination format */
+	codec_mode = ctx->vpu_dst_fmt->codec_mode;
+	ctx->codec_ops = &ctx->dev->variant->codec_ops[codec_mode];
+
+	return 0;
+}
+
+static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
+
+	/* The mem2mem framework calls v4l2_m2m_cancel_job before
+	 * .stop_streaming, so there isn't any job running and
+	 * it is safe to return all the buffers.
+	 */
+	for (;;) {
+		struct vb2_v4l2_buffer *vbuf;
+
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		else
+			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		if (!vbuf)
+			break;
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	}
+}
+
+const struct vb2_ops rockchip_vpu_enc_queue_ops = {
+	.queue_setup = rockchip_vpu_queue_setup,
+	.buf_prepare = rockchip_vpu_buf_prepare,
+	.buf_queue = rockchip_vpu_buf_queue,
+	.start_streaming = rockchip_vpu_start_streaming,
+	.stop_streaming = rockchip_vpu_stop_streaming,
+};
+
+int rockchip_vpu_enc_ctrls_setup(struct rockchip_vpu_ctx *ctx)
+{
+	int i, num_ctrls = ARRAY_SIZE(controls);
+
+	if (num_ctrls > ARRAY_SIZE(ctx->ctrls)) {
+		vpu_err("context control array not large enough\n");
+		return -EINVAL;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, num_ctrls);
+	if (ctx->ctrl_handler.error) {
+		vpu_err("v4l2_ctrl_handler_init failed\n");
+		return ctx->ctrl_handler.error;
+	}
+
+	for (i = 0; i < num_ctrls; i++) {
+		ctx->ctrls[i] = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
+						     &controls[i], NULL);
+		if (ctx->ctrl_handler.error) {
+			vpu_err("Adding control (%d) failed %d\n", i,
+				ctx->ctrl_handler.error);
+			v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+			return ctx->ctrl_handler.error;
+		}
+	}
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+	ctx->num_ctrls = num_ctrls;
+	return 0;
+}
+
+int rockchip_vpu_enc_init(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	int ret;
+
+	rockchip_vpu_reset_dst_fmt(vpu, ctx);
+	rockchip_vpu_reset_src_fmt(vpu, ctx);
+
+	ret = rockchip_vpu_enc_ctrls_setup(ctx);
+	if (ret) {
+		vpu_err("Failed to set up controls.\n");
+		return ret;
+	}
+	return 0;
+}
+
+void rockchip_vpu_enc_exit(struct rockchip_vpu_ctx *ctx)
+{
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+}
diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
new file mode 100644
index 000000000000..4742cbd9295c
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *	Alpha Lin <Alpha.Lin@rock-chips.com>
+ *	Jeffy Chen <jeffy.chen@rock-chips.com>
+ *
+ * Copyright (C) 2018 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ */
+
+#ifndef ROCKCHIP_VPU_ENC_H_
+#define ROCKCHIP_VPU_ENC_H_
+
+extern const struct v4l2_ioctl_ops rockchip_vpu_enc_ioctl_ops;
+extern const struct vb2_ops rockchip_vpu_enc_queue_ops;
+
+int rockchip_vpu_enc_init(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_enc_exit(struct rockchip_vpu_ctx *ctx);
+
+#endif /* ROCKCHIP_VPU_ENC_H_  */
diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h b/drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h
new file mode 100644
index 000000000000..3298e21aa68c
--- /dev/null
+++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ */
+
+#ifndef ROCKCHIP_VPU_HW_H_
+#define ROCKCHIP_VPU_HW_H_
+
+#include <linux/interrupt.h>
+#include <linux/v4l2-controls.h>
+#include <media/videobuf2-core.h>
+
+#define ROCKCHIP_HEADER_SIZE		1280
+#define ROCKCHIP_HW_PARAMS_SIZE		5487
+#define ROCKCHIP_RET_PARAMS_SIZE	488
+#define ROCKCHIP_JPEG_QUANT_ELE_SIZE	64
+
+#define ROCKCHIP_VPU_CABAC_TABLE_SIZE	(52 * 2 * 464)
+
+struct rockchip_vpu_dev;
+struct rockchip_vpu_ctx;
+struct rockchip_vpu_buf;
+struct rockchip_vpu_variant;
+
+/**
+ * struct rockchip_vpu_codec_ops - codec mode specific operations
+ *
+ * @run:	Start single {en,de)coding job. Called from atomic context
+ *		to indicate that a pair of buffers is ready and the hardware
+ *		should be programmed and started.
+ * @done:	Read back processing results and additional data from hardware.
+ * @reset:	Reset the hardware in case of a timeout.
+ */
+struct rockchip_vpu_codec_ops {
+	void (*run)(struct rockchip_vpu_ctx *ctx);
+	void (*done)(struct rockchip_vpu_ctx *ctx, enum vb2_buffer_state);
+	void (*reset)(struct rockchip_vpu_ctx *ctx);
+};
+
+/**
+ * enum rockchip_vpu_enc_fmt - source format ID for hardware registers.
+ */
+enum rockchip_vpu_enc_fmt {
+	RK3288_VPU_ENC_FMT_YUV420P = 0,
+	RK3288_VPU_ENC_FMT_YUV420SP = 1,
+	RK3288_VPU_ENC_FMT_YUYV422 = 2,
+	RK3288_VPU_ENC_FMT_UYVY422 = 3,
+};
+
+extern const struct rockchip_vpu_variant rk3399_vpu_variant;
+extern const struct rockchip_vpu_variant rk3288_vpu_variant;
+
+void rockchip_vpu_watchdog(struct work_struct *work);
+void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu);
+
+void rk3288_vpu_jpege_run(struct rockchip_vpu_ctx *ctx);
+void rk3288_vpu_jpege_done(struct rockchip_vpu_ctx *ctx,
+			   enum vb2_buffer_state result);
+void rk3399_vpu_jpege_run(struct rockchip_vpu_ctx *ctx);
+void rk3399_vpu_jpege_done(struct rockchip_vpu_ctx *ctx,
+			   enum vb2_buffer_state result);
+
+#endif /* ROCKCHIP_VPU_HW_H_ */
-- 
2.18.0
