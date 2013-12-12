Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58630 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3LLIgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:33 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 4/8] v4l: ti-vpe: enable basic scaler support
Date: Thu, 12 Dec 2013 14:06:00 +0530
Message-ID: <1386837364-1264-5-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the required SC register configurations which lets us perform linear scaling
for the supported range of horizontal and vertical scaling ratios.

The horizontal scaler performs polyphase scaling using it's 8 tap 32 phase
filter, decimation is performed when downscaling passes beyond 2x or 4x.

The vertical scaler performs polyphase scaling using it's 5 tap 32 phase filter,
it switches to a simpler form of scaling using the running average filter when
the downscale ratio is more than 4x.

Many of the SC features like peaking, trimming and non-linear scaling aren't
implemented for now. Only the minimal register fields required for basic scaling
operation are configured.

The function to configure SC registers takes the sc_data handle, the source and
destination widths and heights, and the scaler address data block offsets for
the current context so that they can be configured.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/sc.c  | 132 ++++++++++++++++++++++++++++++++++--
 drivers/media/platform/ti-vpe/sc.h  |   4 +-
 drivers/media/platform/ti-vpe/vpe.c |  24 +++++--
 3 files changed, 149 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
index 417feb9..93f0af54 100644
--- a/drivers/media/platform/ti-vpe/sc.c
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -20,11 +20,6 @@
 #include "sc.h"
 #include "sc_coeff.h"
 
-void sc_set_regs_bypass(struct sc_data *sc, u32 *sc_reg0)
-{
-	*sc_reg0 |= CFG_SC_BYPASS;
-}
-
 void sc_dump_regs(struct sc_data *sc)
 {
 	struct device *dev = &sc->pdev->dev;
@@ -159,6 +154,133 @@ void sc_set_vs_coeffs(struct sc_data *sc, void *addr, unsigned int src_h,
 	sc->load_coeff_v = true;
 }
 
+void sc_config_scaler(struct sc_data *sc, u32 *sc_reg0, u32 *sc_reg8,
+		u32 *sc_reg17, unsigned int src_w, unsigned int src_h,
+		unsigned int dst_w, unsigned int dst_h)
+{
+	struct device *dev = &sc->pdev->dev;
+	u32 val;
+	int dcm_x, dcm_shift;
+	bool use_rav;
+	unsigned long lltmp;
+	u32 lin_acc_inc, lin_acc_inc_u;
+	u32 col_acc_offset;
+	u16 factor = 0;
+	int row_acc_init_rav = 0, row_acc_init_rav_b = 0;
+	u32 row_acc_inc = 0, row_acc_offset = 0, row_acc_offset_b = 0;
+	/*
+	 * location of SC register in payload memory with respect to the first
+	 * register in the mmr address data block
+	 */
+	u32 *sc_reg9 = sc_reg8 + 1;
+	u32 *sc_reg12 = sc_reg8 + 4;
+	u32 *sc_reg13 = sc_reg8 + 5;
+	u32 *sc_reg24 = sc_reg17 + 7;
+
+	val = sc_reg0[0];
+
+	/* clear all the features(they may get enabled elsewhere later) */
+	val &= ~(CFG_SELFGEN_FID | CFG_TRIM | CFG_ENABLE_SIN2_VER_INTP |
+		CFG_INTERLACE_I | CFG_DCM_4X | CFG_DCM_2X | CFG_AUTO_HS |
+		CFG_ENABLE_EV | CFG_USE_RAV | CFG_INVT_FID | CFG_SC_BYPASS |
+		CFG_INTERLACE_O | CFG_Y_PK_EN | CFG_HP_BYPASS | CFG_LINEAR);
+
+	if (src_w == dst_w && src_h == dst_h) {
+		val |= CFG_SC_BYPASS;
+		sc_reg0[0] = val;
+		return;
+	}
+
+	/* we only support linear scaling for now */
+	val |= CFG_LINEAR;
+
+	/* configure horizontal scaler */
+
+	/* enable 2X or 4X decimation */
+	dcm_x = src_w / dst_w;
+	if (dcm_x > 4) {
+		val |= CFG_DCM_4X;
+		dcm_shift = 2;
+	} else if (dcm_x > 2) {
+		val |= CFG_DCM_2X;
+		dcm_shift = 1;
+	} else {
+		dcm_shift = 0;
+	}
+
+	lltmp = dst_w - 1;
+	lin_acc_inc = div64_u64(((u64)(src_w >> dcm_shift) - 1) << 24, lltmp);
+	lin_acc_inc_u = 0;
+	col_acc_offset = 0;
+
+	dev_dbg(dev, "hs config: src_w = %d, dst_w = %d, decimation = %s, lin_acc_inc = %08x\n",
+		src_w, dst_w, dcm_shift == 2 ? "4x" :
+		(dcm_shift == 1 ? "2x" : "none"), lin_acc_inc);
+
+	/* configure vertical scaler */
+
+	/* use RAV for vertical scaler if vertical downscaling is > 4x */
+	if (dst_h < (src_h >> 2)) {
+		use_rav = true;
+		val |= CFG_USE_RAV;
+	} else {
+		use_rav = false;
+	}
+
+	if (use_rav) {
+		/* use RAV */
+		factor = (u16) ((dst_h << 10) / src_h);
+
+		row_acc_init_rav = factor + ((1 + factor) >> 1);
+		if (row_acc_init_rav >= 1024)
+			row_acc_init_rav -= 1024;
+
+		row_acc_init_rav_b = row_acc_init_rav +
+				(1 + (row_acc_init_rav >> 1)) -
+				(1024 >> 1);
+
+		if (row_acc_init_rav_b < 0) {
+			row_acc_init_rav_b += row_acc_init_rav;
+			row_acc_init_rav *= 2;
+		}
+
+		dev_dbg(dev, "vs config(RAV): src_h = %d, dst_h = %d, factor = %d, acc_init = %08x, acc_init_b = %08x\n",
+			src_h, dst_h, factor, row_acc_init_rav,
+			row_acc_init_rav_b);
+	} else {
+		/* use polyphase */
+		row_acc_inc = ((src_h - 1) << 16) / (dst_h - 1);
+		row_acc_offset = 0;
+		row_acc_offset_b = 0;
+
+		dev_dbg(dev, "vs config(POLY): src_h = %d, dst_h = %d,row_acc_inc = %08x\n",
+			src_h, dst_h, row_acc_inc);
+	}
+
+
+	sc_reg0[0] = val;
+	sc_reg0[1] = row_acc_inc;
+	sc_reg0[2] = row_acc_offset;
+	sc_reg0[3] = row_acc_offset_b;
+
+	sc_reg0[4] = ((lin_acc_inc_u & CFG_LIN_ACC_INC_U_MASK) <<
+			CFG_LIN_ACC_INC_U_SHIFT) | (dst_w << CFG_TAR_W_SHIFT) |
+			(dst_h << CFG_TAR_H_SHIFT);
+
+	sc_reg0[5] = (src_w << CFG_SRC_W_SHIFT) | (src_h << CFG_SRC_H_SHIFT);
+
+	sc_reg0[6] = (row_acc_init_rav_b << CFG_ROW_ACC_INIT_RAV_B_SHIFT) |
+		(row_acc_init_rav << CFG_ROW_ACC_INIT_RAV_SHIFT);
+
+	*sc_reg9 = lin_acc_inc;
+
+	*sc_reg12 = col_acc_offset << CFG_COL_ACC_OFFSET_SHIFT;
+
+	*sc_reg13 = factor;
+
+	*sc_reg24 = (src_w << CFG_ORG_W_SHIFT) | (src_h << CFG_ORG_H_SHIFT);
+}
+
 struct sc_data *sc_create(struct platform_device *pdev)
 {
 	struct sc_data *sc;
diff --git a/drivers/media/platform/ti-vpe/sc.h b/drivers/media/platform/ti-vpe/sc.h
index c89f3d1..60e411e 100644
--- a/drivers/media/platform/ti-vpe/sc.h
+++ b/drivers/media/platform/ti-vpe/sc.h
@@ -195,12 +195,14 @@ struct sc_data {
 	struct platform_device *pdev;
 };
 
-void sc_set_regs_bypass(struct sc_data *sc, u32 *sc_reg0);
 void sc_dump_regs(struct sc_data *sc);
 void sc_set_hs_coeffs(struct sc_data *sc, void *addr, unsigned int src_w,
 		unsigned int dst_w);
 void sc_set_vs_coeffs(struct sc_data *sc, void *addr, unsigned int src_h,
 		unsigned int dst_h);
+void sc_config_scaler(struct sc_data *sc, u32 *sc_reg0, u32 *sc_reg8,
+		u32 *sc_reg17, unsigned int src_w, unsigned int src_h,
+		unsigned int dst_w, unsigned int dst_h);
 struct sc_data *sc_create(struct platform_device *pdev);
 
 #endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 50d6d0e..dc2b94c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -440,9 +440,15 @@ struct vpe_mmr_adb {
 	u32			us3_regs[8];
 	struct vpdma_adb_hdr	dei_hdr;
 	u32			dei_regs[8];
-	struct vpdma_adb_hdr	sc_hdr;
-	u32			sc_regs[1];
-	u32			sc_pad[3];
+	struct vpdma_adb_hdr	sc_hdr0;
+	u32			sc_regs0[7];
+	u32			sc_pad0[1];
+	struct vpdma_adb_hdr	sc_hdr8;
+	u32			sc_regs8[6];
+	u32			sc_pad8[2];
+	struct vpdma_adb_hdr	sc_hdr17;
+	u32			sc_regs17[9];
+	u32			sc_pad17[3];
 	struct vpdma_adb_hdr	csc_hdr;
 	u32			csc_regs[6];
 	u32			csc_pad[2];
@@ -463,8 +469,12 @@ static void init_adb_hdrs(struct vpe_ctx *ctx)
 	VPE_SET_MMR_ADB_HDR(ctx, us2_hdr, us2_regs, VPE_US2_R0);
 	VPE_SET_MMR_ADB_HDR(ctx, us3_hdr, us3_regs, VPE_US3_R0);
 	VPE_SET_MMR_ADB_HDR(ctx, dei_hdr, dei_regs, VPE_DEI_FRAME_SIZE);
-	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr, sc_regs,
+	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr0, sc_regs0,
 		GET_OFFSET_TOP(ctx, ctx->dev->sc, CFG_SC0));
+	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr8, sc_regs8,
+		GET_OFFSET_TOP(ctx, ctx->dev->sc, CFG_SC8));
+	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr17, sc_regs17,
+		GET_OFFSET_TOP(ctx, ctx->dev->sc, CFG_SC17));
 	VPE_SET_MMR_ADB_HDR(ctx, csc_hdr, csc_regs, VPE_CSC_CSC00);
 };
 
@@ -810,9 +820,13 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	set_cfg_and_line_modes(ctx);
 	set_dei_regs(ctx);
 	set_csc_coeff_bypass(ctx);
+
 	sc_set_hs_coeffs(ctx->dev->sc, ctx->sc_coeff_h.addr, src_w, dst_w);
 	sc_set_vs_coeffs(ctx->dev->sc, ctx->sc_coeff_v.addr, src_h, dst_h);
-	sc_set_regs_bypass(ctx->dev->sc, &mmr_adb->sc_regs[0]);
+
+	sc_config_scaler(ctx->dev->sc, &mmr_adb->sc_regs0[0],
+		&mmr_adb->sc_regs8[0], &mmr_adb->sc_regs17[0],
+		src_w, src_h, dst_w, dst_h);
 
 	return 0;
 }
-- 
1.8.3.2

