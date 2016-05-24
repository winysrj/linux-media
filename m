Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20886 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497AbcEXNb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 09:31:58 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v4 5/7] ARM: Exynos: remove code for MFC custom reserved memory
 handling
Date: Tue, 24 May 2016 15:31:28 +0200
Message-id: <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once MFC driver has been converted to generic reserved memory bindings,
there is no need for custom memory reservation code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-exynos/Makefile      |  2 -
 arch/arm/mach-exynos/exynos.c      | 19 --------
 arch/arm/mach-exynos/mfc.h         | 16 -------
 arch/arm/mach-exynos/s5p-dev-mfc.c | 93 --------------------------------------
 4 files changed, 130 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/mfc.h
 delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 34d29df..b91b382 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -23,5 +23,3 @@ AFLAGS_sleep.o			:=-Wa,-march=armv7-a$(plus_sec)
 
 obj-$(CONFIG_EXYNOS5420_MCPM)	+= mcpm-exynos.o
 CFLAGS_mcpm-exynos.o		+= -march=armv7-a
-
-obj-$(CONFIG_S5P_DEV_MFC)	+= s5p-dev-mfc.o
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 52ccf24..a8620c6 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -27,7 +27,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "mfc.h"
 
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
@@ -237,23 +236,6 @@ static char const *const exynos_dt_compat[] __initconst = {
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
@@ -275,6 +257,5 @@ DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
 	.dt_compat	= exynos_dt_compat,
-	.reserve	= exynos_reserve,
 	.dt_fixup	= exynos_dt_fixup,
 MACHINE_END
diff --git a/arch/arm/mach-exynos/mfc.h b/arch/arm/mach-exynos/mfc.h
deleted file mode 100644
index dec93cd..0000000
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
index 8ef1f3e..0000000
--- a/arch/arm/mach-exynos/s5p-dev-mfc.c
+++ /dev/null
@@ -1,93 +0,0 @@
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

