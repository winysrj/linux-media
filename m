Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB92AC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73A1F20818
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfBEUZW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:25:22 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41822 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbfBEUZV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 15:25:21 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id DDA182802E2
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 08/10] rockchip/vpu: Add decoder boilerplate
Date:   Tue,  5 Feb 2019 17:24:15 -0300
Message-Id: <20190205202417.16555-9-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190205202417.16555-1-ezequiel@collabora.com>
References: <20190205202417.16555-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This commit adds the needed boilerplate code to support the VPU
in decoding operation. Two v4l2 interfaces are exposed, one for
encoding and one for decoding, but a single m2m device is shared
by them, so jobs are properly serialized.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/staging/media/rockchip/vpu/Makefile   |   1 +
 .../media/rockchip/vpu/rk3399_vpu_hw.c        |  19 +
 .../staging/media/rockchip/vpu/rockchip_vpu.h |  35 ++
 .../media/rockchip/vpu/rockchip_vpu_common.h  |   6 +
 .../media/rockchip/vpu/rockchip_vpu_dec.c     | 557 ++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 130 +++-
 6 files changed, 737 insertions(+), 11 deletions(-)
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_dec.c

diff --git a/drivers/staging/media/rockchip/vpu/Makefile b/drivers/staging/media/rockchip/vpu/Makefile
index e9d733bb7632..b9041a139212 100644
--- a/drivers/staging/media/rockchip/vpu/Makefile
+++ b/drivers/staging/media/rockchip/vpu/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
 rockchip-vpu-y += \
 		rockchip_vpu_drv.o \
 		rockchip_vpu_enc.o \
+		rockchip_vpu_dec.o \
 		rk3288_vpu_hw.o \
 		rk3288_vpu_hw_jpeg_enc.o \
 		rk3399_vpu_hw.o \
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
index 8469e474c975..0263584e616d 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
@@ -74,6 +74,24 @@ static irqreturn_t rk3399_vepu_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rk3399_vdpu_irq(int irq, void *dev_id)
+{
+	struct rockchip_vpu_dev *vpu = dev_id;
+	enum vb2_buffer_state state;
+	u32 status;
+
+	status = vdpu_read(vpu, VDPU_REG_INTERRUPT);
+	state = (status & VDPU_REG_INTERRUPT_DEC_IRQ) ?
+		VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
+
+	vdpu_write(vpu, 0, VDPU_REG_INTERRUPT);
+	vdpu_write(vpu, 0, VDPU_REG_AXI_CTRL);
+
+	rockchip_vpu_irq_done(vpu, 0, state);
+
+	return IRQ_HANDLED;
+}
+
 static int rk3399_vpu_hw_init(struct rockchip_vpu_dev *vpu)
 {
 	/* Bump ACLK to max. possible freq. to improve performance. */
@@ -114,6 +132,7 @@ const struct rockchip_vpu_variant rk3399_vpu_variant = {
 	.codec = RK_VPU_CODEC_JPEG,
 	.codec_ops = rk3399_vpu_codec_ops,
 	.vepu_irq = rk3399_vepu_irq,
+	.vdpu_irq = rk3399_vdpu_irq,
 	.init = rk3399_vpu_hw_init,
 	.clk_names = {"aclk", "hclk"},
 	.num_clocks = 2
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
index 084f58cadda1..b383c89ecc17 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
@@ -40,23 +40,31 @@ struct rockchip_vpu_codec_ops;
  * struct rockchip_vpu_variant - information about VPU hardware variant
  *
  * @enc_offset:			Offset from VPU base to encoder registers.
+ * @dec_offset:			Offset from VPU base to decoder registers.
  * @enc_fmts:			Encoder formats.
  * @num_enc_fmts:		Number of encoder formats.
+ * @dec_fmts:			Decoder formats.
+ * @num_dec_fmts:		Number of decoder formats.
  * @codec:			Supported codecs
  * @codec_ops:			Codec ops.
  * @init:			Initialize hardware.
  * @vepu_irq:			encoder interrupt handler
+ * @vdpu_irq:			decoder interrupt handler
  * @clk_names:			array of clock names
  * @num_clocks:			number of clocks in the array
  */
 struct rockchip_vpu_variant {
 	unsigned int enc_offset;
+	unsigned int dec_offset;
 	const struct rockchip_vpu_fmt *enc_fmts;
 	unsigned int num_enc_fmts;
+	const struct rockchip_vpu_fmt *dec_fmts;
+	unsigned int num_dec_fmts;
 	unsigned int codec;
 	const struct rockchip_vpu_codec_ops *codec_ops;
 	int (*init)(struct rockchip_vpu_dev *vpu);
 	irqreturn_t (*vepu_irq)(int irq, void *priv);
+	irqreturn_t (*vdpu_irq)(int irq, void *priv);
 	const char *clk_names[ROCKCHIP_VPU_MAX_CLOCKS];
 	int num_clocks;
 };
@@ -109,6 +117,7 @@ struct rockchip_vpu_mc {
  * @m2m_dev:		mem2mem device associated to this device.
  * @mdev:		media device associated to this device.
  * @vfd_enc:		Video device for encoder.
+ * @vfd_dec:		Video device for decoder.
  * @pdev:		Pointer to VPU platform device.
  * @mc:			Array of media controller topology structs
  *			for encoder and decoder.
@@ -117,6 +126,7 @@ struct rockchip_vpu_mc {
  * @clocks:		Array of clock handles.
  * @base:		Mapped address of VPU registers.
  * @enc_base:		Mapped address of VPU encoder register for convenience.
+ * @dec_base:		Mapped address of VPU decoder register for convenience.
  * @vpu_mutex:		Mutex to synchronize V4L2 calls.
  * @irqlock:		Spinlock to synchronize access to data structures
  *			shared with interrupt handlers.
@@ -128,12 +138,14 @@ struct rockchip_vpu_dev {
 	struct v4l2_m2m_dev *m2m_dev;
 	struct media_device mdev;
 	struct video_device *vfd_enc;
+	struct video_device *vfd_dec;
 	struct platform_device *pdev;
 	struct rockchip_vpu_mc mc[2];
 	struct device *dev;
 	struct clk_bulk_data clocks[ROCKCHIP_VPU_MAX_CLOCKS];
 	void __iomem *base;
 	void __iomem *enc_base;
+	void __iomem *dec_base;
 
 	struct mutex vpu_mutex;	/* video_device lock */
 	spinlock_t irqlock;
@@ -146,6 +158,7 @@ struct rockchip_vpu_dev {
  *
  * @dev:		VPU driver data to which the context belongs.
  * @fh:			V4L2 file handler.
+ * @is_enc:		Encoder or decoder?
  *
  * @sequence_cap:       Sequence counter for capture queue
  * @sequence_out:       Sequence counter for output queue
@@ -164,6 +177,7 @@ struct rockchip_vpu_dev {
 struct rockchip_vpu_ctx {
 	struct rockchip_vpu_dev *dev;
 	struct v4l2_fh fh;
+	unsigned int is_enc;
 
 	u32 sequence_cap;
 	u32 sequence_out;
@@ -262,4 +276,25 @@ static inline u32 vepu_read(struct rockchip_vpu_dev *vpu, u32 reg)
 	return val;
 }
 
+static inline void vdpu_write_relaxed(struct rockchip_vpu_dev *vpu,
+				      u32 val, u32 reg)
+{
+	vpu_debug(6, "0x%04x = 0x%08x\n", reg / 4, val);
+	writel_relaxed(val, vpu->dec_base + reg);
+}
+
+static inline void vdpu_write(struct rockchip_vpu_dev *vpu, u32 val, u32 reg)
+{
+	vpu_debug(6, "0x%04x = 0x%08x\n", reg / 4, val);
+	writel(val, vpu->dec_base + reg);
+}
+
+static inline u32 vdpu_read(struct rockchip_vpu_dev *vpu, u32 reg)
+{
+	u32 val = readl(vpu->dec_base + reg);
+
+	vpu_debug(6, "0x%04x = 0x%08x\n", reg / 4, val);
+	return val;
+}
+
 #endif /* ROCKCHIP_VPU_H_ */
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
index ac018136a7bc..7e5fce3bf215 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
@@ -19,12 +19,18 @@
 #include "rockchip_vpu.h"
 
 extern const struct v4l2_ioctl_ops rockchip_vpu_enc_ioctl_ops;
+extern const struct v4l2_ioctl_ops rockchip_vpu_dec_ioctl_ops;
 extern const struct vb2_ops rockchip_vpu_enc_queue_ops;
+extern const struct vb2_ops rockchip_vpu_dec_queue_ops;
 
 void rockchip_vpu_enc_reset_src_fmt(struct rockchip_vpu_dev *vpu,
 				    struct rockchip_vpu_ctx *ctx);
 void rockchip_vpu_enc_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
 				    struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_dec_reset_src_fmt(struct rockchip_vpu_dev *vpu,
+				    struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_dec_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
+				    struct rockchip_vpu_ctx *ctx);
 
 void *rockchip_vpu_get_ctrl(struct rockchip_vpu_ctx *ctx, u32 id);
 dma_addr_t rockchip_vpu_get_ref(struct vb2_queue *q, u64 ts);
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_dec.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_dec.c
new file mode 100644
index 000000000000..fe2358bb57d9
--- /dev/null
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_dec.c
@@ -0,0 +1,557 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2018 Collabora, Ltd.
+ * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
+ *	Alpha Lin <Alpha.Lin@rock-chips.com>
+ *	Jeffy Chen <jeffy.chen@rock-chips.com>
+ *
+ * Copyright 2018 Google LLC.
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
+#include "rockchip_vpu_hw.h"
+#include "rockchip_vpu_common.h"
+
+static const struct rockchip_vpu_fmt *
+rockchip_vpu_find_format(struct rockchip_vpu_ctx *ctx, u32 fourcc)
+{
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	const struct rockchip_vpu_fmt *formats;
+	unsigned int num_fmts, i;
+
+	formats = dev->variant->dec_fmts;
+	num_fmts = dev->variant->num_dec_fmts;
+	for (i = 0; i < num_fmts; i++)
+		if (formats[i].fourcc == fourcc)
+			return &formats[i];
+	return NULL;
+}
+
+static const struct rockchip_vpu_fmt *
+rockchip_vpu_get_default_fmt(struct rockchip_vpu_ctx *ctx, bool bitstream)
+{
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	const struct rockchip_vpu_fmt *formats;
+	unsigned int num_fmts, i;
+
+	formats = dev->variant->dec_fmts;
+	num_fmts = dev->variant->num_dec_fmts;
+	for (i = 0; i < num_fmts; i++)
+		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
+			return &formats[i];
+	return NULL;
+}
+
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct rockchip_vpu_dev *vpu = video_drvdata(file);
+
+	strlcpy(cap->driver, vpu->dev->driver->name, sizeof(cap->driver));
+	strlcpy(cap->card, vpu->vfd_dec->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform: %s",
+		 vpu->dev->driver->name);
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	const struct rockchip_vpu_fmt *fmt;
+
+	if (fsize->index != 0) {
+		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
+				fsize->index);
+		return -EINVAL;
+	}
+
+	fmt = rockchip_vpu_find_format(ctx, fsize->pixel_format);
+	if (!fmt) {
+		vpu_debug(0, "unsupported bitstream format (%08x)\n",
+				fsize->pixel_format);
+		return -EINVAL;
+	}
+
+	/* This only makes sense for codec formats */
+	if (fmt->codec_mode == RK_VPU_MODE_NONE)
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
+	const struct rockchip_vpu_fmt *formats;
+	int num_fmts, i, j = 0;
+
+	formats = dev->variant->dec_fmts;
+	num_fmts = dev->variant->num_dec_fmts;
+	for (i = 0; i < num_fmts; i++) {
+		/* Skip compressed formats */
+		if (formats[i].codec_mode != RK_VPU_MODE_NONE)
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
+	const struct rockchip_vpu_fmt *formats;
+	const struct rockchip_vpu_fmt *fmt;
+	int num_fmts, i, j = 0;
+
+	formats = dev->variant->dec_fmts;
+	num_fmts = dev->variant->num_dec_fmts;
+	for (i = 0; i < num_fmts; i++) {
+		if (formats[i].codec_mode == RK_VPU_MODE_NONE)
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
+static int vidioc_g_fmt_out_mplane(struct file *file, void *priv,
+				   struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+
+	vpu_debug(4, "f->type = %d\n", f->type);
+
+	*pix_mp = ctx->src_fmt;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_cap_mplane(struct file *file, void *priv,
+				   struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+
+	vpu_debug(4, "f->type = %d\n", f->type);
+
+	*pix_mp = ctx->dst_fmt;
+
+	return 0;
+}
+
+static int
+vidioc_try_fmt_cap_mplane(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct rockchip_vpu_fmt *fmt;
+	unsigned int width, height;
+
+	vpu_debug(4, "%c%c%c%c\n",
+		  (pix_mp->pixelformat & 0x7f),
+		  (pix_mp->pixelformat >> 8) & 0x7f,
+		  (pix_mp->pixelformat >> 16) & 0x7f,
+		  (pix_mp->pixelformat >> 24) & 0x7f);
+
+	fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
+	if (!fmt) {
+		fmt = rockchip_vpu_get_default_fmt(ctx, false);
+		f->fmt.pix.pixelformat = fmt->fourcc;
+	}
+
+	pix_mp->field = V4L2_FIELD_NONE;
+	width = clamp(pix_mp->width,
+		      ctx->vpu_src_fmt->frmsize.min_width,
+		      ctx->vpu_src_fmt->frmsize.max_width);
+	height = clamp(pix_mp->height,
+		       ctx->vpu_src_fmt->frmsize.min_height,
+		       ctx->vpu_src_fmt->frmsize.max_height);
+	/* Round up to macroblocks. */
+	width = round_up(width, ctx->vpu_src_fmt->frmsize.step_width);
+	height = round_up(height, ctx->vpu_src_fmt->frmsize.step_height);
+
+	/* Fill remaining fields */
+	v4l2_fill_pixfmt_mp(pix_mp, fmt->fourcc, width, height);
+	return 0;
+}
+
+static int
+vidioc_try_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	const struct rockchip_vpu_fmt *fmt;
+
+	fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
+	if (!fmt) {
+		fmt = rockchip_vpu_get_default_fmt(ctx, true);
+		f->fmt.pix.pixelformat = fmt->fourcc;
+	}
+
+	pix_mp->num_planes = 1;
+	pix_mp->field = V4L2_FIELD_NONE;
+	pix_mp->width = clamp(pix_mp->width,
+				fmt->frmsize.min_width,
+				fmt->frmsize.max_width);
+	pix_mp->height = clamp(pix_mp->height,
+				fmt->frmsize.min_height,
+				fmt->frmsize.max_height);
+	/* Round up to macroblocks. */
+	pix_mp->width = round_up(pix_mp->width, fmt->frmsize.step_width);
+	pix_mp->height = round_up(pix_mp->height, fmt->frmsize.step_height);
+
+	/*
+	 * For compressed formats the application can specify
+	 * sizeimage. If the application passes a zero sizeimage,
+	 * let's default to the maximum frame size.
+	 */
+	if (!pix_mp->plane_fmt[0].sizeimage)
+		pix_mp->plane_fmt[0].sizeimage = fmt->header_size +
+			pix_mp->width * pix_mp->height * fmt->max_depth;
+	return 0;
+}
+
+void rockchip_vpu_dec_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
+				struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *fmt = &ctx->dst_fmt;
+	unsigned int width, height;
+
+	ctx->vpu_dst_fmt = rockchip_vpu_get_default_fmt(ctx, false);
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	width = clamp(fmt->width, ctx->vpu_src_fmt->frmsize.min_width,
+		      ctx->vpu_src_fmt->frmsize.max_width);
+	height = clamp(fmt->height, ctx->vpu_src_fmt->frmsize.min_height,
+		       ctx->vpu_src_fmt->frmsize.max_height);
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_JPEG,
+	fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
+	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	v4l2_fill_pixfmt_mp(fmt, ctx->vpu_dst_fmt->fourcc, width, height);
+}
+
+void rockchip_vpu_dec_reset_src_fmt(struct rockchip_vpu_dev *vpu,
+				struct rockchip_vpu_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
+
+	ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(ctx, true);
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	fmt->width = clamp(fmt->width, ctx->vpu_src_fmt->frmsize.min_width,
+		      ctx->vpu_src_fmt->frmsize.max_width);
+	fmt->height = clamp(fmt->height, ctx->vpu_src_fmt->frmsize.min_height,
+		       ctx->vpu_src_fmt->frmsize.max_height);
+	fmt->pixelformat = ctx->vpu_src_fmt->fourcc;
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_JPEG,
+	fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
+	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	fmt->plane_fmt[0].sizeimage = ctx->vpu_src_fmt->header_size +
+		fmt->width * fmt->height * ctx->vpu_src_fmt->max_depth;
+}
+
+static int
+vidioc_s_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
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
+	/*
+	 * Since format change on the OUTPUT queue will reset
+	 * the CAPTURE queue, we can't allow doing so
+	 * when the CAPTURE queue has buffers allocated.
+	 */
+	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+				  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	if (vb2_is_busy(peer_vq) &&
+	    (pix_mp->pixelformat != ctx->src_fmt.pixelformat ||
+	     pix_mp->height != ctx->src_fmt.height ||
+	     pix_mp->width != ctx->src_fmt.width))
+		return -EBUSY;
+
+	ret = vidioc_try_fmt_out_mplane(file, priv, f);
+	if (ret)
+		return ret;
+
+	ctx->vpu_src_fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
+	ctx->src_fmt = *pix_mp;
+
+	vpu_debug(0, "OUTPUT codec mode: %d\n", ctx->vpu_src_fmt->codec_mode);
+	vpu_debug(0, "fmt - w: %d, h: %d\n",
+		  pix_mp->width, pix_mp->height);
+
+	rockchip_vpu_dec_reset_dst_fmt(vpu, ctx);
+	return 0;
+}
+
+static int
+vidioc_s_fmt_cap_mplane(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq;
+	int ret;
+
+	/* Change not allowed if queue is streaming. */
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+	ret = vidioc_try_fmt_cap_mplane(file, priv, f);
+	if (ret)
+		return ret;
+
+	ctx->vpu_dst_fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
+	ctx->dst_fmt = *pix_mp;
+
+	vpu_debug(0, "CAPTURE codec mode: %d\n", ctx->vpu_dst_fmt->codec_mode);
+	vpu_debug(0, "fmt - w: %d, h: %d\n",
+		  pix_mp->width, pix_mp->height);
+	return 0;
+}
+
+const struct v4l2_ioctl_ops rockchip_vpu_dec_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+
+	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt_cap_mplane,
+	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt_out_mplane,
+	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt_out_mplane,
+	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt_cap_mplane,
+	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt_out_mplane,
+	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt_cap_mplane,
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
+static int rockchip_vpu_queue_setup(struct vb2_queue *vq,
+				  unsigned int *num_buffers,
+				  unsigned int *num_planes,
+				  unsigned int sizes[],
+				  struct device *alloc_devs[])
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format_mplane *pixfmt;
+	int i;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		pixfmt = &ctx->dst_fmt;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		pixfmt = &ctx->src_fmt;
+		break;
+	default:
+		vpu_err("invalid queue type: %d\n", vq->type);
+		return -EINVAL;
+	}
+
+	if (*num_planes) {
+		if (*num_planes != pixfmt->num_planes)
+			return -EINVAL;
+		for (i = 0; i < pixfmt->num_planes; ++i)
+			if (sizes[i] < pixfmt->plane_fmt[i].sizeimage)
+				return -EINVAL;
+		return 0;
+	}
+
+	*num_planes = pixfmt->num_planes;
+	for (i = 0; i < pixfmt->num_planes; ++i)
+		sizes[i] = pixfmt->plane_fmt[i].sizeimage;
+	return 0;
+}
+
+static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
+	const struct rockchip_vpu_fmt *vpu_fmt;
+	struct v4l2_pix_format_mplane *pixfmt;
+	unsigned int sz;
+	int ret = 0;
+	int i;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		vpu_fmt = ctx->vpu_dst_fmt;
+		pixfmt = &ctx->dst_fmt;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		vpu_fmt = ctx->vpu_src_fmt;
+		pixfmt = &ctx->src_fmt;
+
+		if (vbuf->field == V4L2_FIELD_ANY)
+			vbuf->field = V4L2_FIELD_NONE;
+		if (vbuf->field != V4L2_FIELD_NONE) {
+			vpu_debug(4, "field %d not supported\n",
+				  vbuf->field);
+			return -EINVAL;
+		}
+		break;
+	default:
+		vpu_err("invalid queue type: %d\n", vq->type);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < pixfmt->num_planes; ++i) {
+		sz = pixfmt->plane_fmt[i].sizeimage;
+		vpu_debug(4, "plane %d size: %ld, sizeimage: %u\n",
+			  i, vb2_plane_size(vb, i), sz);
+		if (vb2_plane_size(vb, i) < sz) {
+			vpu_err("plane %d is too small for output\n", i);
+			ret = -EINVAL;
+			break;
+		}
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
+	int ret = 0;
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		ctx->sequence_out = 0;
+	else
+		ctx->sequence_cap = 0;
+
+	codec_mode = ctx->vpu_src_fmt->codec_mode;
+
+	vpu_debug(4, "Codec mode = %d\n", codec_mode);
+	ctx->codec_ops = &ctx->dev->variant->codec_ops[codec_mode];
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		if (ctx->codec_ops && ctx->codec_ops->start)
+			ret = ctx->codec_ops->start(ctx);
+	return ret;
+}
+
+static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		if (ctx->codec_ops && ctx->codec_ops->stop)
+			ctx->codec_ops->stop(ctx);
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
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req, &ctx->ctrl_handler);
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static void rockchip_vpu_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->ctrl_handler);
+}
+
+static int rockchip_vpu_buf_out_validate(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	vbuf->field = V4L2_FIELD_NONE;
+	return 0;
+}
+
+const struct vb2_ops rockchip_vpu_dec_queue_ops = {
+	.queue_setup = rockchip_vpu_queue_setup,
+	.buf_prepare = rockchip_vpu_buf_prepare,
+	.buf_queue = rockchip_vpu_buf_queue,
+	.buf_out_validate = rockchip_vpu_buf_out_validate,
+	.buf_request_complete = rockchip_vpu_buf_request_complete,
+	.start_streaming = rockchip_vpu_start_streaming,
+	.stop_streaming = rockchip_vpu_stop_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+};
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 968dd6700afd..51792f70441d 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -36,6 +36,11 @@ module_param_named(debug, rockchip_vpu_debug, int, 0644);
 MODULE_PARM_DESC(debug,
 		 "Debug level - higher value produces more verbose messages");
 
+enum rockchip_vpu_type {
+	RK_VPU_ENCODER,
+	RK_VPU_DECODER,
+};
+
 void *rockchip_vpu_get_ctrl(struct rockchip_vpu_ctx *ctx, u32 id)
 {
 	struct v4l2_ctrl *ctrl;
@@ -159,6 +164,44 @@ static struct v4l2_m2m_ops vpu_m2m_ops = {
 	.device_run = device_run,
 };
 
+static int
+dec_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+{
+	struct rockchip_vpu_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &rockchip_vpu_dec_queue_ops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
+			    DMA_ATTR_NO_KERNEL_MAPPING;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->vpu_mutex;
+	src_vq->dev = ctx->dev->v4l2_dev.dev;
+	src_vq->supports_requests = true;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->bidirectional = true;
+	dst_vq->ops = &rockchip_vpu_dec_queue_ops;
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
 static int
 enc_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
 {
@@ -277,11 +320,16 @@ static int rockchip_vpu_open(struct file *filp)
 		return -ENOMEM;
 
 	ctx->dev = vpu;
-	if (vdev == vpu->vfd_enc)
+	if (vdev == vpu->vfd_enc) {
+		ctx->is_enc = 1;
 		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(vpu->m2m_dev, ctx,
 						    &enc_queue_init);
-	else
+	} else if (vdev == vpu->vfd_dec) {
+		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(vpu->m2m_dev, ctx,
+						    &dec_queue_init);
+	} else {
 		ctx->fh.m2m_ctx = ERR_PTR(-ENODEV);
+	}
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		kfree(ctx);
@@ -295,6 +343,9 @@ static int rockchip_vpu_open(struct file *filp)
 	if (vdev == vpu->vfd_enc) {
 		rockchip_vpu_enc_reset_dst_fmt(vpu, ctx);
 		rockchip_vpu_enc_reset_src_fmt(vpu, ctx);
+	} else {
+		rockchip_vpu_dec_reset_src_fmt(vpu, ctx);
+		rockchip_vpu_dec_reset_dst_fmt(vpu, ctx);
 	}
 
 	ret = rockchip_vpu_ctrls_setup(vpu, ctx);
@@ -352,7 +403,8 @@ static const struct media_device_ops rockchip_m2m_media_ops = {
 	.req_queue = v4l2_m2m_request_queue,
 };
 
-static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
+static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu,
+					      enum rockchip_vpu_type type)
 {
 	const struct of_device_id *match;
 	struct video_device *vfd;
@@ -371,9 +423,16 @@ static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
 	vfd->v4l2_dev = &vpu->v4l2_dev;
 	vfd->vfl_dir = VFL_DIR_M2M;
 	vfd->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
-	vfd->ioctl_ops = &rockchip_vpu_enc_ioctl_ops;
-	snprintf(vfd->name, sizeof(vfd->name), "%s-enc", match->compatible);
-	vpu->vfd_enc = vfd;
+	vfd->ioctl_ops = (type == RK_VPU_ENCODER) ?
+			 &rockchip_vpu_enc_ioctl_ops :
+			 &rockchip_vpu_dec_ioctl_ops;
+	snprintf(vfd->name, sizeof(vfd->name), "%s-%s", match->compatible,
+		(type == RK_VPU_ENCODER) ? "enc" : "dec");
+
+	if (type == RK_VPU_ENCODER)
+		vpu->vfd_enc = vfd;
+	else
+		vpu->vfd_dec = vfd;
 	video_set_drvdata(vfd, vpu);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
@@ -539,6 +598,16 @@ static int rockchip_register_media_controller(struct rockchip_vpu_dev *vpu)
 			return ret;
 	}
 
+	if (vpu->vfd_dec) {
+		ret = rockchip_register_mc(&vpu->mdev, &vpu->mc[1],
+					   vpu->vfd_dec,
+					   MEDIA_ENT_F_PROC_VIDEO_DECODER);
+		if (ret) {
+			rockchip_unregister_mc(&vpu->mc[0]);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -575,6 +644,7 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 	if (IS_ERR(vpu->base))
 		return PTR_ERR(vpu->base);
 	vpu->enc_base = vpu->base + vpu->variant->enc_offset;
+	vpu->dec_base = vpu->base + vpu->variant->dec_offset;
 
 	ret = dma_set_coherent_mask(vpu->dev, DMA_BIT_MASK(32));
 	if (ret) {
@@ -582,6 +652,23 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	if (vpu->variant->vdpu_irq) {
+		int irq;
+
+		irq = platform_get_irq_byname(vpu->pdev, "vdpu");
+		if (irq <= 0) {
+			dev_err(vpu->dev, "Could not get vdpu IRQ.\n");
+			return -ENXIO;
+		}
+
+		ret = devm_request_irq(vpu->dev, irq, vpu->variant->vdpu_irq,
+				       0, dev_name(vpu->dev), vpu);
+		if (ret) {
+			dev_err(vpu->dev, "Could not request vdpu IRQ.\n");
+			return ret;
+		}
+	}
+
 	if (vpu->variant->vepu_irq) {
 		int irq;
 
@@ -635,10 +722,20 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 	vpu->mdev.ops = &rockchip_m2m_media_ops;
 	vpu->v4l2_dev.mdev = &vpu->mdev;
 
-	ret = rockchip_vpu_video_device_register(vpu);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to register encoder\n");
-		goto err_m2m_rel;
+	if (vpu->variant->enc_fmts) {
+		ret = rockchip_vpu_video_device_register(vpu, RK_VPU_ENCODER);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to register encoder\n");
+			goto err_m2m_enc_rel;
+		}
+	}
+
+	if (vpu->variant->dec_fmts) {
+		ret = rockchip_vpu_video_device_register(vpu, RK_VPU_DECODER);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to register decoder\n");
+			goto err_video_dev_unreg;
+		}
 	}
 
 	ret = rockchip_register_media_controller(vpu);
@@ -654,14 +751,20 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 	}
 	return 0;
 err_mc_unreg:
+	if (vpu->vfd_dec)
+		rockchip_unregister_mc(&vpu->mc[1]);
 	if (vpu->vfd_enc)
 		rockchip_unregister_mc(&vpu->mc[0]);
 err_video_dev_unreg:
+	if (vpu->vfd_dec) {
+		video_unregister_device(vpu->vfd_dec);
+		video_device_release(vpu->vfd_dec);
+	}
 	if (vpu->vfd_enc) {
 		video_unregister_device(vpu->vfd_enc);
 		video_device_release(vpu->vfd_enc);
 	}
-err_m2m_rel:
+err_m2m_enc_rel:
 	v4l2_m2m_release(vpu->m2m_dev);
 err_v4l2_unreg:
 	v4l2_device_unregister(&vpu->v4l2_dev);
@@ -685,6 +788,11 @@ static int rockchip_vpu_remove(struct platform_device *pdev)
 		video_unregister_device(vpu->vfd_enc);
 		video_device_release(vpu->vfd_enc);
 	}
+	if (vpu->vfd_dec) {
+		rockchip_unregister_mc(&vpu->mc[1]);
+		video_unregister_device(vpu->vfd_dec);
+		video_device_release(vpu->vfd_dec);
+	}
 	v4l2_device_unregister(&vpu->v4l2_dev);
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
 	pm_runtime_disable(vpu->dev);
-- 
2.20.1

