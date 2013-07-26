Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64542 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab3GZJdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:33:02 -0400
Received: by mail-pa0-f44.google.com with SMTP id jh10so3052302pab.31
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 02:33:01 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 3/7] [media] vsp1: Rewrite the definition of registers' offset as enum and arrays
Date: Fri, 26 Jul 2013 18:32:13 +0900
Message-Id: <1374831137-9219-4-git-send-email-matsu@igel.co.jp>
In-Reply-To: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
References: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This replaces the macro definitions of register offset with
one written as enum and arrays. It could be useful for supporting
multiple versions of the H/W IP.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1.h        |   15 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |  195 ++++++++++++-
 drivers/media/platform/vsp1/vsp1_entity.c |   18 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |  450 +++++++++++++++++------------
 drivers/media/platform/vsp1/vsp1_rpf.c    |   12 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |   12 +-
 drivers/media/platform/vsp1/vsp1_video.c  |    3 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |   20 +-
 8 files changed, 501 insertions(+), 224 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 11ac94b..8db5bbb 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -55,19 +55,26 @@ struct vsp1_device {
 
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
+
+	const unsigned int *reg_offs;
 };
 
 struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1);
 void vsp1_device_put(struct vsp1_device *vsp1);
 
-static inline u32 vsp1_read(struct vsp1_device *vsp1, u32 reg)
+static inline u32 _vsp1_read(struct vsp1_device *vsp1,
+			     int reg, unsigned int off)
 {
-	return ioread32(vsp1->mmio + reg);
+	return ioread32(vsp1->mmio + vsp1->reg_offs[reg] + off);
 }
 
-static inline void vsp1_write(struct vsp1_device *vsp1, u32 reg, u32 data)
+static inline void _vsp1_write(struct vsp1_device *vsp1,
+			       int reg, unsigned int off, u32 data)
 {
-	iowrite32(data, vsp1->mmio + reg);
+	iowrite32(data, vsp1->mmio + vsp1->reg_offs[reg] + off);
 }
 
+#define vsp1_read(_dev, _reg)		_vsp1_read((_dev), (_reg), 0)
+#define vsp1_write(_dev, _reg, _dat)	_vsp1_write((_dev), (_reg), 0, (_dat))
+
 #endif /* __VSP1_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index a8c21f8..42f51d8 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -44,8 +44,8 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 			continue;
 
 		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
-		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
-		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status & mask);
+		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA0 + i);
+		vsp1_write(vsp1, VI6_WPF_IRQ_STA0 + i, ~status & mask);
 
 		if (status & VI6_WFP_IRQ_STA_FRE) {
 			vsp1_pipeline_frame_end(pipe);
@@ -266,10 +266,10 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
 
 	for (i = 0; i < vsp1->pdata->rpf_count; ++i)
-		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
+		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE0 + i, VI6_DPR_NODE_UNUSED);
 
 	for (i = 0; i < vsp1->pdata->uds_count; ++i)
-		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
+		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE0 + i, VI6_DPR_NODE_UNUSED);
 
 	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
 	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, VI6_DPR_NODE_UNUSED);
@@ -403,6 +403,191 @@ vsp1_get_platform_data(struct platform_device *pdev)
 	return pdata;
 }
 
+static const unsigned int vsp1_reg_offs[] = {
+	[VI6_CMD0]		= 0x0000,
+	[VI6_CMD1]		= 0x0000 + 1 * 4,
+	[VI6_CMD2]		= 0x0000 + 2 * 4,
+	[VI6_CMD3]		= 0x0000 + 3 * 4,
+	[VI6_CLK_DCSWT]		= 0x0018,
+	[VI6_SRESET]		= 0x0028,
+	[VI6_STATUS]		= 0x0038,
+	[VI6_WPF_IRQ_ENB0]	= 0x0048,
+	[VI6_WPF_IRQ_ENB1]	= 0x0048 + 1 * 12,
+	[VI6_WPF_IRQ_ENB2]	= 0x0048 + 2 * 12,
+	[VI6_WPF_IRQ_ENB3]	= 0x0048 + 3 * 12,
+	[VI6_WPF_IRQ_STA0]	= 0x004c,
+	[VI6_WPF_IRQ_STA1]	= 0x004c + 1 * 12,
+	[VI6_WPF_IRQ_STA2]	= 0x004c + 2 * 12,
+	[VI6_WPF_IRQ_STA3]	= 0x004c + 3 * 12,
+	[VI6_DISP_IRQ_ENB]	= 0x0078,
+	[VI6_DISP_IRQ_STA]	= 0x007c,
+	[VI6_WPF_LINE_COUNT0]	= 0x0084,
+	[VI6_WPF_LINE_COUNT1]	= 0x0084 + 1 * 4,
+	[VI6_WPF_LINE_COUNT2]	= 0x0084 + 2 * 4,
+	[VI6_WPF_LINE_COUNT3]	= 0x0084 + 3 * 4,
+
+	[VI6_DL_CTRL]		= 0x0100,
+	[VI6_DL_HDR_ADDR0]	= 0x0104,
+	[VI6_DL_HDR_ADDR1]	= 0x0104 + 1 * 4,
+	[VI6_DL_HDR_ADDR2]	= 0x0104 + 2 * 4,
+	[VI6_DL_HDR_ADDR3]	= 0x0104 + 3 * 4,
+	[VI6_DL_SWAP]		= 0x0114,
+	[VI6_DL_EXT_CTRL]	= 0x011c,
+	[VI6_DL_BODY_SIZE]	= 0x0120,
+
+	[VI6_RPF_SRC_BSIZE]	= 0x0300,
+	[VI6_RPF_SRC_ESIZE]	= 0x0304,
+	[VI6_RPF_INFMT]		= 0x0308,
+	[VI6_RPF_DSWAP]		= 0x030c,
+	[VI6_RPF_LOC]		= 0x0310,
+	[VI6_RPF_ALPH_SEL]	= 0x0314,
+	[VI6_RPF_VRTCOL_SET]	= 0x0318,
+	[VI6_RPF_MSK_CTRL]	= 0x031c,
+	[VI6_RPF_MSK_SET0]	= 0x0320,
+	[VI6_RPF_MSK_SET1]	= 0x0324,
+	[VI6_RPF_CKEY_CTRL]	= 0x0328,
+	[VI6_RPF_CKEY_SET0]	= 0x032c,
+	[VI6_RPF_CKEY_SET1]	= 0x0330,
+	[VI6_RPF_SRCM_PSTRIDE]	= 0x0334,
+	[VI6_RPF_SRCM_ASTRIDE]	= 0x0338,
+	[VI6_RPF_SRCM_ADDR_Y]	= 0x033c,
+	[VI6_RPF_SRCM_ADDR_C0]	= 0x0340,
+	[VI6_RPF_SRCM_ADDR_C1]	= 0x0344,
+	[VI6_RPF_SRCM_ADDR_AI]	= 0x0348,
+
+	[VI6_WPF_SRCRPF]	= 0x1000,
+	[VI6_WPF_HSZCLIP]	= 0x1004,
+	[VI6_WPF_VSZCLIP]	= 0x1008,
+	[VI6_WPF_OUTFMT]	= 0x100c,
+	[VI6_WPF_DSWAP]		= 0x1010,
+	[VI6_WPF_RNDCTRL]	= 0x1014,
+	[VI6_WPF_DSTM_STRIDE_Y]	= 0x101c,
+	[VI6_WPF_DSTM_STRIDE_C]	= 0x1020,
+	[VI6_WPF_DSTM_ADDR_Y]	= 0x1024,
+	[VI6_WPF_DSTM_ADDR_C0]	= 0x1028,
+	[VI6_WPF_DSTM_ADDR_C1]	= 0x102c,
+	[VI6_WPF_WRBCK_CTRL]	= 0x1034,
+
+	[VI6_DPR_RPF_ROUTE0]	= 0x2000,
+	[VI6_DPR_RPF_ROUTE1]	= 0x2000 + 1 * 4,
+	[VI6_DPR_RPF_ROUTE2]	= 0x2000 + 2 * 4,
+	[VI6_DPR_RPF_ROUTE3]	= 0x2000 + 3 * 4,
+	[VI6_DPR_RPF_ROUTE4]	= 0x2000 + 4 * 4,
+	[VI6_DPR_WPF_FPORCH0]	= 0x2014,
+	[VI6_DPR_WPF_FPORCH1]	= 0x2014 + 1 * 4,
+	[VI6_DPR_WPF_FPORCH2]	= 0x2014 + 2 * 4,
+	[VI6_DPR_WPF_FPORCH3]	= 0x2014 + 3 * 4,
+	[VI6_DPR_SRU_ROUTE]	= 0x2024,
+	[VI6_DPR_UDS_ROUTE0]	= 0x2028,
+	[VI6_DPR_UDS_ROUTE1]	= 0x2028 + 1 * 4,
+	[VI6_DPR_UDS_ROUTE2]	= 0x2028 + 2 * 4,
+	[VI6_DPR_LUT_ROUTE]	= 0x203c,
+	[VI6_DPR_CLU_ROUTE]	= 0x2040,
+	[VI6_DPR_HST_ROUTE]	= 0x2044,
+	[VI6_DPR_HSI_ROUTE]	= 0x2048,
+	[VI6_DPR_BRU_ROUTE]	= 0x204c,
+	[VI6_DPR_HGO_SMPPT]	= 0x2050,
+	[VI6_DPR_HGT_SMPPT]	= 0x2054,
+
+	[VI6_SRU_CTRL0]		= 0x2200,
+	[VI6_SRU_CTRL1]		= 0x2204,
+	[VI6_SRU_CTRL2]		= 0x2208,
+
+	[VI6_UDS_CTRL]		= 0x2300,
+	[VI6_UDS_SCALE]		= 0x2304,
+	[VI6_UDS_ALPTH]		= 0x2308,
+	[VI6_UDS_ALPVAL]	= 0x230c,
+	[VI6_UDS_PASS_BWIDTH]	= 0x2310,
+	[VI6_UDS_IPC]		= 0x2318,
+	[VI6_UDS_CLIP_SIZE]	= 0x2324,
+	[VI6_UDS_FILL_COLOR]	= 0x2328,
+
+	[VI6_LUT_CTRL]		= 0x2800,
+
+	[VI6_CLU_CTRL]		= 0x2900,
+
+	[VI6_HST_CTRL]		= 0x2a00,
+
+	[VI6_HSI_CTRL]		= 0x2b00,
+
+	[VI6_BRU_INCTRL]	= 0x2c00,
+	[VI6_BRU_VIRRPF_SIZE]	= 0x2c04,
+	[VI6_BRU_VIRRPF_LOC]	= 0x2c08,
+	[VI6_BRU_VIRRPF_COL]	= 0x2c0c,
+	[VI6_BRU_CTRLA]		= 0x2c10,
+	[VI6_BRU_CTRLB]		= 0x2c10 + 1 * 8,
+	[VI6_BRU_CTRLC]		= 0x2c10 + 2 * 8,
+	[VI6_BRU_CTRLD]		= 0x2c10 + 3 * 8,
+	[VI6_BRU_BLDA]		= 0x2c14,
+	[VI6_BRU_BLDB]		= 0x2c14 + 1 * 8,
+	[VI6_BRU_BLDC]		= 0x2c14 + 2 * 8,
+	[VI6_BRU_BLDD]		= 0x2c14 + 3 * 8,
+	[VI6_BRU_ROP]		= 0x2c30,
+
+	[VI6_HGO_OFFSET]	= 0x3000,
+	[VI6_HGO_SIZE]		= 0x3004,
+	[VI6_HGO_MODE]		= 0x3008,
+	[VI6_HGO_LB_TH]		= 0x300c,
+	[VI6_HGO_LBn_H0]	= 0x3010,
+	[VI6_HGO_LBn_H1]	= 0x3010 + 1 * 8,
+	[VI6_HGO_LBn_H2]	= 0x3010 + 2 * 8,
+	[VI6_HGO_LBn_H3]	= 0x3010 + 3 * 8,
+	[VI6_HGO_LBn_V0]	= 0x3014,
+	[VI6_HGO_LBn_V1]	= 0x3014 + 1 * 8,
+	[VI6_HGO_LBn_V2]	= 0x3014 + 2 * 8,
+	[VI6_HGO_LBn_V3]	= 0x3014 + 3 * 8,
+	[VI6_HGO_R_HISTO]	= 0x3030,
+	[VI6_HGO_R_MAXMIN]	= 0x3130,
+	[VI6_HGO_R_SUM]		= 0x3134,
+	[VI6_HGO_R_LB_DET]	= 0x3138,
+	[VI6_HGO_G_HISTO]	= 0x3140,
+	[VI6_HGO_G_MAXMIN]	= 0x3240,
+	[VI6_HGO_G_SUM]		= 0x3244,
+	[VI6_HGO_G_LB_DET]	= 0x3248,
+	[VI6_HGO_B_HISTO]	= 0x3250,
+	[VI6_HGO_B_MAXMIN]	= 0x3350,
+	[VI6_HGO_B_SUM]		= 0x3354,
+	[VI6_HGO_B_LB_DET]	= 0x3358,
+	[VI6_HGO_REGRST]	= 0x33fc,
+
+	[VI6_HGT_OFFSET]	= 0x3400,
+	[VI6_HGT_SIZE]		= 0x3404,
+	[VI6_HGT_MODE]		= 0x3408,
+	[VI6_HGT_HUE_AREA0]	= 0x340c,
+	[VI6_HGT_HUE_AREA1]	= 0x340c + 1 * 4,
+	[VI6_HGT_HUE_AREA2]	= 0x340c + 2 * 4,
+	[VI6_HGT_HUE_AREA3]	= 0x340c + 3 * 4,
+	[VI6_HGT_HUE_AREA4]	= 0x340c + 4 * 4,
+	[VI6_HGT_HUE_AREA5]	= 0x340c + 5 * 4,
+	[VI6_HGT_LB_TH]		= 0x3424,
+	[VI6_HGT_LBn_H0]	= 0x3438,
+	[VI6_HGT_LBn_H1]	= 0x3438 + 1 * 8,
+	[VI6_HGT_LBn_H2]	= 0x3438 + 2 * 8,
+	[VI6_HGT_LBn_H3]	= 0x3438 + 3 * 8,
+	[VI6_HGT_LBn_V0]	= 0x342c,
+	[VI6_HGT_LBn_V1]	= 0x342c + 1 * 8,
+	[VI6_HGT_LBn_V2]	= 0x342c + 2 * 8,
+	[VI6_HGT_LBn_V3]	= 0x342c + 3 * 8,
+	[VI6_HGT_HISTO0]	= 0x3450,
+	[VI6_HGT_MAXMIN]	= 0x3750,
+	[VI6_HGT_SUM]		= 0x3754,
+	[VI6_HGT_LB_DET]	= 0x3758,
+	[VI6_HGT_REGRST]	= 0x37fc,
+
+	[VI6_LIF_CTRL]		= 0x3b00,
+	[VI6_LIF_CSBTH]		= 0x3b04,
+
+	[VI6_SECURITY_CTRL0]	= 0x3d00,
+	[VI6_SECURITY_CTRL1]	= 0x3d04,
+
+	[VI6_CLUT_TABLE]	= 0x4000,
+
+	[VI6_LUT_TABLE]		= 0x7000,
+
+	[VI6_CLU_ADDR]		= 0x7400,
+	[VI6_CLU_DATA]		= 0x7404,
+};
+
 static int vsp1_probe(struct platform_device *pdev)
 {
 	struct vsp1_device *vsp1;
@@ -416,6 +601,8 @@ static int vsp1_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	vsp1->reg_offs = vsp1_reg_offs;
+
 	vsp1->dev = &pdev->dev;
 	mutex_init(&vsp1->lock);
 	INIT_LIST_HEAD(&vsp1->entities);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 9028f9d..b8b6257 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -120,17 +120,17 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 {
 	static const struct {
 		unsigned int id;
-		unsigned int reg;
+		int reg;
 	} routes[] = {
 		{ VI6_DPR_NODE_LIF, 0 },
-		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE(0) },
-		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE(1) },
-		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE(2) },
-		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE(3) },
-		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE(4) },
-		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE(0) },
-		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE(1) },
-		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE(2) },
+		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE0  },
+		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE0 + 1 },
+		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE0 + 2 },
+		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE0 + 3 },
+		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE0 + 4 },
+		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE0 },
+		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE0 + 1 },
+		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE0 + 2 },
 		{ VI6_DPR_NODE_WPF(0), 0 },
 		{ VI6_DPR_NODE_WPF(1), 0 },
 		{ VI6_DPR_NODE_WPF(2), 0 },
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 1d3304f..a76bc31 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -13,51 +13,303 @@
 #ifndef __VSP1_REGS_H__
 #define __VSP1_REGS_H__
 
+enum {
 /* -----------------------------------------------------------------------------
  * General Control Registers
  */
 
-#define VI6_CMD(n)			(0x0000 + (n) * 4)
+	VI6_CMD0,
+	VI6_CMD1,
+	VI6_CMD2,
+	VI6_CMD3,
+	VI6_CLK_DCSWT,
+	VI6_SRESET,
+	VI6_STATUS,
+	VI6_WPF_IRQ_ENB0,
+	VI6_WPF_IRQ_ENB1,
+	VI6_WPF_IRQ_ENB2,
+	VI6_WPF_IRQ_ENB3,
+	VI6_WPF_IRQ_STA0,
+	VI6_WPF_IRQ_STA1,
+	VI6_WPF_IRQ_STA2,
+	VI6_WPF_IRQ_STA3,
+	VI6_DISP_IRQ_ENB,
+	VI6_DISP_IRQ_STA,
+	VI6_WPF_LINE_COUNT0,
+	VI6_WPF_LINE_COUNT1,
+	VI6_WPF_LINE_COUNT2,
+	VI6_WPF_LINE_COUNT3,
+
+/* -----------------------------------------------------------------------------
+ * Display List Control Registers
+ */
+
+	VI6_DL_CTRL,
+	VI6_DL_HDR_ADDR0,
+	VI6_DL_HDR_ADDR1,
+	VI6_DL_HDR_ADDR2,
+	VI6_DL_HDR_ADDR3,
+	VI6_DL_SWAP,
+	VI6_DL_EXT_CTRL,
+	VI6_DL_BODY_SIZE,
+
+/* -----------------------------------------------------------------------------
+ * RPF Control Registers
+ */
+
+	VI6_RPF_SRC_BSIZE,
+	VI6_RPF_SRC_ESIZE,
+	VI6_RPF_INFMT,
+	VI6_RPF_DSWAP,
+	VI6_RPF_LOC,
+	VI6_RPF_ALPH_SEL,
+	VI6_RPF_VRTCOL_SET,
+	VI6_RPF_MSK_CTRL,
+	VI6_RPF_MSK_SET0,
+	VI6_RPF_MSK_SET1,
+	VI6_RPF_CKEY_CTRL,
+	VI6_RPF_CKEY_SET0,
+	VI6_RPF_CKEY_SET1,
+	VI6_RPF_SRCM_PSTRIDE,
+	VI6_RPF_SRCM_ASTRIDE,
+	VI6_RPF_SRCM_ADDR_Y,
+	VI6_RPF_SRCM_ADDR_C0,
+	VI6_RPF_SRCM_ADDR_C1,
+	VI6_RPF_SRCM_ADDR_AI,
+
+/* -----------------------------------------------------------------------------
+ * WPF Control Registers
+ */
+
+	VI6_WPF_SRCRPF,
+	VI6_WPF_HSZCLIP,
+	VI6_WPF_VSZCLIP,
+	VI6_WPF_OUTFMT,
+	VI6_WPF_DSWAP,
+	VI6_WPF_RNDCTRL,
+	VI6_WPF_DSTM_STRIDE_Y,
+	VI6_WPF_DSTM_STRIDE_C,
+	VI6_WPF_DSTM_ADDR_Y,
+	VI6_WPF_DSTM_ADDR_C0,
+	VI6_WPF_DSTM_ADDR_C1,
+	VI6_WPF_WRBCK_CTRL,
+
+/* -----------------------------------------------------------------------------
+ * DPR Control Registers
+ */
+
+	VI6_DPR_RPF_ROUTE0,
+	VI6_DPR_RPF_ROUTE1,
+	VI6_DPR_RPF_ROUTE2,
+	VI6_DPR_RPF_ROUTE3,
+	VI6_DPR_RPF_ROUTE4,
+	VI6_DPR_WPF_FPORCH0,
+	VI6_DPR_WPF_FPORCH1,
+	VI6_DPR_WPF_FPORCH2,
+	VI6_DPR_WPF_FPORCH3,
+	VI6_DPR_SRU_ROUTE,
+	VI6_DPR_UDS_ROUTE0,
+	VI6_DPR_UDS_ROUTE1,
+	VI6_DPR_UDS_ROUTE2,
+	VI6_DPR_LUT_ROUTE,
+	VI6_DPR_CLU_ROUTE,
+	VI6_DPR_HST_ROUTE,
+	VI6_DPR_HSI_ROUTE,
+	VI6_DPR_BRU_ROUTE,
+	VI6_DPR_HGO_SMPPT,
+	VI6_DPR_HGT_SMPPT,
+
+/* -----------------------------------------------------------------------------
+ * SRU Control Registers
+ */
+
+	VI6_SRU_CTRL0,
+	VI6_SRU_CTRL1,
+	VI6_SRU_CTRL2,
+
+/* -----------------------------------------------------------------------------
+ * UDS Control Registers
+ */
+
+	VI6_UDS_CTRL,
+	VI6_UDS_SCALE,
+	VI6_UDS_ALPTH,
+	VI6_UDS_ALPVAL,
+	VI6_UDS_PASS_BWIDTH,
+	VI6_UDS_IPC,
+	VI6_UDS_CLIP_SIZE,
+	VI6_UDS_FILL_COLOR,
+
+/* -----------------------------------------------------------------------------
+ * LUT Control Registers
+ */
+
+	VI6_LUT_CTRL,
+
+/* -----------------------------------------------------------------------------
+ * CLU Control Registers
+ */
+
+	VI6_CLU_CTRL,
+
+/* -----------------------------------------------------------------------------
+ * HST Control Registers
+ */
+
+	VI6_HST_CTRL,
+
+/* -----------------------------------------------------------------------------
+ * HSI Control Registers
+ */
+
+	VI6_HSI_CTRL,
+
+/* -----------------------------------------------------------------------------
+ * BRU Control Registers
+ */
+
+	VI6_BRU_INCTRL,
+	VI6_BRU_VIRRPF_SIZE,
+	VI6_BRU_VIRRPF_LOC,
+	VI6_BRU_VIRRPF_COL,
+	VI6_BRU_CTRLA,
+	VI6_BRU_CTRLB,
+	VI6_BRU_CTRLC,
+	VI6_BRU_CTRLD,
+	VI6_BRU_BLDA,
+	VI6_BRU_BLDB,
+	VI6_BRU_BLDC,
+	VI6_BRU_BLDD,
+	VI6_BRU_ROP,
+
+/* -----------------------------------------------------------------------------
+ * HGO Control Registers
+ */
+
+	VI6_HGO_OFFSET,
+	VI6_HGO_SIZE,
+	VI6_HGO_MODE,
+	VI6_HGO_LB_TH,
+	VI6_HGO_LBn_H0,
+	VI6_HGO_LBn_H1,
+	VI6_HGO_LBn_H2,
+	VI6_HGO_LBn_H3,
+	VI6_HGO_LBn_V0,
+	VI6_HGO_LBn_V1,
+	VI6_HGO_LBn_V2,
+	VI6_HGO_LBn_V3,
+	VI6_HGO_R_HISTO,
+	VI6_HGO_R_MAXMIN,
+	VI6_HGO_R_SUM,
+	VI6_HGO_R_LB_DET,
+	VI6_HGO_G_HISTO,
+	VI6_HGO_G_MAXMIN,
+	VI6_HGO_G_SUM,
+	VI6_HGO_G_LB_DET,
+	VI6_HGO_B_HISTO,
+	VI6_HGO_B_MAXMIN,
+	VI6_HGO_B_SUM,
+	VI6_HGO_B_LB_DET,
+	VI6_HGO_REGRST,
+
+/* -----------------------------------------------------------------------------
+ * HGT Control Registers
+ */
+
+	VI6_HGT_OFFSET,
+	VI6_HGT_SIZE,
+	VI6_HGT_MODE,
+	VI6_HGT_HUE_AREA0,
+	VI6_HGT_HUE_AREA1,
+	VI6_HGT_HUE_AREA2,
+	VI6_HGT_HUE_AREA3,
+	VI6_HGT_HUE_AREA4,
+	VI6_HGT_HUE_AREA5,
+	VI6_HGT_LB_TH,
+	VI6_HGT_LBn_H0,
+	VI6_HGT_LBn_H1,
+	VI6_HGT_LBn_H2,
+	VI6_HGT_LBn_H3,
+	VI6_HGT_LBn_V0,
+	VI6_HGT_LBn_V1,
+	VI6_HGT_LBn_V2,
+	VI6_HGT_LBn_V3,
+	VI6_HGT_HISTO0,
+	VI6_HGT_MAXMIN,
+	VI6_HGT_SUM,
+	VI6_HGT_LB_DET,
+	VI6_HGT_REGRST,
+
+/* -----------------------------------------------------------------------------
+ * LIF Control Registers
+ */
+
+	VI6_LIF_CTRL,
+	VI6_LIF_CSBTH,
+
+/* -----------------------------------------------------------------------------
+ * Security Control Registers
+ */
+
+	VI6_SECURITY_CTRL0,
+	VI6_SECURITY_CTRL1,
+
+/* -----------------------------------------------------------------------------
+ * RPF CLUT Registers
+ */
+
+	VI6_CLUT_TABLE,
+
+/* -----------------------------------------------------------------------------
+ * 1D LUT Registers
+ */
+
+	VI6_LUT_TABLE,
+
+/* -----------------------------------------------------------------------------
+ * 3D LUT Registers
+ */
+
+	VI6_CLU_ADDR,
+	VI6_CLU_DATA,
+};
+
+/* -----------------------------------------------------------------------------
+ * Macros for General Control Registers
+ */
+#define VI6_REG(_dev, _reg)		((_dev)->reg_offs[(_reg)])
+
 #define VI6_CMD_STRCMD			(1 << 0)
 
-#define VI6_CLK_DCSWT			0x0018
 #define VI6_CLK_DCSWT_CSTPW_MASK	(0xff << 8)
 #define VI6_CLK_DCSWT_CSTPW_SHIFT	8
 #define VI6_CLK_DCSWT_CSTRW_MASK	(0xff << 0)
 #define VI6_CLK_DCSWT_CSTRW_SHIFT	0
 
-#define VI6_SRESET			0x0028
 #define VI6_SRESET_SRTS(n)		(1 << (n))
 
-#define VI6_STATUS			0x0038
 #define VI6_STATUS_SYS_ACT(n)		(1 << ((n) + 8))
 
-#define VI6_WPF_IRQ_ENB(n)		(0x0048 + (n) * 12)
 #define VI6_WFP_IRQ_ENB_DFEE		(1 << 1)
 #define VI6_WFP_IRQ_ENB_FREE		(1 << 0)
 
-#define VI6_WPF_IRQ_STA(n)		(0x004c + (n) * 12)
 #define VI6_WFP_IRQ_STA_DFE		(1 << 1)
 #define VI6_WFP_IRQ_STA_FRE		(1 << 0)
 
-#define VI6_DISP_IRQ_ENB		0x0078
 #define VI6_DISP_IRQ_ENB_DSTE		(1 << 8)
 #define VI6_DISP_IRQ_ENB_MAEE		(1 << 5)
 #define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << ((n) + 4))
 
-#define VI6_DISP_IRQ_STA		0x007c
 #define VI6_DISP_IRQ_STA_DSE		(1 << 8)
 #define VI6_DISP_IRQ_STA_MAE		(1 << 5)
 #define VI6_DISP_IRQ_STA_LNE(n)		(1 << ((n) + 4))
 
-#define VI6_WPF_LINE_COUNT(n)		(0x0084 + (n) * 4)
 #define VI6_WPF_LINE_COUNT_MASK		(0x1fffff << 0)
 
 /* -----------------------------------------------------------------------------
  * Display List Control Registers
  */
 
-#define VI6_DL_CTRL			0x0100
 #define VI6_DL_CTRL_AR_WAIT_MASK	(0xffff << 16)
 #define VI6_DL_CTRL_AR_WAIT_SHIFT	16
 #define VI6_DL_CTRL_DC2			(1 << 12)
@@ -67,14 +319,10 @@
 #define VI6_DL_CTRL_NH0			(1 << 1)
 #define VI6_DL_CTRL_DLE			(1 << 0)
 
-#define VI6_DL_HDR_ADDR(n)		(0x0104 + (n) * 4)
-
-#define VI6_DL_SWAP			0x0114
 #define VI6_DL_SWAP_LWS			(1 << 2)
 #define VI6_DL_SWAP_WDS			(1 << 1)
 #define VI6_DL_SWAP_BTS			(1 << 0)
 
-#define VI6_DL_EXT_CTRL			0x011c
 #define VI6_DL_EXT_CTRL_NWE		(1 << 16)
 #define VI6_DL_EXT_CTRL_POLINT_MASK	(0x3f << 8)
 #define VI6_DL_EXT_CTRL_POLINT_SHIFT	8
@@ -82,7 +330,6 @@
 #define VI6_DL_EXT_CTRL_EXPRI		(1 << 4)
 #define VI6_DL_EXT_CTRL_EXT		(1 << 0)
 
-#define VI6_DL_BODY_SIZE		0x0120
 #define VI6_DL_BODY_SIZE_UPD		(1 << 24)
 #define VI6_DL_BODY_SIZE_BS_MASK	(0x1ffff << 0)
 #define VI6_DL_BODY_SIZE_BS_SHIFT	0
@@ -93,19 +340,16 @@
 
 #define VI6_RPF_OFFSET			0x100
 
-#define VI6_RPF_SRC_BSIZE		0x0300
 #define VI6_RPF_SRC_BSIZE_BHSIZE_MASK	(0x1fff << 16)
 #define VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT	16
 #define VI6_RPF_SRC_BSIZE_BVSIZE_MASK	(0x1fff << 0)
 #define VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT	0
 
-#define VI6_RPF_SRC_ESIZE		0x0304
 #define VI6_RPF_SRC_ESIZE_EHSIZE_MASK	(0x1fff << 16)
 #define VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT	16
 #define VI6_RPF_SRC_ESIZE_EVSIZE_MASK	(0x1fff << 0)
 #define VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT	0
 
-#define VI6_RPF_INFMT			0x0308
 #define VI6_RPF_INFMT_VIR		(1 << 28)
 #define VI6_RPF_INFMT_CIPM		(1 << 16)
 #define VI6_RPF_INFMT_SPYCS		(1 << 15)
@@ -123,7 +367,6 @@
 #define VI6_RPF_INFMT_RDFMT_MASK	(0x7f << 0)
 #define VI6_RPF_INFMT_RDFMT_SHIFT	0
 
-#define VI6_RPF_DSWAP			0x030c
 #define VI6_RPF_DSWAP_A_LLS		(1 << 11)
 #define VI6_RPF_DSWAP_A_LWS		(1 << 10)
 #define VI6_RPF_DSWAP_A_WDS		(1 << 9)
@@ -133,13 +376,11 @@
 #define VI6_RPF_DSWAP_P_WDS		(1 << 1)
 #define VI6_RPF_DSWAP_P_BTS		(1 << 0)
 
-#define VI6_RPF_LOC			0x0310
 #define VI6_RPF_LOC_HCOORD_MASK		(0x1fff << 16)
 #define VI6_RPF_LOC_HCOORD_SHIFT	16
 #define VI6_RPF_LOC_VCOORD_MASK		(0x1fff << 0)
 #define VI6_RPF_LOC_VCOORD_SHIFT	0
 
-#define VI6_RPF_ALPH_SEL		0x0314
 #define VI6_RPF_ALPH_SEL_ASEL_PACKED	(0 << 28)
 #define VI6_RPF_ALPH_SEL_ASEL_8B_PLANE	(1 << 28)
 #define VI6_RPF_ALPH_SEL_ASEL_SELECT	(2 << 28)
@@ -159,7 +400,6 @@
 #define VI6_RPF_ALPH_SEL_ALPHA1_MASK	(0xff << 0)
 #define VI6_RPF_ALPH_SEL_ALPHA1_SHIFT	0
 
-#define VI6_RPF_VRTCOL_SET		0x0318
 #define VI6_RPF_VRTCOL_SET_LAYA_MASK	(0xff << 24)
 #define VI6_RPF_VRTCOL_SET_LAYA_SHIFT	24
 #define VI6_RPF_VRTCOL_SET_LAYR_MASK	(0xff << 16)
@@ -169,7 +409,6 @@
 #define VI6_RPF_VRTCOL_SET_LAYB_MASK	(0xff << 0)
 #define VI6_RPF_VRTCOL_SET_LAYB_SHIFT	0
 
-#define VI6_RPF_MSK_CTRL		0x031c
 #define VI6_RPF_MSK_CTRL_MSK_EN		(1 << 24)
 #define VI6_RPF_MSK_CTRL_MGR_MASK	(0xff << 16)
 #define VI6_RPF_MSK_CTRL_MGR_SHIFT	16
@@ -178,8 +417,6 @@
 #define VI6_RPF_MSK_CTRL_MGB_MASK	(0xff << 0)
 #define VI6_RPF_MSK_CTRL_MGB_SHIFT	0
 
-#define VI6_RPF_MSK_SET0		0x0320
-#define VI6_RPF_MSK_SET1		0x0324
 #define VI6_RPF_MSK_SET_MSA_MASK	(0xff << 24)
 #define VI6_RPF_MSK_SET_MSA_SHIFT	24
 #define VI6_RPF_MSK_SET_MSR_MASK	(0xff << 16)
@@ -194,8 +431,6 @@
 #define VI6_RPF_CKEY_CTRL_SAPE1		(1 << 1)
 #define VI6_RPF_CKEY_CTRL_SAPE0		(1 << 0)
 
-#define VI6_RPF_CKEY_SET0		0x032c
-#define VI6_RPF_CKEY_SET1		0x0330
 #define VI6_RPF_CKEY_SET_AP_MASK	(0xff << 24)
 #define VI6_RPF_CKEY_SET_AP_SHIFT	24
 #define VI6_RPF_CKEY_SET_R_MASK		(0xff << 16)
@@ -205,25 +440,17 @@
 #define VI6_RPF_CKEY_SET_B_MASK		(0xff << 0)
 #define VI6_RPF_CKEY_SET_B_SHIFT	0
 
-#define VI6_RPF_SRCM_PSTRIDE		0x0334
 #define VI6_RPF_SRCM_PSTRIDE_Y_SHIFT	16
 #define VI6_RPF_SRCM_PSTRIDE_C_SHIFT	0
 
-#define VI6_RPF_SRCM_ASTRIDE		0x0338
 #define VI6_RPF_SRCM_PSTRIDE_A_SHIFT	0
 
-#define VI6_RPF_SRCM_ADDR_Y		0x033c
-#define VI6_RPF_SRCM_ADDR_C0		0x0340
-#define VI6_RPF_SRCM_ADDR_C1		0x0344
-#define VI6_RPF_SRCM_ADDR_AI		0x0348
-
 /* -----------------------------------------------------------------------------
- * WPF Control Registers
+ * Macros for WPF Control Registers
  */
 
 #define VI6_WPF_OFFSET			0x100
 
-#define VI6_WPF_SRCRPF			0x1000
 #define VI6_WPF_SRCRPF_VIRACT_DIS	(0 << 28)
 #define VI6_WPF_SRCRPF_VIRACT_SUB	(1 << 28)
 #define VI6_WPF_SRCRPF_VIRACT_MST	(2 << 28)
@@ -233,15 +460,12 @@
 #define VI6_WPF_SRCRPF_RPF_ACT_MST(n)	(2 << ((n) * 2))
 #define VI6_WPF_SRCRPF_RPF_ACT_MASK(n)	(3 << ((n) * 2))
 
-#define VI6_WPF_HSZCLIP			0x1004
-#define VI6_WPF_VSZCLIP			0x1008
 #define VI6_WPF_SZCLIP_EN		(1 << 28)
 #define VI6_WPF_SZCLIP_OFST_MASK	(0xff << 16)
 #define VI6_WPF_SZCLIP_OFST_SHIFT	16
 #define VI6_WPF_SZCLIP_SIZE_MASK	(0x1fff << 0)
 #define VI6_WPF_SZCLIP_SIZE_SHIFT	0
 
-#define VI6_WPF_OUTFMT			0x100c
 #define VI6_WPF_OUTFMT_PDV_MASK		(0xff << 24)
 #define VI6_WPF_OUTFMT_PDV_SHIFT	24
 #define VI6_WPF_OUTFMT_PXA		(1 << 23)
@@ -260,13 +484,11 @@
 #define VI6_WPF_OUTFMT_WRFMT_MASK	(0x7f << 0)
 #define VI6_WPF_OUTFMT_WRFMT_SHIFT	0
 
-#define VI6_WPF_DSWAP			0x1010
 #define VI6_WPF_DSWAP_P_LLS		(1 << 3)
 #define VI6_WPF_DSWAP_P_LWS		(1 << 2)
 #define VI6_WPF_DSWAP_P_WDS		(1 << 1)
 #define VI6_WPF_DSWAP_P_BTS		(1 << 0)
 
-#define VI6_WPF_RNDCTRL			0x1014
 #define VI6_WPF_RNDCTRL_CBRM		(1 << 28)
 #define VI6_WPF_RNDCTRL_ABRM_TRUNC	(0 << 24)
 #define VI6_WPF_RNDCTRL_ABRM_ROUND	(1 << 24)
@@ -279,31 +501,14 @@
 #define VI6_WPF_RNDCTRL_CLMD_EXT	(2 << 12)
 #define VI6_WPF_RNDCTRL_CLMD_MASK	(3 << 12)
 
-#define VI6_WPF_DSTM_STRIDE_Y		0x101c
-#define VI6_WPF_DSTM_STRIDE_C		0x1020
-#define VI6_WPF_DSTM_ADDR_Y		0x1024
-#define VI6_WPF_DSTM_ADDR_C0		0x1028
-#define VI6_WPF_DSTM_ADDR_C1		0x102c
-
-#define VI6_WPF_WRBCK_CTRL		0x1034
 #define VI6_WPF_WRBCK_CTRL_WBMD		(1 << 0)
 
 /* -----------------------------------------------------------------------------
- * DPR Control Registers
+ * Macros for DPR Control Registers
  */
 
-#define VI6_DPR_RPF_ROUTE(n)		(0x2000 + (n) * 4)
-
-#define VI6_DPR_WPF_FPORCH(n)		(0x2014 + (n) * 4)
 #define VI6_DPR_WPF_FPORCH_FP_WPFN	(5 << 8)
 
-#define VI6_DPR_SRU_ROUTE		0x2024
-#define VI6_DPR_UDS_ROUTE(n)		(0x2028 + (n) * 4)
-#define VI6_DPR_LUT_ROUTE		0x203c
-#define VI6_DPR_CLU_ROUTE		0x2040
-#define VI6_DPR_HST_ROUTE		0x2044
-#define VI6_DPR_HSI_ROUTE		0x2048
-#define VI6_DPR_BRU_ROUTE		0x204c
 #define VI6_DPR_ROUTE_FXA_MASK		(0xff << 8)
 #define VI6_DPR_ROUTE_FXA_SHIFT		16
 #define VI6_DPR_ROUTE_FP_MASK		(0xff << 8)
@@ -311,8 +516,6 @@
 #define VI6_DPR_ROUTE_RT_MASK		(0x3f << 0)
 #define VI6_DPR_ROUTE_RT_SHIFT		0
 
-#define VI6_DPR_HGO_SMPPT		0x2050
-#define VI6_DPR_HGT_SMPPT		0x2054
 #define VI6_DPR_SMPPT_TGW_MASK		(7 << 8)
 #define VI6_DPR_SMPPT_TGW_SHIFT		8
 #define VI6_DPR_SMPPT_PT_MASK		(0x3f << 0)
@@ -332,20 +535,11 @@
 #define VI6_DPR_NODE_UNUSED		63
 
 /* -----------------------------------------------------------------------------
- * SRU Control Registers
- */
-
-#define VI6_SRU_CTRL0			0x2200
-#define VI6_SRU_CTRL1			0x2204
-#define VI6_SRU_CTRL2			0x2208
-
-/* -----------------------------------------------------------------------------
- * UDS Control Registers
+ * Macros for UDS Control Registers
  */
 
 #define VI6_UDS_OFFSET			0x100
 
-#define VI6_UDS_CTRL			0x2300
 #define VI6_UDS_CTRL_AMD		(1 << 30)
 #define VI6_UDS_CTRL_FMD		(1 << 29)
 #define VI6_UDS_CTRL_BLADV		(1 << 28)
@@ -358,7 +552,6 @@
 #define VI6_UDS_CTRL_NE_BCB		(1 << 16)
 #define VI6_UDS_CTRL_TDIPC		(1 << 1)
 
-#define VI6_UDS_SCALE			0x2304
 #define VI6_UDS_SCALE_HMANT_MASK	(0xf << 28)
 #define VI6_UDS_SCALE_HMANT_SHIFT	28
 #define VI6_UDS_SCALE_HFRAC_MASK	(0xfff << 16)
@@ -368,13 +561,11 @@
 #define VI6_UDS_SCALE_VFRAC_MASK	(0xfff << 0)
 #define VI6_UDS_SCALE_VFRAC_SHIFT	0
 
-#define VI6_UDS_ALPTH			0x2308
 #define VI6_UDS_ALPTH_TH1_MASK		(0xff << 8)
 #define VI6_UDS_ALPTH_TH1_SHIFT		8
 #define VI6_UDS_ALPTH_TH0_MASK		(0xff << 0)
 #define VI6_UDS_ALPTH_TH0_SHIFT		0
 
-#define VI6_UDS_ALPVAL			0x230c
 #define VI6_UDS_ALPVAL_VAL2_MASK	(0xff << 16)
 #define VI6_UDS_ALPVAL_VAL2_SHIFT	16
 #define VI6_UDS_ALPVAL_VAL1_MASK	(0xff << 8)
@@ -382,24 +573,20 @@
 #define VI6_UDS_ALPVAL_VAL0_MASK	(0xff << 0)
 #define VI6_UDS_ALPVAL_VAL0_SHIFT	0
 
-#define VI6_UDS_PASS_BWIDTH		0x2310
 #define VI6_UDS_PASS_BWIDTH_H_MASK	(0x7f << 16)
 #define VI6_UDS_PASS_BWIDTH_H_SHIFT	16
 #define VI6_UDS_PASS_BWIDTH_V_MASK	(0x7f << 0)
 #define VI6_UDS_PASS_BWIDTH_V_SHIFT	0
 
-#define VI6_UDS_IPC			0x2318
 #define VI6_UDS_IPC_FIELD		(1 << 27)
 #define VI6_UDS_IPC_VEDP_MASK		(0xfff << 0)
 #define VI6_UDS_IPC_VEDP_SHIFT		0
 
-#define VI6_UDS_CLIP_SIZE		0x2324
 #define VI6_UDS_CLIP_SIZE_HSIZE_MASK	(0x1fff << 16)
 #define VI6_UDS_CLIP_SIZE_HSIZE_SHIFT	16
 #define VI6_UDS_CLIP_SIZE_VSIZE_MASK	(0x1fff << 0)
 #define VI6_UDS_CLIP_SIZE_VSIZE_SHIFT	0
 
-#define VI6_UDS_FILL_COLOR		0x2328
 #define VI6_UDS_FILL_COLOR_RFILC_MASK	(0xff << 16)
 #define VI6_UDS_FILL_COLOR_RFILC_SHIFT	16
 #define VI6_UDS_FILL_COLOR_GFILC_MASK	(0xff << 8)
@@ -408,126 +595,21 @@
 #define VI6_UDS_FILL_COLOR_BFILC_SHIFT	0
 
 /* -----------------------------------------------------------------------------
- * LUT Control Registers
- */
-
-#define VI6_LUT_CTRL			0x2800
-
-/* -----------------------------------------------------------------------------
- * CLU Control Registers
- */
-
-#define VI6_CLU_CTRL			0x2900
-
-/* -----------------------------------------------------------------------------
- * HST Control Registers
- */
-
-#define VI6_HST_CTRL			0x2a00
-
-/* -----------------------------------------------------------------------------
- * HSI Control Registers
+ * Macros for LIF Control Registers
  */
 
-#define VI6_HSI_CTRL			0x2b00
-
-/* -----------------------------------------------------------------------------
- * BRU Control Registers
- */
-
-#define VI6_BRU_INCTRL			0x2c00
-#define VI6_BRU_VIRRPF_SIZE		0x2c04
-#define VI6_BRU_VIRRPF_LOC		0x2c08
-#define VI6_BRU_VIRRPF_COL		0x2c0c
-#define VI6_BRU_CTRL(n)			(0x2c10 + (n) * 8)
-#define VI6_BRU_BLD(n)			(0x2c14 + (n) * 8)
-#define VI6_BRU_ROP			0x2c30
-
-/* -----------------------------------------------------------------------------
- * HGO Control Registers
- */
-
-#define VI6_HGO_OFFSET			0x3000
-#define VI6_HGO_SIZE			0x3004
-#define VI6_HGO_MODE			0x3008
-#define VI6_HGO_LB_TH			0x300c
-#define VI6_HGO_LBn_H(n)		(0x3010 + (n) * 8)
-#define VI6_HGO_LBn_V(n)		(0x3014 + (n) * 8)
-#define VI6_HGO_R_HISTO			0x3030
-#define VI6_HGO_R_MAXMIN		0x3130
-#define VI6_HGO_R_SUM			0x3134
-#define VI6_HGO_R_LB_DET		0x3138
-#define VI6_HGO_G_HISTO			0x3140
-#define VI6_HGO_G_MAXMIN		0x3240
-#define VI6_HGO_G_SUM			0x3244
-#define VI6_HGO_G_LB_DET		0x3248
-#define VI6_HGO_B_HISTO			0x3250
-#define VI6_HGO_B_MAXMIN		0x3350
-#define VI6_HGO_B_SUM			0x3354
-#define VI6_HGO_B_LB_DET		0x3358
-#define VI6_HGO_REGRST			0x33fc
-
-/* -----------------------------------------------------------------------------
- * HGT Control Registers
- */
-
-#define VI6_HGT_OFFSET			0x3400
-#define VI6_HGT_SIZE			0x3404
-#define VI6_HGT_MODE			0x3408
-#define VI6_HGT_HUE_AREA(n)		(0x340c + (n) * 4)
-#define VI6_HGT_LB_TH			0x3424
-#define VI6_HGT_LBn_H(n)		(0x3438 + (n) * 8)
-#define VI6_HGT_LBn_V(n)		(0x342c + (n) * 8)
-#define VI6_HGT_HISTO(m, n)		(0x3450 + (m) * 128 + (n) * 4)
-#define VI6_HGT_MAXMIN			0x3750
-#define VI6_HGT_SUM			0x3754
-#define VI6_HGT_LB_DET			0x3758
-#define VI6_HGT_REGRST			0x37fc
-
-/* -----------------------------------------------------------------------------
- * LIF Control Registers
- */
-
-#define VI6_LIF_CTRL			0x3b00
 #define VI6_LIF_CTRL_OBTH_MASK		(0x7ff << 16)
 #define VI6_LIF_CTRL_OBTH_SHIFT		16
 #define VI6_LIF_CTRL_CFMT		(1 << 4)
 #define VI6_LIF_CTRL_REQSEL		(1 << 1)
 #define VI6_LIF_CTRL_LIF_EN		(1 << 0)
 
-#define VI6_LIF_CSBTH			0x3b04
 #define VI6_LIF_CSBTH_HBTH_MASK		(0x7ff << 16)
 #define VI6_LIF_CSBTH_HBTH_SHIFT	16
 #define VI6_LIF_CSBTH_LBTH_MASK		(0x7ff << 0)
 #define VI6_LIF_CSBTH_LBTH_SHIFT	0
 
 /* -----------------------------------------------------------------------------
- * Security Control Registers
- */
-
-#define VI6_SECURITY_CTRL0		0x3d00
-#define VI6_SECURITY_CTRL1		0x3d04
-
-/* -----------------------------------------------------------------------------
- * RPF CLUT Registers
- */
-
-#define VI6_CLUT_TABLE			0x4000
-
-/* -----------------------------------------------------------------------------
- * 1D LUT Registers
- */
-
-#define VI6_LUT_TABLE			0x7000
-
-/* -----------------------------------------------------------------------------
- * 3D LUT Registers
- */
-
-#define VI6_CLU_ADDR			0x7400
-#define VI6_CLU_DATA			0x7404
-
-/* -----------------------------------------------------------------------------
  * Formats
  */
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 254871d..0ba8bba 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -26,16 +26,16 @@
  * Device Access
  */
 
-static inline u32 vsp1_rpf_read(struct vsp1_rwpf *rpf, u32 reg)
+static inline u32 vsp1_rpf_read(struct vsp1_rwpf *rpf, int reg)
 {
-	return vsp1_read(rpf->entity.vsp1,
-			 reg + rpf->entity.index * VI6_RPF_OFFSET);
+	return _vsp1_read(rpf->entity.vsp1, reg,
+			  rpf->entity.index * VI6_RPF_OFFSET);
 }
 
-static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
+static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, int reg, u32 data)
 {
-	vsp1_write(rpf->entity.vsp1,
-		   reg + rpf->entity.index * VI6_RPF_OFFSET, data);
+	_vsp1_write(rpf->entity.vsp1, reg,
+		    rpf->entity.index * VI6_RPF_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 0e50b37..f8fb89a 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -29,16 +29,16 @@
  * Device Access
  */
 
-static inline u32 vsp1_uds_read(struct vsp1_uds *uds, u32 reg)
+static inline u32 vsp1_uds_read(struct vsp1_uds *uds, int reg)
 {
-	return vsp1_read(uds->entity.vsp1,
-			 reg + uds->entity.index * VI6_UDS_OFFSET);
+	return _vsp1_read(uds->entity.vsp1, reg,
+			  uds->entity.index * VI6_UDS_OFFSET);
 }
 
-static inline void vsp1_uds_write(struct vsp1_uds *uds, u32 reg, u32 data)
+static inline void vsp1_uds_write(struct vsp1_uds *uds, int reg, u32 data)
 {
-	vsp1_write(uds->entity.vsp1,
-		   reg + uds->entity.index * VI6_UDS_OFFSET, data);
+	_vsp1_write(uds->entity.vsp1, reg,
+		    uds->entity.index * VI6_UDS_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 0fa01b2..4c5dd8c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -348,7 +348,8 @@ static void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 
-	vsp1_write(vsp1, VI6_CMD(pipe->output->entity.index), VI6_CMD_STRCMD);
+	vsp1_write(vsp1,
+		   VI6_CMD0 + pipe->output->entity.index, VI6_CMD_STRCMD);
 	pipe->state = VSP1_PIPELINE_RUNNING;
 	pipe->buffers_ready = 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index db4b85e..6840642 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -26,16 +26,16 @@
  * Device Access
  */
 
-static inline u32 vsp1_wpf_read(struct vsp1_rwpf *wpf, u32 reg)
+static inline u32 vsp1_wpf_read(struct vsp1_rwpf *wpf, int reg)
 {
-	return vsp1_read(wpf->entity.vsp1,
-			 reg + wpf->entity.index * VI6_WPF_OFFSET);
+	return _vsp1_read(wpf->entity.vsp1, reg,
+			  wpf->entity.index * VI6_WPF_OFFSET);
 }
 
-static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
+static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, int reg, u32 data)
 {
-	vsp1_write(wpf->entity.vsp1,
-		   reg + wpf->entity.index * VI6_WPF_OFFSET, data);
+	_vsp1_write(wpf->entity.vsp1, reg,
+		    wpf->entity.index * VI6_WPF_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -55,7 +55,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	u32 outfmt = 0;
 
 	if (!enable) {
-		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
+		vsp1_write(vsp1, VI6_WPF_IRQ_ENB0 + wpf->entity.index, 0);
 		return 0;
 	}
 
@@ -104,14 +104,14 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
 
-	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH0 + wpf->entity.index,
 		   VI6_DPR_WPF_FPORCH_FP_WPFN);
 
 	vsp1_write(vsp1, VI6_WPF_WRBCK_CTRL, 0);
 
 	/* Enable interrupts */
-	vsp1_write(vsp1, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-	vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index),
+	vsp1_write(vsp1, VI6_WPF_IRQ_STA0 + wpf->entity.index, 0);
+	vsp1_write(vsp1, VI6_WPF_IRQ_ENB0 + wpf->entity.index,
 		   VI6_WFP_IRQ_ENB_FREE);
 
 	return 0;
-- 
1.7.9.5

