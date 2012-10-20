Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56596 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753059Ab2JTOLV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 10:11:21 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com
Subject: [PATCH v5.1 1/3] omap3isp: Add CSI configuration registers from control block to ISP resources
Date: Sat, 20 Oct 2012 17:11:17 +0300
Message-Id: <1350742277-24528-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1651288.n5DBzW1A1K@avalon>
References: <1651288.n5DBzW1A1K@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the registers used to configure the CSI-2 receiver PHY on OMAP3430 and
3630 and map them in the ISP driver. The register is part of the control
block but it only is needed by the ISP driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Tony Lindgren <tony@atomide.com>
---
Hi Laurent,

Could you replace the patch I sent you with this one? I think there's a tiny
conflict there since the interrupt number definition suddenly changed.

 arch/arm/mach-omap2/devices.c         |   10 ++++++++++
 drivers/media/platform/omap3isp/isp.c |    6 ++++--
 drivers/media/platform/omap3isp/isp.h |    2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c8c2117..5f1ee96 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -200,6 +200,16 @@ static struct resource omap3isp_resources[] = {
 		.flags		= IORESOURCE_MEM,
 	},
 	{
+		.start		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE,
+		.end		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE + 3,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL,
+		.end		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL + 3,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
 		.start		= 24 + OMAP_INTC_START,
 		.flags		= IORESOURCE_IRQ,
 	}
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 99640d8..5ea5520 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -102,7 +102,8 @@ static const struct isp_res_mapping isp_res_maps[] = {
 		       1 << OMAP3_ISP_IOMEM_RESZ |
 		       1 << OMAP3_ISP_IOMEM_SBL |
 		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS1 |
-		       1 << OMAP3_ISP_IOMEM_CSIPHY2,
+		       1 << OMAP3_ISP_IOMEM_CSIPHY2 |
+		       1 << OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE,
 	},
 	{
 		.isp_rev = ISP_REVISION_15_0,
@@ -119,7 +120,8 @@ static const struct isp_res_mapping isp_res_maps[] = {
 		       1 << OMAP3_ISP_IOMEM_CSI2A_REGS2 |
 		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS1 |
 		       1 << OMAP3_ISP_IOMEM_CSIPHY1 |
-		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2,
+		       1 << OMAP3_ISP_IOMEM_CSI2C_REGS2 |
+		       1 << OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL,
 	},
 };
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 8be7487..6fed222 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -72,6 +72,8 @@ enum isp_mem_resources {
 	OMAP3_ISP_IOMEM_CSI2C_REGS1,
 	OMAP3_ISP_IOMEM_CSIPHY1,
 	OMAP3_ISP_IOMEM_CSI2C_REGS2,
+	OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE,
+	OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL,
 	OMAP3_ISP_IOMEM_LAST
 };
 
-- 
1.7.2.5

