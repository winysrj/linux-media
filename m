Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47118 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3LLIgY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:24 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 1/8] v4l: ti-vpe: create a scaler block library
Date: Thu, 12 Dec 2013 14:05:57 +0530
Message-ID: <1386837364-1264-2-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE and VIP IPs in DAR7x contain a scaler(SC) sub block. Create a library which
will perform scaler block related configurations and hold SC register
definitions. The functions provided by this library will be called by the vpe
and vip drivers using a sc_data handle.

The vpe_dev holds the sc_data handle. The handle represents an instance of the
SC hardware, and the vpe driver uses it to access the scaler register offsets
or helper functions to configure these registers.

We move the SC register definitions to sc.h so that they aren't specific to
VPE anymore. The register offsets are now relative to the sub-block, and not the
VPE IP as a whole. In order for VPDMA to configure registers, it requires it's
offset from the top level VPE module. A macro called GET_OFFSET_TOP is added to
return the offset of the register relative to the VPE IP.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/Makefile   |   2 +-
 drivers/media/platform/ti-vpe/sc.c       |  91 ++++++++++++++++
 drivers/media/platform/ti-vpe/sc.h       | 175 +++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe.c      |  60 ++++-------
 drivers/media/platform/ti-vpe/vpe_regs.h | 149 --------------------------
 5 files changed, 288 insertions(+), 189 deletions(-)
 create mode 100644 drivers/media/platform/ti-vpe/sc.c
 create mode 100644 drivers/media/platform/ti-vpe/sc.h

diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
index cbf0a80..54c30b3 100644
--- a/drivers/media/platform/ti-vpe/Makefile
+++ b/drivers/media/platform/ti-vpe/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
 
-ti-vpe-y := vpe.o vpdma.o
+ti-vpe-y := vpe.o sc.o vpdma.o
 
 ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
new file mode 100644
index 0000000..f21dfbb
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -0,0 +1,91 @@
+/*
+ * Scaler library
+ *
+ * Copyright (c) 2013 Texas Instruments Inc.
+ *
+ * David Griego, <dagriego@biglakesoftware.com>
+ * Dale Farnsworth, <dale@farnsworth.org>
+ * Archit Taneja, <archit@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "sc.h"
+
+void sc_set_regs_bypass(struct sc_data *sc, u32 *sc_reg0)
+{
+	*sc_reg0 |= CFG_SC_BYPASS;
+}
+
+void sc_dump_regs(struct sc_data *sc)
+{
+	struct device *dev = &sc->pdev->dev;
+
+	u32 read_reg(struct sc_data *sc, int offset)
+	{
+		return ioread32(sc->base + offset);
+	}
+
+#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(sc, CFG_##r))
+
+	DUMPREG(SC0);
+	DUMPREG(SC1);
+	DUMPREG(SC2);
+	DUMPREG(SC3);
+	DUMPREG(SC4);
+	DUMPREG(SC5);
+	DUMPREG(SC6);
+	DUMPREG(SC8);
+	DUMPREG(SC9);
+	DUMPREG(SC10);
+	DUMPREG(SC11);
+	DUMPREG(SC12);
+	DUMPREG(SC13);
+	DUMPREG(SC17);
+	DUMPREG(SC18);
+	DUMPREG(SC19);
+	DUMPREG(SC20);
+	DUMPREG(SC21);
+	DUMPREG(SC22);
+	DUMPREG(SC23);
+	DUMPREG(SC24);
+	DUMPREG(SC25);
+
+#undef DUMPREG
+}
+
+struct sc_data *sc_create(struct platform_device *pdev)
+{
+	struct sc_data *sc;
+
+	dev_dbg(&pdev->dev, "sc_create\n");
+
+	sc = devm_kzalloc(&pdev->dev, sizeof(*sc), GFP_KERNEL);
+	if (!sc) {
+		dev_err(&pdev->dev, "couldn't alloc sc_data\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sc->pdev = pdev;
+
+	sc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sc");
+	if (!sc->res) {
+		dev_err(&pdev->dev, "missing platform resources data\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	sc->base = devm_ioremap_resource(&pdev->dev, sc->res);
+	if (!sc->base) {
+		dev_err(&pdev->dev, "failed to ioremap\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return sc;
+}
diff --git a/drivers/media/platform/ti-vpe/sc.h b/drivers/media/platform/ti-vpe/sc.h
new file mode 100644
index 0000000..9248544
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/sc.h
@@ -0,0 +1,175 @@
+/*
+ * Copyright (c) 2013 Texas Instruments Inc.
+ *
+ * David Griego, <dagriego@biglakesoftware.com>
+ * Dale Farnsworth, <dale@farnsworth.org>
+ * Archit Taneja, <archit@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#ifndef TI_SC_H
+#define TI_SC_H
+
+/* Scaler regs */
+#define CFG_SC0				0x0
+#define CFG_INTERLACE_O			(1 << 0)
+#define CFG_LINEAR			(1 << 1)
+#define CFG_SC_BYPASS			(1 << 2)
+#define CFG_INVT_FID			(1 << 3)
+#define CFG_USE_RAV			(1 << 4)
+#define CFG_ENABLE_EV			(1 << 5)
+#define CFG_AUTO_HS			(1 << 6)
+#define CFG_DCM_2X			(1 << 7)
+#define CFG_DCM_4X			(1 << 8)
+#define CFG_HP_BYPASS			(1 << 9)
+#define CFG_INTERLACE_I			(1 << 10)
+#define CFG_ENABLE_SIN2_VER_INTP	(1 << 11)
+#define CFG_Y_PK_EN			(1 << 14)
+#define CFG_TRIM			(1 << 15)
+#define CFG_SELFGEN_FID			(1 << 16)
+
+#define CFG_SC1				0x4
+#define CFG_ROW_ACC_INC_MASK		0x07ffffff
+#define CFG_ROW_ACC_INC_SHIFT		0
+
+#define CFG_SC2				0x08
+#define CFG_ROW_ACC_OFFSET_MASK		0x0fffffff
+#define CFG_ROW_ACC_OFFSET_SHIFT	0
+
+#define CFG_SC3				0x0c
+#define CFG_ROW_ACC_OFFSET_B_MASK	0x0fffffff
+#define CFG_ROW_ACC_OFFSET_B_SHIFT	0
+
+#define CFG_SC4				0x10
+#define CFG_TAR_H_MASK			0x07ff
+#define CFG_TAR_H_SHIFT			0
+#define CFG_TAR_W_MASK			0x07ff
+#define CFG_TAR_W_SHIFT			12
+#define CFG_LIN_ACC_INC_U_MASK		0x07
+#define CFG_LIN_ACC_INC_U_SHIFT		24
+#define CFG_NLIN_ACC_INIT_U_MASK	0x07
+#define CFG_NLIN_ACC_INIT_U_SHIFT	28
+
+#define CFG_SC5				0x14
+#define CFG_SRC_H_MASK			0x07ff
+#define CFG_SRC_H_SHIFT			0
+#define CFG_SRC_W_MASK			0x07ff
+#define CFG_SRC_W_SHIFT			12
+#define CFG_NLIN_ACC_INC_U_MASK		0x07
+#define CFG_NLIN_ACC_INC_U_SHIFT	24
+
+#define CFG_SC6				0x18
+#define CFG_ROW_ACC_INIT_RAV_MASK	0x03ff
+#define CFG_ROW_ACC_INIT_RAV_SHIFT	0
+#define CFG_ROW_ACC_INIT_RAV_B_MASK	0x03ff
+#define CFG_ROW_ACC_INIT_RAV_B_SHIFT	10
+
+#define CFG_SC8				0x20
+#define CFG_NLIN_LEFT_MASK		0x07ff
+#define CFG_NLIN_LEFT_SHIFT		0
+#define CFG_NLIN_RIGHT_MASK		0x07ff
+#define CFG_NLIN_RIGHT_SHIFT		12
+
+#define CFG_SC9				0x24
+#define CFG_LIN_ACC_INC			CFG_SC9
+
+#define CFG_SC10			0x28
+#define CFG_NLIN_ACC_INIT		CFG_SC10
+
+#define CFG_SC11			0x2c
+#define CFG_NLIN_ACC_INC		CFG_SC11
+
+#define CFG_SC12			0x30
+#define CFG_COL_ACC_OFFSET_MASK		0x01ffffff
+#define CFG_COL_ACC_OFFSET_SHIFT	0
+
+#define CFG_SC13			0x34
+#define CFG_SC_FACTOR_RAV_MASK		0xff
+#define CFG_SC_FACTOR_RAV_SHIFT		0
+#define CFG_CHROMA_INTP_THR_MASK	0x03ff
+#define CFG_CHROMA_INTP_THR_SHIFT	12
+#define CFG_DELTA_CHROMA_THR_MASK	0x0f
+#define CFG_DELTA_CHROMA_THR_SHIFT	24
+
+#define CFG_SC17			0x44
+#define CFG_EV_THR_MASK			0x03ff
+#define CFG_EV_THR_SHIFT		12
+#define CFG_DELTA_LUMA_THR_MASK		0x0f
+#define CFG_DELTA_LUMA_THR_SHIFT	24
+#define CFG_DELTA_EV_THR_MASK		0x0f
+#define CFG_DELTA_EV_THR_SHIFT		28
+
+#define CFG_SC18			0x48
+#define CFG_HS_FACTOR_MASK		0x03ff
+#define CFG_HS_FACTOR_SHIFT		0
+#define CFG_CONF_DEFAULT_MASK		0x01ff
+#define CFG_CONF_DEFAULT_SHIFT		16
+
+#define CFG_SC19			0x4c
+#define CFG_HPF_COEFF0_MASK		0xff
+#define CFG_HPF_COEFF0_SHIFT		0
+#define CFG_HPF_COEFF1_MASK		0xff
+#define CFG_HPF_COEFF1_SHIFT		8
+#define CFG_HPF_COEFF2_MASK		0xff
+#define CFG_HPF_COEFF2_SHIFT		16
+#define CFG_HPF_COEFF3_MASK		0xff
+#define CFG_HPF_COEFF3_SHIFT		23
+
+#define CFG_SC20			0x50
+#define CFG_HPF_COEFF4_MASK		0xff
+#define CFG_HPF_COEFF4_SHIFT		0
+#define CFG_HPF_COEFF5_MASK		0xff
+#define CFG_HPF_COEFF5_SHIFT		8
+#define CFG_HPF_NORM_SHIFT_MASK		0x07
+#define CFG_HPF_NORM_SHIFT_SHIFT	16
+#define CFG_NL_LIMIT_MASK		0x1ff
+#define CFG_NL_LIMIT_SHIFT		20
+
+#define CFG_SC21			0x54
+#define CFG_NL_LO_THR_MASK		0x01ff
+#define CFG_NL_LO_THR_SHIFT		0
+#define CFG_NL_LO_SLOPE_MASK		0xff
+#define CFG_NL_LO_SLOPE_SHIFT		16
+
+#define CFG_SC22			0x58
+#define CFG_NL_HI_THR_MASK		0x01ff
+#define CFG_NL_HI_THR_SHIFT		0
+#define CFG_NL_HI_SLOPE_SH_MASK		0x07
+#define CFG_NL_HI_SLOPE_SH_SHIFT	16
+
+#define CFG_SC23			0x5c
+#define CFG_GRADIENT_THR_MASK		0x07ff
+#define CFG_GRADIENT_THR_SHIFT		0
+#define CFG_GRADIENT_THR_RANGE_MASK	0x0f
+#define CFG_GRADIENT_THR_RANGE_SHIFT	12
+#define CFG_MIN_GY_THR_MASK		0xff
+#define CFG_MIN_GY_THR_SHIFT		16
+#define CFG_MIN_GY_THR_RANGE_MASK	0x0f
+#define CFG_MIN_GY_THR_RANGE_SHIFT	28
+
+#define CFG_SC24			0x60
+#define CFG_ORG_H_MASK			0x07ff
+#define CFG_ORG_H_SHIFT			0
+#define CFG_ORG_W_MASK			0x07ff
+#define CFG_ORG_W_SHIFT			16
+
+#define CFG_SC25			0x64
+#define CFG_OFF_H_MASK			0x07ff
+#define CFG_OFF_H_SHIFT			0
+#define CFG_OFF_W_MASK			0x07ff
+#define CFG_OFF_W_SHIFT			16
+
+struct sc_data {
+	void __iomem		*base;
+	struct resource		*res;
+
+	struct platform_device *pdev;
+};
+
+void sc_set_regs_bypass(struct sc_data *sc, u32 *sc_reg0);
+void sc_dump_regs(struct sc_data *sc);
+struct sc_data *sc_create(struct platform_device *pdev);
+
+#endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 6697770..ecb85f9 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -43,6 +43,7 @@
 
 #include "vpdma.h"
 #include "vpe_regs.h"
+#include "sc.h"
 
 #define VPE_MODULE_NAME "vpe"
 
@@ -324,9 +325,11 @@ struct vpe_dev {
 
 	int			irq;
 	void __iomem		*base;
+	struct resource		*res;
 
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct vpdma_data	*vpdma;		/* vpdma data handle */
+	struct sc_data		*sc;		/* scaler data handle */
 };
 
 /*
@@ -443,6 +446,9 @@ struct vpe_mmr_adb {
 	u32			csc_pad[2];
 };
 
+#define GET_OFFSET_TOP(ctx, obj, reg)	\
+	((obj)->res->start - ctx->dev->res->start + reg)
+
 #define VPE_SET_MMR_ADB_HDR(ctx, hdr, regs, offset_a)	\
 	VPDMA_SET_MMR_ADB_HDR(ctx->mmr_adb, vpe_mmr_adb, hdr, regs, offset_a)
 /*
@@ -455,7 +461,8 @@ static void init_adb_hdrs(struct vpe_ctx *ctx)
 	VPE_SET_MMR_ADB_HDR(ctx, us2_hdr, us2_regs, VPE_US2_R0);
 	VPE_SET_MMR_ADB_HDR(ctx, us3_hdr, us3_regs, VPE_US3_R0);
 	VPE_SET_MMR_ADB_HDR(ctx, dei_hdr, dei_regs, VPE_DEI_FRAME_SIZE);
-	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr, sc_regs, VPE_SC_MP_SC0);
+	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr, sc_regs,
+		GET_OFFSET_TOP(ctx, ctx->dev->sc, CFG_SC0));
 	VPE_SET_MMR_ADB_HDR(ctx, csc_hdr, csc_regs, VPE_CSC_CSC00);
 };
 
@@ -749,18 +756,6 @@ static void set_csc_coeff_bypass(struct vpe_ctx *ctx)
 	ctx->load_mmrs = true;
 }
 
-static void set_sc_regs_bypass(struct vpe_ctx *ctx)
-{
-	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
-	u32 *sc_reg0 = &mmr_adb->sc_regs[0];
-	u32 val = 0;
-
-	val |= VPE_SC_BYPASS;
-	*sc_reg0 = val;
-
-	ctx->load_mmrs = true;
-}
-
 /*
  * Set the shadow registers whose values are modified when either the
  * source or destination format is changed.
@@ -769,6 +764,7 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 {
 	struct vpe_q_data *s_q_data =  &ctx->q_data[Q_DATA_SRC];
 	struct vpe_q_data *d_q_data =  &ctx->q_data[Q_DATA_DST];
+	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
 	size_t mv_buf_size;
 	int ret;
 
@@ -806,7 +802,7 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	set_cfg_and_line_modes(ctx);
 	set_dei_regs(ctx);
 	set_csc_coeff_bypass(ctx);
-	set_sc_regs_bypass(ctx);
+	sc_set_regs_bypass(ctx->dev->sc, &mmr_adb->sc_regs[0]);
 
 	return 0;
 }
@@ -922,28 +918,6 @@ static void vpe_dump_regs(struct vpe_dev *dev)
 	DUMPREG(DEI_FMD_STATUS_R0);
 	DUMPREG(DEI_FMD_STATUS_R1);
 	DUMPREG(DEI_FMD_STATUS_R2);
-	DUMPREG(SC_MP_SC0);
-	DUMPREG(SC_MP_SC1);
-	DUMPREG(SC_MP_SC2);
-	DUMPREG(SC_MP_SC3);
-	DUMPREG(SC_MP_SC4);
-	DUMPREG(SC_MP_SC5);
-	DUMPREG(SC_MP_SC6);
-	DUMPREG(SC_MP_SC8);
-	DUMPREG(SC_MP_SC9);
-	DUMPREG(SC_MP_SC10);
-	DUMPREG(SC_MP_SC11);
-	DUMPREG(SC_MP_SC12);
-	DUMPREG(SC_MP_SC13);
-	DUMPREG(SC_MP_SC17);
-	DUMPREG(SC_MP_SC18);
-	DUMPREG(SC_MP_SC19);
-	DUMPREG(SC_MP_SC20);
-	DUMPREG(SC_MP_SC21);
-	DUMPREG(SC_MP_SC22);
-	DUMPREG(SC_MP_SC23);
-	DUMPREG(SC_MP_SC24);
-	DUMPREG(SC_MP_SC25);
 	DUMPREG(CSC_CSC00);
 	DUMPREG(CSC_CSC01);
 	DUMPREG(CSC_CSC02);
@@ -951,6 +925,8 @@ static void vpe_dump_regs(struct vpe_dev *dev)
 	DUMPREG(CSC_CSC04);
 	DUMPREG(CSC_CSC05);
 #undef DUMPREG
+
+	sc_dump_regs(dev->sc);
 }
 
 static void add_out_dtd(struct vpe_ctx *ctx, int port)
@@ -1965,7 +1941,6 @@ static int vpe_probe(struct platform_device *pdev)
 {
 	struct vpe_dev *dev;
 	struct video_device *vfd;
-	struct resource *res;
 	int ret, irq, func;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -1981,14 +1956,15 @@ static int vpe_probe(struct platform_device *pdev)
 	atomic_set(&dev->num_instances, 0);
 	mutex_init(&dev->dev_mutex);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpe_top");
+	dev->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+			"vpe_top");
 	/*
 	 * HACK: we get resource info from device tree in the form of a list of
 	 * VPE sub blocks, the driver currently uses only the base of vpe_top
 	 * for register access, the driver should be changed later to access
 	 * registers based on the sub block base addresses
 	 */
-	dev->base = devm_ioremap(&pdev->dev, res->start, SZ_32K);
+	dev->base = devm_ioremap(&pdev->dev, dev->res->start, SZ_32K);
 	if (!dev->base) {
 		ret = -ENOMEM;
 		goto v4l2_dev_unreg;
@@ -2033,6 +2009,12 @@ static int vpe_probe(struct platform_device *pdev)
 
 	vpe_top_vpdma_reset(dev);
 
+	dev->sc = sc_create(pdev);
+	if (IS_ERR(dev->sc)) {
+		ret = PTR_ERR(dev->sc);
+		goto runtime_put;
+	}
+
 	dev->vpdma = vpdma_create(pdev);
 	if (IS_ERR(dev->vpdma)) {
 		ret = PTR_ERR(dev->vpdma);
diff --git a/drivers/media/platform/ti-vpe/vpe_regs.h b/drivers/media/platform/ti-vpe/vpe_regs.h
index ed214e8..d8dbdd3 100644
--- a/drivers/media/platform/ti-vpe/vpe_regs.h
+++ b/drivers/media/platform/ti-vpe/vpe_regs.h
@@ -306,155 +306,6 @@
 #define VPE_FMD_FRAME_DIFF_MASK		0x000fffff
 #define VPE_FMD_FRAME_DIFF_SHIFT	0
 
-/* VPE scaler regs */
-#define VPE_SC_MP_SC0			0x0700
-#define VPE_INTERLACE_O			(1 << 0)
-#define VPE_LINEAR			(1 << 1)
-#define VPE_SC_BYPASS			(1 << 2)
-#define VPE_INVT_FID			(1 << 3)
-#define VPE_USE_RAV			(1 << 4)
-#define VPE_ENABLE_EV			(1 << 5)
-#define VPE_AUTO_HS			(1 << 6)
-#define VPE_DCM_2X			(1 << 7)
-#define VPE_DCM_4X			(1 << 8)
-#define VPE_HP_BYPASS			(1 << 9)
-#define VPE_INTERLACE_I			(1 << 10)
-#define VPE_ENABLE_SIN2_VER_INTP	(1 << 11)
-#define VPE_Y_PK_EN			(1 << 14)
-#define VPE_TRIM			(1 << 15)
-#define VPE_SELFGEN_FID			(1 << 16)
-
-#define VPE_SC_MP_SC1			0x0704
-#define VPE_ROW_ACC_INC_MASK		0x07ffffff
-#define VPE_ROW_ACC_INC_SHIFT		0
-
-#define VPE_SC_MP_SC2			0x0708
-#define VPE_ROW_ACC_OFFSET_MASK		0x0fffffff
-#define VPE_ROW_ACC_OFFSET_SHIFT	0
-
-#define VPE_SC_MP_SC3			0x070c
-#define VPE_ROW_ACC_OFFSET_B_MASK	0x0fffffff
-#define VPE_ROW_ACC_OFFSET_B_SHIFT	0
-
-#define VPE_SC_MP_SC4			0x0710
-#define VPE_TAR_H_MASK			0x07ff
-#define VPE_TAR_H_SHIFT			0
-#define VPE_TAR_W_MASK			0x07ff
-#define VPE_TAR_W_SHIFT			12
-#define VPE_LIN_ACC_INC_U_MASK		0x07
-#define VPE_LIN_ACC_INC_U_SHIFT		24
-#define VPE_NLIN_ACC_INIT_U_MASK	0x07
-#define VPE_NLIN_ACC_INIT_U_SHIFT	28
-
-#define VPE_SC_MP_SC5			0x0714
-#define VPE_SRC_H_MASK			0x07ff
-#define VPE_SRC_H_SHIFT			0
-#define VPE_SRC_W_MASK			0x07ff
-#define VPE_SRC_W_SHIFT			12
-#define VPE_NLIN_ACC_INC_U_MASK		0x07
-#define VPE_NLIN_ACC_INC_U_SHIFT	24
-
-#define VPE_SC_MP_SC6			0x0718
-#define VPE_ROW_ACC_INIT_RAV_MASK	0x03ff
-#define VPE_ROW_ACC_INIT_RAV_SHIFT	0
-#define VPE_ROW_ACC_INIT_RAV_B_MASK	0x03ff
-#define VPE_ROW_ACC_INIT_RAV_B_SHIFT	10
-
-#define VPE_SC_MP_SC8			0x0720
-#define VPE_NLIN_LEFT_MASK		0x07ff
-#define VPE_NLIN_LEFT_SHIFT		0
-#define VPE_NLIN_RIGHT_MASK		0x07ff
-#define VPE_NLIN_RIGHT_SHIFT		12
-
-#define VPE_SC_MP_SC9			0x0724
-#define VPE_LIN_ACC_INC			VPE_SC_MP_SC9
-
-#define VPE_SC_MP_SC10			0x0728
-#define VPE_NLIN_ACC_INIT		VPE_SC_MP_SC10
-
-#define VPE_SC_MP_SC11			0x072c
-#define VPE_NLIN_ACC_INC		VPE_SC_MP_SC11
-
-#define VPE_SC_MP_SC12			0x0730
-#define VPE_COL_ACC_OFFSET_MASK		0x01ffffff
-#define VPE_COL_ACC_OFFSET_SHIFT	0
-
-#define VPE_SC_MP_SC13			0x0734
-#define VPE_SC_FACTOR_RAV_MASK		0x03ff
-#define VPE_SC_FACTOR_RAV_SHIFT		0
-#define VPE_CHROMA_INTP_THR_MASK	0x03ff
-#define VPE_CHROMA_INTP_THR_SHIFT	12
-#define VPE_DELTA_CHROMA_THR_MASK	0x0f
-#define VPE_DELTA_CHROMA_THR_SHIFT	24
-
-#define VPE_SC_MP_SC17			0x0744
-#define VPE_EV_THR_MASK			0x03ff
-#define VPE_EV_THR_SHIFT		12
-#define VPE_DELTA_LUMA_THR_MASK		0x0f
-#define VPE_DELTA_LUMA_THR_SHIFT	24
-#define VPE_DELTA_EV_THR_MASK		0x0f
-#define VPE_DELTA_EV_THR_SHIFT		28
-
-#define VPE_SC_MP_SC18			0x0748
-#define VPE_HS_FACTOR_MASK		0x03ff
-#define VPE_HS_FACTOR_SHIFT		0
-#define VPE_CONF_DEFAULT_MASK		0x01ff
-#define VPE_CONF_DEFAULT_SHIFT		16
-
-#define VPE_SC_MP_SC19			0x074c
-#define VPE_HPF_COEFF0_MASK		0xff
-#define VPE_HPF_COEFF0_SHIFT		0
-#define VPE_HPF_COEFF1_MASK		0xff
-#define VPE_HPF_COEFF1_SHIFT		8
-#define VPE_HPF_COEFF2_MASK		0xff
-#define VPE_HPF_COEFF2_SHIFT		16
-#define VPE_HPF_COEFF3_MASK		0xff
-#define VPE_HPF_COEFF3_SHIFT		23
-
-#define VPE_SC_MP_SC20			0x0750
-#define VPE_HPF_COEFF4_MASK		0xff
-#define VPE_HPF_COEFF4_SHIFT		0
-#define VPE_HPF_COEFF5_MASK		0xff
-#define VPE_HPF_COEFF5_SHIFT		8
-#define VPE_HPF_NORM_SHIFT_MASK		0x07
-#define VPE_HPF_NORM_SHIFT_SHIFT	16
-#define VPE_NL_LIMIT_MASK		0x1ff
-#define VPE_NL_LIMIT_SHIFT		20
-
-#define VPE_SC_MP_SC21			0x0754
-#define VPE_NL_LO_THR_MASK		0x01ff
-#define VPE_NL_LO_THR_SHIFT		0
-#define VPE_NL_LO_SLOPE_MASK		0xff
-#define VPE_NL_LO_SLOPE_SHIFT		16
-
-#define VPE_SC_MP_SC22			0x0758
-#define VPE_NL_HI_THR_MASK		0x01ff
-#define VPE_NL_HI_THR_SHIFT		0
-#define VPE_NL_HI_SLOPE_SH_MASK		0x07
-#define VPE_NL_HI_SLOPE_SH_SHIFT	16
-
-#define VPE_SC_MP_SC23			0x075c
-#define VPE_GRADIENT_THR_MASK		0x07ff
-#define VPE_GRADIENT_THR_SHIFT		0
-#define VPE_GRADIENT_THR_RANGE_MASK	0x0f
-#define VPE_GRADIENT_THR_RANGE_SHIFT	12
-#define VPE_MIN_GY_THR_MASK		0xff
-#define VPE_MIN_GY_THR_SHIFT		16
-#define VPE_MIN_GY_THR_RANGE_MASK	0x0f
-#define VPE_MIN_GY_THR_RANGE_SHIFT	28
-
-#define VPE_SC_MP_SC24			0x0760
-#define VPE_ORG_H_MASK			0x07ff
-#define VPE_ORG_H_SHIFT			0
-#define VPE_ORG_W_MASK			0x07ff
-#define VPE_ORG_W_SHIFT			16
-
-#define VPE_SC_MP_SC25			0x0764
-#define VPE_OFF_H_MASK			0x07ff
-#define VPE_OFF_H_SHIFT			0
-#define VPE_OFF_W_MASK			0x07ff
-#define VPE_OFF_W_SHIFT			16
-
 /* VPE color space converter regs */
 #define VPE_CSC_CSC00			0x5700
 #define VPE_CSC_A0_MASK			0x1fff
-- 
1.8.3.2

