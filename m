Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52498 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935841AbeFMOHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:34 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 9/9] media: cedrus: Add H264 decoding support
Date: Wed, 13 Jun 2018 16:07:14 +0200
Message-Id: <20180613140714.1686-10-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce some basic H264 decoding support in cedrus. So far, only the
baseline profile videos have been tested, and some more advanced features
used in higher profiles are not even implemented.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/cedrus/Makefile  |   2 +-
 .../platform/sunxi/cedrus/sunxi_cedrus.c      |  21 +
 .../sunxi/cedrus/sunxi_cedrus_common.h        |  41 +-
 .../platform/sunxi/cedrus/sunxi_cedrus_dec.c  |  12 +
 .../platform/sunxi/cedrus/sunxi_cedrus_h264.c | 443 ++++++++++++++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_hw.c   |   4 +
 .../platform/sunxi/cedrus/sunxi_cedrus_regs.h |  22 +-
 .../sunxi/cedrus/sunxi_cedrus_video.c         |   8 +
 8 files changed, 542 insertions(+), 11 deletions(-)
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_h264.c

diff --git a/drivers/media/platform/sunxi/cedrus/Makefile b/drivers/media/platform/sunxi/cedrus/Makefile
index 98f30df626a9..715f4f67b743 100644
--- a/drivers/media/platform/sunxi/cedrus/Makefile
+++ b/drivers/media/platform/sunxi/cedrus/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi-cedrus.o
 
 sunxi-cedrus-y = sunxi_cedrus.o sunxi_cedrus_video.o sunxi_cedrus_hw.o \
-		 sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o
+		 sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o sunxi_cedrus_h264.o
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
index bc80480f5dfd..581a99ba00c8 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
@@ -41,6 +41,10 @@ static int sunxi_cedrus_s_ctrl(struct v4l2_ctrl *ctrl)
 		container_of(ctrl->handler, struct sunxi_cedrus_ctx, hdl);
 
 	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM:
+	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM:
+	case V4L2_CID_MPEG_VIDEO_H264_SPS:
+	case V4L2_CID_MPEG_VIDEO_H264_PPS:
 	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
 		/* This is kept in memory and used directly. */
 		break;
@@ -57,6 +61,22 @@ static const struct v4l2_ctrl_ops sunxi_cedrus_ctrl_ops = {
 };
 
 static const struct sunxi_cedrus_control controls[] = {
+	[SUNXI_CEDRUS_CTRL_DEC_H264_DECODE_PARAM] = {
+		.id		= V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM,
+		.elem_size	= sizeof(struct v4l2_ctrl_h264_decode_param),
+	},
+	[SUNXI_CEDRUS_CTRL_DEC_H264_SLICE_PARAM] = {
+		.id		= V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM,
+		.elem_size	= sizeof(struct v4l2_ctrl_h264_slice_param),
+	},
+	[SUNXI_CEDRUS_CTRL_DEC_H264_SPS] = {
+		.id		= V4L2_CID_MPEG_VIDEO_H264_SPS,
+		.elem_size	= sizeof(struct v4l2_ctrl_h264_sps),
+	},
+	[SUNXI_CEDRUS_CTRL_DEC_H264_PPS] = {
+		.id		= V4L2_CID_MPEG_VIDEO_H264_PPS,
+		.elem_size	= sizeof(struct v4l2_ctrl_h264_pps),
+	},
 	[SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR] = {
 		.id		= V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR,
 		.elem_size	= sizeof(struct v4l2_ctrl_mpeg2_frame_hdr),
@@ -244,6 +264,7 @@ static int sunxi_cedrus_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dev->dec_ops[SUNXI_CEDRUS_CODEC_H264] = &sunxi_cedrus_dec_ops_h264;
 	dev->dec_ops[SUNXI_CEDRUS_CODEC_MPEG2] = &sunxi_cedrus_dec_ops_mpeg2;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
index 20c78ec1f037..1ab06ee68ce6 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
@@ -32,7 +32,11 @@
 #define SUNXI_CEDRUS_NAME	"sunxi-cedrus"
 
 enum sunxi_cedrus_control_id {
-	SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR = 0,
+	SUNXI_CEDRUS_CTRL_DEC_H264_DECODE_PARAM = 0,
+	SUNXI_CEDRUS_CTRL_DEC_H264_PPS,
+	SUNXI_CEDRUS_CTRL_DEC_H264_SLICE_PARAM,
+	SUNXI_CEDRUS_CTRL_DEC_H264_SPS,
+	SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR,
 	SUNXI_CEDRUS_CTRL_MAX,
 };
 
@@ -48,6 +52,13 @@ struct sunxi_cedrus_fmt {
 	unsigned int num_planes;
 };
 
+struct sunxi_cedrus_h264_run {
+	const struct v4l2_ctrl_h264_decode_param	*decode_param;
+	const struct v4l2_ctrl_h264_pps			*pps;
+	const struct v4l2_ctrl_h264_slice_param		*slice_param;
+	const struct v4l2_ctrl_h264_sps			*sps;
+};
+
 struct sunxi_cedrus_mpeg2_run {
 	const struct v4l2_ctrl_mpeg2_frame_hdr		*hdr;
 };
@@ -57,12 +68,14 @@ struct sunxi_cedrus_run {
 	struct vb2_v4l2_buffer	*dst;
 
 	union {
+		struct sunxi_cedrus_h264_run	h264;
 		struct sunxi_cedrus_mpeg2_run	mpeg2;
 	};
 };
 
 enum sunxi_cedrus_codec {
 	SUNXI_CEDRUS_CODEC_MPEG2,
+	SUNXI_CEDRUS_CODEC_H264,
 
 	SUNXI_CEDRUS_CODEC_LAST,
 };
@@ -88,12 +101,37 @@ struct sunxi_cedrus_ctx {
 	struct work_struct run_work;
 	struct list_head src_list;
 	struct list_head dst_list;
+
+	union {
+		struct {
+			void		*mv_col_buf;
+			dma_addr_t	mv_col_buf_dma;
+			ssize_t		mv_col_buf_size;
+			void		*neighbor_info_buf;
+			dma_addr_t	neighbor_info_buf_dma;
+			void		*pic_info_buf;
+			dma_addr_t	pic_info_buf_dma;
+		} h264;
+	} codec;
+};
+
+enum sunxi_cedrus_h264_pic_type {
+	SUNXI_CEDRUS_H264_PIC_TYPE_FRAME	= 0,
+	SUNXI_CEDRUS_H264_PIC_TYPE_FIELD,
+	SUNXI_CEDRUS_H264_PIC_TYPE_MBAFF,
 };
 
 struct sunxi_cedrus_buffer {
 	struct vb2_v4l2_buffer vb;
 	enum vb2_buffer_state state;
 	struct list_head list;
+
+	union {
+		struct {
+			unsigned int			position;
+			enum sunxi_cedrus_h264_pic_type	pic_type;
+		} h264;
+	} codec;
 };
 
 static inline
@@ -125,6 +163,7 @@ struct sunxi_cedrus_dec_ops {
 	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
 };
 
+extern struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_h264;
 extern struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2;
 
 struct sunxi_cedrus_dev {
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
index 5e552fa05274..c29a2582ed68 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
@@ -122,6 +122,18 @@ void sunxi_cedrus_device_run(void *priv)
 		run.mpeg2.hdr = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
 		break;
 
+	case V4L2_PIX_FMT_H264_SLICE:
+		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_DECODE_PARAM);
+		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_SLICE_PARAM);
+		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_SPS);
+		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_PPS);
+
+		run.h264.decode_param = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_DECODE_PARAM);
+		run.h264.pps = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_PPS);
+		run.h264.slice_param = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_SLICE_PARAM);
+		run.h264.sps = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_H264_SPS);
+		break;
+
 	default:
 		ctx->job_abort = 1;
 	}
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_h264.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_h264.c
new file mode 100644
index 000000000000..0c86f66eb614
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_h264.c
@@ -0,0 +1,443 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2013 Jens Kuske <jenskuske@gmail.com>
+ * Copyright (c) 2018 Bootlin
+ */
+
+#include <linux/types.h>
+
+#include <media/videobuf2-dma-contig.h>
+
+#include "sunxi_cedrus_common.h"
+#include "sunxi_cedrus_hw.h"
+#include "sunxi_cedrus_regs.h"
+
+enum sunxi_cedrus_h264_sram_off {
+	SUNXI_CEDRUS_SRAM_H264_PRED_WEIGHT_TABLE	= 0x000,
+	SUNXI_CEDRUS_SRAM_H264_FRAMEBUFFER_LIST		= 0x100,
+	SUNXI_CEDRUS_SRAM_H264_REF_LIST_0		= 0x190,
+	SUNXI_CEDRUS_SRAM_H264_REF_LIST_1		= 0x199,
+	SUNXI_CEDRUS_SRAM_H264_SCALING_LIST_8x8		= 0x200,
+	SUNXI_CEDRUS_SRAM_H264_SCALING_LIST_4x4		= 0x218,
+};
+
+struct sunxi_cedrus_h264_sram_ref_pic {
+	__le32	top_field_order_cnt;
+	__le32	bottom_field_order_cnt;
+	__le32	frame_info;
+	__le32	luma_ptr;
+	__le32	chroma_ptr;
+	__le32	extra_data_ptr;
+	__le32	extra_data_end;
+	__le32	reserved;
+} __packed;
+
+/* One for the output, 16 for the reference images */
+#define SUNXI_CEDRUS_H264_FRAME_NUM	17
+
+#define SUNXI_CEDRUS_PIC_INFO_BUF_SIZE		(128 * SZ_1K)
+#define SUNXI_CEDRUS_NEIGHBOR_INFO_BUF_SIZE	(16 * SZ_1K)
+
+static void sunxi_cedrus_h264_write_sram(struct sunxi_cedrus_dev *dev,
+					 enum sunxi_cedrus_h264_sram_off off,
+					 const void *data, size_t len)
+{
+	const u32 *buffer = data;
+	size_t count = DIV_ROUND_UP(len, 4);
+
+	sunxi_cedrus_write(dev, off << 2,
+			   VE_AVC_SRAM_PORT_OFFSET);
+
+	do {
+		sunxi_cedrus_write(dev, *buffer++, VE_AVC_SRAM_PORT_DATA);
+	} while (--count);
+}
+
+static void sunxi_cedrus_fill_ref_pic(struct sunxi_cedrus_h264_sram_ref_pic *pic,
+				      struct vb2_buffer *buf,
+				      dma_addr_t extra_buf,
+				      size_t extra_buf_len,
+				      unsigned int top_field_order_cnt,
+				      unsigned int bottom_field_order_cnt,
+				      enum sunxi_cedrus_h264_pic_type pic_type)
+{
+	pic->top_field_order_cnt = top_field_order_cnt;
+	pic->bottom_field_order_cnt = bottom_field_order_cnt;
+	pic->frame_info = pic_type << 8;
+	pic->luma_ptr = vb2_dma_contig_plane_dma_addr(buf, 0) - PHYS_OFFSET;
+	pic->chroma_ptr = vb2_dma_contig_plane_dma_addr(buf, 1) - PHYS_OFFSET;
+	pic->extra_data_ptr = extra_buf - PHYS_OFFSET;
+	pic->extra_data_end = (extra_buf - PHYS_OFFSET) + extra_buf_len;
+}
+
+static void sunxi_cedrus_write_frame_list(struct sunxi_cedrus_ctx *ctx,
+					  struct sunxi_cedrus_run *run)
+{
+	struct sunxi_cedrus_h264_sram_ref_pic pic_list[SUNXI_CEDRUS_H264_FRAME_NUM];
+	const struct v4l2_ctrl_h264_decode_param *dec_param = run->h264.decode_param;
+	const struct v4l2_ctrl_h264_slice_param *slice = run->h264.slice_param;
+	const struct v4l2_ctrl_h264_sps *sps = run->h264.sps;
+	struct sunxi_cedrus_buffer *output_buf;
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	unsigned long used_dpbs = 0;
+	unsigned int position;
+	unsigned int output = 0;
+	unsigned int i;
+
+	memset(pic_list, 0, sizeof(pic_list));
+
+	for (i = 0; i < ARRAY_SIZE(dec_param->dpb); i++) {
+		const struct v4l2_h264_dpb_entry *dpb = &dec_param->dpb[i];
+		const struct sunxi_cedrus_buffer *cedrus_buf;
+		struct vb2_buffer *ref_buf;
+
+		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
+			continue;
+
+		ref_buf = ctx->dst_bufs[dpb->buf_index];
+		cedrus_buf = vb2_to_cedrus_buffer(ref_buf);
+		position = cedrus_buf->codec.h264.position;
+		used_dpbs |= BIT(position);
+		
+		sunxi_cedrus_fill_ref_pic(&pic_list[position], ref_buf,
+					  ctx->codec.h264.mv_col_buf_dma,
+					  ctx->codec.h264.mv_col_buf_size,
+					  dpb->top_field_order_cnt,
+					  dpb->bottom_field_order_cnt,
+					  cedrus_buf->codec.h264.pic_type);
+
+		output = max(position, output);
+	}
+
+	position = find_next_zero_bit(&used_dpbs, 17, output);
+	if (position >= 17)
+		position = find_first_zero_bit(&used_dpbs, 17);
+
+	output_buf = vb2_to_cedrus_buffer(&run->dst->vb2_buf);
+	output_buf->codec.h264.position = position;
+
+	if (slice->flags & V4L2_SLICE_FLAG_FIELD_PIC)
+		output_buf->codec.h264.pic_type = SUNXI_CEDRUS_H264_PIC_TYPE_FIELD;
+	else if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
+		output_buf->codec.h264.pic_type = SUNXI_CEDRUS_H264_PIC_TYPE_MBAFF;
+	else
+		output_buf->codec.h264.pic_type = SUNXI_CEDRUS_H264_PIC_TYPE_FRAME;
+
+	sunxi_cedrus_fill_ref_pic(&pic_list[position], &run->dst->vb2_buf,
+				  ctx->codec.h264.mv_col_buf_dma,
+				  ctx->codec.h264.mv_col_buf_size,
+				  dec_param->top_field_order_cnt,
+				  dec_param->bottom_field_order_cnt,
+				  output_buf->codec.h264.pic_type);
+
+	sunxi_cedrus_h264_write_sram(dev, SUNXI_CEDRUS_SRAM_H264_FRAMEBUFFER_LIST,
+				     pic_list, sizeof(pic_list));
+
+	sunxi_cedrus_write(dev, position, VE_H264_OUTPUT_FRAME_IDX);
+}
+
+#define SUNXI_CEDRUS_MAX_REF_IDX	32
+
+static void _sunxi_cedrus_write_ref_list(struct sunxi_cedrus_ctx *ctx,
+					 struct sunxi_cedrus_run *run,
+					 const u8 *ref_list, u8 num_ref,
+					 enum sunxi_cedrus_h264_sram_off sram)
+{
+	const struct v4l2_ctrl_h264_decode_param *decode = run->h264.decode_param;
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	u32 sram_array[SUNXI_CEDRUS_MAX_REF_IDX / sizeof(u32)];
+	unsigned int size, i;
+
+	memset(sram_array, 0, sizeof(sram_array));
+
+	for (i = 0; i < num_ref; i += 4) {
+		unsigned int j;
+
+		for (j = 0; j < 4; j++) {
+			const struct v4l2_h264_dpb_entry *dpb;
+			const struct sunxi_cedrus_buffer *cedrus_buf;
+			const struct vb2_v4l2_buffer *ref_buf;
+			unsigned int position;
+			u8 ref_idx = i + j;
+			u8 dpb_idx;
+
+			if (ref_idx >= num_ref)
+				break;
+
+			dpb_idx = ref_list[ref_idx];
+			dpb = &decode->dpb[dpb_idx];
+
+			if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
+				continue;
+
+			ref_buf = to_vb2_v4l2_buffer(ctx->dst_bufs[dpb->buf_index]);
+			cedrus_buf = vb2_v4l2_to_cedrus_buffer(ref_buf);
+			position = cedrus_buf->codec.h264.position;
+
+			sram_array[i] |= position << (j * 8 + 1);
+			if (ref_buf->field == V4L2_FIELD_BOTTOM)
+				sram_array[i] |= BIT(j * 8);
+		}
+	}
+
+	size = min((unsigned int)ALIGN(num_ref, 4), sizeof(sram_array));
+	sunxi_cedrus_h264_write_sram(dev, sram, &sram_array, size);
+}
+
+static void sunxi_cedrus_write_ref_list0(struct sunxi_cedrus_ctx *ctx,
+					 struct sunxi_cedrus_run *run)
+{
+	const struct v4l2_ctrl_h264_slice_param *slice = run->h264.slice_param;
+
+	_sunxi_cedrus_write_ref_list(ctx, run,
+				     slice->ref_pic_list0,
+				     slice->num_ref_idx_l0_active_minus1 + 1,
+				     SUNXI_CEDRUS_SRAM_H264_REF_LIST_0);
+}
+
+static void sunxi_cedrus_write_ref_list1(struct sunxi_cedrus_ctx *ctx,
+					 struct sunxi_cedrus_run *run)
+{
+	const struct v4l2_ctrl_h264_slice_param *slice = run->h264.slice_param;
+
+	_sunxi_cedrus_write_ref_list(ctx, run,
+				     slice->ref_pic_list1,
+				     slice->num_ref_idx_l1_active_minus1 + 1,
+				     SUNXI_CEDRUS_SRAM_H264_REF_LIST_1);
+}
+
+static void sunxi_cedrus_set_params(struct sunxi_cedrus_ctx *ctx,
+				    struct sunxi_cedrus_run *run)
+{
+	const struct v4l2_ctrl_h264_slice_param *slice = run->h264.slice_param;
+	const struct v4l2_ctrl_h264_pps *pps = run->h264.pps;
+	const struct v4l2_ctrl_h264_sps *sps = run->h264.sps;
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	dma_addr_t src_buf_addr;
+	u32 offset = slice->header_bit_size;
+	u32 len = (slice->size * 8) - offset;
+	u32 reg;
+
+	sunxi_cedrus_write(dev, ctx->codec.h264.pic_info_buf_dma - PHYS_OFFSET, 0x250);
+	sunxi_cedrus_write(dev, (ctx->codec.h264.pic_info_buf_dma - PHYS_OFFSET) + 0x48000, 0x254);
+
+	sunxi_cedrus_write(dev, len, VE_H264_VLD_LEN);
+	sunxi_cedrus_write(dev, offset, VE_H264_VLD_OFFSET);
+
+	src_buf_addr = vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
+	src_buf_addr -= PHYS_OFFSET;
+	sunxi_cedrus_write(dev, VE_H264_VLD_ADDR_VAL(src_buf_addr) |
+			   VE_H264_VLD_ADDR_FIRST | VE_H264_VLD_ADDR_VALID | VE_H264_VLD_ADDR_LAST,
+			   VE_H264_VLD_ADDR);
+	sunxi_cedrus_write(dev, src_buf_addr + VBV_SIZE - 1, VE_H264_VLD_END);
+
+	sunxi_cedrus_write(dev, VE_H264_TRIGGER_TYPE_INIT_SWDEC,
+			   VE_H264_TRIGGER_TYPE);
+
+	if ((slice->slice_type == V4L2_H264_SLICE_TYPE_P) ||
+	    (slice->slice_type == V4L2_H264_SLICE_TYPE_SP) ||
+	    (slice->slice_type == V4L2_H264_SLICE_TYPE_B))
+		sunxi_cedrus_write_ref_list0(ctx, run);
+
+	if (slice->slice_type == V4L2_H264_SLICE_TYPE_B)
+		sunxi_cedrus_write_ref_list1(ctx, run);
+
+	// picture parameters
+	reg = 0;
+	/*
+	 * FIXME: the kernel headers are allowing the default value to
+	 * be passed, but the libva doesn't give us that.
+	 */
+	reg |= (slice->num_ref_idx_l0_active_minus1 & 0x1f) << 10;
+	reg |= (slice->num_ref_idx_l1_active_minus1 & 0x1f) << 5;
+	reg |= (pps->weighted_bipred_idc & 0x3) << 2;
+	if (pps->flags & V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE)
+		reg |= BIT(15);
+	if (pps->flags & V4L2_H264_PPS_FLAG_WEIGHTED_PRED)
+		reg |= BIT(4);
+	if (pps->flags & V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED)
+		reg |= BIT(1);
+	if (pps->flags & V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE)
+		reg |= BIT(0);
+	sunxi_cedrus_write(dev, reg, VE_H264_PIC_HDR);
+
+	// sequence parameters
+	reg = BIT(19);
+	reg |= (sps->pic_width_in_mbs_minus1 & 0xff) << 8;
+	reg |= sps->pic_height_in_map_units_minus1 & 0xff;
+	if (sps->flags & V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY)
+		reg |= BIT(18);
+	if (sps->flags & V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD)
+		reg |= BIT(17);
+	if (sps->flags & V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE)
+		reg |= BIT(16);
+	sunxi_cedrus_write(dev, reg, VE_H264_FRAME_SIZE);
+
+	// slice parameters
+	reg = 0;
+	/*
+	 * FIXME: This bit marks all the frames as references. This
+	 * should probably be set based on nal_ref_idc, but the libva
+	 * doesn't pass that information along, so this is not always
+	 * available. We should find something else, maybe change the
+	 * kernel UAPI somehow?
+	 */
+	reg |= BIT(12);
+	reg |= (slice->slice_type & 0xf) << 8;
+	reg |= slice->cabac_init_idc & 0x3;
+	reg |= BIT(5);
+	if (slice->flags & V4L2_SLICE_FLAG_FIELD_PIC)
+		reg |= BIT(4);
+	if (slice->flags & V4L2_SLICE_FLAG_BOTTOM_FIELD)
+		reg |= BIT(3);
+	if (slice->flags & V4L2_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED)
+		reg |= BIT(2);
+	sunxi_cedrus_write(dev, reg, VE_H264_SLICE_HDR);
+
+	reg = 0;
+	reg |= (slice->num_ref_idx_l0_active_minus1 & 0x1f) << 24;
+	reg |= (slice->num_ref_idx_l1_active_minus1 & 0x1f) << 16;
+	reg |= (slice->disable_deblocking_filter_idc & 0x3) << 8;
+	reg |= (slice->slice_alpha_c0_offset_div2 & 0xf) << 4;
+	reg |= slice->slice_beta_offset_div2 & 0xf;
+	sunxi_cedrus_write(dev, reg, VE_H264_SLICE_HDR2);
+
+	reg = 0;
+	/*
+	 * FIXME: This bit tells the video engine to use the default
+	 * quantization matrices. This will obviously need to be
+	 * changed to support the profiles supporting custom
+	 * quantization matrices.
+	 */
+	reg |= BIT(24);
+	reg |= (pps->second_chroma_qp_index_offset & 0x3f) << 16;
+	reg |= (pps->chroma_qp_index_offset & 0x3f) << 8;
+	reg |= (pps->pic_init_qp_minus26 + 26 + slice->slice_qp_delta) & 0x3f;
+	sunxi_cedrus_write(dev, reg, VE_H264_QP_PARAM);
+
+	// clear status flags
+	sunxi_cedrus_write(dev, sunxi_cedrus_read(dev, VE_H264_STATUS), VE_H264_STATUS);
+
+	// enable int
+	reg = sunxi_cedrus_read(dev, VE_H264_CTRL) | 0x7;
+	sunxi_cedrus_write(dev, reg, VE_H264_CTRL);
+}
+
+static enum sunxi_cedrus_irq_status
+sunxi_cedrus_h264_irq_status(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	u32 reg = sunxi_cedrus_read(dev, VE_H264_STATUS) & 0x7;
+
+	if (!reg)
+		return SUNXI_CEDRUS_IRQ_NONE;
+
+	if (reg & (BIT(1) | BIT(2)))
+		return SUNXI_CEDRUS_IRQ_ERROR;
+
+	return SUNXI_CEDRUS_IRQ_OK;
+}
+
+static void sunxi_cedrus_h264_irq_clear(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+
+	sunxi_cedrus_write(dev, GENMASK(2, 0), VE_H264_STATUS);
+}
+
+static void sunxi_cedrus_h264_irq_disable(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	u32 reg = sunxi_cedrus_read(dev, VE_H264_CTRL) & ~GENMASK(2, 0);
+
+	sunxi_cedrus_write(dev, reg, VE_H264_CTRL);
+}
+
+static void sunxi_cedrus_h264_setup(struct sunxi_cedrus_ctx *ctx,
+				    struct sunxi_cedrus_run *run)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+
+	sunxi_cedrus_engine_enable(dev, SUNXI_CEDRUS_CODEC_H264);
+
+	sunxi_cedrus_write_frame_list(ctx, run);
+	sunxi_cedrus_set_params(ctx, run);
+}
+
+static int sunxi_cedrus_h264_start(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	int ret;
+
+	ctx->codec.h264.pic_info_buf =
+		dma_alloc_coherent(dev->dev, SUNXI_CEDRUS_PIC_INFO_BUF_SIZE,
+				   &ctx->codec.h264.pic_info_buf_dma,
+				   GFP_KERNEL);
+	if (!ctx->codec.h264.pic_info_buf)
+		return -ENOMEM;
+
+	ctx->codec.h264.neighbor_info_buf =
+		dma_alloc_coherent(dev->dev, SUNXI_CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
+				   &ctx->codec.h264.neighbor_info_buf_dma,
+				   GFP_KERNEL);
+	if (!ctx->codec.h264.neighbor_info_buf) {
+		ret = -ENOMEM;
+		goto err_pic_buf;
+	}
+
+	ctx->codec.h264.mv_col_buf_size = DIV_ROUND_UP(ctx->src_fmt.width, 16) *
+		DIV_ROUND_UP(ctx->src_fmt.height, 16) * 32;
+	ctx->codec.h264.mv_col_buf = dma_alloc_coherent(dev->dev,
+							ctx->codec.h264.mv_col_buf_size,
+							&ctx->codec.h264.mv_col_buf_dma,
+							GFP_KERNEL);
+	if (!ctx->codec.h264.mv_col_buf) {
+		ret = -ENOMEM;
+		goto err_neighbor_buf;
+	}
+
+	return 0;
+
+err_neighbor_buf:
+	dma_free_coherent(dev->dev, SUNXI_CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
+			  ctx->codec.h264.neighbor_info_buf,
+			  ctx->codec.h264.neighbor_info_buf_dma);
+err_pic_buf:
+	dma_free_coherent(dev->dev, SUNXI_CEDRUS_PIC_INFO_BUF_SIZE,
+			  ctx->codec.h264.pic_info_buf,
+			  ctx->codec.h264.pic_info_buf_dma);
+	return ret;
+}
+
+static void sunxi_cedrus_h264_stop(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+
+	dma_free_coherent(dev->dev, ctx->codec.h264.mv_col_buf_size,
+			  ctx->codec.h264.mv_col_buf,
+			  ctx->codec.h264.mv_col_buf_dma);
+	dma_free_coherent(dev->dev, SUNXI_CEDRUS_NEIGHBOR_INFO_BUF_SIZE,
+			  ctx->codec.h264.neighbor_info_buf,
+			  ctx->codec.h264.neighbor_info_buf_dma);
+	dma_free_coherent(dev->dev, SUNXI_CEDRUS_PIC_INFO_BUF_SIZE,
+			  ctx->codec.h264.pic_info_buf,
+			  ctx->codec.h264.pic_info_buf_dma);
+}
+
+static void sunxi_cedrus_h264_trigger(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+
+	sunxi_cedrus_write(dev, VE_H264_TRIGGER_TYPE_AVC_SLICE_DECODE,
+			   VE_H264_TRIGGER_TYPE);
+}
+
+struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_h264 = {
+	.irq_clear	= sunxi_cedrus_h264_irq_clear,
+	.irq_disable	= sunxi_cedrus_h264_irq_disable,
+	.irq_status	= sunxi_cedrus_h264_irq_status,
+	.setup		= sunxi_cedrus_h264_setup,
+	.start		= sunxi_cedrus_h264_start,
+	.stop		= sunxi_cedrus_h264_stop,
+	.trigger	= sunxi_cedrus_h264_trigger,
+};
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
index 6b97cbd2834e..e304457fce34 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
@@ -58,6 +58,10 @@ int sunxi_cedrus_engine_enable(struct sunxi_cedrus_dev *dev,
 		reg |= VE_CTRL_DEC_MODE_MPEG;
 		break;
 
+	case SUNXI_CEDRUS_CODEC_H264:
+		reg |= VE_CTRL_DEC_MODE_H264;
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h
index 6705d41dad07..a79de1b154b0 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h
@@ -124,10 +124,20 @@
 #define VE_H264_PRED_WEIGHT		0x210
 #define VE_H264_QP_PARAM		0x21c
 #define VE_H264_CTRL			0x220
-#define VE_H264_TRIGGER			0x224
+
+#define VE_H264_TRIGGER_TYPE		0x224
+#define VE_H264_TRIGGER_TYPE_AVC_SLICE_DECODE	(8 << 0)
+#define VE_H264_TRIGGER_TYPE_INIT_SWDEC		(7 << 0)
+
 #define VE_H264_STATUS			0x228
 #define VE_H264_CUR_MB_NUM		0x22c
+
 #define VE_H264_VLD_ADDR		0x230
+#define VE_H264_VLD_ADDR_FIRST			BIT(30)
+#define VE_H264_VLD_ADDR_LAST			BIT(29)
+#define VE_H264_VLD_ADDR_VALID			BIT(28)
+#define VE_H264_VLD_ADDR_VAL(x)			(((x) & 0x0ffffff0) | ((x) >> 28))
+
 #define VE_H264_VLD_OFFSET		0x234
 #define VE_H264_VLD_LEN			0x238
 #define VE_H264_VLD_END			0x23c
@@ -136,14 +146,8 @@
 #define VE_H264_EXTRA_BUFFER1		0x250
 #define VE_H264_EXTRA_BUFFER2		0x254
 #define VE_H264_BASIC_BITS		0x2dc
-#define VE_H264_RAM_WRITE_PTR		0x2e0
-#define VE_H264_RAM_WRITE_DATA		0x2e4
-
-#define VE_SRAM_H264_PRED_WEIGHT_TABLE	0x000
-#define VE_SRAM_H264_FRAMEBUFFER_LIST	0x400
-#define VE_SRAM_H264_REF_LIST0		0x640
-#define VE_SRAM_H264_REF_LIST1		0x664
-#define VE_SRAM_H264_SCALING_LISTS	0x800
+#define VE_AVC_SRAM_PORT_OFFSET		0x2e0
+#define VE_AVC_SRAM_PORT_DATA		0x2e4
 
 #define VE_ISP_INPUT_SIZE		0xa00
 #define VE_ISP_INPUT_STRIDE		0xa04
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
index d93461178857..83e55b7825aa 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
@@ -52,6 +52,11 @@ static struct sunxi_cedrus_fmt formats[] = {
 		.types	= SUNXI_CEDRUS_OUTPUT,
 		.num_planes = 1,
 	},
+	{
+		.fourcc = V4L2_PIX_FMT_H264_SLICE,
+		.types	= SUNXI_CEDRUS_OUTPUT,
+		.num_planes = 1,
+	},
 };
 
 #define NUM_FORMATS ARRAY_SIZE(formats)
@@ -420,6 +425,9 @@ static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned int count)
 	int ret = 0;
 
 	switch (ctx->vpu_src_fmt->fourcc) {
+	case V4L2_PIX_FMT_H264_SLICE:
+		ctx->current_codec = SUNXI_CEDRUS_CODEC_H264;
+		break;
 	case V4L2_PIX_FMT_MPEG2_FRAME:
 		ctx->current_codec = SUNXI_CEDRUS_CODEC_MPEG2;
 		break;
-- 
2.17.0
