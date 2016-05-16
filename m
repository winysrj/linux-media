Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33210 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbcEPTe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 15:34:27 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com,
	Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH v2 1/6] ir-rx51: Fix build after multiarch changes broke it
Date: Mon, 16 May 2016 22:34:09 +0300
Message-Id: <1463427254-7728-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1463427254-7728-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1463427254-7728-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony Lindgren <tony@atomide.com>

The ir-rx51 driver for n900 has been disabled since the multiarch
changes as plat include directory no longer is SoC specific.

Let's fix it with minimal changes to pass the dmtimer calls in
pdata. Then the following changes can be done while things can
be tested to be working for each change:

1. Change the non-pwm dmtimer to use just hrtimer if possible

2. Change the pwm dmtimer to use Linux PWM API with the new
   drivers/pwm/pwm-omap-dmtimer.c and remove the direct calls
   to dmtimer functions

3. Parse configuration from device tree and drop the pdata

Note compilation of this depends on the previous patch
"ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51".

Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/media/rc/Kconfig   |  2 +-
 drivers/media/rc/ir-rx51.c | 99 +++++++++++++++++++++++++---------------------
 2 files changed, 54 insertions(+), 47 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index bd4d685..370e16e 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -336,7 +336,7 @@ config IR_TTUSBIR
 
 config IR_RX51
 	tristate "Nokia N900 IR transmitter diode"
-	depends on OMAP_DM_TIMER && ARCH_OMAP2PLUS && LIRC && !ARCH_MULTIPLATFORM
+	depends on OMAP_DM_TIMER && PWM_OMAP_DMTIMER && ARCH_OMAP2PLUS && LIRC
 	---help---
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 4e1711a..da839c3 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
@@ -26,11 +27,9 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
-#include <plat/dmtimer.h>
-#include <plat/clock.h>
-
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
+#include <linux/platform_data/pwm_omap_dmtimer.h>
 #include <linux/platform_data/media/ir-rx51.h>
 
 #define LIRC_RX51_DRIVER_FEATURES (LIRC_CAN_SET_SEND_DUTY_CYCLE |	\
@@ -44,8 +43,9 @@
 #define TIMER_MAX_VALUE 0xffffffff
 
 struct lirc_rx51 {
-	struct omap_dm_timer *pwm_timer;
-	struct omap_dm_timer *pulse_timer;
+	pwm_omap_dmtimer *pwm_timer;
+	pwm_omap_dmtimer *pulse_timer;
+	struct pwm_omap_dmtimer_pdata *dmtimer;
 	struct device	     *dev;
 	struct lirc_rx51_platform_data *pdata;
 	wait_queue_head_t     wqueue;
@@ -63,14 +63,14 @@ struct lirc_rx51 {
 
 static void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
 {
-	omap_dm_timer_set_pwm(lirc_rx51->pwm_timer, 0, 1,
-			      OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE);
+	lirc_rx51->dmtimer->set_pwm(lirc_rx51->pwm_timer, 0, 1,
+				PWM_OMAP_DMTIMER_TRIGGER_OVERFLOW_AND_COMPARE);
 }
 
 static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
 {
-	omap_dm_timer_set_pwm(lirc_rx51->pwm_timer, 0, 1,
-			      OMAP_TIMER_TRIGGER_NONE);
+	lirc_rx51->dmtimer->set_pwm(lirc_rx51->pwm_timer, 0, 1,
+				    PWM_OMAP_DMTIMER_TRIGGER_NONE);
 }
 
 static int init_timing_params(struct lirc_rx51 *lirc_rx51)
@@ -79,12 +79,12 @@ static int init_timing_params(struct lirc_rx51 *lirc_rx51)
 
 	load = -(lirc_rx51->fclk_khz * 1000 / lirc_rx51->freq);
 	match = -(lirc_rx51->duty_cycle * -load / 100);
-	omap_dm_timer_set_load(lirc_rx51->pwm_timer, 1, load);
-	omap_dm_timer_set_match(lirc_rx51->pwm_timer, 1, match);
-	omap_dm_timer_write_counter(lirc_rx51->pwm_timer, TIMER_MAX_VALUE - 2);
-	omap_dm_timer_start(lirc_rx51->pwm_timer);
-	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
-	omap_dm_timer_start(lirc_rx51->pulse_timer);
+	lirc_rx51->dmtimer->set_load(lirc_rx51->pwm_timer, 1, load);
+	lirc_rx51->dmtimer->set_match(lirc_rx51->pwm_timer, 1, match);
+	lirc_rx51->dmtimer->write_counter(lirc_rx51->pwm_timer, TIMER_MAX_VALUE - 2);
+	lirc_rx51->dmtimer->start(lirc_rx51->pwm_timer);
+	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
+	lirc_rx51->dmtimer->start(lirc_rx51->pulse_timer);
 
 	lirc_rx51->match = 0;
 
@@ -100,15 +100,15 @@ static int pulse_timer_set_timeout(struct lirc_rx51 *lirc_rx51, int usec)
 	BUG_ON(usec < 0);
 
 	if (lirc_rx51->match == 0)
-		counter = omap_dm_timer_read_counter(lirc_rx51->pulse_timer);
+		counter = lirc_rx51->dmtimer->read_counter(lirc_rx51->pulse_timer);
 	else
 		counter = lirc_rx51->match;
 
 	counter += (u32)(lirc_rx51->fclk_khz * usec / (1000));
-	omap_dm_timer_set_match(lirc_rx51->pulse_timer, 1, counter);
-	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer,
-				     OMAP_TIMER_INT_MATCH);
-	if (tics_after(omap_dm_timer_read_counter(lirc_rx51->pulse_timer),
+	lirc_rx51->dmtimer->set_match(lirc_rx51->pulse_timer, 1, counter);
+	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer,
+					   PWM_OMAP_DMTIMER_INT_MATCH);
+	if (tics_after(lirc_rx51->dmtimer->read_counter(lirc_rx51->pulse_timer),
 		       counter)) {
 		return 1;
 	}
@@ -120,18 +120,18 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
 	unsigned int retval;
 	struct lirc_rx51 *lirc_rx51 = ptr;
 
-	retval = omap_dm_timer_read_status(lirc_rx51->pulse_timer);
+	retval = lirc_rx51->dmtimer->read_status(lirc_rx51->pulse_timer);
 	if (!retval)
 		return IRQ_NONE;
 
-	if (retval & ~OMAP_TIMER_INT_MATCH)
+	if (retval & ~PWM_OMAP_DMTIMER_INT_MATCH)
 		dev_err_ratelimited(lirc_rx51->dev,
 				": Unexpected interrupt source: %x\n", retval);
 
-	omap_dm_timer_write_status(lirc_rx51->pulse_timer,
-				OMAP_TIMER_INT_MATCH	|
-				OMAP_TIMER_INT_OVERFLOW	|
-				OMAP_TIMER_INT_CAPTURE);
+	lirc_rx51->dmtimer->write_status(lirc_rx51->pulse_timer,
+					 PWM_OMAP_DMTIMER_INT_MATCH |
+					 PWM_OMAP_DMTIMER_INT_OVERFLOW |
+					 PWM_OMAP_DMTIMER_INT_CAPTURE);
 	if (lirc_rx51->wbuf_index < 0) {
 		dev_err_ratelimited(lirc_rx51->dev,
 				": BUG wbuf_index has value of %i\n",
@@ -165,9 +165,9 @@ end:
 	/* Stop TX here */
 	lirc_rx51_off(lirc_rx51);
 	lirc_rx51->wbuf_index = -1;
-	omap_dm_timer_stop(lirc_rx51->pwm_timer);
-	omap_dm_timer_stop(lirc_rx51->pulse_timer);
-	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
+	lirc_rx51->dmtimer->stop(lirc_rx51->pwm_timer);
+	lirc_rx51->dmtimer->stop(lirc_rx51->pulse_timer);
+	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
 	wake_up_interruptible(&lirc_rx51->wqueue);
 
 	return IRQ_HANDLED;
@@ -178,28 +178,29 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 	struct clk *clk_fclk;
 	int retval, pwm_timer = lirc_rx51->pwm_timer_num;
 
-	lirc_rx51->pwm_timer = omap_dm_timer_request_specific(pwm_timer);
+	lirc_rx51->pwm_timer = lirc_rx51->dmtimer->request_specific(pwm_timer);
 	if (lirc_rx51->pwm_timer == NULL) {
 		dev_err(lirc_rx51->dev, ": Error requesting GPT%d timer\n",
 			pwm_timer);
 		return -EBUSY;
 	}
 
-	lirc_rx51->pulse_timer = omap_dm_timer_request();
+	lirc_rx51->pulse_timer = lirc_rx51->dmtimer->request();
 	if (lirc_rx51->pulse_timer == NULL) {
 		dev_err(lirc_rx51->dev, ": Error requesting pulse timer\n");
 		retval = -EBUSY;
 		goto err1;
 	}
 
-	omap_dm_timer_set_source(lirc_rx51->pwm_timer, OMAP_TIMER_SRC_SYS_CLK);
-	omap_dm_timer_set_source(lirc_rx51->pulse_timer,
-				OMAP_TIMER_SRC_SYS_CLK);
+	lirc_rx51->dmtimer->set_source(lirc_rx51->pwm_timer,
+				       PWM_OMAP_DMTIMER_SRC_SYS_CLK);
+	lirc_rx51->dmtimer->set_source(lirc_rx51->pulse_timer,
+				       PWM_OMAP_DMTIMER_SRC_SYS_CLK);
 
-	omap_dm_timer_enable(lirc_rx51->pwm_timer);
-	omap_dm_timer_enable(lirc_rx51->pulse_timer);
+	lirc_rx51->dmtimer->enable(lirc_rx51->pwm_timer);
+	lirc_rx51->dmtimer->enable(lirc_rx51->pulse_timer);
 
-	lirc_rx51->irq_num = omap_dm_timer_get_irq(lirc_rx51->pulse_timer);
+	lirc_rx51->irq_num = lirc_rx51->dmtimer->get_irq(lirc_rx51->pulse_timer);
 	retval = request_irq(lirc_rx51->irq_num, lirc_rx51_interrupt_handler,
 			     IRQF_SHARED, "lirc_pulse_timer", lirc_rx51);
 	if (retval) {
@@ -207,28 +208,28 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 		goto err2;
 	}
 
-	clk_fclk = omap_dm_timer_get_fclk(lirc_rx51->pwm_timer);
-	lirc_rx51->fclk_khz = clk_fclk->rate / 1000;
+	clk_fclk = lirc_rx51->dmtimer->get_fclk(lirc_rx51->pwm_timer);
+	lirc_rx51->fclk_khz = clk_get_rate(clk_fclk) / 1000;
 
 	return 0;
 
 err2:
-	omap_dm_timer_free(lirc_rx51->pulse_timer);
+	lirc_rx51->dmtimer->free(lirc_rx51->pulse_timer);
 err1:
-	omap_dm_timer_free(lirc_rx51->pwm_timer);
+	lirc_rx51->dmtimer->free(lirc_rx51->pwm_timer);
 
 	return retval;
 }
 
 static int lirc_rx51_free_port(struct lirc_rx51 *lirc_rx51)
 {
-	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
+	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
 	free_irq(lirc_rx51->irq_num, lirc_rx51);
 	lirc_rx51_off(lirc_rx51);
-	omap_dm_timer_disable(lirc_rx51->pwm_timer);
-	omap_dm_timer_disable(lirc_rx51->pulse_timer);
-	omap_dm_timer_free(lirc_rx51->pwm_timer);
-	omap_dm_timer_free(lirc_rx51->pulse_timer);
+	lirc_rx51->dmtimer->disable(lirc_rx51->pwm_timer);
+	lirc_rx51->dmtimer->disable(lirc_rx51->pulse_timer);
+	lirc_rx51->dmtimer->free(lirc_rx51->pwm_timer);
+	lirc_rx51->dmtimer->free(lirc_rx51->pulse_timer);
 	lirc_rx51->wbuf_index = -1;
 
 	return 0;
@@ -446,7 +447,13 @@ static int lirc_rx51_probe(struct platform_device *dev)
 {
 	lirc_rx51_driver.features = LIRC_RX51_DRIVER_FEATURES;
 	lirc_rx51.pdata = dev->dev.platform_data;
+	if (!lirc_rx51.pdata->dmtimer) {
+		dev_err(&dev->dev, "no dmtimer?\n");
+		return -ENODEV;
+	}
+
 	lirc_rx51.pwm_timer_num = lirc_rx51.pdata->pwm_timer;
+	lirc_rx51.dmtimer = lirc_rx51.pdata->dmtimer;
 	lirc_rx51.dev = &dev->dev;
 	lirc_rx51_driver.dev = &dev->dev;
 	lirc_rx51_driver.minor = lirc_register_driver(&lirc_rx51_driver);
-- 
1.9.1

