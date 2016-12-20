Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36725 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752210AbcLTRuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 12:50:32 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH 1/5] [media] ir-rx51: port to rc-core
Date: Tue, 20 Dec 2016 17:50:24 +0000
Message-Id: <f5262cc638a494f238ef96a80d8f45265ca2fd02.1482255894.git.sean@mess.org>
In-Reply-To: <cover.1482255894.git.sean@mess.org>
References: <cover.1482255894.git.sean@mess.org>
In-Reply-To: <cover.1482255894.git.sean@mess.org>
References: <cover.1482255894.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver was written using lirc since rc-core did not support
transmitter-only hardware at that time. Now that it does, port
this driver.

Compile tested only.

Signed-off-by: Sean Young <sean@mess.org>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 arch/arm/mach-omap2/pdata-quirks.c          |   8 +-
 drivers/media/rc/Kconfig                    |   2 +-
 drivers/media/rc/ir-rx51.c                  | 332 ++++++++++------------------
 include/linux/platform_data/media/ir-rx51.h |   6 +-
 4 files changed, 126 insertions(+), 222 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 05e20aa..fdd6e7f 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -485,15 +485,15 @@ static struct pwm_omap_dmtimer_pdata pwm_dmtimer_pdata = {
 };
 #endif
 
-static struct lirc_rx51_platform_data __maybe_unused rx51_lirc_data = {
+static struct ir_rx51_platform_data __maybe_unused rx51_ir_data = {
 	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
 };
 
-static struct platform_device __maybe_unused rx51_lirc_device = {
-	.name           = "lirc_rx51",
+static struct platform_device __maybe_unused rx51_ir_device = {
+	.name           = "ir_rx51",
 	.id             = -1,
 	.dev            = {
-		.platform_data = &rx51_lirc_data,
+		.platform_data = &rx51_ir_data,
 	},
 };
 
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 3351e25..d0ddbd3 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -345,7 +345,7 @@ config IR_TTUSBIR
 
 config IR_RX51
 	tristate "Nokia N900 IR transmitter diode"
-	depends on OMAP_DM_TIMER && PWM_OMAP_DMTIMER && ARCH_OMAP2PLUS && LIRC
+	depends on (OMAP_DM_TIMER && PWM_OMAP_DMTIMER && ARCH_OMAP2PLUS || COMPILE_TEST) && RC_CORE
 	---help---
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 82fb6f2..e897c15 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -15,32 +15,23 @@
  */
 #include <linux/clk.h>
 #include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/uaccess.h>
 #include <linux/platform_device.h>
-#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/pwm.h>
 #include <linux/of.h>
 #include <linux/hrtimer.h>
 
-#include <media/lirc.h>
-#include <media/lirc_dev.h>
+#include <media/rc-core.h>
 #include <linux/platform_data/media/ir-rx51.h>
 
-#define LIRC_RX51_DRIVER_FEATURES (LIRC_CAN_SET_SEND_DUTY_CYCLE |	\
-				   LIRC_CAN_SET_SEND_CARRIER |		\
-				   LIRC_CAN_SEND_PULSE)
-
-#define DRIVER_NAME "lirc_rx51"
-
 #define WBUF_LEN 256
 
-struct lirc_rx51 {
+struct ir_rx51 {
+	struct rc_dev *rcdev;
 	struct pwm_device *pwm;
 	struct hrtimer timer;
 	struct device	     *dev;
-	struct lirc_rx51_platform_data *pdata;
+	struct ir_rx51_platform_data *pdata;
 	wait_queue_head_t     wqueue;
 
 	unsigned int	freq;		/* carrier frequency */
@@ -50,38 +41,37 @@ struct lirc_rx51 {
 	unsigned long	device_is_open;
 };
 
-static inline void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
+static inline void ir_rx51_on(struct ir_rx51 *ir_rx51)
 {
-	pwm_enable(lirc_rx51->pwm);
+	pwm_enable(ir_rx51->pwm);
 }
 
-static inline void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
+static inline void ir_rx51_off(struct ir_rx51 *ir_rx51)
 {
-	pwm_disable(lirc_rx51->pwm);
+	pwm_disable(ir_rx51->pwm);
 }
 
-static int init_timing_params(struct lirc_rx51 *lirc_rx51)
+static int init_timing_params(struct ir_rx51 *ir_rx51)
 {
-	struct pwm_device *pwm = lirc_rx51->pwm;
-	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, lirc_rx51->freq);
+	struct pwm_device *pwm = ir_rx51->pwm;
+	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, ir_rx51->freq);
 
-	duty = DIV_ROUND_CLOSEST(lirc_rx51->duty_cycle * period, 100);
+	duty = DIV_ROUND_CLOSEST(ir_rx51->duty_cycle * period, 100);
 
 	pwm_config(pwm, duty, period);
 
 	return 0;
 }
 
-static enum hrtimer_restart lirc_rx51_timer_cb(struct hrtimer *timer)
+static enum hrtimer_restart ir_rx51_timer_cb(struct hrtimer *timer)
 {
-	struct lirc_rx51 *lirc_rx51 =
-			container_of(timer, struct lirc_rx51, timer);
+	struct ir_rx51 *ir_rx51 = container_of(timer, struct ir_rx51, timer);
 	ktime_t now;
 
-	if (lirc_rx51->wbuf_index < 0) {
-		dev_err_ratelimited(lirc_rx51->dev,
-				"BUG wbuf_index has value of %i\n",
-				lirc_rx51->wbuf_index);
+	if (ir_rx51->wbuf_index < 0) {
+		dev_err_ratelimited(ir_rx51->dev,
+				    "BUG wbuf_index has value of %i\n",
+				    ir_rx51->wbuf_index);
 		goto end;
 	}
 
@@ -92,20 +82,20 @@ static enum hrtimer_restart lirc_rx51_timer_cb(struct hrtimer *timer)
 	do {
 		u64 ns;
 
-		if (lirc_rx51->wbuf_index >= WBUF_LEN)
+		if (ir_rx51->wbuf_index >= WBUF_LEN)
 			goto end;
-		if (lirc_rx51->wbuf[lirc_rx51->wbuf_index] == -1)
+		if (ir_rx51->wbuf[ir_rx51->wbuf_index] == -1)
 			goto end;
 
-		if (lirc_rx51->wbuf_index % 2)
-			lirc_rx51_off(lirc_rx51);
+		if (ir_rx51->wbuf_index % 2)
+			ir_rx51_off(ir_rx51);
 		else
-			lirc_rx51_on(lirc_rx51);
+			ir_rx51_on(ir_rx51);
 
-		ns = 1000 * lirc_rx51->wbuf[lirc_rx51->wbuf_index];
+		ns = US_TO_NS(ir_rx51->wbuf[ir_rx51->wbuf_index]);
 		hrtimer_add_expires_ns(timer, ns);
 
-		lirc_rx51->wbuf_index++;
+		ir_rx51->wbuf_index++;
 
 		now = timer->base->get_time();
 
@@ -114,203 +104,112 @@ static enum hrtimer_restart lirc_rx51_timer_cb(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 end:
 	/* Stop TX here */
-	lirc_rx51_off(lirc_rx51);
-	lirc_rx51->wbuf_index = -1;
+	ir_rx51_off(ir_rx51);
+	ir_rx51->wbuf_index = -1;
 
-	wake_up_interruptible(&lirc_rx51->wqueue);
+	wake_up_interruptible(&ir_rx51->wqueue);
 
 	return HRTIMER_NORESTART;
 }
 
-static ssize_t lirc_rx51_write(struct file *file, const char *buf,
-			  size_t n, loff_t *ppos)
+static int ir_rx51_tx(struct rc_dev *dev, unsigned int *buffer,
+		      unsigned int count)
 {
-	int count, i;
-	struct lirc_rx51 *lirc_rx51 = file->private_data;
+	struct ir_rx51 *ir_rx51 = dev->priv;
 
-	if (n % sizeof(int))
+	if (count > WBUF_LEN)
 		return -EINVAL;
 
-	count = n / sizeof(int);
-	if ((count > WBUF_LEN) || (count % 2 == 0))
-		return -EINVAL;
+	memcpy(ir_rx51->wbuf, buffer, count * sizeof(unsigned int));
 
 	/* Wait any pending transfers to finish */
-	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
-
-	if (copy_from_user(lirc_rx51->wbuf, buf, n))
-		return -EFAULT;
-
-	/* Sanity check the input pulses */
-	for (i = 0; i < count; i++)
-		if (lirc_rx51->wbuf[i] < 0)
-			return -EINVAL;
+	wait_event_interruptible(ir_rx51->wqueue, ir_rx51->wbuf_index < 0);
 
-	init_timing_params(lirc_rx51);
+	init_timing_params(ir_rx51);
 	if (count < WBUF_LEN)
-		lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
+		ir_rx51->wbuf[count] = -1; /* Insert termination mark */
 
 	/*
 	 * Adjust latency requirements so the device doesn't go in too
 	 * deep sleep states
 	 */
-	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
+	ir_rx51->pdata->set_max_mpu_wakeup_lat(ir_rx51->dev, 50);
 
-	lirc_rx51_on(lirc_rx51);
-	lirc_rx51->wbuf_index = 1;
-	hrtimer_start(&lirc_rx51->timer,
-		      ns_to_ktime(1000 * lirc_rx51->wbuf[0]),
+	ir_rx51_on(ir_rx51);
+	ir_rx51->wbuf_index = 1;
+	hrtimer_start(&ir_rx51->timer,
+		      ns_to_ktime(US_TO_NS(ir_rx51->wbuf[0])),
 		      HRTIMER_MODE_REL);
 	/*
 	 * Don't return back to the userspace until the transfer has
 	 * finished
 	 */
-	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
+	wait_event_interruptible(ir_rx51->wqueue, ir_rx51->wbuf_index < 0);
 
 	/* We can sleep again */
-	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
+	ir_rx51->pdata->set_max_mpu_wakeup_lat(ir_rx51->dev, -1);
 
-	return n;
+	return count;
 }
 
-static long lirc_rx51_ioctl(struct file *filep,
-			unsigned int cmd, unsigned long arg)
+static int ir_rx51_open(struct rc_dev *dev)
 {
-	int result;
-	unsigned long value;
-	unsigned int ivalue;
-	struct lirc_rx51 *lirc_rx51 = filep->private_data;
-
-	switch (cmd) {
-	case LIRC_GET_SEND_MODE:
-		result = put_user(LIRC_MODE_PULSE, (unsigned long *)arg);
-		if (result)
-			return result;
-		break;
-
-	case LIRC_SET_SEND_MODE:
-		result = get_user(value, (unsigned long *)arg);
-		if (result)
-			return result;
-
-		/* only LIRC_MODE_PULSE supported */
-		if (value != LIRC_MODE_PULSE)
-			return -ENOSYS;
-		break;
-
-	case LIRC_GET_REC_MODE:
-		result = put_user(0, (unsigned long *) arg);
-		if (result)
-			return result;
-		break;
-
-	case LIRC_GET_LENGTH:
-		return -ENOSYS;
-		break;
-
-	case LIRC_SET_SEND_DUTY_CYCLE:
-		result = get_user(ivalue, (unsigned int *) arg);
-		if (result)
-			return result;
-
-		if (ivalue <= 0 || ivalue > 100) {
-			dev_err(lirc_rx51->dev, ": invalid duty cycle %d\n",
-				ivalue);
-			return -EINVAL;
-		}
-
-		lirc_rx51->duty_cycle = ivalue;
-		break;
-
-	case LIRC_SET_SEND_CARRIER:
-		result = get_user(ivalue, (unsigned int *) arg);
-		if (result)
-			return result;
-
-		if (ivalue > 500000 || ivalue < 20000) {
-			dev_err(lirc_rx51->dev, ": invalid carrier freq %d\n",
-				ivalue);
-			return -EINVAL;
-		}
-
-		lirc_rx51->freq = ivalue;
-		break;
-
-	case LIRC_GET_FEATURES:
-		result = put_user(LIRC_RX51_DRIVER_FEATURES,
-				  (unsigned long *) arg);
-		if (result)
-			return result;
-		break;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
-
-	return 0;
-}
+	struct ir_rx51 *ir_rx51 = dev->priv;
 
-static int lirc_rx51_open(struct inode *inode, struct file *file)
-{
-	struct lirc_rx51 *lirc_rx51 = lirc_get_pdata(file);
-	BUG_ON(!lirc_rx51);
-
-	file->private_data = lirc_rx51;
-
-	if (test_and_set_bit(1, &lirc_rx51->device_is_open))
+	if (test_and_set_bit(1, &ir_rx51->device_is_open))
 		return -EBUSY;
 
-	lirc_rx51->pwm = pwm_get(lirc_rx51->dev, NULL);
-	if (IS_ERR(lirc_rx51->pwm)) {
-		int res = PTR_ERR(lirc_rx51->pwm);
+	ir_rx51->pwm = pwm_get(ir_rx51->dev, NULL);
+	if (IS_ERR(ir_rx51->pwm)) {
+		int res = PTR_ERR(ir_rx51->pwm);
 
-		dev_err(lirc_rx51->dev, "pwm_get failed: %d\n", res);
+		dev_err(ir_rx51->dev, "pwm_get failed: %d\n", res);
 		return res;
 	}
 
 	return 0;
 }
 
-static int lirc_rx51_release(struct inode *inode, struct file *file)
+static void ir_rx51_release(struct rc_dev *dev)
 {
-	struct lirc_rx51 *lirc_rx51 = file->private_data;
-
-	hrtimer_cancel(&lirc_rx51->timer);
-	lirc_rx51_off(lirc_rx51);
-	pwm_put(lirc_rx51->pwm);
+	struct ir_rx51 *ir_rx51 = dev->priv;
 
-	clear_bit(1, &lirc_rx51->device_is_open);
+	hrtimer_cancel(&ir_rx51->timer);
+	ir_rx51_off(ir_rx51);
+	pwm_put(ir_rx51->pwm);
 
-	return 0;
+	clear_bit(1, &ir_rx51->device_is_open);
 }
 
-static struct lirc_rx51 lirc_rx51 = {
+static struct ir_rx51 ir_rx51 = {
 	.duty_cycle	= 50,
 	.wbuf_index	= -1,
 };
 
-static const struct file_operations lirc_fops = {
-	.owner		= THIS_MODULE,
-	.write		= lirc_rx51_write,
-	.unlocked_ioctl	= lirc_rx51_ioctl,
-	.read		= lirc_dev_fop_read,
-	.poll		= lirc_dev_fop_poll,
-	.open		= lirc_rx51_open,
-	.release	= lirc_rx51_release,
-};
+static int ir_rx51_set_duty_cycle(struct rc_dev *dev, u32 duty)
+{
+	struct ir_rx51 *ir_rx51 = dev->priv;
 
-static struct lirc_driver lirc_rx51_driver = {
-	.name		= DRIVER_NAME,
-	.minor		= -1,
-	.code_length	= 1,
-	.data		= &lirc_rx51,
-	.fops		= &lirc_fops,
-	.owner		= THIS_MODULE,
-};
+	ir_rx51->duty_cycle = duty;
+
+	return 0;
+}
+
+static int ir_rx51_set_tx_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct ir_rx51 *ir_rx51 = dev->priv;
+
+	if (carrier > 500000 || carrier < 20000)
+		return -EINVAL;
+
+	ir_rx51->freq = carrier;
+
+	return 0;
+}
 
 #ifdef CONFIG_PM
 
-static int lirc_rx51_suspend(struct platform_device *dev, pm_message_t state)
+static int ir_rx51_suspend(struct platform_device *dev, pm_message_t state)
 {
 	/*
 	 * In case the device is still open, do not suspend. Normally
@@ -320,34 +219,34 @@ static int lirc_rx51_suspend(struct platform_device *dev, pm_message_t state)
 	 * were in a middle of a transmit. Thus, we defer any suspend
 	 * actions until transmit has completed.
 	 */
-	if (test_and_set_bit(1, &lirc_rx51.device_is_open))
+	if (test_and_set_bit(1, &ir_rx51.device_is_open))
 		return -EAGAIN;
 
-	clear_bit(1, &lirc_rx51.device_is_open);
+	clear_bit(1, &ir_rx51.device_is_open);
 
 	return 0;
 }
 
-static int lirc_rx51_resume(struct platform_device *dev)
+static int ir_rx51_resume(struct platform_device *dev)
 {
 	return 0;
 }
 
 #else
 
-#define lirc_rx51_suspend	NULL
-#define lirc_rx51_resume	NULL
+#define ir_rx51_suspend	NULL
+#define ir_rx51_resume	NULL
 
 #endif /* CONFIG_PM */
 
-static int lirc_rx51_probe(struct platform_device *dev)
+static int ir_rx51_probe(struct platform_device *dev)
 {
 	struct pwm_device *pwm;
+	struct rc_dev *rcdev;
 
-	lirc_rx51_driver.features = LIRC_RX51_DRIVER_FEATURES;
-	lirc_rx51.pdata = dev->dev.platform_data;
+	ir_rx51.pdata = dev->dev.platform_data;
 
-	if (!lirc_rx51.pdata) {
+	if (!ir_rx51.pdata) {
 		dev_err(&dev->dev, "Platform Data is missing\n");
 		return -ENXIO;
 	}
@@ -362,51 +261,56 @@ static int lirc_rx51_probe(struct platform_device *dev)
 	}
 
 	/* Use default, in case userspace does not set the carrier */
-	lirc_rx51.freq = DIV_ROUND_CLOSEST(pwm_get_period(pwm), NSEC_PER_SEC);
+	ir_rx51.freq = DIV_ROUND_CLOSEST(pwm_get_period(pwm), NSEC_PER_SEC);
 	pwm_put(pwm);
 
-	hrtimer_init(&lirc_rx51.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	lirc_rx51.timer.function = lirc_rx51_timer_cb;
+	hrtimer_init(&ir_rx51.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	ir_rx51.timer.function = ir_rx51_timer_cb;
 
-	lirc_rx51.dev = &dev->dev;
-	lirc_rx51_driver.dev = &dev->dev;
-	lirc_rx51_driver.minor = lirc_register_driver(&lirc_rx51_driver);
-	init_waitqueue_head(&lirc_rx51.wqueue);
+	ir_rx51.dev = &dev->dev;
 
-	if (lirc_rx51_driver.minor < 0) {
-		dev_err(lirc_rx51.dev, ": lirc_register_driver failed: %d\n",
-		       lirc_rx51_driver.minor);
-		return lirc_rx51_driver.minor;
-	}
+	rcdev = devm_rc_allocate_device(&dev->dev, RC_DRIVER_IR_RAW_TX);
+	if (!rcdev)
+		return -ENOMEM;
 
-	return 0;
+	rcdev->priv = &ir_rx51;
+	rcdev->open = ir_rx51_open;
+	rcdev->close = ir_rx51_release;
+	rcdev->tx_ir = ir_rx51_tx;
+	rcdev->s_tx_duty_cycle = ir_rx51_set_duty_cycle;
+	rcdev->s_tx_carrier = ir_rx51_set_tx_carrier;
+	rcdev->driver_name = KBUILD_MODNAME;
+
+	ir_rx51.rcdev = rcdev;
+
+	return devm_rc_register_device(&dev->dev, ir_rx51.rcdev);
 }
 
-static int lirc_rx51_remove(struct platform_device *dev)
+static int ir_rx51_remove(struct platform_device *dev)
 {
-	return lirc_unregister_driver(lirc_rx51_driver.minor);
+	return 0;
 }
 
-static const struct of_device_id lirc_rx51_match[] = {
+static const struct of_device_id ir_rx51_match[] = {
 	{
 		.compatible = "nokia,n900-ir",
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, lirc_rx51_match);
+MODULE_DEVICE_TABLE(of, ir_rx51_match);
 
-struct platform_driver lirc_rx51_platform_driver = {
-	.probe		= lirc_rx51_probe,
-	.remove		= lirc_rx51_remove,
-	.suspend	= lirc_rx51_suspend,
-	.resume		= lirc_rx51_resume,
+static struct platform_driver ir_rx51_platform_driver = {
+	.probe		= ir_rx51_probe,
+	.remove		= ir_rx51_remove,
+	.suspend	= ir_rx51_suspend,
+	.resume		= ir_rx51_resume,
 	.driver		= {
-		.name	= DRIVER_NAME,
-		.of_match_table = of_match_ptr(lirc_rx51_match),
+		.name	= KBUILD_MODNAME,
+		.of_match_table = of_match_ptr(ir_rx51_match),
 	},
 };
-module_platform_driver(lirc_rx51_platform_driver);
+module_platform_driver(ir_rx51_platform_driver);
 
-MODULE_DESCRIPTION("LIRC TX driver for Nokia RX51");
+MODULE_DESCRIPTION("IR TX driver for Nokia RX51");
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/media/ir-rx51.h b/include/linux/platform_data/media/ir-rx51.h
index 812d873..2c94ab5 100644
--- a/include/linux/platform_data/media/ir-rx51.h
+++ b/include/linux/platform_data/media/ir-rx51.h
@@ -1,7 +1,7 @@
-#ifndef _LIRC_RX51_H
-#define _LIRC_RX51_H
+#ifndef _IR_RX51_H
+#define _IR_RX51_H
 
-struct lirc_rx51_platform_data {
+struct ir_rx51_platform_data {
 	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
 };
 
-- 
2.9.3

