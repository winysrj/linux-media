Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42825 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab2KRPNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:13 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 5/7] ir-rx51: Convert latency constraints to PM QoS API
Date: Sun, 18 Nov 2012 17:13:07 +0200
Message-Id: <1353251589-26143-6-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the driver from the obsolete omap_pm_set_max_mpu_wakeup_lat
API to the new PM QoS API. This allows the callback to be removed from
the platform data structure.

The latency requirements are also adjusted to prevent the MPU from
going into sleep mode. This is needed as the GP timers have no means
to wake up the MPU once it has gone into sleep. The "side effect" is
that from now on the driver actually works even if there is no
background load keeping the MPU awake.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |  2 --
 drivers/media/rc/ir-rx51.c                   | 17 ++++++++++++-----
 include/media/ir-rx51.h                      |  2 --
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 020e03c..6d0f29d 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -33,7 +33,6 @@
 #include "common.h"
 #include <plat/dma.h>
 #include <plat/gpmc.h>
-#include <plat/omap-pm.h>
 #include "gpmc-smc91x.h"
 
 #include "board-rx51.h"
@@ -1224,7 +1223,6 @@ static void __init rx51_init_tsc2005(void)
 
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
 static struct lirc_rx51_platform_data rx51_lirc_data = {
-	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
 	.pwm_timer = 9, /* Use GPT 9 for CIR */
 };
 
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 6e1ffa6..96ed23d 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/pm_qos.h>
 
 #include <plat/dmtimer.h>
 #include <plat/clock.h>
@@ -49,6 +50,7 @@ struct lirc_rx51 {
 	struct omap_dm_timer *pulse_timer;
 	struct device	     *dev;
 	struct lirc_rx51_platform_data *pdata;
+	struct pm_qos_request	pm_qos_request;
 	wait_queue_head_t     wqueue;
 
 	unsigned long	fclk_khz;
@@ -268,10 +270,16 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 		lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
 
 	/*
-	 * Adjust latency requirements so the device doesn't go in too
-	 * deep sleep states
+	 * If the MPU is going into too deep sleep state while we are
+	 * transmitting the IR code, timers will not be able to wake
+	 * up the MPU. Thus, we need to set a strict enough latency
+	 * requirement in order to ensure the interrupts come though
+	 * properly. The 10us latency requirement is low enough to
+	 * keep MPU from sleeping and thus ensures the interrupts are
+	 * getting through properly.
 	 */
-	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
+	pm_qos_add_request(&lirc_rx51->pm_qos_request,
+			PM_QOS_CPU_DMA_LATENCY,	10);
 
 	lirc_rx51_on(lirc_rx51);
 	lirc_rx51->wbuf_index = 1;
@@ -292,8 +300,7 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 	 */
 	lirc_rx51_stop_tx(lirc_rx51);
 
-	/* We can sleep again */
-	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
+	pm_qos_remove_request(&lirc_rx51->pm_qos_request);
 
 	return n;
 }
diff --git a/include/media/ir-rx51.h b/include/media/ir-rx51.h
index 104aa89..57523f2 100644
--- a/include/media/ir-rx51.h
+++ b/include/media/ir-rx51.h
@@ -3,8 +3,6 @@
 
 struct lirc_rx51_platform_data {
 	int pwm_timer;
-
-	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
 };
 
 #endif
-- 
1.8.0

