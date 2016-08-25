Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34217 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758992AbcHYJk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:28 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 08/10] sunxi-cedrus: Add a MPEG 4 codec
Date: Thu, 25 Aug 2016 11:39:47 +0200
Message-Id: <1472117989-21455-9-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces the support of MPEG4 video decoding to the
sunxi-cedrus video decoder driver.

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 drivers/media/platform/sunxi-cedrus/Makefile       |   3 +-
 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c |  15 +++
 .../platform/sunxi-cedrus/sunxi_cedrus_common.h    |  13 ++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c |  33 +++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |   3 +
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c     | 140 +++++++++++++++++++++
 6 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c

diff --git a/drivers/media/platform/sunxi-cedrus/Makefile b/drivers/media/platform/sunxi-cedrus/Makefile
index 2d495a2..823d611 100644
--- a/drivers/media/platform/sunxi-cedrus/Makefile
+++ b/drivers/media/platform/sunxi-cedrus/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi_cedrus.o sunxi_cedrus_hw.o \
-				    sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o
+				    sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o \
+				    sunxi_cedrus_mpeg4.o
diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
index d1c957a..3001440 100644
--- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
+++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
@@ -47,6 +47,7 @@ static int sunxi_cedrus_s_ctrl(struct v4l2_ctrl *ctrl)
 		container_of(ctrl->handler, struct sunxi_cedrus_ctx, hdl);
 
 	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_MPEG4_FRAME_HDR:
 	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
 		/* This is kept in memory and used directly. */
 		break;
@@ -71,6 +72,15 @@ static const struct v4l2_ctrl_config sunxi_cedrus_ctrl_mpeg2_frame_hdr = {
 	.elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr),
 };
 
+static const struct v4l2_ctrl_config sunxi_cedrus_ctrl_mpeg4_frame_hdr = {
+	.ops = &sunxi_cedrus_ctrl_ops,
+	.id = V4L2_CID_MPEG_VIDEO_MPEG4_FRAME_HDR,
+	.type = V4L2_CTRL_TYPE_PRIVATE,
+	.name = "MPEG4 Frame Header Parameters",
+	.max_reqs = VIDEO_MAX_FRAME,
+	.elem_size = sizeof(struct v4l2_ctrl_mpeg4_frame_hdr),
+};
+
 /*
  * File operations
  */
@@ -99,6 +109,10 @@ static int sunxi_cedrus_open(struct file *file)
 			&sunxi_cedrus_ctrl_mpeg2_frame_hdr, NULL);
 	ctx->mpeg2_frame_hdr_ctrl->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
 
+	ctx->mpeg4_frame_hdr_ctrl = v4l2_ctrl_new_custom(hdl,
+			&sunxi_cedrus_ctrl_mpeg4_frame_hdr, NULL);
+	ctx->mpeg4_frame_hdr_ctrl->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
+
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -139,6 +153,7 @@ static int sunxi_cedrus_release(struct file *file)
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->hdl);
 	ctx->mpeg2_frame_hdr_ctrl = NULL;
+	ctx->mpeg4_frame_hdr_ctrl = NULL;
 	mutex_lock(&dev->dev_mutex);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(&dev->dev_mutex);
diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
index e715184..33fa891 100644
--- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
+++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
@@ -49,6 +49,18 @@ struct sunxi_cedrus_dev {
 	struct reset_control *rstc;
 
 	char *base;
+
+	unsigned int mbh_buf;
+	unsigned int dcac_buf;
+	unsigned int ncf_buf;
+
+	void *mbh_buf_virt;
+	void *dcac_buf_virt;
+	void *ncf_buf_virt;
+
+	unsigned int mbh_buf_size;
+	unsigned int dcac_buf_size;
+	unsigned int ncf_buf_size;
 };
 
 struct sunxi_cedrus_fmt {
@@ -72,6 +84,7 @@ struct sunxi_cedrus_ctx {
 	struct vb2_buffer *dst_bufs[VIDEO_MAX_FRAME];
 
 	struct v4l2_ctrl *mpeg2_frame_hdr_ctrl;
+	struct v4l2_ctrl *mpeg4_frame_hdr_ctrl;
 };
 
 static inline void sunxi_cedrus_write(struct sunxi_cedrus_dev *vpu,
diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
index 38e8a3a..8ce635d 100644
--- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
+++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
@@ -53,6 +53,11 @@ static struct sunxi_cedrus_fmt formats[] = {
 		.types	= SUNXI_CEDRUS_OUTPUT,
 		.num_planes = 1,
 	},
+	{
+		.fourcc = V4L2_PIX_FMT_MPEG4_FRAME,
+		.types	= SUNXI_CEDRUS_OUTPUT,
+		.num_planes = 1,
+	},
 };
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
@@ -129,6 +134,10 @@ void device_run(void *priv)
 		struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr =
 				ctx->mpeg2_frame_hdr_ctrl->p_new.p;
 		process_mpeg2(ctx, in_buf, out_luma, out_chroma, frame_hdr);
+	} else if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_MPEG4_FRAME) {
+		struct v4l2_ctrl_mpeg4_frame_hdr *frame_hdr =
+				ctx->mpeg4_frame_hdr_ctrl->p_new.p;
+		process_mpeg4(ctx, in_buf, out_luma, out_chroma, frame_hdr);
 	} else {
 		v4l2_m2m_buf_done(in_vb, VB2_BUF_STATE_ERROR);
 		v4l2_m2m_buf_done(out_vb, VB2_BUF_STATE_ERROR);
@@ -306,8 +315,32 @@ static int vidioc_s_fmt(struct sunxi_cedrus_ctx *ctx, struct v4l2_format *f)
 
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (ctx->vpu_src_fmt && ctx->vpu_src_fmt->fourcc ==
+		       V4L2_PIX_FMT_MPEG4_FRAME && dev->mbh_buf_virt) {
+			dma_free_coherent(dev->dev, dev->mbh_buf_size,
+					  dev->mbh_buf_virt, dev->mbh_buf);
+			dma_free_coherent(dev->dev, dev->dcac_buf_size,
+					  dev->dcac_buf_virt, dev->dcac_buf);
+			dma_free_coherent(dev->dev, dev->ncf_buf_size,
+					  dev->ncf_buf_virt, dev->ncf_buf);
+		}
+
 		ctx->vpu_src_fmt = find_format(f);
 		ctx->src_fmt = *pix_fmt_mp;
+
+		if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_MPEG4_FRAME) {
+			dev->mbh_buf_size  = pix_fmt_mp->height * 2048;
+			dev->dcac_buf_size = 2 * pix_fmt_mp->width *
+					       pix_fmt_mp->height;
+			dev->ncf_buf_size  = 4 * 1024;
+
+			dev->mbh_buf_virt = dma_alloc_coherent(dev->dev,
+			       dev->mbh_buf_size, &dev->mbh_buf, GFP_KERNEL);
+			dev->dcac_buf_virt = dma_alloc_coherent(dev->dev,
+			       dev->dcac_buf_size, &dev->dcac_buf, GFP_KERNEL);
+			dev->ncf_buf_virt = dma_alloc_coherent(dev->dev,
+			       dev->ncf_buf_size, &dev->ncf_buf, GFP_KERNEL);
+		}
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		fmt = find_format(f);
diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
index 78625e5..d5f8b47 100644
--- a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
+++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
@@ -32,5 +32,8 @@ void sunxi_cedrus_hw_remove(struct sunxi_cedrus_dev *vpu);
 void process_mpeg2(struct sunxi_cedrus_ctx *ctx, dma_addr_t in_buf,
 		   dma_addr_t out_luma, dma_addr_t out_chroma,
 		   struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr);
+void process_mpeg4(struct sunxi_cedrus_ctx *ctx, dma_addr_t in_buf,
+		   dma_addr_t out_luma, dma_addr_t out_chroma,
+		   struct v4l2_ctrl_mpeg4_frame_hdr *frame_hdr);
 
 #endif /* SUNXI_CEDRUS_HW_H_ */
diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c
new file mode 100644
index 0000000..656fb6f
--- /dev/null
+++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c
@@ -0,0 +1,140 @@
+/*
+ * Sunxi Cedrus codec driver
+ *
+ * Copyright (C) 2016 Florent Revest
+ * Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on reverse engineering efforts of the 'Cedrus' project
+ * Copyright (c) 2013-2014 Jens Kuske <jenskuske@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "sunxi_cedrus_common.h"
+
+#include <media/videobuf2-dma-contig.h>
+
+#define VOP_I	0
+#define VOP_P	1
+#define VOP_B	2
+#define VOP_S	3
+
+void process_mpeg4(struct sunxi_cedrus_ctx *ctx, dma_addr_t in_buf,
+		   dma_addr_t out_luma, dma_addr_t out_chroma,
+		   struct v4l2_ctrl_mpeg4_frame_hdr *frame_hdr)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+
+	u16 width = DIV_ROUND_UP(frame_hdr->width, 16);
+	u16 height = DIV_ROUND_UP(frame_hdr->height, 16);
+
+	u32 vop_header = 0;
+	u32 vld_len = frame_hdr->slice_len - frame_hdr->slice_pos;
+
+	struct vb2_buffer *fwd_vb2_buf, *bwd_vb2_buf;
+	dma_addr_t fwd_luma = 0, fwd_chroma = 0, bwd_luma = 0, bwd_chroma = 0;
+
+	/*
+	 * The VPU is only able to handle bus addresses so we have to subtract
+	 * the RAM offset to the physcal addresses
+	 */
+	fwd_vb2_buf = ctx->dst_bufs[frame_hdr->forward_index];
+	if (fwd_vb2_buf) {
+		fwd_luma   = vb2_dma_contig_plane_dma_addr(fwd_vb2_buf, 0);
+		fwd_chroma = vb2_dma_contig_plane_dma_addr(fwd_vb2_buf, 1);
+		fwd_luma   -= PHYS_OFFSET;
+		fwd_chroma -= PHYS_OFFSET;
+	}
+
+	bwd_vb2_buf = ctx->dst_bufs[frame_hdr->backward_index];
+	if (bwd_vb2_buf) {
+		bwd_luma   = vb2_dma_contig_plane_dma_addr(bwd_vb2_buf, 0);
+		bwd_chroma = vb2_dma_contig_plane_dma_addr(bwd_vb2_buf, 1);
+		bwd_chroma -= PHYS_OFFSET;
+		bwd_luma   -= PHYS_OFFSET;
+	}
+
+	/* Activates MPEG engine */
+	sunxi_cedrus_write(dev, VE_CTRL_MPEG, VE_CTRL);
+
+	/* Quantization parameter */
+	sunxi_cedrus_write(dev, frame_hdr->quant_scale, VE_MPEG_QP_INPUT);
+
+	/* Intermediate buffers needed by the VPU */
+	sunxi_cedrus_write(dev, dev->mbh_buf  - PHYS_OFFSET, VE_MPEG_MBH_ADDR);
+	sunxi_cedrus_write(dev, dev->dcac_buf - PHYS_OFFSET, VE_MPEG_DCAC_ADDR);
+	sunxi_cedrus_write(dev, dev->ncf_buf  - PHYS_OFFSET, VE_MPEG_NCF_ADDR);
+
+	/* Image's dimensions */
+	sunxi_cedrus_write(dev, width << 8  | height,      VE_MPEG_SIZE);
+	sunxi_cedrus_write(dev, width << 20 | height << 4, VE_MPEG_FRAME_SIZE);
+
+	/* MPEG VOP's header */
+	vop_header |= (frame_hdr->vop_fields.vop_coding_type == VOP_B) << 28;
+	vop_header |= frame_hdr->vol_fields.quant_type << 24;
+	vop_header |= frame_hdr->vol_fields.quarter_sample << 23;
+	vop_header |= frame_hdr->vol_fields.resync_marker_disable << 22;
+	vop_header |= frame_hdr->vop_fields.vop_coding_type << 18;
+	vop_header |= frame_hdr->vop_fields.vop_rounding_type << 17;
+	vop_header |= frame_hdr->vop_fields.intra_dc_vlc_thr << 8;
+	vop_header |= frame_hdr->vop_fields.top_field_first << 7;
+	vop_header |= frame_hdr->vop_fields.alternate_vertical_scan_flag << 6;
+	if (frame_hdr->vop_fields.vop_coding_type != VOP_I)
+		vop_header |= frame_hdr->vop_fcode_forward << 3;
+	if (frame_hdr->vop_fields.vop_coding_type == VOP_B)
+		vop_header |= frame_hdr->vop_fcode_backward << 0;
+	sunxi_cedrus_write(dev, vop_header, VE_MPEG_VOP_HDR);
+
+	/* Enable interrupt and an unknown control flag */
+	if (frame_hdr->vop_fields.vop_coding_type == VOP_P)
+		sunxi_cedrus_write(dev, VE_MPEG_CTRL_MPEG4_P, VE_MPEG_CTRL);
+	else
+		sunxi_cedrus_write(dev, VE_MPEG_CTRL_MPEG4, VE_MPEG_CTRL);
+
+	/* Temporal distances of B frames */
+	if (frame_hdr->vop_fields.vop_coding_type == VOP_B) {
+		u32 trbtrd = (frame_hdr->trb << 16) | frame_hdr->trd;
+
+		sunxi_cedrus_write(dev, trbtrd, VE_MPEG_TRBTRD_FRAME);
+		sunxi_cedrus_write(dev, 0, VE_MPEG_TRBTRD_FIELD);
+	}
+
+	/* Don't rotate or scale buffer */
+	sunxi_cedrus_write(dev, VE_NO_SDROT_CTRL, VE_MPEG_SDROT_CTRL);
+
+	/* Macroblock number */
+	sunxi_cedrus_write(dev, 0, VE_MPEG_MBA);
+
+	/* Clear previous status */
+	sunxi_cedrus_write(dev, 0xffffffff, VE_MPEG_STATUS);
+
+	/* Forward and backward prediction buffers (cached in dst_bufs) */
+	sunxi_cedrus_write(dev, fwd_luma,   VE_MPEG_FWD_LUMA);
+	sunxi_cedrus_write(dev, fwd_chroma, VE_MPEG_FWD_CHROMA);
+	sunxi_cedrus_write(dev, bwd_luma,   VE_MPEG_BACK_LUMA);
+	sunxi_cedrus_write(dev, bwd_chroma, VE_MPEG_BACK_CHROMA);
+
+	/* Output luma and chroma buffers */
+	sunxi_cedrus_write(dev, out_luma,   VE_MPEG_REC_LUMA);
+	sunxi_cedrus_write(dev, out_chroma, VE_MPEG_REC_CHROMA);
+	sunxi_cedrus_write(dev, out_luma,   VE_MPEG_ROT_LUMA);
+	sunxi_cedrus_write(dev, out_chroma, VE_MPEG_ROT_CHROMA);
+
+	/* Input offset and length in bits */
+	sunxi_cedrus_write(dev, frame_hdr->slice_pos, VE_MPEG_VLD_OFFSET);
+	sunxi_cedrus_write(dev, vld_len, VE_MPEG_VLD_LEN);
+
+	/* Input beginning and end addresses */
+	sunxi_cedrus_write(dev, VE_MPEG_VLD_ADDR_VAL(in_buf), VE_MPEG_VLD_ADDR);
+	sunxi_cedrus_write(dev, in_buf + VBV_SIZE - 1, VE_MPEG_VLD_END);
+
+	/* Starts the MPEG engine */
+	sunxi_cedrus_write(dev, VE_TRIG_MPEG4(width, height), VE_MPEG_TRIGGER);
+}
-- 
2.7.4

