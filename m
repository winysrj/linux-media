Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55019 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbbLECNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:22 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 31/32] v4l: vsp1: Add support for the R-Car Gen3 VSP2
Date: Sat,  5 Dec 2015 04:13:05 +0200
Message-Id: <1449281586-25726-32-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT compatible strings for the VSP2 instances found in the R-Car Gen3
SoCs and support them in the vsp1 driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---

Changes since v1:

- Configure device parameters based on the version register

---
 .../devicetree/bindings/media/renesas,vsp1.txt     | 20 ++++++++-------
 drivers/media/platform/vsp1/vsp1_drv.c             | 25 ++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.c          |  3 ++-
 drivers/media/platform/vsp1/vsp1_regs.h            | 30 +++++++++++++++++-----
 4 files changed, 62 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index 674c8c30d046..fe74fb38e4d5 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -1,24 +1,26 @@
-* Renesas VSP1 Video Processing Engine
+* Renesas VSP Video Processing Engine
 
-The VSP1 is a video processing engine that supports up-/down-scaling, alpha
+The VSP is a video processing engine that supports up-/down-scaling, alpha
 blending, color space conversion and various other image processing features.
 It can be found in the Renesas R-Car second generation SoCs.
 
 Required properties:
 
-  - compatible: Must contain "renesas,vsp1"
+  - compatible: Must contain one of the following values
+    - "renesas,vsp1" for the R-Car Gen2 VSP1
+    - "renesas,vsp2" for the R-Car Gen3 VSP2
 
-  - reg: Base address and length of the registers block for the VSP1.
-  - interrupts: VSP1 interrupt specifier.
-  - clocks: A phandle + clock-specifier pair for the VSP1 functional clock.
+  - reg: Base address and length of the registers block for the VSP.
+  - interrupts: VSP interrupt specifier.
+  - clocks: A phandle + clock-specifier pair for the VSP functional clock.
 
-  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP1.
-  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP1.
+  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP.
+  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP.
 
 
 Optional properties:
 
-  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP1. Defaults
+  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP. Defaults
     to 0 if not present.
   - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
     available.
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 377b167892e3..9a30c96dc642 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -575,6 +575,7 @@ static int vsp1_probe(struct platform_device *pdev)
 	struct vsp1_device *vsp1;
 	struct resource *irq;
 	struct resource *io;
+	u32 version;
 	int ret;
 
 	vsp1 = devm_kzalloc(&pdev->dev, sizeof(*vsp1), GFP_KERNEL);
@@ -615,6 +616,29 @@ static int vsp1_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Configure device parameters based on the version register. */
+	ret = clk_prepare_enable(vsp1->clock);
+	if (ret < 0)
+		return ret;
+
+	version = vsp1_read(vsp1, VI6_IP_VERSION);
+	clk_disable_unprepare(vsp1->clock);
+
+	dev_dbg(&pdev->dev, "IP version 0x%08x\n", version);
+
+	switch (version & VI6_IP_VERSION_MODEL_MASK) {
+	case VI6_IP_VERSION_MODEL_VSPD_GEN3:
+		vsp1->pdata.num_bru_inputs = 5;
+		vsp1->pdata.uapi = false;
+		break;
+
+	case VI6_IP_VERSION_MODEL_VSPI_GEN3:
+	case VI6_IP_VERSION_MODEL_VSPBD_GEN3:
+	case VI6_IP_VERSION_MODEL_VSPBC_GEN3:
+		vsp1->pdata.features &= ~VSP1_HAS_BRU;
+		break;
+	}
+
 	/* Instanciate entities */
 	ret = vsp1_create_entities(vsp1);
 	if (ret < 0) {
@@ -638,6 +662,7 @@ static int vsp1_remove(struct platform_device *pdev)
 
 static const struct of_device_id vsp1_of_match[] = {
 	{ .compatible = "renesas,vsp1" },
+	{ .compatible = "renesas,vsp2" },
 	{ },
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 38a496f43050..4b46cb0e0e8a 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -165,7 +165,8 @@ int vsp1_entity_link_setup(struct media_entity *entity,
 static const struct vsp1_route vsp1_routes[] = {
 	{ VSP1_ENTITY_BRU, 0, VI6_DPR_BRU_ROUTE,
 	  { VI6_DPR_NODE_BRU_IN(0), VI6_DPR_NODE_BRU_IN(1),
-	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3), } },
+	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3),
+	    VI6_DPR_NODE_BRU_IN(4) } },
 	{ VSP1_ENTITY_HSI, 0, VI6_DPR_HSI_ROUTE, { VI6_DPR_NODE_HSI, } },
 	{ VSP1_ENTITY_HST, 0, VI6_DPR_HST_ROUTE, { VI6_DPR_NODE_HST, } },
 	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, } },
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 8173ceaab9f9..a3a0a15d9997 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -322,7 +322,7 @@
 #define VI6_DPR_NODE_SRU		16
 #define VI6_DPR_NODE_UDS(n)		(17 + (n))
 #define VI6_DPR_NODE_LUT		22
-#define VI6_DPR_NODE_BRU_IN(n)		(23 + (n))
+#define VI6_DPR_NODE_BRU_IN(n)		(((n) <= 3) ? 23 + (n) : 49)
 #define VI6_DPR_NODE_BRU_OUT		27
 #define VI6_DPR_NODE_CLU		29
 #define VI6_DPR_NODE_HST		30
@@ -504,12 +504,12 @@
 #define VI6_BRU_VIRRPF_COL_BCB_MASK	(0xff << 0)
 #define VI6_BRU_VIRRPF_COL_BCB_SHIFT	0
 
-#define VI6_BRU_CTRL(n)			(0x2c10 + (n) * 8)
+#define VI6_BRU_CTRL(n)			(0x2c10 + (n) * 8 + ((n) <= 3 ? 0 : 4))
 #define VI6_BRU_CTRL_RBC		(1 << 31)
-#define VI6_BRU_CTRL_DSTSEL_BRUIN(n)	((n) << 20)
+#define VI6_BRU_CTRL_DSTSEL_BRUIN(n)	(((n) <= 3 ? (n) : (n)+1) << 20)
 #define VI6_BRU_CTRL_DSTSEL_VRPF	(4 << 20)
 #define VI6_BRU_CTRL_DSTSEL_MASK	(7 << 20)
-#define VI6_BRU_CTRL_SRCSEL_BRUIN(n)	((n) << 16)
+#define VI6_BRU_CTRL_SRCSEL_BRUIN(n)	(((n) <= 3 ? (n) : (n)+1) << 16)
 #define VI6_BRU_CTRL_SRCSEL_VRPF	(4 << 16)
 #define VI6_BRU_CTRL_SRCSEL_MASK	(7 << 16)
 #define VI6_BRU_CTRL_CROP(rop)		((rop) << 4)
@@ -517,7 +517,7 @@
 #define VI6_BRU_CTRL_AROP(rop)		((rop) << 0)
 #define VI6_BRU_CTRL_AROP_MASK		(0xf << 0)
 
-#define VI6_BRU_BLD(n)			(0x2c14 + (n) * 8)
+#define VI6_BRU_BLD(n)			(0x2c14 + (n) * 8 + ((n) <= 3 ? 0 : 4))
 #define VI6_BRU_BLD_CBES		(1 << 31)
 #define VI6_BRU_BLD_CCMDX_DST_A		(0 << 28)
 #define VI6_BRU_BLD_CCMDX_255_DST_A	(1 << 28)
@@ -551,7 +551,7 @@
 #define VI6_BRU_BLD_COEFY_SHIFT		0
 
 #define VI6_BRU_ROP			0x2c30
-#define VI6_BRU_ROP_DSTSEL_BRUIN(n)	((n) << 20)
+#define VI6_BRU_ROP_DSTSEL_BRUIN(n)	(((n) <= 3 ? (n) : (n)+1) << 20)
 #define VI6_BRU_ROP_DSTSEL_VRPF		(4 << 20)
 #define VI6_BRU_ROP_DSTSEL_MASK		(7 << 20)
 #define VI6_BRU_ROP_CROP(rop)		((rop) << 4)
@@ -625,6 +625,24 @@
 #define VI6_SECURITY_CTRL1		0x3d04
 
 /* -----------------------------------------------------------------------------
+ * IP Version Registers
+ */
+
+#define VI6_IP_VERSION			0x3f00
+#define VI6_IP_VERSION_MODEL_MASK	(0xff << 8)
+#define VI6_IP_VERSION_MODEL_VSPS_H2	(0x09 << 8)
+#define VI6_IP_VERSION_MODEL_VSPR_GEN2	(0x0a << 8)
+#define VI6_IP_VERSION_MODEL_VSPD_H2	(0x0b << 8)
+#define VI6_IP_VERSION_MODEL_VSPS_M2	(0x0c << 8)
+#define VI6_IP_VERSION_MODEL_VSPI_GEN3	(0x14 << 8)
+#define VI6_IP_VERSION_MODEL_VSPBD_GEN3	(0x15 << 8)
+#define VI6_IP_VERSION_MODEL_VSPBC_GEN3	(0x16 << 8)
+#define VI6_IP_VERSION_MODEL_VSPD_GEN3	(0x17 << 8)
+#define VI6_IP_VERSION_SOC_MASK		(0xff << 0)
+#define VI6_IP_VERSION_SOC_H		(0x01 << 0)
+#define VI6_IP_VERSION_SOC_M		(0x02 << 0)
+
+/* -----------------------------------------------------------------------------
  * RPF CLUT Registers
  */
 
-- 
2.4.10

