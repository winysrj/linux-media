Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52348 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbbIMU5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 31/32] v4l: vsp1: Add support for the R-Car Gen3 VSP2
Date: Sun, 13 Sep 2015 23:57:09 +0300
Message-Id: <1442177830-24536-32-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT compatible strings for the VSP2 instances found in the R-Car Gen3
SoCs and support them in the vsp1 driver.

Cc: devicetree@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/devicetree/bindings/media/renesas,vsp1.txt |  5 ++++-
 drivers/media/platform/vsp1/vsp1_drv.c                   | 12 ++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.c                |  3 ++-
 drivers/media/platform/vsp1/vsp1_regs.h                  | 12 ++++++------
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index 766f034c1e45..dc7fc142aada 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -6,7 +6,10 @@ It can be found in the Renesas R-Car second generation SoCs.
 
 Required properties:
 
-  - compatible: Must contain "renesas,vsp1"
+  - compatible: Must contain one of the following values
+    - "renesas,vsp1" for the R-Car Gen2 VSP1
+    - "renesas,vsp2" for the R-Car Gen3 VSP2BC, VSP2BD or VSP2I
+    - "renesas,vsp2d" for the R-Car Gen3 VSP2D
 
   - reg: Base address and length of the registers block for the VSP1.
   - interrupts: VSP1 interrupt specifier.
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 5d58cad5b125..75cdf8715d9a 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -648,8 +648,20 @@ static const struct vsp1_device_info vsp1_gen2_info = {
 	.uapi = true,
 };
 
+static const struct vsp1_device_info vsp1_gen3_info = {
+	.num_bru_inputs = 5,
+	.uapi = true,
+};
+
+static const struct vsp1_device_info vsp1_gen3_vspd_info = {
+	.num_bru_inputs = 5,
+	.uapi = false,
+};
+
 static const struct of_device_id vsp1_of_match[] = {
 	{ .compatible = "renesas,vsp1", .data = &vsp1_gen2_info },
+	{ .compatible = "renesas,vsp2", .data = &vsp1_gen3_info },
+	{ .compatible = "renesas,vsp2d", .data = &vsp1_gen3_vspd_info },
 	{ },
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 79e05b76d6e3..8947c1883bf4 100644
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
index 8173ceaab9f9..f94050224aa0 100644
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
-- 
2.4.6

