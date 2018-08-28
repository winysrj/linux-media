Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34805 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbeH1LxY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 07:53:24 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/2] media: cedrus: Add HEVC/H.265 decoding support
Date: Tue, 28 Aug 2018 10:02:40 +0200
Message-Id: <20180828080240.10982-3-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180828080240.10982-1-paul.kocialkowski@bootlin.com>
References: <20180828080240.10982-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces support for HEVC/H.265 to the Cedrus VPU driver, with
both uni-directional and bi-directional prediction modes supported.

Field-coded (interlaced) pictures, custom quantization matrices and
10-bit output are not supported at this point.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/Makefile   |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c   |  19 +
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  20 +-
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |   9 +
 .../staging/media/sunxi/cedrus/cedrus_h265.c  | 540 ++++++++++++++++++
 .../staging/media/sunxi/cedrus/cedrus_hw.c    |   4 +
 .../staging/media/sunxi/cedrus/cedrus_regs.h  | 290 ++++++++++
 .../staging/media/sunxi/cedrus/cedrus_video.c |  13 +
 8 files changed, 895 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_h265.c

diff --git a/drivers/staging/media/sunxi/cedrus/Makefile b/drivers/staging/media/sunxi/cedrus/Makefile
index aaf141fc58b6..186cb6d01b67 100644
--- a/drivers/staging/media/sunxi/cedrus/Makefile
+++ b/drivers/staging/media/sunxi/cedrus/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi-cedrus.o
 
 sunxi-cedrus-y = cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o \
-		 cedrus_mpeg2.o cedrus_h264.o
+		 cedrus_mpeg2.o cedrus_h264.o cedrus_h265.o
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index df66b0288d0a..8716bb7a7c6a 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -70,6 +70,24 @@ static const struct cedrus_control cedrus_controls[] = {
 		.codec		= CEDRUS_CODEC_H264,
 		.required	= true,
 	},
+	{
+		.id		= V4L2_CID_MPEG_VIDEO_HEVC_SPS,
+		.elem_size	= sizeof(struct v4l2_ctrl_hevc_sps),
+		.codec		= CEDRUS_CODEC_H265,
+		.required	= true,
+	},
+	{
+		.id		= V4L2_CID_MPEG_VIDEO_HEVC_PPS,
+		.elem_size	= sizeof(struct v4l2_ctrl_hevc_pps),
+		.codec		= CEDRUS_CODEC_H265,
+		.required	= true,
+	},
+	{
+		.id		= V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS,
+		.elem_size	= sizeof(struct v4l2_ctrl_hevc_slice_params),
+		.codec		= CEDRUS_CODEC_H265,
+		.required	= true,
+	},
 };
 
 #define CEDRUS_CONTROLS_COUNT	ARRAY_SIZE(cedrus_controls)
@@ -296,6 +314,7 @@ static int cedrus_probe(struct platform_device *pdev)
 
 	dev->dec_ops[CEDRUS_CODEC_MPEG2] = &cedrus_dec_ops_mpeg2;
 	dev->dec_ops[CEDRUS_CODEC_H264] = &cedrus_dec_ops_h264;
+	dev->dec_ops[CEDRUS_CODEC_H265] = &cedrus_dec_ops_h265;
 
 	mutex_init(&dev->dev_mutex);
 	spin_lock_init(&dev->irq_lock);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index bd8ba04cff9a..639a7976125a 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -31,6 +31,7 @@
 enum cedrus_codec {
 	CEDRUS_CODEC_MPEG2,
 	CEDRUS_CODEC_H264,
+	CEDRUS_CODEC_H265,
 	CEDRUS_CODEC_LAST,
 };
 
@@ -66,6 +67,12 @@ struct cedrus_mpeg2_run {
 	const struct v4l2_ctrl_mpeg2_quantization	*quantization;
 };
 
+struct cedrus_h265_run {
+	const struct v4l2_ctrl_hevc_sps			*sps;
+	const struct v4l2_ctrl_hevc_pps			*pps;
+	const struct v4l2_ctrl_hevc_slice_params	*slice_params;
+};
+
 struct cedrus_run {
 	struct vb2_v4l2_buffer	*src;
 	struct vb2_v4l2_buffer	*dst;
@@ -73,6 +80,7 @@ struct cedrus_run {
 	union {
 		struct cedrus_h264_run	h264;
 		struct cedrus_mpeg2_run	mpeg2;
+		struct cedrus_h265_run	h265;
 	};
 };
 
@@ -112,6 +120,14 @@ struct cedrus_ctx {
 			void		*pic_info_buf;
 			dma_addr_t	pic_info_buf_dma;
 		} h264;
+		struct {
+			void		*mv_col_buf;
+			dma_addr_t	mv_col_buf_addr;
+			ssize_t		mv_col_buf_size;
+			ssize_t		mv_col_buf_unit_size;
+			void		*neighbor_info_buf;
+			dma_addr_t	neighbor_info_buf_addr;
+		} h265;
 	} codec;
 };
 
@@ -157,6 +173,7 @@ struct cedrus_dev {
 
 extern struct cedrus_dec_ops cedrus_dec_ops_mpeg2;
 extern struct cedrus_dec_ops cedrus_dec_ops_h264;
+extern struct cedrus_dec_ops cedrus_dec_ops_h265;
 
 static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 val)
 {
@@ -165,7 +182,8 @@ static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 val)
 
 static inline u32 cedrus_read(struct cedrus_dev *dev, u32 reg)
 {
-	return readl(dev->base + reg);
+	u32 val = readl(dev->base + reg);
+	return val;
 }
 
 static inline dma_addr_t cedrus_buf_addr(struct vb2_buffer *buf,
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index ab25843cd7ad..7baa98266bf3 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -66,6 +66,15 @@ void cedrus_device_run(void *priv)
 			V4L2_CID_MPEG_VIDEO_H264_SPS);
 		break;
 
+	case V4L2_PIX_FMT_HEVC_SLICE:
+		run.h265.sps = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_HEVC_SPS);
+		run.h265.pps = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_HEVC_PPS);
+		run.h265.slice_params = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS);
+		break;
+
 	default:
 		ctx->job_abort = 1;
 		break;
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
new file mode 100644
index 000000000000..2a285997fa20
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -0,0 +1,540 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2013 Jens Kuske <jenskuske@gmail.com>
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ */
+
+#include <linux/types.h>
+
+#include <media/videobuf2-dma-contig.h>
+
+#include "cedrus.h"
+#include "cedrus_hw.h"
+#include "cedrus_regs.h"
+
+/*
+ * Note: Neighbor info buffer size is apparently doubled for H6, which may be
+ * related to 10 bit H265 support.
+ */
+#define CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE	(397 * SZ_1K)
+#define CEDRUS_H265_ENTRY_POINTS_BUF_SIZE	(4 * SZ_1K)
+#define CEDRUS_H265_MV_COL_BUF_UNIT_CTB_SIZE	160
+
+struct cedrus_h265_sram_frame_info {
+	__le32	top_pic_order_cnt;
+	__le32	bottom_pic_order_cnt;
+	__le32	top_mv_col_buf_addr;
+	__le32	bottom_mv_col_buf_addr;
+	__le32	luma_addr;
+	__le32	chroma_addr;
+} __packed;
+
+struct cedrus_h265_sram_pred_weight {
+	__s8	delta_weight;
+	__s8	offset;
+} __packed;
+
+static enum cedrus_irq_status cedrus_h265_irq_status(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg;
+
+	reg = cedrus_read(dev, VE_DEC_H265_STATUS);
+	reg &= VE_DEC_H265_STATUS_CHECK_MASK;
+
+	if (reg & VE_DEC_H265_STATUS_CHECK_ERROR ||
+	    !(reg & VE_DEC_H265_STATUS_SUCCESS))
+		return CEDRUS_IRQ_ERROR;
+
+	return CEDRUS_IRQ_OK;
+}
+
+static void cedrus_h265_irq_clear(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	cedrus_write(dev, VE_DEC_H265_STATUS, VE_DEC_H265_STATUS_CHECK_MASK);
+}
+
+static void cedrus_h265_irq_disable(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg = cedrus_read(dev, VE_DEC_H265_CTRL);
+
+	reg &= ~VE_DEC_H265_CTRL_IRQ_MASK;
+
+	cedrus_write(dev, VE_DEC_H265_CTRL, reg);
+}
+
+static void cedrus_h265_sram_write_offset(struct cedrus_dev *dev, u32 offset)
+{
+	cedrus_write(dev, VE_DEC_H265_SRAM_OFFSET, offset);
+}
+
+static void cedrus_h265_sram_write_data(struct cedrus_dev *dev, u32 *data,
+					unsigned int count)
+{
+	while (count--)
+		cedrus_write(dev, VE_DEC_H265_SRAM_DATA, *data++);
+}
+
+static inline dma_addr_t cedrus_h265_frame_info_mv_col_buf_addr(
+	struct cedrus_ctx *ctx, unsigned int index, unsigned int field)
+{
+	return ctx->codec.h265.mv_col_buf_addr + index *
+	       ctx->codec.h265.mv_col_buf_unit_size +
+	       field * ctx->codec.h265.mv_col_buf_unit_size / 2;
+}
+
+static void cedrus_h265_frame_info_write_single(struct cedrus_dev *dev,
+						unsigned int index,
+						bool field_pic,
+						u32 pic_order_cnt[],
+						dma_addr_t mv_col_buf_addr[],
+						dma_addr_t dst_luma_addr,
+						dma_addr_t dst_chroma_addr)
+{
+	u32 offset = VE_DEC_H265_SRAM_OFFSET_FRAME_INFO +
+		     VE_DEC_H265_SRAM_OFFSET_FRAME_INFO_UNIT * index;
+	struct cedrus_h265_sram_frame_info frame_info = {
+		.top_pic_order_cnt = pic_order_cnt[0],
+		.bottom_pic_order_cnt = field_pic ? pic_order_cnt[1] :
+					pic_order_cnt[0],
+		.top_mv_col_buf_addr =
+			VE_DEC_H265_SRAM_DATA_ADDR_BASE(mv_col_buf_addr[0]),
+		.bottom_mv_col_buf_addr = field_pic ?
+			VE_DEC_H265_SRAM_DATA_ADDR_BASE(mv_col_buf_addr[1]) :
+			VE_DEC_H265_SRAM_DATA_ADDR_BASE(mv_col_buf_addr[0]),
+		.luma_addr = VE_DEC_H265_SRAM_DATA_ADDR_BASE(dst_luma_addr),
+		.chroma_addr = VE_DEC_H265_SRAM_DATA_ADDR_BASE(dst_chroma_addr),
+	};
+	unsigned int count = sizeof(frame_info) / sizeof(u32);
+
+	cedrus_h265_sram_write_offset(dev, offset);
+	cedrus_h265_sram_write_data(dev, (u32 *)&frame_info, count);
+}
+
+static void cedrus_h265_frame_info_write_dpb(struct cedrus_ctx *ctx,
+					     const struct v4l2_hevc_dpb_entry *dpb,
+					     u8 num_active_dpb_entries)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	dma_addr_t dst_luma_addr, dst_chroma_addr;
+	dma_addr_t mv_col_buf_addr[2];
+	u32 pic_order_cnt[2];
+	unsigned int i;
+
+	for (i = 0; i < num_active_dpb_entries; i++) {
+		dst_luma_addr = cedrus_dst_buf_addr(ctx, dpb[i].buffer_index,
+						    0); // FIXME - PHYS_OFFSET ?
+		dst_chroma_addr = cedrus_dst_buf_addr(ctx, dpb[i].buffer_index,
+						      1); // FIXME - PHYS_OFFSET ?
+		mv_col_buf_addr[0] = cedrus_h265_frame_info_mv_col_buf_addr(ctx,
+			dpb[i].buffer_index, 0);
+		pic_order_cnt[0] = dpb[i].pic_order_cnt[0];
+
+		if (dpb[i].field_pic) {
+			mv_col_buf_addr[1] =
+				cedrus_h265_frame_info_mv_col_buf_addr(ctx,
+				dpb[i].buffer_index, 1);
+			pic_order_cnt[1] = dpb[i].pic_order_cnt[1];
+		}
+
+		cedrus_h265_frame_info_write_single(dev, i, dpb[i].field_pic,
+						    pic_order_cnt,
+						    mv_col_buf_addr,
+						    dst_luma_addr,
+						    dst_chroma_addr);
+	}
+}
+
+static void cedrus_h265_ref_pic_list_write(struct cedrus_dev *dev,
+					   const u8 list[],
+					   u8 num_ref_idx_active,
+					   const struct v4l2_hevc_dpb_entry *dpb,
+					   u8 num_active_dpb_entries,
+					   u32 sram_offset)
+{
+	unsigned int index;
+	unsigned int shift;
+	unsigned int i;
+	u32 reg = 0;
+	u8 value;
+
+	cedrus_h265_sram_write_offset(dev, sram_offset);
+
+	for (i = 0; i < num_ref_idx_active; i++) {
+		shift = (i % 4) * 8;
+
+		value = list[i];
+		index = value;
+
+		if (dpb[index].rps == V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR)
+			value |= VE_DEC_H265_SRAM_REF_PIC_LIST_LT_REF;
+
+		reg |= value << shift;
+
+		if ((i % 4) == 3 || i == (num_ref_idx_active - 1)) {
+			cedrus_h265_sram_write_data(dev, &reg, 1);
+			reg = 0;
+		}
+	}
+}
+
+static void cedrus_h265_pred_weight_write(struct cedrus_dev *dev,
+					  const s8 delta_luma_weight[],
+					  const s8 luma_offset[],
+					  const s8 delta_chroma_weight[][2],
+					  const s8 chroma_offset[][2],
+					  u8 num_ref_idx_active,
+					  u32 sram_luma_offset,
+					  u32 sram_chroma_offset)
+{
+	struct cedrus_h265_sram_pred_weight pred_weight[2] = { 0 };
+	unsigned int index;
+	unsigned int i, j;
+
+	cedrus_h265_sram_write_offset(dev, sram_luma_offset);
+
+	for (i = 0; i < num_ref_idx_active; i++) {
+		index = i % 2;
+
+		pred_weight[index].delta_weight = delta_luma_weight[i];
+		pred_weight[index].offset = luma_offset[i];
+
+		if (index == 1 || i == (num_ref_idx_active - 1))
+			cedrus_h265_sram_write_data(dev, (u32 *)&pred_weight,
+						    1);
+	}
+
+	cedrus_h265_sram_write_offset(dev, sram_chroma_offset);
+
+	for (i = 0; i < num_ref_idx_active; i++) {
+		for (j = 0; j < 2; j++) {
+			pred_weight[j].delta_weight = delta_chroma_weight[i][j];
+			pred_weight[j].offset = chroma_offset[i][j];
+		}
+
+		cedrus_h265_sram_write_data(dev, (u32 *)&pred_weight, 1);
+	}
+}
+
+static void cedrus_h265_setup(struct cedrus_ctx *ctx,
+			      struct cedrus_run *run)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	const struct v4l2_ctrl_hevc_sps *sps;
+	const struct v4l2_ctrl_hevc_pps *pps;
+	const struct v4l2_ctrl_hevc_slice_params *slice_params;
+	const struct v4l2_hevc_pred_weight_table *pred_weight_table;
+	unsigned int num_buffers;
+	unsigned int log2_max_luma_coding_block_size;
+	unsigned int ctb_size_luma;
+	dma_addr_t src_buf_addr;
+	dma_addr_t src_buf_end_addr;
+	dma_addr_t dst_luma_addr, dst_chroma_addr;
+	dma_addr_t mv_col_buf_addr[2];
+	u32 chroma_log2_weight_denom;
+	u32 output_pic_list_index;
+	u32 pic_order_cnt[2];
+	u32 reg;
+
+	sps = run->h265.sps;
+	pps = run->h265.pps;
+	slice_params = run->h265.slice_params;
+	pred_weight_table = &slice_params->pred_weight_table;
+
+	/* MV column buffer size and allocation. */
+	if (!ctx->codec.h265.mv_col_buf_size) {
+		num_buffers = run->dst->vb2_buf.vb2_queue->num_buffers;
+		log2_max_luma_coding_block_size =
+			sps->log2_min_luma_coding_block_size_minus3 + 3 +
+			sps->log2_diff_max_min_luma_coding_block_size;
+		ctb_size_luma = 1 << log2_max_luma_coding_block_size;
+
+		/*
+		 * Each CTB requires a MV col buffer with a specific unit size.
+		 * Since the address is given with missing lsb bits, 1 KiB is
+		 * added to each buffer to ensure proper alignment.
+		 */
+		ctx->codec.h265.mv_col_buf_unit_size =
+			DIV_ROUND_UP(ctx->src_fmt.width, ctb_size_luma) *
+			DIV_ROUND_UP(ctx->src_fmt.height, ctb_size_luma) *
+			CEDRUS_H265_MV_COL_BUF_UNIT_CTB_SIZE + SZ_1K;
+
+		ctx->codec.h265.mv_col_buf_size = num_buffers *
+			ctx->codec.h265.mv_col_buf_unit_size;
+
+		ctx->codec.h265.mv_col_buf =
+			dma_alloc_coherent(dev->dev,
+					   ctx->codec.h265.mv_col_buf_size,
+					   &ctx->codec.h265.mv_col_buf_addr,
+					   GFP_KERNEL);
+		if (!ctx->codec.h265.mv_col_buf) {
+			ctx->codec.h265.mv_col_buf_size = 0;
+			ctx->job_abort = 1;
+			return;
+		}
+	}
+
+	/* Activate H265 engine. */
+	cedrus_engine_enable(dev, CEDRUS_CODEC_H265);
+
+	/* Source offset and length in bits. */
+
+	reg = slice_params->data_bit_offset;
+	cedrus_write(dev, VE_DEC_H265_BITS_OFFSET, reg);
+
+	reg = slice_params->bit_size - slice_params->data_bit_offset;
+	cedrus_write(dev, VE_DEC_H265_BITS_LEN, reg);
+
+	/* Source beginning and end addresses. */
+
+	src_buf_addr = vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
+
+	reg = VE_DEC_H265_BITS_ADDR_BASE(src_buf_addr);
+	reg |= VE_DEC_H265_BITS_ADDR_VALID_SLICE_DATA;
+	reg |= VE_DEC_H265_BITS_ADDR_LAST_SLICE_DATA;
+	reg |= VE_DEC_H265_BITS_ADDR_FIRST_SLICE_DATA;
+
+	cedrus_write(dev, VE_DEC_H265_BITS_ADDR, reg);
+
+	src_buf_end_addr = src_buf_addr +
+			   DIV_ROUND_UP(slice_params->bit_size, 8);
+
+	reg = VE_DEC_H265_BITS_END_ADDR_BASE(src_buf_end_addr);
+	cedrus_write(dev, VE_DEC_H265_BITS_END_ADDR, reg);
+
+	/* Coding tree block address: start at the beginning. */
+	reg = VE_DEC_H265_DEC_CTB_ADDR_X(0) | VE_DEC_H265_DEC_CTB_ADDR_Y(0);
+	cedrus_write(dev, VE_DEC_H265_DEC_CTB_ADDR, reg);
+
+	cedrus_write(dev, VE_DEC_H265_TILE_START_CTB, 0);
+	cedrus_write(dev, VE_DEC_H265_TILE_END_CTB, 0);
+
+	/* Clear the number of correctly-decoded coding tree blocks. */
+	cedrus_write(dev, VE_DEC_H265_DEC_CTB_NUM, 0);
+
+	/* Initialize bitstream access. */
+	cedrus_write(dev, VE_DEC_H265_TRIGGER, VE_DEC_H265_TRIGGER_INIT_SWDEC);
+
+	/* Bitstream parameters. */
+
+	reg = VE_DEC_H265_DEC_NAL_HDR_NAL_UNIT_TYPE(slice_params->nal_unit_type) |
+	      VE_DEC_H265_DEC_NAL_HDR_NUH_TEMPORAL_ID_PLUS1(slice_params->nuh_temporal_id_plus1);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_NAL_HDR, reg);
+
+	reg = VE_DEC_H265_DEC_SPS_HDR_STRONG_INTRA_SMOOTHING_ENABLE_FLAG(sps->strong_intra_smoothing_enabled_flag) |
+	      VE_DEC_H265_DEC_SPS_HDR_SPS_TEMPORAL_MVP_ENABLED_FLAG(sps->sps_temporal_mvp_enabled_flag) |
+	      VE_DEC_H265_DEC_SPS_HDR_SAMPLE_ADAPTIVE_OFFSET_ENABLED_FLAG(sps->sample_adaptive_offset_enabled_flag) |
+	      VE_DEC_H265_DEC_SPS_HDR_AMP_ENABLED_FLAG(sps->amp_enabled_flag) |
+	      VE_DEC_H265_DEC_SPS_HDR_MAX_TRANSFORM_HIERARCHY_DEPTH_INTRA(sps->max_transform_hierarchy_depth_intra) |
+	      VE_DEC_H265_DEC_SPS_HDR_MAX_TRANSFORM_HIERARCHY_DEPTH_INTER(sps->max_transform_hierarchy_depth_inter) |
+	      VE_DEC_H265_DEC_SPS_HDR_LOG2_DIFF_MAX_MIN_TRANSFORM_BLOCK_SIZE(sps->log2_diff_max_min_luma_transform_block_size) |
+	      VE_DEC_H265_DEC_SPS_HDR_LOG2_MIN_TRANSFORM_BLOCK_SIZE_MINUS2(sps->log2_min_luma_transform_block_size_minus2) |
+	      VE_DEC_H265_DEC_SPS_HDR_LOG2_DIFF_MAX_MIN_LUMA_CODING_BLOCK_SIZE(sps->log2_diff_max_min_luma_coding_block_size) |
+	      VE_DEC_H265_DEC_SPS_HDR_LOG2_MIN_LUMA_CODING_BLOCK_SIZE_MINUS3(sps->log2_min_luma_coding_block_size_minus3) |
+	      VE_DEC_H265_DEC_SPS_HDR_BIT_DEPTH_CHROMA_MINUS8(sps->bit_depth_chroma_minus8) |
+	      VE_DEC_H265_DEC_SPS_HDR_SEPARATE_COLOUR_PLANE_FLAG(sps->separate_colour_plane_flag) |
+	      VE_DEC_H265_DEC_SPS_HDR_CHROMA_FORMAT_IDC(sps->chroma_format_idc);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_SPS_HDR, reg);
+
+	reg = VE_DEC_H265_DEC_PCM_CTRL_PCM_ENABLED_FLAG(sps->pcm_enabled_flag) |
+	      VE_DEC_H265_DEC_PCM_CTRL_PCM_LOOP_FILTER_DISABLED_FLAG(sps->pcm_loop_filter_disabled_flag) |
+	      VE_DEC_H265_DEC_PCM_CTRL_LOG2_DIFF_MAX_MIN_PCM_LUMA_CODING_BLOCK_SIZE(sps->log2_diff_max_min_pcm_luma_coding_block_size) |
+	      VE_DEC_H265_DEC_PCM_CTRL_LOG2_MIN_PCM_LUMA_CODING_BLOCK_SIZE_MINUS3(sps->log2_min_pcm_luma_coding_block_size_minus3) |
+	      VE_DEC_H265_DEC_PCM_CTRL_PCM_SAMPLE_BIT_DEPTH_CHROMA_MINUS1(sps->pcm_sample_bit_depth_chroma_minus1) |
+	      VE_DEC_H265_DEC_PCM_CTRL_PCM_SAMPLE_BIT_DEPTH_LUMA_MINUS1(sps->pcm_sample_bit_depth_luma_minus1);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_PCM_CTRL, reg);
+
+	reg = VE_DEC_H265_DEC_PPS_CTRL0_PPS_CR_QP_OFFSET(pps->pps_cr_qp_offset) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_PPS_CB_QP_OFFSET(pps->pps_cb_qp_offset) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_INIT_QP_MINUS26(pps->init_qp_minus26) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_DIFF_CU_QP_DELTA_DEPTH(pps->diff_cu_qp_delta_depth) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_CU_QP_DELTA_ENABLED_FLAG(pps->cu_qp_delta_enabled_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_TRANSFORM_SKIP_ENABLED_FLAG(pps->transform_skip_enabled_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_CONSTRAINED_INTRA_PRED_FLAG(pps->constrained_intra_pred_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL0_SIGN_DATA_HIDING_FLAG(pps->sign_data_hiding_enabled_flag);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_PPS_CTRL0, reg);
+
+	reg = VE_DEC_H265_DEC_PPS_CTRL1_LOG2_PARALLEL_MERGE_LEVEL_MINUS2(pps->log2_parallel_merge_level_minus2) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG(pps->pps_loop_filter_across_slices_enabled_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_LOOP_FILTER_ACROSS_TILES_ENABLED_FLAG(pps->loop_filter_across_tiles_enabled_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_ENTROPY_CODING_SYNC_ENABLED_FLAG(pps->entropy_coding_sync_enabled_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_TILES_ENABLED_FLAG(0) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_TRANSQUANT_BYPASS_ENABLE_FLAG(pps->transquant_bypass_enabled_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_WEIGHTED_BIPRED_FLAG(pps->weighted_bipred_flag) |
+	      VE_DEC_H265_DEC_PPS_CTRL1_WEIGHTED_PRED_FLAG(pps->weighted_pred_flag);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_PPS_CTRL1, reg);
+
+	reg = VE_DEC_H265_DEC_SLICE_HDR_INFO0_PICTURE_TYPE(slice_params->pic_struct) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_FIVE_MINUS_MAX_NUM_MERGE_CAND(slice_params->five_minus_max_num_merge_cand) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_NUM_REF_IDX_L1_ACTIVE_MINUS1(slice_params->num_ref_idx_l1_active_minus1) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_NUM_REF_IDX_L0_ACTIVE_MINUS1(slice_params->num_ref_idx_l0_active_minus1) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLLOCATED_REF_IDX(slice_params->collocated_ref_idx) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLLOCATED_FROM_L0_FLAG(slice_params->collocated_from_l0_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_CABAC_INIT_FLAG(slice_params->cabac_init_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_MVD_L1_ZERO_FLAG(slice_params->mvd_l1_zero_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_SAO_CHROMA_FLAG(slice_params->slice_sao_chroma_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_SAO_LUMA_FLAG(slice_params->slice_sao_luma_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_TEMPORAL_MVP_ENABLE_FLAG(slice_params->slice_temporal_mvp_enabled_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLOUR_PLANE_ID(slice_params->colour_plane_id) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_TYPE(slice_params->slice_type) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_DEPENDENT_SLICE_SEGMENT_FLAG(pps->dependent_slice_segment_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_FIRST_SLICE_SEGMENT_IN_PIC_FLAG(1);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO0, reg);
+
+	reg = VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_TC_OFFSET_DIV2(slice_params->slice_tc_offset_div2) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_BETA_OFFSET_DIV2(slice_params->slice_beta_offset_div2) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_DEBLOCKING_FILTER_DISABLED_FLAG(slice_params->slice_deblocking_filter_disabled_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG(slice_params->slice_loop_filter_across_slices_enabled_flag) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_POC_BIGEST_IN_RPS_ST(slice_params->num_rps_poc_st_curr_after == 0) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CR_QP_OFFSET(slice_params->slice_cr_qp_offset) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CB_QP_OFFSET(slice_params->slice_cb_qp_offset) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_QP_DELTA(slice_params->slice_qp_delta);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO1, reg);
+
+	chroma_log2_weight_denom = pred_weight_table->luma_log2_weight_denom +
+				   pred_weight_table->delta_chroma_log2_weight_denom;
+	reg = VE_DEC_H265_DEC_SLICE_HDR_INFO2_NUM_ENTRY_POINT_OFFSETS(0) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO2_CHROMA_LOG2_WEIGHT_DENOM(chroma_log2_weight_denom) |
+	      VE_DEC_H265_DEC_SLICE_HDR_INFO2_LUMA_LOG2_WEIGHT_DENOM(pred_weight_table->luma_log2_weight_denom);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO2, reg);
+
+	/* Decoded picture size. */
+
+	reg = VE_DEC_H265_DEC_PIC_SIZE_WIDTH(ctx->src_fmt.width) |
+	      VE_DEC_H265_DEC_PIC_SIZE_HEIGHT(ctx->src_fmt.height);
+
+	cedrus_write(dev, VE_DEC_H265_DEC_PIC_SIZE, reg);
+
+	/* Scaling list */
+
+	reg = VE_DEC_H265_SCALING_LIST_CTRL0_DEFAULT;
+	cedrus_write(dev, VE_DEC_H265_SCALING_LIST_CTRL0, reg);
+
+	/* Neightbor information address. */
+	reg = VE_DEC_H265_NEIGHBOR_INFO_ADDR_BASE(ctx->codec.h265.neighbor_info_buf_addr);
+	cedrus_write(dev, VE_DEC_H265_NEIGHBOR_INFO_ADDR, reg);
+
+	/* Write decoded picture buffer in pic list. */
+	cedrus_h265_frame_info_write_dpb(ctx, slice_params->dpb,
+					 slice_params->num_active_dpb_entries);
+
+	/* Output frame. */
+
+	output_pic_list_index = V4L2_HEVC_DPB_ENTRIES_NUM_MAX;
+	pic_order_cnt[0] = pic_order_cnt[1] = slice_params->slice_pic_order_cnt;
+	mv_col_buf_addr[0] = cedrus_h265_frame_info_mv_col_buf_addr(ctx,
+		run->dst->vb2_buf.index, 0);
+	mv_col_buf_addr[1] = cedrus_h265_frame_info_mv_col_buf_addr(ctx,
+		run->dst->vb2_buf.index, 1);
+	dst_luma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0); // FIXME - PHYS_OFFSET ?
+	dst_chroma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 1); // FIXME - PHYS_OFFSET ?
+
+	cedrus_h265_frame_info_write_single(dev, output_pic_list_index,
+					    slice_params->pic_struct != 0,
+					    pic_order_cnt, mv_col_buf_addr,
+					    dst_luma_addr, dst_chroma_addr);
+
+	cedrus_write(dev, VE_DEC_H265_OUTPUT_FRAME_IDX, output_pic_list_index);
+
+	/* Reference picture list 0 (for P/B frames). */
+	if (slice_params->slice_type != V4L2_HEVC_SLICE_TYPE_I) {
+		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l0,
+			slice_params->num_ref_idx_l0_active_minus1 + 1,
+			slice_params->dpb, slice_params->num_active_dpb_entries,
+			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST0);
+
+		if (pps->weighted_pred_flag || pps->weighted_bipred_flag)
+			cedrus_h265_pred_weight_write(dev,
+				pred_weight_table->delta_luma_weight_l0,
+				pred_weight_table->luma_offset_l0,
+				pred_weight_table->delta_chroma_weight_l0,
+				pred_weight_table->chroma_offset_l0,
+				slice_params->num_ref_idx_l0_active_minus1 + 1,
+				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L0,
+				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L0);
+	}
+
+	/* Reference picture list 1 (for B frames). */
+	if (slice_params->slice_type == V4L2_HEVC_SLICE_TYPE_B) {
+		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l1,
+			slice_params->num_ref_idx_l1_active_minus1 + 1,
+			slice_params->dpb,
+			slice_params->num_active_dpb_entries,
+			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST1);
+
+		if (pps->weighted_bipred_flag)
+			cedrus_h265_pred_weight_write(dev,
+				pred_weight_table->delta_luma_weight_l1,
+				pred_weight_table->luma_offset_l1,
+				pred_weight_table->delta_chroma_weight_l1,
+				pred_weight_table->chroma_offset_l1,
+				slice_params->num_ref_idx_l1_active_minus1 + 1,
+				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L1,
+				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L1);
+	}
+
+	/* Enable appropriate interruptions. */
+	cedrus_write(dev, VE_DEC_H265_CTRL, VE_DEC_H265_CTRL_IRQ_MASK);
+}
+
+static int cedrus_h265_start(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	/* The buffer size is calculated at setup time. */
+	ctx->codec.h265.mv_col_buf_size = 0;
+
+	ctx->codec.h265.neighbor_info_buf =
+		dma_alloc_coherent(dev->dev, CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE,
+				   &ctx->codec.h265.neighbor_info_buf_addr,
+				   GFP_KERNEL);
+	if (!ctx->codec.h265.neighbor_info_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void cedrus_h265_stop(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	if (ctx->codec.h265.mv_col_buf_size > 0) {
+		dma_free_coherent(dev->dev, ctx->codec.h265.mv_col_buf_size,
+				  ctx->codec.h265.mv_col_buf,
+				  ctx->codec.h265.mv_col_buf_addr);
+
+		ctx->codec.h265.mv_col_buf_size = 0;
+	}
+
+	dma_free_coherent(dev->dev, CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE,
+			  ctx->codec.h265.neighbor_info_buf,
+			  ctx->codec.h265.neighbor_info_buf_addr);
+}
+
+static void cedrus_h265_trigger(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	cedrus_write(dev, VE_DEC_H265_TRIGGER, VE_DEC_H265_TRIGGER_DEC_SLICE);
+}
+
+struct cedrus_dec_ops cedrus_dec_ops_h265 = {
+	.irq_clear	= cedrus_h265_irq_clear,
+	.irq_disable	= cedrus_h265_irq_disable,
+	.irq_status	= cedrus_h265_irq_status,
+	.setup		= cedrus_h265_setup,
+	.start		= cedrus_h265_start,
+	.stop		= cedrus_h265_stop,
+	.trigger	= cedrus_h265_trigger,
+};
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index cb6366b58acb..eb6c6f1fc6cc 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -50,6 +50,10 @@ int cedrus_engine_enable(struct cedrus_dev *dev, enum cedrus_codec codec)
 		reg |= VE_MODE_DEC_H264;
 		break;
 
+	case CEDRUS_CODEC_H265:
+		reg |= VE_MODE_DEC_H265;
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
index 2a851bc94687..45ea5ff3e5ea 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -18,10 +18,17 @@
  * * MC: Motion Compensation
  * * STCD: Start Code Detect
  * * SDRT: Scale Down and Rotate
+ * * WB: Writeback
+ * * BITS/BS: Bitstream
+ * * MB: Macroblock
+ * * CTU: Coding Tree Unit
+ * * CTB: Coding Tree Block
+ * * IDX: Index
  */
 
 #define VE_ENGINE_DEC_MPEG			0x100
 #define VE_ENGINE_DEC_H264			0x200
+#define VE_ENGINE_DEC_H265			0x500
 
 #define VE_MODE					0x00
 
@@ -230,6 +237,289 @@
 #define VE_DEC_MPEG_ROT_LUMA			(VE_ENGINE_DEC_MPEG + 0xcc)
 #define VE_DEC_MPEG_ROT_CHROMA			(VE_ENGINE_DEC_MPEG + 0xd0)
 
+#define VE_DEC_H265_DEC_NAL_HDR			(VE_ENGINE_DEC_H265 + 0x00)
+
+#define VE_DEC_H265_DEC_NAL_HDR_NUH_TEMPORAL_ID_PLUS1(v) \
+	(((v) << 6) & GENMASK(8, 6))
+#define VE_DEC_H265_DEC_NAL_HDR_NAL_UNIT_TYPE(v) \
+	((v) & GENMASK(5, 0))
+
+#define VE_DEC_H265_DEC_SPS_HDR			(VE_ENGINE_DEC_H265 + 0x04)
+
+#define VE_DEC_H265_DEC_SPS_HDR_STRONG_INTRA_SMOOTHING_ENABLE_FLAG(v) \
+	((v) ? BIT(26) : 0)
+#define VE_DEC_H265_DEC_SPS_HDR_SPS_TEMPORAL_MVP_ENABLED_FLAG(v) \
+	((v) ? BIT(25) : 0)
+#define VE_DEC_H265_DEC_SPS_HDR_SAMPLE_ADAPTIVE_OFFSET_ENABLED_FLAG(v) \
+	((v) ? BIT(24) : 0)
+#define VE_DEC_H265_DEC_SPS_HDR_AMP_ENABLED_FLAG(v) \
+	((v) ? BIT(23) : 0)
+#define VE_DEC_H265_DEC_SPS_HDR_MAX_TRANSFORM_HIERARCHY_DEPTH_INTRA(v) \
+	(((v) << 20) & GENMASK(22, 20))
+#define VE_DEC_H265_DEC_SPS_HDR_MAX_TRANSFORM_HIERARCHY_DEPTH_INTER(v) \
+	(((v) << 17) & GENMASK(19, 17))
+#define VE_DEC_H265_DEC_SPS_HDR_LOG2_DIFF_MAX_MIN_TRANSFORM_BLOCK_SIZE(v) \
+	(((v) << 15) & GENMASK(16, 15))
+#define VE_DEC_H265_DEC_SPS_HDR_LOG2_MIN_TRANSFORM_BLOCK_SIZE_MINUS2(v) \
+	(((v) << 13) & GENMASK(14, 13))
+#define VE_DEC_H265_DEC_SPS_HDR_LOG2_DIFF_MAX_MIN_LUMA_CODING_BLOCK_SIZE(v) \
+	(((v) << 11) & GENMASK(12, 11))
+#define VE_DEC_H265_DEC_SPS_HDR_LOG2_MIN_LUMA_CODING_BLOCK_SIZE_MINUS3(v) \
+	(((v) << 9) & GENMASK(10, 9))
+#define VE_DEC_H265_DEC_SPS_HDR_BIT_DEPTH_CHROMA_MINUS8(v) \
+	(((v) << 6) & GENMASK(8, 6))
+#define VE_DEC_H265_DEC_SPS_HDR_BIT_DEPTH_LUMA_MINUS8(v) \
+	(((v) << 3) & GENMASK(5, 3))
+#define VE_DEC_H265_DEC_SPS_HDR_SEPARATE_COLOUR_PLANE_FLAG(v) \
+	((v) ? BIT(2) : 0)
+#define VE_DEC_H265_DEC_SPS_HDR_CHROMA_FORMAT_IDC(v) \
+	((v) & GENMASK(1, 0))
+
+#define VE_DEC_H265_DEC_PIC_SIZE		(VE_ENGINE_DEC_H265 + 0x08)
+
+#define VE_DEC_H265_DEC_PIC_SIZE_WIDTH(w)	(((w) << 0) & GENMASK(13, 0))
+#define VE_DEC_H265_DEC_PIC_SIZE_HEIGHT(h)	(((h) << 16) & GENMASK(29, 16))
+
+#define VE_DEC_H265_DEC_PCM_CTRL		(VE_ENGINE_DEC_H265 + 0x0c)
+
+#define VE_DEC_H265_DEC_PCM_CTRL_PCM_ENABLED_FLAG(v) \
+	((v) ? BIT(15) : 0)
+#define VE_DEC_H265_DEC_PCM_CTRL_PCM_LOOP_FILTER_DISABLED_FLAG(v) \
+	((v) ? BIT(14) : 0)
+#define VE_DEC_H265_DEC_PCM_CTRL_LOG2_DIFF_MAX_MIN_PCM_LUMA_CODING_BLOCK_SIZE(v) \
+	(((v) << 10) & GENMASK(11, 10))
+#define VE_DEC_H265_DEC_PCM_CTRL_LOG2_MIN_PCM_LUMA_CODING_BLOCK_SIZE_MINUS3(v) \
+	(((v) << 8) & GENMASK(9, 8))
+#define VE_DEC_H265_DEC_PCM_CTRL_PCM_SAMPLE_BIT_DEPTH_CHROMA_MINUS1(v) \
+	(((v) << 4) & GENMASK(7, 4))
+#define VE_DEC_H265_DEC_PCM_CTRL_PCM_SAMPLE_BIT_DEPTH_LUMA_MINUS1(v) \
+	(((v) << 0) & GENMASK(3, 0))
+
+#define VE_DEC_H265_DEC_PPS_CTRL0		(VE_ENGINE_DEC_H265 + 0x10)
+
+#define VE_DEC_H265_DEC_PPS_CTRL0_PPS_CR_QP_OFFSET(v) \
+	(((v) << 24) & GENMASK(29, 24))
+#define VE_DEC_H265_DEC_PPS_CTRL0_PPS_CB_QP_OFFSET(v) \
+	(((v) << 16) & GENMASK(21, 16))
+#define VE_DEC_H265_DEC_PPS_CTRL0_INIT_QP_MINUS26(v) \
+	(((v) << 8) & GENMASK(14, 8))
+#define VE_DEC_H265_DEC_PPS_CTRL0_DIFF_CU_QP_DELTA_DEPTH(v) \
+	(((v) << 4) & GENMASK(5, 4))
+#define VE_DEC_H265_DEC_PPS_CTRL0_CU_QP_DELTA_ENABLED_FLAG(v) \
+	((v) ? BIT(3) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL0_TRANSFORM_SKIP_ENABLED_FLAG(v) \
+	((v) ? BIT(2) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL0_CONSTRAINED_INTRA_PRED_FLAG(v) \
+	((v) ? BIT(1) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL0_SIGN_DATA_HIDING_FLAG(v) \
+	((v) ? BIT(0) : 0)
+
+#define VE_DEC_H265_DEC_PPS_CTRL1		(VE_ENGINE_DEC_H265 + 0x14)
+
+#define VE_DEC_H265_DEC_PPS_CTRL1_LOG2_PARALLEL_MERGE_LEVEL_MINUS2(v) \
+	(((v) << 8) & GENMASK(10, 8))
+#define VE_DEC_H265_DEC_PPS_CTRL1_PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG(v) \
+	((v) ? BIT(6) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL1_LOOP_FILTER_ACROSS_TILES_ENABLED_FLAG(v) \
+	((v) ? BIT(5) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL1_ENTROPY_CODING_SYNC_ENABLED_FLAG(v) \
+	((v) ? BIT(4) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL1_TILES_ENABLED_FLAG(v) \
+	((v) ? BIT(3) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL1_TRANSQUANT_BYPASS_ENABLE_FLAG(v) \
+	((v) ? BIT(2) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL1_WEIGHTED_BIPRED_FLAG(v) \
+	((v) ? BIT(1) : 0)
+#define VE_DEC_H265_DEC_PPS_CTRL1_WEIGHTED_PRED_FLAG(v) \
+	((v) ? BIT(0) : 0)
+
+#define VE_DEC_H265_SCALING_LIST_CTRL0		(VE_ENGINE_DEC_H265 + 0x18)
+
+#define VE_DEC_H265_SCALING_LIST_CTRL0_ENABLED_FLAG(v) \
+	((v) ? BIT(31) : 0)
+#define VE_DEC_H265_SCALING_LIST_CTRL0_SRAM	(0 << 30)
+#define VE_DEC_H265_SCALING_LIST_CTRL0_DEFAULT	(1 << 30)
+
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0		(VE_ENGINE_DEC_H265 + 0x20)
+
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_PICTURE_TYPE(v) \
+	(((v) << 28) & GENMASK(29, 28))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_FIVE_MINUS_MAX_NUM_MERGE_CAND(v) \
+	(((v) << 24) & GENMASK(26, 24))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_NUM_REF_IDX_L1_ACTIVE_MINUS1(v) \
+	(((v) << 20) & GENMASK(23, 20))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_NUM_REF_IDX_L0_ACTIVE_MINUS1(v) \
+	(((v) << 16) & GENMASK(19, 16))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLLOCATED_REF_IDX(v) \
+	(((v) << 12) & GENMASK(15, 12))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLLOCATED_FROM_L0_FLAG(v) \
+	((v) ? BIT(11) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_CABAC_INIT_FLAG(v) \
+	((v) ? BIT(10) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_MVD_L1_ZERO_FLAG(v) \
+	((v) ? BIT(9) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_SAO_CHROMA_FLAG(v) \
+	((v) ? BIT(8) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_SAO_LUMA_FLAG(v) \
+	((v) ? BIT(7) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_TEMPORAL_MVP_ENABLE_FLAG(v) \
+	((v) ? BIT(6) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLOUR_PLANE_ID(v) \
+	(((v) << 4) & GENMASK(5, 4))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_TYPE(v) \
+	(((v) << 2) & GENMASK(3, 2))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_DEPENDENT_SLICE_SEGMENT_FLAG(v) \
+	((v) ? BIT(1) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO0_FIRST_SLICE_SEGMENT_IN_PIC_FLAG(v) \
+	((v) ? BIT(0) : 0)
+
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1		(VE_ENGINE_DEC_H265 + 0x24)
+
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_TC_OFFSET_DIV2(v) \
+	(((v) << 28) & GENMASK(31, 28))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_BETA_OFFSET_DIV2(v) \
+	(((v) << 24) & GENMASK(27, 24))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_DEBLOCKING_FILTER_DISABLED_FLAG(v) \
+	((v) ? BIT(23) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG(v) \
+	((v) ? BIT(22) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_POC_BIGEST_IN_RPS_ST(v) \
+	((v) ? BIT(21) : 0)
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CR_QP_OFFSET(v) \
+	(((v) << 16) & GENMASK(20, 16))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CB_QP_OFFSET(v) \
+	(((v) << 8) & GENMASK(12, 8))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_QP_DELTA(v) \
+	((v) & GENMASK(6, 0))
+
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO2		(VE_ENGINE_DEC_H265 + 0x28)
+
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO2_NUM_ENTRY_POINT_OFFSETS(v) \
+	(((v) << 8) & GENMASK(21, 8))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO2_CHROMA_LOG2_WEIGHT_DENOM(v) \
+	(((v) << 4) & GENMASK(6, 4))
+#define VE_DEC_H265_DEC_SLICE_HDR_INFO2_LUMA_LOG2_WEIGHT_DENOM(v) \
+	(((v) << 0) & GENMASK(2, 0))
+
+#define VE_DEC_H265_DEC_CTB_ADDR		(VE_ENGINE_DEC_H265 + 0x2c)
+
+#define VE_DEC_H265_DEC_CTB_ADDR_Y(y) 		(((y) << 16) & GENMASK(25, 16))
+#define VE_DEC_H265_DEC_CTB_ADDR_X(x) 		(((x) << 0) & GENMASK(9, 0))
+
+#define VE_DEC_H265_CTRL			(VE_ENGINE_DEC_H265 + 0x30)
+
+#define VE_DEC_H265_CTRL_DDR_CONSISTENCY_EN	BIT(31)
+#define VE_DEC_H265_CTRL_STCD_EN		BIT(25)
+#define VE_DEC_H265_CTRL_EPTB_DEC_BYPASS_EN	BIT(24)
+#define VE_DEC_H265_CTRL_TQ_BYPASS_EN		BIT(12)
+#define VE_DEC_H265_CTRL_VLD_BYPASS_EN		BIT(11)
+#define VE_DEC_H265_CTRL_NCRI_CACHE_DISABLE	BIT(10)
+#define VE_DEC_H265_CTRL_ROTATE_SCALE_OUT_EN	BIT(9)
+#define VE_DEC_H265_CTRL_MC_NO_WRITEBACK	BIT(8)
+#define VE_DEC_H265_CTRL_VLD_DATA_REQ_IRQ_EN	BIT(2)
+#define VE_DEC_H265_CTRL_ERROR_IRQ_EN		BIT(1)
+#define VE_DEC_H265_CTRL_FINISH_IRQ_EN		BIT(0)
+#define VE_DEC_H265_CTRL_IRQ_MASK \
+	(VE_DEC_H265_CTRL_FINISH_IRQ_EN | VE_DEC_H265_CTRL_ERROR_IRQ_EN | \
+	 VE_DEC_H265_CTRL_VLD_DATA_REQ_IRQ_EN)
+
+#define VE_DEC_H265_TRIGGER			(VE_ENGINE_DEC_H265 + 0x34)
+
+#define VE_DEC_H265_TRIGGER_STCD_VC1		(0x02 << 4)
+#define VE_DEC_H265_TRIGGER_STCD_AVS		(0x01 << 4)
+#define VE_DEC_H265_TRIGGER_STCD_HEVC		(0x00 << 4)
+#define VE_DEC_H265_TRIGGER_DEC_SLICE		(0x08 << 0)
+#define VE_DEC_H265_TRIGGER_INIT_SWDEC		(0x07 << 0)
+#define VE_DEC_H265_TRIGGER_BYTE_ALIGN		(0x06 << 0)
+#define VE_DEC_H265_TRIGGER_GET_VLCUE		(0x05 << 0)
+#define VE_DEC_H265_TRIGGER_GET_VLCSE		(0x04 << 0)
+#define VE_DEC_H265_TRIGGER_FLUSH_BITS		(0x03 << 0)
+#define VE_DEC_H265_TRIGGER_GET_BITS		(0x02 << 0)
+#define VE_DEC_H265_TRIGGER_SHOW_BITS		(0x01 << 0)
+
+#define VE_DEC_H265_STATUS			(VE_ENGINE_DEC_H265 + 0x38)
+
+#define VE_DEC_H265_STATUS_STCD			BIT(24)
+#define VE_DEC_H265_STATUS_STCD_BUSY		BIT(21)
+#define VE_DEC_H265_STATUS_WB_BUSY		BIT(20)
+#define VE_DEC_H265_STATUS_BS_DMA_BUSY		BIT(19)
+#define VE_DEC_H265_STATUS_IQIT_BUSY		BIT(18)
+#define VE_DEC_H265_STATUS_INTER_BUSY		BIT(17)
+#define VE_DEC_H265_STATUS_MORE_DATA		BIT(16)
+#define VE_DEC_H265_STATUS_VLD_BUSY		BIT(14)
+#define VE_DEC_H265_STATUS_DEBLOCKING_BUSY	BIT(13)
+#define VE_DEC_H265_STATUS_DEBLOCKING_DRAM_BUSY	BIT(12)
+#define VE_DEC_H265_STATUS_INTRA_BUSY		BIT(11)
+#define VE_DEC_H265_STATUS_SAO_BUSY		BIT(10)
+#define VE_DEC_H265_STATUS_MVP_BUSY		BIT(9)
+#define VE_DEC_H265_STATUS_SWDEC_BUSY		BIT(8)
+#define VE_DEC_H265_STATUS_OVER_TIME		BIT(3)
+#define VE_DEC_H265_STATUS_VLD_DATA_REQ		BIT(2)
+#define VE_DEC_H265_STATUS_ERROR		BIT(1)
+#define VE_DEC_H265_STATUS_SUCCESS		BIT(0)
+#define VE_DEC_H265_STATUS_STCD_TYPE_MASK	GENMASK(23, 22)
+#define VE_DEC_H265_STATUS_CHECK_MASK \
+	(VE_DEC_H265_STATUS_SUCCESS | VE_DEC_H265_STATUS_ERROR | \
+	 VE_DEC_H265_STATUS_VLD_DATA_REQ)
+#define VE_DEC_H265_STATUS_CHECK_ERROR \
+	(VE_DEC_H265_STATUS_ERROR | VE_DEC_H265_STATUS_VLD_DATA_REQ)
+
+#define VE_DEC_H265_DEC_CTB_NUM			(VE_ENGINE_DEC_H265 + 0x3c)
+
+#define VE_DEC_H265_BITS_ADDR			(VE_ENGINE_DEC_H265 + 0x40)
+
+#define VE_DEC_H265_BITS_ADDR_FIRST_SLICE_DATA	BIT(30)
+#define VE_DEC_H265_BITS_ADDR_LAST_SLICE_DATA	BIT(29)
+#define VE_DEC_H265_BITS_ADDR_VALID_SLICE_DATA	BIT(28)
+#define VE_DEC_H265_BITS_ADDR_BASE(a)		(((a) >> 8) & GENMASK(27, 0))
+
+#define VE_DEC_H265_BITS_OFFSET			(VE_ENGINE_DEC_H265 + 0x44)
+#define VE_DEC_H265_BITS_LEN			(VE_ENGINE_DEC_H265 + 0x48)
+
+#define VE_DEC_H265_BITS_END_ADDR		(VE_ENGINE_DEC_H265 + 0x4c)
+
+#define VE_DEC_H265_BITS_END_ADDR_BASE(a)	((a) >> 8)
+
+#define VE_DEC_H265_SDRT_CTRL			(VE_ENGINE_DEC_H265 + 0x50)
+#define VE_DEC_H265_SDRT_LUMA_ADDR		(VE_ENGINE_DEC_H265 + 0x54)
+#define VE_DEC_H265_SDRT_CHROMA_ADDR		(VE_ENGINE_DEC_H265 + 0x58)
+
+#define VE_DEC_H265_OUTPUT_FRAME_IDX		(VE_ENGINE_DEC_H265 + 0x5c)
+
+#define VE_DEC_H265_NEIGHBOR_INFO_ADDR		(VE_ENGINE_DEC_H265 + 0x60)
+
+#define VE_DEC_H265_NEIGHBOR_INFO_ADDR_BASE(a)	((a) >> 8)
+
+#define VE_DEC_H265_ENTRY_POINT_OFFSET_ADDR	(VE_ENGINE_DEC_H265 + 0x64)
+#define VE_DEC_H265_TILE_START_CTB		(VE_ENGINE_DEC_H265 + 0x68)
+#define VE_DEC_H265_TILE_END_CTB		(VE_ENGINE_DEC_H265 + 0x6c)
+
+#define VE_DEC_H265_LOW_ADDR			(VE_ENGINE_DEC_H265 + 0x80)
+
+#define VE_DEC_H265_LOW_ADDR_PRIMARY_CHROMA(a) \
+	(((a) << 24) & GENMASK(31, 24))
+#define VE_DEC_H265_LOW_ADDR_SECONDARY_CHROMA(a) \
+	(((a) << 16) & GENMASK(23, 16))
+#define VE_DEC_H265_LOW_ADDR_ENTRY_POINTS_BUF(a) \
+	(((a) << 0) & GENMASK(7, 0))
+
+#define VE_DEC_H265_SRAM_OFFSET			(VE_ENGINE_DEC_H265 + 0xe0)
+
+#define VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L0	0x00
+#define VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L0	0x20
+#define VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L1	0x60
+#define VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L1	0x80
+#define VE_DEC_H265_SRAM_OFFSET_FRAME_INFO		0x400
+#define VE_DEC_H265_SRAM_OFFSET_FRAME_INFO_UNIT		0x20
+#define VE_DEC_H265_SRAM_OFFSET_SCALING_LISTS		0x800
+#define VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST0		0xc00
+#define VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST1		0xc10
+
+#define VE_DEC_H265_SRAM_DATA			(VE_ENGINE_DEC_H265 + 0xe4)
+
+#define VE_DEC_H265_SRAM_DATA_ADDR_BASE(a)	((a) >> 8)
+#define VE_DEC_H265_SRAM_REF_PIC_LIST_LT_REF	BIT(7)
+
 /*  FIXME: Legacy below. */
 
 #define VBV_SIZE                       (1024 * 1024)
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 7af2054a75ad..0a38166396a4 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -45,6 +45,12 @@ static struct cedrus_format cedrus_formats[] = {
 		.num_planes	= 1,
 		.num_buffers	= 1,
 	},
+	{
+		.pixelformat	= V4L2_PIX_FMT_HEVC_SLICE,
+		.directions	= CEDRUS_DECODE_SRC,
+		.num_planes	= 1,
+		.num_buffers	= 1,
+	},
 	{
 		.pixelformat	= V4L2_PIX_FMT_SUNXI_TILED_NV12,
 		.directions	= CEDRUS_DECODE_DST,
@@ -104,6 +110,7 @@ static void cedrus_prepare_plane_format(struct cedrus_format *fmt,
 	switch (fmt->pixelformat) {
 	case V4L2_PIX_FMT_MPEG2_SLICE:
 	case V4L2_PIX_FMT_H264_SLICE:
+	case V4L2_PIX_FMT_HEVC_SLICE:
 		/* Zero bytes per line. */
 		bytesperline = 0;
 		break;
@@ -490,9 +497,15 @@ static int cedrus_start_streaming(struct vb2_queue *vq, unsigned int count)
 	case V4L2_PIX_FMT_MPEG2_SLICE:
 		ctx->current_codec = CEDRUS_CODEC_MPEG2;
 		break;
+
 	case V4L2_PIX_FMT_H264_SLICE:
 		ctx->current_codec = CEDRUS_CODEC_H264;
 		break;
+
+	case V4L2_PIX_FMT_HEVC_SLICE:
+		ctx->current_codec = CEDRUS_CODEC_H265;
+		break;
+
 	default:
 		return -EINVAL;
 	}
-- 
2.18.0
