Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50388 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZFISv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 14:51:26 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n59IpNRt018778
	for <linux-media@vger.kernel.org>; Tue, 9 Jun 2009 13:51:28 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 10/10 - v2] common vpss module for video drivers
Date: Tue,  9 Jun 2009 14:51:21 -0400
Message-Id: <1244573481-20691-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

This is a new module added for vpss library functions that are
used configuring vpss system module. All video drivers will
include vpss.h header and call functions defined in this module
to configure vpss system module.
 
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/vpss.c |  291 ++++++++++++++++++++++++++++++++++++
 include/media/davinci/vpss.h       |   69 +++++++++
 2 files changed, 360 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpss.c
 create mode 100644 include/media/davinci/vpss.h

diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
new file mode 100644
index 0000000..9480256
--- /dev/null
+++ b/drivers/media/video/davinci/vpss.c
@@ -0,0 +1,291 @@
+/*
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * common vpss driver for all video drivers.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/compiler.h>
+#include <linux/io.h>
+#include <mach/cpu.h>
+#include <mach/hardware.h>
+#include <media/davinci/vpss.h>
+
+/* DM644x defines */
+#define DM644X_SBL_PCR_VPSS		(4)
+
+/* vpss BL register offsets */
+#define DM355_VPSSBL_CCDCMUX		0x1c
+/* vpss CLK register offsets */
+#define DM355_VPSSCLK_CLKCTRL		0x04
+/* masks and shifts */
+#define VPSS_HSSISEL_SHIFT		4
+
+/*
+ * vpss operations. Depends on platform. Not all functions are available
+ * on all platforms. The api, first check if a functio is available before
+ * invoking it. In the probe, the function ptrs are intialized based on
+ * vpss name. vpss name can be "dm355_vpss", "dm644x_vpss" etc.
+ */
+struct vpss_hw_ops {
+	/* enable clock */
+	int (*enable_clock)(enum vpss_clock_sel clock_sel, int en);
+	/* select input to ccdc */
+	void (*select_ccdc_source)(enum vpss_ccdc_source_sel src_sel);
+	/* clear wbl overlflow bit */
+	int (*clear_wbl_overflow)(enum vpss_wbl_sel wbl_sel);
+};
+
+/* vpss configuration */
+struct vpss_oper_config {
+	__iomem void *vpss_bl_regs_base;
+	__iomem void *vpss_regs_base;
+	struct resource		*r1;
+	resource_size_t		len1;
+	struct resource		*r2;
+	resource_size_t		len2;
+	char vpss_name[32];
+	spinlock_t vpss_lock;
+	struct vpss_hw_ops hw_ops;
+};
+
+static struct vpss_oper_config oper_cfg;
+
+/* register access routines */
+static inline u32 bl_regr(u32 offset)
+{
+	return __raw_readl(oper_cfg.vpss_bl_regs_base + offset);
+}
+
+static inline void bl_regw(u32 val, u32 offset)
+{
+	__raw_writel(val, oper_cfg.vpss_bl_regs_base + offset);
+}
+
+static inline u32 vpss_regr(u32 offset)
+{
+	return __raw_readl(oper_cfg.vpss_regs_base + offset);
+}
+
+static inline void vpss_regw(u32 val, u32 offset)
+{
+	__raw_writel(val, oper_cfg.vpss_regs_base + offset);
+}
+
+static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
+{
+	bl_regw(src_sel << VPSS_HSSISEL_SHIFT, DM355_VPSSBL_CCDCMUX);
+}
+
+int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
+{
+	if (!oper_cfg.hw_ops.select_ccdc_source)
+		return -1;
+
+	dm355_select_ccdc_source(src_sel);
+	return 0;
+}
+EXPORT_SYMBOL(vpss_select_ccdc_source);
+
+static int dm644x_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
+{
+	u32 mask = 1, val;
+
+	if (wbl_sel < VPSS_PCR_AEW_WBL_0 ||
+	    wbl_sel > VPSS_PCR_CCDC_WBL_O)
+		return -1;
+
+	/* writing a 0 clear the overflow */
+	mask = ~(mask << wbl_sel);
+	val = bl_regr(DM644X_SBL_PCR_VPSS) & mask;
+	bl_regw(val, DM644X_SBL_PCR_VPSS);
+	return 0;
+}
+
+int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
+{
+	if (!oper_cfg.hw_ops.clear_wbl_overflow)
+		return -1;
+
+	return oper_cfg.hw_ops.clear_wbl_overflow(wbl_sel);
+}
+EXPORT_SYMBOL(vpss_clear_wbl_overflow);
+
+/*
+ *  dm355_enable_clock - Enable VPSS Clock
+ *  @clock_sel: CLock to be enabled/disabled
+ *  @en: enable/disable flag
+ *
+ *  This is called to enable or disable a vpss clock
+ */
+static int dm355_enable_clock(enum vpss_clock_sel clock_sel, int en)
+{
+	unsigned long flags;
+	u32 utemp, mask = 0x1, shift = 0;
+
+	switch (clock_sel) {
+	case VPSS_VPBE_CLOCK:
+		/* nothing since lsb */
+		break;
+	case VPSS_VENC_CLOCK_SEL:
+		shift = 2;
+		break;
+	case VPSS_CFALD_CLOCK:
+		shift = 3;
+		break;
+	case VPSS_H3A_CLOCK:
+		shift = 4;
+		break;
+	case VPSS_IPIPE_CLOCK:
+		shift = 5;
+		break;
+	case VPSS_CCDC_CLOCK:
+		shift = 6;
+		break;
+	default:
+		printk(KERN_ERR "dm355_enable_clock:"
+				" Invalid selector: %d\n", clock_sel);
+		return -1;
+	}
+
+	spin_lock_irqsave(&oper_cfg.vpss_lock, flags);
+	utemp = vpss_regr(DM355_VPSSCLK_CLKCTRL);
+	if (!en)
+		utemp &= ~(mask << shift);
+	else
+		utemp |= (mask << shift);
+
+	vpss_regw(utemp, DM355_VPSSCLK_CLKCTRL);
+	spin_unlock_irqrestore(&oper_cfg.vpss_lock, flags);
+	return 0;
+}
+
+int vpss_enable_clock(enum vpss_clock_sel clock_sel, int en)
+{
+	if (!oper_cfg.hw_ops.enable_clock)
+		return -1;
+
+	return oper_cfg.hw_ops.enable_clock(clock_sel, en);
+}
+EXPORT_SYMBOL(vpss_enable_clock);
+
+static int __init vpss_probe(struct platform_device *pdev)
+{
+	int			status;
+
+	if (!pdev->dev.platform_data) {
+		dev_err(&pdev->dev, "vpss, no platform data\n");
+		return -ENOENT;
+	}
+
+	strcpy(oper_cfg.vpss_name, pdev->dev.platform_data);
+	dev_info(&pdev->dev, "%s vpss probed\n", oper_cfg.vpss_name);
+	oper_cfg.r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!oper_cfg.r1)
+		return -ENOENT;
+
+	oper_cfg.len1 = oper_cfg.r1->end - oper_cfg.r1->start + 1;
+
+	oper_cfg.r1 = request_mem_region(oper_cfg.r1->start, oper_cfg.len1,
+					 oper_cfg.r1->name);
+	if (!oper_cfg.r1)
+		return -EBUSY;
+
+	oper_cfg.vpss_bl_regs_base = ioremap(oper_cfg.r1->start, oper_cfg.len1);
+	if (!oper_cfg.vpss_bl_regs_base) {
+		status = -EBUSY;
+		goto fail1;
+	}
+
+	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
+		oper_cfg.r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!oper_cfg.r2) {
+			status = -ENOENT;
+			goto fail2;
+		}
+		oper_cfg.len2 = oper_cfg.r2->end - oper_cfg.r2->start + 1;
+		oper_cfg.r2 = request_mem_region(oper_cfg.r2->start,
+						 oper_cfg.len2,
+						 oper_cfg.r2->name);
+		if (!oper_cfg.r2) {
+			status = -EBUSY;
+			goto fail2;
+		}
+
+		oper_cfg.vpss_regs_base = ioremap(oper_cfg.r2->start,
+						  oper_cfg.len2);
+		if (!oper_cfg.vpss_regs_base) {
+			status = -EBUSY;
+			goto fail3;
+		}
+	}
+
+	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
+		oper_cfg.hw_ops.enable_clock = dm355_enable_clock;
+		oper_cfg.hw_ops.select_ccdc_source = dm355_select_ccdc_source;
+	} else if (!strcmp(oper_cfg.vpss_name, "dm644x_vpss"))
+		oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
+	else
+		return -ENODEV;
+	spin_lock_init(&oper_cfg.vpss_lock);
+	dev_info(&pdev->dev, "%s vpss probe success\n", oper_cfg.vpss_name);
+	return 0;
+fail3:
+	release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
+fail2:
+	iounmap(oper_cfg.vpss_bl_regs_base);
+fail1:
+	release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
+	return status;
+}
+
+static int vpss_remove(struct platform_device *pdev)
+{
+	iounmap(oper_cfg.vpss_bl_regs_base);
+	release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
+	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
+		iounmap(oper_cfg.vpss_regs_base);
+		release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
+	}
+	return 0;
+}
+
+static struct platform_driver vpss_driver = {
+	.driver = {
+		.name	= "vpss",
+		.owner = THIS_MODULE,
+	},
+	.remove = __devexit_p(vpss_remove),
+	.probe = vpss_probe,
+};
+
+static void vpss_exit(void)
+{
+	platform_driver_unregister(&vpss_driver);
+}
+
+static int __init vpss_init(void)
+{
+	return platform_driver_register(&vpss_driver);
+}
+subsys_initcall(vpss_init);
+module_exit(vpss_exit);
+MODULE_LICENSE("GPL");
diff --git a/include/media/davinci/vpss.h b/include/media/davinci/vpss.h
new file mode 100644
index 0000000..fcdff74
--- /dev/null
+++ b/include/media/davinci/vpss.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * vpss - video processing subsystem module header file.
+ *
+ * Include this header file if a driver needs to configure vpss system
+ * module. It exports a set of library functions  for video drivers to
+ * configure vpss system module functions such as clock enable/disable,
+ * vpss interrupt mux to arm, and other common vpss system module
+ * functions.
+ */
+#ifndef _VPSS_H
+#define _VPSS_H
+
+/* selector for ccdc input selection on DM355 */
+enum vpss_ccdc_source_sel {
+	VPSS_CCDCIN,
+	VPSS_HSSIIN
+};
+
+/* Used for enable/diable VPSS Clock */
+enum vpss_clock_sel {
+	/* DM355/DM365 */
+	VPSS_CCDC_CLOCK,
+	VPSS_IPIPE_CLOCK,
+	VPSS_H3A_CLOCK,
+	VPSS_CFALD_CLOCK,
+	/*
+	 * When using VPSS_VENC_CLOCK_SEL in vpss_enable_clock() api
+	 * following applies:-
+	 * en = 0 selects ENC_CLK
+	 * en = 1 selects ENC_CLK/2
+	 */
+	VPSS_VENC_CLOCK_SEL,
+	VPSS_VPBE_CLOCK,
+};
+
+/* select input to ccdc on dm355 */
+int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel);
+/* enable/disable a vpss clock, 0 - success, -1 - failure */
+int vpss_enable_clock(enum vpss_clock_sel clock_sel, int en);
+
+/* wbl reset for dm644x */
+enum vpss_wbl_sel {
+	VPSS_PCR_AEW_WBL_0 = 16,
+	VPSS_PCR_AF_WBL_0,
+	VPSS_PCR_RSZ4_WBL_0,
+	VPSS_PCR_RSZ3_WBL_0,
+	VPSS_PCR_RSZ2_WBL_0,
+	VPSS_PCR_RSZ1_WBL_0,
+	VPSS_PCR_PREV_WBL_0,
+	VPSS_PCR_CCDC_WBL_O,
+};
+int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel);
+#endif
-- 
1.6.0.4

