Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42357 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab1DBJoO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 05:44:14 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v18 08/13] davinci: eliminate use of IO_ADDRESS() on sysmod
Date: Sat,  2 Apr 2011 15:13:17 +0530
Message-Id: <1301737397-4327-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Current devices.c file has a number of instances where
IO_ADDRESS() is used for system module register
access. Eliminate this in favor of a ioremap()
based access.

Consequent to this, a new global pointer davinci_sysmodbase
has been introduced which gets initialized during
the initialization of each relevant SoC

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/devices.c               |   24 +++++++++++++++---------
 arch/arm/mach-davinci/dm355.c                 |    1 +
 arch/arm/mach-davinci/dm365.c                 |    1 +
 arch/arm/mach-davinci/dm644x.c                |    1 +
 arch/arm/mach-davinci/dm646x.c                |    1 +
 arch/arm/mach-davinci/include/mach/hardware.h |    6 ++++++
 6 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 4e1b663..529b440 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -33,6 +33,14 @@
 #define DM365_MMCSD0_BASE	     0x01D11000
 #define DM365_MMCSD1_BASE	     0x01D00000
 
+void __iomem  *davinci_sysmodbase;
+
+void davinci_map_sysmod(void)
+{
+	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
+	WARN_ON(!davinci_sysmodbase);
+}
+
 static struct resource i2c_resources[] = {
 	{
 		.start		= DAVINCI_I2C_BASE,
@@ -210,12 +218,12 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 			davinci_cfg_reg(DM355_SD1_DATA2);
 			davinci_cfg_reg(DM355_SD1_DATA3);
 		} else if (cpu_is_davinci_dm365()) {
-			void __iomem *pupdctl1 =
-				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE + 0x7c);
-
 			/* Configure pull down control */
-			__raw_writel((__raw_readl(pupdctl1) & ~0xfc0),
-					pupdctl1);
+			void __iomem *pupdctl1 = DAVINCI_SYSMODULE_VIRT(0x7c);
+			unsigned v;
+
+			v = __raw_readl(pupdctl1);
+			__raw_writel(v & ~0xfc0, pupdctl1);
 
 			mmcsd1_resources[0].start = DM365_MMCSD1_BASE;
 			mmcsd1_resources[0].end = DM365_MMCSD1_BASE +
@@ -244,11 +252,9 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 			mmcsd0_resources[2].start = IRQ_DM365_SDIOINT0;
 		} else if (cpu_is_davinci_dm644x()) {
 			/* REVISIT: should this be in board-init code? */
-			void __iomem *base =
-				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
-
 			/* Power-on 3.3V IO cells */
-			__raw_writel(0, base + DM64XX_VDD3P3V_PWDN);
+			__raw_writel(0,
+				DAVINCI_SYSMODULE_VIRT(DM64XX_VDD3P3V_PWDN));
 			/*Set up the pull regiter for MMC */
 			davinci_cfg_reg(DM644X_MSTK);
 		}
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index a5f8a80..1baab94 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -874,6 +874,7 @@ void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata)
 void __init dm355_init(void)
 {
 	davinci_common_init(&davinci_soc_info_dm355);
+	davinci_map_sysmod();
 }
 
 static int __init dm355_init_devices(void)
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 02d2cc3..a788980 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -1127,6 +1127,7 @@ void __init dm365_init_rtc(void)
 void __init dm365_init(void)
 {
 	davinci_common_init(&davinci_soc_info_dm365);
+	davinci_map_sysmod();
 }
 
 static struct resource dm365_vpss_resources[] = {
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 9a2376b..77dea11 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -779,6 +779,7 @@ void __init dm644x_init_asp(struct snd_platform_data *pdata)
 void __init dm644x_init(void)
 {
 	davinci_common_init(&davinci_soc_info_dm644x);
+	davinci_map_sysmod();
 }
 
 static int __init dm644x_init_devices(void)
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 1e0f809..ce93b83 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -903,6 +903,7 @@ void __init dm646x_init(void)
 {
 	dm646x_board_setup_refclk(&ref_clk);
 	davinci_common_init(&davinci_soc_info_dm646x);
+	davinci_map_sysmod();
 }
 
 static int __init dm646x_init_devices(void)
diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
index 414e0b9..2a6b560 100644
--- a/arch/arm/mach-davinci/include/mach/hardware.h
+++ b/arch/arm/mach-davinci/include/mach/hardware.h
@@ -21,6 +21,12 @@
  */
 #define DAVINCI_SYSTEM_MODULE_BASE        0x01C40000
 
+#ifndef __ASSEMBLER__
+extern void __iomem *davinci_sysmodbase;
+#define DAVINCI_SYSMODULE_VIRT(x)	(davinci_sysmodbase + (x))
+void davinci_map_sysmod(void);
+#endif
+
 /*
  * I/O mapping
  */
-- 
1.6.2.4

