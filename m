Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:52347 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbcDZXv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 19:51:59 -0400
From: Tony Lindgren <tony@atomide.com>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machel <pavel@ucw.cz>,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	Neil Armstrong <narmstrong@baylibre.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 1/2] ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51
Date: Tue, 26 Apr 2016 16:51:48 -0700
Message-Id: <1461714709-10455-2-git-send-email-tony@atomide.com>
In-Reply-To: <1461714709-10455-1-git-send-email-tony@atomide.com>
References: <1461714709-10455-1-git-send-email-tony@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before we start removing omap3 legacy booting support, let's make n900
DT booting behave the same way for ir-rx51 as the legacy booting does.

For now, we need to pass pdata to the ir-rx51 driver. This means that
the n900 tree can move to using DT based booting without having to carry
all the legacy platform data with it when it gets dropped from the mainline
tree.

Note that the ir-rx51 driver is currently disabled because of the
dependency to !ARCH_MULTIPLATFORM. This will get sorted out later
with the help of drivers/pwm/pwm-omap-dmtimer.c. But first we need
to add chained IRQ support to dmtimer code to avoid introducing new
custom frameworks.

So let's just pass the necessary dmtimer functions to ir-rx51 so we
can get it working in the following patch.

Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c   | 35 ++++++++++++++++++++++++--
 arch/arm/mach-omap2/pdata-quirks.c             | 33 +++++++++++++++++++++++-
 include/linux/platform_data/media/ir-rx51.h    |  1 +
 include/linux/platform_data/pwm_omap_dmtimer.h | 21 ++++++++++++++++
 4 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index da174c0..4c35ffd 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -30,6 +30,8 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
 
+#include <plat/dmtimer.h>
+
 #include <asm/system_info.h>
 
 #include "common.h"
@@ -47,9 +49,8 @@
 
 #include <video/omap-panel-data.h>
 
-#if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
+#include <linux/platform_data/pwm_omap_dmtimer.h>
 #include <linux/platform_data/media/ir-rx51.h>
-#endif
 
 #include "mux.h"
 #include "omap-pm.h"
@@ -1212,10 +1213,40 @@ static void __init rx51_init_tsc2005(void)
 				gpio_to_irq(RX51_TSC2005_IRQ_GPIO);
 }
 
+#if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
+static struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
+	.request_by_node = omap_dm_timer_request_by_node,
+	.request_specific = omap_dm_timer_request_specific,
+	.request = omap_dm_timer_request,
+	.set_source = omap_dm_timer_set_source,
+	.get_irq = omap_dm_timer_get_irq,
+	.set_int_enable = omap_dm_timer_set_int_enable,
+	.set_int_disable = omap_dm_timer_set_int_disable,
+	.free = omap_dm_timer_free,
+	.enable = omap_dm_timer_enable,
+	.disable = omap_dm_timer_disable,
+	.get_fclk = omap_dm_timer_get_fclk,
+	.start = omap_dm_timer_start,
+	.stop = omap_dm_timer_stop,
+	.set_load = omap_dm_timer_set_load,
+	.set_match = omap_dm_timer_set_match,
+	.set_pwm = omap_dm_timer_set_pwm,
+	.set_prescaler = omap_dm_timer_set_prescaler,
+	.read_counter = omap_dm_timer_read_counter,
+	.write_counter = omap_dm_timer_write_counter,
+	.read_status = omap_dm_timer_read_status,
+	.write_status = omap_dm_timer_write_status,
+};
+#endif
+
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
 static struct lirc_rx51_platform_data rx51_lirc_data = {
 	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
 	.pwm_timer = 9, /* Use GPT 9 for CIR */
+#if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
+	.dmtimer = &pwm_dmtimer_pdata,
+#endif
+
 };
 
 static struct platform_device rx51_lirc_device = {
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index cfaf45f..b36f0bd 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -25,6 +25,7 @@
 #include <linux/platform_data/iommu-omap.h>
 #include <linux/platform_data/wkup_m3.h>
 #include <linux/platform_data/pwm_omap_dmtimer.h>
+#include <linux/platform_data/media/ir-rx51.h>
 #include <plat/dmtimer.h>
 
 #include "common.h"
@@ -32,6 +33,7 @@
 #include "dss-common.h"
 #include "control.h"
 #include "omap_device.h"
+#include "omap-pm.h"
 #include "omap-secure.h"
 #include "soc.h"
 #include "hsmmc.h"
@@ -271,6 +273,8 @@ static struct platform_device omap3_rom_rng_device = {
 	},
 };
 
+static struct platform_device rx51_lirc_device;
+
 static void __init nokia_n900_legacy_init(void)
 {
 	hsmmc2_internal_input_clk();
@@ -291,6 +295,8 @@ static void __init nokia_n900_legacy_init(void)
 		platform_device_register(&omap3_rom_rng_device);
 
 	}
+
+	platform_device_register(&rx51_lirc_device);
 }
 
 static void __init omap3_tao3530_legacy_init(void)
@@ -458,8 +464,14 @@ void omap_auxdata_legacy_init(struct device *dev)
 
 /* Dual mode timer PWM callbacks platdata */
 #if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
-struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
+static struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
 	.request_by_node = omap_dm_timer_request_by_node,
+	.request_specific = omap_dm_timer_request_specific,
+	.request = omap_dm_timer_request,
+	.set_source = omap_dm_timer_set_source,
+	.get_irq = omap_dm_timer_get_irq,
+	.set_int_enable = omap_dm_timer_set_int_enable,
+	.set_int_disable = omap_dm_timer_set_int_disable,
 	.free = omap_dm_timer_free,
 	.enable = omap_dm_timer_enable,
 	.disable = omap_dm_timer_disable,
@@ -470,10 +482,29 @@ struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
 	.set_match = omap_dm_timer_set_match,
 	.set_pwm = omap_dm_timer_set_pwm,
 	.set_prescaler = omap_dm_timer_set_prescaler,
+	.read_counter = omap_dm_timer_read_counter,
 	.write_counter = omap_dm_timer_write_counter,
+	.read_status = omap_dm_timer_read_status,
+	.write_status = omap_dm_timer_write_status,
 };
 #endif
 
+static struct lirc_rx51_platform_data __maybe_unused rx51_lirc_data = {
+	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
+	.pwm_timer = 9, /* Use GPT 9 for CIR */
+#if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
+	.dmtimer = &pwm_dmtimer_pdata,
+#endif
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
 /*
  * Few boards still need auxdata populated before we populate
  * the dev entries in of_platform_populate().
diff --git a/include/linux/platform_data/media/ir-rx51.h b/include/linux/platform_data/media/ir-rx51.h
index 104aa89..3038120 100644
--- a/include/linux/platform_data/media/ir-rx51.h
+++ b/include/linux/platform_data/media/ir-rx51.h
@@ -5,6 +5,7 @@ struct lirc_rx51_platform_data {
 	int pwm_timer;
 
 	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
+	struct pwm_omap_dmtimer_pdata *dmtimer;
 };
 
 #endif
diff --git a/include/linux/platform_data/pwm_omap_dmtimer.h b/include/linux/platform_data/pwm_omap_dmtimer.h
index 5938421..e7d521e 100644
--- a/include/linux/platform_data/pwm_omap_dmtimer.h
+++ b/include/linux/platform_data/pwm_omap_dmtimer.h
@@ -35,6 +35,16 @@
 #ifndef __PWM_OMAP_DMTIMER_PDATA_H
 #define __PWM_OMAP_DMTIMER_PDATA_H
 
+/* clock sources */
+#define PWM_OMAP_DMTIMER_SRC_SYS_CLK			0x00
+#define PWM_OMAP_DMTIMER_SRC_32_KHZ			0x01
+#define PWM_OMAP_DMTIMER_SRC_EXT_CLK			0x02
+
+/* timer interrupt enable bits */
+#define PWM_OMAP_DMTIMER_INT_CAPTURE			(1 << 2)
+#define PWM_OMAP_DMTIMER_INT_OVERFLOW			(1 << 1)
+#define PWM_OMAP_DMTIMER_INT_MATCH			(1 << 0)
+
 /* trigger types */
 #define PWM_OMAP_DMTIMER_TRIGGER_NONE			0x00
 #define PWM_OMAP_DMTIMER_TRIGGER_OVERFLOW		0x01
@@ -45,15 +55,23 @@ typedef struct omap_dm_timer pwm_omap_dmtimer;
 
 struct pwm_omap_dmtimer_pdata {
 	pwm_omap_dmtimer *(*request_by_node)(struct device_node *np);
+	pwm_omap_dmtimer *(*request_specific)(int timer_id);
+	pwm_omap_dmtimer *(*request)(void);
+
 	int	(*free)(pwm_omap_dmtimer *timer);
 
 	void	(*enable)(pwm_omap_dmtimer *timer);
 	void	(*disable)(pwm_omap_dmtimer *timer);
 
+	int	(*get_irq)(pwm_omap_dmtimer *timer);
+	int	(*set_int_enable)(pwm_omap_dmtimer *timer, unsigned int value);
+	int	(*set_int_disable)(pwm_omap_dmtimer *timer, u32 mask);
+
 	struct clk *(*get_fclk)(pwm_omap_dmtimer *timer);
 
 	int	(*start)(pwm_omap_dmtimer *timer);
 	int	(*stop)(pwm_omap_dmtimer *timer);
+	int	(*set_source)(pwm_omap_dmtimer *timer, int source);
 
 	int	(*set_load)(pwm_omap_dmtimer *timer, int autoreload,
 			unsigned int value);
@@ -63,7 +81,10 @@ struct pwm_omap_dmtimer_pdata {
 			int toggle, int trigger);
 	int	(*set_prescaler)(pwm_omap_dmtimer *timer, int prescaler);
 
+	unsigned int (*read_counter)(pwm_omap_dmtimer *timer);
 	int	(*write_counter)(pwm_omap_dmtimer *timer, unsigned int value);
+	unsigned int (*read_status)(pwm_omap_dmtimer *timer);
+	int	(*write_status)(pwm_omap_dmtimer *timer, unsigned int value);
 };
 
 #endif /* __PWM_OMAP_DMTIMER_PDATA_H */
-- 
2.8.1

