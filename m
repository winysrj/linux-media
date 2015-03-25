Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56417 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752526AbbCYW6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:39 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 10/15] omap3isp: Move the syscon register out of the ISP register maps
Date: Thu, 26 Mar 2015 00:57:34 +0200
Message-Id: <1427324259-18438-11-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The syscon register isn't part of the ISP, use it through the syscom driver
regmap instead. The syscom block is considered to be from 343x on ISP
revision 2.0 whereas 15.0 is assumed to have 3630 syscon.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c               |   10 ----------
 drivers/media/platform/Kconfig              |    1 +
 drivers/media/platform/omap3isp/isp.c       |   20 ++++++++++++++++----
 drivers/media/platform/omap3isp/isp.h       |   19 +++++++++++++++++--
 drivers/media/platform/omap3isp/ispcsiphy.c |   20 +++++++++-----------
 5 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1afb50d..e945957 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -143,16 +143,6 @@ static struct resource omap3isp_resources[] = {
 		.flags		= IORESOURCE_MEM,
 	},
 	{
-		.start		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE,
-		.end		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE + 3,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL,
-		.end		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL + 3,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
 		.start		= 24 + OMAP_INTC_START,
 		.flags		= IORESOURCE_IRQ,
 	}
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2e30be5..272dc8c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -90,6 +90,7 @@ config VIDEO_OMAP3
 	select ARM_DMA_USE_IOMMU
 	select OMAP_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
+	select MFD_SYSCON
 	---help---
 	  Driver for an OMAP 3 camera controller.
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 68d7edfc..83b4368 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -51,6 +51,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/omap-iommu.h>
 #include <linux/platform_device.h>
@@ -94,8 +95,9 @@ static const struct isp_res_mapping isp_res_maps[] = {
 		       1 << OMAP3_ISP_IOMEM_RESZ |
 		       1 << OMAP3_ISP_IOMEM_SBL |
 		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
-		       1 << OMAP3_ISP_IOMEM_CSIPHY2 |
-		       1 << OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE,
+		       1 << OMAP3_ISP_IOMEM_CSIPHY2,
+		.syscon_offset = 0xdc,
+		.phy_type = ISP_PHY_TYPE_3430,
 	},
 	{
 		.isp_rev = ISP_REVISION_15_0,
@@ -112,8 +114,9 @@ static const struct isp_res_mapping isp_res_maps[] = {
 		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS2 |
 		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS1 |
 		       1 << OMAP3_ISP_IOMEM_CSIPHY1 |
-		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2 |
-		       1 << OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL,
+		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2,
+		.syscon_offset = 0x2f0,
+		.phy_type = ISP_PHY_TYPE_3630,
 	},
 };
 
@@ -2352,6 +2355,15 @@ static int isp_probe(struct platform_device *pdev)
 		}
 	}
 
+	isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
+	if (IS_ERR(isp->syscon)) {
+		ret = PTR_ERR(isp->syscon);
+		goto error_isp;
+	}
+
+	isp->syscon_offset = isp_res_maps[m].syscon_offset;
+	isp->phy_type = isp_res_maps[m].phy_type;
+
 	/* IOMMU */
 	ret = isp_attach_iommu(isp);
 	if (ret < 0) {
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 9535524..03d2129 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -59,8 +59,6 @@ enum isp_mem_resources {
 	OMAP3_ISP_IOMEM_CSI2C_REGS1,
 	OMAP3_ISP_IOMEM_CSIPHY1,
 	OMAP3_ISP_IOMEM_CSI2C_REGS2,
-	OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE,
-	OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL,
 	OMAP3_ISP_IOMEM_LAST
 };
 
@@ -93,14 +91,25 @@ enum isp_subclk_resource {
 /* ISP2P: OMAP 36xx */
 #define ISP_REVISION_15_0		0xF0
 
+#define ISP_PHY_TYPE_3430		0
+#define ISP_PHY_TYPE_3630		1
+
+struct regmap;
+
 /*
  * struct isp_res_mapping - Map ISP io resources to ISP revision.
  * @isp_rev: ISP_REVISION_x_x
  * @map: bitmap for enum isp_mem_resources
+ * @syscon_offset: offset of the syscon register for 343x / 3630
+ *	    (CONTROL_CSIRXFE / CONTROL_CAMERA_PHY_CTRL, respectively)
+ *	    from the syscon base address
+ * @phy_type: ISP_PHY_TYPE_{3430,3630}
  */
 struct isp_res_mapping {
 	u32 isp_rev;
 	u32 map;
+	u32 syscon_offset;
+	u32 phy_type;
 };
 
 /*
@@ -140,6 +149,9 @@ struct isp_xclk {
  *             regions.
  * @mmio_hist_base_phys: Physical L4 bus address for ISP hist block register
  *			 region.
+ * @syscon: Regmap for the syscon register space
+ * @syscon_offset: Offset of the CSIPHY control register in syscon
+ * @phy_type: ISP_PHY_TYPE_{3430,3630}
  * @mapping: IOMMU mapping
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
@@ -176,6 +188,9 @@ struct isp_device {
 
 	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
 	unsigned long mmio_hist_base_phys;
+	struct regmap *syscon;
+	u32 syscon_offset;
+	u32 phy_type;
 
 	struct dma_iommu_mapping *mapping;
 
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 4486e9f..d91dde1 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 
 #include "isp.h"
@@ -26,10 +27,11 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *phy,
 				    enum isp_interface_type iface,
 				    bool ccp2_strobe)
 {
-	u32 reg = isp_reg_readl(
-		phy->isp, OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
+	u32 reg;
 	u32 shift, mode;
 
+	regmap_read(phy->isp->syscon, phy->isp->syscon_offset, &reg);
+
 	switch (iface) {
 	default:
 	/* Should not happen in practice, but let's keep the compiler happy. */
@@ -63,8 +65,7 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *phy,
 	reg &= ~(OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_MASK << shift);
 	reg |= mode << shift;
 
-	isp_reg_writel(phy->isp, reg,
-		       OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
+	regmap_write(phy->isp->syscon, phy->isp->syscon_offset, reg);
 }
 
 static void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool on,
@@ -78,16 +79,14 @@ static void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool on,
 		return;
 
 	if (!on) {
-		isp_reg_writel(phy->isp, 0,
-			       OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE, 0);
+		regmap_write(phy->isp->syscon, phy->isp->syscon_offset, 0);
 		return;
 	}
 
 	if (ccp2_strobe)
 		csirxfe |= OMAP343X_CONTROL_CSIRXFE_SELFORM;
 
-	isp_reg_writel(phy->isp, csirxfe,
-		       OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE, 0);
+	regmap_write(phy->isp->syscon, phy->isp->syscon_offset, csirxfe);
 }
 
 /*
@@ -106,10 +105,9 @@ static void csiphy_routing_cfg(struct isp_csiphy *phy,
 			       enum isp_interface_type iface, bool on,
 			       bool ccp2_strobe)
 {
-	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL]
-	    && on)
+	if (phy->isp->phy_type == ISP_PHY_TYPE_3630 && on)
 		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
-	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE])
+	if (phy->isp->phy_type == ISP_PHY_TYPE_3430)
 		return csiphy_routing_cfg_3430(phy, iface, on, ccp2_strobe);
 }
 
-- 
1.7.10.4

