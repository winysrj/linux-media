Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33313 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbcEPTee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 15:34:34 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH v2 5/6] ir-rx51: use hrtimer instead of dmtimer
Date: Mon, 16 May 2016 22:34:13 +0300
Message-Id: <1463427254-7728-6-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1463427254-7728-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1463427254-7728-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop dmtimer usage for pulse timer in favor of hrtimer. That allows
removing PWM dmitimer platform data usage.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   4 -
 arch/arm/mach-omap2/pdata-quirks.c           |   3 -
 drivers/media/rc/ir-rx51.c                   | 166 ++++++---------------------
 include/linux/platform_data/media/ir-rx51.h  |   1 -
 4 files changed, 37 insertions(+), 137 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index e487575..a5ab712 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1242,10 +1242,6 @@ static struct pwm_omap_dmtimer_pdata __maybe_unused pwm_dmtimer_pdata = {
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
 static struct lirc_rx51_platform_data rx51_lirc_data = {
 	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
-#if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
-	.dmtimer = &pwm_dmtimer_pdata,
-#endif
-
 };
 
 static struct platform_device rx51_lirc_device = {
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 436c6e6..8739d5c 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -486,9 +486,6 @@ static struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
 
 static struct lirc_rx51_platform_data __maybe_unused rx51_lirc_data = {
 	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
-#if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
-	.dmtimer = &pwm_dmtimer_pdata,
-#endif
 };
 
 static struct platform_device __maybe_unused rx51_lirc_device = {
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 1cbb43d..82fb6f2 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -22,10 +22,10 @@
 #include <linux/wait.h>
 #include <linux/pwm.h>
 #include <linux/of.h>
+#include <linux/hrtimer.h>
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
-#include <linux/platform_data/pwm_omap_dmtimer.h>
 #include <linux/platform_data/media/ir-rx51.h>
 
 #define LIRC_RX51_DRIVER_FEATURES (LIRC_CAN_SET_SEND_DUTY_CYCLE |	\
@@ -36,32 +36,26 @@
 
 #define WBUF_LEN 256
 
-#define TIMER_MAX_VALUE 0xffffffff
-
 struct lirc_rx51 {
 	struct pwm_device *pwm;
-	pwm_omap_dmtimer *pulse_timer;
-	struct pwm_omap_dmtimer_pdata *dmtimer;
+	struct hrtimer timer;
 	struct device	     *dev;
 	struct lirc_rx51_platform_data *pdata;
 	wait_queue_head_t     wqueue;
 
-	unsigned long	fclk_khz;
 	unsigned int	freq;		/* carrier frequency */
 	unsigned int	duty_cycle;	/* carrier duty cycle */
-	unsigned int	irq_num;
-	unsigned int	match;
 	int		wbuf[WBUF_LEN];
 	int		wbuf_index;
 	unsigned long	device_is_open;
 };
 
-static void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
+static inline void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
 {
 	pwm_enable(lirc_rx51->pwm);
 }
 
-static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
+static inline void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
 {
 	pwm_disable(lirc_rx51->pwm);
 }
@@ -72,61 +66,21 @@ static int init_timing_params(struct lirc_rx51 *lirc_rx51)
 	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, lirc_rx51->freq);
 
 	duty = DIV_ROUND_CLOSEST(lirc_rx51->duty_cycle * period, 100);
-	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
 
 	pwm_config(pwm, duty, period);
 
-	lirc_rx51->dmtimer->start(lirc_rx51->pulse_timer);
-
-	lirc_rx51->match = 0;
-
 	return 0;
 }
 
-#define tics_after(a, b) ((long)(b) - (long)(a) < 0)
-
-static int pulse_timer_set_timeout(struct lirc_rx51 *lirc_rx51, int usec)
+static enum hrtimer_restart lirc_rx51_timer_cb(struct hrtimer *timer)
 {
-	int counter;
-
-	BUG_ON(usec < 0);
-
-	if (lirc_rx51->match == 0)
-		counter = lirc_rx51->dmtimer->read_counter(lirc_rx51->pulse_timer);
-	else
-		counter = lirc_rx51->match;
-
-	counter += (u32)(lirc_rx51->fclk_khz * usec / (1000));
-	lirc_rx51->dmtimer->set_match(lirc_rx51->pulse_timer, 1, counter);
-	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer,
-					   PWM_OMAP_DMTIMER_INT_MATCH);
-	if (tics_after(lirc_rx51->dmtimer->read_counter(lirc_rx51->pulse_timer),
-		       counter)) {
-		return 1;
-	}
-	return 0;
-}
+	struct lirc_rx51 *lirc_rx51 =
+			container_of(timer, struct lirc_rx51, timer);
+	ktime_t now;
 
-static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
-{
-	unsigned int retval;
-	struct lirc_rx51 *lirc_rx51 = ptr;
-
-	retval = lirc_rx51->dmtimer->read_status(lirc_rx51->pulse_timer);
-	if (!retval)
-		return IRQ_NONE;
-
-	if (retval & ~PWM_OMAP_DMTIMER_INT_MATCH)
-		dev_err_ratelimited(lirc_rx51->dev,
-				": Unexpected interrupt source: %x\n", retval);
-
-	lirc_rx51->dmtimer->write_status(lirc_rx51->pulse_timer,
-					 PWM_OMAP_DMTIMER_INT_MATCH |
-					 PWM_OMAP_DMTIMER_INT_OVERFLOW |
-					 PWM_OMAP_DMTIMER_INT_CAPTURE);
 	if (lirc_rx51->wbuf_index < 0) {
 		dev_err_ratelimited(lirc_rx51->dev,
-				": BUG wbuf_index has value of %i\n",
+				"BUG wbuf_index has value of %i\n",
 				lirc_rx51->wbuf_index);
 		goto end;
 	}
@@ -136,6 +90,8 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
 	 * pulses until we catch up.
 	 */
 	do {
+		u64 ns;
+
 		if (lirc_rx51->wbuf_index >= WBUF_LEN)
 			goto end;
 		if (lirc_rx51->wbuf[lirc_rx51->wbuf_index] == -1)
@@ -146,80 +102,24 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
 		else
 			lirc_rx51_on(lirc_rx51);
 
-		retval = pulse_timer_set_timeout(lirc_rx51,
-					lirc_rx51->wbuf[lirc_rx51->wbuf_index]);
+		ns = 1000 * lirc_rx51->wbuf[lirc_rx51->wbuf_index];
+		hrtimer_add_expires_ns(timer, ns);
+
 		lirc_rx51->wbuf_index++;
 
-	} while (retval);
+		now = timer->base->get_time();
+
+	} while (hrtimer_get_expires_tv64(timer) < now.tv64);
 
-	return IRQ_HANDLED;
+	return HRTIMER_RESTART;
 end:
 	/* Stop TX here */
 	lirc_rx51_off(lirc_rx51);
 	lirc_rx51->wbuf_index = -1;
 
-	lirc_rx51->dmtimer->stop(lirc_rx51->pulse_timer);
-	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
 	wake_up_interruptible(&lirc_rx51->wqueue);
 
-	return IRQ_HANDLED;
-}
-
-static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
-{
-	struct clk *clk_fclk;
-	int retval;
-
-	lirc_rx51->pwm = pwm_get(lirc_rx51->dev, NULL);
-	if (IS_ERR(lirc_rx51->pwm)) {
-		retval = PTR_ERR(lirc_rx51->pwm);
-		dev_err(lirc_rx51->dev, ": pwm_get failed: %d\n", retval);
-		return retval;
-	}
-
-	lirc_rx51->pulse_timer = lirc_rx51->dmtimer->request();
-	if (lirc_rx51->pulse_timer == NULL) {
-		dev_err(lirc_rx51->dev, ": Error requesting pulse timer\n");
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	lirc_rx51->dmtimer->set_source(lirc_rx51->pulse_timer,
-				       PWM_OMAP_DMTIMER_SRC_SYS_CLK);
-	lirc_rx51->dmtimer->enable(lirc_rx51->pulse_timer);
-	lirc_rx51->irq_num =
-			lirc_rx51->dmtimer->get_irq(lirc_rx51->pulse_timer);
-	retval = request_irq(lirc_rx51->irq_num, lirc_rx51_interrupt_handler,
-			     IRQF_SHARED, "lirc_pulse_timer", lirc_rx51);
-	if (retval) {
-		dev_err(lirc_rx51->dev, ": Failed to request interrupt line\n");
-		goto err2;
-	}
-
-	clk_fclk = lirc_rx51->dmtimer->get_fclk(lirc_rx51->pulse_timer);
-	lirc_rx51->fclk_khz = clk_get_rate(clk_fclk) / 1000;
-
-	return 0;
-
-err2:
-	lirc_rx51->dmtimer->free(lirc_rx51->pulse_timer);
-err1:
-	pwm_put(lirc_rx51->pwm);
-
-	return retval;
-}
-
-static int lirc_rx51_free_port(struct lirc_rx51 *lirc_rx51)
-{
-	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
-	free_irq(lirc_rx51->irq_num, lirc_rx51);
-	lirc_rx51_off(lirc_rx51);
-	lirc_rx51->dmtimer->disable(lirc_rx51->pulse_timer);
-	lirc_rx51->dmtimer->free(lirc_rx51->pulse_timer);
-	lirc_rx51->wbuf_index = -1;
-	pwm_put(lirc_rx51->pwm);
-
-	return 0;
+	return HRTIMER_NORESTART;
 }
 
 static ssize_t lirc_rx51_write(struct file *file, const char *buf,
@@ -258,8 +158,9 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 
 	lirc_rx51_on(lirc_rx51);
 	lirc_rx51->wbuf_index = 1;
-	pulse_timer_set_timeout(lirc_rx51, lirc_rx51->wbuf[0]);
-
+	hrtimer_start(&lirc_rx51->timer,
+		      ns_to_ktime(1000 * lirc_rx51->wbuf[0]),
+		      HRTIMER_MODE_REL);
 	/*
 	 * Don't return back to the userspace until the transfer has
 	 * finished
@@ -359,14 +260,24 @@ static int lirc_rx51_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(1, &lirc_rx51->device_is_open))
 		return -EBUSY;
 
-	return lirc_rx51_init_port(lirc_rx51);
+	lirc_rx51->pwm = pwm_get(lirc_rx51->dev, NULL);
+	if (IS_ERR(lirc_rx51->pwm)) {
+		int res = PTR_ERR(lirc_rx51->pwm);
+
+		dev_err(lirc_rx51->dev, "pwm_get failed: %d\n", res);
+		return res;
+	}
+
+	return 0;
 }
 
 static int lirc_rx51_release(struct inode *inode, struct file *file)
 {
 	struct lirc_rx51 *lirc_rx51 = file->private_data;
 
-	lirc_rx51_free_port(lirc_rx51);
+	hrtimer_cancel(&lirc_rx51->timer);
+	lirc_rx51_off(lirc_rx51);
+	pwm_put(lirc_rx51->pwm);
 
 	clear_bit(1, &lirc_rx51->device_is_open);
 
@@ -441,11 +352,6 @@ static int lirc_rx51_probe(struct platform_device *dev)
 		return -ENXIO;
 	}
 
-	if (!lirc_rx51.pdata->dmtimer) {
-		dev_err(&dev->dev, "no dmtimer?\n");
-		return -ENODEV;
-	}
-
 	pwm = pwm_get(&dev->dev, NULL);
 	if (IS_ERR(pwm)) {
 		int err = PTR_ERR(pwm);
@@ -459,7 +365,9 @@ static int lirc_rx51_probe(struct platform_device *dev)
 	lirc_rx51.freq = DIV_ROUND_CLOSEST(pwm_get_period(pwm), NSEC_PER_SEC);
 	pwm_put(pwm);
 
-	lirc_rx51.dmtimer = lirc_rx51.pdata->dmtimer;
+	hrtimer_init(&lirc_rx51.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	lirc_rx51.timer.function = lirc_rx51_timer_cb;
+
 	lirc_rx51.dev = &dev->dev;
 	lirc_rx51_driver.dev = &dev->dev;
 	lirc_rx51_driver.minor = lirc_register_driver(&lirc_rx51_driver);
diff --git a/include/linux/platform_data/media/ir-rx51.h b/include/linux/platform_data/media/ir-rx51.h
index 6acf22d..812d873 100644
--- a/include/linux/platform_data/media/ir-rx51.h
+++ b/include/linux/platform_data/media/ir-rx51.h
@@ -3,7 +3,6 @@
 
 struct lirc_rx51_platform_data {
 	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
-	struct pwm_omap_dmtimer_pdata *dmtimer;
 };
 
 #endif
-- 
1.9.1

