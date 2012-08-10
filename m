Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:51185 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab2HJKQm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 06:16:42 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: [PATCHv2 2/2] ARM: mach-omap2: board-rx51-peripherals: Add lirc-rx51 data
Date: Fri, 10 Aug 2012 13:16:37 +0300
Message-Id: <1344593797-15819-3-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1344593797-15819-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1344593797-15819-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IR diode on the RX51 is connected to the GPT9. This data is needed
for the IR driver to function.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   30 ++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index df2534d..ca07264 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -34,6 +34,7 @@
 #include <plat/gpmc.h>
 #include <plat/onenand.h>
 #include <plat/gpmc-smc91x.h>
+#include <plat/omap-pm.h>
 
 #include <mach/board-rx51.h>
 
@@ -46,6 +47,10 @@
 #include <../drivers/staging/iio/light/tsl2563.h>
 #include <linux/lis3lv02d.h>
 
+#if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
+#include <media/ir-rx51.h>
+#endif
+
 #include "mux.h"
 #include "hsmmc.h"
 #include "common-board-devices.h"
@@ -1220,6 +1225,30 @@ static void __init rx51_init_tsc2005(void)
 				gpio_to_irq(RX51_TSC2005_IRQ_GPIO);
 }
 
+#if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
+static struct lirc_rx51_platform_data rx51_lirc_data = {
+	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
+	.pwm_timer = 9, /* Use GPT 9 for CIR */
+};
+
+static struct platform_device rx51_lirc_device = {
+	.name           = "lirc_rx51",
+	.id             = -1,
+	.dev            = {
+		.platform_data = &rx51_lirc_data,
+	},
+};
+
+static void __init rx51_init_lirc(void)
+{
+	platform_device_register(&rx51_lirc_device);
+}
+#else
+static void __init rx51_init_lirc(void)
+{
+}
+#endif
+
 void __init rx51_peripherals_init(void)
 {
 	rx51_i2c_init();
@@ -1230,6 +1259,7 @@ void __init rx51_peripherals_init(void)
 	rx51_init_wl1251();
 	rx51_init_tsc2005();
 	rx51_init_si4713();
+	rx51_init_lirc();
 	spi_register_board_info(rx51_peripherals_spi_board_info,
 				ARRAY_SIZE(rx51_peripherals_spi_board_info));
 
-- 
1.7.8.6

