Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37452 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2JAWqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 18:46:55 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so4134460qch.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 15:46:54 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 4/5] arm: omap: Move iommu/iovmm headers to platform_data
Date: Mon,  1 Oct 2012 18:46:30 -0400
Message-Id: <1349131591-10804-4-git-send-email-ido@wizery.com>
In-Reply-To: <1349131591-10804-1-git-send-email-ido@wizery.com>
References: <20120927195526.GP4840@atomide.com>
 <1349131591-10804-1-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move iommu/iovmm headers from plat/ to platform_data/ as part of the
single zImage work.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/arm/mach-omap2/devices.c                                       | 2 +-
 arch/arm/mach-omap2/iommu2.c                                        | 2 +-
 arch/arm/mach-omap2/omap-iommu.c                                    | 2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c                          | 2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c                          | 2 +-
 drivers/iommu/omap-iommu-debug.c                                    | 4 ++--
 drivers/iommu/omap-iommu.c                                          | 2 +-
 drivers/iommu/omap-iovmm.c                                          | 4 ++--
 drivers/media/platform/omap3isp/isp.h                               | 5 +++--
 drivers/media/platform/omap3isp/ispvideo.c                          | 6 ++++--
 .../plat/iommu.h => include/linux/platform_data/iommu-omap.h        | 0
 .../plat/iovmm.h => include/linux/platform_data/iovmm-omap.h        | 0
 12 files changed, 17 insertions(+), 14 deletions(-)
 rename arch/arm/plat-omap/include/plat/iommu.h => include/linux/platform_data/iommu-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/iovmm.h => include/linux/platform_data/iovmm-omap.h (100%)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c8c2117..6cd0c2a 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -126,7 +126,7 @@ static struct platform_device omap2cam_device = {
 
 #if defined(CONFIG_IOMMU_API)
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 static struct resource omap3isp_resources[] = {
 	{
diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
index c986880..82f9174 100644
--- a/arch/arm/mach-omap2/iommu2.c
+++ b/arch/arm/mach-omap2/iommu2.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/stringify.h>
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 /*
  * omap2 architecture specific register bit definitions
diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index df298d4..a6a4ff8 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 #include "soc.h"
 #include "common.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 2857772..35ebf14 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -26,8 +26,8 @@
 #include <plat/mmc.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/platform_data/iommu-omap.h>
 #include <plat/dmtimer.h>
-#include <plat/iommu.h>
 
 #include "am35xx.h"
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 652d028..5850b3e 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -27,10 +27,10 @@
 #include <plat/dma.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
+#include <linux/platform_data/iommu-omap.h>
 #include <plat/mmc.h>
 #include <plat/dmtimer.h>
 #include <plat/common.h>
-#include <plat/iommu.h>
 
 #include "omap_hwmod_common_data.h"
 #include "cm1_44xx.h"
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index a0b0309..8c1e30b 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -19,8 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/debugfs.h>
 
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
+#include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/iovmm-omap.h>
 
 #include <plat/iopgtable.h>
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 80844b3..6100334 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -24,7 +24,7 @@
 
 #include <asm/cacheflush.h>
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 #include <plat/iopgtable.h>
 
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index b362fb5..b5ac2cd 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -21,8 +21,8 @@
 #include <asm/cacheflush.h>
 #include <asm/mach/map.h>
 
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
+#include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/iovmm-omap.h>
 
 #include <plat/iopgtable.h>
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 8be7487..62c76f9 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -34,8 +34,9 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 #include <linux/iommu.h>
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
+
+#include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/iovmm-omap.h>
 
 #include "ispstat.h"
 #include "ispccdc.h"
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3a5085e..1093f07 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -34,8 +34,10 @@
 #include <linux/vmalloc.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
+
+#include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/iovmm-omap.h>
+
 #include <plat/omap-pm.h>
 
 #include "ispvideo.h"
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/include/linux/platform_data/iommu-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/iommu.h
rename to include/linux/platform_data/iommu-omap.h
diff --git a/arch/arm/plat-omap/include/plat/iovmm.h b/include/linux/platform_data/iovmm-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/iovmm.h
rename to include/linux/platform_data/iovmm-omap.h
-- 
1.7.11.4

