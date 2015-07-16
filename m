Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38475 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbGPMy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 08:54:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Tony Lindgren <tony@atomide.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/2] ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
Date: Thu, 16 Jul 2015 15:55:18 +0300
Message-Id: <1437051319-9904-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3 ISP is now fully supported in DT, remove its instantiation
from C code.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-omap2/devices.c | 53 -------------------------------------------
 arch/arm/mach-omap2/devices.h | 19 ----------------
 2 files changed, 72 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/devices.h

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index a69bd67e9028..9374da313e8e 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -33,7 +33,6 @@
 #include "common.h"
 #include "mux.h"
 #include "control.h"
-#include "devices.h"
 #include "display.h"
 
 #define L3_MODULES_MAX_LEN 12
@@ -67,58 +66,6 @@ static int __init omap3_l3_init(void)
 }
 omap_postcore_initcall(omap3_l3_init);
 
-#if defined(CONFIG_IOMMU_API)
-
-#include <linux/platform_data/iommu-omap.h>
-
-static struct resource omap3isp_resources[] = {
-	{
-		.start		= OMAP3430_ISP_BASE,
-		.end		= OMAP3430_ISP_BASE + 0x12fc,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= OMAP3430_ISP_BASE2,
-		.end		= OMAP3430_ISP_BASE2 + 0x0600,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= 24 + OMAP_INTC_START,
-		.flags		= IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device omap3isp_device = {
-	.name		= "omap3isp",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(omap3isp_resources),
-	.resource	= omap3isp_resources,
-};
-
-static struct omap_iommu_arch_data omap3_isp_iommu = {
-	.name = "mmu_isp",
-};
-
-int omap3_init_camera(struct isp_platform_data *pdata)
-{
-	if (of_have_populated_dt())
-		omap3_isp_iommu.name = "480bd400.mmu";
-
-	omap3isp_device.dev.platform_data = pdata;
-	omap3isp_device.dev.archdata.iommu = &omap3_isp_iommu;
-
-	return platform_device_register(&omap3isp_device);
-}
-
-#else /* !CONFIG_IOMMU_API */
-
-int omap3_init_camera(struct isp_platform_data *pdata)
-{
-	return 0;
-}
-
-#endif
-
 #if defined(CONFIG_OMAP2PLUS_MBOX) || defined(CONFIG_OMAP2PLUS_MBOX_MODULE)
 static inline void __init omap_init_mbox(void)
 {
diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
deleted file mode 100644
index f61eb6e5d136..000000000000
--- a/arch/arm/mach-omap2/devices.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * arch/arm/mach-omap2/devices.h
- *
- * OMAP2 platform device setup/initialization
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ARCH_ARM_MACH_OMAP_DEVICES_H
-#define __ARCH_ARM_MACH_OMAP_DEVICES_H
-
-struct isp_platform_data;
-
-int omap3_init_camera(struct isp_platform_data *pdata);
-
-#endif
-- 
2.3.6

