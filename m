Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33201 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852AbcAZJEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:04:50 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@osg.samsung.com, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, herman.chen@rock-chips.com,
	alpha.lin@rock-chips.com, zhaojun <jung.zhao@rock-chips.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: [PATCH v1 3/3] media: vcodec: rockchip: Add Rockchip VP8 decoder driver
Date: Tue, 26 Jan 2016 17:04:06 +0800
Message-Id: <1453799046-307-4-git-send-email-jung.zhao@rock-chips.com>
In-Reply-To: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
References: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: zhaojun <jung.zhao@rock-chips.com>

add vp8 decoder for rk3229 & rk3288

Signed-off-by: zhaojun <jung.zhao@rock-chips.com>
---

 drivers/media/platform/rockchip-vpu/Makefile       |    3 +-
 .../media/platform/rockchip-vpu/rkvpu_hw_vp8d.c    |  798 ++++++++++
 .../platform/rockchip-vpu/rockchip_vp8d_regs.h     | 1594 ++++++++++++++++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.c |   15 +-
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  |   19 +-
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |   22 +
 6 files changed, 2448 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h

diff --git a/drivers/media/platform/rockchip-vpu/Makefile b/drivers/media/platform/rockchip-vpu/Makefile
index 5aab094..2163eb9 100644
--- a/drivers/media/platform/rockchip-vpu/Makefile
+++ b/drivers/media/platform/rockchip-vpu/Makefile
@@ -3,4 +3,5 @@ obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
 
 rockchip-vpu-y += rockchip_vpu.o \
 		rockchip_vpu_dec.o \
-		rockchip_vpu_hw.o
+		rockchip_vpu_hw.o \
+		rkvpu_hw_vp8d.o
diff --git a/drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c b/drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
new file mode 100644
index 0000000..d584eae
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
@@ -0,0 +1,798 @@
+/*
+ * Rockchip VPU codec vp8 decode driver
+ *
+ * Copyright (C) 2014 Rockchip Electronics Co., Ltd.
+ *	ZhiChao Yu <zhichao.yu@rock-chips.com>
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *      Tomasz Figa <tfiga@chromium.org>
+ *
+ * Copyright (C) 2015 Rockchip Electronics Co., Ltd.
+ *      Alpha Lin <alpha.lin@rock-chips.com>
+ *
+ * Copyright (C) 2015 Rockchip Electronics Co., Ltd.
+ *      Jung Zhao <jung.zhao@rock-chips.com>
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
+#include "rockchip_vpu_hw.h"
+#include "rockchip_vp8d_regs.h"
+#include "rockchip_vpu_common.h"
+
+#define RK_MAX_REGS_NUMS	256
+#define DEC_8190_ALIGN_MASK	0x07U
+
+static u32 *rockchip_regs_map;
+static u32 (*rockchip_regs_table)[3];
+static u32 rk_regs_value[RK_MAX_REGS_NUMS];
+
+#define RK_GET_REG_BASE(x) \
+	(rockchip_regs_table[rockchip_regs_map[(x)]][0])
+
+#define RK_GET_REG_BITS_MASK(x) \
+	(rockchip_regs_table[rockchip_regs_map[(x)]][1])
+
+#define RK_GET_REG_BITS_OFFSET(x) \
+	(rockchip_regs_table[rockchip_regs_map[(x)]][2])
+
+/*
+ * probs table with packed
+ */
+struct vp8_prob_tbl_packed {
+	u8 prob_mb_skip_false;
+	u8 prob_intra;
+	u8 prob_ref_last;
+	u8 prob_ref_golden;
+	u8 prob_segment[3];
+	u8 packed0;
+
+	u8 prob_luma_16x16_pred_mode[4];
+	u8 prob_chroma_pred_mode[3];
+	u8 packed1;
+
+	/* mv prob */
+	u8 prob_mv_context[2][19];
+	u8 packed2[2];
+
+	/* coeff probs */
+	u8 prob_coeffs[4][8][3][11];
+	u8 packed3[96];
+};
+
+/*
+ * filter taps taken to 7-bit precision,
+ * reference RFC6386#Page-16, filters[8][6]
+ */
+static const u32 vp8d_mc_filter[8][6] = {
+	{ 0, 0, 128, 0, 0, 0 },
+	{ 0, -6, 123, 12, -1, 0 },
+	{ 2, -11, 108, 36, -8, 1 },
+	{ 0, -9, 93, 50, -6, 0 },
+	{ 3, -16, 77, 77, -16, 3 },
+	{ 0, -6, 50, 93, -9, 0 },
+	{ 1, -8, 36, 108, -11, 2 },
+	{ 0, -1, 12, 123, -6, 0 }
+};
+
+/* dump hw params for debug */
+#ifdef DEBUG
+static void rockchip_vp8d_dump_hdr(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	int dct_total_len = 0;
+	int i;
+
+	vpu_debug(4, "Frame tag: key_frame=0x%02x, version=0x%02x\n",
+		  !hdr->key_frame, hdr->version);
+
+	vpu_debug(4, "Picture size: w=%d, h=%d\n", hdr->width, hdr->height);
+
+	/* stream addresses */
+	vpu_debug(4, "Addresses: segmap=0x%x, probs=0x%x\n",
+		  ctx->hw.vp8d.segment_map.dma,
+		  ctx->hw.vp8d.prob_tbl.dma);
+
+	/* reference frame info */
+	vpu_debug(4, "Ref frame: last=%d, golden=%d, alt=%d\n",
+		  hdr->last_frame, hdr->golden_frame, hdr->alt_frame);
+
+	/* bool decoder info */
+	vpu_debug(4, "Bool decoder: range=0x%x, value=0x%x, count=0x%x\n",
+		  hdr->bool_dec_range, hdr->bool_dec_value,
+		  hdr->bool_dec_count);
+
+	/* control partition info */
+	vpu_debug(4, "Control Part: offset=0x%x, size=0x%x\n",
+		  hdr->first_part_offset, hdr->first_part_size);
+	vpu_debug(2, "Macroblock Data: bits_offset=0x%x\n",
+		  hdr->macroblock_bit_offset);
+
+	/* dct partition info */
+	for (i = 0; i < hdr->num_dct_parts; i++) {
+		dct_total_len += hdr->dct_part_sizes[i];
+		vpu_debug(4, "Dct Part%d Size: 0x%x\n",
+			  i, hdr->dct_part_sizes[i]);
+	}
+
+	dct_total_len += (hdr->num_dct_parts - 1) * 3;
+	vpu_debug(4, "Dct Part Total Length: 0x%x\n", dct_total_len);
+}
+#else
+static inline void rockchip_vp8d_dump_hdr(struct rockchip_vpu_ctx *ctx) { }
+#endif
+
+static void vp8d_write_regs_value(u32 index, u32 value, char *name)
+{
+	vpu_debug(6, "rk_regs_value[ %s:%03d ]=%08x\n", name, index, value);
+	rk_regs_value[index] = value;
+}
+static void rockchip_vp8d_prob_update(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	const struct v4l2_vp8_entropy_hdr *entropy_hdr = &hdr->entropy_hdr;
+	u32 i, j, k;
+	u8 *dst;
+
+	/* first probs */
+	dst = ctx->hw.vp8d.prob_tbl.cpu;
+
+	dst[0] = hdr->prob_skip_false;
+	dst[1] = hdr->prob_intra;
+	dst[2] = hdr->prob_last;
+	dst[3] = hdr->prob_gf;
+	dst[4] = hdr->sgmnt_hdr.segment_probs[0];
+	dst[5] = hdr->sgmnt_hdr.segment_probs[1];
+	dst[6] = hdr->sgmnt_hdr.segment_probs[2];
+	dst[7] = 0;
+
+	dst += 8;
+	dst[0] = entropy_hdr->y_mode_probs[0];
+	dst[1] = entropy_hdr->y_mode_probs[1];
+	dst[2] = entropy_hdr->y_mode_probs[2];
+	dst[3] = entropy_hdr->y_mode_probs[3];
+	dst[4] = entropy_hdr->uv_mode_probs[0];
+	dst[5] = entropy_hdr->uv_mode_probs[1];
+	dst[6] = entropy_hdr->uv_mode_probs[2];
+	dst[7] = 0; /*unused */
+
+	/* mv probs */
+	dst += 8;
+	dst[0] = entropy_hdr->mv_probs[0][0]; /* is short */
+	dst[1] = entropy_hdr->mv_probs[1][0];
+	dst[2] = entropy_hdr->mv_probs[0][1]; /* sign */
+	dst[3] = entropy_hdr->mv_probs[1][1];
+	dst[4] = entropy_hdr->mv_probs[0][8 + 9];
+	dst[5] = entropy_hdr->mv_probs[0][9 + 9];
+	dst[6] = entropy_hdr->mv_probs[1][8 + 9];
+	dst[7] = entropy_hdr->mv_probs[1][9 + 9];
+	dst += 8;
+	for (i = 0; i < 2; ++i) {
+		for (j = 0; j < 8; j += 4) {
+			dst[0] = entropy_hdr->mv_probs[i][j + 9 + 0];
+			dst[1] = entropy_hdr->mv_probs[i][j + 9 + 1];
+			dst[2] = entropy_hdr->mv_probs[i][j + 9 + 2];
+			dst[3] = entropy_hdr->mv_probs[i][j + 9 + 3];
+			dst += 4;
+		}
+	}
+	for (i = 0; i < 2; ++i) {
+		dst[0] = entropy_hdr->mv_probs[i][0 + 2];
+		dst[1] = entropy_hdr->mv_probs[i][1 + 2];
+		dst[2] = entropy_hdr->mv_probs[i][2 + 2];
+		dst[3] = entropy_hdr->mv_probs[i][3 + 2];
+		dst[4] = entropy_hdr->mv_probs[i][4 + 2];
+		dst[5] = entropy_hdr->mv_probs[i][5 + 2];
+		dst[6] = entropy_hdr->mv_probs[i][6 + 2];
+		dst[7] = 0; /*unused */
+		dst += 8;
+	}
+
+	/* coeff probs (header part) */
+	dst = ctx->hw.vp8d.prob_tbl.cpu;
+	dst += (8 * 7);
+	for (i = 0; i < 4; ++i) {
+		for (j = 0; j < 8; ++j) {
+			for (k = 0; k < 3; ++k) {
+				dst[0] = entropy_hdr->coeff_probs[i][j][k][0];
+				dst[1] = entropy_hdr->coeff_probs[i][j][k][1];
+				dst[2] = entropy_hdr->coeff_probs[i][j][k][2];
+				dst[3] = entropy_hdr->coeff_probs[i][j][k][3];
+				dst += 4;
+			}
+		}
+	}
+
+	/* coeff probs (footer part) */
+	dst = ctx->hw.vp8d.prob_tbl.cpu;
+	dst += (8 * 55);
+	for (i = 0; i < 4; ++i) {
+		for (j = 0; j < 8; ++j) {
+			for (k = 0; k < 3; ++k) {
+				dst[0] = entropy_hdr->coeff_probs[i][j][k][4];
+				dst[1] = entropy_hdr->coeff_probs[i][j][k][5];
+				dst[2] = entropy_hdr->coeff_probs[i][j][k][6];
+				dst[3] = entropy_hdr->coeff_probs[i][j][k][7];
+				dst[4] = entropy_hdr->coeff_probs[i][j][k][8];
+				dst[5] = entropy_hdr->coeff_probs[i][j][k][9];
+				dst[6] = entropy_hdr->coeff_probs[i][j][k][10];
+				dst[7] = 0; /*unused */
+				dst += 8;
+			}
+		}
+	}
+}
+
+/*
+ * set loop filters
+ */
+static void rockchip_vp8d_cfg_lf(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	__s8 reg_value;
+	int i;
+
+	if (!(hdr->sgmnt_hdr.flags & V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED)) {
+		vp8d_write_regs_value(VDPU_REG_REF_PIC_LF_LEVEL_0,
+				      hdr->lf_hdr.level,
+				      "VDPU_REG_REF_PIC_LF_LEVEL_0");
+	} else if (hdr->sgmnt_hdr.segment_feature_mode) {
+		/* absolute mode */
+		for (i = 0; i < 4; i++) {
+			vp8d_write_regs_value(VDPU_REG_REF_PIC_LF_LEVEL_0 + i,
+					      hdr->sgmnt_hdr.lf_update[i],
+					      "VDPU_REG_REF_PIC_LF_LEVEL_ARRAY"
+					      );
+		}
+	} else {
+		/* delta mode */
+		for (i = 0; i < 4; i++) {
+			vp8d_write_regs_value(VDPU_REG_REF_PIC_LF_LEVEL_0 + i,
+					      clamp(hdr->lf_hdr.level +
+						    hdr->sgmnt_hdr.lf_update[i],
+						    0, 63),
+					      "VDPU_REG_REF_PIC_LF_LEVEL_ARRAY"
+					      );
+		}
+	}
+
+	vp8d_write_regs_value(VDPU_REG_REF_PIC_FILT_SHARPNESS,
+			      (hdr->lf_hdr.sharpness_level),
+			      "VDPU_REG_REF_PIC_FILT_SHARPNESS");
+	if (hdr->lf_hdr.type)
+		vp8d_write_regs_value(VDPU_REG_REF_PIC_FILT_TYPE_E, 1,
+				      "VDPU_REG_REF_PIC_FILT_TYPE_E");
+
+	if (hdr->lf_hdr.flags & V4L2_VP8_LF_HDR_ADJ_ENABLE) {
+		for (i = 0; i < 4; i++) {
+			reg_value = hdr->lf_hdr.mb_mode_delta_magnitude[i];
+			vp8d_write_regs_value(VDPU_REG_FILT_MB_ADJ_0 + i,
+					      reg_value,
+					      "VDPU_REG_FILT_MB_ADJ_ARRAY");
+			reg_value = hdr->lf_hdr.ref_frm_delta_magnitude[i];
+			vp8d_write_regs_value(VDPU_REG_REF_PIC_ADJ_0 + i,
+					      reg_value,
+					      "VDPU_REG_REF_PIC_ADJ_ARRAY");
+		}
+	}
+}
+
+/*
+ * set quantization parameters
+ */
+static void rockchip_vp8d_cfg_qp(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	__s8 reg_value;
+	int i;
+
+	if (!(hdr->sgmnt_hdr.flags & V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED)) {
+		vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_0,
+				      hdr->quant_hdr.y_ac_qi,
+				      "VDPU_REG_REF_PIC_QUANT_0");
+	} else if (hdr->sgmnt_hdr.segment_feature_mode) {
+		/* absolute mode */
+		for (i = 0; i < 4; i++) {
+			vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_0 + i,
+					      hdr->sgmnt_hdr.quant_update[i],
+					      "VDPU_REG_REF_PIC_QUANT_ARRAY");
+		}
+	} else {
+		/* delta mode */
+		for (i = 0; i < 4; i++) {
+			reg_value = hdr->sgmnt_hdr.quant_update[i];
+			vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_0 + i,
+					      clamp(hdr->quant_hdr.y_ac_qi +
+						    reg_value,
+						    0, 127),
+					      "VDPU_REG_REF_PIC_QUANT_ARRAY");
+		}
+	}
+
+	vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_DELTA_0,
+			      hdr->quant_hdr.y_dc_delta,
+			      "VDPU_REG_REF_PIC_QUANT_DELTA_0");
+	vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_DELTA_1,
+			      hdr->quant_hdr.y2_dc_delta,
+			      "VDPU_REG_REF_PIC_QUANT_DELTA_1");
+	vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_DELTA_2,
+			      hdr->quant_hdr.y2_ac_delta,
+			      "VDPU_REG_REF_PIC_QUANT_DELTA_2");
+	vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_DELTA_3,
+			      hdr->quant_hdr.uv_dc_delta,
+			      "VDPU_REG_REF_PIC_QUANT_DELTA_3");
+	vp8d_write_regs_value(VDPU_REG_REF_PIC_QUANT_DELTA_4,
+			      hdr->quant_hdr.uv_ac_delta,
+			      "VDPU_REG_REF_PIC_QUANT_DELTA_4");
+}
+
+/*
+ * set control partition and dct partition regs
+ *
+ * VP8 frame stream data layout:
+ *
+ *	                     first_part_size          parttion_sizes[0]
+ *                              ^                     ^
+ * src_dma                      |                     |
+ * ^                   +--------+------+        +-----+-----+
+ * |                   | control part  |        |           |
+ * +--------+----------------+------------------+-----------+-----+-----------+
+ * | tag 3B | extra 7B | hdr | mb_data | dct sz | dct part0 | ... | dct partn |
+ * +--------+-----------------------------------+-----------+-----+-----------+
+ *                     |     |         |        |                             |
+ *                     |     v         +----+---+                             v
+ *                     |     mb_start       |                       src_dma_end
+ *                     v                    v
+ *             first_part_offset         dct size part
+ *                                      (num_dct-1)*3B
+ * Note:
+ *   1. only key frame has extra 7 bytes
+ *   2. all offsets are base on src_dma
+ *   3. number of dct parts is 1, 2, 4 or 8
+ *   4. the addresses set to vpu must be 64bits alignment
+ */
+static void rockchip_vp8d_cfg_parts(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	u32 dct_part_total_len = 0;
+	u32 dct_size_part_size = 0;
+	u32 dct_part_offset = 0;
+	u32 mb_offset_bytes = 0;
+	u32 mb_offset_bits = 0;
+	u32 mb_start_bits = 0;
+	dma_addr_t src_dma;
+	u32 mb_size = 0;
+	u32 count = 0;
+	u32 i;
+
+	src_dma = vb2_dma_contig_plane_dma_addr(&ctx->run.src->b.vb2_buf, 0);
+
+	/*
+	 * Calculate control partition mb data info
+	 * @macroblock_bit_offset:	bits offset of mb data from first
+	 *				part start pos
+	 * @mb_offset_bits:		bits offset of mb data from src_dma
+	 *				base addr
+	 * @mb_offset_byte:		bytes offset of mb data from src_dma
+	 *				base addr
+	 * @mb_start_bits:		bits offset of mb data from mb data
+	 *				64bits alignment addr
+	 */
+	mb_offset_bits = hdr->first_part_offset * 8
+			 + hdr->macroblock_bit_offset + 8;
+	mb_offset_bytes = mb_offset_bits / 8;
+	mb_start_bits = mb_offset_bits
+			- (mb_offset_bytes & (~DEC_8190_ALIGN_MASK)) * 8;
+	mb_size = hdr->first_part_size
+		  - (mb_offset_bytes - hdr->first_part_offset)
+		  + (mb_offset_bytes & DEC_8190_ALIGN_MASK);
+
+	/* mb data aligned base addr */
+	vp8d_write_regs_value(VDPU_REG_VP8_ADDR_CTRL_PART,
+			      (mb_offset_bytes & (~DEC_8190_ALIGN_MASK))
+			      + src_dma,
+			      "VDPU_REG_VP8_ADDR_CTRL_PART");
+
+	/* mb data start bits */
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL2_STRM1_START_BIT,
+			      mb_start_bits,
+			      "VDPU_REG_DEC_CTRL2_STRM1_START_BIT");
+
+	/* mb aligned data length */
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL6_STREAM1_LEN,
+			      mb_size,
+			      "VDPU_REG_DEC_CTRL6_STREAM1_LEN");
+
+	/*
+	 * Calculate dct partition info
+	 * @dct_size_part_size: Containing sizes of dct part, every dct part
+	 *			has 3 bytes to store its size, except the last
+	 *			dct part
+	 * @dct_part_offset:	bytes offset of dct parts from src_dma base addr
+	 * @dct_part_total_len: total size of all dct parts
+	 */
+	dct_size_part_size = (hdr->num_dct_parts - 1) * 3;
+	dct_part_offset = hdr->first_part_offset + hdr->first_part_size;
+	for (i = 0; i < hdr->num_dct_parts; i++)
+		dct_part_total_len += hdr->dct_part_sizes[i];
+	dct_part_total_len += dct_size_part_size;
+	dct_part_total_len += (dct_part_offset & DEC_8190_ALIGN_MASK);
+
+	/* number of dct partitions */
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL6_COEFFS_PART_AM,
+			      (hdr->num_dct_parts - 1),
+			      "VDPU_REG_DEC_CTRL6_COEFFS_PART_AM");
+
+	/* dct partition length */
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL3_STREAM_LEN,
+			      dct_part_total_len,
+			      "VDPU_REG_DEC_CTRL3_STREAM_LEN");
+	/* dct partitions base address */
+	for (i = 0; i < hdr->num_dct_parts; i++) {
+		u32 byte_offset = dct_part_offset + dct_size_part_size + count;
+		u32 base_addr = byte_offset + src_dma;
+
+		vp8d_write_regs_value(VDPU_REG_ADDR_STR + i,
+				      base_addr & (~DEC_8190_ALIGN_MASK),
+				      "VDPU_REG_ADDR_STR_ARRAY");
+
+		vp8d_write_regs_value(VDPU_REG_DEC_CTRL2_STRM_START_BIT + i,
+				      ((byte_offset & DEC_8190_ALIGN_MASK) * 8),
+				      "VDPU_REG_DEC_CTRL2_STRM_START_BIT_ARRAY"
+				     );
+
+		count += hdr->dct_part_sizes[i];
+	}
+}
+
+/*
+ * prediction filter taps
+ * normal 6-tap filters
+ */
+static void rockchip_vp8d_cfg_tap(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	int i, j, index;
+
+	if ((hdr->version & 0x03) != 0)
+		return; /* Tap filter not used. */
+
+	for (i = 0; i < 8; i++) {
+		for (j = 0; j < 6; j++) {
+			index = VDPU_REG_PRED_FLT_NONE_0 + i * 6 + j;
+			if (RK_GET_REG_BASE(index) != 0) {
+				vp8d_write_regs_value(index,
+						      vp8d_mc_filter[i][j],
+						      "VDPU_REG_PRED_FLT_ARRAY"
+						      );
+			}
+		}
+	}
+}
+
+/* set reference frame */
+static void rockchip_vp8d_cfg_ref(struct rockchip_vpu_ctx *ctx)
+{
+	struct vb2_buffer *buf;
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	dma_addr_t dma_address;
+
+	/* set last frame address */
+	if (hdr->last_frame >= ctx->vq_dst.num_buffers)
+		buf = &ctx->run.dst->b.vb2_buf;
+	else
+		buf = ctx->dst_bufs[hdr->last_frame];
+
+	if (!hdr->key_frame) {
+		dma_address =
+			vb2_dma_contig_plane_dma_addr(&ctx->run.dst->b.vb2_buf,
+						      0);
+		vp8d_write_regs_value(VDPU_REG_VP8_ADDR_REF0,
+				      dma_address,
+				      "VDPU_REG_VP8_ADDR_REF0");
+	} else {
+		vp8d_write_regs_value(VDPU_REG_VP8_ADDR_REF0,
+				      vb2_dma_contig_plane_dma_addr(buf, 0),
+				      "VDPU_REG_VP8_ADDR_REF0");
+	}
+
+	/* set golden reference frame buffer address */
+	if (hdr->golden_frame >= ctx->vq_dst.num_buffers)
+		buf = &ctx->run.dst->b.vb2_buf;
+	else
+		buf = ctx->dst_bufs[hdr->golden_frame];
+
+	vp8d_write_regs_value(VDPU_REG_VP8_ADDR_REF2_5_0,
+			      vb2_dma_contig_plane_dma_addr(buf, 0),
+			      "VDPU_REG_VP8_ADDR_REF2_5_0");
+
+	if (hdr->sign_bias_golden)
+		vp8d_write_regs_value(VDPU_REG_VP8_GREF_SIGN_BIAS_0, 1,
+				      "VDPU_REG_VP8_GREF_SIGN_BIAS_0");
+
+	/* set alternate reference frame buffer address */
+	if (hdr->alt_frame >= ctx->vq_dst.num_buffers)
+		buf = &ctx->run.dst->b.vb2_buf;
+	else
+		buf = ctx->dst_bufs[hdr->alt_frame];
+
+	vp8d_write_regs_value(VDPU_REG_VP8_ADDR_REF2_5_1,
+			      vb2_dma_contig_plane_dma_addr(buf, 0),
+			      "VDPU_REG_VP8_ADDR_REF2_5_1");
+	if (hdr->sign_bias_alternate)
+		vp8d_write_regs_value(VDPU_REG_VP8_AREF_SIGN_BIAS_1, 1,
+				      "VDPU_REG_VP8_AREF_SIGN_BIAS_1");
+}
+
+static void rockchip_vp8d_cfg_buffers(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	dma_addr_t dma_address;
+
+	/* set probability table buffer address */
+	vp8d_write_regs_value(VDPU_REG_ADDR_QTABLE,
+			      ctx->hw.vp8d.prob_tbl.dma,
+			      "VDPU_REG_ADDR_QTABLE");
+
+	/* set segment map address */
+	vp8d_write_regs_value(VDPU_REG_FWD_PIC1_SEGMENT_BASE,
+			      ctx->hw.vp8d.segment_map.dma,
+			      "VDPU_REG_FWD_PIC1_SEGMENT_BASE");
+
+	if (hdr->sgmnt_hdr.flags & V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED) {
+		vp8d_write_regs_value(VDPU_REG_FWD_PIC1_SEGMENT_E, 1,
+				      "VDPU_REG_FWD_PIC1_SEGMENT_E");
+		if (hdr->sgmnt_hdr.flags & V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_MAP)
+			vp8d_write_regs_value(VDPU_REG_FWD_PIC1_SEGMENT_UPD_E,
+					      1,
+					      "VDPU_REG_FWD_PIC1_SEGMENT_UPD_E");
+	}
+
+	dma_address = vb2_dma_contig_plane_dma_addr(&ctx->run.dst->b.vb2_buf,
+						    0);
+	/* set output frame buffer address */
+	vp8d_write_regs_value(VDPU_REG_ADDR_DST, dma_address,
+			      "VDPU_REG_ADDR_DST");
+}
+
+int rockchip_vpu_vp8d_init(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	unsigned int mb_width, mb_height;
+	size_t segment_map_size;
+	int ret;
+
+	vpu_debug_enter();
+	if (vpu->variant->vpu_type == RK3229_VPU) {
+		rockchip_regs_table = rk3229_vp8d_regs_table;
+		rockchip_regs_map = rk3229_regs_map;
+	} else if (vpu->variant->vpu_type == RK3288_VPU) {
+		rockchip_regs_table = rk3288_vp8d_regs_table;
+		rockchip_regs_map = rk3288_regs_map;
+	} else {
+		vpu_err("unknown platform\n");
+		return -EPERM;
+	}
+	/* segment map table size calculation */
+	mb_width = MB_WIDTH(ctx->dst_fmt.width);
+	mb_height = MB_HEIGHT(ctx->dst_fmt.height);
+	segment_map_size = round_up(DIV_ROUND_UP(mb_width * mb_height, 4), 64);
+
+	/*
+	 * In context init the dma buffer for segment map must be allocated.
+	 * And the data in segment map buffer must be set to all zero.
+	 */
+	ret = rockchip_vpu_aux_buf_alloc(vpu, &ctx->hw.vp8d.segment_map,
+					 segment_map_size);
+	if (ret) {
+		vpu_err("allocate segment map mem failed\n");
+		return ret;
+	}
+	memset(ctx->hw.vp8d.segment_map.cpu, 0, ctx->hw.vp8d.segment_map.size);
+
+	/*
+	 * Allocate probability table buffer,
+	 * total 1208 bytes, 4K page is far enough.
+	 */
+	ret = rockchip_vpu_aux_buf_alloc(vpu, &ctx->hw.vp8d.prob_tbl,
+					 sizeof(struct vp8_prob_tbl_packed));
+	if (ret) {
+		vpu_err("allocate prob table mem failed\n");
+		goto prob_table_failed;
+	}
+
+	vpu_debug_leave();
+	return 0;
+
+prob_table_failed:
+	rockchip_vpu_aux_buf_free(vpu, &ctx->hw.vp8d.segment_map);
+
+	vpu_debug_leave();
+	return ret;
+}
+
+void rockchip_vpu_vp8d_exit(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+
+	vpu_debug_enter();
+
+	rockchip_vpu_aux_buf_free(vpu, &ctx->hw.vp8d.segment_map);
+	rockchip_vpu_aux_buf_free(vpu, &ctx->hw.vp8d.prob_tbl);
+
+	vpu_debug_leave();
+}
+
+void rockchip_vpu_vp8d_run(struct rockchip_vpu_ctx *ctx)
+{
+	const struct v4l2_ctrl_vp8_frame_hdr *hdr = ctx->run.vp8d.frame_hdr;
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	size_t height = ctx->dst_fmt.height;
+	size_t width = ctx->dst_fmt.width;
+	u32 mb_width, mb_height;
+	u32 reg;
+	u32 cur_reg;
+	u32 reg_base;
+	int i;
+
+	vpu_debug_enter();
+
+	memset(rk_regs_value, 0, sizeof(rk_regs_value));
+
+	rockchip_vp8d_dump_hdr(ctx);
+
+	/* reset segment_map buffer in keyframe */
+	if (!hdr->key_frame && ctx->hw.vp8d.segment_map.cpu)
+		memset(ctx->hw.vp8d.segment_map.cpu, 0,
+		       ctx->hw.vp8d.segment_map.size);
+
+	rockchip_vp8d_prob_update(ctx);
+
+	rockchip_vpu_power_on(vpu);
+
+	for (i = 0; i < vpu->variant->dec_reg_num; i++)
+		vdpu_write_relaxed(vpu, 0, i * 4);
+
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_TIMEOUT_E, 1,
+			      "VDPU_REG_CONFIG_DEC_TIMEOUT_E");
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_CLK_GATE_E, 1,
+			      "VDPU_REG_CONFIG_DEC_CLK_GATE_E");
+
+	if (hdr->key_frame)
+		vp8d_write_regs_value(VDPU_REG_DEC_CTRL0_PIC_INTER_E, 1,
+				      "VDPU_REG_DEC_CTRL0_PIC_INTER_E");
+
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_STRENDIAN_E, 1,
+			      "VDPU_REG_CONFIG_DEC_STRENDIAN_E");
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_INSWAP32_E, 1,
+			      "VDPU_REG_CONFIG_DEC_INSWAP32_E");
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_STRSWAP32_E, 1,
+			      "VDPU_REG_CONFIG_DEC_STRSWAP32_E");
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_OUTSWAP32_E, 1,
+			      "VDPU_REG_CONFIG_DEC_OUTSWAP32_E");
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_IN_ENDIAN, 1,
+			      "VDPU_REG_CONFIG_DEC_IN_ENDIAN");
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_OUT_ENDIAN, 1,
+			      "VDPU_REG_CONFIG_DEC_OUT_ENDIAN");
+
+	vp8d_write_regs_value(VDPU_REG_CONFIG_DEC_MAX_BURST, 16,
+			      "VDPU_REG_CONFIG_DEC_MAX_BURST");
+
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL0_DEC_MODE, 10,
+			      "VDPU_REG_DEC_CTRL0_DEC_MODE");
+
+	if (!(hdr->flags & V4L2_VP8_FRAME_HDR_FLAG_MB_NO_SKIP_COEFF))
+		vp8d_write_regs_value(VDPU_REG_DEC_CTRL0_SKIP_MODE, 1,
+				      "VDPU_REG_DEC_CTRL0_SKIP_MODE");
+	if (hdr->lf_hdr.level == 0)
+		vp8d_write_regs_value(VDPU_REG_DEC_CTRL0_FILTERING_DIS, 1,
+				      "VDPU_REG_DEC_CTRL0_FILTERING_DIS");
+
+	/* frame dimensions */
+	mb_width = MB_WIDTH(width);
+	mb_height = MB_HEIGHT(height);
+	vp8d_write_regs_value(VDPU_REG_DEC_PIC_MB_WIDTH, mb_width,
+			      "VDPU_REG_DEC_PIC_MB_WIDTH");
+	vp8d_write_regs_value(VDPU_REG_DEC_PIC_MB_HEIGHT_P, mb_height,
+			      "VDPU_REG_DEC_PIC_MB_HEIGHT_P");
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT, (mb_width >> 9),
+			      "VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT");
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT, (mb_height >> 8),
+			      "VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT");
+
+	/* bool decode info */
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE,
+			      hdr->bool_dec_range,
+			      "VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE");
+	vp8d_write_regs_value(VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE,
+			      hdr->bool_dec_value,
+			      "VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE");
+
+	if (hdr->version != 3)
+		vp8d_write_regs_value(VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT, 1,
+				      "VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT");
+	if (hdr->version & 0x3)
+		vp8d_write_regs_value(VDPU_REG_DEC_CTRL4_BILIN_MC_E, 1,
+				      "VDPU_REG_DEC_CTRL4_BILIN_MC_E");
+
+	rockchip_vp8d_cfg_lf(ctx);
+	rockchip_vp8d_cfg_qp(ctx);
+	rockchip_vp8d_cfg_parts(ctx);
+	rockchip_vp8d_cfg_tap(ctx);
+	rockchip_vp8d_cfg_ref(ctx);
+	rockchip_vp8d_cfg_buffers(ctx);
+
+	reg = (rk_regs_value[0]
+	       & RK_GET_REG_BITS_MASK(0)) << RK_GET_REG_BITS_OFFSET(0);
+	reg_base = RK_GET_REG_BASE(0);
+
+	for (i = 1; i <= VDPU_REG_BEFORE_ENABLE; i++) {
+		cur_reg = (rk_regs_value[i]
+			   & RK_GET_REG_BITS_MASK(i))
+				<< RK_GET_REG_BITS_OFFSET(i);
+
+		if ((reg_base != 0)
+		    && (reg_base != RK_GET_REG_BASE(i)
+			|| i == VDPU_REG_BEFORE_ENABLE)) {
+			reg |= vdpu_read(vpu, reg_base);
+			vdpu_write_relaxed(vpu, reg, reg_base);
+			reg = cur_reg;
+		} else
+			reg |= cur_reg;
+
+		reg_base = RK_GET_REG_BASE(i);
+	}
+	schedule_delayed_work(&vpu->watchdog_work, msecs_to_jiffies(2000));
+
+	reg = vdpu_read(vpu, RK_GET_REG_BASE(VDPU_REG_INTERRUPT_DEC_E));
+	reg &= ~(RK_GET_REG_BITS_MASK(VDPU_REG_INTERRUPT_DEC_E)
+		 << RK_GET_REG_BITS_OFFSET(VDPU_REG_INTERRUPT_DEC_E));
+	reg |= (((1) & RK_GET_REG_BITS_MASK(VDPU_REG_INTERRUPT_DEC_E))
+		<< RK_GET_REG_BITS_OFFSET(VDPU_REG_INTERRUPT_DEC_E));
+	vdpu_write_relaxed(vpu, reg, RK_GET_REG_BASE(VDPU_REG_INTERRUPT_DEC_E));
+
+	vpu_debug_leave();
+}
+
+int rockchip_vdpu_irq(int irq, struct rockchip_vpu_dev *vpu)
+{
+	u32 mask;
+	u32 status = vdpu_read(vpu,
+			       RK_GET_REG_BASE(VDPU_REG_INTERRUPT_DEC_IRQ));
+
+	vdpu_write(vpu, 0, RK_GET_REG_BASE(VDPU_REG_INTERRUPT_DEC_IRQ));
+
+	vpu_debug(3, "vdpu_irq status: %08x\n", status);
+
+	mask = RK_GET_REG_BITS_MASK(VDPU_REG_INTERRUPT_DEC_IRQ);
+	mask = mask << RK_GET_REG_BITS_OFFSET(VDPU_REG_INTERRUPT_DEC_IRQ);
+	if (status & mask) {
+		vdpu_write(vpu, 0,
+			   RK_GET_REG_BASE(VDPU_REG_CONFIG_DEC_MAX_BURST));
+		return 0;
+	}
+
+	return -1;
+}
+
+/*
+ * Initialization/clean-up.
+ */
+
+void rockchip_vpu_dec_reset(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_dev *vpu = ctx->dev;
+	u32 mask;
+
+	mask = RK_GET_REG_BITS_MASK(VDPU_REG_INTERRUPT_DEC_IRQ_DIS);
+	mask = mask << RK_GET_REG_BITS_OFFSET(VDPU_REG_INTERRUPT_DEC_IRQ_DIS);
+	vdpu_write(vpu, mask, RK_GET_REG_BASE(VDPU_REG_INTERRUPT_DEC_IRQ_DIS));
+	vdpu_write(vpu, 0, RK_GET_REG_BASE(VDPU_REG_CONFIG_DEC_TIMEOUT_E));
+}
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h b/drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
new file mode 100644
index 0000000..dc01554
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
@@ -0,0 +1,1594 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2015 Rockchip Electronics Co., Ltd.
+ *      Alpha Lin <alpha.lin@rock-chips.com>
+ *
+ * * Copyright (C) 2016 Rockchip Electronics Co., Ltd.
+ *      Jung Zhao <jung.zhao@rock-chips.com>
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
+#ifndef ROCKCHIP_VP8D_REGS_H
+#define ROCKCHIP_VP8D_REGS_H
+
+enum VP8_REGS {
+	VDPU_REG_CONFIG_DEC_TIMEOUT_E,
+	VDPU_REG_CONFIG_DEC_CLK_GATE_E,
+	VDPU_REG_DEC_CTRL0_PIC_INTER_E,
+	VDPU_REG_CONFIG_DEC_STRENDIAN_E,
+	VDPU_REG_CONFIG_DEC_INSWAP32_E,
+	VDPU_REG_CONFIG_DEC_STRSWAP32_E,
+	VDPU_REG_CONFIG_DEC_OUTSWAP32_E,
+	VDPU_REG_CONFIG_DEC_IN_ENDIAN,
+	VDPU_REG_CONFIG_DEC_OUT_ENDIAN,
+	VDPU_REG_CONFIG_DEC_MAX_BURST,
+	VDPU_REG_DEC_CTRL0_DEC_MODE,
+	VDPU_REG_DEC_CTRL0_SKIP_MODE,
+	VDPU_REG_DEC_CTRL0_FILTERING_DIS,
+	VDPU_REG_DEC_PIC_MB_WIDTH,
+	VDPU_REG_DEC_PIC_MB_HEIGHT_P,
+	VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT,
+	VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT,
+	VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE,
+	VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE,
+	VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT,
+	VDPU_REG_DEC_CTRL4_BILIN_MC_E,
+	VDPU_REG_REF_PIC_LF_LEVEL_0,
+	VDPU_REG_REF_PIC_LF_LEVEL_1,
+	VDPU_REG_REF_PIC_LF_LEVEL_2,
+	VDPU_REG_REF_PIC_LF_LEVEL_3,
+	VDPU_REG_REF_PIC_FILT_SHARPNESS,
+	VDPU_REG_REF_PIC_FILT_TYPE_E,
+	VDPU_REG_FILT_MB_ADJ_0,
+	VDPU_REG_FILT_MB_ADJ_1,
+	VDPU_REG_FILT_MB_ADJ_2,
+	VDPU_REG_FILT_MB_ADJ_3,
+	VDPU_REG_REF_PIC_ADJ_0,
+	VDPU_REG_REF_PIC_ADJ_1,
+	VDPU_REG_REF_PIC_ADJ_2,
+	VDPU_REG_REF_PIC_ADJ_3,
+	VDPU_REG_REF_PIC_QUANT_0,
+	VDPU_REG_REF_PIC_QUANT_1,
+	VDPU_REG_REF_PIC_QUANT_2,
+	VDPU_REG_REF_PIC_QUANT_3,
+	VDPU_REG_REF_PIC_QUANT_DELTA_0,
+	VDPU_REG_REF_PIC_QUANT_DELTA_1,
+	VDPU_REG_REF_PIC_QUANT_DELTA_2,
+	VDPU_REG_REF_PIC_QUANT_DELTA_3,
+	VDPU_REG_REF_PIC_QUANT_DELTA_4,
+	VDPU_REG_VP8_ADDR_CTRL_PART,
+	VDPU_REG_DEC_CTRL2_STRM1_START_BIT,
+	VDPU_REG_DEC_CTRL6_STREAM1_LEN,
+	VDPU_REG_DEC_CTRL6_COEFFS_PART_AM,
+	VDPU_REG_DEC_CTRL3_STREAM_LEN,
+	VDPU_REG_ADDR_STR,
+	VDPU_REG_VP8_DCT_BASE_0,
+	VDPU_REG_VP8_DCT_BASE_1,
+	VDPU_REG_VP8_DCT_BASE_2,
+	VDPU_REG_VP8_DCT_BASE_3,
+	VDPU_REG_VP8_DCT_BASE_4,
+	VDPU_REG_VP8_DCT_BASE_5,
+	VDPU_REG_VP8_DCT_BASE_6,
+	VDPU_REG_DEC_CTRL2_STRM_START_BIT,
+	VDPU_REG_DEC_CTRL4_DCT1_START_BIT,
+	VDPU_REG_DEC_CTRL4_DCT2_START_BIT,
+	VDPU_REG_DEC_CTRL7_DCT3_START_BIT,
+	VDPU_REG_DEC_CTRL7_DCT4_START_BIT,
+	VDPU_REG_DEC_CTRL7_DCT5_START_BIT,
+	VDPU_REG_DEC_CTRL7_DCT6_START_BIT,
+	VDPU_REG_DEC_CTRL7_DCT7_START_BIT,
+	VDPU_REG_PRED_FLT_NONE_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_0_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_0_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_0_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_0_3,
+	VDPU_REG_PRED_FLT_NONE_1,
+	VDPU_REG_PRED_FLT_NONE_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_1_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_1_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_1_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_1_3,
+	VDPU_REG_PRED_FLT_NONE_3,
+	VDPU_REG_BD_REF_PIC_PRED_TAP_2_M1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_2_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_2_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_2_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_2_3,
+	VDPU_REG_BD_REF_PIC_PRED_TAP_2_4,
+	VDPU_REG_PRED_FLT_NONE_4,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_3_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_3_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_3_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_3_3,
+	VDPU_REG_PRED_FLT_NONE_5,
+	VDPU_REG_BD_REF_PIC_PRED_TAP_4_M1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_4_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_4_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_4_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_4_3,
+	VDPU_REG_BD_REF_PIC_PRED_TAP_4_4,
+	VDPU_REG_PRED_FLT_NONE_6,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_5_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_5_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_5_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_5_3,
+	VDPU_REG_PRED_FLT_NONE_7,
+	VDPU_REG_BD_REF_PIC_PRED_TAP_6_M1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_6_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_6_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_6_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_6_3,
+	VDPU_REG_BD_REF_PIC_PRED_TAP_6_4,
+	VDPU_REG_PRED_FLT_NONE_8,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_7_0,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_7_1,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_7_2,
+	VDPU_REG_PRED_FLT_PRED_BC_TAP_7_3,
+	VDPU_REG_PRED_FLT_NONE_9,
+	VDPU_REG_VP8_ADDR_REF0,
+	VDPU_REG_VP8_ADDR_REF2_5_0,
+	VDPU_REG_VP8_GREF_SIGN_BIAS_0,
+	VDPU_REG_VP8_ADDR_REF2_5_1,
+	VDPU_REG_VP8_AREF_SIGN_BIAS_1,
+	VDPU_REG_ADDR_QTABLE,
+	VDPU_REG_FWD_PIC1_SEGMENT_BASE,
+	VDPU_REG_FWD_PIC1_SEGMENT_E,
+	VDPU_REG_FWD_PIC1_SEGMENT_UPD_E,
+	VDPU_REG_ADDR_DST,
+	VDPU_REG_INTERRUPT_DEC_IRQ,
+	VDPU_REG_INTERRUPT_DEC_IRQ_DIS,
+	VDPU_REG_BEFORE_ENABLE,
+	VDPU_REG_INTERRUPT_DEC_E,
+	VDPU_REG_LAST,
+};
+
+/* {register_base, mask, bit_offset } */
+u32 rk3229_vp8d_regs_table[][3] = {
+	{ 0, 0, 0 },
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_REF_BUF_CTRL2_REFBU2_PICID */ 0x1f,
+		25
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_REF_BUF_CTRL2_REFBU2_THR */ 0xfff,
+		13
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_CONFIG_TILED_MODE_LSB */ 0x01,
+		12
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_CONFIG_DEC_ADV_PRE_DIS */ 0x01,
+		11
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_CONFIG_DEC_SCMD_DIS */ 0x01,
+		10
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_DEC_CTRL0_SKIP_MODE */ 0x01,
+		9
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_DEC_CTRL0_FILTERING_DIS */ 0x01,
+		8
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0 */ 0x0c8,
+		/* VDPU_REG_DEC_CTRL0_PIC_FIXED_QUANT */ 0x01,
+		7
+	},
+	{
+		/* VDPU_REG_STREAM_LEN */ 0x0cc,
+		/* VDPU_REG_DEC_CTRL3_INIT_QP */ 0x3f,
+		25
+	},
+	{
+		/* VDPU_REG_STREAM_LEN */ 0x0cc,
+		/* VDPU_REG_DEC_STREAM_LEN_HI */ 0x01,
+		24
+	},
+	{
+		/* VDPU_REG_STREAM_LEN */ 0x0cc,
+		/* VDPU_REG_DEC_CTRL3_STREAM_LEN */ 0xffffff,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_FORMAT */ 0x0d4,
+		/* VDPU_REG_DEC_CTRL0_DEC_MODE */ 0x0f,
+		0
+	},
+	{
+		/* VDPU_REG_DATA_ENDIAN */ 0x0d8,
+		/* VDPU_REG_CONFIG_DEC_STRENDIAN_E */ 0x01,
+		5
+	},
+	{
+		/* VDPU_REG_DATA_ENDIAN */ 0x0d8,
+		/* VDPU_REG_CONFIG_DEC_STRSWAP32_E */ 0x01,
+		4
+	},
+	{
+		/* VDPU_REG_DATA_ENDIAN */ 0x0d8,
+		/* VDPU_REG_CONFIG_DEC_OUTSWAP32_E */ 0x01,
+		3
+	},
+	{
+		/* VDPU_REG_DATA_ENDIAN */ 0x0d8,
+		/* VDPU_REG_CONFIG_DEC_INSWAP32_E */ 0x01,
+		2
+	},
+	{
+		/* VDPU_REG_DATA_ENDIAN */ 0x0d8,
+		/* VDPU_REG_CONFIG_DEC_OUT_ENDIAN */ 0x01,
+		1
+	},
+	{
+		/* VDPU_REG_DATA_ENDIAN */ 0x0d8,
+		/* VDPU_REG_CONFIG_DEC_IN_ENDIAN */ 0x01,
+		0
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_TIMEOUT */ 0x01,
+		13
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_ERROR_INT */ 0x01,
+		12
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_PIC_INF */ 0x01,
+		10
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_SLICE_INT */ 0x01,
+		9
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_ASO_INT */ 0x01,
+		8
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_BUFFER_INT */ 0x01,
+		6
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_BUS_INT */ 0x01,
+		5
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_RDY_INT */ 0x01,
+		4
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_IRQ_DIS */ 0x01,
+		1
+	},
+	{
+		/* VDPU_REG_INTERRUPT */ 0x0dc,
+		/* VDPU_REG_INTERRUPT_DEC_IRQ */ 0x01,
+		0
+	},
+	{
+		/* VDPU_REG_AXI_CTRL */ 0x0e0,
+		/* VDPU_REG_AXI_DEC_SEL */ 0x01,
+		23
+	},
+	{
+		/* VDPU_REG_AXI_CTRL */ 0x0e0,
+		/* VDPU_REG_CONFIG_DEC_DATA_DISC_E */ 0x01,
+		22
+	},
+	{
+		/* VDPU_REG_AXI_CTRL */ 0x0e0,
+		/* VDPU_REG_PARAL_BUS_E */ 0x01,
+		21
+	},
+	{
+		/* VDPU_REG_AXI_CTRL */ 0x0e0,
+		/* VDPU_REG_CONFIG_DEC_MAX_BURST */ 0x1f,
+		16
+	},
+	{
+		/* VDPU_REG_AXI_CTRL */ 0x0e0,
+		/* VDPU_REG_DEC_CTRL0_DEC_AXI_WR_ID */ 0xff,
+		8
+	},
+	{
+		/* VDPU_REG_AXI_CTRL */ 0x0e0,
+		/* VDPU_REG_CONFIG_DEC_AXI_RD_ID */ 0xff,
+		0
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_AHB_HLOCK_E */ 0x01,
+		31
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_CACHE_E */ 0x01,
+		29
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_PREFETCH_SINGLE_CHANNEL_E */ 0x01,
+		28
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_INTRA_3_CYCLE_ENHANCE */ 0x01,
+		27
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_INTRA_DOUBLE_SPEED */ 0x01,
+		26
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_INTER_DOUBLE_SPEED */ 0x01,
+		25
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL3_START_CODE_E */ 0x01,
+		22
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL3_CH_8PIX_ILEAV_E */ 0x01,
+		21
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_RLC_MODE_E */ 0x01,
+		20
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_DIVX3_E */ 0x01,
+		19
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PJPEG_E */ 0x01,
+		18
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PIC_INTERLACE_E */ 0x01,
+		17
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PIC_FIELDMODE_E */ 0x01,
+		16
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PIC_B_E */ 0x01,
+		15
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PIC_INTER_E */ 0x01,
+		14
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PIC_TOPFIELD_E */ 0x01,
+		13
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_FWD_INTERLACE_E */ 0x01,
+		12
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_SORENSON_E */ 0x01,
+		11
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_WRITE_MVS_E */ 0x01,
+		10
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_REF_TOPFIELD_E */ 0x01,
+		9
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_REFTOPFIRST_E */ 0x01,
+		8
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_SEQ_MBAFF_E */ 0x01,
+		7
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_PICORD_COUNT_E */ 0x01,
+		6
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_CONFIG_DEC_TIMEOUT_E */ 0x01,
+		5
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_CONFIG_DEC_CLK_GATE_E */ 0x01,
+		4
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_DEC_CTRL0_DEC_OUT_DIS */ 0x01,
+		2
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_REF_BUF_CTRL2_REFBU2_BUF_E */ 0x01,
+		1
+	},
+	{
+		/* VDPU_REG_EN_FLAGS */ 0x0e4,
+		/* VDPU_REG_INTERRUPT_DEC_E */ 0x01,
+		0
+	},
+	{
+		/* VDPU_REG_PRED_FLT */ 0x0ec,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_0 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT */ 0x0ec,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_1 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT */ 0x0ec,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_2 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_ADDR_QTABLE */ 0x0f4,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_ADDR_DST */ 0x0fc,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_ADDR_STR */ 0x100,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_PIC_MB_SIZE */ 0x1e0,
+		/* VDPU_REG_DEC_PIC_MB_WIDTH */ 0x1ff,
+		23
+	},
+	{
+		/* VDPU_REG_VP8_PIC_MB_SIZE */ 0x1e0,
+		/* VDPU_REG_DEC_MB_WIDTH_OFF */ 0x0f,
+		19
+	},
+	{
+		/* VDPU_REG_VP8_PIC_MB_SIZE */ 0x1e0,
+		/* VDPU_REG_DEC_PIC_MB_HEIGHT_P */ 0xff,
+		11
+	},
+	{
+		/* VDPU_REG_VP8_PIC_MB_SIZE */ 0x1e0,
+		/* VDPU_REG_DEC_MB_HEIGHT_OFF */ 0x0f,
+		7
+	},
+	{
+		/* VDPU_REG_VP8_PIC_MB_SIZE */ 0x1e0,
+		/* VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT */ 0x07,
+		3
+	},
+	{
+		/* VDPU_REG_VP8_PIC_MB_SIZE */ 0x1e0,
+		/* VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT */ 0x07,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT */ 0x1e4,
+		/* VDPU_REG_DEC_CTRL4_DCT1_START_BIT */ 0x3f,
+		26
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT */ 0x1e4,
+		/* VDPU_REG_DEC_CTRL4_DCT2_START_BIT */ 0x3f,
+		20
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT */ 0x1e4,
+		/* VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT */ 0x01,
+		13
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT */ 0x1e4,
+		/* VDPU_REG_DEC_CTRL4_BILIN_MC_E */ 0x01,
+		12
+	},
+	{
+		/* VDPU_REG_VP8_CTRL0 */ 0x1e8,
+		/* VDPU_REG_DEC_CTRL2_STRM_START_BIT */ 0x3f,
+		26
+	},
+	{
+		/* VDPU_REG_VP8_CTRL0 */ 0x1e8,
+		/* VDPU_REG_DEC_CTRL2_STRM1_START_BIT */ 0x3f,
+		18
+	},
+	{
+		/* VDPU_REG_VP8_CTRL0 */ 0x1e8,
+		/* VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE */ 0xff,
+		8
+	},
+	{
+		/* VDPU_REG_VP8_CTRL0 */ 0x1e8,
+		/* VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE */ 0xff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_DATA_VAL */ 0x1f0,
+		/* VDPU_REG_DEC_CTRL6_COEFFS_PART_AM */ 0x0f,
+		24
+	},
+	{
+		/* VDPU_REG_VP8_DATA_VAL */ 0x1f0,
+		/* VDPU_REG_DEC_CTRL6_STREAM1_LEN */ 0xffffff,
+		0
+	},
+	{
+		/* VDPU_REG_PRED_FLT7 */ 0x1f4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_1 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT7 */ 0x1f4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_2 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT7 */ 0x1f4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_3 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT8 */ 0x1f8,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_0 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT8 */ 0x1f8,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_1 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT8 */ 0x1f8,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_2 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT9 */ 0x1fc,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_3 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT9 */ 0x1fc,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_0 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT9 */ 0x1fc,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_1 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_2 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_3 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_2_M1 */ 0x03,
+		10
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_2_4 */ 0x03,
+		8
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_4_M1 */ 0x03,
+		6
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_4_4 */ 0x03,
+		4
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_6_M1 */ 0x03,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT10 */ 0x200,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_6_4 */ 0x03,
+		0
+	},
+	{
+		/* VDPU_REG_FILTER_LEVEL */ 0x204,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_0 */ 0x3f,
+		18
+	},
+	{
+		/* VDPU_REG_FILTER_LEVEL */ 0x204,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_1 */ 0x3f,
+		12
+	},
+	{
+		/* VDPU_REG_FILTER_LEVEL */ 0x204,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_2 */ 0x3f,
+		6
+	},
+	{
+		/* VDPU_REG_FILTER_LEVEL */ 0x204,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_3 */ 0x3f,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER0 */ 0x208,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_0 */ 0x1f,
+		27
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER0 */ 0x208,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_1 */ 0x1f,
+		22
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER0 */ 0x208,
+		/* VDPU_REG_REF_PIC_QUANT_0 */ 0x7ff,
+		11
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER0 */ 0x208,
+		/* VDPU_REG_REF_PIC_QUANT_1 */ 0x7ff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_REF0 */ 0x20c,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_FILTER_MB_ADJ */ 0x210,
+		/* VDPU_REG_REF_PIC_FILT_TYPE_E */ 0x01,
+		31
+	},
+	{
+		/* VDPU_REG_FILTER_MB_ADJ */ 0x210,
+		/* VDPU_REG_REF_PIC_FILT_SHARPNESS */ 0x07,
+		28
+	},
+	{
+		/* VDPU_REG_FILTER_MB_ADJ */ 0x210,
+		/* VDPU_REG_FILT_MB_ADJ_0 */ 0x7f,
+		21
+	},
+	{
+		/* VDPU_REG_FILTER_MB_ADJ */ 0x210,
+		/* VDPU_REG_FILT_MB_ADJ_1 */ 0x7f,
+		14
+	},
+	{
+		/* VDPU_REG_FILTER_MB_ADJ */ 0x210,
+		/* VDPU_REG_FILT_MB_ADJ_2 */ 0x7f,
+		7
+	},
+	{
+		/* VDPU_REG_FILTER_MB_ADJ */ 0x210,
+		/* VDPU_REG_FILT_MB_ADJ_3 */ 0x7f,
+		0
+	},
+	{
+		/* VDPU_REG_FILTER_REF_ADJ */ 0x214,
+		/* VDPU_REG_REF_PIC_ADJ_0 */ 0x7f,
+		21
+	},
+	{
+		/* VDPU_REG_FILTER_REF_ADJ */ 0x214,
+		/* VDPU_REG_REF_PIC_ADJ_1 */ 0x7f,
+		14
+	},
+	{
+		/* VDPU_REG_FILTER_REF_ADJ */ 0x214,
+		/* VDPU_REG_REF_PIC_ADJ_2 */ 0x7f,
+		7
+	},
+	{
+		/* VDPU_REG_FILTER_REF_ADJ */ 0x214,
+		/* VDPU_REG_REF_PIC_ADJ_3 */ 0x7f,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_REF2_5(2) */ 0x220,
+		/* VDPU_REG_VP8_ADDR_REF2_5_2 */ 0xffffffff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_REF2_5(2) */ 0x220,
+		/* VDPU_REG_VP8_GREF_SIGN_BIAS_2 */ 0x01, 0},
+	{
+		/* VDPU_REG_VP8_ADDR_REF2_5(2) */ 0x220,
+		/* VDPU_REG_VP8_AREF_SIGN_BIAS_2 */ 0x01, 0},
+	{
+		/* VDPU_REG_VP8_ADDR_REF2_5(3) */ 0x224,
+		/* VDPU_REG_VP8_ADDR_REF2_5_3 */ 0xffffffff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_REF2_5(3) */ 0x224,
+		/* VDPU_REG_VP8_GREF_SIGN_BIAS_3 */ 0x01, 0},
+	{
+		/* VDPU_REG_VP8_ADDR_REF2_5(3) */ 0x224,
+		/* VDPU_REG_VP8_AREF_SIGN_BIAS_3 */ 0x01, 0},
+	{
+		/* VDPU_REG_VP8_DCT_BASE0 */ 0x230,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE1 */ 0x234,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE2 */ 0x238,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE3 */ 0x23C,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE4 */ 0x240,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_CTRL_PART */ 0x244,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE6 */ 0x248,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_REF1 */ 0x250,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_SEGMENT_VAL */ 0x254,
+		/* VDPU_REG_FWD_PIC1_SEGMENT_BASE */ 0xffffffff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_SEGMENT_VAL */ 0x254,
+		/* VDPU_REG_FWD_PIC1_SEGMENT_UPD_E */ 0x01,
+		1
+	},
+	{
+		/* VDPU_REG_VP8_SEGMENT_VAL */ 0x254,
+		/* VDPU_REG_FWD_PIC1_SEGMENT_E */ 0x01,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT2 */ 0x258,
+		/* VDPU_REG_DEC_CTRL7_DCT3_START_BIT */ 0x3f,
+		24
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT2 */ 0x258,
+		/* VDPU_REG_DEC_CTRL7_DCT4_START_BIT */ 0x3f,
+		18
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT2 */ 0x258,
+		/* VDPU_REG_DEC_CTRL7_DCT5_START_BIT */ 0x3f,
+		12
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT2 */ 0x258,
+		/* VDPU_REG_DEC_CTRL7_DCT6_START_BIT */ 0x3f,
+		6
+	},
+	{
+		/* VDPU_REG_VP8_DCT_START_BIT2 */ 0x258,
+		/* VDPU_REG_DEC_CTRL7_DCT7_START_BIT */ 0x3f,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER1 */ 0x25c,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_2 */ 0x1f,
+		27
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER1 */ 0x25c,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_3 */ 0x1f,
+		22
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER1 */ 0x25c,
+		/* VDPU_REG_REF_PIC_QUANT_2 */ 0x7ff,
+		11
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER1 */ 0x25c,
+		/* VDPU_REG_REF_PIC_QUANT_3 */ 0x7ff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER2 */ 0x260,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_4 */ 0x1f,
+		27
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER2 */ 0x260,
+		/* VDPU_REG_REF_PIC_QUANT_4 */ 0x7ff,
+		11
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER2 */ 0x260,
+		/* VDPU_REG_REF_PIC_QUANT_5 */ 0x7ff,
+		0
+	},
+	{
+		/* VDPU_REG_PRED_FLT1 */ 0x264,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_3 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT1 */ 0x264,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_0 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT1 */ 0x264,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_1 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT2 */ 0x268,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_2 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT2 */ 0x268,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_3 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT2 */ 0x268,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_0 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT3 */ 0x26c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_1 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT3 */ 0x26c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_2 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT3 */ 0x26c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_3 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT4 */ 0x270,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_0 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT4 */ 0x270,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_1 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT4 */ 0x270,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_2 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT5 */ 0x274,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_3 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT5 */ 0x274,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_0 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT5 */ 0x274,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_1 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_PRED_FLT6 */ 0x278,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_2 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT6 */ 0x278,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_3 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT6 */ 0x278,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_0 */ 0x3ff,
+		2
+	},
+	{ 0, 0, 0 },
+};
+
+u32 rk3288_vp8d_regs_table[][3] = {
+	{ 0, 0, 0 },
+	{
+		/* VDPU_REG_INTERRUPT	*/ 0x004,
+		/* VDPU_REG_INTERRUPT_DEC_IRQ */ 0x01,
+		8
+	},
+	{
+		/* VDPU_REG_INTERRUPT	*/ 0x004,
+		/* VDPU_REG_INTERRUPT_DEC_IRQ_DIS */ 0x01,
+		4
+	},
+	{
+		/* VDPU_REG_INTERRUPT	*/ 0x004,
+		/* VDPU_REG_INTERRUPT_DEC_E */ 0x01,
+		0
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_TIMEOUT_E */ 0x01,
+		23
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_STRSWAP32_E */ 0x01,
+		22
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_STRENDIAN_E */ 0x01,
+		21
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_INSWAP32_E */ 0x01,
+		20
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_OUTSWAP32_E */ 0x01,
+		19
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_CLK_GATE_E */ 0x01,
+		10
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_IN_ENDIAN */ 0x01,
+		9
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_OUT_ENDIAN */ 0x01,
+		8
+	},
+	{
+		/* VDPU_REG_CONFIG	*/ 0x008,
+		/* VDPU_REG_CONFIG_DEC_MAX_BURST */ 0x1f,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0	*/ 0x00c,
+		/* VDPU_REG_DEC_CTRL0_DEC_MODE */ 0x0f,
+		28
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0	*/ 0x00c,
+		/* VDPU_REG_DEC_CTRL0_SKIP_MODE */ 0x01,
+		26
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0	*/ 0x00c,
+		/* VDPU_REG_DEC_CTRL0_PIC_INTER_E */ 0x01,
+		20
+	},
+	{
+		/* VDPU_REG_DEC_CTRL0	*/ 0x00c,
+		/* VDPU_REG_DEC_CTRL0_FILTERING_DIS */ 0x01,
+		14
+	},
+	{
+		/* VDPU_REG_DEC_CTRL1	*/ 0x010,
+		/* VDPU_REG_DEC_PIC_MB_WIDTH */ 0x1ff,
+		23
+	},
+	{
+		/* VDPU_REG_DEC_CTRL1	*/ 0x010,
+		/* VDPU_REG_DEC_PIC_MB_HEIGHT_P */ 0xff,
+		11
+	},
+	{
+		/* VDPU_REG_DEC_CTRL1	*/ 0x010,
+		/* VDPU_REG_DEC_CTRL1_PIC_MB_W_EXT */ 0x07,
+		3
+	},
+	{
+		/* VDPU_REG_DEC_CTRL1	*/ 0x010,
+		/* VDPU_REG_DEC_CTRL1_PIC_MB_H_EXT */ 0x07,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_CTRL2	*/ 0x014,
+		/* VDPU_REG_DEC_CTRL2_STRM_START_BIT */ 0x3f,
+		26
+	},
+	{
+		/* VDPU_REG_DEC_CTRL2	*/ 0x014,
+		/* VDPU_REG_DEC_CTRL2_STRM1_START_BIT */ 0x3f,
+		18
+	},
+	{
+		/* VDPU_REG_DEC_CTRL2	*/ 0x014,
+		/* VDPU_REG_DEC_CTRL2_BOOLEAN_VALUE */ 0xff,
+		8
+	},
+	{
+		/* VDPU_REG_DEC_CTRL2	*/ 0x014,
+		/* VDPU_REG_DEC_CTRL2_BOOLEAN_RANGE */ 0xff,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_CTRL3	*/ 0x018,
+		/* VDPU_REG_DEC_CTRL3_STREAM_LEN */ 0xffffff,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_CTRL4	*/ 0x01c,
+		/* VDPU_REG_DEC_CTRL4_DCT1_START_BIT */ 0x3f,
+		26
+	},
+	{
+		/* VDPU_REG_DEC_CTRL4	*/ 0x01c,
+		/* VDPU_REG_DEC_CTRL4_DCT2_START_BIT */ 0x3f,
+		20
+	},
+	{
+		/* VDPU_REG_DEC_CTRL4	*/ 0x01c,
+		/* VDPU_REG_DEC_CTRL4_VC1_HEIGHT_EXT */ 0x01,
+		13
+	},
+	{
+		/* VDPU_REG_DEC_CTRL4	*/ 0x01c,
+		/* VDPU_REG_DEC_CTRL4_BILIN_MC_E */ 0x01,
+		12
+	},
+	{
+		/* VDPU_REG_DEC_CTRL7	*/ 0x02c,
+		/* VDPU_REG_DEC_CTRL7_DCT3_START_BIT */ 0x3f,
+		24
+	},
+	{
+		/* VDPU_REG_DEC_CTRL7	*/ 0x02c,
+		/* VDPU_REG_DEC_CTRL7_DCT4_START_BIT */ 0x3f,
+		18
+	},
+	{
+		/* VDPU_REG_DEC_CTRL7	*/ 0x02c,
+		/* VDPU_REG_DEC_CTRL7_DCT5_START_BIT */ 0x3f,
+		12
+	},
+	{
+		/* VDPU_REG_DEC_CTRL7	*/ 0x02c,
+		/* VDPU_REG_DEC_CTRL7_DCT6_START_BIT */ 0x3f,
+		6
+	},
+	{
+		/* VDPU_REG_DEC_CTRL7	*/ 0x02c,
+		/* VDPU_REG_DEC_CTRL7_DCT7_START_BIT */ 0x3f,
+		0
+	},
+	{
+		/* VDPU_REG_ADDR_STR	*/ 0x030,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_ADDR_DST	*/ 0x034,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_ADDR_REF(0) */ 0x038,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_ADDR_REF(4) */ 0x048,
+		/* VDPU_REG_VP8_ADDR_REF2_5_2 */ 0xffffffff,
+		0
+	},
+	{
+		/* VDPU_REG_ADDR_REF(4) */ 0x048,
+		/* VDPU_REG_VP8_GREF_SIGN_BIAS_2 */ 0x01, 1},
+	{
+		/* VDPU_REG_ADDR_REF(4) */ 0x048,
+		/* VDPU_REG_VP8_AREF_SIGN_BIAS_2 */ 0x01, 0},
+	{
+		/* VDPU_REG_ADDR_REF(5) */ 0x04c,
+		/* VDPU_REG_VP8_ADDR_REF2_5_3 */ 0xffffffff,
+		0
+	},
+	{
+		/* VDPU_REG_ADDR_REF(5) */ 0x04c,
+		/* VDPU_REG_VP8_GREF_SIGN_BIAS_3 */ 0x01, 1},
+	{
+		/* VDPU_REG_ADDR_REF(5) */ 0x04c,
+		/* VDPU_REG_VP8_AREF_SIGN_BIAS_3 */ 0x01, 0},
+	{
+		/* VDPU_REG_VP8_DCT_BASE0 */ 0x058,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE1 */ 0x05c,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE2 */ 0x060,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE3 */ 0x064,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE4 */ 0x068,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_ADDR_CTRL_PART */ 0x06c,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_VP8_DCT_BASE6 */ 0x070,
+		0xffffffff, 0
+	},
+	{
+		/* VDPU_REG_REF_PIC(2) */ 0x080,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_0 */ 0x3f,
+		18
+	},
+	{
+		/* VDPU_REG_REF_PIC(2) */ 0x080,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_1 */ 0x3f,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(2) */ 0x080,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_2 */ 0x3f,
+		6
+	},
+	{
+		/* VDPU_REG_REF_PIC(2) */ 0x080,
+		/* VDPU_REG_REF_PIC_LF_LEVEL_3 */ 0x3f,
+		0
+	},
+	{
+		/* VDPU_REG_REF_PIC(0) */ 0x078,
+		/* VDPU_REG_REF_PIC_FILT_TYPE_E */ 0x01,
+		31
+	},
+	{
+		/* VDPU_REG_REF_PIC(0) */ 0x078,
+		/* VDPU_REG_REF_PIC_FILT_SHARPNESS */ 0x07,
+		28
+	},
+	{
+		/* VDPU_REG_REF_PIC(0) */ 0x078,
+		/* VDPU_REG_FILT_MB_ADJ_0 */ 0x7f,
+		21
+	},
+	{
+		/* VDPU_REG_REF_PIC(0) */ 0x078,
+		/* VDPU_REG_FILT_MB_ADJ_1 */ 0x7f,
+		14
+	},
+	{
+		/* VDPU_REG_REF_PIC(0) */ 0x078,
+		/* VDPU_REG_FILT_MB_ADJ_2 */ 0x7f,
+		7
+	},
+	{
+		/* VDPU_REG_REF_PIC(0) */ 0x078,
+		/* VDPU_REG_FILT_MB_ADJ_3 */ 0x7f,
+		0
+	},
+	{
+		/* VDPU_REG_REF_PIC(1) */ 0x07c,
+		/* VDPU_REG_REF_PIC_ADJ_0 */ 0x7f,
+		21
+	},
+	{
+		/* VDPU_REG_REF_PIC(1) */ 0x07c,
+		/* VDPU_REG_REF_PIC_ADJ_1 */ 0x7f,
+		14
+	},
+	{
+		/* VDPU_REG_REF_PIC(1) */ 0x07c,
+		/* VDPU_REG_REF_PIC_ADJ_2 */ 0x7f,
+		7
+	},
+	{
+		/* VDPU_REG_REF_PIC(1) */ 0x07c,
+		/* VDPU_REG_REF_PIC_ADJ_3 */ 0x7f,
+		0
+	},
+	{
+		/* VDPU_REG_REF_PIC(3) */ 0x084,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_0 */ 0x1f,
+		27
+	},
+	{
+		/* VDPU_REG_REF_PIC(3) */ 0x084,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_1 */ 0x1f,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(3) */ 0x084,
+		/* VDPU_REG_REF_PIC_QUANT_0 */ 0x7ff,
+		11
+	},
+	{
+		/* VDPU_REG_REF_PIC(3) */ 0x084,
+		/* VDPU_REG_REF_PIC_QUANT_1 */ 0x7ff,
+		0
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(4) */ 0x0b8,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_2 */ 0x1f,
+		27
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(4) */ 0x0b8,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_3 */ 0x1f,
+		22
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(4) */ 0x0b8,
+		/* VDPU_REG_REF_PIC_QUANT_2 */ 0x7ff,
+		11
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(4) */ 0x0b8,
+		/* VDPU_REG_REF_PIC_QUANT_3 */ 0x7ff,
+		0
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER2 */ 0x0bc,
+		/* VDPU_REG_REF_PIC_QUANT_DELTA_4 */ 0x1f,
+		27
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER2 */ 0x0bc,
+		/* VDPU_REG_REF_PIC_QUANT_4 */ 0x7ff,
+		11
+	},
+	{
+		/* VDPU_REG_VP8_QUANTER2 */ 0x0bc,
+		/* VDPU_REG_REF_PIC_QUANT_5 */ 0x7ff,
+		0
+	},
+	{
+		/* VDPU_REG_FWD_PIC(0) */ 0x028,
+		/* VDPU_REG_FWD_PIC1_SEGMENT_BASE */ 0xffffffff,
+		0
+	},
+	{
+		/* VDPU_REG_FWD_PIC(0) */ 0x028,
+		/* VDPU_REG_FWD_PIC1_SEGMENT_UPD_E */ 0x01,
+		1
+	},
+	{
+		/* VDPU_REG_FWD_PIC(0) */ 0x028,
+		/* VDPU_REG_FWD_PIC1_SEGMENT_E */ 0x01,
+		0
+	},
+	{
+		/* VDPU_REG_PRED_FLT */ 0x0c4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_0 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_PRED_FLT */ 0x0c4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_1 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_PRED_FLT */ 0x0c4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_2 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_REF_PIC(4) */ 0x088,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_0_3 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(4) */ 0x088,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_0 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(4) */ 0x088,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_1 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_REF_PIC(5) */ 0x08c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_2 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(5) */ 0x08c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_1_3 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(5) */ 0x08c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_0 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_REF_PIC(6) */ 0x090,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_1 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(6) */ 0x090,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_2 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(6) */ 0x090,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_2_3 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_REF_PIC(7) */ 0x094,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_0 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(7) */ 0x094,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_1 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(7) */ 0x094,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_2 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_REF_PIC(8) */ 0x098,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_3_3 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(8) */ 0x098,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_0 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(8) */ 0x098,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_1 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_REF_PIC(9) */ 0x09c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_2 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_REF_PIC(9) */ 0x09c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_4_3 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_REF_PIC(9) */ 0x09c,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_0 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(0) */ 0x0a8,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_1 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(0) */ 0x0a8,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_2 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(0) */ 0x0a8,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_5_3 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(1) */ 0x0ac,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_0 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(1) */ 0x0ac,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_1 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(1) */ 0x0ac,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_2 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(2) */ 0x0b0,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_6_3 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(2) */ 0x0b0,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_0 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(2) */ 0x0b0,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_1 */ 0x3ff,
+		2
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_2 */ 0x3ff,
+		22
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_PRED_FLT_PRED_BC_TAP_7_3 */ 0x3ff,
+		12
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_2_M1 */ 0x03,
+		10
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_2_4 */ 0x03,
+		8
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_4_M1 */ 0x03,
+		6
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_4_4 */ 0x03,
+		4
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_6_M1 */ 0x03,
+		2
+	},
+	{
+		/* VDPU_REG_BD_REF_PIC(3) */ 0x0b4,
+		/* VDPU_REG_BD_REF_PIC_PRED_TAP_6_4 */ 0x03,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_CTRL6 */ 0x024,
+		/* VDPU_REG_DEC_CTRL6_STREAM1_LEN */ 0xffffff,
+		0
+	},
+	{
+		/* VDPU_REG_DEC_CTRL6 */ 0x024,
+		/* VDPU_REG_DEC_CTRL6_COEFFS_PART_AM */ 0x0f,
+		24
+	},
+	{
+		/* VDPU_REG_ADDR_QTABLE */ 0x0a0,
+		0xffffffff, 0
+	},
+	{ 0, 0, 0 },
+};
+
+u32 rk3229_regs_map[VDPU_REG_LAST + 1] = {
+	58, 59, 49, 13, 16, 14, 15, 18,
+	17, 32, 12, 6, 7, 69, 71, 73,
+	74, 82, 81, 77, 78, 102, 103, 104,
+	105, 112, 111, 113, 114, 115, 116, 117,
+	118, 119, 120, 108, 109, 145, 146, 106,
+	107, 143, 144, 147, 132, 80, 84, 83,
+	11, 68, 127, 128, 129, 130, 131, 132,
+	133, 79, 75, 76, 138, 139, 140, 141,
+	142, 0, 63, 64, 65, 150, 0, 0,
+	151, 152, 153, 154, 0, 96, 155, 156,
+	157, 158, 97, 0, 159, 160, 161, 162,
+	0, 98, 163, 164, 165, 166, 99, 0,
+	167, 85, 86, 87, 0, 100, 88, 89,
+	90, 91, 101, 0, 92, 93, 94, 95,
+	0, 110, 121, 122, 124, 126, 66, 135,
+	137, 136, 67, 28, 27, 0, 62, 0,
+};
+
+u32 rk3288_regs_map[VDPU_REG_LAST + 1] = {
+	4, 9, 15, 6, 7, 5, 8, 10,
+	11, 12, 13, 14, 16, 17, 18, 19,
+	20, 24, 23, 28, 29, 51, 52, 53,
+	54, 56, 55, 57, 58, 59, 60, 61,
+	62, 63, 64, 67, 68, 71, 72, 65,
+	66, 69, 70, 73, 49, 22, 117, 118,
+	25, 35, 44, 45, 46, 47, 48, 49,
+	50, 21, 26, 27, 30, 31, 32, 33,
+	34, 0, 79, 80, 81, 82, 0, 0,
+	83, 84, 85, 86, 0, 111, 87, 88,
+	89, 90, 112, 0, 91, 92, 93, 94,
+	0, 113, 95, 96, 97, 98, 114, 0,
+	99, 100, 101, 102, 0, 115, 103, 104,
+	105, 106, 116, 0, 107, 108, 109, 110,
+	0, 37, 38, 39, 41, 43, 119, 76,
+	78, 77, 36, 1, 2, 0, 3, 0,
+};
+
+#endif
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
index 33e9a89..916f549 100644
--- a/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
@@ -93,7 +93,16 @@ enum {
 	ROCKCHIP_VPU_DEC_CTRL_VP8_FRAME_HDR,
 };
 
-static struct rockchip_vpu_control controls[0];
+static struct rockchip_vpu_control controls[] = {
+	[ROCKCHIP_VPU_DEC_CTRL_VP8_FRAME_HDR] = {
+		.id = V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR,
+		.type = V4L2_CTRL_TYPE_PRIVATE,
+		.name = "VP8 Frame Header Parameters",
+		.max_reqs = VIDEO_MAX_FRAME,
+		.elem_size = sizeof(struct v4l2_ctrl_vp8_frame_hdr),
+		.can_store = true,
+	},
+};
 
 static inline const void *get_ctrl_ptr(struct rockchip_vpu_ctx *ctx,
 				       unsigned id)
@@ -954,6 +963,10 @@ static void rockchip_vpu_dec_prepare_run(struct rockchip_vpu_ctx *ctx)
 
 	v4l2_ctrl_apply_request(&ctx->ctrl_handler, src->request);
 
+	if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_VP8_FRAME) {
+		ctx->run.vp8d.frame_hdr = get_ctrl_ptr(ctx,
+				ROCKCHIP_VPU_DEC_CTRL_VP8_FRAME_HDR);
+	}
 }
 
 static void rockchip_vpu_dec_run_done(struct rockchip_vpu_ctx *ctx,
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
index dc7abc7..f4aa866 100644
--- a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
@@ -254,7 +254,24 @@ void rockchip_vpu_hw_remove(struct rockchip_vpu_dev *vpu)
 	clk_disable_unprepare(vpu->aclk);
 }
 
-static const struct rockchip_vpu_codec_ops mode_ops[0];
+static const struct rockchip_vpu_codec_ops mode_ops[] = {
+	[RK3288_VPU_CODEC_VP8D] = {
+		.init = rockchip_vpu_vp8d_init,
+		.exit = rockchip_vpu_vp8d_exit,
+		.irq = rockchip_vdpu_irq,
+		.run = rockchip_vpu_vp8d_run,
+		.done = rockchip_vpu_run_done,
+		.reset = rockchip_vpu_dec_reset,
+	},
+	[RK3229_VPU_CODEC_VP8D] = {
+		.init = rockchip_vpu_vp8d_init,
+		.exit = rockchip_vpu_vp8d_exit,
+		.irq = rockchip_vdpu_irq,
+		.run = rockchip_vpu_vp8d_run,
+		.done = rockchip_vpu_run_done,
+		.reset = rockchip_vpu_dec_reset,
+	},
+};
 
 void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx)
 {
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
index 975357da..675a0eb 100644
--- a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
@@ -56,6 +56,16 @@ struct rockchip_vpu_aux_buf {
 };
 
 /**
+ * struct rockchip_vpu_vp8d_hw_ctx - Context private data of VP8 decoder.
+ * @segment_map:	Segment map buffer.
+ * @prob_tbl:		Probability table buffer.
+ */
+struct rockchip_vpu_vp8d_hw_ctx {
+	struct rockchip_vpu_aux_buf segment_map;
+	struct rockchip_vpu_aux_buf prob_tbl;
+};
+
+/**
  * struct rockchip_vpu_hw_ctx - Context private data of hardware code.
  * @codec_ops:		Set of operations associated with current codec mode.
  */
@@ -63,6 +73,10 @@ struct rockchip_vpu_hw_ctx {
 	const struct rockchip_vpu_codec_ops *codec_ops;
 
 	/* Specific for particular codec modes. */
+	union {
+		struct rockchip_vpu_vp8d_hw_ctx vp8d;
+		/* Other modes will need different data. */
+	};
 };
 
 int rockchip_vpu_hw_probe(struct rockchip_vpu_dev *vpu);
@@ -75,4 +89,12 @@ void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx);
 
 void rockchip_vpu_power_on(struct rockchip_vpu_dev *vpu);
 
+/* for vp8 decoder */
+int rockchip_vdpu_irq(int irq, struct rockchip_vpu_dev *vpu);
+void rockchip_vpu_dec_reset(struct rockchip_vpu_ctx *ctx);
+
+int rockchip_vpu_vp8d_init(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_vp8d_exit(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_vp8d_run(struct rockchip_vpu_ctx *ctx);
+
 #endif /* RK3288_VPU_HW_H_ */
-- 
1.9.1

