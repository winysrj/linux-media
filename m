Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:49746 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2HVTuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 15:50:44 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 7/8] ir-rx51: Remove MPU wakeup latency adjustments
Date: Wed, 22 Aug 2012 22:50:40 +0300
Message-Id: <1345665041-15211-8-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir-rx51 driver calls omap_pm_set_max_mpu_wakeup_lat() in order to
avoid problems that occur when MPU goes to sleep in the middle of
sending an IR code. Without such calls it takes ridiculously long for
the MPU to wake up from a sleep, which distorts the IR signal
completely.

However, the actual problem is that probably the GP timers are not
able to wake up the MPU at all. That is, adjusting the latency
requirements is not the correct way to solve the issue either. The
reason why this used to work with the original 2.6.28 based N900
kernel that is shipped with the product is that placing strict latency
requirements prevents the MPU from going to sleep at all. Furthermore,
the only PM layer imlementation available at the moment for OMAP3
doesn't do anything with the latency requirement placed with
omap_pm_set_max_mpu_wakeup_lat() calls.

A more appropriate fix for the problem would be to modify the idle
layer so that it does not allow MPU going to too deep sleep modes when
it is expected that the timers need to wake up MPU.

Therefore, it makes sense to actually remove this call entirely from
the ir-rx51 driver as it is both wrong and does nothing useful at the
moment.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c | 2 --
 drivers/media/rc/ir-rx51.c                   | 9 ---------
 include/media/ir-rx51.h                      | 2 --
 3 files changed, 13 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index ca07264..e0750cb 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -34,7 +34,6 @@
 #include <plat/gpmc.h>
 #include <plat/onenand.h>
 #include <plat/gpmc-smc91x.h>
-#include <plat/omap-pm.h>
 
 #include <mach/board-rx51.h>
 
@@ -1227,7 +1226,6 @@ static void __init rx51_init_tsc2005(void)
 
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
 static struct lirc_rx51_platform_data rx51_lirc_data = {
-	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
 	.pwm_timer = 9, /* Use GPT 9 for CIR */
 };
 
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 7eed541..ac7d3f0 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -267,12 +267,6 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 	if (count < WBUF_LEN)
 		lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
 
-	/*
-	 * Adjust latency requirements so the device doesn't go in too
-	 * deep sleep states
-	 */
-	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
-
 	lirc_rx51_on(lirc_rx51);
 	lirc_rx51->wbuf_index = 1;
 	pulse_timer_set_timeout(lirc_rx51, lirc_rx51->wbuf[0]);
@@ -292,9 +286,6 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 	 */
 	lirc_rx51_stop_tx(lirc_rx51);
 
-	/* We can sleep again */
-	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
-
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
1.7.12

