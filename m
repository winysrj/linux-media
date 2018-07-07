Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:44940 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753864AbeGGQVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 12:21:31 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] media: staging: tegra-vde: Replace debug messages with trace points
Date: Sat,  7 Jul 2018 19:20:49 +0300
Message-Id: <20180707162049.20407-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trace points are much more efficient than debug messages for extensive
tracing and could be conveniently enabled / disabled dynamically, hence
let's replace debug messages with the trace points.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 221 +++++++++++---------
 drivers/staging/media/tegra-vde/trace.h     | 101 +++++++++
 2 files changed, 227 insertions(+), 95 deletions(-)
 create mode 100644 drivers/staging/media/tegra-vde/trace.h

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 6f06061a40d9..3f71b46d287b 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -24,6 +24,8 @@
 
 #include <soc/tegra/pmc.h>
 
+#define CREATE_TRACE_POINTS
+#include "trace.h"
 #include "uapi.h"
 
 #define ICMDQUE_WR		0x00
@@ -35,14 +37,6 @@
 #define BSE_ICMDQUE_EMPTY	BIT(3)
 #define BSE_DMA_BUSY		BIT(23)
 
-#define VDE_WR(__data, __addr)				\
-do {							\
-	dev_dbg(vde->miscdev.parent,			\
-		"%s: %d: 0x%08X => " #__addr ")\n",	\
-		__func__, __LINE__, (u32)(__data));	\
-	writel_relaxed(__data, __addr);			\
-} while (0)
-
 struct video_frame {
 	struct dma_buf_attachment *y_dmabuf_attachment;
 	struct dma_buf_attachment *cb_dmabuf_attachment;
@@ -81,12 +75,63 @@ struct tegra_vde {
 	u32 *iram;
 };
 
+static __maybe_unused
+char const *tegra_vde_reg_base_name(struct tegra_vde *vde, void __iomem *base)
+{
+	if (vde->sxe == base)
+		return "SXE";
+
+	if (vde->bsev == base)
+		return "BSEV";
+
+	if (vde->mbe == base)
+		return "MBE";
+
+	if (vde->ppe == base)
+		return "PPE";
+
+	if (vde->mce == base)
+		return "MCE";
+
+	if (vde->tfe == base)
+		return "TFE";
+
+	if (vde->ppb == base)
+		return "PPB";
+
+	if (vde->vdma == base)
+		return "VDMA";
+
+	if (vde->frameid == base)
+		return "FRAMEID";
+
+	return "???";
+}
+
+static void tegra_vde_writel(struct tegra_vde *vde,
+			     u32 value, void __iomem *base, u32 offset)
+{
+	trace_vde_writel(vde, base, offset, value);
+
+	writel_relaxed(value, base + offset);
+}
+
+static u32 tegra_vde_readl(struct tegra_vde *vde,
+			   void __iomem *base, u32 offset)
+{
+	u32 value = readl_relaxed(base + offset);
+
+	trace_vde_readl(vde, base, offset, value);
+
+	return value;
+}
+
 static void tegra_vde_set_bits(struct tegra_vde *vde,
-			       u32 mask, void __iomem *regs)
+			       u32 mask, void __iomem *base, u32 offset)
 {
-	u32 value = readl_relaxed(regs);
+	u32 value = tegra_vde_readl(vde, base, offset);
 
-	VDE_WR(value | mask, regs);
+	tegra_vde_writel(vde, value | mask, base, offset);
 }
 
 static int tegra_vde_wait_mbe(struct tegra_vde *vde)
@@ -107,8 +152,8 @@ static int tegra_vde_setup_mbe_frame_idx(struct tegra_vde *vde,
 	unsigned int idx;
 	int err;
 
-	VDE_WR(0xD0000000 | (0 << 23), vde->mbe + 0x80);
-	VDE_WR(0xD0200000 | (0 << 23), vde->mbe + 0x80);
+	tegra_vde_writel(vde, 0xD0000000 | (0 << 23), vde->mbe, 0x80);
+	tegra_vde_writel(vde, 0xD0200000 | (0 << 23), vde->mbe, 0x80);
 
 	err = tegra_vde_wait_mbe(vde);
 	if (err)
@@ -118,8 +163,10 @@ static int tegra_vde_setup_mbe_frame_idx(struct tegra_vde *vde,
 		return 0;
 
 	for (idx = 0, frame_idx = 1; idx < refs_nb; idx++, frame_idx++) {
-		VDE_WR(0xD0000000 | (frame_idx << 23), vde->mbe + 0x80);
-		VDE_WR(0xD0200000 | (frame_idx << 23), vde->mbe + 0x80);
+		tegra_vde_writel(vde, 0xD0000000 | (frame_idx << 23),
+				 vde->mbe, 0x80);
+		tegra_vde_writel(vde, 0xD0200000 | (frame_idx << 23),
+				 vde->mbe, 0x80);
 
 		frame_idx_enb_mask |= frame_idx << (6 * (idx % 4));
 
@@ -128,7 +175,7 @@ static int tegra_vde_setup_mbe_frame_idx(struct tegra_vde *vde,
 			value |= (idx >> 2) << 24;
 			value |= frame_idx_enb_mask;
 
-			VDE_WR(value, vde->mbe + 0x80);
+			tegra_vde_writel(vde, value, vde->mbe, 0x80);
 
 			err = tegra_vde_wait_mbe(vde);
 			if (err)
@@ -143,8 +190,10 @@ static int tegra_vde_setup_mbe_frame_idx(struct tegra_vde *vde,
 
 static void tegra_vde_mbe_set_0xa_reg(struct tegra_vde *vde, int reg, u32 val)
 {
-	VDE_WR(0xA0000000 | (reg << 24) | (val & 0xFFFF), vde->mbe + 0x80);
-	VDE_WR(0xA0000000 | ((reg + 1) << 24) | (val >> 16), vde->mbe + 0x80);
+	tegra_vde_writel(vde, 0xA0000000 | (reg << 24) | (val & 0xFFFF),
+			 vde->mbe, 0x80);
+	tegra_vde_writel(vde, 0xA0000000 | ((reg + 1) << 24) | (val >> 16),
+			 vde->mbe, 0x80);
 }
 
 static int tegra_vde_wait_bsev(struct tegra_vde *vde, bool wait_dma)
@@ -183,7 +232,7 @@ static int tegra_vde_wait_bsev(struct tegra_vde *vde, bool wait_dma)
 static int tegra_vde_push_to_bsev_icmdqueue(struct tegra_vde *vde,
 					    u32 value, bool wait_dma)
 {
-	VDE_WR(value, vde->bsev + ICMDQUE_WR);
+	tegra_vde_writel(vde, value, vde->bsev, ICMDQUE_WR);
 
 	return tegra_vde_wait_bsev(vde, wait_dma);
 }
@@ -199,11 +248,11 @@ static void tegra_vde_setup_frameid(struct tegra_vde *vde,
 	u32 value1 = frame ? ((mbs_width << 16) | mbs_height) : 0;
 	u32 value2 = frame ? ((((mbs_width + 1) >> 1) << 6) | 1) : 0;
 
-	VDE_WR(y_addr  >> 8, vde->frameid + 0x000 + frameid * 4);
-	VDE_WR(cb_addr >> 8, vde->frameid + 0x100 + frameid * 4);
-	VDE_WR(cr_addr >> 8, vde->frameid + 0x180 + frameid * 4);
-	VDE_WR(value1,       vde->frameid + 0x080 + frameid * 4);
-	VDE_WR(value2,       vde->frameid + 0x280 + frameid * 4);
+	tegra_vde_writel(vde, y_addr  >> 8, vde->frameid, 0x000 + frameid * 4);
+	tegra_vde_writel(vde, cb_addr >> 8, vde->frameid, 0x100 + frameid * 4);
+	tegra_vde_writel(vde, cr_addr >> 8, vde->frameid, 0x180 + frameid * 4);
+	tegra_vde_writel(vde, value1,       vde->frameid, 0x080 + frameid * 4);
+	tegra_vde_writel(vde, value2,       vde->frameid, 0x280 + frameid * 4);
 }
 
 static void tegra_setup_frameidx(struct tegra_vde *vde,
@@ -228,8 +277,7 @@ static void tegra_vde_setup_iram_entry(struct tegra_vde *vde,
 {
 	u32 *iram_tables = vde->iram;
 
-	dev_dbg(vde->miscdev.parent, "IRAM table %u: row %u: 0x%08X 0x%08X\n",
-		table, row, value1, value2);
+	trace_vde_setup_iram_entry(table, row, value1, value2);
 
 	iram_tables[0x20 * table + row * 2] = value1;
 	iram_tables[0x20 * table + row * 2 + 1] = value2;
@@ -245,10 +293,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 	int with_later_poc_nb;
 	unsigned int i, k;
 
-	dev_dbg(vde->miscdev.parent, "DPB: Frame 0: frame_num = %d\n",
-		dpb_frames[0].frame_num);
-
-	dev_dbg(vde->miscdev.parent, "REF L0:\n");
+	trace_vde_ref_l0(dpb_frames[0].frame_num);
 
 	for (i = 0; i < 16; i++) {
 		if (i < ref_frames_nb) {
@@ -260,11 +305,6 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 			value |= !(frame->flags & FLAG_B_FRAME) << 25;
 			value |= 1 << 24;
 			value |= frame->frame_num;
-
-			dev_dbg(vde->miscdev.parent,
-				"\tFrame %d: frame_num = %d B_frame = %d\n",
-				i + 1, frame->frame_num,
-				(frame->flags & FLAG_B_FRAME));
 		} else {
 			aux_addr = 0x6ADEAD00;
 			value = 0;
@@ -284,9 +324,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 
 	with_later_poc_nb = ref_frames_nb - with_earlier_poc_nb;
 
-	dev_dbg(vde->miscdev.parent,
-		"REF L1: with_later_poc_nb %d with_earlier_poc_nb %d\n",
-		 with_later_poc_nb, with_earlier_poc_nb);
+	trace_vde_ref_l1(with_later_poc_nb, with_earlier_poc_nb);
 
 	for (i = 0, k = with_earlier_poc_nb; i < with_later_poc_nb; i++, k++) {
 		frame = &dpb_frames[k + 1];
@@ -298,10 +336,6 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 		value |= 1 << 24;
 		value |= frame->frame_num;
 
-		dev_dbg(vde->miscdev.parent,
-			"\tFrame %d: frame_num = %d\n",
-			k + 1, frame->frame_num);
-
 		tegra_vde_setup_iram_entry(vde, 2, i, value, aux_addr);
 	}
 
@@ -315,10 +349,6 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 		value |= 1 << 24;
 		value |= frame->frame_num;
 
-		dev_dbg(vde->miscdev.parent,
-			"\tFrame %d: frame_num = %d\n",
-			k + 1, frame->frame_num);
-
 		tegra_vde_setup_iram_entry(vde, 2, i, value, aux_addr);
 	}
 }
@@ -334,32 +364,32 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	u32 value;
 	int err;
 
-	tegra_vde_set_bits(vde, 0x000A, vde->sxe + 0xF0);
-	tegra_vde_set_bits(vde, 0x000B, vde->bsev + CMDQUE_CONTROL);
-	tegra_vde_set_bits(vde, 0x8002, vde->mbe + 0x50);
-	tegra_vde_set_bits(vde, 0x000A, vde->mbe + 0xA0);
-	tegra_vde_set_bits(vde, 0x000A, vde->ppe + 0x14);
-	tegra_vde_set_bits(vde, 0x000A, vde->ppe + 0x28);
-	tegra_vde_set_bits(vde, 0x0A00, vde->mce + 0x08);
-	tegra_vde_set_bits(vde, 0x000A, vde->tfe + 0x00);
-	tegra_vde_set_bits(vde, 0x0005, vde->vdma + 0x04);
-
-	VDE_WR(0x00000000, vde->vdma + 0x1C);
-	VDE_WR(0x00000000, vde->vdma + 0x00);
-	VDE_WR(0x00000007, vde->vdma + 0x04);
-	VDE_WR(0x00000007, vde->frameid + 0x200);
-	VDE_WR(0x00000005, vde->tfe + 0x04);
-	VDE_WR(0x00000000, vde->mbe + 0x84);
-	VDE_WR(0x00000010, vde->sxe + 0x08);
-	VDE_WR(0x00000150, vde->sxe + 0x54);
-	VDE_WR(0x0000054C, vde->sxe + 0x58);
-	VDE_WR(0x00000E34, vde->sxe + 0x5C);
-	VDE_WR(0x063C063C, vde->mce + 0x10);
-	VDE_WR(0x0003FC00, vde->bsev + INTR_STATUS);
-	VDE_WR(0x0000150D, vde->bsev + BSE_CONFIG);
-	VDE_WR(0x00000100, vde->bsev + BSE_INT_ENB);
-	VDE_WR(0x00000000, vde->bsev + 0x98);
-	VDE_WR(0x00000060, vde->bsev + 0x9C);
+	tegra_vde_set_bits(vde, 0x000A, vde->sxe, 0xF0);
+	tegra_vde_set_bits(vde, 0x000B, vde->bsev, CMDQUE_CONTROL);
+	tegra_vde_set_bits(vde, 0x8002, vde->mbe, 0x50);
+	tegra_vde_set_bits(vde, 0x000A, vde->mbe, 0xA0);
+	tegra_vde_set_bits(vde, 0x000A, vde->ppe, 0x14);
+	tegra_vde_set_bits(vde, 0x000A, vde->ppe, 0x28);
+	tegra_vde_set_bits(vde, 0x0A00, vde->mce, 0x08);
+	tegra_vde_set_bits(vde, 0x000A, vde->tfe, 0x00);
+	tegra_vde_set_bits(vde, 0x0005, vde->vdma, 0x04);
+
+	tegra_vde_writel(vde, 0x00000000, vde->vdma, 0x1C);
+	tegra_vde_writel(vde, 0x00000000, vde->vdma, 0x00);
+	tegra_vde_writel(vde, 0x00000007, vde->vdma, 0x04);
+	tegra_vde_writel(vde, 0x00000007, vde->frameid, 0x200);
+	tegra_vde_writel(vde, 0x00000005, vde->tfe, 0x04);
+	tegra_vde_writel(vde, 0x00000000, vde->mbe, 0x84);
+	tegra_vde_writel(vde, 0x00000010, vde->sxe, 0x08);
+	tegra_vde_writel(vde, 0x00000150, vde->sxe, 0x54);
+	tegra_vde_writel(vde, 0x0000054C, vde->sxe, 0x58);
+	tegra_vde_writel(vde, 0x00000E34, vde->sxe, 0x5C);
+	tegra_vde_writel(vde, 0x063C063C, vde->mce, 0x10);
+	tegra_vde_writel(vde, 0x0003FC00, vde->bsev, INTR_STATUS);
+	tegra_vde_writel(vde, 0x0000150D, vde->bsev, BSE_CONFIG);
+	tegra_vde_writel(vde, 0x00000100, vde->bsev, BSE_INT_ENB);
+	tegra_vde_writel(vde, 0x00000000, vde->bsev, 0x98);
+	tegra_vde_writel(vde, 0x00000060, vde->bsev, 0x9C);
 
 	memset(vde->iram + 128, 0, macroblocks_nb / 2);
 
@@ -376,13 +406,13 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	 */
 	wmb();
 
-	VDE_WR(0x00000000, vde->bsev + 0x8C);
-	VDE_WR(bitstream_data_addr + bitstream_data_size,
-	       vde->bsev + 0x54);
+	tegra_vde_writel(vde, 0x00000000, vde->bsev, 0x8C);
+	tegra_vde_writel(vde, bitstream_data_addr + bitstream_data_size,
+			 vde->bsev, 0x54);
 
 	value = ctx->pic_width_in_mbs << 11 | ctx->pic_height_in_mbs << 3;
 
-	VDE_WR(value, vde->bsev + 0x88);
+	tegra_vde_writel(vde, value, vde->bsev, 0x88);
 
 	err = tegra_vde_wait_bsev(vde, false);
 	if (err)
@@ -417,7 +447,7 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	value |= ctx->pic_width_in_mbs << 11;
 	value |= ctx->pic_height_in_mbs << 3;
 
-	VDE_WR(value, vde->sxe + 0x10);
+	tegra_vde_writel(vde, value, vde->sxe, 0x10);
 
 	value = !ctx->baseline_profile << 17;
 	value |= ctx->level_idc << 13;
@@ -425,54 +455,54 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	value |= ctx->pic_order_cnt_type << 5;
 	value |= ctx->log2_max_frame_num;
 
-	VDE_WR(value, vde->sxe + 0x40);
+	tegra_vde_writel(vde, value, vde->sxe, 0x40);
 
 	value = ctx->pic_init_qp << 25;
 	value |= !!(ctx->deblocking_filter_control_present_flag) << 2;
 	value |= !!ctx->pic_order_present_flag;
 
-	VDE_WR(value, vde->sxe + 0x44);
+	tegra_vde_writel(vde, value, vde->sxe, 0x44);
 
 	value = ctx->chroma_qp_index_offset;
 	value |= ctx->num_ref_idx_l0_active_minus1 << 5;
 	value |= ctx->num_ref_idx_l1_active_minus1 << 10;
 	value |= !!ctx->constrained_intra_pred_flag << 15;
 
-	VDE_WR(value, vde->sxe + 0x48);
+	tegra_vde_writel(vde, value, vde->sxe, 0x48);
 
 	value = 0x0C000000;
 	value |= !!(dpb_frames[0].flags & FLAG_B_FRAME) << 24;
 
-	VDE_WR(value, vde->sxe + 0x4C);
+	tegra_vde_writel(vde, value, vde->sxe, 0x4C);
 
 	value = 0x03800000;
 	value |= bitstream_data_size & GENMASK(19, 15);
 
-	VDE_WR(value, vde->sxe + 0x68);
+	tegra_vde_writel(vde, value, vde->sxe, 0x68);
 
-	VDE_WR(bitstream_data_addr, vde->sxe + 0x6C);
+	tegra_vde_writel(vde, bitstream_data_addr, vde->sxe, 0x6C);
 
 	value = 0x10000005;
 	value |= ctx->pic_width_in_mbs << 11;
 	value |= ctx->pic_height_in_mbs << 3;
 
-	VDE_WR(value, vde->mbe + 0x80);
+	tegra_vde_writel(vde, value, vde->mbe, 0x80);
 
 	value = 0x26800000;
 	value |= ctx->level_idc << 4;
 	value |= !ctx->baseline_profile << 1;
 	value |= !!ctx->direct_8x8_inference_flag;
 
-	VDE_WR(value, vde->mbe + 0x80);
+	tegra_vde_writel(vde, value, vde->mbe, 0x80);
 
-	VDE_WR(0xF4000001, vde->mbe + 0x80);
-	VDE_WR(0x20000000, vde->mbe + 0x80);
-	VDE_WR(0xF4000101, vde->mbe + 0x80);
+	tegra_vde_writel(vde, 0xF4000001, vde->mbe, 0x80);
+	tegra_vde_writel(vde, 0x20000000, vde->mbe, 0x80);
+	tegra_vde_writel(vde, 0xF4000101, vde->mbe, 0x80);
 
 	value = 0x20000000;
 	value |= ctx->chroma_qp_index_offset << 8;
 
-	VDE_WR(value, vde->mbe + 0x80);
+	tegra_vde_writel(vde, value, vde->mbe, 0x80);
 
 	err = tegra_vde_setup_mbe_frame_idx(vde,
 					    ctx->dpb_frames_nb - 1,
@@ -494,7 +524,7 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	if (!ctx->baseline_profile)
 		value |= !!(dpb_frames[0].flags & FLAG_REFERENCE) << 1;
 
-	VDE_WR(value, vde->mbe + 0x80);
+	tegra_vde_writel(vde, value, vde->mbe, 0x80);
 
 	err = tegra_vde_wait_mbe(vde);
 	if (err) {
@@ -510,8 +540,9 @@ static void tegra_vde_decode_frame(struct tegra_vde *vde,
 {
 	reinit_completion(&vde->decode_completion);
 
-	VDE_WR(0x00000001, vde->bsev + 0x8C);
-	VDE_WR(0x20000000 | (macroblocks_nb - 1), vde->sxe + 0x00);
+	tegra_vde_writel(vde, 0x00000001, vde->bsev, 0x8C);
+	tegra_vde_writel(vde, 0x20000000 | (macroblocks_nb - 1),
+			 vde->sxe, 0x00);
 }
 
 static void tegra_vde_detach_and_put_dmabuf(struct dma_buf_attachment *a,
@@ -883,8 +914,8 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	timeout = wait_for_completion_interruptible_timeout(
 			&vde->decode_completion, msecs_to_jiffies(1000));
 	if (timeout == 0) {
-		bsev_ptr = readl_relaxed(vde->bsev + 0x10);
-		macroblocks_nb = readl_relaxed(vde->sxe + 0xC8) & 0x1FFF;
+		bsev_ptr = tegra_vde_readl(vde, vde->bsev, 0x10);
+		macroblocks_nb = tegra_vde_readl(vde, vde->sxe, 0xC8) & 0x1FFF;
 		read_bytes = bsev_ptr ? bsev_ptr - bitstream_data_addr : 0;
 
 		dev_err(dev, "Decoding failed: read 0x%X bytes, %u macroblocks parsed\n",
@@ -962,7 +993,7 @@ static irqreturn_t tegra_vde_isr(int irq, void *data)
 	if (completion_done(&vde->decode_completion))
 		return IRQ_NONE;
 
-	tegra_vde_set_bits(vde, 0, vde->frameid + 0x208);
+	tegra_vde_set_bits(vde, 0, vde->frameid, 0x208);
 	complete(&vde->decode_completion);
 
 	return IRQ_HANDLED;
diff --git a/drivers/staging/media/tegra-vde/trace.h b/drivers/staging/media/tegra-vde/trace.h
new file mode 100644
index 000000000000..9fef8c0f6a9b
--- /dev/null
+++ b/drivers/staging/media/tegra-vde/trace.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM tegra_vde
+
+#if !defined(TEGRA_VDE_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define TEGRA_VDE_TRACE_H
+
+#include <linux/tracepoint.h>
+
+struct tegra_vde;
+
+static char const *tegra_vde_reg_base_name(struct tegra_vde *vde,
+					   void __iomem *base);
+
+DECLARE_EVENT_CLASS(register_access,
+	TP_PROTO(struct tegra_vde *vde, void __iomem *base,
+		 u32 offset, u32 value),
+	TP_ARGS(vde, base, offset, value),
+	TP_STRUCT__entry(
+		__field(struct tegra_vde *, vde)
+		__field(void __iomem *, base)
+		__field(u32, offset)
+		__field(u32, value)
+	),
+	TP_fast_assign(
+		__entry->vde = vde;
+		__entry->base = base;
+		__entry->offset = offset;
+		__entry->value = value;
+	),
+	TP_printk("%s:0x%03x 0x%08x",
+		  tegra_vde_reg_base_name(__entry->vde, __entry->base),
+		  __entry->offset, __entry->value)
+);
+
+DEFINE_EVENT(register_access, vde_writel,
+	TP_PROTO(struct tegra_vde *vde, void __iomem *base,
+		 u32 offset, u32 value),
+	TP_ARGS(vde, base, offset, value));
+DEFINE_EVENT(register_access, vde_readl,
+	TP_PROTO(struct tegra_vde *vde, void __iomem *base,
+		 u32 offset, u32 value),
+	TP_ARGS(vde, base, offset, value));
+
+TRACE_EVENT(vde_setup_iram_entry,
+	TP_PROTO(unsigned int table, unsigned int row, u32 value, u32 aux_addr),
+	TP_ARGS(table, row, value, aux_addr),
+	TP_STRUCT__entry(
+		__field(unsigned int, table)
+		__field(unsigned int, row)
+		__field(u32, value)
+		__field(u32, aux_addr)
+	),
+	TP_fast_assign(
+		__entry->table = table;
+		__entry->row = row;
+		__entry->value = value;
+		__entry->aux_addr = aux_addr;
+	),
+	TP_printk("[%u][%u] = { 0x%08x (flags = \"%s\", frame_num = %u); 0x%08x }",
+		  __entry->table, __entry->row, __entry->value,
+		  __print_flags(__entry->value, " ", { (1 << 25), "B" }),
+		  __entry->value & 0x7FFFFF, __entry->aux_addr)
+);
+
+TRACE_EVENT(vde_ref_l0,
+	TP_PROTO(unsigned int frame_num),
+	TP_ARGS(frame_num),
+	TP_STRUCT__entry(
+		__field(unsigned int, frame_num)
+	),
+	TP_fast_assign(
+		__entry->frame_num = frame_num;
+	),
+	TP_printk("REF L0: DPB: Frame 0: frame_num = %u", __entry->frame_num)
+);
+
+TRACE_EVENT(vde_ref_l1,
+	TP_PROTO(unsigned int with_later_poc_nb,
+		 unsigned int with_earlier_poc_nb),
+	TP_ARGS(with_later_poc_nb, with_earlier_poc_nb),
+	TP_STRUCT__entry(
+		__field(unsigned int, with_later_poc_nb)
+		__field(unsigned int, with_earlier_poc_nb)
+	),
+	TP_fast_assign(
+		__entry->with_later_poc_nb = with_later_poc_nb;
+		__entry->with_earlier_poc_nb = with_earlier_poc_nb;
+	),
+	TP_printk("REF L1: with_later_poc_nb %u, with_earlier_poc_nb %u",
+		  __entry->with_later_poc_nb, __entry->with_earlier_poc_nb)
+);
+
+#endif /* TEGRA_VDE_TRACE_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/staging/media/tegra-vde
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 
2.18.0
