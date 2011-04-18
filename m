Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27329 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab1DRJ1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 05:27:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 18 Apr 2011 11:26:39 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
In-reply-to: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1303118804-5575-3-git-send-email-m.szyprowski@samsung.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch performs a complete rewrite of sysmmu driver for Samsung platform:
- simplified the resource management: no more single platform
  device with 32 resources is needed, better fits into linux driver model,
  each sysmmu instance has it's own resource definition
- the new version uses kernel wide common iommu api defined in include/iommu.h
- cleaned support for sysmmu clocks
- added support for custom fault handlers and tlb replacement policy

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-exynos4/clock.c               |   68 +-
 arch/arm/mach-exynos4/dev-sysmmu.c          |  615 +++++++++------
 arch/arm/mach-exynos4/include/mach/irqs.h   |   35 +-
 arch/arm/mach-exynos4/include/mach/sysmmu.h |   46 -
 arch/arm/plat-s5p/Kconfig                   |   20 +-
 arch/arm/plat-s5p/include/plat/sysmmu.h     |  241 ++++---
 arch/arm/plat-s5p/sysmmu.c                  | 1191 ++++++++++++++++++++-------
 arch/arm/plat-samsung/include/plat/devs.h   |    2 +-
 8 files changed, 1478 insertions(+), 740 deletions(-)
 rewrite arch/arm/mach-exynos4/dev-sysmmu.c (88%)
 delete mode 100644 arch/arm/mach-exynos4/include/mach/sysmmu.h
 rewrite arch/arm/plat-s5p/include/plat/sysmmu.h (83%)
 rewrite arch/arm/plat-s5p/sysmmu.c (87%)

diff --git a/arch/arm/mach-exynos4/clock.c b/arch/arm/mach-exynos4/clock.c
index 871f9d5..963195e 100644
--- a/arch/arm/mach-exynos4/clock.c
+++ b/arch/arm/mach-exynos4/clock.c
@@ -20,10 +20,10 @@
 #include <plat/pll.h>
 #include <plat/s5p-clock.h>
 #include <plat/clock-clksrc.h>
+#include <plat/sysmmu.h>
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
-#include <mach/sysmmu.h>
 
 static struct clk clk_sclk_hdmi27m = {
 	.name		= "sclk_hdmi27m",
@@ -127,6 +127,11 @@ static int exynos4_clk_ip_perir_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_IP_PERIR, clk, enable);
 }
 
+static int exynos4_clk_ip_dmc_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_DMC, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk clk_mout_apll = {
@@ -614,75 +619,80 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 13),
 	}, {
-		.name		= "SYSMMU_MDMA",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_MDMA,
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 5),
 	}, {
-		.name		= "SYSMMU_FIMC0",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC0,
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 7),
 	}, {
-		.name		= "SYSMMU_FIMC1",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC1,
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 8),
 	}, {
-		.name		= "SYSMMU_FIMC2",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC2,
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 9),
 	}, {
-		.name		= "SYSMMU_FIMC3",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC3,
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 10),
 	}, {
-		.name		= "SYSMMU_JPEG",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_JPEG,
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 11),
 	}, {
-		.name		= "SYSMMU_FIMD0",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMD0,
 		.enable		= exynos4_clk_ip_lcd0_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_FIMD1",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMD1,
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_PCIe",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_PCIe,
 		.enable		= exynos4_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 18),
 	}, {
-		.name		= "SYSMMU_G2D",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_G2D,
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
-		.name		= "SYSMMU_ROTATOR",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_ROTATOR,
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_TV",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_TV,
 		.enable		= exynos4_clk_ip_tv_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_MFC_L",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_MFC_L,
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 1),
 	}, {
-		.name		= "SYSMMU_MFC_R",
-		.id		= -1,
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_MFC_R,
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_SSS,
+		.enable		= exynos4_clk_ip_dmc_ctrl,
+		.ctrlbit	= (1 << 12),
 	}
 };
 
diff --git a/arch/arm/mach-exynos4/dev-sysmmu.c b/arch/arm/mach-exynos4/dev-sysmmu.c
dissimilarity index 88%
index 3b7cae0..23c3a6e 100644
--- a/arch/arm/mach-exynos4/dev-sysmmu.c
+++ b/arch/arm/mach-exynos4/dev-sysmmu.c
@@ -1,232 +1,383 @@
-/* linux/arch/arm/mach-exynos4/dev-sysmmu.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS4 - System MMU support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
-
-#include <mach/map.h>
-#include <mach/irqs.h>
-#include <mach/sysmmu.h>
-#include <plat/s5p-clock.h>
-
-/* These names must be equal to the clock names in mach-exynos4/clock.c */
-const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM] = {
-	"SYSMMU_MDMA"	,
-	"SYSMMU_SSS"	,
-	"SYSMMU_FIMC0"	,
-	"SYSMMU_FIMC1"	,
-	"SYSMMU_FIMC2"	,
-	"SYSMMU_FIMC3"	,
-	"SYSMMU_JPEG"	,
-	"SYSMMU_FIMD0"	,
-	"SYSMMU_FIMD1"	,
-	"SYSMMU_PCIe"	,
-	"SYSMMU_G2D"	,
-	"SYSMMU_ROTATOR",
-	"SYSMMU_MDMA2"	,
-	"SYSMMU_TV"	,
-	"SYSMMU_MFC_L"	,
-	"SYSMMU_MFC_R"	,
-};
-
-static struct resource exynos4_sysmmu_resource[] = {
-	[0] = {
-		.start	= EXYNOS4_PA_SYSMMU_MDMA,
-		.end	= EXYNOS4_PA_SYSMMU_MDMA + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= IRQ_SYSMMU_MDMA0_0,
-		.end	= IRQ_SYSMMU_MDMA0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = {
-		.start	= EXYNOS4_PA_SYSMMU_SSS,
-		.end	= EXYNOS4_PA_SYSMMU_SSS + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[3] = {
-		.start	= IRQ_SYSMMU_SSS_0,
-		.end	= IRQ_SYSMMU_SSS_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[4] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC0,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[5] = {
-		.start	= IRQ_SYSMMU_FIMC0_0,
-		.end	= IRQ_SYSMMU_FIMC0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[6] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC1,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[7] = {
-		.start	= IRQ_SYSMMU_FIMC1_0,
-		.end	= IRQ_SYSMMU_FIMC1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[8] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC2,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[9] = {
-		.start	= IRQ_SYSMMU_FIMC2_0,
-		.end	= IRQ_SYSMMU_FIMC2_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[10] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC3,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC3 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[11] = {
-		.start	= IRQ_SYSMMU_FIMC3_0,
-		.end	= IRQ_SYSMMU_FIMC3_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[12] = {
-		.start	= EXYNOS4_PA_SYSMMU_JPEG,
-		.end	= EXYNOS4_PA_SYSMMU_JPEG + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[13] = {
-		.start	= IRQ_SYSMMU_JPEG_0,
-		.end	= IRQ_SYSMMU_JPEG_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[14] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMD0,
-		.end	= EXYNOS4_PA_SYSMMU_FIMD0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[15] = {
-		.start	= IRQ_SYSMMU_LCD0_M0_0,
-		.end	= IRQ_SYSMMU_LCD0_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[16] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMD1,
-		.end	= EXYNOS4_PA_SYSMMU_FIMD1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[17] = {
-		.start	= IRQ_SYSMMU_LCD1_M1_0,
-		.end	= IRQ_SYSMMU_LCD1_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[18] = {
-		.start	= EXYNOS4_PA_SYSMMU_PCIe,
-		.end	= EXYNOS4_PA_SYSMMU_PCIe + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[19] = {
-		.start	= IRQ_SYSMMU_PCIE_0,
-		.end	= IRQ_SYSMMU_PCIE_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[20] = {
-		.start	= EXYNOS4_PA_SYSMMU_G2D,
-		.end	= EXYNOS4_PA_SYSMMU_G2D + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[21] = {
-		.start	= IRQ_SYSMMU_2D_0,
-		.end	= IRQ_SYSMMU_2D_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[22] = {
-		.start	= EXYNOS4_PA_SYSMMU_ROTATOR,
-		.end	= EXYNOS4_PA_SYSMMU_ROTATOR + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[23] = {
-		.start	= IRQ_SYSMMU_ROTATOR_0,
-		.end	= IRQ_SYSMMU_ROTATOR_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[24] = {
-		.start	= EXYNOS4_PA_SYSMMU_MDMA2,
-		.end	= EXYNOS4_PA_SYSMMU_MDMA2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[25] = {
-		.start	= IRQ_SYSMMU_MDMA1_0,
-		.end	= IRQ_SYSMMU_MDMA1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[26] = {
-		.start	= EXYNOS4_PA_SYSMMU_TV,
-		.end	= EXYNOS4_PA_SYSMMU_TV + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[27] = {
-		.start	= IRQ_SYSMMU_TV_M0_0,
-		.end	= IRQ_SYSMMU_TV_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[28] = {
-		.start	= EXYNOS4_PA_SYSMMU_MFC_L,
-		.end	= EXYNOS4_PA_SYSMMU_MFC_L + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[29] = {
-		.start	= IRQ_SYSMMU_MFC_M0_0,
-		.end	= IRQ_SYSMMU_MFC_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[30] = {
-		.start	= EXYNOS4_PA_SYSMMU_MFC_R,
-		.end	= EXYNOS4_PA_SYSMMU_MFC_R + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[31] = {
-		.start	= IRQ_SYSMMU_MFC_M1_0,
-		.end	= IRQ_SYSMMU_MFC_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device exynos4_device_sysmmu = {
-	.name		= "s5p-sysmmu",
-	.id		= 32,
-	.num_resources	= ARRAY_SIZE(exynos4_sysmmu_resource),
-	.resource	= exynos4_sysmmu_resource,
-};
-EXPORT_SYMBOL(exynos4_device_sysmmu);
-
-static struct clk *sysmmu_clk[S5P_SYSMMU_TOTAL_IPNUM];
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips)
-{
-	sysmmu_clk[ips] = clk_get(dev, sysmmu_ips_name[ips]);
-	if (IS_ERR(sysmmu_clk[ips]))
-		sysmmu_clk[ips] = NULL;
-	else
-		clk_put(sysmmu_clk[ips]);
-}
-
-void sysmmu_clk_enable(sysmmu_ips ips)
-{
-	if (sysmmu_clk[ips])
-		clk_enable(sysmmu_clk[ips]);
-}
-
-void sysmmu_clk_disable(sysmmu_ips ips)
-{
-	if (sysmmu_clk[ips])
-		clk_disable(sysmmu_clk[ips]);
-}
+/* linux/arch/arm/mach-exynos4/dev-sysmmu.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS4 - System MMU support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+
+#include <mach/map.h>
+#include <mach/irqs.h>
+
+#include <plat/devs.h>
+#include <plat/cpu.h>
+#include <plat/sysmmu.h>
+
+#define EXYNOS4_NUM_RESOURCES (2)
+
+static struct resource exynos4_sysmmu_resource[][EXYNOS4_NUM_RESOURCES] = {
+	[S5P_SYSMMU_MDMA] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_MDMA,
+			.end	= EXYNOS4_PA_SYSMMU_MDMA + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_MDMA0,
+			.end	= IRQ_SYSMMU_MDMA0,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_SSS] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_SSS,
+			.end	= EXYNOS4_PA_SYSMMU_SSS + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_SSS,
+			.end	= IRQ_SYSMMU_SSS,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_FIMC0] = {
+		[0] = {
+			.start = EXYNOS4_PA_SYSMMU_FIMC0,
+			.end   = EXYNOS4_PA_SYSMMU_FIMC0 + SZ_4K - 1,
+			.flags = IORESOURCE_MEM,
+		},
+		[1] = {
+			.start = IRQ_SYSMMU_FIMC0,
+			.end   = IRQ_SYSMMU_FIMC0,
+			.flags = IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_FIMC1] = {
+		[0] = {
+			.start = EXYNOS4_PA_SYSMMU_FIMC1,
+			.end   = EXYNOS4_PA_SYSMMU_FIMC1 + SZ_4K - 1,
+			.flags = IORESOURCE_MEM,
+		},
+		[1] = {
+			.start = IRQ_SYSMMU_FIMC1,
+			.end   = IRQ_SYSMMU_FIMC1,
+			.flags = IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_FIMC2] = {
+		[0] = {
+			.start = EXYNOS4_PA_SYSMMU_FIMC2,
+			.end   = EXYNOS4_PA_SYSMMU_FIMC2 + SZ_4K - 1,
+			.flags = IORESOURCE_MEM,
+		},
+		[1] = {
+			.start = IRQ_SYSMMU_FIMC2,
+			.end   = IRQ_SYSMMU_FIMC2,
+			.flags = IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_FIMC3] = {
+		[0] = {
+			.start = EXYNOS4_PA_SYSMMU_FIMC3,
+			.end   = EXYNOS4_PA_SYSMMU_FIMC3 + SZ_4K - 1,
+			.flags = IORESOURCE_MEM,
+		},
+		[1] = {
+			.start = IRQ_SYSMMU_FIMC3,
+			.end   = IRQ_SYSMMU_FIMC3,
+			.flags = IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_JPEG] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_JPEG,
+			.end	= EXYNOS4_PA_SYSMMU_JPEG + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_JPEG,
+			.end	= IRQ_SYSMMU_JPEG,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_FIMD0] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_FIMD0,
+			.end	= EXYNOS4_PA_SYSMMU_FIMD0 + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_FIMD0,
+			.end	= IRQ_SYSMMU_FIMD0,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_FIMD1] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_FIMD1,
+			.end	= EXYNOS4_PA_SYSMMU_FIMD1 + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_FIMD1,
+			.end	= IRQ_SYSMMU_FIMD1,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_PCIe] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_PCIe,
+			.end	= EXYNOS4_PA_SYSMMU_PCIe + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_PCIE,
+			.end	= IRQ_SYSMMU_PCIE,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_G2D] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_G2D,
+			.end	= EXYNOS4_PA_SYSMMU_G2D + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_2D,
+			.end	= IRQ_SYSMMU_2D,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_ROTATOR] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_ROTATOR,
+			.end	= EXYNOS4_PA_SYSMMU_ROTATOR + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_ROTATOR,
+			.end	= IRQ_SYSMMU_ROTATOR,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_MDMA2] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_MDMA2,
+			.end	= EXYNOS4_PA_SYSMMU_MDMA2 + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_MDMA1,
+			.end	= IRQ_SYSMMU_MDMA1,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_TV] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_TV,
+			.end	= EXYNOS4_PA_SYSMMU_TV + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_TV,
+			.end	= IRQ_SYSMMU_TV,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_MFC_L] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_MFC_L,
+			.end	= EXYNOS4_PA_SYSMMU_MFC_L + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_MFC_L,
+			.end	= IRQ_SYSMMU_MFC_L,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+	[S5P_SYSMMU_MFC_R] = {
+		[0] = {
+			.start	= EXYNOS4_PA_SYSMMU_MFC_R,
+			.end	= EXYNOS4_PA_SYSMMU_MFC_R + SZ_4K - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+		[1] = {
+			.start	= IRQ_SYSMMU_MFC_R,
+			.end	= IRQ_SYSMMU_MFC_R,
+			.flags	= IORESOURCE_IRQ,
+		},
+	},
+};
+
+static u64 exynos4_sysmmu_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device exynos4_device_sysmmu[] = {
+	[S5P_SYSMMU_MDMA] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MDMA,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_MDMA],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_SSS] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_SSS,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_SSS],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC0] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC0,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_FIMC0],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC1] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC1,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_FIMC1],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC2] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC2,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_FIMC2],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC3] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC3,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_FIMC3],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_JPEG] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_JPEG,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_JPEG],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMD0] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMD0,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_FIMD0],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMD1] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMD1,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_FIMD1],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_PCIe] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_PCIe,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_PCIe],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_G2D] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_G2D,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_G2D],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_ROTATOR] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_ROTATOR,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_ROTATOR],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_MDMA2] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MDMA2,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_MDMA2],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_TV] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_TV,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_TV],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_MFC_L] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MFC_L,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_MFC_L],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_MFC_R] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MFC_R,
+		.num_resources	= EXYNOS4_NUM_RESOURCES,
+		.resource	= exynos4_sysmmu_resource[S5P_SYSMMU_MFC_R],
+		.dev		= {
+			.dma_mask		= &exynos4_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+};
diff --git a/arch/arm/mach-exynos4/include/mach/irqs.h b/arch/arm/mach-exynos4/include/mach/irqs.h
index 5d03730..ad1d00c 100644
--- a/arch/arm/mach-exynos4/include/mach/irqs.h
+++ b/arch/arm/mach-exynos4/include/mach/irqs.h
@@ -55,23 +55,23 @@
 #define COMBINER_GROUP(x)	((x) * MAX_IRQ_IN_COMBINER + IRQ_SPI(64))
 #define COMBINER_IRQ(x, y)	(COMBINER_GROUP(x) + y)
 
-#define IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(4, 0)
-#define IRQ_SYSMMU_SSS_0	COMBINER_IRQ(4, 1)
-#define IRQ_SYSMMU_FIMC0_0	COMBINER_IRQ(4, 2)
-#define IRQ_SYSMMU_FIMC1_0	COMBINER_IRQ(4, 3)
-#define IRQ_SYSMMU_FIMC2_0	COMBINER_IRQ(4, 4)
-#define IRQ_SYSMMU_FIMC3_0	COMBINER_IRQ(4, 5)
-#define IRQ_SYSMMU_JPEG_0	COMBINER_IRQ(4, 6)
-#define IRQ_SYSMMU_2D_0		COMBINER_IRQ(4, 7)
-
-#define IRQ_SYSMMU_ROTATOR_0	COMBINER_IRQ(5, 0)
-#define IRQ_SYSMMU_MDMA1_0	COMBINER_IRQ(5, 1)
-#define IRQ_SYSMMU_LCD0_M0_0	COMBINER_IRQ(5, 2)
-#define IRQ_SYSMMU_LCD1_M1_0	COMBINER_IRQ(5, 3)
-#define IRQ_SYSMMU_TV_M0_0	COMBINER_IRQ(5, 4)
-#define IRQ_SYSMMU_MFC_M0_0	COMBINER_IRQ(5, 5)
-#define IRQ_SYSMMU_MFC_M1_0	COMBINER_IRQ(5, 6)
-#define IRQ_SYSMMU_PCIE_0	COMBINER_IRQ(5, 7)
+#define IRQ_SYSMMU_MDMA0	COMBINER_IRQ(4, 0)
+#define IRQ_SYSMMU_SSS		COMBINER_IRQ(4, 1)
+#define IRQ_SYSMMU_FIMC0	COMBINER_IRQ(4, 2)
+#define IRQ_SYSMMU_FIMC1	COMBINER_IRQ(4, 3)
+#define IRQ_SYSMMU_FIMC2	COMBINER_IRQ(4, 4)
+#define IRQ_SYSMMU_FIMC3	COMBINER_IRQ(4, 5)
+#define IRQ_SYSMMU_JPEG		COMBINER_IRQ(4, 6)
+#define IRQ_SYSMMU_2D		COMBINER_IRQ(4, 7)
+
+#define IRQ_SYSMMU_ROTATOR	COMBINER_IRQ(5, 0)
+#define IRQ_SYSMMU_MDMA1	COMBINER_IRQ(5, 1)
+#define IRQ_SYSMMU_FIMD0	COMBINER_IRQ(5, 2)
+#define IRQ_SYSMMU_FIMD1	COMBINER_IRQ(5, 3)
+#define IRQ_SYSMMU_TV		COMBINER_IRQ(5, 4)
+#define IRQ_SYSMMU_MFC_L	COMBINER_IRQ(5, 5)
+#define IRQ_SYSMMU_MFC_R	COMBINER_IRQ(5, 6)
+#define IRQ_SYSMMU_PCIE		COMBINER_IRQ(5, 7)
 
 #define IRQ_PDMA0		COMBINER_IRQ(21, 0)
 #define IRQ_PDMA1		COMBINER_IRQ(21, 1)
@@ -157,4 +157,5 @@
 /* Set the default NR_IRQS */
 #define NR_IRQS			(IRQ_GPIO_END)
 
+
 #endif /* __ASM_ARCH_IRQS_H */
diff --git a/arch/arm/mach-exynos4/include/mach/sysmmu.h b/arch/arm/mach-exynos4/include/mach/sysmmu.h
deleted file mode 100644
index 6a5fbb5..0000000
--- a/arch/arm/mach-exynos4/include/mach/sysmmu.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* linux/arch/arm/mach-exynos4/include/mach/sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Samsung sysmmu driver for EXYNOS4
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARM_ARCH_SYSMMU_H
-#define __ASM_ARM_ARCH_SYSMMU_H __FILE__
-
-enum exynos4_sysmmu_ips {
-	SYSMMU_MDMA,
-	SYSMMU_SSS,
-	SYSMMU_FIMC0,
-	SYSMMU_FIMC1,
-	SYSMMU_FIMC2,
-	SYSMMU_FIMC3,
-	SYSMMU_JPEG,
-	SYSMMU_FIMD0,
-	SYSMMU_FIMD1,
-	SYSMMU_PCIe,
-	SYSMMU_G2D,
-	SYSMMU_ROTATOR,
-	SYSMMU_MDMA2,
-	SYSMMU_TV,
-	SYSMMU_MFC_L,
-	SYSMMU_MFC_R,
-	EXYNOS4_SYSMMU_TOTAL_IPNUM,
-};
-
-#define S5P_SYSMMU_TOTAL_IPNUM		EXYNOS4_SYSMMU_TOTAL_IPNUM
-
-extern const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM];
-
-typedef enum exynos4_sysmmu_ips sysmmu_ips;
-
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips);
-void sysmmu_clk_enable(sysmmu_ips ips);
-void sysmmu_clk_disable(sysmmu_ips ips);
-
-#endif /* __ASM_ARM_ARCH_SYSMMU_H */
diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 8492297..9a7805b 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -42,14 +42,6 @@ config S5P_HRT
 	help
 	  Use the High Resolution timer support
 
-comment "System MMU"
-
-config S5P_SYSTEM_MMU
-	bool "S5P SYSTEM MMU"
-	depends on ARCH_EXYNOS4
-	help
-	  Say Y here if you want to enable System MMU
-
 config S5P_DEV_FIMC0
 	bool
 	help
@@ -89,3 +81,15 @@ config S5P_SETUP_MIPIPHY
 	bool
 	help
 	  Compile in common setup code for MIPI-CSIS and MIPI-DSIM devices
+
+comment "System MMU"
+
+config IOMMU_API
+	bool
+
+config S5P_SYSTEM_MMU
+	bool "S5P SYSTEM MMU"
+	depends on ARCH_EXYNOS4
+	select IOMMU_API
+	help
+	  Say Y here if you want to enable System MMU
diff --git a/arch/arm/plat-s5p/include/plat/sysmmu.h b/arch/arm/plat-s5p/include/plat/sysmmu.h
dissimilarity index 83%
index bf5283c..ee9e6d0 100644
--- a/arch/arm/plat-s5p/include/plat/sysmmu.h
+++ b/arch/arm/plat-s5p/include/plat/sysmmu.h
@@ -1,95 +1,146 @@
-/* linux/arch/arm/plat-s5p/include/plat/sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Samsung System MMU driver for S5P platform
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM__PLAT_SYSMMU_H
-#define __ASM__PLAT_SYSMMU_H __FILE__
-
-enum S5P_SYSMMU_INTERRUPT_TYPE {
-	SYSMMU_PAGEFAULT,
-	SYSMMU_AR_MULTIHIT,
-	SYSMMU_AW_MULTIHIT,
-	SYSMMU_BUSERROR,
-	SYSMMU_AR_SECURITY,
-	SYSMMU_AR_ACCESS,
-	SYSMMU_AW_SECURITY,
-	SYSMMU_AW_PROTECTION, /* 7 */
-	SYSMMU_FAULTS_NUM
-};
-
-#ifdef CONFIG_S5P_SYSTEM_MMU
-
-#include <mach/sysmmu.h>
-
-/**
- * s5p_sysmmu_enable() - enable system mmu of ip
- * @ips: The ip connected system mmu.
- * #pgd: Base physical address of the 1st level page table
- *
- * This function enable system mmu to transfer address
- * from virtual address to physical address
- */
-void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_disable() - disable sysmmu mmu of ip
- * @ips: The ip connected system mmu.
- *
- * This function disable system mmu to transfer address
- * from virtual address to physical address
- */
-void s5p_sysmmu_disable(sysmmu_ips ips);
-
-/**
- * s5p_sysmmu_set_tablebase_pgd() - set page table base address to refer page table
- * @ips: The ip connected system mmu.
- * @pgd: The page table base address.
- *
- * This function set page table base address
- * When system mmu transfer address from virtaul address to physical address,
- * system mmu refer address information from page table
- */
-void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_tlb_invalidate() - flush all TLB entry in system mmu
- * @ips: The ip connected system mmu.
- *
- * This function flush all TLB entry in system mmu
- */
-void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips);
-
-/** s5p_sysmmu_set_fault_handler() - Fault handler for System MMUs
- * @itype: type of fault.
- * @pgtable_base: the physical address of page table base. This is 0 if @ips is
- *               SYSMMU_BUSERROR.
- * @fault_addr: the device (virtual) address that the System MMU tried to
- *             translated. This is 0 if @ips is SYSMMU_BUSERROR.
- * Called when interrupt occurred by the System MMUs
- * The device drivers of peripheral devices that has a System MMU can implement
- * a fault handler to resolve address translation fault by System MMU.
- * The meanings of return value and parameters are described below.
-
- * return value: non-zero if the fault is correctly resolved.
- *         zero if the fault is not handled.
- */
-void s5p_sysmmu_set_fault_handler(sysmmu_ips ips,
-			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-					unsigned long pgtable_base,
-					unsigned long fault_addr));
-#else
-#define s5p_sysmmu_enable(ips, pgd) do { } while (0)
-#define s5p_sysmmu_disable(ips) do { } while (0)
-#define s5p_sysmmu_set_tablebase_pgd(ips, pgd) do { } while (0)
-#define s5p_sysmmu_tlb_invalidate(ips) do { } while (0)
-#define s5p_sysmmu_set_fault_handler(ips, handler) do { } while (0)
-#endif
-#endif /* __ASM_PLAT_SYSMMU_H */
+/* linux/arch/arm/plat-s5p/include/plat/sysmmu.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * Samsung System MMU driver for S5P platform
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ASM__PLAT_SYSMMU_H
+#define __ASM__PLAT_SYSMMU_H __FILE__
+
+struct device;
+struct iommu_domain;
+
+/**
+ * enum s5p_sysmmu_ip - integrated peripherals identifiers
+ * @S5P_SYSMMU_MDMA:	MDMA
+ * @S5P_SYSMMU_SSS:	SSS
+ * @S5P_SYSMMU_FIMC0:	FIMC0
+ * @S5P_SYSMMU_FIMC1:	FIMC1
+ * @S5P_SYSMMU_FIMC2:	FIMC2
+ * @S5P_SYSMMU_FIMC3:	FIMC3
+ * @S5P_SYSMMU_JPEG:	JPEG
+ * @S5P_SYSMMU_FIMD0:	FIMD0
+ * @S5P_SYSMMU_FIMD1:	FIMD1
+ * @S5P_SYSMMU_PCIe:	PCIe
+ * @S5P_SYSMMU_G2D:	G2D
+ * @S5P_SYSMMU_ROTATOR:	ROTATOR
+ * @S5P_SYSMMU_MDMA2:	MDMA2
+ * @S5P_SYSMMU_TV:	TV
+ * @S5P_SYSMMU_MFC_L:	MFC_L
+ * @S5P_SYSMMU_MFC_R:	MFC_R
+ */
+enum s5p_sysmmu_ip {
+	S5P_SYSMMU_MDMA,
+	S5P_SYSMMU_SSS,
+	S5P_SYSMMU_FIMC0,
+	S5P_SYSMMU_FIMC1,
+	S5P_SYSMMU_FIMC2,
+	S5P_SYSMMU_FIMC3,
+	S5P_SYSMMU_JPEG,
+	S5P_SYSMMU_FIMD0,
+	S5P_SYSMMU_FIMD1,
+	S5P_SYSMMU_PCIe,
+	S5P_SYSMMU_G2D,
+	S5P_SYSMMU_ROTATOR,
+	S5P_SYSMMU_MDMA2,
+	S5P_SYSMMU_TV,
+	S5P_SYSMMU_MFC_L,
+	S5P_SYSMMU_MFC_R,
+	S5P_SYSMMU_TOTAL_IP_NUM,
+};
+
+/**
+ * enum s5p_sysmmu_fault - reason of the raised sysmmu irq
+ * @S5P_SYSMMU_PAGE_FAULT
+ * @S5P_SYSMMU_AR_FAULT
+ * @S5P_SYSMMU_AW_FAULT
+ * @S5P_SYSMMU_BUS_ERROR
+ * @S5P_SYSMMU_AR_SECURITY
+ * @S5P_SYSMMU_AR_PROT
+ * @S5P_SYSMMU_AW_SECURITY
+ * @S5P_SYSMMU_AW_PROT
+ */
+enum s5p_sysmmu_fault {
+	S5P_SYSMMU_PAGE_FAULT,
+	S5P_SYSMMU_AR_FAULT,
+	S5P_SYSMMU_AW_FAULT,
+	S5P_SYSMMU_BUS_ERROR,
+	S5P_SYSMMU_AR_SECURITY,
+	S5P_SYSMMU_AR_PROT,
+	S5P_SYSMMU_AW_SECURITY,
+	S5P_SYSMMU_AW_PROT,
+};
+
+/**
+ * enum s5p_sysmmu_tlb_policy - policy of using the tlb
+ * @S5P_SYSMMU_TLB_RR:	round robin policy
+ * @S5P_SYSMMU_TLB_LRU: least recently used policy
+ */
+enum s5p_sysmmu_tlb_policy {
+	S5P_SYSMMU_TLB_RR,
+	S5P_SYSMMU_TLB_LRU,
+};
+
+#define S5P_IRQ_CB(name) \
+	void (*name)(struct iommu_domain *domain, int reason, \
+		     unsigned long addr, void *prv)
+
+/**
+ * struct s5p_sysmmu_irq_callb - callback operations for irq routine
+ * @page_fault:	called when page fault occurs
+ * @ar_fault:	called when ar multi-hit fault occcurs
+ * @aw_fault:	called when aw multi-hit fault occcurs 
+ * @bus_error:	called when bus error occurs
+ * @ar_security:called when ar security protection fault occurs
+ * @ar_prot:	called when ar acces protection fault occurs
+ * @aw_security:called when aw security protection fault occurs
+ * @aw_prot:	called when aw acces protection fault occurs
+ */
+struct s5p_sysmmu_irq_callb {
+	S5P_IRQ_CB(page_fault);
+	S5P_IRQ_CB(ar_fault);
+	S5P_IRQ_CB(aw_fault);
+	S5P_IRQ_CB(bus_error);
+	S5P_IRQ_CB(ar_security);
+	S5P_IRQ_CB(ar_prot);
+	S5P_IRQ_CB(aw_security);
+	S5P_IRQ_CB(aw_prot);
+};
+
+/**
+ * s5p_sysmmu_get() - get sysmmu device instance
+ * @ip:		integrated peripheral identifier of the device
+ */
+struct device *s5p_sysmmu_get(enum s5p_sysmmu_ip ip);
+
+/**
+ * s5p_sysmmu_put() - release sysmmu handle for a device
+ * @dev_id:	sysmmu handle obtained from s5p_sysmmu_get()
+ */
+void s5p_sysmmu_put(void *dev);
+
+/**
+ * s5p_sysmmu_domain_irq_callb() - set non-default per-domain ops to be called
+ * from irq handling routine
+ * @domain:	iommu domain for which to set the ops
+ * @ops:	non-default operations to be set
+ * @priv:	private data to be passed to the op when it is called
+ */
+void s5p_sysmmu_domain_irq_callb(struct iommu_domain *domain,
+			    struct s5p_sysmmu_irq_callb *ops, void *priv);
+
+/**
+ * s5p_sysmmu_domain_tlb_policy() - set per-domain tlb policy
+ * @domain:	iommu domain for which to set the tlb policy
+ * @policy:	tlb policy specifier (0 round robin, 1 lru)
+ */
+void s5p_sysmmu_domain_tlb_policy(struct iommu_domain *domain, int policy);
+
+#endif /* __ASM_PLAT_SYSMMU_H */
diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
dissimilarity index 87%
index 54f5edd..905bb2b 100644
--- a/arch/arm/plat-s5p/sysmmu.c
+++ b/arch/arm/plat-s5p/sysmmu.c
@@ -1,312 +1,879 @@
-/* linux/arch/arm/plat-s5p/sysmmu.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-
-#include <asm/pgtable.h>
-
-#include <mach/map.h>
-#include <mach/regs-sysmmu.h>
-#include <plat/sysmmu.h>
-
-#define CTRL_ENABLE	0x5
-#define CTRL_BLOCK	0x7
-#define CTRL_DISABLE	0x0
-
-static struct device *dev;
-
-static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
-	S5P_PAGE_FAULT_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR,
-	S5P_DEFAULT_SLAVE_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR
-};
-
-static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
-	"PAGE FAULT",
-	"AR MULTI-HIT FAULT",
-	"AW MULTI-HIT FAULT",
-	"BUS ERROR",
-	"AR SECURITY PROTECTION FAULT",
-	"AR ACCESS PROTECTION FAULT",
-	"AW SECURITY PROTECTION FAULT",
-	"AW ACCESS PROTECTION FAULT"
-};
-
-static int (*fault_handlers[S5P_SYSMMU_TOTAL_IPNUM])(
-		enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-		unsigned long pgtable_base,
-		unsigned long fault_addr);
-
-/*
- * If adjacent 2 bits are true, the system MMU is enabled.
- * The system MMU is disabled, otherwise.
- */
-static unsigned long sysmmu_states;
-
-static inline void set_sysmmu_active(sysmmu_ips ips)
-{
-	sysmmu_states |= 3 << (ips * 2);
-}
-
-static inline void set_sysmmu_inactive(sysmmu_ips ips)
-{
-	sysmmu_states &= ~(3 << (ips * 2));
-}
-
-static inline int is_sysmmu_active(sysmmu_ips ips)
-{
-	return sysmmu_states & (3 << (ips * 2));
-}
-
-static void __iomem *sysmmusfrs[S5P_SYSMMU_TOTAL_IPNUM];
-
-static inline void sysmmu_block(sysmmu_ips ips)
-{
-	__raw_writel(CTRL_BLOCK, sysmmusfrs[ips] + S5P_MMU_CTRL);
-	dev_dbg(dev, "%s is blocked.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void sysmmu_unblock(sysmmu_ips ips)
-{
-	__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-	dev_dbg(dev, "%s is unblocked.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void __sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	__raw_writel(0x1, sysmmusfrs[ips] + S5P_MMU_FLUSH);
-	dev_dbg(dev, "TLB of %s is invalidated.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void __sysmmu_set_ptbase(sysmmu_ips ips, unsigned long pgd)
-{
-	if (unlikely(pgd == 0)) {
-		pgd = (unsigned long)ZERO_PAGE(0);
-		__raw_writel(0x20, sysmmusfrs[ips] + S5P_MMU_CFG); /* 4KB LV1 */
-	} else {
-		__raw_writel(0x0, sysmmusfrs[ips] + S5P_MMU_CFG); /* 16KB LV1 */
-	}
-
-	__raw_writel(pgd, sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
-
-	dev_dbg(dev, "Page table base of %s is initialized with 0x%08lX.\n",
-						sysmmu_ips_name[ips], pgd);
-	__sysmmu_tlb_invalidate(ips);
-}
-
-void sysmmu_set_fault_handler(sysmmu_ips ips,
-			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-					unsigned long pgtable_base,
-					unsigned long fault_addr))
-{
-	BUG_ON(!((ips >= SYSMMU_MDMA) && (ips < S5P_SYSMMU_TOTAL_IPNUM)));
-	fault_handlers[ips] = handler;
-}
-
-static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
-{
-	/* SYSMMU is in blocked when interrupt occurred. */
-	unsigned long base = 0;
-	sysmmu_ips ips = (sysmmu_ips)dev_id;
-	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
-
-	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
-		__ffs(__raw_readl(sysmmusfrs[ips] + S5P_INT_STATUS));
-
-	BUG_ON(!((itype >= 0) && (itype < 8)));
-
-	dev_alert(dev, "%s occurred by %s.\n", sysmmu_fault_name[itype],
-							sysmmu_ips_name[ips]);
-
-	if (fault_handlers[ips]) {
-		unsigned long addr;
-
-		base = __raw_readl(sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
-		addr = __raw_readl(sysmmusfrs[ips] + fault_reg_offset[itype]);
-
-		if (fault_handlers[ips](itype, base, addr)) {
-			__raw_writel(1 << itype,
-					sysmmusfrs[ips] + S5P_INT_CLEAR);
-			dev_notice(dev, "%s from %s is resolved."
-					" Retrying translation.\n",
-				sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
-		} else {
-			base = 0;
-		}
-	}
-
-	sysmmu_unblock(ips);
-
-	if (!base)
-		dev_notice(dev, "%s from %s is not handled.\n",
-			sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
-
-	return IRQ_HANDLED;
-}
-
-void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd)
-{
-	if (is_sysmmu_active(ips)) {
-		sysmmu_block(ips);
-		__sysmmu_set_ptbase(ips, pgd);
-		sysmmu_unblock(ips);
-	} else {
-		dev_dbg(dev, "%s is disabled. "
-			"Skipping initializing page table base.\n",
-						sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd)
-{
-	if (!is_sysmmu_active(ips)) {
-		sysmmu_clk_enable(ips);
-
-		__sysmmu_set_ptbase(ips, pgd);
-
-		__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-
-		set_sysmmu_active(ips);
-		dev_dbg(dev, "%s is enabled.\n", sysmmu_ips_name[ips]);
-	} else {
-		dev_dbg(dev, "%s is already enabled.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_disable(sysmmu_ips ips)
-{
-	if (is_sysmmu_active(ips)) {
-		__raw_writel(CTRL_DISABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-		set_sysmmu_inactive(ips);
-		sysmmu_clk_disable(ips);
-		dev_dbg(dev, "%s is disabled.\n", sysmmu_ips_name[ips]);
-	} else {
-		dev_dbg(dev, "%s is already disabled.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	if (is_sysmmu_active(ips)) {
-		sysmmu_block(ips);
-		__sysmmu_tlb_invalidate(ips);
-		sysmmu_unblock(ips);
-	} else {
-		dev_dbg(dev, "%s is disabled. "
-			"Skipping invalidating TLB.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-static int s5p_sysmmu_probe(struct platform_device *pdev)
-{
-	int i, ret;
-	struct resource *res, *mem;
-
-	dev = &pdev->dev;
-
-	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++) {
-		int irq;
-
-		sysmmu_clk_init(dev, i);
-		sysmmu_clk_disable(i);
-
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res) {
-			dev_err(dev, "Failed to get the resource of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENODEV;
-			goto err_res;
-		}
-
-		mem = request_mem_region(res->start,
-				((res->end) - (res->start)) + 1, pdev->name);
-		if (!mem) {
-			dev_err(dev, "Failed to request the memory region of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -EBUSY;
-			goto err_res;
-		}
-
-		sysmmusfrs[i] = ioremap(res->start, res->end - res->start + 1);
-		if (!sysmmusfrs[i]) {
-			dev_err(dev, "Failed to ioremap() for %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENXIO;
-			goto err_reg;
-		}
-
-		irq = platform_get_irq(pdev, i);
-		if (irq <= 0) {
-			dev_err(dev, "Failed to get the IRQ resource of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENOENT;
-			goto err_map;
-		}
-
-		if (request_irq(irq, s5p_sysmmu_irq, IRQF_DISABLED,
-						pdev->name, (void *)i)) {
-			dev_err(dev, "Failed to request IRQ for %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENOENT;
-			goto err_map;
-		}
-	}
-
-	return 0;
-
-err_map:
-	iounmap(sysmmusfrs[i]);
-err_reg:
-	release_mem_region(mem->start, resource_size(mem));
-err_res:
-	return ret;
-}
-
-static int s5p_sysmmu_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-int s5p_sysmmu_runtime_suspend(struct device *dev)
-{
-	return 0;
-}
-
-int s5p_sysmmu_runtime_resume(struct device *dev)
-{
-	return 0;
-}
-
-const struct dev_pm_ops s5p_sysmmu_pm_ops = {
-	.runtime_suspend	= s5p_sysmmu_runtime_suspend,
-	.runtime_resume		= s5p_sysmmu_runtime_resume,
-};
-
-static struct platform_driver s5p_sysmmu_driver = {
-	.probe		= s5p_sysmmu_probe,
-	.remove		= s5p_sysmmu_remove,
-	.driver		= {
-		.owner		= THIS_MODULE,
-		.name		= "s5p-sysmmu",
-		.pm		= &s5p_sysmmu_pm_ops,
-	}
-};
-
-static int __init s5p_sysmmu_init(void)
-{
-	return platform_driver_register(&s5p_sysmmu_driver);
-}
-arch_initcall(s5p_sysmmu_init);
+/* linux/arch/arm/plat-s5p/sysmmu.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <linux/iommu.h>
+
+#include <asm/memory.h>
+
+#include <plat/irqs.h>
+#include <plat/devs.h>
+#include <plat/cpu.h>
+#include <plat/sysmmu.h>
+
+#include <mach/map.h>
+#include <mach/regs-sysmmu.h>
+
+static int debug;
+module_param(debug, int, 0644);
+
+#define sysmmu_debug(level, fmt, arg...)				 \
+	do {								 \
+		if (debug >= level)					 \
+			printk(KERN_DEBUG "[%s] " fmt, __func__, ## arg);\
+	} while (0)
+
+#define FLPT_ENTRIES		4096
+#define FLPT_4K_64K_MASK	(~0x3FF)
+#define FLPT_1M_MASK		(~0xFFFFF)
+#define FLPT_16M_MASK		(~0xFFFFFF)
+#define SLPT_4K_MASK		(~0xFFF)
+#define SLPT_64K_MASK		(~0xFFFF)
+#define PAGE_4K_64K		0x1
+#define PAGE_1M			0x2
+#define PAGE_16M		0x40002
+#define PAGE_4K			0x2
+#define PAGE_64K		0x1
+#define FLPT_IDX_SHIFT		20
+#define FLPT_IDX_MASK		0xFFF
+#define FLPT_OFFS_SHIFT		(FLPT_IDX_SHIFT - 2)
+#define FLPT_OFFS_MASK		(FLPT_IDX_MASK << 2)
+#define SLPT_IDX_SHIFT		12
+#define SLPT_IDX_MASK		0xFF
+#define SLPT_OFFS_SHIFT		(SLPT_IDX_SHIFT - 2)
+#define SLPT_OFFS_MASK		(SLPT_IDX_MASK << 2)
+
+#define deref_va(va)		(*((unsigned long *)(va)))
+
+#define generic_extract(l, s, entry) \
+				((entry) & l##LPT_##s##_MASK)
+#define flpt_get_1m(entry)	generic_extract(F, 1M, deref_va(entry))
+#define flpt_get_16m(entry)	generic_extract(F, 16M, deref_va(entry))
+#define slpt_get_4k(entry)	generic_extract(S, 4K, deref_va(entry))
+#define slpt_get_64k(entry)	generic_extract(S, 64K, deref_va(entry))
+
+#define generic_entry(l, s, entry) \
+				(generic_extract(l, s, entry)  | PAGE_##s)
+#define flpt_ent_4k_64k(entry)	generic_entry(F, 4K_64K, entry)
+#define flpt_ent_1m(entry)	generic_entry(F, 1M, entry)
+#define flpt_ent_16m(entry)	generic_entry(F, 16M, entry)
+#define slpt_ent_4k(entry)	generic_entry(S, 4K, entry)
+#define slpt_ent_64k(entry)	generic_entry(S, 64K, entry)
+
+#define page_4k_64k(entry)	(deref_va(entry) & PAGE_4K_64K)
+#define page_1m(entry)		(deref_va(entry) & PAGE_1M)
+#define page_16m(entry)		((deref_va(entry) & PAGE_16M) == PAGE_16M)
+#define page_4k(entry)		(deref_va(entry) & PAGE_4K)
+#define page_64k(entry)		(deref_va(entry) & PAGE_64K)
+
+#define generic_pg_offs(l, s, va) \
+				(va & ~l##LPT_##s##_MASK)
+#define pg_offs_1m(va)		generic_pg_offs(F, 1M, va)
+#define pg_offs_16m(va)		generic_pg_offs(F, 16M, va)
+#define pg_offs_4k(va)		generic_pg_offs(S, 4K, va)
+#define pg_offs_64k(va)		generic_pg_offs(S, 64K, va)
+
+#define flpt_index(va)		(((va) >> FLPT_IDX_SHIFT) & FLPT_IDX_MASK)
+
+#define generic_offset(l, va)	(((va) >> l##LPT_OFFS_SHIFT) & l##LPT_OFFS_MASK)
+#define flpt_offs(va)		generic_offset(F, va)
+#define slpt_offs(va)		generic_offset(S, va)
+
+#define invalidate_slpt_ent(slpt_va) (deref_va(slpt_va) = 0UL)
+
+#define get_irq_callb(cb) \
+				(s5p_domain->irq_callb ? \
+					(s5p_domain->irq_callb->cb ? \
+					s5p_domain->irq_callb->cb : \
+					s5p_sysmmu_irq_callb.cb) \
+				: s5p_sysmmu_irq_callb.cb)
+
+struct s5p_sysmmu_info {
+	struct resource			*ioarea;
+	void __iomem			*regs;
+	unsigned int			irq;
+	struct clk			*clk;
+	bool				enabled;
+	enum s5p_sysmmu_ip		ip;
+	struct device			*dev;
+	struct iommu_domain		*domain;
+};
+
+/*
+ * iommu domain is a virtual address space of an I/O device driver.
+ * It contains kernel virtual and physical addresses of the first level
+ * page table and owns the memory in which the page tables are stored.
+ * It contains a table of kernel virtual addresses of second level
+ * page tables.
+ *
+ * In order to be used the iommu domain must be bound to an iommu device.
+ * This is accomplished with s5p_sysmmu_attach_dev, which is called through
+ * s5p_sysmmu_ops by drivers/base/iommu.c.
+ */
+struct s5p_sysmmu_domain {
+	unsigned long			flpt;
+	void				*flpt_va;
+	void				**slpt_va;
+	unsigned short			*refcount;
+	struct s5p_sysmmu_info		*sysmmu;
+	struct s5p_sysmmu_irq_callb	*irq_callb;
+	void				*irq_callb_priv;
+	int				policy;
+};
+
+static struct s5p_sysmmu_info *sysmmu_table[S5P_SYSMMU_TOTAL_IP_NUM];
+static DEFINE_SPINLOCK(sysmmu_slock);
+
+static struct kmem_cache *slpt_cache;
+
+static const char *irq_reasons[] = {
+	"sysmmu irq:page fault",
+	"sysmmu irq:ar multi hit",
+	"sysmmu irq:aw multi hit",
+	"sysmmu irq:bus error",
+	"sysmmu irq:ar security protection fault",
+	"sysmmu irq:ar access protection fault",
+	"sysmmu irq:aw security protection fault",
+	"sysmmu irq:aw access protection fault"
+};
+
+static void flush_cache(const void *start, unsigned long size)
+{
+	dmac_flush_range(start, start + size);
+	outer_flush_range(virt_to_phys(start), virt_to_phys(start + size));
+}
+
+static int s5p_sysmmu_domain_init(struct iommu_domain *domain)
+{
+	struct s5p_sysmmu_domain *s5p_domain;
+
+	s5p_domain = kzalloc(sizeof(struct s5p_sysmmu_domain), GFP_KERNEL);
+	if (!s5p_domain) {
+		sysmmu_debug(3, "no memory for state\n");
+		return -ENOMEM;
+	}
+	domain->priv = s5p_domain;
+
+	/*
+	 * first-level page table holds
+	 * 4k second-level descriptors == 16kB == 4 pages
+	 */
+	s5p_domain->flpt_va = kzalloc(FLPT_ENTRIES * sizeof(unsigned long),
+					 GFP_KERNEL);
+	if (!s5p_domain->flpt_va)
+		return -ENOMEM;
+	s5p_domain->flpt = virt_to_phys(s5p_domain->flpt_va);
+
+	s5p_domain->refcount = kzalloc(FLPT_ENTRIES * sizeof(u16), GFP_KERNEL);
+	if (!s5p_domain->refcount) {
+		kfree(s5p_domain->flpt_va);
+		return -ENOMEM;
+	}
+
+	s5p_domain->slpt_va = kzalloc(FLPT_ENTRIES * sizeof(void *),
+				      GFP_KERNEL);
+	if (!s5p_domain->slpt_va) {
+		kfree(s5p_domain->refcount);
+		kfree(s5p_domain->flpt_va);
+		return -ENOMEM;
+	}
+	flush_cache(s5p_domain->flpt_va, 4 * PAGE_SIZE);
+	return 0;
+}
+
+static void s5p_sysmmu_domain_destroy(struct iommu_domain *domain)
+{
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	int i;
+	for (i = FLPT_ENTRIES - 1; i >= 0; --i)
+		if (s5p_domain->refcount[i])
+			kmem_cache_free(slpt_cache, s5p_domain->slpt_va[i]);
+
+	kfree(s5p_domain->slpt_va);
+	kfree(s5p_domain->refcount);
+	kfree(s5p_domain->flpt_va);
+	kfree(domain->priv);
+	domain->priv = NULL;
+}
+
+static int s5p_sysmmu_attach_dev(struct iommu_domain *domain,
+				 struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	struct s5p_sysmmu_info *sysmmu = platform_get_drvdata(pdev);
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	unsigned int reg;
+
+	s5p_domain->sysmmu = sysmmu;
+	sysmmu->domain = domain;
+
+	pm_runtime_get_sync(sysmmu->dev);
+	clk_enable(sysmmu->clk);
+
+	/* configure first level page table base address */
+	writel(s5p_domain->flpt, sysmmu->regs + S5P_PT_BASE_ADDR);
+
+	reg = readl(sysmmu->regs + S5P_MMU_CFG);
+	if (s5p_domain->policy)
+		reg |= (0x1<<0);		/* replacement policy : LRU */
+	else
+		reg &= ~(0x1<<0);		/* replacement policy: RR */
+	writel(reg, sysmmu->regs + S5P_MMU_CFG);
+
+	reg = readl(sysmmu->regs + S5P_MMU_CTRL);
+	reg |= ((0x1<<2)|(0x1<<0));	/* Enable interrupt, Enable MMU */
+	writel(reg, sysmmu->regs + S5P_MMU_CTRL);
+
+	sysmmu->enabled = true;
+
+	return 0;
+}
+
+static void s5p_sysmmu_detach_dev(struct iommu_domain *domain,
+				  struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	struct s5p_sysmmu_info *sysmmu = platform_get_drvdata(pdev);
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	unsigned int reg;
+
+	/* SYSMMU disable */
+	reg = readl(sysmmu->regs + S5P_MMU_CFG);
+	reg |= (0x1<<0);		/* replacement policy : LRU */
+	writel(reg, sysmmu->regs + S5P_MMU_CFG);
+
+	reg = readl(sysmmu->regs + S5P_MMU_CTRL);
+	reg &= ~(0x1);			/* Disable MMU */
+	writel(reg, sysmmu->regs + S5P_MMU_CTRL);
+
+	sysmmu->enabled = false;
+
+	clk_disable(sysmmu->clk);
+	pm_runtime_put_sync(sysmmu->dev);
+
+	sysmmu->domain = NULL;
+	s5p_domain->sysmmu = NULL;
+}
+
+#define bug_mapping_prohibited(iova, len) \
+		s5p_mapping_prohibited_impl(iova, len, __FILE__, __LINE__)
+
+static void s5p_mapping_prohibited_impl(unsigned long iova, size_t len,
+				   const char *file, int line)
+{
+	sysmmu_debug(3, "%s:%d Attempting to map %d@0x%lx over existing\
+mapping\n", file, line, len, iova);
+	BUG();
+}
+
+/*
+ * Map an area of length corresponding to gfp_order, starting at iova.
+ * gfp_order is an order of units of 4kB: 0 -> 1 unit, 1 -> 2 units,
+ * 2 -> 4 units, 3 -> 8 units and so on.
+ *
+ * The act of mapping is all about deciding how to interpret in the MMU the
+ * virtual addresses belonging to the mapped range. Mapping can be done with
+ * 4kB, 64kB, 1MB and 16MB pages, so only orders of 0, 4, 8, 12 are valid.
+ *
+ * iova must be aligned on a 4kB, 64kB, 1MB and 16MB boundaries, respectively.
+ */
+static int s5p_sysmmu_map(struct iommu_domain *domain, unsigned long iova,
+			  phys_addr_t paddr, int gfp_order, int prot)
+{
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	int flpt_idx = flpt_index(iova);
+	size_t len = 0x1000UL << gfp_order;
+	void *flpt_va, *slpt_va;
+
+	if (len != SZ_16M && len != SZ_1M && len != SZ_64K && len != SZ_4K) {
+		sysmmu_debug(3, "bad order: %d\n", gfp_order);
+		return -EINVAL;
+	}
+
+	flpt_va = s5p_domain->flpt_va + flpt_offs(iova);
+
+	if (SZ_1M == len) {
+		if (deref_va(flpt_va))
+			bug_mapping_prohibited(iova, len);
+		deref_va(flpt_va) = flpt_ent_1m(paddr);
+		flush_cache(flpt_va, 4); /* one 4-byte entry */
+
+		return 0;
+	} else if (SZ_16M == len) {
+		int i = 0;
+		/* first loop to verify mapping allowed */
+		for (i = 0; i < 16; ++i)
+			if (deref_va(flpt_va + 4 * i))
+				bug_mapping_prohibited(iova, len);
+		/* actually map only if allowed */
+		for (i = 0; i < 16; ++i)
+			deref_va(flpt_va + 4 * i) = flpt_ent_16m(paddr);
+		flush_cache(flpt_va, 4 * 16); /* 16 4-byte entries */
+
+		return 0;
+	}
+
+	/* for 4K and 64K pages only */
+	if (page_1m(flpt_va) || page_16m(flpt_va))
+		bug_mapping_prohibited(iova, len);
+
+	/* need to allocate a new second level page table */
+	if (0 == deref_va(flpt_va)) {
+		void *slpt = kmem_cache_zalloc(slpt_cache, GFP_KERNEL);
+		if (!slpt) {
+			sysmmu_debug(3, "cannot allocate slpt\n");
+			return -ENOMEM;
+		}
+
+		s5p_domain->slpt_va[flpt_idx] = slpt;
+		deref_va(flpt_va) = flpt_ent_4k_64k(virt_to_phys(slpt));
+		flush_cache(flpt_va, 4);
+	}
+	slpt_va = s5p_domain->slpt_va[flpt_idx] + slpt_offs(iova);
+
+	if (SZ_4K == len) {
+		if (deref_va(slpt_va))
+			bug_mapping_prohibited(iova, len);
+		deref_va(slpt_va) = slpt_ent_4k(paddr);
+		flush_cache(slpt_va, 4); /* one 4-byte entry */
+		s5p_domain->refcount[flpt_idx]++;
+	} else {
+		int i;
+		/* first loop to verify mapping allowed */
+		for (i = 0; i < 16; ++i)
+			if (deref_va(slpt_va + 4 * i))
+				bug_mapping_prohibited(iova, len);
+		/* actually map only if allowed */
+		for (i = 0; i < 16; ++i) {
+			deref_va(slpt_va + 4 * i) = slpt_ent_64k(paddr);
+			s5p_domain->refcount[flpt_idx]++;
+		}
+		flush_cache(slpt_va, 4 * 16); /* 16 4-byte entries */
+	}
+
+	return 0;
+}
+
+static void s5p_tlb_invalidate(struct s5p_sysmmu_domain *domain)
+{
+	unsigned int reg;
+	void __iomem *regs;
+
+	if (!domain->sysmmu)
+		return;
+
+	regs = domain->sysmmu->regs;
+
+	/* TLB invalidate */
+	reg = readl(regs + S5P_MMU_CTRL);
+	reg |= (0x1<<1);		/* Block MMU */
+	writel(reg, regs + S5P_MMU_CTRL);
+
+	writel(0x1, regs + S5P_MMU_FLUSH);
+					/* Flush_entry */
+
+	reg = readl(regs + S5P_MMU_CTRL);
+	reg &= ~(0x1<<1);		/* Un-block MMU */
+	writel(reg, regs + S5P_MMU_CTRL);
+}
+
+#define bug_unmapping_prohibited(iova, len) \
+		s5p_unmapping_prohibited_impl(iova, len, __FILE__, __LINE__)
+
+static void s5p_unmapping_prohibited_impl(unsigned long iova, size_t len,
+				     const char *file, int line)
+{
+	sysmmu_debug(3, "%s:%d Attempting to unmap different size or \
+non-existing mapping %d@0x%lx\n", file, line, len, iova);
+	BUG();
+}
+
+static int s5p_sysmmu_unmap(struct iommu_domain *domain, unsigned long iova,
+			    int gfp_order)
+{
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	int flpt_idx = flpt_index(iova);
+	size_t len = 0x1000UL << gfp_order;
+	void *flpt_va, *slpt_va;
+
+	if (len != SZ_16M && len != SZ_1M && len != SZ_64K && len != SZ_4K) {
+		sysmmu_debug(3, "bad order: %d\n", gfp_order);
+		return -EINVAL;
+	}
+
+	flpt_va = s5p_domain->flpt_va + flpt_offs(iova);
+
+	/* check if there is any mapping at all */
+	if (!deref_va(flpt_va))
+		bug_unmapping_prohibited(iova, len);
+
+	if (SZ_1M == len) {
+		if (!page_1m(flpt_va))
+			bug_unmapping_prohibited(iova, len);
+		deref_va(flpt_va) = 0;
+		flush_cache(flpt_va, 4); /* one 4-byte entry */
+		s5p_tlb_invalidate(s5p_domain);
+
+		return 0;
+	} else if (SZ_16M == len) {
+		int i;
+		/* first loop to verify it actually is 16M mapping */
+		for (i = 0; i < 16; ++i)
+			if (!page_16m(flpt_va + 4 * i))
+				bug_unmapping_prohibited(iova, len);
+		/* actually unmap */
+		for (i = 0; i < 16; ++i)
+			deref_va(flpt_va + 4 * i) = 0;
+		flush_cache(flpt_va, 4 * 16); /* 16 4-byte entries */
+		s5p_tlb_invalidate(s5p_domain);
+
+		return 0;
+	}
+
+	if (!page_4k_64k(flpt_va))
+		bug_unmapping_prohibited(iova, len);
+
+	slpt_va = s5p_domain->slpt_va[flpt_idx] + slpt_offs(iova);
+
+	/* verify that we attempt to unmap a matching mapping */
+	if (SZ_4K == len) {
+		if (!page_4k(slpt_va))
+			bug_unmapping_prohibited(iova, len);
+	} else if (SZ_64K == len) {
+		int i;
+		for (i = 0; i < 16; ++i)
+			if (!page_64k(slpt_va + 4 * i))
+				bug_unmapping_prohibited(iova, len);
+	}
+
+	if (SZ_64K == len)
+		s5p_domain->refcount[flpt_idx] -= 15;
+
+	if (--s5p_domain->refcount[flpt_idx]) {
+		if (SZ_4K == len) {
+			invalidate_slpt_ent(slpt_va);
+			flush_cache(slpt_va, 4);
+		} else {
+			int i;
+			for (i = 0; i < 16; ++i)
+				invalidate_slpt_ent(slpt_va + 4 * i);
+			flush_cache(slpt_va, 4 * 16);
+		}
+	} else {
+		kmem_cache_free(slpt_cache, s5p_domain->slpt_va[flpt_idx]);
+		s5p_domain->slpt_va[flpt_idx] = 0;
+		memset(flpt_va, 0, 4);
+		flush_cache(flpt_va, 4);
+	}
+
+	s5p_tlb_invalidate(s5p_domain);
+
+	return 0;
+}
+
+phys_addr_t s5p_iova_to_phys(struct iommu_domain *domain, unsigned long iova)
+{
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	int flpt_idx = flpt_index(iova);
+	unsigned long flpt_va, slpt_va;
+
+	flpt_va = (unsigned long)s5p_domain->flpt_va + flpt_offs(iova);
+
+	if (!deref_va(flpt_va))
+		return 0;
+
+	if (page_16m(flpt_va))
+		return flpt_get_16m(flpt_va) | pg_offs_16m(iova);
+	else if (page_1m(flpt_va))
+		return flpt_get_1m(flpt_va) | pg_offs_1m(iova);
+
+	if (!page_4k_64k(flpt_va))
+		return 0;
+
+	slpt_va = (unsigned long)s5p_domain->slpt_va[flpt_idx] +
+		  slpt_offs(iova);
+
+	if (!deref_va(slpt_va))
+		return 0;
+
+	if (page_4k(slpt_va))
+		return slpt_get_4k(slpt_va) | pg_offs_4k(iova);
+	else if (page_64k(slpt_va))
+		return slpt_get_64k(slpt_va) | pg_offs_64k(iova);
+
+	return 0;
+}
+
+static struct iommu_ops s5p_sysmmu_ops = {
+	.domain_init = s5p_sysmmu_domain_init,
+	.domain_destroy = s5p_sysmmu_domain_destroy,
+	.attach_dev = s5p_sysmmu_attach_dev,
+	.detach_dev = s5p_sysmmu_detach_dev,
+	.map = s5p_sysmmu_map,
+	.unmap = s5p_sysmmu_unmap,
+	.iova_to_phys = s5p_iova_to_phys,
+};
+
+struct device *s5p_sysmmu_get(enum s5p_sysmmu_ip ip)
+{
+	struct device *ret = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sysmmu_slock, flags);
+	if (sysmmu_table[ip]) {
+		try_module_get(THIS_MODULE);
+		ret = sysmmu_table[ip]->dev;
+	}
+	spin_unlock_irqrestore(&sysmmu_slock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_get);
+
+void s5p_sysmmu_put(void *dev)
+{
+	BUG_ON(!dev);
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_put);
+
+void s5p_sysmmu_domain_irq_callb(struct iommu_domain *domain,
+			    struct s5p_sysmmu_irq_callb *ops, void *priv)
+{
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	s5p_domain->irq_callb = ops;
+	s5p_domain->irq_callb_priv = priv;
+}
+EXPORT_SYMBOL(s5p_sysmmu_domain_irq_callb);
+
+
+void s5p_sysmmu_domain_tlb_policy(struct iommu_domain *domain, int policy)
+{
+	struct s5p_sysmmu_domain *s5p_domain = domain->priv;
+	s5p_domain->policy = policy;
+}
+EXPORT_SYMBOL(s5p_sysmmu_domain_tlb_policy);
+
+static void s5p_sysmmu_irq_page_fault(struct iommu_domain *domain, int reason,
+				      unsigned long addr, void *priv)
+{
+	sysmmu_debug(3, "%s: Faulting virtual address: 0x%08lx\n",
+		     irq_reasons[reason], addr);
+	BUG();
+}
+
+static void s5p_sysmmu_irq_generic_callb(struct iommu_domain *domain,
+					 int reason, unsigned long addr,
+					 void *priv)
+{
+	sysmmu_debug(3, "%s\n", irq_reasons[reason]);
+	BUG();
+}
+
+static struct s5p_sysmmu_irq_callb s5p_sysmmu_irq_callb = {
+	.page_fault = s5p_sysmmu_irq_page_fault,
+	.ar_fault = s5p_sysmmu_irq_generic_callb,
+	.aw_fault = s5p_sysmmu_irq_generic_callb,
+	.bus_error = s5p_sysmmu_irq_generic_callb,
+	.ar_security = s5p_sysmmu_irq_generic_callb,
+	.ar_prot = s5p_sysmmu_irq_generic_callb,
+	.aw_security = s5p_sysmmu_irq_generic_callb,
+	.aw_prot = s5p_sysmmu_irq_generic_callb,
+};
+
+static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
+{
+	struct s5p_sysmmu_info *sysmmu = dev_id;
+	struct s5p_sysmmu_domain *s5p_domain = sysmmu->domain->priv;
+	unsigned int reg_INT_STATUS;
+
+	if (false == sysmmu->enabled)
+		return IRQ_HANDLED;
+
+	reg_INT_STATUS = readl(sysmmu->regs + S5P_INT_STATUS);
+	if (reg_INT_STATUS & 0xFF) {
+		S5P_IRQ_CB(cb);
+		enum s5p_sysmmu_fault reason = 0;
+		unsigned long fault = 0;
+		unsigned reg = 0;
+		cb = NULL;
+		switch (reg_INT_STATUS & 0xFF) {
+		case 0x1:
+			cb = get_irq_callb(page_fault);
+			reason = S5P_SYSMMU_PAGE_FAULT;
+			reg = S5P_PAGE_FAULT_ADDR;
+			break;
+		case 0x2:
+			cb = get_irq_callb(ar_fault);
+			reason = S5P_SYSMMU_AR_FAULT;
+			reg = S5P_AR_FAULT_ADDR;
+			break;
+		case 0x4:
+			cb = get_irq_callb(aw_fault);
+			reason = S5P_SYSMMU_AW_FAULT;
+			reg = S5P_AW_FAULT_ADDR;
+			break;
+		case 0x8:
+			cb = get_irq_callb(bus_error);
+			reason = S5P_SYSMMU_BUS_ERROR;
+			/* register common to page fault and bus error */
+			reg = S5P_PAGE_FAULT_ADDR;
+			break;
+		case 0x10:
+			cb = get_irq_callb(ar_security);
+			reason = S5P_SYSMMU_AR_SECURITY;
+			reg = S5P_AR_FAULT_ADDR;
+			break;
+		case 0x20:
+			cb = get_irq_callb(ar_prot);
+			reason = S5P_SYSMMU_AR_PROT;
+			reg = S5P_AR_FAULT_ADDR;
+			break;
+		case 0x40:
+			cb = get_irq_callb(aw_security);
+			reason = S5P_SYSMMU_AW_SECURITY;
+			reg = S5P_AW_FAULT_ADDR;
+			break;
+		case 0x80:
+			cb = get_irq_callb(aw_prot);
+			reason = S5P_SYSMMU_AW_PROT;
+			reg = S5P_AW_FAULT_ADDR;
+			break;
+		}
+		fault = readl(sysmmu->regs + reg);
+		cb(sysmmu->domain, reason, fault, s5p_domain->irq_callb_priv);
+		writel(reg_INT_STATUS, sysmmu->regs + S5P_INT_CLEAR);
+	}
+	return IRQ_HANDLED;
+}
+
+static int s5p_sysmmu_probe(struct platform_device *pdev)
+{
+	struct s5p_sysmmu_info *sysmmu;
+	struct resource *res;
+	int ret;
+	unsigned long flags;
+
+	sysmmu = kzalloc(sizeof(struct s5p_sysmmu_info), GFP_KERNEL);
+	if (!sysmmu) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (NULL == res) {
+		dev_err(&pdev->dev, "cannot find IO resource\n");
+		ret = -ENOENT;
+		goto err_s5p_sysmmu_info_allocated;
+	}
+
+	sysmmu->ioarea = request_mem_region(res->start, resource_size(res),
+					 pdev->name);
+
+	if (NULL == sysmmu->ioarea) {
+		dev_err(&pdev->dev, "cannot request IO\n");
+		ret = -ENXIO;
+		goto err_s5p_sysmmu_info_allocated;
+	}
+
+	sysmmu->regs = ioremap(res->start, resource_size(res));
+
+	if (NULL == sysmmu->regs) {
+		dev_err(&pdev->dev, "cannot map IO\n");
+		ret = -ENXIO;
+		goto err_ioarea_requested;
+	}
+
+	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
+		sysmmu->regs, sysmmu->ioarea, res);
+
+	sysmmu->irq = ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
+		dev_err(&pdev->dev, "cannot find IRQ\n");
+		goto err_iomap_done;
+	}
+
+	ret = request_irq(sysmmu->irq, s5p_sysmmu_irq, 0,
+			  dev_name(&pdev->dev), sysmmu);
+
+	if (ret != 0) {
+		dev_err(&pdev->dev, "cannot claim IRQ %d\n", sysmmu->irq);
+		goto err_iomap_done;
+	}
+
+	sysmmu->clk = clk_get(&pdev->dev, "sysmmu");
+	if (IS_ERR_OR_NULL(sysmmu->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		ret = -ENOENT;
+		goto err_request_irq_done;
+	}
+	dev_dbg(&pdev->dev, "clock source %p\n", sysmmu->clk);
+
+	sysmmu->ip = pdev->id;
+
+	spin_lock_irqsave(&sysmmu_slock, flags);
+	sysmmu_table[pdev->id] = sysmmu;
+	spin_unlock_irqrestore(&sysmmu_slock, flags);
+
+	sysmmu->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, sysmmu);
+
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	dev_info(&pdev->dev, "Samsung S5P SYSMMU (IOMMU)\n");
+	return 0;
+
+err_request_irq_done:
+	free_irq(sysmmu->irq, sysmmu);
+
+err_iomap_done:
+	iounmap(sysmmu->regs);
+
+err_ioarea_requested:
+	release_resource(sysmmu->ioarea);
+	kfree(sysmmu->ioarea);
+
+err_s5p_sysmmu_info_allocated:
+	kfree(sysmmu);
+	return ret;
+}
+
+static int s5p_sysmmu_remove(struct platform_device *pdev)
+{
+	struct s5p_sysmmu_info *sysmmu = platform_get_drvdata(pdev);
+	unsigned long flags;
+
+	pm_runtime_disable(sysmmu->dev);
+
+	spin_lock_irqsave(&sysmmu_slock, flags);
+	sysmmu_table[pdev->id] = NULL;
+	spin_unlock_irqrestore(&sysmmu_slock, flags);
+
+	clk_disable(sysmmu->clk);
+	clk_put(sysmmu->clk);
+
+	free_irq(sysmmu->irq, sysmmu);
+
+	iounmap(sysmmu->regs);
+
+	release_resource(sysmmu->ioarea);
+	kfree(sysmmu->ioarea);
+
+	kfree(sysmmu);
+
+	return 0;
+}
+
+static int
+s5p_sysmmu_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	int ret = 0;
+	sysmmu_debug(3, "begin\n");
+
+	return ret;
+}
+
+static int s5p_sysmmu_resume(struct platform_device *pdev)
+{
+	int ret = 0;
+	sysmmu_debug(3, "begin\n");
+
+	return ret;
+}
+
+static int s5p_sysmmu_runtime_suspend(struct device *dev)
+{
+	sysmmu_debug(3, "begin\n");
+	return 0;
+}
+
+static int s5p_sysmmu_runtime_resume(struct device *dev)
+{
+	sysmmu_debug(3, "begin\n");
+	return 0;
+}
+
+static const struct dev_pm_ops s5p_sysmmu_pm_ops = {
+	.runtime_suspend = s5p_sysmmu_runtime_suspend,
+	.runtime_resume	 = s5p_sysmmu_runtime_resume,
+};
+
+static struct platform_driver s5p_sysmmu_driver = {
+	.probe = s5p_sysmmu_probe,
+	.remove = s5p_sysmmu_remove,
+	.suspend = s5p_sysmmu_suspend,
+	.resume = s5p_sysmmu_resume,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "s5p-sysmmu",
+		.pm = &s5p_sysmmu_pm_ops,
+	},
+};
+
+static int __init
+s5p_sysmmu_register(void)
+{
+	int ret;
+
+	sysmmu_debug(3, "Registering sysmmu driver...\n");
+
+	slpt_cache = kmem_cache_create("slpt_cache", 1024, 1024,
+				       SLAB_HWCACHE_ALIGN, NULL);
+	if (!slpt_cache) {
+		printk(KERN_ERR
+			"%s: failed to allocated slpt cache\n", __func__);
+		return -ENOMEM;
+	}
+
+	ret = platform_driver_register(&s5p_sysmmu_driver);
+
+	if (ret) {
+		printk(KERN_ERR
+			"%s: failed to register sysmmu driver\n", __func__);
+		return -EINVAL;
+	}
+
+	register_iommu(&s5p_sysmmu_ops);
+
+	return ret;
+}
+
+static void __exit
+s5p_sysmmu_unregister(void)
+{
+	kmem_cache_destroy(slpt_cache);
+	platform_driver_unregister(&s5p_sysmmu_driver);
+}
+
+module_init(s5p_sysmmu_register);
+module_exit(s5p_sysmmu_unregister);
+
+MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
+MODULE_DESCRIPTION("Samsung System MMU (IOMMU) driver");
+MODULE_LICENSE("GPL");
+
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index f0da6b7..0ae5dd0 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -142,7 +142,7 @@ extern struct platform_device s5p_device_fimc3;
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
 
-extern struct platform_device exynos4_device_sysmmu;
+extern struct platform_device exynos4_device_sysmmu[];
 
 /* s3c2440 specific devices */
 
-- 
1.7.1.569.g6f426
