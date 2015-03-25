Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56425 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751888AbbCYW6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:40 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 11/15] omap3isp: Replace many MMIO regions by two
Date: Thu, 26 Mar 2015 00:57:35 +0200
Message-Id: <1427324259-18438-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp MMIO register block is contiguous in the MMIO register space
apart from the fact that the ISP IOMMU register block is in the middle of
the area. Ioremap it at two occasions, and keep the rest of the layout of
the register space internal to the omap3isp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c         |   66 +------------------
 arch/arm/mach-omap2/omap34xx.h        |   36 +----------
 drivers/media/platform/omap3isp/isp.c |  113 +++++++++++++++++----------------
 drivers/media/platform/omap3isp/isp.h |    4 +-
 4 files changed, 66 insertions(+), 153 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index e945957..990338f 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -74,72 +74,12 @@ omap_postcore_initcall(omap3_l3_init);
 static struct resource omap3isp_resources[] = {
 	{
 		.start		= OMAP3430_ISP_BASE,
-		.end		= OMAP3430_ISP_END,
+		.end		= OMAP3430_ISP_BASE + 0x12fc,
 		.flags		= IORESOURCE_MEM,
 	},
 	{
-		.start		= OMAP3430_ISP_CCP2_BASE,
-		.end		= OMAP3430_ISP_CCP2_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_CCDC_BASE,
-		.end		= OMAP3430_ISP_CCDC_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_HIST_BASE,
-		.end		= OMAP3430_ISP_HIST_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_H3A_BASE,
-		.end		= OMAP3430_ISP_H3A_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_PREV_BASE,
-		.end		= OMAP3430_ISP_PREV_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_RESZ_BASE,
-		.end		= OMAP3430_ISP_RESZ_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_SBL_BASE,
-		.end		= OMAP3430_ISP_SBL_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_CSI2A_REGS1_BASE,
-		.end		= OMAP3430_ISP_CSI2A_REGS1_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_CSIPHY2_BASE,
-		.end		= OMAP3430_ISP_CSIPHY2_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3630_ISP_CSI2A_REGS2_BASE,
-		.end		= OMAP3630_ISP_CSI2A_REGS2_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3630_ISP_CSI2C_REGS1_BASE,
-		.end		= OMAP3630_ISP_CSI2C_REGS1_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3630_ISP_CSIPHY1_BASE,
-		.end		= OMAP3630_ISP_CSIPHY1_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3630_ISP_CSI2C_REGS2_BASE,
-		.end		= OMAP3630_ISP_CSI2C_REGS2_END,
+		.start		= OMAP3430_ISP_BASE2,
+		.end		= OMAP3430_ISP_BASE2 + 0x0600,
 		.flags		= IORESOURCE_MEM,
 	},
 	{
diff --git a/arch/arm/mach-omap2/omap34xx.h b/arch/arm/mach-omap2/omap34xx.h
index c0d1b4b..ed0024d 100644
--- a/arch/arm/mach-omap2/omap34xx.h
+++ b/arch/arm/mach-omap2/omap34xx.h
@@ -46,39 +46,9 @@
 
 #define OMAP34XX_IC_BASE	0x48200000
 
-#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
-#define OMAP3430_ISP_CBUFF_BASE		(OMAP3430_ISP_BASE + 0x0100)
-#define OMAP3430_ISP_CCP2_BASE		(OMAP3430_ISP_BASE + 0x0400)
-#define OMAP3430_ISP_CCDC_BASE		(OMAP3430_ISP_BASE + 0x0600)
-#define OMAP3430_ISP_HIST_BASE		(OMAP3430_ISP_BASE + 0x0A00)
-#define OMAP3430_ISP_H3A_BASE		(OMAP3430_ISP_BASE + 0x0C00)
-#define OMAP3430_ISP_PREV_BASE		(OMAP3430_ISP_BASE + 0x0E00)
-#define OMAP3430_ISP_RESZ_BASE		(OMAP3430_ISP_BASE + 0x1000)
-#define OMAP3430_ISP_SBL_BASE		(OMAP3430_ISP_BASE + 0x1200)
-#define OMAP3430_ISP_MMU_BASE		(OMAP3430_ISP_BASE + 0x1400)
-#define OMAP3430_ISP_CSI2A_REGS1_BASE	(OMAP3430_ISP_BASE + 0x1800)
-#define OMAP3430_ISP_CSIPHY2_BASE	(OMAP3430_ISP_BASE + 0x1970)
-#define OMAP3630_ISP_CSI2A_REGS2_BASE	(OMAP3430_ISP_BASE + 0x19C0)
-#define OMAP3630_ISP_CSI2C_REGS1_BASE	(OMAP3430_ISP_BASE + 0x1C00)
-#define OMAP3630_ISP_CSIPHY1_BASE	(OMAP3430_ISP_BASE + 0x1D70)
-#define OMAP3630_ISP_CSI2C_REGS2_BASE	(OMAP3430_ISP_BASE + 0x1DC0)
-
-#define OMAP3430_ISP_END		(OMAP3430_ISP_BASE         + 0x06F)
-#define OMAP3430_ISP_CBUFF_END		(OMAP3430_ISP_CBUFF_BASE   + 0x077)
-#define OMAP3430_ISP_CCP2_END		(OMAP3430_ISP_CCP2_BASE    + 0x1EF)
-#define OMAP3430_ISP_CCDC_END		(OMAP3430_ISP_CCDC_BASE    + 0x0A7)
-#define OMAP3430_ISP_HIST_END		(OMAP3430_ISP_HIST_BASE    + 0x047)
-#define OMAP3430_ISP_H3A_END		(OMAP3430_ISP_H3A_BASE     + 0x05F)
-#define OMAP3430_ISP_PREV_END		(OMAP3430_ISP_PREV_BASE    + 0x09F)
-#define OMAP3430_ISP_RESZ_END		(OMAP3430_ISP_RESZ_BASE    + 0x0AB)
-#define OMAP3430_ISP_SBL_END		(OMAP3430_ISP_SBL_BASE     + 0x0FB)
-#define OMAP3430_ISP_MMU_END		(OMAP3430_ISP_MMU_BASE     + 0x06F)
-#define OMAP3430_ISP_CSI2A_REGS1_END	(OMAP3430_ISP_CSI2A_REGS1_BASE + 0x16F)
-#define OMAP3430_ISP_CSIPHY2_END	(OMAP3430_ISP_CSIPHY2_BASE + 0x00B)
-#define OMAP3630_ISP_CSI2A_REGS2_END	(OMAP3630_ISP_CSI2A_REGS2_BASE + 0x3F)
-#define OMAP3630_ISP_CSI2C_REGS1_END	(OMAP3630_ISP_CSI2C_REGS1_BASE + 0x16F)
-#define OMAP3630_ISP_CSIPHY1_END	(OMAP3630_ISP_CSIPHY1_BASE + 0x00B)
-#define OMAP3630_ISP_CSI2C_REGS2_END	(OMAP3630_ISP_CSI2C_REGS2_BASE + 0x3F)
+#define OMAP3430_ISP_BASE	(L4_34XX_BASE + 0xBC000)
+#define OMAP3430_ISP_MMU_BASE	(OMAP3430_ISP_BASE + 0x1400)
+#define OMAP3430_ISP_BASE2	(OMAP3430_ISP_BASE + 0x1800)
 
 #define OMAP34XX_HSUSB_OTG_BASE	(L4_34XX_BASE + 0xAB000)
 #define OMAP34XX_USBTLL_BASE	(L4_34XX_BASE + 0x62000)
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 83b4368..992e74c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -86,35 +86,43 @@ static void isp_restore_ctx(struct isp_device *isp);
 static const struct isp_res_mapping isp_res_maps[] = {
 	{
 		.isp_rev = ISP_REVISION_2_0,
-		.map = 1 << OMAP3_ISP_IOMEM_MAIN |
-		       1 << OMAP3_ISP_IOMEM_CCP2 |
-		       1 << OMAP3_ISP_IOMEM_CCDC |
-		       1 << OMAP3_ISP_IOMEM_HIST |
-		       1 << OMAP3_ISP_IOMEM_H3A |
-		       1 << OMAP3_ISP_IOMEM_PREV |
-		       1 << OMAP3_ISP_IOMEM_RESZ |
-		       1 << OMAP3_ISP_IOMEM_SBL |
-		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
-		       1 << OMAP3_ISP_IOMEM_CSIPHY2,
+		.offset = {
+			/* first MMIO area */
+			0x0000, /* base, len 0x0070 */
+			0x0400, /* ccp2, len 0x01f0 */
+			0x0600, /* ccdc, len 0x00a8 */
+			0x0a00, /* hist, len 0x0048 */
+			0x0c00, /* h3a, len 0x0060 */
+			0x0e00, /* preview, len 0x00a0 */
+			0x1000, /* resizer, len 0x00ac */
+			0x1200, /* sbl, len 0x00fc */
+			/* second MMIO area */
+			0x0000, /* csi2a, len 0x0170 */
+			0x0170, /* csiphy2, len 0x000c */
+		},
 		.syscon_offset = 0xdc,
 		.phy_type = ISP_PHY_TYPE_3430,
 	},
 	{
 		.isp_rev = ISP_REVISION_15_0,
-		.map = 1 << OMAP3_ISP_IOMEM_MAIN |
-		       1 << OMAP3_ISP_IOMEM_CCP2 |
-		       1 << OMAP3_ISP_IOMEM_CCDC |
-		       1 << OMAP3_ISP_IOMEM_HIST |
-		       1 << OMAP3_ISP_IOMEM_H3A |
-		       1 << OMAP3_ISP_IOMEM_PREV |
-		       1 << OMAP3_ISP_IOMEM_RESZ |
-		       1 << OMAP3_ISP_IOMEM_SBL |
-		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
-		       1 << OMAP3_ISP_IOMEM_CSIPHY2 |
-		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS2 |
-		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS1 |
-		       1 << OMAP3_ISP_IOMEM_CSIPHY1 |
-		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2,
+		.offset = {
+			/* first MMIO area */
+			0x0000, /* base, len 0x0070 */
+			0x0400, /* ccp2, len 0x01f0 */
+			0x0600, /* ccdc, len 0x00a8 */
+			0x0a00, /* hist, len 0x0048 */
+			0x0c00, /* h3a, len 0x0060 */
+			0x0e00, /* preview, len 0x00a0 */
+			0x1000, /* resizer, len 0x00ac */
+			0x1200, /* sbl, len 0x00fc */
+			/* second MMIO area */
+			0x0000, /* csi2a, len 0x0170 (1st area) */
+			0x0170, /* csiphy2, len 0x000c */
+			0x01c0, /* csi2a, len 0x0040 (2nd area) */
+			0x0400, /* csi2c, len 0x0170 (1st area) */
+			0x0570, /* csiphy1, len 0x000c */
+			0x05c0, /* csi2c, len 0x0040 (2nd area) */
+		},
 		.syscon_offset = 0x2f0,
 		.phy_type = ISP_PHY_TYPE_3630,
 	},
@@ -2235,27 +2243,6 @@ static int isp_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int isp_map_mem_resource(struct platform_device *pdev,
-				struct isp_device *isp,
-				enum isp_mem_resources res)
-{
-	struct resource *mem;
-
-	/* request the mem region for the camera registers */
-
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, res);
-
-	/* map the region */
-	isp->mmio_base[res] = devm_ioremap_resource(isp->dev, mem);
-	if (IS_ERR(isp->mmio_base[res]))
-		return PTR_ERR(isp->mmio_base[res]);
-
-	if (res == OMAP3_ISP_IOMEM_HIST)
-		isp->mmio_hist_base_phys = mem->start;
-
-	return 0;
-}
-
 /*
  * isp_probe - Probe ISP platform device
  * @pdev: Pointer to ISP platform device
@@ -2271,6 +2258,7 @@ static int isp_probe(struct platform_device *pdev)
 {
 	struct isp_platform_data *pdata = pdev->dev.platform_data;
 	struct isp_device *isp;
+	struct resource *mem;
 	int ret;
 	int i, m;
 
@@ -2303,10 +2291,21 @@ static int isp_probe(struct platform_device *pdev)
 	 *
 	 * The ISP clock tree is revision-dependent. We thus need to enable ICLK
 	 * manually to read the revision before calling __omap3isp_get().
+	 *
+	 * Start by mapping the ISP MMIO area, which is in two pieces.
+	 * The ISP IOMMU is in between. Map both now, and fill in the
+	 * ISP revision specific portions a little later in the
+	 * function.
 	 */
-	ret = isp_map_mem_resource(pdev, isp, OMAP3_ISP_IOMEM_MAIN);
-	if (ret < 0)
-		goto error;
+	for (i = 0; i < 2; i++) {
+		unsigned int map_idx = i ? OMAP3_ISP_IOMEM_CSI2A_REGS1 : 0;
+
+		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		isp->mmio_base[map_idx] =
+			devm_ioremap_resource(isp->dev, mem);
+		if (IS_ERR(isp->mmio_base[map_idx]))
+			return PTR_ERR(isp->mmio_base[map_idx]);
+	}
 
 	ret = isp_get_clocks(isp);
 	if (ret < 0)
@@ -2347,13 +2346,17 @@ static int isp_probe(struct platform_device *pdev)
 		goto error_isp;
 	}
 
-	for (i = 1; i < OMAP3_ISP_IOMEM_LAST; i++) {
-		if (isp_res_maps[m].map & 1 << i) {
-			ret = isp_map_mem_resource(pdev, isp, i);
-			if (ret)
-				goto error_isp;
-		}
-	}
+	for (i = 1; i < OMAP3_ISP_IOMEM_CSI2A_REGS1; i++)
+		isp->mmio_base[i] =
+			isp->mmio_base[0] + isp_res_maps[m].offset[i];
+
+	for (i = OMAP3_ISP_IOMEM_CSIPHY2; i < OMAP3_ISP_IOMEM_LAST; i++)
+		isp->mmio_base[i] =
+			isp->mmio_base[OMAP3_ISP_IOMEM_CSI2A_REGS1]
+			+ isp_res_maps[m].offset[i];
+
+	isp->mmio_hist_base_phys =
+		mem->start + isp_res_maps[m].offset[OMAP3_ISP_IOMEM_HIST];
 
 	isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
 	if (IS_ERR(isp->syscon)) {
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 03d2129..dcb7d20 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -99,7 +99,7 @@ struct regmap;
 /*
  * struct isp_res_mapping - Map ISP io resources to ISP revision.
  * @isp_rev: ISP_REVISION_x_x
- * @map: bitmap for enum isp_mem_resources
+ * @offset: register offsets of various ISP sub-blocks
  * @syscon_offset: offset of the syscon register for 343x / 3630
  *	    (CONTROL_CSIRXFE / CONTROL_CAMERA_PHY_CTRL, respectively)
  *	    from the syscon base address
@@ -107,7 +107,7 @@ struct regmap;
  */
 struct isp_res_mapping {
 	u32 isp_rev;
-	u32 map;
+	u32 offset[OMAP3_ISP_IOMEM_LAST];
 	u32 syscon_offset;
 	u32 phy_type;
 };
-- 
1.7.10.4

