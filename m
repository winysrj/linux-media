Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55196 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab3GZJdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:33:12 -0400
Received: by mail-pa0-f44.google.com with SMTP id jh10so3052448pab.31
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 02:33:12 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 7/7] [media] vsp1: Add VIO6 support
Date: Fri, 26 Jul 2013 18:32:17 +0900
Message-Id: <1374831137-9219-8-git-send-email-matsu@igel.co.jp>
In-Reply-To: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
References: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIO6 is an older version of the VSP1 used by many of the current
Renesas R-Car/R-Mobile SoCs.
This patch just handles the differences between VSP1 and VIO6,
by adjusting the offset of some registers and the DPR register
operation.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1.h      |    1 +
 drivers/media/platform/vsp1/vsp1_drv.c  |  226 +++++++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_regs.h |    8 ++
 drivers/media/platform/vsp1/vsp1_rpf.c  |    5 +
 drivers/media/platform/vsp1/vsp1_wpf.c  |    6 +-
 5 files changed, 230 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 31c24a3..efd8085 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -51,6 +51,7 @@ struct vsp1_device {
 
 	struct mutex lock;
 	int ref_count;
+	bool is_vio6;
 
 	struct vsp1_lif *lif;
 	struct vsp1_rwpf *rpf[VPS1_MAX_RPF];
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index c24f43f..d685d72 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -241,11 +241,21 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 	u32 status;
 	u32 route_unused = vsp1->routes[VI6_DPR_NODE_UNUSED].id;
 	u32 val;
-	const u32 fporch_fp[VPS1_MAX_WPF] = {
-		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
-		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
-		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
-		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+	const u32 fporch_fp[][VPS1_MAX_WPF] = {
+		{
+			(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+			(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+			(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+			(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+		},
+		{
+			0,
+			0,
+			(VI6_DPR_WPF_FPORCH_FP_WPFN << 16) |
+			(VI6_DPR_WPF_FPORCH_FP_WPFN <<  8) |
+			(VI6_DPR_WPF_FPORCH_FP_WPFN <<  0),
+			VI6_DPR_WPF_FPORCH_FP_WPFN << 24,
+		},
 	};
 
 	/* Reset any channel that might be running. */
@@ -312,12 +322,17 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, val);
 
 	for (i = 0; i < VPS1_MAX_WPF; ++i)
-		vsp1_write(vsp1, VI6_DPR_WPF_FPORCH0 + i, fporch_fp[i]);
-
-	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
-		   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
-	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
-		   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
+		vsp1_write(vsp1, VI6_DPR_WPF_FPORCH0 + i,
+			   fporch_fp[vsp1->is_vio6 ? 1 : 0][i]);
+
+	if (!vsp1->is_vio6) {
+		vsp1_write(vsp1, VI6_DPR_HGO_SMPPT,
+			   (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+			   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
+		vsp1_write(vsp1, VI6_DPR_HGT_SMPPT,
+			   (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+			   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
+	}
 }
 
 /*
@@ -651,7 +666,147 @@ static const struct vsp1_dpr_route vsp1_routes[] = {
 	[VI6_DPR_NODE_UNUSED]	= { 63, 0, 0 },
 };
 
-static int vsp1_probe(struct platform_device *pdev)
+static const unsigned int vio6_reg_offs[] = {
+	[VI6_CMD0]		= 0x0000,
+	[VI6_CMD1]		= 0x0000 + 1 * 4,
+	[VI6_CMD2]		= 0x0000 + 2 * 4,
+	[VI6_CMD3]		= 0x0000 + 3 * 4,
+	[VI6_SRESET]		= 0x0018,
+	[VI6_STATUS]		= 0x0020,
+	[VI6_WPF_IRQ_ENB0]	= 0x0030,
+	[VI6_WPF_IRQ_ENB1]	= 0x0030 + 1 * 12,
+	[VI6_WPF_IRQ_ENB2]	= 0x0030 + 2 * 12,
+	[VI6_WPF_IRQ_ENB3]	= 0x0030 + 3 * 12,
+	[VI6_WPF_IRQ_STA0]	= 0x0034,
+	[VI6_WPF_IRQ_STA1]	= 0x0034 + 1 * 12,
+	[VI6_WPF_IRQ_STA2]	= 0x0034 + 2 * 12,
+	[VI6_WPF_IRQ_STA3]	= 0x0034 + 3 * 12,
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
+	[VI6_RPF_SRCM_PSTRIDE]	= 0x0364,
+	[VI6_RPF_SRCM_ASTRIDE]	= 0x0368,
+	[VI6_RPF_SRCM_ADDR_Y]	= 0x036c,
+	[VI6_RPF_SRCM_ADDR_C0]	= 0x0370,
+	[VI6_RPF_SRCM_ADDR_C1]	= 0x0374,
+	[VI6_RPF_SRCM_ADDR_AI]	= 0x0378,
+	[VI6_RPF_CHPRI_CTRL]	= 0x0380,
+
+	[VI6_WPF_SRCRPF]	= 0x1000,
+	[VI6_WPF_HSZCLIP]	= 0x1004,
+	[VI6_WPF_VSZCLIP]	= 0x1008,
+	[VI6_WPF_OUTFMT]	= 0x100c,
+	[VI6_WPF_DSWAP]		= 0x1010,
+	[VI6_WPF_RNDCTRL]	= 0x1014,
+	[VI6_WPF_DSTM_STRIDE_Y]	= 0x104c,
+	[VI6_WPF_DSTM_STRIDE_C]	= 0x1050,
+	[VI6_WPF_DSTM_ADDR_Y]	= 0x1054,
+	[VI6_WPF_DSTM_ADDR_C0]	= 0x1058,
+	[VI6_WPF_DSTM_ADDR_C1]	= 0x105c,
+	[VI6_WPF_CHPRI_CTRL]	= 0x1060,
+
+#define VI6_DPR_CTRL(n)		(0x2000 + (n) * 4)
+	[VI6_DPR_RPF_ROUTE0]	= VI6_DPR_CTRL(0),
+	[VI6_DPR_RPF_ROUTE1]	= VI6_DPR_CTRL(0),
+	[VI6_DPR_RPF_ROUTE2]	= VI6_DPR_CTRL(0),
+	[VI6_DPR_RPF_ROUTE3]	= VI6_DPR_CTRL(0),
+	[VI6_DPR_RPF_ROUTE4]	= VI6_DPR_CTRL(1),
+	[VI6_DPR_FXA0]		= 0x2010,
+	[VI6_DPR_FXA1]		= 0x2014,
+	[VI6_DPR_WPF_FPORCH0]	= 0x2018,
+	[VI6_DPR_WPF_FPORCH1]	= 0x2018 + 1 * 4,
+	[VI6_DPR_WPF_FPORCH2]	= 0x2018 + 2 * 4,
+	[VI6_DPR_WPF_FPORCH3]	= 0x2018 + 3 * 4,
+	[VI6_DPR_SRU_ROUTE]	= VI6_DPR_CTRL(1),
+	[VI6_DPR_UDS_ROUTE0]	= VI6_DPR_CTRL(1),
+	[VI6_DPR_UDS_ROUTE1]	= VI6_DPR_CTRL(2),
+	[VI6_DPR_LUT_ROUTE]	= VI6_DPR_CTRL(2),
+	[VI6_DPR_CLU_ROUTE]	= VI6_DPR_CTRL(2),
+	[VI6_DPR_HST_ROUTE]	= VI6_DPR_CTRL(2),
+	[VI6_DPR_HSI_ROUTE]	= VI6_DPR_CTRL(3),
+	[VI6_DPR_BRU_ROUTE]	= VI6_DPR_CTRL(3),
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
+	[VI6_UDS_CLIP_SIZE]	= 0x2324,
+	[VI6_UDS_FILL_COLOR]	= 0x2328,
+
+	[VI6_LUT_CTRL]		= 0x2600,
+
+	[VI6_CLU_CTRL]		= 0x2700,
+
+	[VI6_HST_CTRL]		= 0x2800,
+
+	[VI6_HSI_CTRL]		= 0x2900,
+
+	[VI6_BRU_INCTRL]	= 0x2a00,
+	[VI6_BRU_VIRRPF_SIZE]	= 0x2a04,
+	[VI6_BRU_VIRRPF_LOC]	= 0x2a08,
+	[VI6_BRU_VIRRPF_COL]	= 0x2a0c,
+	[VI6_BRU_CTRLA]		= 0x2a10,
+	[VI6_BRU_CTRLB]		= 0x2a10 + 1 * 8,
+	[VI6_BRU_CTRLC]		= 0x2a10 + 2 * 8,
+	[VI6_BRU_CTRLD]		= 0x2a10 + 3 * 8,
+	[VI6_BRU_BLDA]		= 0x2a14,
+	[VI6_BRU_BLDB]		= 0x2a14 + 1 * 8,
+	[VI6_BRU_BLDC]		= 0x2a14 + 2 * 8,
+	[VI6_BRU_BLDD]		= 0x2a14 + 3 * 8,
+	[VI6_BRU_ROP]		= 0x2a30,
+
+	[VI6_CLUT_TABLE]	= 0x4800,
+
+	[VI6_LUT_TABLE]		= 0x7000,
+
+	[VI6_CLU_ADDR]		= 0x7400,
+	[VI6_CLU_DATA]		= 0x7404,
+};
+
+static const struct vsp1_dpr_route vio6_routes[] = {
+	[VI6_DPR_NODE_RPF0]	= {  0, VI6_DPR_RPF_ROUTE0, 24 },
+	[VI6_DPR_NODE_RPF1]	= {  1, VI6_DPR_RPF_ROUTE0 + 1, 16 },
+	[VI6_DPR_NODE_RPF2]	= {  2, VI6_DPR_RPF_ROUTE0 + 2, 8 },
+	[VI6_DPR_NODE_RPF3]	= {  3, VI6_DPR_RPF_ROUTE0 + 3, 0 },
+	[VI6_DPR_NODE_RPF4]	= {  4, VI6_DPR_RPF_ROUTE0 + 4, 24 },
+	[VI6_DPR_NODE_SRU]	= {  8, VI6_DPR_SRU_ROUTE, 16 },
+	[VI6_DPR_NODE_UDS0]	= {  9, VI6_DPR_UDS_ROUTE0, 8 },
+	[VI6_DPR_NODE_UDS1]	= { 22, VI6_DPR_UDS_ROUTE0 + 1, 8 },
+	[VI6_DPR_NODE_LUT]	= { 12, VI6_DPR_LUT_ROUTE, 16 },
+	[VI6_DPR_NODE_BRU_IN0]	= { 13, 0, 0 },
+	[VI6_DPR_NODE_BRU_IN1]	= { 14, 0, 0 },
+	[VI6_DPR_NODE_BRU_IN2]	= { 15, 0, 0 },
+	[VI6_DPR_NODE_BRU_IN3]	= { 16, 0, 0 },
+	[VI6_DPR_NODE_BRU_OUT]	= { 17, VI6_DPR_BRU_ROUTE, 16 },
+	[VI6_DPR_NODE_CLU]	= { 19, VI6_DPR_CLU_ROUTE, 8 },
+	[VI6_DPR_NODE_HST]	= { 20, VI6_DPR_HST_ROUTE, 0 },
+	[VI6_DPR_NODE_HSI]	= { 21, VI6_DPR_HSI_ROUTE, 24 },
+	[VI6_DPR_NODE_WPF0]	= { 26, 0, 0 },
+	[VI6_DPR_NODE_WPF1]	= { 27, 0, 0 },
+	[VI6_DPR_NODE_WPF2]	= { 28, 0, 0 },
+	[VI6_DPR_NODE_WPF3]	= { 29, 0, 0 },
+	[VI6_DPR_NODE_UNUSED]	= { 31, 0, 0 },
+};
+
+static int _vsp1_probe(struct platform_device *pdev,
+		       const unsigned int *reg_offs,
+		       const struct vsp1_dpr_route *routes, bool is_vio6)
 {
 	struct vsp1_device *vsp1;
 	struct resource *irq;
@@ -664,8 +819,9 @@ static int vsp1_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	vsp1->reg_offs = vsp1_reg_offs;
-	vsp1->routes = vsp1_routes;
+	vsp1->reg_offs = reg_offs;
+	vsp1->routes = routes;
+	vsp1->is_vio6 = is_vio6;
 
 	vsp1->dev = &pdev->dev;
 	mutex_init(&vsp1->lock);
@@ -715,6 +871,17 @@ static int vsp1_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int vsp1_probe(struct platform_device *pdev)
+{
+	return _vsp1_probe(pdev, vsp1_reg_offs, vsp1_routes, false);
+}
+
+static int vio6_probe(struct platform_device *pdev)
+{
+	return _vsp1_probe(pdev, vio6_reg_offs, vio6_routes, true);
+}
+
+
 static int vsp1_remove(struct platform_device *pdev)
 {
 	struct vsp1_device *vsp1 = platform_get_drvdata(pdev);
@@ -734,7 +901,36 @@ static struct platform_driver vsp1_platform_driver = {
 	},
 };
 
-module_platform_driver(vsp1_platform_driver);
+static struct platform_driver vio6_platform_driver = {
+	.probe		= vio6_probe,
+	.remove		= vsp1_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "vio6",
+		.pm	= &vsp1_pm_ops,
+	},
+};
+
+static int __init vsp1_platform_driver_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&vsp1_platform_driver);
+	if (ret)
+		return ret;
+	ret = platform_driver_register(&vio6_platform_driver);
+	if (ret)
+		platform_driver_unregister(&vsp1_platform_driver);
+	return ret;
+}
+module_init(vsp1_platform_driver_init);
+
+static void __exit vsp1_platform_driver_exit(void)
+{
+	platform_driver_unregister(&vio6_platform_driver);
+	platform_driver_unregister(&vsp1_platform_driver);
+}
+module_exit(vsp1_platform_driver_exit);
 
 MODULE_ALIAS("vsp1");
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index bd9f72e..3885aee 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -76,6 +76,7 @@ enum {
 	VI6_RPF_SRCM_ADDR_C0,
 	VI6_RPF_SRCM_ADDR_C1,
 	VI6_RPF_SRCM_ADDR_AI,
+	VI6_RPF_CHPRI_CTRL,	/* for VIO6 */
 
 /* -----------------------------------------------------------------------------
  * WPF Control Registers
@@ -93,6 +94,7 @@ enum {
 	VI6_WPF_DSTM_ADDR_C0,
 	VI6_WPF_DSTM_ADDR_C1,
 	VI6_WPF_WRBCK_CTRL,
+	VI6_WPF_CHPRI_CTRL,	/* for VIO6 */
 
 /* -----------------------------------------------------------------------------
  * DPR Control Registers
@@ -118,6 +120,8 @@ enum {
 	VI6_DPR_BRU_ROUTE,
 	VI6_DPR_HGO_SMPPT,
 	VI6_DPR_HGT_SMPPT,
+	VI6_DPR_FXA0,		/* for VIO6 */
+	VI6_DPR_FXA1,		/* for VIO6 */
 
 /* -----------------------------------------------------------------------------
  * SRU Control Registers
@@ -445,6 +449,8 @@ enum {
 
 #define VI6_RPF_SRCM_PSTRIDE_A_SHIFT	0
 
+#define VI6_RPF_CHPRI_CTRL_ICBP		(1 << 16)	/* for VIO6 */
+
 /* -----------------------------------------------------------------------------
  * Macros for WPF Control Registers
  */
@@ -503,6 +509,8 @@ enum {
 
 #define VI6_WPF_WRBCK_CTRL_WBMD		(1 << 0)
 
+#define VI6_WPF_CHPRI_CTRL_ICBP		(1 << 16)	/* for VIO6 */
+
 /* -----------------------------------------------------------------------------
  * Macros for DPR Control Registers
  */
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index d469cc8..561ab6a 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -45,6 +45,7 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, int reg, u32 data)
 static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(subdev);
+	struct vsp1_device *vsp1 = rpf->entity.vsp1;
 	const struct vsp1_format_info *fmtinfo = rpf->video.fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->video.format;
 	u32 pstride;
@@ -97,6 +98,10 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
 
+	if (vsp1->is_vio6)
+		vsp1_rpf_write(rpf, VI6_RPF_CHPRI_CTRL,
+			       VI6_RPF_CHPRI_CTRL_ICBP);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index af1f1b8..72dfdea 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -104,7 +104,11 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
 
-	vsp1_write(vsp1, VI6_WPF_WRBCK_CTRL, 0);
+	if (!vsp1->is_vio6)
+		vsp1_write(vsp1, VI6_WPF_WRBCK_CTRL, 0);
+	else
+		vsp1_wpf_write(wpf, VI6_WPF_CHPRI_CTRL,
+			       VI6_WPF_CHPRI_CTRL_ICBP);
 
 	/* Enable interrupts */
 	vsp1_write(vsp1, VI6_WPF_IRQ_STA0 + wpf->entity.index, 0);
-- 
1.7.9.5

