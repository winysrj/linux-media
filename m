Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53156 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3LLIgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:38 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 5/8] v4l: ti-vpe: create a color space converter block library
Date: Thu, 12 Dec 2013 14:06:01 +0530
Message-ID: <1386837364-1264-6-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE and VIP IPs in DAR7x contain a color space converter(CSC) sub block. Create
a library which will perform CSC related configurations and hold CSC register
definitions. The functions provided by this library will be called by the vpe
and vip drivers using a csc_data handle.

The vpe_dev holds the csc_data handle. The handle represents an instance of the
CSC hardware, and the vpe driver uses it to access the CSC register offsets or
helper functions to configure these registers.

The CSC register offsets are now relative to the CSC block itself, so we need
to use the macro GET_OFFSET_TOP to get the CSC register offset relative to the
VPE IP in the vpe driver.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/Makefile   |  2 +-
 drivers/media/platform/ti-vpe/csc.c      | 76 ++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/csc.h      | 65 +++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe.c      | 31 ++++++-------
 drivers/media/platform/ti-vpe/vpe_regs.h | 38 ----------------
 5 files changed, 155 insertions(+), 57 deletions(-)
 create mode 100644 drivers/media/platform/ti-vpe/csc.c
 create mode 100644 drivers/media/platform/ti-vpe/csc.h

diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
index 54c30b3..be680f8 100644
--- a/drivers/media/platform/ti-vpe/Makefile
+++ b/drivers/media/platform/ti-vpe/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
 
-ti-vpe-y := vpe.o sc.o vpdma.o
+ti-vpe-y := vpe.o sc.o csc.o vpdma.o
 
 ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
new file mode 100644
index 0000000..62e2fec
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -0,0 +1,76 @@
+/*
+ * Color space converter library
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
+#include "csc.h"
+
+void csc_dump_regs(struct csc_data *csc)
+{
+	struct device *dev = &csc->pdev->dev;
+
+	u32 read_reg(struct csc_data *csc, int offset)
+	{
+		return ioread32(csc->base + offset);
+	}
+
+#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(csc, CSC_##r))
+
+	DUMPREG(CSC00);
+	DUMPREG(CSC01);
+	DUMPREG(CSC02);
+	DUMPREG(CSC03);
+	DUMPREG(CSC04);
+	DUMPREG(CSC05);
+
+#undef DUMPREG
+}
+
+void csc_set_coeff_bypass(struct csc_data *csc, u32 *csc_reg5)
+{
+	*csc_reg5 |= CSC_BYPASS;
+}
+
+struct csc_data *csc_create(struct platform_device *pdev)
+{
+	struct csc_data *csc;
+
+	dev_dbg(&pdev->dev, "csc_create\n");
+
+	csc = devm_kzalloc(&pdev->dev, sizeof(*csc), GFP_KERNEL);
+	if (!csc) {
+		dev_err(&pdev->dev, "couldn't alloc csc_data\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	csc->pdev = pdev;
+
+	csc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+			"vpe_csc");
+	if (csc->res == NULL) {
+		dev_err(&pdev->dev, "missing platform resources data\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	csc->base = devm_ioremap_resource(&pdev->dev, csc->res);
+	if (!csc->base) {
+		dev_err(&pdev->dev, "failed to ioremap\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return csc;
+}
diff --git a/drivers/media/platform/ti-vpe/csc.h b/drivers/media/platform/ti-vpe/csc.h
new file mode 100644
index 0000000..57b5ed6
--- /dev/null
+++ b/drivers/media/platform/ti-vpe/csc.h
@@ -0,0 +1,65 @@
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
+#ifndef TI_CSC_H
+#define TI_CSC_H
+
+/* VPE color space converter regs */
+#define CSC_CSC00		0x00
+#define CSC_A0_MASK		0x1fff
+#define CSC_A0_SHIFT		0
+#define CSC_B0_MASK		0x1fff
+#define CSC_B0_SHIFT		16
+
+#define CSC_CSC01		0x04
+#define CSC_C0_MASK		0x1fff
+#define CSC_C0_SHIFT		0
+#define CSC_A1_MASK		0x1fff
+#define CSC_A1_SHIFT		16
+
+#define CSC_CSC02		0x08
+#define CSC_B1_MASK		0x1fff
+#define CSC_B1_SHIFT		0
+#define CSC_C1_MASK		0x1fff
+#define CSC_C1_SHIFT		16
+
+#define CSC_CSC03		0x0c
+#define CSC_A2_MASK		0x1fff
+#define CSC_A2_SHIFT		0
+#define CSC_B2_MASK		0x1fff
+#define CSC_B2_SHIFT		16
+
+#define CSC_CSC04		0x10
+#define CSC_C2_MASK		0x1fff
+#define CSC_C2_SHIFT		0
+#define CSC_D0_MASK		0x0fff
+#define CSC_D0_SHIFT		16
+
+#define CSC_CSC05		0x14
+#define CSC_D1_MASK		0x0fff
+#define CSC_D1_SHIFT		0
+#define CSC_D2_MASK		0x0fff
+#define CSC_D2_SHIFT		16
+
+#define CSC_BYPASS		(1 << 28)
+
+struct csc_data {
+	void __iomem		*base;
+	struct resource		*res;
+
+	struct platform_device	*pdev;
+};
+
+void csc_dump_regs(struct csc_data *csc);
+void csc_set_coeff_bypass(struct csc_data *csc, u32 *csc_reg5);
+struct csc_data *csc_create(struct platform_device *pdev);
+
+#endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index dc2b94c..6c4db57 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -44,6 +44,7 @@
 #include "vpdma.h"
 #include "vpe_regs.h"
 #include "sc.h"
+#include "csc.h"
 
 #define VPE_MODULE_NAME "vpe"
 
@@ -330,6 +331,7 @@ struct vpe_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct vpdma_data	*vpdma;		/* vpdma data handle */
 	struct sc_data		*sc;		/* scaler data handle */
+	struct csc_data		*csc;		/* csc data handle */
 };
 
 /*
@@ -475,7 +477,8 @@ static void init_adb_hdrs(struct vpe_ctx *ctx)
 		GET_OFFSET_TOP(ctx, ctx->dev->sc, CFG_SC8));
 	VPE_SET_MMR_ADB_HDR(ctx, sc_hdr17, sc_regs17,
 		GET_OFFSET_TOP(ctx, ctx->dev->sc, CFG_SC17));
-	VPE_SET_MMR_ADB_HDR(ctx, csc_hdr, csc_regs, VPE_CSC_CSC00);
+	VPE_SET_MMR_ADB_HDR(ctx, csc_hdr, csc_regs,
+		GET_OFFSET_TOP(ctx, ctx->dev->csc, CSC_CSC00));
 };
 
 /*
@@ -758,16 +761,6 @@ static void set_dei_shadow_registers(struct vpe_ctx *ctx)
 	ctx->load_mmrs = true;
 }
 
-static void set_csc_coeff_bypass(struct vpe_ctx *ctx)
-{
-	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
-	u32 *shadow_csc_reg5 = &mmr_adb->csc_regs[5];
-
-	*shadow_csc_reg5 |= VPE_CSC_BYPASS;
-
-	ctx->load_mmrs = true;
-}
-
 /*
  * Set the shadow registers whose values are modified when either the
  * source or destination format is changed.
@@ -819,7 +812,8 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 
 	set_cfg_and_line_modes(ctx);
 	set_dei_regs(ctx);
-	set_csc_coeff_bypass(ctx);
+
+	csc_set_coeff_bypass(ctx->dev->csc, &mmr_adb->csc_regs[5]);
 
 	sc_set_hs_coeffs(ctx->dev->sc, ctx->sc_coeff_h.addr, src_w, dst_w);
 	sc_set_vs_coeffs(ctx->dev->sc, ctx->sc_coeff_v.addr, src_h, dst_h);
@@ -942,15 +936,10 @@ static void vpe_dump_regs(struct vpe_dev *dev)
 	DUMPREG(DEI_FMD_STATUS_R0);
 	DUMPREG(DEI_FMD_STATUS_R1);
 	DUMPREG(DEI_FMD_STATUS_R2);
-	DUMPREG(CSC_CSC00);
-	DUMPREG(CSC_CSC01);
-	DUMPREG(CSC_CSC02);
-	DUMPREG(CSC_CSC03);
-	DUMPREG(CSC_CSC04);
-	DUMPREG(CSC_CSC05);
 #undef DUMPREG
 
 	sc_dump_regs(dev->sc);
+	csc_dump_regs(dev->csc);
 }
 
 static void add_out_dtd(struct vpe_ctx *ctx, int port)
@@ -2074,6 +2063,12 @@ static int vpe_probe(struct platform_device *pdev)
 		goto runtime_put;
 	}
 
+	dev->csc = csc_create(pdev);
+	if (IS_ERR(dev->csc)) {
+		ret = PTR_ERR(dev->csc);
+		goto runtime_put;
+	}
+
 	dev->vpdma = vpdma_create(pdev);
 	if (IS_ERR(dev->vpdma)) {
 		ret = PTR_ERR(dev->vpdma);
diff --git a/drivers/media/platform/ti-vpe/vpe_regs.h b/drivers/media/platform/ti-vpe/vpe_regs.h
index d8dbdd3..74283d7 100644
--- a/drivers/media/platform/ti-vpe/vpe_regs.h
+++ b/drivers/media/platform/ti-vpe/vpe_regs.h
@@ -306,42 +306,4 @@
 #define VPE_FMD_FRAME_DIFF_MASK		0x000fffff
 #define VPE_FMD_FRAME_DIFF_SHIFT	0
 
-/* VPE color space converter regs */
-#define VPE_CSC_CSC00			0x5700
-#define VPE_CSC_A0_MASK			0x1fff
-#define VPE_CSC_A0_SHIFT		0
-#define VPE_CSC_B0_MASK			0x1fff
-#define VPE_CSC_B0_SHIFT		16
-
-#define VPE_CSC_CSC01			0x5704
-#define VPE_CSC_C0_MASK			0x1fff
-#define VPE_CSC_C0_SHIFT		0
-#define VPE_CSC_A1_MASK			0x1fff
-#define VPE_CSC_A1_SHIFT		16
-
-#define VPE_CSC_CSC02			0x5708
-#define VPE_CSC_B1_MASK			0x1fff
-#define VPE_CSC_B1_SHIFT		0
-#define VPE_CSC_C1_MASK			0x1fff
-#define VPE_CSC_C1_SHIFT		16
-
-#define VPE_CSC_CSC03			0x570c
-#define VPE_CSC_A2_MASK			0x1fff
-#define VPE_CSC_A2_SHIFT		0
-#define VPE_CSC_B2_MASK			0x1fff
-#define VPE_CSC_B2_SHIFT		16
-
-#define VPE_CSC_CSC04			0x5710
-#define VPE_CSC_C2_MASK			0x1fff
-#define VPE_CSC_C2_SHIFT		0
-#define VPE_CSC_D0_MASK			0x0fff
-#define VPE_CSC_D0_SHIFT		16
-
-#define VPE_CSC_CSC05			0x5714
-#define VPE_CSC_D1_MASK			0x0fff
-#define VPE_CSC_D1_SHIFT		0
-#define VPE_CSC_D2_MASK			0x0fff
-#define VPE_CSC_D2_SHIFT		16
-#define VPE_CSC_BYPASS			(1 << 28)
-
 #endif
-- 
1.8.3.2

