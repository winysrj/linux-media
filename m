Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:41160 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab1DBJnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 05:43:09 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v18 07/13] davinci: move DM64XX_VDD3P3V_PWDN to devices.c
Date: Sat,  2 Apr 2011 15:13:00 +0530
Message-Id: <1301737380-4288-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Move the definition of DM64XX_VDD3P3V_PWDN from hardware.h
to devices.c since it is used only there.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/devices.c               |    1 +
 arch/arm/mach-davinci/include/mach/hardware.h |    3 ---
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 22ebc64..4e1b663 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -182,6 +182,7 @@ static struct platform_device davinci_mmcsd1_device = {
 	.resource = mmcsd1_resources,
 };
 
+#define DM64XX_VDD3P3V_PWDN	0x48
 
 void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
 {
diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
index c45ba1f..414e0b9 100644
--- a/arch/arm/mach-davinci/include/mach/hardware.h
+++ b/arch/arm/mach-davinci/include/mach/hardware.h
@@ -21,9 +21,6 @@
  */
 #define DAVINCI_SYSTEM_MODULE_BASE        0x01C40000
 
-/* System control register offsets */
-#define DM64XX_VDD3P3V_PWDN	0x48
-
 /*
  * I/O mapping
  */
-- 
1.6.2.4

