Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15510 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1CDQEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 11:04:35 -0500
Date: Fri, 04 Mar 2011 17:04:20 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
In-reply-to: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299254660-15765-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch performs a complete rewrite of sysmmu driver for Samsung platform:
- the new version introduces an api to construct device private page
  tables and enables to use device private address space mode
- simplified the resource management: no more single platform
  device with 32 resources is needed, better fits into linux driver model,
  each sysmmu instance has it's own resource definition
- added support for sysmmu clocks
- some other minor API chages required by upcoming videobuf2 allocator

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---

Hello,

I'm really sorry for breaking this patch in the previous mail. The
semi-colon is missing in the "EXPORT_SYMBOL_GPL(s5p_sysmmu_unmap_area)"
line. This is the fixed version.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

---
 arch/arm/mach-s5pv310/clock.c                    |   91 ++
 arch/arm/mach-s5pv310/dev-sysmmu.c               |  582 +++++++++----
 arch/arm/mach-s5pv310/include/mach/irqs.h        |   36 +-
 arch/arm/mach-s5pv310/include/mach/regs-clock.h  |    3 +
 arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h |   23 +-
 arch/arm/mach-s5pv310/include/mach/sysmmu.h      |  122 ---
 arch/arm/plat-s5p/Kconfig                        |   17 +-
 arch/arm/plat-s5p/include/plat/sysmmu.h          |  127 +++
 arch/arm/plat-s5p/sysmmu.c                       |  988 +++++++++++++++-------
 arch/arm/plat-samsung/include/plat/devs.h        |    2 +-
 10 files changed, 1323 insertions(+), 668 deletions(-)
 rewrite arch/arm/mach-s5pv310/dev-sysmmu.c (86%)
 delete mode 100644 arch/arm/mach-s5pv310/include/mach/sysmmu.h
 create mode 100644 arch/arm/plat-s5p/include/plat/sysmmu.h
 rewrite arch/arm/plat-s5p/sysmmu.c (85%)

diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-s5pv310/clock.c
index fc7c2f8..f142b8c 100644
--- a/arch/arm/mach-s5pv310/clock.c
+++ b/arch/arm/mach-s5pv310/clock.c
@@ -20,6 +20,7 @@
 #include <plat/pll.h>
 #include <plat/s5p-clock.h>
 #include <plat/clock-clksrc.h>
+#include <plat/sysmmu.h>
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
@@ -116,6 +117,21 @@ static int s5pv310_clk_ip_perir_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_IP_PERIR, clk, enable);
 }
 
+static int s5pv310_clk_ip_dmc_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_DMC, clk, enable);
+}
+
+static int s5pv310_clk_ip_mfc_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_MFC, clk, enable);
+}
+
+static int s5pv310_clk_ip_tv_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_TV, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk clk_mout_apll = {
@@ -422,6 +438,81 @@ static struct clk init_clocks_off[] = {
 		.enable		= s5pv310_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
+		.name           = "sysmmu",
+		.id             = S5P_SYSMMU_MFC_L,
+		.enable         = s5pv310_clk_ip_mfc_ctrl,
+		.ctrlbit        = ((15 << 1) | 1),
+	}, {
+		.name           = "sysmmu",
+		.id             = S5P_SYSMMU_MFC_R,
+		.enable         = s5pv310_clk_ip_mfc_ctrl,
+		.ctrlbit        = ((15 << 1) | 1),
+	}, {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC0,
+		.enable		= s5pv310_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 7),
+	}, {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC1,
+		.enable		= s5pv310_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 8),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC2,
+		.enable		= s5pv310_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 9),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMC3,
+		.enable		= s5pv310_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 10),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_JPEG,
+		.enable		= s5pv310_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 11),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_TV,
+		.enable		= s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 4),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_G2D,
+		.enable		= s5pv310_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 3),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_ROTATOR,
+		.enable		= s5pv310_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 4),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_MDMA,
+		.enable		= s5pv310_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 5),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMD0,
+		.enable		= s5pv310_clk_ip_lcd0_ctrl,
+		.ctrlbit	= (1 << 4),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_FIMD1,
+		.enable		= s5pv310_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 4),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_PCIe,
+		.enable		= s5pv310_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 18),
+	} , {
+		.name		= "sysmmu",
+		.id		= S5P_SYSMMU_SSS,
+		.enable		= s5pv310_clk_ip_dmc_ctrl,
+		.ctrlbit	= (1 << 12),
+	} , {
 		.name		= "fimd",
 		.id		= 0,
 		.enable		= s5pv310_clk_ip_lcd0_ctrl,
diff --git a/arch/arm/mach-s5pv310/dev-sysmmu.c b/arch/arm/mach-s5pv310/dev-sysmmu.c
dissimilarity index 86%
index e1bb200..73c1541 100644
--- a/arch/arm/mach-s5pv310/dev-sysmmu.c
+++ b/arch/arm/mach-s5pv310/dev-sysmmu.c
@@ -1,187 +1,395 @@
-/* linux/arch/arm/mach-s5pv310/dev-sysmmu.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
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
-
-static struct resource s5pv310_sysmmu_resource[] = {
-	[0] = {
-		.start	= S5PV310_PA_SYSMMU_MDMA,
-		.end	= S5PV310_PA_SYSMMU_MDMA + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= IRQ_SYSMMU_MDMA0_0,
-		.end	= IRQ_SYSMMU_MDMA0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = {
-		.start	= S5PV310_PA_SYSMMU_SSS,
-		.end	= S5PV310_PA_SYSMMU_SSS + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[3] = {
-		.start	= IRQ_SYSMMU_SSS_0,
-		.end	= IRQ_SYSMMU_SSS_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[4] = {
-		.start	= S5PV310_PA_SYSMMU_FIMC0,
-		.end	= S5PV310_PA_SYSMMU_FIMC0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[5] = {
-		.start	= IRQ_SYSMMU_FIMC0_0,
-		.end	= IRQ_SYSMMU_FIMC0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[6] = {
-		.start	= S5PV310_PA_SYSMMU_FIMC1,
-		.end	= S5PV310_PA_SYSMMU_FIMC1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[7] = {
-		.start	= IRQ_SYSMMU_FIMC1_0,
-		.end	= IRQ_SYSMMU_FIMC1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[8] = {
-		.start	= S5PV310_PA_SYSMMU_FIMC2,
-		.end	= S5PV310_PA_SYSMMU_FIMC2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[9] = {
-		.start	= IRQ_SYSMMU_FIMC2_0,
-		.end	= IRQ_SYSMMU_FIMC2_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[10] = {
-		.start	= S5PV310_PA_SYSMMU_FIMC3,
-		.end	= S5PV310_PA_SYSMMU_FIMC3 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[11] = {
-		.start	= IRQ_SYSMMU_FIMC3_0,
-		.end	= IRQ_SYSMMU_FIMC3_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[12] = {
-		.start	= S5PV310_PA_SYSMMU_JPEG,
-		.end	= S5PV310_PA_SYSMMU_JPEG + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[13] = {
-		.start	= IRQ_SYSMMU_JPEG_0,
-		.end	= IRQ_SYSMMU_JPEG_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[14] = {
-		.start	= S5PV310_PA_SYSMMU_FIMD0,
-		.end	= S5PV310_PA_SYSMMU_FIMD0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[15] = {
-		.start	= IRQ_SYSMMU_LCD0_M0_0,
-		.end	= IRQ_SYSMMU_LCD0_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[16] = {
-		.start	= S5PV310_PA_SYSMMU_FIMD1,
-		.end	= S5PV310_PA_SYSMMU_FIMD1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[17] = {
-		.start	= IRQ_SYSMMU_LCD1_M1_0,
-		.end	= IRQ_SYSMMU_LCD1_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[18] = {
-		.start	= S5PV310_PA_SYSMMU_PCIe,
-		.end	= S5PV310_PA_SYSMMU_PCIe + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[19] = {
-		.start	= IRQ_SYSMMU_PCIE_0,
-		.end	= IRQ_SYSMMU_PCIE_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[20] = {
-		.start	= S5PV310_PA_SYSMMU_G2D,
-		.end	= S5PV310_PA_SYSMMU_G2D + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[21] = {
-		.start	= IRQ_SYSMMU_2D_0,
-		.end	= IRQ_SYSMMU_2D_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[22] = {
-		.start	= S5PV310_PA_SYSMMU_ROTATOR,
-		.end	= S5PV310_PA_SYSMMU_ROTATOR + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[23] = {
-		.start	= IRQ_SYSMMU_ROTATOR_0,
-		.end	= IRQ_SYSMMU_ROTATOR_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[24] = {
-		.start	= S5PV310_PA_SYSMMU_MDMA2,
-		.end	= S5PV310_PA_SYSMMU_MDMA2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[25] = {
-		.start	= IRQ_SYSMMU_MDMA1_0,
-		.end	= IRQ_SYSMMU_MDMA1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[26] = {
-		.start	= S5PV310_PA_SYSMMU_TV,
-		.end	= S5PV310_PA_SYSMMU_TV + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[27] = {
-		.start	= IRQ_SYSMMU_TV_M0_0,
-		.end	= IRQ_SYSMMU_TV_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[28] = {
-		.start	= S5PV310_PA_SYSMMU_MFC_L,
-		.end	= S5PV310_PA_SYSMMU_MFC_L + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[29] = {
-		.start	= IRQ_SYSMMU_MFC_M0_0,
-		.end	= IRQ_SYSMMU_MFC_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[30] = {
-		.start	= S5PV310_PA_SYSMMU_MFC_R,
-		.end	= S5PV310_PA_SYSMMU_MFC_R + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[31] = {
-		.start	= IRQ_SYSMMU_MFC_M1_0,
-		.end	= IRQ_SYSMMU_MFC_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device s5pv310_device_sysmmu = {
-	.name		= "s5p-sysmmu",
-	.id		= 32,
-	.num_resources	= ARRAY_SIZE(s5pv310_sysmmu_resource),
-	.resource	= s5pv310_sysmmu_resource,
-};
-
-EXPORT_SYMBOL(s5pv310_device_sysmmu);
+/* linux/arch/arm/mach-s5pv310/dev-sysmmu.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
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
+static struct resource s5p_sysmmu_resource[][2] = {
+	[S5P_SYSMMU_MDMA] = {
+		[0] = {
+			.start	= S5PV310_PA_SYSMMU_MDMA,
+			.end	= S5PV310_PA_SYSMMU_MDMA + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_SSS,
+			.end	= S5PV310_PA_SYSMMU_SSS + SZ_4K - 1,
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
+			.start = S5PV310_PA_SYSMMU_FIMC0,
+			.end   = S5PV310_PA_SYSMMU_FIMC0 + SZ_4K - 1,
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
+			.start = S5PV310_PA_SYSMMU_FIMC1,
+			.end   = S5PV310_PA_SYSMMU_FIMC1 + SZ_4K - 1,
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
+			.start = S5PV310_PA_SYSMMU_FIMC2,
+			.end   = S5PV310_PA_SYSMMU_FIMC2 + SZ_4K - 1,
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
+			.start = S5PV310_PA_SYSMMU_FIMC3,
+			.end   = S5PV310_PA_SYSMMU_FIMC3 + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_JPEG,
+			.end	= S5PV310_PA_SYSMMU_JPEG + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_FIMD0,
+			.end	= S5PV310_PA_SYSMMU_FIMD0 + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_FIMD1,
+			.end	= S5PV310_PA_SYSMMU_FIMD1 + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_PCIe,
+			.end	= S5PV310_PA_SYSMMU_PCIe + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_G2D,
+			.end	= S5PV310_PA_SYSMMU_G2D + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_ROTATOR,
+			.end	= S5PV310_PA_SYSMMU_ROTATOR + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_MDMA2,
+			.end	= S5PV310_PA_SYSMMU_MDMA2 + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_TV,
+			.end	= S5PV310_PA_SYSMMU_TV + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_MFC_L,
+			.end	= S5PV310_PA_SYSMMU_MFC_L + SZ_4K - 1,
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
+			.start	= S5PV310_PA_SYSMMU_MFC_R,
+			.end	= S5PV310_PA_SYSMMU_MFC_R + SZ_4K - 1,
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
+static u64 s5p_sysmmu_dma_mask = DMA_BIT_MASK(32);
+
+struct platform_device s5pv310_device_sysmmu[] = {
+	[S5P_SYSMMU_MDMA] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MDMA,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_MDMA]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_MDMA],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_SSS] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_SSS,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_SSS]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_SSS],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC0] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC0,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_FIMC0]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_FIMC0],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC1] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC1,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_FIMC1]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_FIMC1],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC2] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC2,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_FIMC2]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_FIMC2],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMC3] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMC3,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_FIMC3]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_FIMC3],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_JPEG] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_JPEG,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_JPEG]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_JPEG],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMD0] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMD0,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_FIMD0]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_FIMD0],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_FIMD1] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_FIMD1,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_FIMD1]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_FIMD1],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_PCIe] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_PCIe,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_PCIe]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_PCIe],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_G2D] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_G2D,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_G2D]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_G2D],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_ROTATOR] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_ROTATOR,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_ROTATOR]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_ROTATOR],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_MDMA2] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MDMA2,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_MDMA2]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_MDMA2],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_TV] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_TV,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_TV]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_TV],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_MFC_L] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MFC_L,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_MFC_L]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_MFC_L],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+	[S5P_SYSMMU_MFC_R] = {
+		.name		= "s5p-sysmmu",
+		.id		= S5P_SYSMMU_MFC_R,
+		.num_resources	= ARRAY_SIZE(
+					s5p_sysmmu_resource[S5P_SYSMMU_MFC_R]),
+		.resource	= s5p_sysmmu_resource[S5P_SYSMMU_MFC_R],
+		.dev		= {
+			.dma_mask		= &s5p_sysmmu_dma_mask,
+			.coherent_dma_mask	= DMA_BIT_MASK(32),
+		},
+	},
+};
diff --git a/arch/arm/mach-s5pv310/include/mach/irqs.h b/arch/arm/mach-s5pv310/include/mach/irqs.h
index 0e99968..f6b99c6 100644
--- a/arch/arm/mach-s5pv310/include/mach/irqs.h
+++ b/arch/arm/mach-s5pv310/include/mach/irqs.h
@@ -55,23 +55,24 @@
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
+
 
 #define IRQ_PDMA0		COMBINER_IRQ(21, 0)
 #define IRQ_PDMA1		COMBINER_IRQ(21, 1)
@@ -147,4 +148,5 @@
 
 #define NR_IRQS			(S5P_IRQ_EINT_BASE + 32)
 
+
 #endif /* __ASM_ARCH_IRQS_H */
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
index 341571a..9ef5f0c 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
@@ -67,6 +67,8 @@
 #define S5P_CLKDIV_STAT_TOP		S5P_CLKREG(0x0C610)
 
 #define S5P_CLKGATE_IP_CAM		S5P_CLKREG(0x0C920)
+#define S5P_CLKGATE_IP_MFC		S5P_CLKREG(0x0C928)
+#define S5P_CLKGATE_IP_TV		S5P_CLKREG(0x0C924)
 #define S5P_CLKGATE_IP_IMAGE		S5P_CLKREG(0x0C930)
 #define S5P_CLKGATE_IP_LCD0		S5P_CLKREG(0x0C934)
 #define S5P_CLKGATE_IP_LCD1		S5P_CLKREG(0x0C938)
@@ -78,6 +80,7 @@
 #define S5P_CLKSRC_DMC			S5P_CLKREG(0x10200)
 #define S5P_CLKDIV_DMC0			S5P_CLKREG(0x10500)
 #define S5P_CLKDIV_STAT_DMC0		S5P_CLKREG(0x10600)
+#define S5P_CLKGATE_IP_DMC		S5P_CLKREG(0x10900)
 
 #define S5P_APLL_LOCK			S5P_CLKREG(0x14000)
 #define S5P_MPLL_LOCK			S5P_CLKREG(0x14004)
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h b/arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h
index 0b28e81..dd2a954 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-sysmmu.h
@@ -13,12 +13,21 @@
 #ifndef __ASM_ARCH_REGS_SYSMMU_H
 #define __ASM_ARCH_REGS_SYSMMU_H __FILE__
 
-#define S5P_MMU_CTRL			0x000
-#define S5P_MMU_CFG			0x004
-#define S5P_MMU_STATUS			0x008
-#define S5P_MMU_FLUSH			0x00C
-#define S5P_PT_BASE_ADDR		0x014
-#define S5P_INT_STATUS			0x018
-#define S5P_PAGE_FAULT_ADDR		0x024
+#define S5P_MMU_CTRL		(0x000)
+#define S5P_MMU_CFG		(0x004)
+#define S5P_MMU_STATUS		(0x008)
+#define S5P_MMU_FLUSH		(0x00C)
+#define S5P_MMU_FLUSH_ENTRY	(0x010)
+#define S5P_PT_BASE_ADDR	(0x014)
+#define S5P_INT_STATUS		(0x018)
+#define S5P_INT_CLEAR		(0x01C)
+#define S5P_INT_MASK		(0x020)
+#define S5P_PAGE_FAULT_ADDR	(0x024)
+#define S5P_AW_FAULT_ADDR	(0x028)
+#define S5P_AR_FAULT_ADDR	(0x02C)
+#define S5P_DEFAULT_SLAVE_ADDR	(0x030)
+#define S5P_MMU_VERSION		(0x034)
+#define S5P_TLB_READ            (0x038)
+#define S5P_TLB_DATA            (0x03C)
 
 #endif /* __ASM_ARCH_REGS_SYSMMU_H */
diff --git a/arch/arm/mach-s5pv310/include/mach/sysmmu.h b/arch/arm/mach-s5pv310/include/mach/sysmmu.h
deleted file mode 100644
index 598fc5c..0000000
--- a/arch/arm/mach-s5pv310/include/mach/sysmmu.h
+++ /dev/null
@@ -1,122 +0,0 @@
-/* linux/arch/arm/mach-s5pv310/include/mach/sysmmu.h
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com/
- *
- * Samsung sysmmu driver for S5PV310
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARM_ARCH_SYSMMU_H
-#define __ASM_ARM_ARCH_SYSMMU_H __FILE__
-
-#define S5PV310_SYSMMU_TOTAL_IPNUM	16
-#define S5P_SYSMMU_TOTAL_IPNUM		S5PV310_SYSMMU_TOTAL_IPNUM
-
-enum s5pv310_sysmmu_ips {
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
-};
-
-static char *sysmmu_ips_name[S5PV310_SYSMMU_TOTAL_IPNUM] = {
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
-typedef enum s5pv310_sysmmu_ips sysmmu_ips;
-
-struct sysmmu_tt_info {
-	unsigned long *pgd;
-	unsigned long pgd_paddr;
-	unsigned long *pte;
-};
-
-struct sysmmu_controller {
-	const char		*name;
-
-	/* channels registers */
-	void __iomem		*regs;
-
-	/* channel irq */
-	unsigned int		irq;
-
-	sysmmu_ips		ips;
-
-	/* Translation Table Info. */
-	struct sysmmu_tt_info	*tt_info;
-
-	struct resource		*mem;
-	struct device		*dev;
-
-	/* SysMMU controller enable - true : enable */
-	bool			enable;
-};
-
-/**
- * s5p_sysmmu_enable() - enable system mmu of ip
- * @ips: The ip connected system mmu.
- *
- * This function enable system mmu to transfer address
- * from virtual address to physical address
- */
-int s5p_sysmmu_enable(sysmmu_ips ips);
-
-/**
- * s5p_sysmmu_disable() - disable sysmmu mmu of ip
- * @ips: The ip connected system mmu.
- *
- * This function disable system mmu to transfer address
- * from virtual address to physical address
- */
-int s5p_sysmmu_disable(sysmmu_ips ips);
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
-int s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_tlb_invalidate() - flush all TLB entry in system mmu
- * @ips: The ip connected system mmu.
- *
- * This function flush all TLB entry in system mmu
- */
-int s5p_sysmmu_tlb_invalidate(sysmmu_ips ips);
-#endif /* __ASM_ARM_ARCH_SYSMMU_H */
diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 0db2a7a..4166964 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -37,14 +37,6 @@ config S5P_GPIO_INT
 	help
 	  Common code for the GPIO interrupts (other than external interrupts.)
 
-comment "System MMU"
-
-config S5P_SYSTEM_MMU
-	bool "S5P SYSTEM MMU"
-	depends on ARCH_S5PV310
-	help
-	  Say Y here if you want to enable System MMU
-
 config S5P_DEV_FIMC0
 	bool
 	help
@@ -79,3 +71,12 @@ config S5P_DEV_CSIS1
 	bool
 	help
 	  Compile in platform device definitions for MIPI-CSIS channel 1
+
+comment "System MMU"
+
+config S5P_SYSTEM_MMU
+	bool "S5P SYSTEM MMU"
+	depends on ARCH_S5PV310
+	help
+	  Say Y here if you want to enable System MMU
+
diff --git a/arch/arm/plat-s5p/include/plat/sysmmu.h b/arch/arm/plat-s5p/include/plat/sysmmu.h
new file mode 100644
index 0000000..9051af4
--- /dev/null
+++ b/arch/arm/plat-s5p/include/plat/sysmmu.h
@@ -0,0 +1,127 @@
+/*
+ * sysmmu.h
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+#ifndef __S5P_SYSMMU_H__
+#define __S5P_SYSMMU_H__
+
+struct device;
+
+/**
+ * enum s5p_sysmmu_cmd - sysmmu control commands
+ * @S5P_SYSMMU_ENABLE_SHARED:	enable sysmmu, share page tables with ARM CPU
+ * @S5P_SYSMMU_ENABLE_PRIVATE:	enable sysmmu, use private page tables
+ * @S5P_SYSMMU_DISABLE:		disable sysmmu
+ * @S5P_SYSMMU_TLB_INVALIDATE:	invalidate sysmmu TLB contents
+ */
+enum s5p_sysmmu_cmd {
+	S5P_SYSMMU_ENABLE_SHARED,
+	S5P_SYSMMU_ENABLE_PRIVATE,
+	S5P_SYSMMU_DISABLE,
+	S5P_SYSMMU_TLB_INVALIDATE,
+};
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
+};
+
+/**
+ * s5p_sysmmu_get() - get sysmmu handle for a device
+ * @dev:	device which needs to use its sysmmu
+ * @ip:		integrated peripheral identifier of the device
+ */
+void *s5p_sysmmu_get(struct device *dev, enum s5p_sysmmu_ip ip);
+
+/**
+ * s5p_sysmmu_put() - release sysmmu handle for a device
+ * @dev_id:	sysmmu handle obtained from s5p_sysmmu_get()
+ */
+void s5p_sysmmu_put(void *dev_id);
+
+/**
+ * s5p_sysmmu_control() - control a sysmmu
+ * @dev_id:	sysmmu handle obtained from s5p_sysmmu_get()
+ * @cmd:	command to perform
+ */
+int s5p_sysmmu_control(void *dev_id, enum s5p_sysmmu_cmd cmd);
+
+/**
+ * s5p_sysmmu_map_area() - map an area of device's virtual memory,
+ 			underlying memory is described by struct pages
+ * @dev_id:		sysmmu handle obtained from s5p_sysmmu_get()
+ * @varea_start:	beginning virtual address of the mapped area,
+ *			must be page aligned
+ * @num_pages:		number of pages to map starting from varea_start
+ * @pages:		an array of struct page pointers representing
+ *			the physical pages which will be mapped
+ */
+int s5p_sysmmu_map_area(void *dev_id, unsigned long varea_start,
+			unsigned long num_pages, struct page **pages);
+
+/**
+ * s5p_sysmmu_map_phys_area() - map an area of device's virtual memory,
+ *			underlying memory is a physically contiguous block
+ * @dev_id:		sysmmu handle obtained from s5p_sysmmu_get()
+ * @varea_start:	beginning virtual address of the mapped area,
+ *			must be page aligned
+ * @phys_area_start:	beginning physical adddress of the underlying memory
+ * @num_pages:		number of pages to map starting from phys_area_start
+ */
+int s5p_sysmmu_map_phys_area(void *dev_id, unsigned long varea_start,
+			     unsigned long phys_area_start,
+			     unsigned long num_pages);
+
+/**
+ * s5p_sysmmu_unmap_area() - unmap an area of device's virtual memory
+ * @dev_id:		sysmmu handle obtained from s5p_sysmmu_get()
+ * @varea_start:	beginning virtual address of the mapped area,
+ *			must be page aligned and correspond to the address
+ * 			used while mapping
+ * @num_pages:		number of pages to unmap starting from phys_area_start,
+ *			must correspond to the number used while mapping
+ */
+void s5p_sysmmu_unmap_area(void *dev_id, unsigned long varea_start,
+			   unsigned long num_pages);
+
+#endif /* __S5P_SYSMMU_H__ */
diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
dissimilarity index 85%
index ffe8a48..45adbf4 100644
--- a/arch/arm/plat-s5p/sysmmu.c
+++ b/arch/arm/plat-s5p/sysmmu.c
@@ -1,326 +1,662 @@
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
-#include <mach/map.h>
-#include <mach/regs-sysmmu.h>
-#include <mach/sysmmu.h>
-
-struct sysmmu_controller s5p_sysmmu_cntlrs[S5P_SYSMMU_TOTAL_IPNUM];
-
-void s5p_sysmmu_register(struct sysmmu_controller *sysmmuconp)
-{
-	unsigned int reg_mmu_ctrl;
-	unsigned int reg_mmu_status;
-	unsigned int reg_pt_base_addr;
-	unsigned int reg_int_status;
-	unsigned int reg_page_ft_addr;
-
-	reg_int_status = __raw_readl(sysmmuconp->regs + S5P_INT_STATUS);
-	reg_mmu_ctrl = __raw_readl(sysmmuconp->regs + S5P_MMU_CTRL);
-	reg_mmu_status = __raw_readl(sysmmuconp->regs + S5P_MMU_STATUS);
-	reg_pt_base_addr = __raw_readl(sysmmuconp->regs + S5P_PT_BASE_ADDR);
-	reg_page_ft_addr = __raw_readl(sysmmuconp->regs + S5P_PAGE_FAULT_ADDR);
-
-	printk(KERN_INFO "%s: ips:%s\n", __func__, sysmmuconp->name);
-	printk(KERN_INFO "%s: MMU_CTRL:0x%X, ", __func__, reg_mmu_ctrl);
-	printk(KERN_INFO "MMU_STATUS:0x%X, PT_BASE_ADDR:0x%X\n", reg_mmu_status, reg_pt_base_addr);
-	printk(KERN_INFO "%s: INT_STATUS:0x%X, PAGE_FAULT_ADDR:0x%X\n", __func__, reg_int_status, reg_page_ft_addr);
-
-	switch (reg_int_status & 0xFF) {
-	case 0x1:
-		printk(KERN_INFO "%s: Page fault\n", __func__);
-		printk(KERN_INFO "%s: Virtual address causing last page fault or bus error : 0x%x\n", __func__ , reg_page_ft_addr);
-		break;
-	case 0x2:
-		printk(KERN_INFO "%s: AR multi-hit fault\n", __func__);
-		break;
-	case 0x4:
-		printk(KERN_INFO "%s: AW multi-hit fault\n", __func__);
-		break;
-	case 0x8:
-		printk(KERN_INFO "%s: Bus error\n", __func__);
-		break;
-	case 0x10:
-		printk(KERN_INFO "%s: AR Security protection fault\n", __func__);
-		break;
-	case 0x20:
-		printk(KERN_INFO "%s: AR Access protection fault\n", __func__);
-		break;
-	case 0x40:
-		printk(KERN_INFO "%s: AW Security protection fault\n", __func__);
-		break;
-	case 0x80:
-		printk(KERN_INFO "%s: AW Access protection fault\n", __func__);
-		break;
-	}
-}
-
-static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
-{
-	unsigned int i;
-	unsigned int reg_int_status;
-	struct sysmmu_controller *sysmmuconp;
-
-	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++) {
-		sysmmuconp = &s5p_sysmmu_cntlrs[i];
-
-		if (sysmmuconp->enable == true) {
-			reg_int_status = __raw_readl(sysmmuconp->regs + S5P_INT_STATUS);
-
-			if (reg_int_status & 0xFF)
-				s5p_sysmmu_register(sysmmuconp);
-		}
-	}
-	return IRQ_HANDLED;
-}
-
-int s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd)
-{
-	struct sysmmu_controller *sysmmuconp = NULL;
-
-	sysmmuconp = &s5p_sysmmu_cntlrs[ips];
-
-	if (sysmmuconp == NULL) {
-		printk(KERN_ERR "failed to get ip's sysmmu info\n");
-		return 1;
-	}
-
-	/* Set sysmmu page table base address */
-	__raw_writel(pgd, sysmmuconp->regs + S5P_PT_BASE_ADDR);
-
-	if (s5p_sysmmu_tlb_invalidate(ips) != 0)
-		printk(KERN_ERR "failed s5p_sysmmu_tlb_invalidate\n");
-
-	return 0;
-}
-
-static int s5p_sysmmu_set_tablebase(sysmmu_ips ips)
-{
-	unsigned int pg;
-	struct sysmmu_controller *sysmmuconp;
-
-	sysmmuconp = &s5p_sysmmu_cntlrs[ips];
-
-	if (sysmmuconp == NULL) {
-		printk(KERN_ERR "failed to get ip's sysmmu info\n");
-		return 1;
-	}
-
-	__asm__("mrc	p15, 0, %0, c2, c0, 0"	\
-		: "=r" (pg) : : "cc");		\
-		pg &= ~0x3fff;
-
-	printk(KERN_INFO "%s: CP15 TTBR0 : 0x%x\n", __func__, pg);
-
-	/* Set sysmmu page table base address */
-	__raw_writel(pg, sysmmuconp->regs + S5P_PT_BASE_ADDR);
-
-	return 0;
-}
-
-int s5p_sysmmu_enable(sysmmu_ips ips)
-{
-	unsigned int reg;
-
-	struct sysmmu_controller *sysmmuconp;
-
-	sysmmuconp = &s5p_sysmmu_cntlrs[ips];
-
-	if (sysmmuconp == NULL) {
-		printk(KERN_ERR "failed to get ip's sysmmu info\n");
-		return 1;
-	}
-
-	s5p_sysmmu_set_tablebase(ips);
-
-	/* replacement policy : LRU */
-	reg = __raw_readl(sysmmuconp->regs + S5P_MMU_CFG);
-	reg |= 0x1;
-	__raw_writel(reg, sysmmuconp->regs + S5P_MMU_CFG);
-
-	/* Enable interrupt, Enable MMU */
-	reg = __raw_readl(sysmmuconp->regs + S5P_MMU_CTRL);
-	reg |= (0x1 << 2) | (0x1 << 0);
-
-	__raw_writel(reg, sysmmuconp->regs + S5P_MMU_CTRL);
-
-	sysmmuconp->enable = true;
-
-	return 0;
-}
-
-int s5p_sysmmu_disable(sysmmu_ips ips)
-{
-	unsigned int reg;
-
-	struct sysmmu_controller *sysmmuconp = NULL;
-
-	if (ips > S5P_SYSMMU_TOTAL_IPNUM)
-		printk(KERN_ERR "failed to get ips parameter\n");
-
-	sysmmuconp = &s5p_sysmmu_cntlrs[ips];
-
-	if (sysmmuconp == NULL) {
-		printk(KERN_ERR "failed to get ip's sysmmu info\n");
-		return 1;
-	}
-
-	reg = __raw_readl(sysmmuconp->regs + S5P_MMU_CFG);
-
-	/* replacement policy : LRU */
-	reg |= 0x1;
-	__raw_writel(reg, sysmmuconp->regs + S5P_MMU_CFG);
-
-	reg = __raw_readl(sysmmuconp->regs + S5P_MMU_CTRL);
-
-	/* Disable MMU */
-	reg &= ~0x1;
-	__raw_writel(reg, sysmmuconp->regs + S5P_MMU_CTRL);
-
-	sysmmuconp->enable = false;
-
-	return 0;
-}
-
-int s5p_sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	unsigned int reg;
-	struct sysmmu_controller *sysmmuconp = NULL;
-
-	sysmmuconp = &s5p_sysmmu_cntlrs[ips];
-
-	if (sysmmuconp == NULL) {
-		printk(KERN_ERR "failed to get ip's sysmmu info\n");
-		return 1;
-	}
-
-	/* set Block MMU for flush TLB */
-	reg = __raw_readl(sysmmuconp->regs + S5P_MMU_CTRL);
-	reg |= 0x1 << 1;
-	__raw_writel(reg, sysmmuconp->regs + S5P_MMU_CTRL);
-
-	/* flush all TLB entry */
-	__raw_writel(0x1, sysmmuconp->regs + S5P_MMU_FLUSH);
-
-	/* set Un-block MMU after flush TLB */
-	reg = __raw_readl(sysmmuconp->regs + S5P_MMU_CTRL);
-	reg &= ~(0x1 << 1);
-	__raw_writel(reg, sysmmuconp->regs + S5P_MMU_CTRL);
-
-	return 0;
-}
-
-static int s5p_sysmmu_probe(struct platform_device *pdev)
-{
-	int i;
-	int ret;
-	struct resource *res;
-	struct sysmmu_controller *sysmmuconp;
-	sysmmu_ips ips;
-
-	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++) {
-		sysmmuconp = &s5p_sysmmu_cntlrs[i];
-		if (sysmmuconp == NULL) {
-			printk(KERN_ERR "failed to get ip's sysmmu info\n");
-			ret = -ENOENT;
-			goto err_res;
-		}
-
-		sysmmuconp->name = sysmmu_ips_name[i];
-
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res) {
-			printk(KERN_ERR "failed to get sysmmu resource\n");
-			ret = -ENODEV;
-			goto err_res;
-		}
-
-		sysmmuconp->mem = request_mem_region(res->start,
-				((res->end) - (res->start)) + 1, pdev->name);
-		if (!sysmmuconp->mem) {
-			pr_err("failed to request sysmmu memory region\n");
-			ret = -EBUSY;
-			goto err_res;
-		}
-
-		sysmmuconp->regs = ioremap(res->start, res->end - res->start + 1);
-		if (!sysmmuconp->regs) {
-			pr_err("failed to sysmmu ioremap\n");
-			ret = -ENXIO;
-			goto err_reg;
-		}
-
-		sysmmuconp->irq = platform_get_irq(pdev, i);
-		if (sysmmuconp->irq <= 0) {
-			pr_err("failed to get sysmmu irq resource\n");
-			ret = -ENOENT;
-			goto err_map;
-		}
-
-		ret = request_irq(sysmmuconp->irq, s5p_sysmmu_irq, IRQF_DISABLED, pdev->name, sysmmuconp);
-		if (ret) {
-			pr_err("failed to request irq\n");
-			ret = -ENOENT;
-			goto err_map;
-		}
-
-		ips = (sysmmu_ips)i;
-
-		sysmmuconp->ips = ips;
-	}
-
-	return 0;
-
-err_reg:
-	release_mem_region((resource_size_t)sysmmuconp->mem, (resource_size_t)((res->end) - (res->start) + 1));
-err_map:
-	iounmap(sysmmuconp->regs);
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
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
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
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
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
+struct s5p_sysmmu_info {
+	struct mutex		mutex;
+	struct resource		*ioarea;
+	void __iomem		*regs;
+	unsigned int		irq;
+	struct clk		*clk;
+	bool			enabled;
+	bool			page_tables_allocated;
+	enum s5p_sysmmu_ip	ip;
+	enum s5p_sysmmu_cmd	mode;
+
+	unsigned long		flpt;
+	unsigned long		flpt_vaddr;
+	/* one table entry per 4 entries of the first level page table */
+	unsigned long		*vaddr;
+	/* one table entry per 4 entries of the first level page table */
+	u16			*refcount;
+
+	struct device		*dev;
+
+	struct list_head	entry;
+};
+
+static LIST_HEAD(sysmmu_list);
+static DEFINE_SPINLOCK(sysmmu_list_slock);
+
+void *s5p_sysmmu_get(struct device *dev, enum s5p_sysmmu_ip ip)
+{
+	struct s5p_sysmmu_info *ret;
+	unsigned long flags;
+
+	sysmmu_debug(3, "for %s\n", dev_name(dev));
+
+	spin_lock_irqsave(&sysmmu_list_slock, flags);
+	list_for_each_entry(ret, &sysmmu_list, entry) {
+		if (ret->ip == ip) {
+			try_module_get(THIS_MODULE);
+			spin_unlock_irqrestore(&sysmmu_list_slock, flags);
+			return ret;
+		}
+	}
+	spin_unlock_irqrestore(&sysmmu_list_slock, flags);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_get);
+
+void s5p_sysmmu_put(void *dev_id)
+{
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_put);
+
+static void s5p_sysmmu_configure(struct s5p_sysmmu_info *sysmmu,
+				 unsigned long pg)
+{
+	unsigned int reg;
+
+	writel(pg, sysmmu->regs + S5P_PT_BASE_ADDR);
+
+	reg = readl(sysmmu->regs + S5P_MMU_CFG);
+	reg |= (0x1<<0);		/* replacement policy : LRU */
+	writel(reg, sysmmu->regs + S5P_MMU_CFG);
+
+	reg = readl(sysmmu->regs + S5P_MMU_CTRL);
+	reg |= ((0x1<<2)|(0x1<<0));	/* Enable interrupt, Enable MMU */
+	writel(reg, sysmmu->regs + S5P_MMU_CTRL);
+
+	sysmmu_debug(3, "CFG:0x%x\n", readl(sysmmu->regs + S5P_MMU_CFG));
+	sysmmu_debug(3, "CTRL:0x%x\n", readl(sysmmu->regs + S5P_MMU_CTRL));
+	sysmmu_debug(3, "STATUS:0x%x\n", readl(sysmmu->regs + S5P_MMU_STATUS));
+
+	sysmmu->enabled = true;
+}
+
+static int s5p_sysmmu_control_locked(struct s5p_sysmmu_info *sysmmu,
+				     enum s5p_sysmmu_cmd cmd)
+{
+	unsigned int pg, reg;
+
+	sysmmu_debug(3, "%d\n", cmd);
+
+	sysmmu->mode = cmd;
+
+	switch (cmd) {
+	case S5P_SYSMMU_ENABLE_SHARED:
+		/*
+		 * coprocessor 15 == mmu;
+		 * copy system page tables base from there
+		 */
+		__asm__("mrc p15, 0, %0, c2, c0, 0" : "=r" (pg) : : "cc");
+		pg &= ~0x3fff;
+
+		s5p_sysmmu_configure(sysmmu, pg);
+
+		return 0;
+	break;
+
+	case S5P_SYSMMU_ENABLE_PRIVATE:
+		pm_runtime_get_sync(sysmmu->dev);
+		if (!sysmmu->page_tables_allocated) {
+			/*
+			 * first-level page table holds
+			 * 4k second-level descriptors == 16kB == 4 pages
+			 */
+			sysmmu->flpt_vaddr = (unsigned long)dma_alloc_coherent(
+				sysmmu->dev,
+				4 * PAGE_SIZE,
+				(dma_addr_t *)&sysmmu->flpt,
+				GFP_KERNEL | __GFP_ZERO);
+			if (!sysmmu->flpt_vaddr)
+				return -ENOMEM;
+
+			sysmmu->refcount = kzalloc(1024 * sizeof(u16),
+						   GFP_KERNEL);
+			if (!sysmmu->refcount) {
+				dma_free_coherent(sysmmu->dev, 4 * PAGE_SIZE,
+					(dma_addr_t *)sysmmu->flpt_vaddr,
+					sysmmu->flpt);
+				return -ENOMEM;
+			}
+
+			sysmmu->vaddr = kzalloc(1024 * sizeof(unsigned long),
+						GFP_KERNEL);
+			if (!sysmmu->vaddr) {
+				kfree(sysmmu->refcount);
+				dma_free_coherent(sysmmu->dev, 4 * PAGE_SIZE,
+					(void *)sysmmu->flpt_vaddr,
+					sysmmu->flpt);
+				return -ENOMEM;
+			}
+			sysmmu->page_tables_allocated = true;
+		}
+		s5p_sysmmu_configure(sysmmu, sysmmu->flpt);
+
+		return 0;
+	break;
+
+	case S5P_SYSMMU_DISABLE:
+		reg = readl(sysmmu->regs + S5P_MMU_CFG);
+		reg |= (0x1<<0);		/* replacement policy : LRU */
+		writel(reg, sysmmu->regs + S5P_MMU_CFG);
+
+		reg = readl(sysmmu->regs + S5P_MMU_CTRL);
+		reg &= ~(0x1);			/* Disable MMU */
+		writel(reg, sysmmu->regs + S5P_MMU_CTRL);
+		sysmmu->enabled = false;
+ 		pm_runtime_put_sync(sysmmu->dev);
+		return 0;
+	break;
+
+	case S5P_SYSMMU_TLB_INVALIDATE:
+		reg = readl(sysmmu->regs + S5P_MMU_CTRL);
+		reg |= (0x1<<1);		/* Block MMU */
+		writel(reg, sysmmu->regs + S5P_MMU_CTRL);
+
+		writel(0x1, sysmmu->regs + S5P_MMU_FLUSH);
+						/* Flush_entry */
+
+		reg = readl(sysmmu->regs + S5P_MMU_CTRL);
+		reg &= ~(0x1<<1);		/* Un-block MMU */
+		writel(reg, sysmmu->regs + S5P_MMU_CTRL);
+		return 0;
+	break;
+
+	default:
+		;
+	}
+	return -EINVAL;
+}
+
+int s5p_sysmmu_control(void *dev_id, enum s5p_sysmmu_cmd cmd)
+{
+	struct s5p_sysmmu_info *sysmmu = dev_id;
+	int ret;
+
+	mutex_lock(&sysmmu->mutex);
+	ret = s5p_sysmmu_control_locked(sysmmu, cmd);
+	mutex_unlock(&sysmmu->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_control);
+
+#define dereference_vaddr(vaddr) (*((unsigned long *)(vaddr)))
+
+#define make_flpt_entry(slpt, k) \
+	((((slpt) + (k) * 256 * 4) & ~0x3FF) | 0x1)
+#define make_slpt_phys_entry(phys) (((phys) & ~0xFFF) | 0x2)
+
+#define flpt_offset(vaddr) (((vaddr) >> 18) & 0x3FFC)
+#define slpt_offset(slpt, vaddr) \
+	(((slpt) & (0x3 << 10)) + (((vaddr) >> 10) & 0x3FC))
+
+#define slpt_number(vaddr) (((vaddr) >> 22) & 0x3FF)
+
+#define get_slpt(flpt_entry_vaddr) \
+	(dereference_vaddr(flpt_entry_vaddr) & ~0x3FF)
+#define get_slpt_four(flpt_entry_vaddr) \
+	(dereference_vaddr(flpt_entry_vaddr) & ~0xFFF)
+
+#define invalidate_slpt_entry(slpt_entry_vaddr) \
+	(dereference_vaddr(slpt_entry_vaddr) &= ~0x3)
+
+/*
+ * vaddr:
+ * X X X X X X X X X X X X  X X X X X X X X  X X X X X X X X X X 0 0
+ * 31--------------------20 19------------12 11--------------------0
+ *     index into flpt       idx into slpt      offset within page
+ */
+static int s5p_sysmmu_map_page(struct s5p_sysmmu_info *sysmmu,
+	   		       unsigned long vaddr, unsigned long paddr)
+{
+	unsigned long flpt_entry_vaddr, slpt_entry_vaddr, slpt, slpt_vaddr;
+	int four_entry = slpt_number(vaddr);
+
+	flpt_entry_vaddr = sysmmu->flpt_vaddr + flpt_offset(vaddr);
+	if (0 == dereference_vaddr(flpt_entry_vaddr)) {
+		int k;
+		unsigned long flpt_four = flpt_entry_vaddr & ~0xF;
+
+		slpt_vaddr = (unsigned long)dma_alloc_coherent(
+			sysmmu->dev,
+			PAGE_SIZE,
+			(dma_addr_t *)&slpt,
+			GFP_KERNEL | __GFP_ZERO);
+		if (!slpt_vaddr)
+			return -1;
+
+		sysmmu->vaddr[four_entry] = slpt_vaddr;
+
+		for (k = 0; k < 4; ++k)
+			dereference_vaddr(flpt_four + 4 * k) =
+						make_flpt_entry(slpt, k);
+
+		sysmmu_debug(3, "4-entry:%d\n", four_entry);
+	}
+	slpt = get_slpt(flpt_entry_vaddr);
+	slpt_entry_vaddr = sysmmu->vaddr[four_entry] + slpt_offset(slpt, vaddr);
+	dereference_vaddr(slpt_entry_vaddr) = make_slpt_phys_entry(paddr);
+	sysmmu->refcount[four_entry]++;
+
+	return 0;
+}
+
+static void s5p_unmap_page(struct s5p_sysmmu_info *sysmmu, unsigned long vaddr)
+{
+	unsigned long flpt_entry_vaddr, slpt_entry_vaddr, slpt;
+	int four_entry = slpt_number(vaddr);
+
+	flpt_entry_vaddr = sysmmu->flpt_vaddr + flpt_offset(vaddr);
+	if (--sysmmu->refcount[four_entry]) {
+		slpt = get_slpt(flpt_entry_vaddr);
+		slpt_entry_vaddr = sysmmu->vaddr[four_entry] +
+				slpt_offset(slpt, vaddr);
+		invalidate_slpt_entry(slpt_entry_vaddr);
+	} else {
+		dma_free_coherent(sysmmu->dev, PAGE_SIZE,
+			(void *)sysmmu->vaddr[four_entry],
+			get_slpt_four(flpt_entry_vaddr));
+
+		memset((void *)(flpt_entry_vaddr & ~0xF), 0, 16);
+
+		sysmmu->vaddr[four_entry] = 0;
+	}
+}
+
+int s5p_sysmmu_map_area(void *dev_id, unsigned long varea_start,
+			unsigned long num_pages, struct page **pages)
+{
+	struct s5p_sysmmu_info *sysmmu = dev_id;
+	int i, ret;
+
+	sysmmu_debug(3, "varea_start:0x%lx, num_pages:%ld\n",
+		     varea_start, num_pages);
+
+	mutex_lock(&sysmmu->mutex);
+	for (i = 0; i < num_pages; varea_start += PAGE_SIZE, ++i) {
+		ret = s5p_sysmmu_map_page(sysmmu,
+				     varea_start, page_to_phys(pages[i]));
+		if (ret < 0)
+			goto slpt_pg_alloc_fail;
+	}
+
+	mutex_unlock(&sysmmu->mutex);
+
+	sysmmu_debug(3, "MAPPING DONE for varea_start:0x%lx, num_pages:%ld\n",
+		     varea_start - num_pages * PAGE_SIZE, num_pages);
+
+	return 0;
+
+slpt_pg_alloc_fail:
+	while (--i >= 0) {
+		varea_start -= PAGE_SIZE;
+		s5p_unmap_page(sysmmu, varea_start);
+	}
+	s5p_sysmmu_control_locked(sysmmu, S5P_SYSMMU_TLB_INVALIDATE);
+	mutex_unlock(&sysmmu->mutex);
+	return -1;
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_map_area);
+
+int s5p_sysmmu_map_phys_area(void *dev_id, unsigned long varea_start,
+			unsigned long phys_area_start, unsigned long num_pages)
+{
+	struct s5p_sysmmu_info *sysmmu = dev_id;
+	int i;
+
+	sysmmu_debug(3, "varea_start:0x%lx, num_pages:%ld\n",
+		     varea_start, num_pages);
+
+	mutex_lock(&sysmmu->mutex);
+	for (i = 0; i < num_pages;
+		varea_start += PAGE_SIZE, phys_area_start += PAGE_SIZE, ++i)
+		if (s5p_sysmmu_map_page(sysmmu, varea_start, phys_area_start) < 0)
+			goto slpt_pg_alloc_fail;
+
+	mutex_unlock(&sysmmu->mutex);
+
+	sysmmu_debug(3, "MAPPING DONE for varea_start:0x%lx, num_pages:%ld\n",
+		     varea_start - num_pages * PAGE_SIZE, num_pages);
+
+	return 0;
+
+slpt_pg_alloc_fail:
+	while (--i >= 0) {
+		varea_start -= PAGE_SIZE;
+		s5p_unmap_page(sysmmu, varea_start);
+	}
+	s5p_sysmmu_control_locked(sysmmu, S5P_SYSMMU_TLB_INVALIDATE);
+	mutex_unlock(&sysmmu->mutex);
+	return -1;
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_map_phys_area);
+
+void s5p_sysmmu_unmap_area(void *dev_id, unsigned long varea_start,
+			   unsigned long num_pages)
+{
+	struct s5p_sysmmu_info *sysmmu = dev_id;
+	unsigned long vaddr = varea_start;
+	int i;
+
+	mutex_lock(&sysmmu->mutex);
+
+	sysmmu_debug(3, "varea_start:0x%lx, num_pages:%ld\n",
+		     varea_start, num_pages);
+
+	for (i = 0; i < num_pages; vaddr += PAGE_SIZE, ++i)
+		s5p_unmap_page(sysmmu, vaddr);
+
+	s5p_sysmmu_control_locked(sysmmu, S5P_SYSMMU_TLB_INVALIDATE);
+	mutex_unlock(&sysmmu->mutex);
+
+	sysmmu_debug(3, "UNMAPPING DONE for varea_start:0x%lx, num_pages:%ld\n",
+		     varea_start, num_pages);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(s5p_sysmmu_unmap_area);
+
+static void s5p_sysmmu_pg_fault(struct s5p_sysmmu_info *sysmmu)
+{
+	void __iomem *regbase = sysmmu->regs;
+	unsigned long fault;
+
+	fault = readl(regbase + S5P_PAGE_FAULT_ADDR);
+	sysmmu_debug(3, "Page fault occured for virtual address 0x%08lx\n",
+		     fault);
+}
+
+static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
+{
+	struct s5p_sysmmu_info *sysmmu = dev_id;
+	unsigned int reg_INT_STATUS;
+
+	if (false == sysmmu->enabled)
+		return IRQ_HANDLED;
+
+	reg_INT_STATUS = readl(sysmmu->regs + S5P_INT_STATUS);
+	if (reg_INT_STATUS & 0xFF) {
+		switch (reg_INT_STATUS & 0xFF) {
+		case 0x1:
+			/* page fault */
+			sysmmu_debug(3, "irq:pg fault\n");
+			s5p_sysmmu_pg_fault(sysmmu);
+			break;
+		case 0x2:
+			/* AR multi-hit fault */
+			sysmmu_debug(3, "irq:ar multi hit\n");
+			break;
+		case 0x4:
+			/* AW multi-hit fault */
+			sysmmu_debug(3, "irq:aw multi hit\n");
+			break;
+		case 0x8:
+			/* bus error */
+			sysmmu_debug(3, "irq:bus error\n");
+			break;
+		case 0x10:
+			/* AR security protection fault */
+			sysmmu_debug(3, "irq:ar security protection fault\n");
+			break;
+		case 0x20:
+			/* AR access protection fault */
+			sysmmu_debug(3, "irq:ar access protection fault\n");
+			break;
+		case 0x40:
+			/* AW security protection fault */
+			sysmmu_debug(3, "irq:aw security protection fault\n");
+			break;
+		case 0x80:
+			/* AW access protection fault */
+			sysmmu_debug(3, "irq:aw access protection fault\n");
+			break;
+		}
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
+	clk_enable(sysmmu->clk);
+
+	sysmmu->ip = pdev->id;
+
+	spin_lock_irqsave(&sysmmu_list_slock, flags);
+	list_add(&sysmmu->entry, &sysmmu_list);
+	spin_unlock_irqrestore(&sysmmu_list_slock, flags);
+
+	sysmmu->dev = &pdev->dev;
+
+	mutex_init(&sysmmu->mutex);
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
+	int i = 1024;
+
+ 	pm_runtime_disable(sysmmu->dev);
+
+	if ((S5P_SYSMMU_ENABLE_PRIVATE == sysmmu->mode)) {
+		while (i >= 0) {
+			if (sysmmu->refcount[i]) {
+				unsigned long flpt_entry;
+				flpt_entry = dereference_vaddr(
+					sysmmu->flpt_vaddr + 4 * 4 * i);
+				dma_free_coherent(sysmmu->dev,
+					PAGE_SIZE,
+					(void *)sysmmu->vaddr[i],
+					flpt_entry & ~0xFFF);
+			}
+			--i;
+		}
+
+		if (sysmmu->flpt) {
+			dma_free_coherent(sysmmu->dev, 4 * PAGE_SIZE,
+				(void *)sysmmu->flpt_vaddr, sysmmu->flpt);
+		}
+		kfree(sysmmu->refcount);
+		kfree(sysmmu->vaddr);
+	}
+
+	spin_lock_irqsave(&sysmmu_list_slock, flags);
+	list_del(&sysmmu->entry);
+	spin_unlock_irqrestore(&sysmmu_list_slock, flags);
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
+static int s5p_sysmmu_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int s5p_sysmmu_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int s5p_sysmmu_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	return 0;
+}
+
+static int s5p_sysmmu_resume(struct platform_device *pdev)
+{
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
+static int __init s5p_sysmmu_register(void)
+{
+	return platform_driver_register(&s5p_sysmmu_driver);
+}
+
+static void __exit s5p_sysmmu_unregister(void)
+{
+	platform_driver_unregister(&s5p_sysmmu_driver);
+}
+
+module_init(s5p_sysmmu_register);
+module_exit(s5p_sysmmu_unregister);
+
+MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
+MODULE_DESCRIPTION("Samsung System MMU (IOMMU) driver");
+MODULE_LICENSE("GPL");
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index b0123f3..9f42dee 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -138,7 +138,7 @@ extern struct platform_device s5p_device_fimc3;
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
 
-extern struct platform_device s5pv310_device_sysmmu;
+extern struct platform_device s5pv310_device_sysmmu[];
 
 /* s3c2440 specific devices */
 
-- 
1.7.1.569.g6f426
