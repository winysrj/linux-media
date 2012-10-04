Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11443 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752651Ab2JDWFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 18:05:22 -0400
Subject: [PATCH 16/16] ARM: OMAP: Make plat/omap-pm.h local to mach-omap2
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 04 Oct 2012 15:05:10 -0700
Message-ID: <20121004220510.26676.36302.stgit@muffinssi.local>
In-Reply-To: <20121004213950.26676.21898.stgit@muffinssi.local>
References: <20121004213950.26676.21898.stgit@muffinssi.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We must move this for ARM common zImage support.

Note that neither drivers/media/rc/ir-rx51.c or
drivers/media/platform/omap3isp/ispvideo.c need
to include omap-pm.h, so this patch removes the
include for those files.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/pm_bus.c                 |    2 --
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/mach-omap2/display.c                |    2 +-
 arch/arm/mach-omap2/dsp.c                    |    2 +-
 arch/arm/mach-omap2/gpio.c                   |    2 +-
 arch/arm/mach-omap2/hsmmc.c                  |    2 +-
 arch/arm/mach-omap2/i2c.c                    |    2 +-
 arch/arm/mach-omap2/io.c                     |    2 +-
 arch/arm/mach-omap2/omap-pm.h                |    0 
 arch/arm/mach-omap2/pm-debug.c               |    2 +-
 arch/arm/mach-omap2/pm.c                     |    2 +-
 arch/arm/mach-omap2/serial.c                 |    2 +-
 arch/arm/mach-omap2/timer.c                  |    2 +-
 arch/arm/plat-omap/dmtimer.c                 |    3 ++-
 arch/arm/plat-omap/omap-pm-noop.c            |    4 +---
 drivers/media/platform/omap3isp/ispvideo.c   |    1 -
 drivers/media/rc/ir-rx51.c                   |    1 -
 17 files changed, 14 insertions(+), 19 deletions(-)
 rename arch/arm/{plat-omap/include/plat/omap-pm.h => mach-omap2/omap-pm.h} (100%)

diff --git a/arch/arm/mach-omap1/pm_bus.c b/arch/arm/mach-omap1/pm_bus.c
index 8a74ec5..16bf2f9 100644
--- a/arch/arm/mach-omap1/pm_bus.c
+++ b/arch/arm/mach-omap1/pm_bus.c
@@ -19,8 +19,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 
-#include <plat/omap-pm.h>
-
 #ifdef CONFIG_PM_RUNTIME
 static int omap1_pm_runtime_suspend(struct device *dev)
 {
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index ed85fb8..0199b24 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -33,7 +33,7 @@
 #include "common.h"
 #include <plat/dma.h>
 #include <plat/gpmc.h>
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 #include "gpmc-smc91x.h"
 
 #include "board-rx51.h"
diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 261f79f..bfa3e4c 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -27,7 +27,7 @@
 #include <video/omapdss.h>
 #include "omap_hwmod.h"
 #include "omap_device.h"
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 #include "common.h"
 
 #include "iomap.h"
diff --git a/arch/arm/mach-omap2/dsp.c b/arch/arm/mach-omap2/dsp.c
index 9838810..b155500 100644
--- a/arch/arm/mach-omap2/dsp.c
+++ b/arch/arm/mach-omap2/dsp.c
@@ -27,7 +27,7 @@
 #include "cm2xxx_3xxx.h"
 #include "prm2xxx_3xxx.h"
 #ifdef CONFIG_BRIDGE_DVFS
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 #endif
 
 #include <linux/platform_data/dsp-omap.h>
diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index 80b1e1a..399acab 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -25,7 +25,7 @@
 
 #include "omap_hwmod.h"
 #include "omap_device.h"
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 
 #include "powerdomain.h"
 
diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index b0b11be..1d5957e 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -18,7 +18,7 @@
 #include <linux/platform_data/gpio-omap.h>
 
 #include "mmc.h"
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 #include "omap_device.h"
 
 #include "mux.h"
diff --git a/arch/arm/mach-omap2/i2c.c b/arch/arm/mach-omap2/i2c.c
index 5904a7a..af4e0de 100644
--- a/arch/arm/mach-omap2/i2c.c
+++ b/arch/arm/mach-omap2/i2c.c
@@ -24,7 +24,7 @@
 #include "common.h"
 #include "omap_hwmod.h"
 #include "omap_device.h"
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 
 #include "mux.h"
 #include "i2c.h"
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 1e0ba6f..fe807d1 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -26,7 +26,7 @@
 #include <asm/mach/map.h>
 
 #include <plat/sdrc.h>
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 #include "omap_hwmod.h"
 #include <plat/dma.h>
 
diff --git a/arch/arm/plat-omap/include/plat/omap-pm.h b/arch/arm/mach-omap2/omap-pm.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/omap-pm.h
rename to arch/arm/mach-omap2/omap-pm.h
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index 3e1345f..d6d575f 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -31,7 +31,7 @@
 #include "powerdomain.h"
 #include "clockdomain.h"
 #include <plat/dmtimer.h>
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 
 #include "cm2xxx_3xxx.h"
 #include "prm2xxx_3xxx.h"
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index bb01ac6..29c82ad 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -19,7 +19,7 @@
 
 #include <asm/system_misc.h>
 
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 #include "omap_device.h"
 #include "common.h"
 
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index 60374a4..6084e02f 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -33,7 +33,7 @@
 #include <plat/dma.h>
 #include "omap_hwmod.h"
 #include "omap_device.h"
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 
 #include "prm2xxx_3xxx.h"
 #include "pm.h"
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index b888051..17b069f 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -46,7 +46,7 @@
 #include "omap_hwmod.h"
 #include "omap_device.h"
 #include <plat/dmtimer.h>
-#include <plat/omap-pm.h>
+#include "omap-pm.h"
 
 #include "soc.h"
 #include "common.h"
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 938b50a..4a0b30a 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -42,10 +42,11 @@
 #include <linux/pm_runtime.h>
 
 #include <plat/dmtimer.h>
-#include <plat/omap-pm.h>
 
 #include <mach/hardware.h>
 
+#include "../mach-omap2/omap-pm.h"
+
 static u32 omap_reserved_systimers;
 static LIST_HEAD(omap_timer_list);
 static DEFINE_SPINLOCK(dm_timer_lock);
diff --git a/arch/arm/plat-omap/omap-pm-noop.c b/arch/arm/plat-omap/omap-pm-noop.c
index c498dd2..114c1f8 100644
--- a/arch/arm/plat-omap/omap-pm-noop.c
+++ b/arch/arm/plat-omap/omap-pm-noop.c
@@ -22,10 +22,8 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 
-/* Interface documentation is in mach/omap-pm.h */
-#include <plat/omap-pm.h>
-
 #include "../mach-omap2/omap_device.h"
+#include "../mach-omap2/omap-pm.h"
 
 static bool off_mode_enabled;
 static int dummy_context_loss_counter;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3a5085e..4039674 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -36,7 +36,6 @@
 #include <media/v4l2-ioctl.h>
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
-#include <plat/omap-pm.h>
 
 #include "ispvideo.h"
 #include "isp.h"
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 546199e..82e6c1e 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -28,7 +28,6 @@
 
 #include <plat/dmtimer.h>
 #include <plat/clock.h>
-#include <plat/omap-pm.h>
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>

