Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36475 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab0G2QHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v3 09/12] ARM: OMAP3: Update Camera ISP definitions for OMAP3630
Date: Thu, 29 Jul 2010 18:06:53 +0200
Message-Id: <1280419616-7658-21-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>

Add new/changed base address definitions and resources for
OMAP3630 ISP.

The OMAP3430 CSI2PHY block is same as the OMAP3630 CSIPHY2
block. But the later name is chosen as it gives more symmetry
to the names.

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
---
 arch/arm/mach-omap2/devices.c              |   28 ++++++++++++++++++++++++----
 arch/arm/plat-omap/include/plat/omap34xx.h |   16 ++++++++++++----
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 03e6c9e..46b0b4b 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -107,13 +107,33 @@ static struct resource omap3isp_resources[] = {
 		.flags		= IORESOURCE_MEM,
 	},
 	{
-		.start		= OMAP3430_ISP_CSI2A_BASE,
-		.end		= OMAP3430_ISP_CSI2A_END,
+		.start		= OMAP3430_ISP_CSI2A_REGS1_BASE,
+		.end		= OMAP3430_ISP_CSI2A_REGS1_END,
 		.flags		= IORESOURCE_MEM,
 	},
 	{
-		.start		= OMAP3430_ISP_CSI2PHY_BASE,
-		.end		= OMAP3430_ISP_CSI2PHY_END,
+		.start		= OMAP3430_ISP_CSIPHY2_BASE,
+		.end		= OMAP3430_ISP_CSIPHY2_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3630_ISP_CSI2A_REGS2_BASE,
+		.end		= OMAP3630_ISP_CSI2A_REGS2_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3630_ISP_CSI2C_REGS1_BASE,
+		.end		= OMAP3630_ISP_CSI2C_REGS1_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3630_ISP_CSIPHY1_BASE,
+		.end		= OMAP3630_ISP_CSIPHY1_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3630_ISP_CSI2C_REGS2_BASE,
+		.end		= OMAP3630_ISP_CSI2C_REGS2_END,
 		.flags		= IORESOURCE_MEM,
 	},
 	{
diff --git a/arch/arm/plat-omap/include/plat/omap34xx.h b/arch/arm/plat-omap/include/plat/omap34xx.h
index 98fc8b4..b9e8588 100644
--- a/arch/arm/plat-omap/include/plat/omap34xx.h
+++ b/arch/arm/plat-omap/include/plat/omap34xx.h
@@ -56,8 +56,12 @@
 #define OMAP3430_ISP_RESZ_BASE		(OMAP3430_ISP_BASE + 0x1000)
 #define OMAP3430_ISP_SBL_BASE		(OMAP3430_ISP_BASE + 0x1200)
 #define OMAP3430_ISP_MMU_BASE		(OMAP3430_ISP_BASE + 0x1400)
-#define OMAP3430_ISP_CSI2A_BASE		(OMAP3430_ISP_BASE + 0x1800)
-#define OMAP3430_ISP_CSI2PHY_BASE	(OMAP3430_ISP_BASE + 0x1970)
+#define OMAP3430_ISP_CSI2A_REGS1_BASE	(OMAP3430_ISP_BASE + 0x1800)
+#define OMAP3430_ISP_CSIPHY2_BASE	(OMAP3430_ISP_BASE + 0x1970)
+#define OMAP3630_ISP_CSI2A_REGS2_BASE	(OMAP3430_ISP_BASE + 0x19C0)
+#define OMAP3630_ISP_CSI2C_REGS1_BASE	(OMAP3430_ISP_BASE + 0x1C00)
+#define OMAP3630_ISP_CSIPHY1_BASE	(OMAP3430_ISP_BASE + 0x1D70)
+#define OMAP3630_ISP_CSI2C_REGS2_BASE	(OMAP3430_ISP_BASE + 0x1DC0)
 
 #define OMAP3430_ISP_END		(OMAP3430_ISP_BASE         + 0x06F)
 #define OMAP3430_ISP_CBUFF_END		(OMAP3430_ISP_CBUFF_BASE   + 0x077)
@@ -69,8 +73,12 @@
 #define OMAP3430_ISP_RESZ_END		(OMAP3430_ISP_RESZ_BASE    + 0x0AB)
 #define OMAP3430_ISP_SBL_END		(OMAP3430_ISP_SBL_BASE     + 0x0FB)
 #define OMAP3430_ISP_MMU_END		(OMAP3430_ISP_MMU_BASE     + 0x06F)
-#define OMAP3430_ISP_CSI2A_END		(OMAP3430_ISP_CSI2A_BASE   + 0x16F)
-#define OMAP3430_ISP_CSI2PHY_END	(OMAP3430_ISP_CSI2PHY_BASE + 0x007)
+#define OMAP3430_ISP_CSI2A_REGS1_END	(OMAP3430_ISP_CSI2A_REGS1_BASE + 0x16F)
+#define OMAP3430_ISP_CSIPHY2_END	(OMAP3430_ISP_CSIPHY2_BASE + 0x00B)
+#define OMAP3630_ISP_CSI2A_REGS2_END	(OMAP3630_ISP_CSI2A_REGS2_BASE + 0x3F)
+#define OMAP3630_ISP_CSI2C_REGS1_END	(OMAP3630_ISP_CSI2C_REGS1_BASE + 0x16F)
+#define OMAP3630_ISP_CSIPHY1_END	(OMAP3630_ISP_CSIPHY1_BASE + 0x00B)
+#define OMAP3630_ISP_CSI2C_REGS2_END	(OMAP3630_ISP_CSI2C_REGS2_BASE + 0x3F)
 
 #define OMAP34XX_HSUSB_OTG_BASE	(L4_34XX_BASE + 0xAB000)
 #define OMAP34XX_USBTLL_BASE	(L4_34XX_BASE + 0x62000)
-- 
1.7.1

