Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50591 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZAMCDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:03:44 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Mon, 12 Jan 2009 20:03:13 -0600
Subject: [REVIEW PATCH 03/14] OMAP34XX: CAM: Resources fixes
Message-ID: <A24693684029E5489D1D202277BE894416429F99@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch reassigns resources of a omap3isp platform device,
which is more adequate than the older one. This is needed for
using __raw_[readl,writel] calls after ioremapping the specified
platform resources in ISP driver.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c              |   76 ++++++++++++++++++++++++++--
 arch/arm/plat-omap/include/mach/omap34xx.h |   53 +++++++++++++++++++-
 2 files changed, 123 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index d7e848e..4617c8b 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -56,10 +56,68 @@ static inline void omap_init_camera(void)
 
 #elif defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
 
-static struct resource cam_resources[] = {
+static struct resource omap34xxcam_resources[] = {
+};
+
+static struct resource omap3isp_resources[] = {
+	{
+		.start		= OMAP3_ISP_BASE,
+		.end		= OMAP3_ISP_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_CBUFF_BASE,
+		.end		= OMAP3_ISP_CBUFF_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_CCP2_BASE,
+		.end		= OMAP3_ISP_CCP2_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_CCDC_BASE,
+		.end		= OMAP3_ISP_CCDC_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_HIST_BASE,
+		.end		= OMAP3_ISP_HIST_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_H3A_BASE,
+		.end		= OMAP3_ISP_H3A_END,
+		.flags		= IORESOURCE_MEM,
+	},
 	{
-		.start		= OMAP34XX_CAMERA_BASE,
-		.end		= OMAP34XX_CAMERA_BASE + 0x1B70,
+		.start		= OMAP3_ISP_PREV_BASE,
+		.end		= OMAP3_ISP_PREV_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_RESZ_BASE,
+		.end		= OMAP3_ISP_RESZ_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_SBL_BASE,
+		.end		= OMAP3_ISP_SBL_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_MMU_BASE,
+		.end		= OMAP3_ISP_MMU_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_CSI2A_BASE,
+		.end		= OMAP3_ISP_CSI2A_END,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= OMAP3_ISP_CSI2PHY_BASE,
+		.end		= OMAP3_ISP_CSI2PHY_END,
 		.flags		= IORESOURCE_MEM,
 	},
 	{
@@ -71,13 +129,21 @@ static struct resource cam_resources[] = {
 static struct platform_device omap_cam_device = {
 	.name		= "omap34xxcam",
 	.id		= -1,
-	.num_resources	= ARRAY_SIZE(cam_resources),
-	.resource	= cam_resources,
+	.num_resources	= ARRAY_SIZE(omap34xxcam_resources),
+	.resource	= omap34xxcam_resources,
+};
+
+static struct platform_device omap_isp_device = {
+	.name		= "omap3isp",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(omap3isp_resources),
+	.resource	= omap3isp_resources,
 };
 
 static inline void omap_init_camera(void)
 {
 	platform_device_register(&omap_cam_device);
+	platform_device_register(&omap_isp_device);
 }
 #else
 static inline void omap_init_camera(void)
diff --git a/arch/arm/plat-omap/include/mach/omap34xx.h b/arch/arm/plat-omap/include/mach/omap34xx.h
index 27a1e45..d19c423 100644
--- a/arch/arm/plat-omap/include/mach/omap34xx.h
+++ b/arch/arm/plat-omap/include/mach/omap34xx.h
@@ -56,7 +56,32 @@
 #define OMAP34XX_SR1_BASE	0x480C9000
 #define OMAP34XX_SR2_BASE	0x480CB000
 
-#define OMAP34XX_CAMERA_BASE		(L4_34XX_BASE + 0xBC000)
+#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
+#define OMAP3430_ISP_CBUFF_BASE		(OMAP3430_ISP_BASE + 0x0100)
+#define OMAP3430_ISP_CCP2_BASE		(OMAP3430_ISP_BASE + 0x0400)
+#define OMAP3430_ISP_CCDC_BASE		(OMAP3430_ISP_BASE + 0x0600)
+#define OMAP3430_ISP_HIST_BASE		(OMAP3430_ISP_BASE + 0x0A00)
+#define OMAP3430_ISP_H3A_BASE		(OMAP3430_ISP_BASE + 0x0C00)
+#define OMAP3430_ISP_PREV_BASE		(OMAP3430_ISP_BASE + 0x0E00)
+#define OMAP3430_ISP_RESZ_BASE		(OMAP3430_ISP_BASE + 0x1000)
+#define OMAP3430_ISP_SBL_BASE		(OMAP3430_ISP_BASE + 0x1200)
+#define OMAP3430_ISP_MMU_BASE		(OMAP3430_ISP_BASE + 0x1400)
+#define OMAP3430_ISP_CSI2A_BASE		(OMAP3430_ISP_BASE + 0x1800)
+#define OMAP3430_ISP_CSI2PHY_BASE	(OMAP3430_ISP_BASE + 0x1970)
+
+#define OMAP3430_ISP_END		(OMAP3430_ISP_BASE         + 0x06F)
+#define OMAP3430_ISP_CBUFF_END		(OMAP3430_ISP_CBUFF_BASE   + 0x077)
+#define OMAP3430_ISP_CCP2_END		(OMAP3430_ISP_CCP2_BASE    + 0x1EF)
+#define OMAP3430_ISP_CCDC_END		(OMAP3430_ISP_CCDC_BASE    + 0x0A7)
+#define OMAP3430_ISP_HIST_END		(OMAP3430_ISP_HIST_BASE    + 0x047)
+#define OMAP3430_ISP_H3A_END		(OMAP3430_ISP_H3A_BASE     + 0x05F)
+#define OMAP3430_ISP_PREV_END		(OMAP3430_ISP_PREV_BASE    + 0x09F)
+#define OMAP3430_ISP_RESZ_END		(OMAP3430_ISP_RESZ_BASE    + 0x0AB)
+#define OMAP3430_ISP_SBL_END		(OMAP3430_ISP_SBL_BASE     + 0x0FB)
+#define OMAP3430_ISP_MMU_END		(OMAP3430_ISP_MMU_BASE     + 0x06F)
+#define OMAP3430_ISP_CSI2A_END		(OMAP3430_ISP_CSI2A_BASE   + 0x16F)
+#define OMAP3430_ISP_CSI2PHY_END	(OMAP3430_ISP_CSI2PHY_BASE + 0x007)
+
 #define OMAP34XX_MAILBOX_BASE		(L4_34XX_BASE + 0x94000)
 
 
@@ -67,6 +92,32 @@
 #define OMAP2_PRM_BASE			OMAP3430_PRM_BASE
 #define OMAP2_VA_IC_BASE		IO_ADDRESS(OMAP34XX_IC_BASE)
 
+#define OMAP3_ISP_BASE			OMAP3430_ISP_BASE
+#define OMAP3_ISP_CBUFF_BASE		OMAP3430_ISP_CBUFF_BASE
+#define OMAP3_ISP_CCP2_BASE		OMAP3430_ISP_CCP2_BASE
+#define OMAP3_ISP_CCDC_BASE		OMAP3430_ISP_CCDC_BASE
+#define OMAP3_ISP_HIST_BASE		OMAP3430_ISP_HIST_BASE
+#define OMAP3_ISP_H3A_BASE		OMAP3430_ISP_H3A_BASE
+#define OMAP3_ISP_PREV_BASE		OMAP3430_ISP_PREV_BASE
+#define OMAP3_ISP_RESZ_BASE		OMAP3430_ISP_RESZ_BASE
+#define OMAP3_ISP_SBL_BASE		OMAP3430_ISP_SBL_BASE
+#define OMAP3_ISP_MMU_BASE		OMAP3430_ISP_MMU_BASE
+#define OMAP3_ISP_CSI2A_BASE		OMAP3430_ISP_CSI2A_BASE
+#define OMAP3_ISP_CSI2PHY_BASE		OMAP3430_ISP_CSI2PHY_BASE
+
+#define OMAP3_ISP_END			OMAP3430_ISP_END
+#define OMAP3_ISP_CBUFF_END		OMAP3430_ISP_CBUFF_END
+#define OMAP3_ISP_CCP2_END		OMAP3430_ISP_CCP2_END
+#define OMAP3_ISP_CCDC_END		OMAP3430_ISP_CCDC_END
+#define OMAP3_ISP_HIST_END		OMAP3430_ISP_HIST_END
+#define OMAP3_ISP_H3A_END		OMAP3430_ISP_H3A_END
+#define OMAP3_ISP_PREV_END		OMAP3430_ISP_PREV_END
+#define OMAP3_ISP_RESZ_END		OMAP3430_ISP_RESZ_END
+#define OMAP3_ISP_SBL_END		OMAP3430_ISP_SBL_END
+#define OMAP3_ISP_MMU_END		OMAP3430_ISP_MMU_END
+#define OMAP3_ISP_CSI2A_END		OMAP3430_ISP_CSI2A_END
+#define OMAP3_ISP_CSI2PHY_END		OMAP3430_ISP_CSI2PHY_END
+
 #endif
 
 #define OMAP34XX_DSP_BASE	0x58000000
-- 
1.5.6.5

