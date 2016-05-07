Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35012 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcEGPWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 11:22:23 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH 3/7] [media] ir-rx51: use PWM framework instead of OMAP dmtimer
Date: Sat,  7 May 2016 18:21:44 +0300
Message-Id: <1462634508-24961-4-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver to use PWM framework instead of calling dmtimer functions
directly for PWM timer. Remove paragraph about writing to the Free Software
Foundation's mailing address while at it.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |  1 -
 arch/arm/mach-omap2/pdata-quirks.c           |  1 -
 drivers/media/rc/ir-rx51.c                   | 85 ++++++++++++++--------------
 include/linux/platform_data/media/ir-rx51.h  |  2 -
 4 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9a70739..e487575 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1242,7 +1242,6 @@ static struct pwm_omap_dmtimer_pdata __maybe_unused pwm_dmtimer_pdata = {
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
 static struct lirc_rx51_platform_data rx51_lirc_data = {
 	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
-	.pwm_timer = 9, /* Use GPT 9 for CIR */
 #if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
 	.dmtimer = &pwm_dmtimer_pdata,
 #endif
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index ea3a7d5..af65781 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -491,7 +491,6 @@ static struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
 
 static struct lirc_rx51_platform_data __maybe_unused rx51_lirc_data = {
 	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
-	.pwm_timer = 9, /* Use GPT 9 for CIR */
 #if IS_ENABLED(CONFIG_OMAP_DM_TIMER)
 	.dmtimer = &pwm_dmtimer_pdata,
 #endif
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index da839c3..5096ef3 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -12,13 +12,7 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
-
 #include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -26,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/pwm.h>
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
@@ -43,7 +38,7 @@
 #define TIMER_MAX_VALUE 0xffffffff
 
 struct lirc_rx51 {
-	pwm_omap_dmtimer *pwm_timer;
+	struct pwm_device *pwm;
 	pwm_omap_dmtimer *pulse_timer;
 	struct pwm_omap_dmtimer_pdata *dmtimer;
 	struct device	     *dev;
@@ -58,32 +53,28 @@ struct lirc_rx51 {
 	int		wbuf[WBUF_LEN];
 	int		wbuf_index;
 	unsigned long	device_is_open;
-	int		pwm_timer_num;
 };
 
 static void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
 {
-	lirc_rx51->dmtimer->set_pwm(lirc_rx51->pwm_timer, 0, 1,
-				PWM_OMAP_DMTIMER_TRIGGER_OVERFLOW_AND_COMPARE);
+	pwm_enable(lirc_rx51->pwm);
 }
 
 static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
 {
-	lirc_rx51->dmtimer->set_pwm(lirc_rx51->pwm_timer, 0, 1,
-				    PWM_OMAP_DMTIMER_TRIGGER_NONE);
+	pwm_disable(lirc_rx51->pwm);
 }
 
 static int init_timing_params(struct lirc_rx51 *lirc_rx51)
 {
-	u32 load, match;
-
-	load = -(lirc_rx51->fclk_khz * 1000 / lirc_rx51->freq);
-	match = -(lirc_rx51->duty_cycle * -load / 100);
-	lirc_rx51->dmtimer->set_load(lirc_rx51->pwm_timer, 1, load);
-	lirc_rx51->dmtimer->set_match(lirc_rx51->pwm_timer, 1, match);
-	lirc_rx51->dmtimer->write_counter(lirc_rx51->pwm_timer, TIMER_MAX_VALUE - 2);
-	lirc_rx51->dmtimer->start(lirc_rx51->pwm_timer);
+	struct pwm_device *pwm = lirc_rx51->pwm;
+	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, lirc_rx51->freq);
+
+	duty = DIV_ROUND_CLOSEST(lirc_rx51->duty_cycle * period, 100);
 	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
+
+	pwm_config(pwm, duty, period);
+
 	lirc_rx51->dmtimer->start(lirc_rx51->pulse_timer);
 
 	lirc_rx51->match = 0;
@@ -165,7 +156,7 @@ end:
 	/* Stop TX here */
 	lirc_rx51_off(lirc_rx51);
 	lirc_rx51->wbuf_index = -1;
-	lirc_rx51->dmtimer->stop(lirc_rx51->pwm_timer);
+
 	lirc_rx51->dmtimer->stop(lirc_rx51->pulse_timer);
 	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
 	wake_up_interruptible(&lirc_rx51->wqueue);
@@ -176,13 +167,13 @@ end:
 static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 {
 	struct clk *clk_fclk;
-	int retval, pwm_timer = lirc_rx51->pwm_timer_num;
+	int retval;
 
-	lirc_rx51->pwm_timer = lirc_rx51->dmtimer->request_specific(pwm_timer);
-	if (lirc_rx51->pwm_timer == NULL) {
-		dev_err(lirc_rx51->dev, ": Error requesting GPT%d timer\n",
-			pwm_timer);
-		return -EBUSY;
+	lirc_rx51->pwm = pwm_get(lirc_rx51->dev, NULL);
+	if (IS_ERR(lirc_rx51->pwm)) {
+		retval = PTR_ERR(lirc_rx51->pwm);
+		dev_err(lirc_rx51->dev, ": pwm_get failed: %d\n", retval);
+		return retval;
 	}
 
 	lirc_rx51->pulse_timer = lirc_rx51->dmtimer->request();
@@ -192,15 +183,11 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 		goto err1;
 	}
 
-	lirc_rx51->dmtimer->set_source(lirc_rx51->pwm_timer,
-				       PWM_OMAP_DMTIMER_SRC_SYS_CLK);
 	lirc_rx51->dmtimer->set_source(lirc_rx51->pulse_timer,
 				       PWM_OMAP_DMTIMER_SRC_SYS_CLK);
-
-	lirc_rx51->dmtimer->enable(lirc_rx51->pwm_timer);
 	lirc_rx51->dmtimer->enable(lirc_rx51->pulse_timer);
-
-	lirc_rx51->irq_num = lirc_rx51->dmtimer->get_irq(lirc_rx51->pulse_timer);
+	lirc_rx51->irq_num =
+			lirc_rx51->dmtimer->get_irq(lirc_rx51->pulse_timer);
 	retval = request_irq(lirc_rx51->irq_num, lirc_rx51_interrupt_handler,
 			     IRQF_SHARED, "lirc_pulse_timer", lirc_rx51);
 	if (retval) {
@@ -208,7 +195,7 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 		goto err2;
 	}
 
-	clk_fclk = lirc_rx51->dmtimer->get_fclk(lirc_rx51->pwm_timer);
+	clk_fclk = lirc_rx51->dmtimer->get_fclk(lirc_rx51->pulse_timer);
 	lirc_rx51->fclk_khz = clk_get_rate(clk_fclk) / 1000;
 
 	return 0;
@@ -216,7 +203,7 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 err2:
 	lirc_rx51->dmtimer->free(lirc_rx51->pulse_timer);
 err1:
-	lirc_rx51->dmtimer->free(lirc_rx51->pwm_timer);
+	pwm_put(lirc_rx51->pwm);
 
 	return retval;
 }
@@ -226,11 +213,10 @@ static int lirc_rx51_free_port(struct lirc_rx51 *lirc_rx51)
 	lirc_rx51->dmtimer->set_int_enable(lirc_rx51->pulse_timer, 0);
 	free_irq(lirc_rx51->irq_num, lirc_rx51);
 	lirc_rx51_off(lirc_rx51);
-	lirc_rx51->dmtimer->disable(lirc_rx51->pwm_timer);
 	lirc_rx51->dmtimer->disable(lirc_rx51->pulse_timer);
-	lirc_rx51->dmtimer->free(lirc_rx51->pwm_timer);
 	lirc_rx51->dmtimer->free(lirc_rx51->pulse_timer);
 	lirc_rx51->wbuf_index = -1;
+	pwm_put(lirc_rx51->pwm);
 
 	return 0;
 }
@@ -387,7 +373,6 @@ static int lirc_rx51_release(struct inode *inode, struct file *file)
 }
 
 static struct lirc_rx51 lirc_rx51 = {
-	.freq		= 38000,
 	.duty_cycle	= 50,
 	.wbuf_index	= -1,
 };
@@ -445,14 +430,34 @@ static int lirc_rx51_resume(struct platform_device *dev)
 
 static int lirc_rx51_probe(struct platform_device *dev)
 {
+	struct pwm_device *pwm;
+
 	lirc_rx51_driver.features = LIRC_RX51_DRIVER_FEATURES;
 	lirc_rx51.pdata = dev->dev.platform_data;
+
+	if (!lirc_rx51.pdata) {
+		dev_err(&dev->dev, "Platform Data is missing\n");
+		return -ENXIO;
+	}
+
 	if (!lirc_rx51.pdata->dmtimer) {
 		dev_err(&dev->dev, "no dmtimer?\n");
 		return -ENODEV;
 	}
 
-	lirc_rx51.pwm_timer_num = lirc_rx51.pdata->pwm_timer;
+	pwm = pwm_get(&dev->dev, NULL);
+	if (IS_ERR(pwm)) {
+		int err = PTR_ERR(pwm);
+
+		if (err != -EPROBE_DEFER)
+			dev_err(&dev->dev, "pwm_get failed: %d\n", err);
+		return err;
+	}
+
+	/* Use default, in case userspace does not set the carrier */
+	lirc_rx51.freq = DIV_ROUND_CLOSEST(pwm_get_period(pwm), NSEC_PER_SEC);
+	pwm_put(pwm);
+
 	lirc_rx51.dmtimer = lirc_rx51.pdata->dmtimer;
 	lirc_rx51.dev = &dev->dev;
 	lirc_rx51_driver.dev = &dev->dev;
@@ -464,8 +469,6 @@ static int lirc_rx51_probe(struct platform_device *dev)
 		       lirc_rx51_driver.minor);
 		return lirc_rx51_driver.minor;
 	}
-	dev_info(lirc_rx51.dev, "registration ok, minor: %d, pwm: %d\n",
-		 lirc_rx51_driver.minor, lirc_rx51.pwm_timer_num);
 
 	return 0;
 }
diff --git a/include/linux/platform_data/media/ir-rx51.h b/include/linux/platform_data/media/ir-rx51.h
index 3038120..6acf22d 100644
--- a/include/linux/platform_data/media/ir-rx51.h
+++ b/include/linux/platform_data/media/ir-rx51.h
@@ -2,8 +2,6 @@
 #define _LIRC_RX51_H
 
 struct lirc_rx51_platform_data {
-	int pwm_timer;
-
 	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
 	struct pwm_omap_dmtimer_pdata *dmtimer;
 };
-- 
1.9.1

