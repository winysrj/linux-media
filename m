Return-path: <linux-media-owner@vger.kernel.org>
Received: from sg-smtp01.263.net ([54.255.195.220]:50504 "EHLO
	sg-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbcCACY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 21:24:29 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: tfiga@chromium.org, posciak@chromium.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Pawel Osciak <posciak@google.com>,
	eddie.cai@rock-chips.com, alpha.lin@rock-chips.com,
	jeffy.chen@rock-chips.com, herman.chen@rock-chips.com
Subject: [PATCH v3 3/3] media: vcodec: rockchip: Add Rockchip VP8 decoder driver
Date: Tue,  1 Mar 2016 10:23:56 +0800
Message-Id: <1456799036-8670-1-git-send-email-jung.zhao@rock-chips.com>
In-Reply-To: <1456798977-8514-1-git-send-email-jung.zhao@rock-chips.com>
References: <1456798977-8514-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add Rockchip VP8 decoder driver for RK3229 &
RK3288 platform.

The Driver framework was written by Tomasz and Pawel,
and amended by Rockchip. The related detail description,
you can get from Chromium Tree OS[1].

[1]https://chromium.googlesource.com/chromiumos/third_party/kernel

The base address and bits meanning of registers are
totally different between rk3229 and rk3288. We use map
tables and static register tables to help the driver generate
correct registers configuration. Through dts's message,
framework will choose proper map and register table.

Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Owen Lin <owenlin@google.com>
Signed-off-by: ZhiChao Yu <zhichao.yu@rock-chips.com>
Signed-off-by: Jung Zhao <jung.zhao@rock-chips.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Changes in v3:
- set DMA_ATTR_ALLOC_SINGLE_PAGES(Douglas)

Changes in v2: None

 drivers/media/platform/Kconfig                     |   11 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rockchip-vpu/Makefile       |    7 +
 .../media/platform/rockchip-vpu/rkvpu_hw_vp8d.c    |  798 ++++++++++
 .../platform/rockchip-vpu/rockchip_vp8d_regs.h     | 1594 ++++++++++++++++++++
 drivers/media/platform/rockchip-vpu/rockchip_vpu.c |  812 ++++++++++
 .../platform/rockchip-vpu/rockchip_vpu_common.h    |  439 ++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.c | 1007 +++++++++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.h |   33 +
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  |  295 ++++
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |  100 ++
 11 files changed, 5097 insertions(+)
 create mode 100644 drivers/media/platform/rockchip-vpu/Makefile
 create mode 100644 drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0c53805..0d6ff68 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -266,6 +266,17 @@ config VIDEO_TI_VPE
 	  Support for the TI VPE(Video Processing Engine) block
 	  found on DRA7XX SoC.
 
+config VIDEO_ROCKCHIP_VPU
+	tristate "Rockchip ROCKCHIP VPU driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	---help---
+	  Support for the VPU video codec found on Rockchip SoC.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called rockchip-vpu.
+
 config VIDEO_TI_VPE_DEBUG
 	bool "VPE debug messages"
 	depends on VIDEO_TI_VPE
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index efa0295..7b552e4 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 obj-y	+= omap/
 
 obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
+obj-$(CONFIG_VIDEO_ROCKCHIP_VPU)	+= rockchip-vpu/
 
 obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 
diff --git a/drivers/media/platform/rockchip-vpu/Makefile b/drivers/media/platform/rockchip-vpu/Makefile
new file mode 100644
index 0000000..2163eb9
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/Makefile
@@ -0,0 +1,7 @@
+
+obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
+
+rockchip-vpu-y += rockchip_vpu.o \
+		rockchip_vpu_dec.o \
+		rockchip_vpu_hw.o \
+		rkvpu_hw_vp8d.o
diff --git a/drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c b/drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
new file mode 100644
index 0000000..5df7c36
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
+ * Copyright (C) 2016 Rockchip Electronics Co., Ltd.
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
index 0000000..c54dfb4
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
@@ -0,0 +1,1594 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2015 Rockchip Electronics Co., Ltd.
+ *      Alpha Lin <alpha.lin@rock-chips.com>
+ *
+ * Copyright (C) 2016 Rockchip Electronics Co., Ltd.
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
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu.c
new file mode 100644
index 0000000..d35ef9c
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu.c
@@ -0,0 +1,812 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
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
+#include "rockchip_vpu_common.h"
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-event.h>
+#include <linux/workqueue.h>
+#include <linux/of.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "rockchip_vpu_dec.h"
+#include "rockchip_vpu_hw.h"
+
+int debug;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug,
+		 "Debug level - higher value produces more verbose messages");
+
+#define DUMP_FILE "/tmp/vpu.out"
+
+int rockchip_vpu_write(const char *file, void *buf, size_t size)
+{
+	const char __user *p = (__force const char __user *)buf;
+	struct file *filp = filp_open(file ? file : DUMP_FILE,
+			O_CREAT | O_RDWR | O_APPEND, 0644);
+	mm_segment_t fs;
+	int ret;
+
+	if (IS_ERR(filp)) {
+		pr_info("open(%s) failed\n", file ? file : DUMP_FILE);
+		return -ENODEV;
+	}
+
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+
+	filp->f_pos = 0;
+	ret = filp->f_op->write(filp, p, size, &filp->f_pos);
+
+	filp_close(filp, NULL);
+	set_fs(fs);
+
+	return ret;
+}
+
+/*
+ * DMA coherent helpers.
+ */
+
+int rockchip_vpu_aux_buf_alloc(struct rockchip_vpu_dev *vpu,
+			       struct rockchip_vpu_aux_buf *buf, size_t size)
+{
+	buf->cpu = dma_alloc_coherent(vpu->dev, size, &buf->dma, GFP_KERNEL);
+	if (!buf->cpu)
+		return -ENOMEM;
+
+	buf->size = size;
+	return 0;
+}
+
+void rockchip_vpu_aux_buf_free(struct rockchip_vpu_dev *vpu,
+			       struct rockchip_vpu_aux_buf *buf)
+{
+	dma_free_coherent(vpu->dev, buf->size, buf->cpu, buf->dma);
+
+	buf->cpu = NULL;
+	buf->dma = 0;
+	buf->size = 0;
+}
+
+/*
+ * Context scheduling.
+ */
+
+static void rockchip_vpu_prepare_run(struct rockchip_vpu_ctx *ctx)
+{
+	if (ctx->run_ops->prepare_run)
+		ctx->run_ops->prepare_run(ctx);
+}
+
+static void __rockchip_vpu_dequeue_run_locked(struct rockchip_vpu_ctx *ctx)
+{
+	struct rockchip_vpu_buf *src, *dst;
+
+	/*
+	 * Since ctx was dequeued from ready_ctxs list, we know that it has
+	 * at least one buffer in each queue.
+	 */
+	src = list_first_entry(&ctx->src_queue, struct rockchip_vpu_buf, list);
+	dst = list_first_entry(&ctx->dst_queue, struct rockchip_vpu_buf, list);
+
+	list_del(&src->list);
+	list_del(&dst->list);
+
+	ctx->run.src = src;
+	ctx->run.dst = dst;
+}
+
+static void rockchip_vpu_try_run(struct rockchip_vpu_dev *dev)
+{
+	struct rockchip_vpu_ctx *ctx = NULL;
+	unsigned long flags;
+
+	vpu_debug_enter();
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (list_empty(&dev->ready_ctxs) ||
+	    test_bit(VPU_SUSPENDED, &dev->state))
+		/* Nothing to do. */
+		goto out;
+
+	if (test_and_set_bit(VPU_RUNNING, &dev->state))
+		/*
+		* The hardware is already running. We will pick another
+		* run after we get the notification in rockchip_vpu_run_done().
+		*/
+		goto out;
+
+	ctx = list_entry(dev->ready_ctxs.next, struct rockchip_vpu_ctx, list);
+
+	list_del_init(&ctx->list);
+	__rockchip_vpu_dequeue_run_locked(ctx);
+
+	dev->current_ctx = ctx;
+
+out:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	if (ctx) {
+		rockchip_vpu_prepare_run(ctx);
+		rockchip_vpu_run(ctx);
+	}
+
+	vpu_debug_leave();
+}
+
+static void __rockchip_vpu_try_context_locked(struct rockchip_vpu_dev *dev,
+					      struct rockchip_vpu_ctx *ctx)
+{
+	if (!list_empty(&ctx->list))
+		/* Context already queued. */
+		return;
+
+	if (!list_empty(&ctx->dst_queue) && !list_empty(&ctx->src_queue))
+		list_add_tail(&ctx->list, &dev->ready_ctxs);
+}
+
+void rockchip_vpu_run_done(struct rockchip_vpu_ctx *ctx,
+			   enum vb2_buffer_state result)
+{
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	unsigned long flags;
+
+	vpu_debug_enter();
+
+	if (ctx->run_ops->run_done)
+		ctx->run_ops->run_done(ctx, result);
+
+	struct vb2_buffer *src = &ctx->run.src->b.vb2_buf;
+	struct vb2_buffer *dst = &ctx->run.dst->b.vb2_buf;
+
+	to_vb2_v4l2_buffer(dst)->timestamp =
+		to_vb2_v4l2_buffer(src)->timestamp;
+	vb2_buffer_done(&ctx->run.src->b.vb2_buf, result);
+	vb2_buffer_done(&ctx->run.dst->b.vb2_buf, result);
+
+	dev->current_ctx = NULL;
+	wake_up_all(&dev->run_wq);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	__rockchip_vpu_try_context_locked(dev, ctx);
+	clear_bit(VPU_RUNNING, &dev->state);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	/* Try scheduling another run to see if we have anything left to do. */
+	rockchip_vpu_try_run(dev);
+
+	vpu_debug_leave();
+}
+
+void rockchip_vpu_try_context(struct rockchip_vpu_dev *dev,
+			      struct rockchip_vpu_ctx *ctx)
+{
+	unsigned long flags;
+
+	vpu_debug_enter();
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	__rockchip_vpu_try_context_locked(dev, ctx);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	rockchip_vpu_try_run(dev);
+
+	vpu_debug_enter();
+}
+
+/*
+ * Control registration.
+ */
+
+#define IS_VPU_PRIV(x) ((V4L2_CTRL_ID2WHICH(x) == V4L2_CTRL_CLASS_MPEG) && \
+			  V4L2_CTRL_DRIVER_PRIV(x))
+
+int rockchip_vpu_ctrls_setup(struct rockchip_vpu_ctx *ctx,
+			     const struct v4l2_ctrl_ops *ctrl_ops,
+			     struct rockchip_vpu_control *controls,
+			     unsigned num_ctrls,
+			     const char* const* (*get_menu)(u32))
+{
+	struct v4l2_ctrl_config cfg;
+	int i;
+
+	if (num_ctrls > ARRAY_SIZE(ctx->ctrls)) {
+		vpu_err("context control array not large enough\n");
+		return -ENOSPC;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, num_ctrls);
+	if (ctx->ctrl_handler.error) {
+		vpu_err("v4l2_ctrl_handler_init failed\n");
+		return ctx->ctrl_handler.error;
+	}
+
+	for (i = 0; i < num_ctrls; i++) {
+		if (IS_VPU_PRIV(controls[i].id)
+		    || controls[i].id >= V4L2_CID_CUSTOM_BASE
+		    || controls[i].type == V4L2_CTRL_TYPE_PRIVATE) {
+			memset(&cfg, 0, sizeof(struct v4l2_ctrl_config));
+
+			cfg.ops = ctrl_ops;
+			cfg.id = controls[i].id;
+			cfg.min = controls[i].minimum;
+			cfg.max = controls[i].maximum;
+			cfg.max_reqs = controls[i].max_reqs;
+			cfg.def = controls[i].default_value;
+			cfg.name = controls[i].name;
+			cfg.type = controls[i].type;
+			cfg.elem_size = controls[i].elem_size;
+			memcpy(cfg.dims, controls[i].dims, sizeof(cfg.dims));
+
+			if (cfg.type == V4L2_CTRL_TYPE_MENU) {
+				cfg.menu_skip_mask = cfg.menu_skip_mask;
+				cfg.qmenu = get_menu(cfg.id);
+			} else {
+				cfg.step = controls[i].step;
+			}
+
+			ctx->ctrls[i] = v4l2_ctrl_new_custom(
+							     &ctx->ctrl_handler,
+							     &cfg, NULL);
+		} else {
+			if (controls[i].type == V4L2_CTRL_TYPE_MENU) {
+				ctx->ctrls[i] =
+					v4l2_ctrl_new_std_menu
+					(&ctx->ctrl_handler,
+					 ctrl_ops,
+					 controls[i].id,
+					 controls[i].maximum,
+					 0,
+					 controls[i].
+					 default_value);
+			} else {
+				ctx->ctrls[i] =
+					v4l2_ctrl_new_std(&ctx->ctrl_handler,
+							  ctrl_ops,
+							  controls[i].id,
+							  controls[i].minimum,
+							  controls[i].maximum,
+							  controls[i].step,
+							  controls[i].
+							  default_value);
+			}
+		}
+
+		if (ctx->ctrl_handler.error) {
+			vpu_err("Adding control (%d) failed\n", i);
+			return ctx->ctrl_handler.error;
+		}
+
+		if (controls[i].is_volatile && ctx->ctrls[i])
+			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
+		if (controls[i].is_read_only && ctx->ctrls[i])
+			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		if (controls[i].can_store && ctx->ctrls[i])
+			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
+	}
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+	ctx->num_ctrls = num_ctrls;
+	return 0;
+}
+
+void rockchip_vpu_ctrls_delete(struct rockchip_vpu_ctx *ctx)
+{
+	int i;
+
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	for (i = 0; i < ctx->num_ctrls; i++)
+		ctx->ctrls[i] = NULL;
+}
+
+/*
+ * V4L2 file operations.
+ */
+
+static int rockchip_vpu_open(struct file *filp)
+{
+	struct video_device *vdev = video_devdata(filp);
+	struct rockchip_vpu_dev *dev = video_drvdata(filp);
+	struct rockchip_vpu_ctx *ctx = NULL;
+	struct vb2_queue *q;
+	int ret = 0;
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
+	vpu_debug_enter();
+
+	/* Allocate memory for context */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto err_leave;
+	}
+
+	v4l2_fh_init(&ctx->fh, video_devdata(filp));
+	filp->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+	ctx->dev = dev;
+	INIT_LIST_HEAD(&ctx->src_queue);
+	INIT_LIST_HEAD(&ctx->dst_queue);
+	INIT_LIST_HEAD(&ctx->list);
+
+	if (vdev == dev->vfd_dec) {
+		/* only for decoder */
+		ret = rockchip_vpu_dec_init(ctx);
+		if (ret) {
+			vpu_err("Failed to initialize decoder context\n");
+			goto err_fh_free;
+		}
+	} else {
+		ret = -ENOENT;
+		goto err_fh_free;
+	}
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+
+	/* Init videobuf2 queue for CAPTURE */
+	q = &ctx->vq_dst;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->drv_priv = &ctx->fh;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	q->lock = &dev->vpu_mutex;
+	q->buf_struct_size = sizeof(struct rockchip_vpu_buf);
+
+	if (vdev == dev->vfd_dec)
+		q->ops = get_dec_queue_ops();
+
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+
+	q->v4l2_allow_requests = true;
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		vpu_err("Failed to initialize videobuf2 queue(capture)\n");
+		goto err_dec_exit;
+	}
+
+	/* Init videobuf2 queue for OUTPUT */
+	q = &ctx->vq_src;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	q->drv_priv = &ctx->fh;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	q->lock = &dev->vpu_mutex;
+	q->buf_struct_size = sizeof(struct rockchip_vpu_buf);
+
+	if (vdev == dev->vfd_dec)
+		q->ops = get_dec_queue_ops();
+
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+
+	q->v4l2_allow_requests = true;
+
+	ret = vb2_queue_init(q);
+	if (ret) {
+		vpu_err("Failed to initialize videobuf2 queue(output)\n");
+		goto err_vq_dst_release;
+	}
+
+	vpu_debug_leave();
+
+	return 0;
+
+err_vq_dst_release:
+	vb2_queue_release(&ctx->vq_dst);
+err_dec_exit:
+	if (vdev == dev->vfd_dec)
+		rockchip_vpu_dec_exit(ctx);
+err_fh_free:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+err_leave:
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int rockchip_vpu_release(struct file *filp)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
+	struct video_device *vdev = video_devdata(filp);
+	struct rockchip_vpu_dev *dev = ctx->dev;
+
+	/*
+	 * No need for extra locking because this was the last reference
+	 * to this file.
+	 */
+
+	vpu_debug_enter();
+
+	/*
+	 * vb2_queue_release() ensures that streaming is stopped, which
+	 * in turn means that there are no frames still being processed
+	 * by hardware.
+	 */
+	vb2_queue_release(&ctx->vq_src);
+	vb2_queue_release(&ctx->vq_dst);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (vdev == dev->vfd_dec)
+		rockchip_vpu_dec_exit(ctx);
+
+	kfree(ctx);
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+static unsigned int rockchip_vpu_poll(struct file *filp,
+				      struct poll_table_struct *wait)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
+	struct vb2_queue *src_q, *dst_q;
+	struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
+	unsigned int rc = 0;
+	unsigned long flags;
+
+	vpu_debug_enter();
+
+	src_q = &ctx->vq_src;
+	dst_q = &ctx->vq_dst;
+
+	/*
+	 * There has to be at least one buffer queued on each queued_list, which
+	 * means either in driver already or waiting for driver to claim it
+	 * and start processing.
+	 */
+	if ((!vb2_is_streaming(src_q) || list_empty(&src_q->queued_list)) &&
+	    (!vb2_is_streaming(dst_q) || list_empty(&dst_q->queued_list))) {
+		vpu_debug(0, "src q streaming %d, dst q streaming %d, src list empty(%d), dst list empty(%d)\n",
+			  src_q->streaming, dst_q->streaming,
+			  list_empty(&src_q->queued_list),
+			  list_empty(&dst_q->queued_list));
+		return POLLERR;
+	}
+
+	poll_wait(filp, &ctx->fh.wait, wait);
+	poll_wait(filp, &src_q->done_wq, wait);
+	poll_wait(filp, &dst_q->done_wq, wait);
+
+	if (v4l2_event_pending(&ctx->fh))
+		rc |= POLLPRI;
+
+	spin_lock_irqsave(&src_q->done_lock, flags);
+
+	if (!list_empty(&src_q->done_list))
+		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
+					  done_entry);
+
+	if (src_vb && (src_vb->state == VB2_BUF_STATE_DONE ||
+		       src_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLOUT | POLLWRNORM;
+
+	spin_unlock_irqrestore(&src_q->done_lock, flags);
+
+	spin_lock_irqsave(&dst_q->done_lock, flags);
+
+	if (!list_empty(&dst_q->done_list))
+		dst_vb = list_first_entry(&dst_q->done_list, struct vb2_buffer,
+					  done_entry);
+
+	if (dst_vb && (dst_vb->state == VB2_BUF_STATE_DONE ||
+		       dst_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLIN | POLLRDNORM;
+
+	spin_unlock_irqrestore(&dst_q->done_lock, flags);
+
+	return rc;
+}
+
+static int rockchip_vpu_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int ret;
+
+	vpu_debug_enter();
+
+	if (offset < DST_QUEUE_OFF_BASE) {
+		vpu_debug(4, "mmaping source\n");
+
+		ret = vb2_mmap(&ctx->vq_src, vma);
+	} else {        /* capture */
+		vpu_debug(4, "mmaping destination\n");
+
+		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
+		ret = vb2_mmap(&ctx->vq_dst, vma);
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static const struct v4l2_file_operations rockchip_vpu_fops = {
+	.owner = THIS_MODULE,
+	.open = rockchip_vpu_open,
+	.release = rockchip_vpu_release,
+	.poll = rockchip_vpu_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = rockchip_vpu_mmap,
+};
+
+/*
+ * Platform driver.
+ */
+
+static void *rockchip_get_drv_data(struct platform_device *pdev);
+
+static int rockchip_vpu_probe(struct platform_device *pdev)
+{
+	struct rockchip_vpu_dev *vpu = NULL;
+	DEFINE_DMA_ATTRS(attrs_novm);
+	DEFINE_DMA_ATTRS(attrs_nohugepage);
+	struct video_device *vfd;
+	int ret = 0;
+
+	vpu_debug_enter();
+
+	vpu = devm_kzalloc(&pdev->dev, sizeof(*vpu), GFP_KERNEL);
+	if (!vpu)
+		return -ENOMEM;
+
+	vpu->dev = &pdev->dev;
+	vpu->pdev = pdev;
+	mutex_init(&vpu->vpu_mutex);
+	spin_lock_init(&vpu->irqlock);
+	INIT_LIST_HEAD(&vpu->ready_ctxs);
+	init_waitqueue_head(&vpu->run_wq);
+
+	vpu->variant = rockchip_get_drv_data(pdev);
+
+	ret = rockchip_vpu_hw_probe(vpu);
+	if (ret) {
+		dev_err(&pdev->dev, "rockchip_vpu_hw_probe failed\n");
+		goto err_hw_probe;
+	}
+
+	/*
+	 * We'll do mostly sequential access, so sacrifice TLB efficiency for
+	 * faster allocation.
+	 */
+	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs_novm);
+
+	dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs_novm);
+	vpu->alloc_ctx = vb2_dma_contig_init_ctx_attrs(&pdev->dev,
+						       &attrs_novm);
+	if (IS_ERR(vpu->alloc_ctx)) {
+		ret = PTR_ERR(vpu->alloc_ctx);
+		goto err_dma_contig;
+	}
+
+	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs_nohugepage);
+	vpu->alloc_ctx_vm = vb2_dma_contig_init_ctx_attrs(&pdev->dev,
+							  &attrs_nohugepage);
+	if (IS_ERR(vpu->alloc_ctx_vm)) {
+		ret = PTR_ERR(vpu->alloc_ctx_vm);
+		goto err_dma_contig_vm;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
+		goto err_v4l2_dev_reg;
+	}
+
+	platform_set_drvdata(pdev, vpu);
+
+	/* decoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&vpu->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto err_v4l2_dev_reg;
+	}
+
+	vfd->fops = &rockchip_vpu_fops;
+	vfd->ioctl_ops = get_dec_v4l2_ioctl_ops();
+	vfd->release = video_device_release;
+	vfd->lock = &vpu->vpu_mutex;
+	vfd->v4l2_dev = &vpu->v4l2_dev;
+	vfd->vfl_dir = VFL_DIR_M2M;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", ROCKCHIP_VPU_DEC_NAME);
+	vpu->vfd_dec = vfd;
+
+	video_set_drvdata(vfd, vpu);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&vpu->v4l2_dev, "Failed to register video device\n");
+		video_device_release(vfd);
+		goto err_dec_reg;
+	}
+
+	v4l2_info(&vpu->v4l2_dev,
+		  "Rockchip VPU decoder registered as /vpu/video%d\n",
+		  vfd->num);
+
+	vpu_debug_leave();
+
+	return 0;
+
+err_dec_reg:
+	video_device_release(vpu->vfd_dec);
+err_v4l2_dev_reg:
+	vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx_vm);
+err_dma_contig_vm:
+	vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx);
+err_dma_contig:
+	rockchip_vpu_hw_remove(vpu);
+err_hw_probe:
+	pr_debug("%s-- with error\n", __func__);
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int rockchip_vpu_remove(struct platform_device *pdev)
+{
+	struct rockchip_vpu_dev *vpu = platform_get_drvdata(pdev);
+
+	vpu_debug_enter();
+
+	v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
+
+	/*
+	 * We are safe here assuming that .remove() got called as
+	 * a result of module removal, which guarantees that all
+	 * contexts have been released.
+	 */
+
+	video_unregister_device(vpu->vfd_dec);
+	v4l2_device_unregister(&vpu->v4l2_dev);
+	vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx_vm);
+	vb2_dma_contig_cleanup_ctx(vpu->alloc_ctx);
+	rockchip_vpu_hw_remove(vpu);
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+/* Supported VPU variants. */
+static const struct rockchip_vpu_variant rk3288_vpu_variant = {
+	.vpu_type = RK3288_VPU,
+	.name = "Rk3288 vpu",
+	.dec_offset = 0x400,
+	.dec_reg_num = 60 + 41,
+};
+
+static const struct rockchip_vpu_variant rk3229_vpu_variant = {
+	.vpu_type = RK3229_VPU,
+	.name = "Rk3229 vpu",
+	.dec_offset = 0x400,
+	.dec_reg_num = 159,
+};
+
+static struct platform_device_id vpu_driver_ids[] = {
+	{
+		.name = "rk3288-vpu",
+		.driver_data = (unsigned long)&rk3288_vpu_variant,
+	}, {
+		.name = "rk3229-vpu",
+		.driver_data = (unsigned long)&rk3229_vpu_variant,
+	},
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(platform, vpu_driver_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id of_rockchip_vpu_match[] = {
+	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
+	{ .compatible = "rockchip,rk3229-vpu", .data = &rk3229_vpu_variant, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, of_rockchip_vpu_match);
+#endif
+
+static void *rockchip_get_drv_data(struct platform_device *pdev)
+{
+	void *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(of_rockchip_vpu_match,
+				      pdev->dev.of_node);
+		if (match)
+			driver_data = (void *)match->data;
+	} else {
+		driver_data = (void *)platform_get_device_id(pdev)->driver_data;
+	}
+	return driver_data;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_vpu_suspend(struct device *dev)
+{
+	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
+
+	set_bit(VPU_SUSPENDED, &vpu->state);
+	wait_event(vpu->run_wq, vpu->current_ctx == NULL);
+
+	return 0;
+}
+
+static int rockchip_vpu_resume(struct device *dev)
+{
+	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
+
+	clear_bit(VPU_SUSPENDED, &vpu->state);
+	rockchip_vpu_try_run(vpu);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops rockchip_vpu_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(rockchip_vpu_suspend, rockchip_vpu_resume)
+};
+
+static struct platform_driver rockchip_vpu_driver = {
+	.probe = rockchip_vpu_probe,
+	.remove = rockchip_vpu_remove,
+	.id_table = vpu_driver_ids,
+	.driver = {
+		.name = ROCKCHIP_VPU_NAME,
+		.owner = THIS_MODULE,
+#ifdef CONFIG_OF
+		.of_match_table = of_match_ptr(of_rockchip_vpu_match),
+#endif
+		.pm = &rockchip_vpu_pm_ops,
+	},
+};
+module_platform_driver(rockchip_vpu_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Jung Zhao <jung.zhao@rock-chips.com>");
+MODULE_AUTHOR("Alpha Lin <Alpha.Lin@Rock-Chips.com>");
+MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
+MODULE_DESCRIPTION("Rockchip VPU codec driver");
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
new file mode 100644
index 0000000..0d77304
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
@@ -0,0 +1,439 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
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
+#ifndef ROCKCHIP_VPU_COMMON_H_
+#define ROCKCHIP_VPU_COMMON_H_
+
+/* Enable debugging by default for now. */
+#define DEBUG
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
+#define ROCKCHIP_VPU_NAME		"rockchip-vpu"
+#define ROCKCHIP_VPU_DEC_NAME		"rockchip-vpu-dec"
+
+#define V4L2_CID_CUSTOM_BASE		(V4L2_CID_USER_BASE | 0x1000)
+
+#define DST_QUEUE_OFF_BASE		(TASK_SIZE / 2)
+
+#define ROCKCHIP_VPU_MAX_CTRLS		32
+
+#define MB_DIM				16
+#define MB_WIDTH(x_size)		DIV_ROUND_UP(x_size, MB_DIM)
+#define MB_HEIGHT(y_size)		DIV_ROUND_UP(y_size, MB_DIM)
+
+struct rockchip_vpu_ctx;
+struct rockchip_vpu_codec_ops;
+
+/**
+ * struct rockchip_vpu_variant - information about VPU hardware variant
+ *
+ * @hw_id:		Top 16 bits (product ID) of hardware ID register.
+ * @vpu_type:		Vpu type.
+ * @name:		Vpu name.
+ * @dec_offset:		Offset from VPU base to decoder registers.
+ * @dec_reg_num:	Number of registers of decoder block.
+ */
+struct rockchip_vpu_variant {
+	enum rockchip_vpu_type vpu_type;
+	char *name;
+	unsigned dec_offset;
+	unsigned dec_reg_num;
+};
+
+/**
+ * enum rockchip_vpu_codec_mode - codec operating mode.
+ * @RK_VPU_CODEC_NONE:	No operating mode. Used for RAW video formats.
+ * @RK3288_VPU_CODEC_VP8D:	Rk3288 VP8 decoder.
+ * @RK3229_VPU_CODEC_VP8D:	Rk3229 VP8 decoder.
+ */
+enum rockchip_vpu_codec_mode {
+	RK_VPU_CODEC_NONE = -1,
+	RK3288_VPU_CODEC_VP8D,
+	RK3229_VPU_CODEC_VP8D,
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
+ * struct rockchip_vpu_buf - Private data related to each VB2 buffer.
+ * @vb:			Pointer to related VB2 buffer.
+ * @list:		List head for queuing in buffer queue.
+ * @flags:		Buffer state. See enum rockchip_vpu_buf_flags.
+ */
+struct rockchip_vpu_buf {
+	struct vb2_v4l2_buffer b;
+	struct list_head list;
+	/* Mode-specific data. */
+};
+
+/**
+ * enum rockchip_vpu_state - bitwise flags indicating hardware state.
+ * @VPU_RUNNING:	The hardware has been programmed for operation
+ *			and is running at the moment.
+ * @VPU_SUSPENDED:	System is entering sleep state and no more runs
+ *			should be executed on hardware.
+ */
+enum rockchip_vpu_state {
+	VPU_RUNNING	= BIT(0),
+	VPU_SUSPENDED	= BIT(1),
+};
+
+/**
+ * struct rockchip_vpu_dev - driver data
+ * @v4l2_dev:		V4L2 device to register video devices for.
+ * @vfd_dec:		Video device for decoder.
+ * @pdev:		Pointer to VPU platform device.
+ * @dev:		Pointer to device for convenient logging using
+ *			dev_ macros.
+ * @alloc_ctx:		VB2 allocator context
+ *			(for allocations without kernel mapping).
+ * @alloc_ctx_vm:	VB2 allocator context
+ *			(for allocations with kernel mapping).
+ * @aclk:		Handle of ACLK clock.
+ * @hclk:		Handle of HCLK clock.
+ * @base:		Mapped address of VPU registers.
+ * @dec_base:		Mapped address of VPU decoder register for convenience.
+ * @mapping:		DMA IOMMU mapping.
+ * @vpu_mutex:		Mutex to synchronize V4L2 calls.
+ * @irqlock:		Spinlock to synchronize access to data structures
+ *			shared with interrupt handlers.
+ * @state:		Device state.
+ * @ready_ctxs:		List of contexts ready to run.
+ * @variant:		Hardware variant-specific parameters.
+ * @current_ctx:	Context being currently processed by hardware.
+ * @run_wq:		Wait queue to wait for run completion.
+ * @watchdog_work:	Delayed work for hardware timeout handling.
+ */
+struct rockchip_vpu_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device *vfd_dec;
+	struct platform_device *pdev;
+	struct device *dev;
+	void *alloc_ctx;
+	void *alloc_ctx_vm;
+	struct clk *aclk;
+	struct clk *hclk;
+	void __iomem *base;
+	void __iomem *dec_base;
+	struct dma_iommu_mapping *mapping;
+
+	struct mutex vpu_mutex; /* video_device lock */
+	spinlock_t irqlock;
+	unsigned long state;
+	struct list_head ready_ctxs;
+	const struct rockchip_vpu_variant *variant;
+	struct rockchip_vpu_ctx *current_ctx;
+	wait_queue_head_t run_wq;
+	struct delayed_work watchdog_work;
+};
+
+/**
+ * struct rockchip_vpu_run_ops - per context operations on run data.
+ * @prepare_run:	Called when the context was selected for running
+ *			to prepare operating mode specific data.
+ * @run_done:		Called when hardware completed the run to collect
+ *			operating mode specific data from hardware and
+ *			finalize the processing.
+ */
+struct rockchip_vpu_run_ops {
+	void (*prepare_run)(struct rockchip_vpu_ctx *);
+	void (*run_done)(struct rockchip_vpu_ctx *, enum vb2_buffer_state);
+};
+
+/**
+ * struct rockchip_vpu_vp8d_run - per-run data specific to VP8
+ * decoding.
+ * @frame_hdr: Pointer to a buffer containing per-run frame data which
+ *			is needed by setting vpu register.
+ */
+struct rockchip_vpu_vp8d_run {
+	const struct v4l2_ctrl_vp8_frame_hdr *frame_hdr;
+};
+
+/**
+ * struct rockchip_vpu_run - per-run data for hardware code.
+ * @src:		Source buffer to be processed.
+ * @dst:		Destination buffer to be processed.
+ * @priv_src:		Hardware private source buffer.
+ * @priv_dst:		Hardware private destination buffer.
+ */
+struct rockchip_vpu_run {
+	/* Generic for more than one operating mode. */
+	struct rockchip_vpu_buf *src;
+	struct rockchip_vpu_buf *dst;
+
+	struct rockchip_vpu_aux_buf priv_src;
+	struct rockchip_vpu_aux_buf priv_dst;
+
+	/* Specific for particular operating modes. */
+	union {
+		struct rockchip_vpu_vp8d_run vp8d;
+		/* Other modes will need different data. */
+	};
+};
+
+/**
+ * struct rockchip_vpu_ctx - Context (instance) private data.
+ *
+ * @dev:		VPU driver data to which the context belongs.
+ * @fh:			V4L2 file handler.
+ *
+ * @vpu_src_fmt:	Descriptor of active source format.
+ * @src_fmt:		V4L2 pixel format of active source format.
+ * @vpu_dst_fmt:	Descriptor of active destination format.
+ * @dst_fmt:		V4L2 pixel format of active destination format.
+ *
+ * @vq_src:		Videobuf2 source queue.
+ * @src_queue:		Internal source buffer queue.
+ * @src_crop:		Configured source crop rectangle (encoder-only).
+ * @vq_dst:		Videobuf2 destination queue
+ * @dst_queue:		Internal destination buffer queue.
+ * @dst_bufs:		Private buffers wrapping VB2 buffers (destination).
+ *
+ * @ctrls:		Array containing pointer to registered controls.
+ * @ctrl_handler:	Control handler used to register controls.
+ * @num_ctrls:		Number of registered controls.
+ *
+ * @list:		List head for queue of ready contexts.
+ *
+ * @run:		Structure containing data about currently scheduled
+ *			processing run.
+ * @run_ops:		Set of operations related to currently scheduled run.
+ * @hw:			Structure containing hardware-related context.
+ */
+struct rockchip_vpu_ctx {
+	struct rockchip_vpu_dev *dev;
+	struct v4l2_fh fh;
+
+	/* Format info */
+	struct rockchip_vpu_fmt *vpu_src_fmt;
+	struct v4l2_pix_format_mplane src_fmt;
+	struct rockchip_vpu_fmt *vpu_dst_fmt;
+	struct v4l2_pix_format_mplane dst_fmt;
+
+	/* VB2 queue data */
+	struct vb2_queue vq_src;
+	struct list_head src_queue;
+	struct v4l2_rect src_crop;
+	struct vb2_queue vq_dst;
+	struct list_head dst_queue;
+	struct vb2_buffer *dst_bufs[VIDEO_MAX_FRAME];
+
+	/* Controls */
+	struct v4l2_ctrl *ctrls[ROCKCHIP_VPU_MAX_CTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	unsigned num_ctrls;
+
+	/* Various runtime data */
+	struct list_head list;
+
+	struct rockchip_vpu_run run;
+	const struct rockchip_vpu_run_ops *run_ops;
+	struct rockchip_vpu_hw_ctx hw;
+};
+
+/**
+ * struct rockchip_vpu_fmt - information about supported video formats.
+ * @name:	Human readable name of the format.
+ * @fourcc:	FourCC code of the format. See V4L2_PIX_FMT_*.
+ * @vpu_type:	Vpu_type;
+ * @codec_mode:	Codec mode related to this format. See
+ *		enum rockchip_vpu_codec_mode.
+ * @num_planes:	Number of planes used by this format.
+ * @depth:	Depth of each plane in bits per pixel.
+ */
+struct rockchip_vpu_fmt {
+	char *name;
+	u32 fourcc;
+	enum rockchip_vpu_type vpu_type;
+	enum rockchip_vpu_codec_mode codec_mode;
+	int num_planes;
+	u8 depth[VIDEO_MAX_PLANES];
+};
+
+/**
+ * struct rockchip_vpu_control - information about controls to be registered.
+ * @id:			Control ID.
+ * @type:		Type of the control.
+ * @name:		Human readable name of the control.
+ * @minimum:		Minimum value of the control.
+ * @maximum:		Maximum value of the control.
+ * @step:		Control value increase step.
+ * @menu_skip_mask:	Mask of invalid menu positions.
+ * @default_value:	Initial value of the control.
+ * @max_reqs:		Maximum number of configration request.
+ * @dims:		Size of each dimension of compound control.
+ * @elem_size:		Size of individual element of compound control.
+ * @is_volatile:	Control is volatile.
+ * @is_read_only:	Control is read-only.
+ * @can_store:		Control uses configuration stores.
+ *
+ * See also struct v4l2_ctrl_config.
+ */
+struct rockchip_vpu_control {
+	u32 id;
+
+	enum v4l2_ctrl_type type;
+	const char *name;
+	s32 minimum;
+	s32 maximum;
+	s32 step;
+	u32 menu_skip_mask;
+	s32 default_value;
+	s32 max_reqs;
+	u32 dims[V4L2_CTRL_MAX_DIMS];
+	u32 elem_size;
+
+	bool is_volatile:1;
+	bool is_read_only:1;
+	bool can_store:1;
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
+extern int debug;
+
+#define vpu_debug(level, fmt, args...)				\
+	do {							\
+		if (debug & BIT(level))				\
+			pr_err("%s:%d: " fmt,	                \
+			       __func__, __LINE__, ##args);	\
+	} while (0)
+
+#define vpu_debug_enter()	vpu_debug(5, "enter\n")
+#define vpu_debug_leave()	vpu_debug(5, "leave\n")
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
+static inline struct rockchip_vpu_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler,
+			    struct rockchip_vpu_ctx, ctrl_handler);
+}
+
+static inline struct rockchip_vpu_buf *vb_to_buf(struct vb2_buffer *vb)
+{
+	return container_of(to_vb2_v4l2_buffer(vb), struct rockchip_vpu_buf, b);
+}
+
+static inline bool rockchip_vpu_ctx_is_encoder(struct rockchip_vpu_ctx *ctx)
+{
+	return ctx->vpu_dst_fmt->codec_mode != RK_VPU_CODEC_NONE;
+}
+
+int rockchip_vpu_ctrls_setup(struct rockchip_vpu_ctx *ctx,
+			     const struct v4l2_ctrl_ops *ctrl_ops,
+			     struct rockchip_vpu_control *controls,
+			     unsigned num_ctrls,
+			     const char* const* (*get_menu)(u32));
+void rockchip_vpu_ctrls_delete(struct rockchip_vpu_ctx *ctx);
+
+void rockchip_vpu_try_context(struct rockchip_vpu_dev *dev,
+			      struct rockchip_vpu_ctx *ctx);
+
+void rockchip_vpu_run_done(struct rockchip_vpu_ctx *ctx,
+			   enum vb2_buffer_state result);
+
+int rockchip_vpu_aux_buf_alloc(struct rockchip_vpu_dev *vpu,
+			       struct rockchip_vpu_aux_buf *buf, size_t size);
+void rockchip_vpu_aux_buf_free(struct rockchip_vpu_dev *vpu,
+			       struct rockchip_vpu_aux_buf *buf);
+
+static inline void vdpu_write_relaxed(struct rockchip_vpu_dev *vpu,
+				      u32 val, u32 reg)
+{
+	vpu_debug(6, "MARK: set reg[%03d]: %08x\n", reg / 4, val);
+	writel_relaxed(val, vpu->dec_base + reg);
+}
+
+static inline void vdpu_write(struct rockchip_vpu_dev *vpu, u32 val, u32 reg)
+{
+	vpu_debug(6, "MARK: set reg[%03d]: %08x\n", reg / 4, val);
+	writel(val, vpu->dec_base + reg);
+}
+
+static inline u32 vdpu_read(struct rockchip_vpu_dev *vpu, u32 reg)
+{
+	u32 val = readl(vpu->dec_base + reg);
+
+	vpu_debug(6, "MARK: get reg[%03d]: %08x\n", reg / 4, val);
+	return val;
+}
+
+int rockchip_vpu_write(const char *file, void *buf, size_t size);
+
+#endif /* ROCKCHIP_VPU_COMMON_H_ */
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
new file mode 100644
index 0000000..f1d1c01
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
@@ -0,0 +1,1007 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2014 Rockchip Electronics Co., Ltd.
+ *	Hertz Wong <hertz.wong@rock-chips.com>
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ *
+ * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
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
+#include "rockchip_vpu_common.h"
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "rockchip_vpu_dec.h"
+#include "rockchip_vpu_hw.h"
+
+#define DEF_SRC_FMT_DEC				V4L2_PIX_FMT_H264_SLICE
+#define DEF_DST_FMT_DEC				V4L2_PIX_FMT_NV12
+
+#define ROCKCHIP_DEC_MIN_WIDTH			48U
+#define ROCKCHIP_DEC_MAX_WIDTH			3840U
+#define ROCKCHIP_DEC_MIN_HEIGHT			48U
+#define ROCKCHIP_DEC_MAX_HEIGHT			2160U
+
+static struct rockchip_vpu_fmt formats[] = {
+	{
+		.name = "4:2:0 1 plane Y/CbCr",
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.vpu_type = RK_VPU_NONE,
+		.codec_mode = RK_VPU_CODEC_NONE,
+		.num_planes = 1,
+		.depth = { 12 },
+	},
+	{
+		.name = "Frames of VP8 Decoded Stream",
+		.fourcc = V4L2_PIX_FMT_VP8_FRAME,
+		.vpu_type = RK3288_VPU,
+		.codec_mode = RK3288_VPU_CODEC_VP8D,
+		.num_planes = 1,
+	},
+	{
+		.name = "Frames of VP8 Decoded Stream",
+		.fourcc = V4L2_PIX_FMT_VP8_FRAME,
+		.vpu_type = RK3229_VPU,
+		.codec_mode = RK3229_VPU_CODEC_VP8D,
+		.num_planes = 1,
+	},
+};
+
+static struct rockchip_vpu_fmt *find_format(u32 fourcc, bool bitstream,
+					    struct rockchip_vpu_dev *dev)
+{
+	unsigned int i;
+
+	vpu_debug_enter();
+
+	for (i = 0; i < ARRAY_SIZE(formats); i++) {
+		if (formats[i].fourcc != fourcc)
+			continue;
+		if (bitstream && formats[i].codec_mode != RK_VPU_CODEC_NONE
+		    && formats[i].vpu_type == dev->variant->vpu_type)
+			return &formats[i];
+		if (!bitstream && formats[i].codec_mode == RK_VPU_CODEC_NONE)
+			return &formats[i];
+	}
+
+	return NULL;
+}
+
+/* Indices of controls that need to be accessed directly. */
+enum {
+	ROCKCHIP_VPU_DEC_CTRL_VP8_FRAME_HDR,
+};
+
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
+
+static inline const void *get_ctrl_ptr(struct rockchip_vpu_ctx *ctx,
+				       unsigned id)
+{
+	struct v4l2_ctrl *ctrl = ctx->ctrls[id];
+
+	return ctrl->p_cur.p;
+}
+
+/* Query capabilities of the device */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+
+	vpu_debug_enter();
+
+	strlcpy(cap->driver, ROCKCHIP_VPU_DEC_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, dev->pdev->name, sizeof(cap->card));
+	strlcpy(cap->bus_info, "platform:" ROCKCHIP_VPU_NAME,
+		sizeof(cap->bus_info));
+
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+	    V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *prov,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	struct v4l2_frmsize_stepwise *s = &fsize->stepwise;
+	struct rockchip_vpu_fmt *fmt;
+
+	if (fsize->index != 0) {
+		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
+				fsize->index);
+		return -EINVAL;
+	}
+
+	fmt = find_format(fsize->pixel_format, true, dev);
+	if (!fmt) {
+		vpu_debug(0, "unsupported bitstream format (%08x)\n",
+				fsize->pixel_format);
+		return -EINVAL;
+	}
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+
+	s->min_width = ROCKCHIP_DEC_MIN_WIDTH;
+	s->max_width = ROCKCHIP_DEC_MAX_WIDTH;
+	s->step_width = MB_DIM;
+	s->min_height = ROCKCHIP_DEC_MIN_HEIGHT;
+	s->max_height = ROCKCHIP_DEC_MAX_HEIGHT;
+	s->step_height = MB_DIM;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool out,
+			   struct rockchip_vpu_dev *dev)
+{
+	struct rockchip_vpu_fmt *fmt;
+	int i, j = 0;
+
+	vpu_debug_enter();
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (out && formats[i].codec_mode == RK_VPU_CODEC_NONE)
+			continue;
+		else if (!out && (formats[i].codec_mode != RK_VPU_CODEC_NONE))
+			continue;
+		else if (formats[i].vpu_type != dev->variant->vpu_type &&
+			 formats[i].vpu_type != RK_VPU_NONE)
+			continue;
+
+		if (j == f->index) {
+			fmt = &formats[i];
+			strlcpy(f->description, fmt->name,
+				sizeof(f->description));
+			f->pixelformat = fmt->fourcc;
+
+			f->flags = 0;
+			if (formats[i].codec_mode != RK_VPU_CODEC_NONE)
+				f->flags |= V4L2_FMT_FLAG_COMPRESSED;
+
+			vpu_debug_leave();
+
+			return 0;
+		}
+
+		++j;
+	}
+
+	vpu_debug_leave();
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
+					  struct v4l2_fmtdesc *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+
+	return vidioc_enum_fmt(f, false, dev);
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
+					  struct v4l2_fmtdesc *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+
+	return vidioc_enum_fmt(f, true, dev);
+}
+
+static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+
+	vpu_debug_enter();
+
+	vpu_debug(4, "f->type = %d\n", f->type);
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		f->fmt.pix_mp = ctx->dst_fmt;
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		f->fmt.pix_mp = ctx->src_fmt;
+		break;
+
+	default:
+		vpu_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct rockchip_vpu_dev *dev = video_drvdata(file);
+	struct rockchip_vpu_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	char str[5];
+
+	vpu_debug_enter();
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		vpu_debug(4, "%s\n", fmt2str(f->fmt.pix_mp.pixelformat, str));
+
+		fmt = find_format(pix_fmt_mp->pixelformat, true, dev);
+		if (!fmt) {
+			vpu_err("failed to try output format\n");
+			return -EINVAL;
+		}
+
+		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
+			vpu_err("sizeimage of output format must be given\n");
+			return -EINVAL;
+		}
+
+		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		vpu_debug(4, "%s\n", fmt2str(f->fmt.pix_mp.pixelformat, str));
+
+		fmt = find_format(pix_fmt_mp->pixelformat, false, dev);
+		if (!fmt) {
+			vpu_err("failed to try capture format\n");
+			return -EINVAL;
+		}
+
+		if (fmt->num_planes != pix_fmt_mp->num_planes) {
+			vpu_err("plane number mismatches on capture format\n");
+			return -EINVAL;
+		}
+
+		/* Limit to hardware min/max. */
+		pix_fmt_mp->width =
+			clamp(pix_fmt_mp->width,
+			      ROCKCHIP_DEC_MIN_WIDTH, ROCKCHIP_DEC_MAX_WIDTH);
+		pix_fmt_mp->height =
+			clamp(pix_fmt_mp->height,
+			      ROCKCHIP_DEC_MIN_HEIGHT, ROCKCHIP_DEC_MAX_HEIGHT);
+
+		/* Round up to macroblocks. */
+		pix_fmt_mp->width = round_up(pix_fmt_mp->width, MB_DIM);
+		pix_fmt_mp->height = round_up(pix_fmt_mp->height, MB_DIM);
+		break;
+
+	default:
+		vpu_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	unsigned int mb_width, mb_height;
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	struct rockchip_vpu_fmt *fmt;
+	int ret = 0;
+	int i;
+
+	vpu_debug_enter();
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		/* Change not allowed if any queue is streaming. */
+		if (vb2_is_streaming(&ctx->vq_src)
+		    || vb2_is_streaming(&ctx->vq_dst)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/*
+		 * Pixel format change is not allowed when the other queue has
+		 * buffers allocated.
+		 */
+		if (vb2_is_busy(&ctx->vq_dst)
+		    && pix_fmt_mp->pixelformat != ctx->src_fmt.pixelformat) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		ret = vidioc_try_fmt(file, priv, f);
+		if (ret)
+			goto out;
+
+		ctx->vpu_src_fmt = find_format(pix_fmt_mp->pixelformat,
+					       true, dev);
+		ctx->src_fmt = *pix_fmt_mp;
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		/*
+		 * Change not allowed if this queue is streaming.
+		 *
+		 * NOTE: We allow changes with source queue streaming
+		 * to support resolution change in decoded stream.
+		 */
+		if (vb2_is_streaming(&ctx->vq_dst)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/*
+		 * Pixel format change is not allowed when the other queue has
+		 * buffers allocated.
+		 */
+		if (vb2_is_busy(&ctx->vq_src)
+		    && pix_fmt_mp->pixelformat != ctx->dst_fmt.pixelformat) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		ret = vidioc_try_fmt(file, priv, f);
+		if (ret)
+			goto out;
+
+		fmt = find_format(pix_fmt_mp->pixelformat, false, dev);
+		ctx->vpu_dst_fmt = fmt;
+
+		mb_width = MB_WIDTH(pix_fmt_mp->width);
+		mb_height = MB_HEIGHT(pix_fmt_mp->height);
+
+		vpu_debug(0, "CAPTURE codec mode: %d\n", fmt->codec_mode);
+		vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
+			  pix_fmt_mp->width, pix_fmt_mp->height,
+			  mb_width, mb_height);
+
+		for (i = 0; i < fmt->num_planes; ++i) {
+			pix_fmt_mp->plane_fmt[i].bytesperline =
+				mb_width * MB_DIM * fmt->depth[i] / 8;
+			pix_fmt_mp->plane_fmt[i].sizeimage =
+				pix_fmt_mp->plane_fmt[i].bytesperline
+				* mb_height * MB_DIM;
+			/*
+			 * All of multiplanar formats we support have chroma
+			 * planes subsampled by 2.
+			 */
+			if (i != 0)
+				pix_fmt_mp->plane_fmt[i].sizeimage /= 2;
+		}
+
+		ctx->dst_fmt = *pix_fmt_mp;
+		break;
+
+	default:
+		vpu_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+out:
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	vpu_debug_enter();
+
+	switch (reqbufs->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		if (ret != 0) {
+			vpu_err("error in vb2_reqbufs() for E(S)\n");
+			goto out;
+		}
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		if (ret != 0) {
+			vpu_err("error in vb2_reqbufs() for E(D)\n");
+			goto out;
+		}
+		break;
+
+	default:
+		vpu_err("invalid buf type\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+out:
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	vpu_debug_enter();
+
+	switch (buf->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		if (ret != 0) {
+			vpu_err("error in vb2_querybuf() for E(D)\n");
+			goto out;
+		}
+
+		buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_querybuf(&ctx->vq_src, buf);
+		if (ret != 0) {
+			vpu_err("error in vb2_querybuf() for E(S)\n");
+			goto out;
+		}
+		break;
+
+	default:
+		vpu_err("invalid buf type\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+out:
+	vpu_debug_leave();
+
+	return ret;
+}
+
+/* Queue a buffer */
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+	int i;
+
+	vpu_debug_enter();
+
+	for (i = 0; i < buf->length; i++)
+		vpu_debug(4, "plane[%d]->length %d bytesused %d\n",
+				i, buf->m.planes[i].length,
+				buf->m.planes[i].bytesused);
+
+	switch (buf->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_qbuf(&ctx->vq_src, buf);
+		vpu_debug(4, "OUTPUT_MPLANE : vb2_qbuf return %d\n", ret);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_qbuf(&ctx->vq_dst, buf);
+		vpu_debug(4, "CAPTURE_MPLANE: vb2_qbuf return %d\n", ret);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+/* Dequeue a buffer */
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	vpu_debug_enter();
+
+	switch (buf->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+/* Export DMA buffer */
+static int vidioc_expbuf(struct file *file, void *priv,
+			 struct v4l2_exportbuffer *eb)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	vpu_debug_enter();
+
+	switch (eb->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_expbuf(&ctx->vq_src, eb);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_expbuf(&ctx->vq_dst, eb);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+/* Stream on */
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	vpu_debug_enter();
+
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_streamon(&ctx->vq_src, type);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_streamon(&ctx->vq_dst, type);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+/* Stream off, which equals to a pause */
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	vpu_debug_enter();
+
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		ret = vb2_streamoff(&ctx->vq_src, type);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		ret = vb2_streamoff(&ctx->vq_dst, type);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int rockchip_vpu_dec_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct rockchip_vpu_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	int ret = 0;
+
+	vpu_debug_enter();
+
+	vpu_debug(4, "ctrl id %d\n", ctrl->id);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
+		/* These controls are used directly. */
+		break;
+
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
+			 ctrl->id, ctrl->val);
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops rockchip_vpu_dec_ctrl_ops = {
+	.s_ctrl = rockchip_vpu_dec_s_ctrl,
+};
+
+static const struct v4l2_ioctl_ops rockchip_vpu_dec_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt,
+	.vidioc_reqbufs = vidioc_reqbufs,
+	.vidioc_querybuf = vidioc_querybuf,
+	.vidioc_qbuf = vidioc_qbuf,
+	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_expbuf = vidioc_expbuf,
+	.vidioc_streamon = vidioc_streamon,
+	.vidioc_streamoff = vidioc_streamoff,
+};
+
+static int rockchip_vpu_queue_setup(struct vb2_queue *vq,
+				  const void *parg,
+				  unsigned int *buf_count,
+				  unsigned int *plane_count,
+				  unsigned int psize[], void *allocators[])
+{
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	int ret = 0;
+
+	vpu_debug_enter();
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		*plane_count = ctx->vpu_src_fmt->num_planes;
+
+		if (*buf_count < 1)
+			*buf_count = 1;
+
+		if (*buf_count > VIDEO_MAX_FRAME)
+			*buf_count = VIDEO_MAX_FRAME;
+
+		psize[0] = ctx->src_fmt.plane_fmt[0].sizeimage;
+		allocators[0] = ctx->dev->alloc_ctx;
+		vpu_debug(0, "output psize[%d]: %d\n", 0, psize[0]);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		*plane_count = ctx->vpu_dst_fmt->num_planes;
+
+		if (*buf_count < 1)
+			*buf_count = 1;
+
+		if (*buf_count > VIDEO_MAX_FRAME)
+			*buf_count = VIDEO_MAX_FRAME;
+
+		psize[0] = round_up(ctx->dst_fmt.plane_fmt[0].sizeimage, 8);
+		allocators[0] = ctx->dev->alloc_ctx;
+
+		vpu_debug(0, "capture psize[%d]: %d\n", 0, psize[0]);
+		break;
+
+	default:
+		vpu_err("invalid queue type: %d\n", vq->type);
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int rockchip_vpu_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
+
+	vpu_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		ctx->dst_bufs[vb->index] = vb;
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+static void rockchip_vpu_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
+
+	vpu_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		ctx->dst_bufs[vb->index] = NULL;
+
+	vpu_debug_leave();
+}
+
+static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	int ret = 0;
+	int i;
+
+	vpu_debug_enter();
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		vpu_debug(4, "plane size: %ld, dst size: %d\n",
+				vb2_plane_size(vb, 0),
+				ctx->src_fmt.plane_fmt[0].sizeimage);
+
+		if (vb2_plane_size(vb, 0)
+		    < ctx->src_fmt.plane_fmt[0].sizeimage) {
+			vpu_err("plane size is too small for output\n");
+			ret = -EINVAL;
+		}
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		for (i = 0; i < ctx->vpu_dst_fmt->num_planes; ++i) {
+			vpu_debug(4, "plane %d size: %ld, sizeimage: %u\n", i,
+					vb2_plane_size(vb, i),
+					ctx->dst_fmt.plane_fmt[i].sizeimage);
+
+			if (vb2_plane_size(vb, i)
+			    < ctx->dst_fmt.plane_fmt[i].sizeimage) {
+				vpu_err("size of plane %d is too small for capture\n",
+					i);
+				break;
+			}
+		}
+
+		if (i != ctx->vpu_dst_fmt->num_planes)
+			ret = -EINVAL;
+		break;
+
+	default:
+		vpu_err("invalid queue type: %d\n", vq->type);
+		ret = -EINVAL;
+	}
+
+	vpu_debug_leave();
+
+	return ret;
+}
+
+static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	int ret = 0;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	bool ready = false;
+
+	vpu_debug_enter();
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = rockchip_vpu_init(ctx);
+		if (ret < 0) {
+			vpu_err("rockchip_vpu_init failed\n");
+			return ret;
+		}
+
+		ready = vb2_is_streaming(&ctx->vq_src);
+	} else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ready = vb2_is_streaming(&ctx->vq_dst);
+	}
+
+	if (ready)
+		rockchip_vpu_try_context(dev, ctx);
+
+	vpu_debug_leave();
+
+	return 0;
+}
+
+static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
+{
+	unsigned long flags;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	struct rockchip_vpu_buf *b;
+	LIST_HEAD(queue);
+	int i;
+
+	vpu_debug_enter();
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	list_del_init(&ctx->list);
+
+	switch (q->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		list_splice_init(&ctx->dst_queue, &queue);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		list_splice_init(&ctx->src_queue, &queue);
+		break;
+
+	default:
+		break;
+	}
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	wait_event(dev->run_wq, dev->current_ctx != ctx);
+
+	while (!list_empty(&queue)) {
+		b = list_first_entry(&queue, struct rockchip_vpu_buf, list);
+		for (i = 0; i < b->b.vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&b->b.vb2_buf, i, 0);
+		vb2_buffer_done(&b->b.vb2_buf, VB2_BUF_STATE_ERROR);
+		list_del(&b->list);
+	}
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		rockchip_vpu_deinit(ctx);
+
+	vpu_debug_leave();
+}
+
+static void rockchip_vpu_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct rockchip_vpu_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct rockchip_vpu_dev *dev = ctx->dev;
+	struct rockchip_vpu_buf *vpu_buf;
+	unsigned long flags;
+
+	vpu_debug_enter();
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		vpu_buf = vb_to_buf(vb);
+
+		/* Mark destination as available for use by VPU */
+		spin_lock_irqsave(&dev->irqlock, flags);
+
+		list_add_tail(&vpu_buf->list, &ctx->dst_queue);
+
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		vpu_buf = vb_to_buf(vb);
+
+		spin_lock_irqsave(&dev->irqlock, flags);
+
+		list_add_tail(&vpu_buf->list, &ctx->src_queue);
+
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		break;
+
+	default:
+		vpu_err("unsupported buffer type (%d)\n", vq->type);
+	}
+
+	if (vb2_is_streaming(&ctx->vq_src) && vb2_is_streaming(&ctx->vq_dst))
+		rockchip_vpu_try_context(dev, ctx);
+
+	vpu_debug_leave();
+}
+
+static struct vb2_ops rockchip_vpu_dec_qops = {
+	.queue_setup = rockchip_vpu_queue_setup,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.buf_init = rockchip_vpu_buf_init,
+	.buf_prepare = rockchip_vpu_buf_prepare,
+	.buf_cleanup = rockchip_vpu_buf_cleanup,
+	.start_streaming = rockchip_vpu_start_streaming,
+	.stop_streaming = rockchip_vpu_stop_streaming,
+	.buf_queue = rockchip_vpu_buf_queue,
+};
+
+struct vb2_ops *get_dec_queue_ops(void)
+{
+	return &rockchip_vpu_dec_qops;
+}
+
+const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void)
+{
+	return &rockchip_vpu_dec_ioctl_ops;
+}
+
+static void rockchip_vpu_dec_prepare_run(struct rockchip_vpu_ctx *ctx)
+{
+	struct vb2_v4l2_buffer *src =
+		to_vb2_v4l2_buffer(&ctx->run.src->b.vb2_buf);
+
+	v4l2_ctrl_apply_request(&ctx->ctrl_handler, src->request);
+
+	if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_VP8_FRAME) {
+		ctx->run.vp8d.frame_hdr = get_ctrl_ptr(ctx,
+				ROCKCHIP_VPU_DEC_CTRL_VP8_FRAME_HDR);
+	}
+}
+
+static void rockchip_vpu_dec_run_done(struct rockchip_vpu_ctx *ctx,
+				    enum vb2_buffer_state result)
+{
+	struct v4l2_plane_pix_format *plane_fmts = ctx->dst_fmt.plane_fmt;
+	struct vb2_buffer *dst = &ctx->run.dst->b.vb2_buf;
+	int i;
+
+	if (result != VB2_BUF_STATE_DONE) {
+		/* Assume no payload after failed run. */
+		for (i = 0; i < dst->num_planes; ++i)
+			vb2_set_plane_payload(dst, i, 0);
+		return;
+	}
+
+	for (i = 0; i < dst->num_planes; ++i)
+		vb2_set_plane_payload(dst, i, plane_fmts[i].sizeimage);
+}
+
+static const struct rockchip_vpu_run_ops rockchip_vpu_dec_run_ops = {
+	.prepare_run = rockchip_vpu_dec_prepare_run,
+	.run_done = rockchip_vpu_dec_run_done,
+};
+
+int rockchip_vpu_dec_init(struct rockchip_vpu_ctx *ctx)
+{
+
+	ctx->run_ops = &rockchip_vpu_dec_run_ops;
+
+	return rockchip_vpu_ctrls_setup(ctx, &rockchip_vpu_dec_ctrl_ops,
+					controls, ARRAY_SIZE(controls), NULL);
+}
+
+void rockchip_vpu_dec_exit(struct rockchip_vpu_ctx *ctx)
+{
+	rockchip_vpu_ctrls_delete(ctx);
+}
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
new file mode 100644
index 0000000..267a089
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
@@ -0,0 +1,33 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2014 Rockchip Electronics Co., Ltd.
+ *	Hertz Wong <hertz.wong@rock-chips.com>
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
+ *
+ * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
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
+#ifndef ROCKCHIP_VPU_DEC_H_
+#define ROCKCHIP_VPU_DEC_H_
+
+struct vb2_ops *get_dec_queue_ops(void);
+const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
+struct rockchip_vpu_fmt *get_dec_def_fmt(bool src);
+int rockchip_vpu_dec_init(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_dec_exit(struct rockchip_vpu_ctx *ctx);
+
+#endif /* ROCKCHIP_VPU_DEC_H_ */
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
new file mode 100644
index 0000000..f4aa866
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
@@ -0,0 +1,295 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
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
+#include "rockchip_vpu_common.h"
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+
+#include <asm/dma-iommu.h>
+
+/**
+ * struct rockchip_vpu_codec_ops - codec mode specific operations
+ *
+ * @init:	Prepare for streaming. Called from VB2 .start_streaming()
+ *		when streaming from both queues is being enabled.
+ * @exit:	Clean-up after streaming. Called from VB2 .stop_streaming()
+ *		when streaming from first of both enabled queues is being
+ *		disabled.
+ * @run:	Start single {en,de)coding run. Called from non-atomic context
+ *		to indicate that a pair of buffers is ready and the hardware
+ *		should be programmed and started.
+ * @done:	Read back processing results and additional data from hardware.
+ * @reset:	Reset the hardware in case of a timeout.
+ */
+struct rockchip_vpu_codec_ops {
+	int (*init)(struct rockchip_vpu_ctx *);
+	void (*exit)(struct rockchip_vpu_ctx *);
+
+	int (*irq)(int, struct rockchip_vpu_dev *);
+	void (*run)(struct rockchip_vpu_ctx *);
+	void (*done)(struct rockchip_vpu_ctx *, enum vb2_buffer_state);
+	void (*reset)(struct rockchip_vpu_ctx *);
+};
+
+/*
+ * Hardware control routines.
+ */
+
+void rockchip_vpu_power_on(struct rockchip_vpu_dev *vpu)
+{
+	vpu_debug_enter();
+
+	/* TODO: Clock gating. */
+
+	pm_runtime_get_sync(vpu->dev);
+
+	vpu_debug_leave();
+}
+
+static void rockchip_vpu_power_off(struct rockchip_vpu_dev *vpu)
+{
+	vpu_debug_enter();
+
+	pm_runtime_mark_last_busy(vpu->dev);
+	pm_runtime_put_autosuspend(vpu->dev);
+
+	/* TODO: Clock gating. */
+
+	vpu_debug_leave();
+}
+
+/*
+ * Interrupt handlers.
+ */
+
+static irqreturn_t vdpu_irq(int irq, void *dev_id)
+{
+	struct rockchip_vpu_dev *vpu = dev_id;
+	struct rockchip_vpu_ctx *ctx = vpu->current_ctx;
+
+	if (!ctx->hw.codec_ops->irq(irq, vpu)) {
+		rockchip_vpu_power_off(vpu);
+		cancel_delayed_work(&vpu->watchdog_work);
+
+		ctx->hw.codec_ops->done(ctx, VB2_BUF_STATE_DONE);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void rockchip_vpu_watchdog(struct work_struct *work)
+{
+	struct rockchip_vpu_dev *vpu = container_of(to_delayed_work(work),
+					struct rockchip_vpu_dev, watchdog_work);
+	struct rockchip_vpu_ctx *ctx = vpu->current_ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpu->irqlock, flags);
+
+	ctx->hw.codec_ops->reset(ctx);
+
+	spin_unlock_irqrestore(&vpu->irqlock, flags);
+
+	vpu_err("frame processing timed out!\n");
+
+	rockchip_vpu_power_off(vpu);
+	ctx->hw.codec_ops->done(ctx, VB2_BUF_STATE_ERROR);
+}
+
+/*
+ * Initialization/clean-up.
+ */
+
+#if defined(CONFIG_ROCKCHIP_IOMMU)
+static int rockchip_vpu_iommu_init(struct rockchip_vpu_dev *vpu)
+{
+	int ret;
+
+	vpu->mapping = arm_iommu_create_mapping(&platform_bus_type,
+						0x10000000, SZ_2G);
+	if (IS_ERR(vpu->mapping)) {
+		ret = PTR_ERR(vpu->mapping);
+		return ret;
+	}
+
+	vpu->dev->dma_parms = devm_kzalloc(vpu->dev,
+				sizeof(*vpu->dev->dma_parms), GFP_KERNEL);
+	if (!vpu->dev->dma_parms)
+		goto err_release_mapping;
+
+	dma_set_max_seg_size(vpu->dev, 0xffffffffu);
+
+	ret = arm_iommu_attach_device(vpu->dev, vpu->mapping);
+	if (ret)
+		goto err_release_mapping;
+
+	return 0;
+
+err_release_mapping:
+	arm_iommu_release_mapping(vpu->mapping);
+
+	return ret;
+}
+
+static void rockchip_vpu_iommu_cleanup(struct rockchip_vpu_dev *vpu)
+{
+	arm_iommu_detach_device(vpu->dev);
+	arm_iommu_release_mapping(vpu->mapping);
+}
+#else
+static inline int rockchip_vpu_iommu_init(struct rockchip_vpu_dev *vpu)
+{
+	return 0;
+}
+
+static inline void rockchip_vpu_iommu_cleanup(struct rockchip_vpu_dev *vpu) { }
+#endif
+
+int rockchip_vpu_hw_probe(struct rockchip_vpu_dev *vpu)
+{
+	struct resource *res;
+	int irq_dec;
+	int ret;
+
+	pr_info("probe device %s\n", dev_name(vpu->dev));
+
+	INIT_DELAYED_WORK(&vpu->watchdog_work, rockchip_vpu_watchdog);
+
+	vpu->aclk = devm_clk_get(vpu->dev, "aclk");
+	if (IS_ERR(vpu->aclk)) {
+		dev_err(vpu->dev, "failed to get aclk\n");
+		return PTR_ERR(vpu->aclk);
+	}
+
+	vpu->hclk = devm_clk_get(vpu->dev, "hclk");
+	if (IS_ERR(vpu->hclk)) {
+		dev_err(vpu->dev, "failed to get hclk\n");
+		return PTR_ERR(vpu->hclk);
+	}
+
+	/*
+	 * Bump ACLK to max. possible freq. (400 MHz) to improve performance.
+	 */
+	clk_set_rate(vpu->aclk, 400*1000*1000);
+
+	res = platform_get_resource(vpu->pdev, IORESOURCE_MEM, 0);
+	vpu->base = devm_ioremap_resource(vpu->dev, res);
+	if (IS_ERR(vpu->base))
+		return PTR_ERR(vpu->base);
+
+	clk_prepare_enable(vpu->aclk);
+	clk_prepare_enable(vpu->hclk);
+
+	vpu->dec_base = vpu->base + vpu->variant->dec_offset;
+
+	ret = dma_set_coherent_mask(vpu->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(vpu->dev, "could not set DMA coherent mask\n");
+		goto err_power;
+	}
+
+	ret = rockchip_vpu_iommu_init(vpu);
+	if (ret)
+		goto err_power;
+
+	irq_dec = platform_get_irq_byname(vpu->pdev, "vdpu");
+	if (irq_dec <= 0) {
+		dev_err(vpu->dev, "could not get vdpu IRQ\n");
+		ret = -ENXIO;
+		goto err_iommu;
+	}
+
+	ret = devm_request_threaded_irq(vpu->dev, irq_dec, NULL, vdpu_irq,
+					IRQF_ONESHOT, dev_name(vpu->dev), vpu);
+	if (ret) {
+		dev_err(vpu->dev, "could not request vdpu IRQ\n");
+		goto err_iommu;
+	}
+
+	pm_runtime_set_autosuspend_delay(vpu->dev, 100);
+	pm_runtime_use_autosuspend(vpu->dev);
+	pm_runtime_enable(vpu->dev);
+
+	return 0;
+
+err_iommu:
+	rockchip_vpu_iommu_cleanup(vpu);
+err_power:
+	clk_disable_unprepare(vpu->hclk);
+	clk_disable_unprepare(vpu->aclk);
+
+	return ret;
+}
+
+void rockchip_vpu_hw_remove(struct rockchip_vpu_dev *vpu)
+{
+	rockchip_vpu_iommu_cleanup(vpu);
+
+	pm_runtime_disable(vpu->dev);
+
+	clk_disable_unprepare(vpu->hclk);
+	clk_disable_unprepare(vpu->aclk);
+}
+
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
+
+void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx)
+{
+	ctx->hw.codec_ops->run(ctx);
+}
+
+int rockchip_vpu_init(struct rockchip_vpu_ctx *ctx)
+{
+	enum rockchip_vpu_codec_mode codec_mode;
+
+	codec_mode = ctx->vpu_src_fmt->codec_mode; /* Decoder */
+
+	ctx->hw.codec_ops = &mode_ops[codec_mode];
+
+	return ctx->hw.codec_ops->init(ctx);
+}
+
+void rockchip_vpu_deinit(struct rockchip_vpu_ctx *ctx)
+{
+	ctx->hw.codec_ops->exit(ctx);
+}
diff --git a/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
new file mode 100644
index 0000000..675a0eb
--- /dev/null
+++ b/drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
@@ -0,0 +1,100 @@
+/*
+ * Rockchip VPU codec driver
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *	Tomasz Figa <tfiga@chromium.org>
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
+#ifndef ROCKCHIP_VPU_HW_H_
+#define ROCKCHIP_VPU_HW_H_
+
+#include <media/videobuf2-core.h>
+
+#define ROCKCHIP_HEADER_SIZE		1280
+#define ROCKCHIP_HW_PARAMS_SIZE		5487
+#define ROCKCHIP_RET_PARAMS_SIZE	488
+
+struct rockchip_vpu_dev;
+struct rockchip_vpu_ctx;
+struct rockchip_vpu_buf;
+
+/**
+ * enum rockchip_vpu_type - vpu type.
+ * @RK_VPU_NONE:	No vpu type. Used for RAW video formats.
+ * @RK3288_VPU:		Vpu on rk3288 soc.
+ * @RK3229_VPU:		Vpu on rk3229 soc.
+ * @RKVDEC:		Rkvdec.
+ */
+enum rockchip_vpu_type {
+	RK_VPU_NONE	= -1,
+	RK3288_VPU,
+	RK3229_VPU,
+};
+
+#define ROCKCHIP_VPU_MATCHES(type1, type2) \
+	(type1 == RK_VPU_NONE || type2 == RK_VPU_NONE || type1 == type2)
+
+/**
+ * struct rockchip_vpu_aux_buf - auxiliary DMA buffer for hardware data
+ * @cpu:	CPU pointer to the buffer.
+ * @dma:	DMA address of the buffer.
+ * @size:	Size of the buffer.
+ */
+struct rockchip_vpu_aux_buf {
+	void *cpu;
+	dma_addr_t dma;
+	size_t size;
+};
+
+/**
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
+ * struct rockchip_vpu_hw_ctx - Context private data of hardware code.
+ * @codec_ops:		Set of operations associated with current codec mode.
+ */
+struct rockchip_vpu_hw_ctx {
+	const struct rockchip_vpu_codec_ops *codec_ops;
+
+	/* Specific for particular codec modes. */
+	union {
+		struct rockchip_vpu_vp8d_hw_ctx vp8d;
+		/* Other modes will need different data. */
+	};
+};
+
+int rockchip_vpu_hw_probe(struct rockchip_vpu_dev *vpu);
+void rockchip_vpu_hw_remove(struct rockchip_vpu_dev *vpu);
+
+int rockchip_vpu_init(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_deinit(struct rockchip_vpu_ctx *ctx);
+
+void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx);
+
+void rockchip_vpu_power_on(struct rockchip_vpu_dev *vpu);
+
+/* for vp8 decoder */
+int rockchip_vdpu_irq(int irq, struct rockchip_vpu_dev *vpu);
+void rockchip_vpu_dec_reset(struct rockchip_vpu_ctx *ctx);
+
+int rockchip_vpu_vp8d_init(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_vp8d_exit(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_vp8d_run(struct rockchip_vpu_ctx *ctx);
+
+#endif /* RK3288_VPU_HW_H_ */
-- 
1.9.1

