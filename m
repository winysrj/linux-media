Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29803 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3FNRtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 13:49:12 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 5/5] ARM: Samsung: Remove MIPI PHY setup code
Date: Fri, 14 Jun 2013 19:45:51 +0200
Message-id: <1371231951-1969-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Generic PHY drivers are used to handle the MIPI CSIS and MIPI DSIM
DPHYs so we can remove now unused code at arch/arm/plat-samsung.
In case there is any board file for S5PV210 platforms using MIPI
CSIS/DSIM (not any upstream currently) it should use the generic
PHY API to bind the PHYs to respective PHY consumer drivers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/include/mach/regs-pmu.h    |    5 --
 arch/arm/mach-s5pv210/include/mach/regs-clock.h |    4 --
 arch/arm/plat-samsung/Makefile                  |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c           |   60 -----------------------
 4 files changed, 70 deletions(-)
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c

diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h b/arch/arm/mach-exynos/include/mach/regs-pmu.h
index cf40b86..3820e39 100644
--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -44,11 +44,6 @@
 #define S5P_DAC_PHY_CONTROL			S5P_PMUREG(0x070C)
 #define S5P_DAC_PHY_ENABLE			(1 << 0)
 
-#define S5P_MIPI_DPHY_CONTROL(n)		S5P_PMUREG(0x0710 + (n) * 4)
-#define S5P_MIPI_DPHY_ENABLE			(1 << 0)
-#define S5P_MIPI_DPHY_SRESETN			(1 << 1)
-#define S5P_MIPI_DPHY_MRESETN			(1 << 2)
-
 #define S5P_INFORM0				S5P_PMUREG(0x0800)
 #define S5P_INFORM1				S5P_PMUREG(0x0804)
 #define S5P_INFORM2				S5P_PMUREG(0x0808)
diff --git a/arch/arm/mach-s5pv210/include/mach/regs-clock.h b/arch/arm/mach-s5pv210/include/mach/regs-clock.h
index 032de66..e345584 100644
--- a/arch/arm/mach-s5pv210/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv210/include/mach/regs-clock.h
@@ -147,10 +147,6 @@
 #define S5P_HDMI_PHY_CONTROL	S5P_CLKREG(0xE804)
 #define S5P_USB_PHY_CONTROL	S5P_CLKREG(0xE80C)
 #define S5P_DAC_PHY_CONTROL	S5P_CLKREG(0xE810)
-#define S5P_MIPI_DPHY_CONTROL(x) S5P_CLKREG(0xE814)
-#define S5P_MIPI_DPHY_ENABLE	(1 << 0)
-#define S5P_MIPI_DPHY_SRESETN	(1 << 1)
-#define S5P_MIPI_DPHY_MRESETN	(1 << 2)
 
 #define S5P_INFORM0		S5P_CLKREG(0xF000)
 #define S5P_INFORM1		S5P_CLKREG(0xF004)
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index a23c460..5a15fae 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -41,7 +41,6 @@ obj-$(CONFIG_S5P_DEV_UART)	+= s5p-dev-uart.o
 obj-$(CONFIG_SAMSUNG_DEV_BACKLIGHT)	+= dev-backlight.o
 
 obj-$(CONFIG_S3C_SETUP_CAMIF)	+= setup-camif.o
-obj-$(CONFIG_S5P_SETUP_MIPIPHY)	+= setup-mipiphy.o
 
 # DMA support
 
diff --git a/arch/arm/plat-samsung/setup-mipiphy.c b/arch/arm/plat-samsung/setup-mipiphy.c
deleted file mode 100644
index 66df315..0000000
--- a/arch/arm/plat-samsung/setup-mipiphy.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- *
- * S5P - Helper functions for MIPI-CSIS and MIPI-DSIM D-PHY control
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/export.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/io.h>
-#include <linux/spinlock.h>
-#include <mach/regs-clock.h>
-
-static int __s5p_mipi_phy_control(int id, bool on, u32 reset)
-{
-	static DEFINE_SPINLOCK(lock);
-	void __iomem *addr;
-	unsigned long flags;
-	u32 cfg;
-
-	id = max(0, id);
-	if (id > 1)
-		return -EINVAL;
-
-	addr = S5P_MIPI_DPHY_CONTROL(id);
-
-	spin_lock_irqsave(&lock, flags);
-
-	cfg = __raw_readl(addr);
-	cfg = on ? (cfg | reset) : (cfg & ~reset);
-	__raw_writel(cfg, addr);
-
-	if (on) {
-		cfg |= S5P_MIPI_DPHY_ENABLE;
-	} else if (!(cfg & (S5P_MIPI_DPHY_SRESETN |
-			    S5P_MIPI_DPHY_MRESETN) & ~reset)) {
-		cfg &= ~S5P_MIPI_DPHY_ENABLE;
-	}
-
-	__raw_writel(cfg, addr);
-	spin_unlock_irqrestore(&lock, flags);
-
-	return 0;
-}
-
-int s5p_csis_phy_enable(int id, bool on)
-{
-	return __s5p_mipi_phy_control(id, on, S5P_MIPI_DPHY_SRESETN);
-}
-EXPORT_SYMBOL(s5p_csis_phy_enable);
-
-int s5p_dsim_phy_enable(struct platform_device *pdev, bool on)
-{
-	return __s5p_mipi_phy_control(pdev->id, on, S5P_MIPI_DPHY_MRESETN);
-}
-EXPORT_SYMBOL(s5p_dsim_phy_enable);
-- 
1.7.9.5

