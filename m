Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:47740 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab1CON6t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 09:58:49 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v17 07/13] davinci: move DM64XX_VDD3P3V_PWDN to devices.c
Date: Tue, 15 Mar 2011 19:28:30 +0530
Message-Id: <1300197510-4467-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Move the definition of DM64XX_VDD3P3V_PWDN from hardware.h
to devices.c since it is used only there.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/devices.c               |    1 +
 arch/arm/mach-davinci/include/mach/hardware.h |    3 ---
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 22ebc64..d3b2040 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -182,6 +182,7 @@ static struct platform_device davinci_mmcsd1_device = {
 	.resource = mmcsd1_resources,
 };
 
+#define DM64XX_VDD3P3V_PWDN     0x48
 
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

