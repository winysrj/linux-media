Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20987 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbbLPPhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 10:37:38 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v3 1/7] ARM: Exynos: convert MFC device to generic reserved
 memory bindings
Date: Wed, 16 Dec 2015 16:37:23 +0100
Message-id: <1450280249-24681-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com>
References: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces custom properties for definining reserved memory
regions with generic reserved memory bindings. All custom code for
handling MFC-specific reserved memory can be now removed from Exynos-DT
generic board code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          | 16 ++--
 arch/arm/boot/dts/exynos4210-origen.dts            | 22 ++++-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          | 22 ++++-
 arch/arm/boot/dts/exynos4412-origen.dts            | 22 ++++-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          | 22 ++++-
 arch/arm/boot/dts/exynos5250-arndale.dts           | 22 ++++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          | 22 ++++-
 arch/arm/boot/dts/exynos5250-spring.dts            | 22 ++++-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      | 22 ++++-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          | 22 ++++-
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi | 22 ++++-
 arch/arm/mach-exynos/Makefile                      |  2 -
 arch/arm/mach-exynos/exynos.c                      | 19 -----
 arch/arm/mach-exynos/mfc.h                         | 16 ----
 arch/arm/mach-exynos/s5p-dev-mfc.c                 | 94 ----------------------
 15 files changed, 208 insertions(+), 159 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/mfc.h
 delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 2d5787eac91a..4603673c593b 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -21,16 +21,16 @@ Required properties:
   - clock-names : from common clock binding: must contain "mfc",
 		  corresponding to entry in the clocks property.
 
-  - samsung,mfc-r : Base address of the first memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
-  - samsung,mfc-l : Base address of the second memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
 Optional properties:
   - power-domains : power-domain property defined with a phandle
 			   to respective power domain.
 
+  - memory-region : from reserved memory binding: phandles to two reserved
+	memory regions: accessed by "left" and "right" mfc memory bus
+	interfaces, used when no SYSMMU support is available
+  - memory-region-names : from reserved memory binding: must be "left"
+	and "right"
+
 Example:
 SoC specific DT entry:
 
@@ -46,6 +46,6 @@ mfc: codec@13400000 {
 Board specific DT entry:
 
 codec@13400000 {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index 5821ad87e32c..4b7637dfa392 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -30,6 +30,24 @@
 		       0x70000000 0x10000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs ="root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC2,115200 init=/linuxrc";
 		stdout-path = &serial_2;
@@ -288,8 +306,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 104cbb33d2bb..efafc5721817 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -26,6 +26,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC1,115200 init=/linuxrc";
 		stdout-path = &serial_1;
@@ -133,8 +151,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 9e2e24c6177a..fb9291e371bc 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -25,6 +25,24 @@
 		reg = <0x40000000 0x40000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs ="console=ttySAC2,115200";
 		stdout-path = &serial_2;
@@ -466,8 +484,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index a130ab39fa77..4df182b52665 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -23,6 +23,24 @@
 		reg = <0x40000000 0x40000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs ="root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC1,115200 init=/linuxrc";
 		stdout-path = &serial_1;
@@ -112,8 +130,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index c000532c1444..30ada98cd078 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -23,6 +23,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=ttySAC2,115200";
 	};
@@ -518,8 +536,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 0f5dcd418af8..88fe16dda188 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -25,6 +25,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "root=/dev/ram0 rw ramdisk=8192 initrd=0x41000000,8M console=ttySAC2,115200 init=/linuxrc";
 	};
@@ -346,8 +364,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index c1edd6d038a9..607d133ac1a9 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -23,6 +23,24 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=tty1";
 		stdout-path = "serial3:115200n8";
@@ -427,8 +445,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 4ecef6981d5c..cdaf49a1bd5b 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -24,6 +24,24 @@
 		reg = <0x20000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=ttySAC3,115200";
 	};
@@ -345,8 +363,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index ac35aefd320f..159e6d9ae0f8 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -21,6 +21,24 @@
 		reg = <0x20000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		bootargs = "console=ttySAC2,115200 init=/linuxrc";
 	};
@@ -355,8 +373,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
 
 &mmc_0 {
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 9134217446b8..864cf1180129 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -23,6 +23,24 @@
 		reg = <0x40000000 0x7EA00000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	chosen {
 		linux,stdout-path = &serial_2;
 	};
@@ -319,8 +337,8 @@
 };
 
 &mfc {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
 };
 
 &mmc_0 {
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 2f306767cdfe..bcefb5473ee4 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -23,5 +23,3 @@ AFLAGS_sleep.o			:=-Wa,-march=armv7-a$(plus_sec)
 
 obj-$(CONFIG_EXYNOS5420_MCPM)	+= mcpm-exynos.o
 CFLAGS_mcpm-exynos.o		+= -march=armv7-a
-
-obj-$(CONFIG_S5P_DEV_MFC)	+= s5p-dev-mfc.o
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 1c47aee31e9c..662f329e37cd 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -30,7 +30,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "mfc.h"
 #include "regs-pmu.h"
 
 void __iomem *pmu_base_addr;
@@ -290,23 +289,6 @@ static char const *const exynos_dt_compat[] __initconst = {
 	NULL
 };
 
-static void __init exynos_reserve(void)
-{
-#ifdef CONFIG_S5P_DEV_MFC
-	int i;
-	char *mfc_mem[] = {
-		"samsung,mfc-v5",
-		"samsung,mfc-v6",
-		"samsung,mfc-v7",
-		"samsung,mfc-v8",
-	};
-
-	for (i = 0; i < ARRAY_SIZE(mfc_mem); i++)
-		if (of_scan_flat_dt(s5p_fdt_alloc_mfc_mem, mfc_mem[i]))
-			break;
-#endif
-}
-
 static void __init exynos_dt_fixup(void)
 {
 	/*
@@ -328,6 +310,5 @@ DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
 	.dt_compat	= exynos_dt_compat,
-	.reserve	= exynos_reserve,
 	.dt_fixup	= exynos_dt_fixup,
 MACHINE_END
diff --git a/arch/arm/mach-exynos/mfc.h b/arch/arm/mach-exynos/mfc.h
deleted file mode 100644
index dec93cd5b3c6..000000000000
--- a/arch/arm/mach-exynos/mfc.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (C) 2013 Samsung Electronics Co.Ltd
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef __MACH_EXYNOS_MFC_H
-#define __MACH_EXYNOS_MFC_H __FILE__
-
-int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
-				int depth, void *data);
-
-#endif /* __MACH_EXYNOS_MFC_H */
diff --git a/arch/arm/mach-exynos/s5p-dev-mfc.c b/arch/arm/mach-exynos/s5p-dev-mfc.c
deleted file mode 100644
index 0b04b6b0fa30..000000000000
--- a/arch/arm/mach-exynos/s5p-dev-mfc.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
- *
- * Base S5P MFC resource and device definitions
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
-#include <linux/memblock.h>
-#include <linux/ioport.h>
-#include <linux/of_fdt.h>
-#include <linux/of.h>
-
-static struct platform_device s5p_device_mfc_l;
-static struct platform_device s5p_device_mfc_r;
-
-struct s5p_mfc_dt_meminfo {
-	unsigned long	loff;
-	unsigned long	lsize;
-	unsigned long	roff;
-	unsigned long	rsize;
-	char		*compatible;
-};
-
-struct s5p_mfc_reserved_mem {
-	phys_addr_t	base;
-	unsigned long	size;
-	struct device	*dev;
-};
-
-static struct s5p_mfc_reserved_mem s5p_mfc_mem[2] __initdata;
-
-
-static void __init s5p_mfc_reserve_mem(phys_addr_t rbase, unsigned int rsize,
-				phys_addr_t lbase, unsigned int lsize)
-{
-	int i;
-
-	s5p_mfc_mem[0].dev = &s5p_device_mfc_r.dev;
-	s5p_mfc_mem[0].base = rbase;
-	s5p_mfc_mem[0].size = rsize;
-
-	s5p_mfc_mem[1].dev = &s5p_device_mfc_l.dev;
-	s5p_mfc_mem[1].base = lbase;
-	s5p_mfc_mem[1].size = lsize;
-
-	for (i = 0; i < ARRAY_SIZE(s5p_mfc_mem); i++) {
-		struct s5p_mfc_reserved_mem *area = &s5p_mfc_mem[i];
-		if (memblock_remove(area->base, area->size)) {
-			printk(KERN_ERR "Failed to reserve memory for MFC device (%ld bytes at 0x%08lx)\n",
-			       area->size, (unsigned long) area->base);
-			area->base = 0;
-		}
-	}
-}
-
-int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
-				int depth, void *data)
-{
-	const __be32 *prop;
-	int len;
-	struct s5p_mfc_dt_meminfo mfc_mem;
-
-	if (!data)
-		return 0;
-
-	if (!of_flat_dt_is_compatible(node, data))
-		return 0;
-
-	prop = of_get_flat_dt_prop(node, "samsung,mfc-l", &len);
-	if (!prop || (len != 2 * sizeof(unsigned long)))
-		return 0;
-
-	mfc_mem.loff = be32_to_cpu(prop[0]);
-	mfc_mem.lsize = be32_to_cpu(prop[1]);
-
-	prop = of_get_flat_dt_prop(node, "samsung,mfc-r", &len);
-	if (!prop || (len != 2 * sizeof(unsigned long)))
-		return 0;
-
-	mfc_mem.roff = be32_to_cpu(prop[0]);
-	mfc_mem.rsize = be32_to_cpu(prop[1]);
-
-	s5p_mfc_reserve_mem(mfc_mem.roff, mfc_mem.rsize,
-			mfc_mem.loff, mfc_mem.lsize);
-
-	return 1;
-}
-- 
1.9.2

