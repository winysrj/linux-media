Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:52222 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1AQOPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 09:15:42 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v15 3/3] davinci vpbe: changes to common files
Date: Mon, 17 Jan 2011 19:45:13 +0530
Message-Id: <1295273713-15289-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Implemented a common and single mapping for DAVINCI_SYSTEM_MODULE_BASE
to be used by all davinci platforms.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 arch/arm/mach-davinci/common.c                |    4 +++-
 arch/arm/mach-davinci/devices.c               |   10 ++++------
 arch/arm/mach-davinci/include/mach/hardware.h |    5 +++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/common.c b/arch/arm/mach-davinci/common.c
index 1d25573..fa7152d 100644
--- a/arch/arm/mach-davinci/common.c
+++ b/arch/arm/mach-davinci/common.c
@@ -111,7 +111,9 @@ void __init davinci_common_init(struct davinci_soc_info *soc_info)
 		if (ret != 0)
 			goto err;
 	}
-
+	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
+	if (!davinci_sysmodbase)
+		return;
 	return;
 
 err:
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 22ebc64..2bff2d6 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -33,6 +33,8 @@
 #define DM365_MMCSD0_BASE	     0x01D11000
 #define DM365_MMCSD1_BASE	     0x01D00000
 
+void __iomem  *davinci_sysmodbase;
+
 static struct resource i2c_resources[] = {
 	{
 		.start		= DAVINCI_I2C_BASE,
@@ -209,9 +211,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 			davinci_cfg_reg(DM355_SD1_DATA2);
 			davinci_cfg_reg(DM355_SD1_DATA3);
 		} else if (cpu_is_davinci_dm365()) {
-			void __iomem *pupdctl1 =
-				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE + 0x7c);
-
+			void __iomem *pupdctl1 = DAVINCI_SYSMODULE_VIRT(0x7c);
 			/* Configure pull down control */
 			__raw_writel((__raw_readl(pupdctl1) & ~0xfc0),
 					pupdctl1);
@@ -243,9 +243,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 			mmcsd0_resources[2].start = IRQ_DM365_SDIOINT0;
 		} else if (cpu_is_davinci_dm644x()) {
 			/* REVISIT: should this be in board-init code? */
-			void __iomem *base =
-				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
-
+			void __iomem *base = DAVINCI_SYSMODULE_VIRT(0);
 			/* Power-on 3.3V IO cells */
 			__raw_writel(0, base + DM64XX_VDD3P3V_PWDN);
 			/*Set up the pull regiter for MMC */
diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
index c45ba1f..5a105c4 100644
--- a/arch/arm/mach-davinci/include/mach/hardware.h
+++ b/arch/arm/mach-davinci/include/mach/hardware.h
@@ -24,6 +24,11 @@
 /* System control register offsets */
 #define DM64XX_VDD3P3V_PWDN	0x48
 
+#ifndef __ASSEMBLER__
+	extern void __iomem  *davinci_sysmodbase;
+	#define DAVINCI_SYSMODULE_VIRT(x)       (davinci_sysmodbase+(x))
+#endif
+
 /*
  * I/O mapping
  */
-- 
1.6.2.4

