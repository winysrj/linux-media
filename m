Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:41917 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752462AbcLTRub (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 12:50:31 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
        Christoph Bartelmus <lirc@bartelmus.de>,
        Milan Pikula <www@fornax.sk>,
        Frank Przybylski <mail@frankprzybylski.de>
Subject: [PATCH 2/5] [media] staging: lirc_sir: port to rc-core
Date: Tue, 20 Dec 2016 17:50:25 +0000
Message-Id: <c6b824fa7649a599527c5b4ffabd0a6bb09f614b.1482255894.git.sean@mess.org>
In-Reply-To: <cover.1482255894.git.sean@mess.org>
References: <cover.1482255894.git.sean@mess.org>
In-Reply-To: <cover.1482255894.git.sean@mess.org>
References: <cover.1482255894.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this driver can be moved out of staging, it should be ported
to rc-core. I've tried to make the minimum changes possible without
upsetting checkpatch.

Compile tested only.

Signed-off-by: Sean Young <sean@mess.org>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>
Cc: Milan Pikula <www@fornax.sk>
Cc: Frank Przybylski <mail@frankprzybylski.de>
---
 drivers/staging/media/lirc/Kconfig    |   2 +-
 drivers/staging/media/lirc/lirc_sir.c | 296 ++++++++--------------------------
 2 files changed, 69 insertions(+), 229 deletions(-)

diff --git a/drivers/staging/media/lirc/Kconfig b/drivers/staging/media/lirc/Kconfig
index 25b7e7c..56e5fd7 100644
--- a/drivers/staging/media/lirc/Kconfig
+++ b/drivers/staging/media/lirc/Kconfig
@@ -40,7 +40,7 @@ config LIRC_SASEM
 
 config LIRC_SIR
 	tristate "Built-in SIR IrDA port"
-	depends on LIRC
+	depends on RC_CORE
 	help
 	  Driver for the SIR IrDA port
 
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 4f326e9..c75ae43 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -1,7 +1,7 @@
 /*
  * LIRC SIR driver, (C) 2000 Milan Pikula <www@fornax.sk>
  *
- * lirc_sir - Device driver for use with SIR (serial infra red)
+ * sir_ir - Device driver for use with SIR (serial infra red)
  * mode of IrDA on many notebooks.
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -58,8 +58,7 @@
 
 #include <linux/timer.h>
 
-#include <media/lirc.h>
-#include <media/lirc_dev.h>
+#include <media/rc-core.h>
 
 /* SECTION: Definitions */
 
@@ -87,11 +86,6 @@ static void init_act200(void);
 static void init_act220(void);
 #endif
 
-#define RBUF_LEN 1024
-#define WBUF_LEN 1024
-
-#define LIRC_DRIVER_NAME "lirc_sir"
-
 #define PULSE '['
 
 #ifndef LIRC_SIR_TEKRAM
@@ -131,28 +125,19 @@ static ktime_t last;
 /* time of last UART data ready interrupt */
 static ktime_t last_intr_time;
 static int last_value;
+static struct rc_dev *rcdev;
 
-static DECLARE_WAIT_QUEUE_HEAD(lirc_read_queue);
+static struct platform_device *sir_ir_dev;
 
 static DEFINE_SPINLOCK(hardware_lock);
 
-static int rx_buf[RBUF_LEN];
-static unsigned int rx_tail, rx_head;
-
 static bool debug;
 
 /* SECTION: Prototypes */
 
 /* Communication with user-space */
-static unsigned int lirc_poll(struct file *file, poll_table *wait);
-static ssize_t lirc_read(struct file *file, char __user *buf, size_t count,
-			 loff_t *ppos);
-static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
-			  loff_t *pos);
-static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 static void add_read_queue(int flag, unsigned long val);
 static int init_chrdev(void);
-static void drop_chrdev(void);
 /* Hardware */
 static irqreturn_t sir_interrupt(int irq, void *dev_id);
 static void send_space(unsigned long len);
@@ -189,72 +174,14 @@ static void safe_udelay(unsigned long usecs)
 }
 
 /* SECTION: Communication with user-space */
-
-static unsigned int lirc_poll(struct file *file, poll_table *wait)
-{
-	poll_wait(file, &lirc_read_queue, wait);
-	if (rx_head != rx_tail)
-		return POLLIN | POLLRDNORM;
-	return 0;
-}
-
-static ssize_t lirc_read(struct file *file, char __user *buf, size_t count,
-			 loff_t *ppos)
-{
-	int n = 0;
-	int retval = 0;
-	DECLARE_WAITQUEUE(wait, current);
-
-	if (count % sizeof(int))
-		return -EINVAL;
-
-	add_wait_queue(&lirc_read_queue, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (n < count) {
-		if (rx_head != rx_tail) {
-			if (copy_to_user(buf + n,
-					 rx_buf + rx_head,
-					 sizeof(int))) {
-				retval = -EFAULT;
-				break;
-			}
-			rx_head = (rx_head + 1) & (RBUF_LEN - 1);
-			n += sizeof(int);
-		} else {
-			if (file->f_flags & O_NONBLOCK) {
-				retval = -EAGAIN;
-				break;
-			}
-			if (signal_pending(current)) {
-				retval = -ERESTARTSYS;
-				break;
-			}
-			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
-		}
-	}
-	remove_wait_queue(&lirc_read_queue, &wait);
-	set_current_state(TASK_RUNNING);
-	return n ? n : retval;
-}
-static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
-			  loff_t *pos)
+static int sir_tx_ir(struct rc_dev *dev, unsigned int *tx_buf,
+		     unsigned int count)
 {
 	unsigned long flags;
-	int i, count;
-	int *tx_buf;
-
-	count = n / sizeof(int);
-	if (n % sizeof(int) || count % 2 == 0)
-		return -EINVAL;
-	tx_buf = memdup_user(buf, n);
-	if (IS_ERR(tx_buf))
-		return PTR_ERR(tx_buf);
-	i = 0;
+	int i;
+
 	local_irq_save(flags);
-	while (1) {
-		if (i >= count)
-			break;
+	for (i = 0; i < count;) {
 		if (tx_buf[i])
 			send_pulse(tx_buf[i]);
 		i++;
@@ -265,138 +192,53 @@ static ssize_t lirc_write(struct file *file, const char __user *buf, size_t n,
 		i++;
 	}
 	local_irq_restore(flags);
-	kfree(tx_buf);
-	return count;
-}
-
-static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
-{
-	u32 __user *uptr = (u32 __user *)arg;
-	int retval = 0;
-	u32 value = 0;
-
-	if (cmd == LIRC_GET_FEATURES)
-		value = LIRC_CAN_SEND_PULSE | LIRC_CAN_REC_MODE2;
-	else if (cmd == LIRC_GET_SEND_MODE)
-		value = LIRC_MODE_PULSE;
-	else if (cmd == LIRC_GET_REC_MODE)
-		value = LIRC_MODE_MODE2;
-
-	switch (cmd) {
-	case LIRC_GET_FEATURES:
-	case LIRC_GET_SEND_MODE:
-	case LIRC_GET_REC_MODE:
-		retval = put_user(value, uptr);
-		break;
-
-	case LIRC_SET_SEND_MODE:
-	case LIRC_SET_REC_MODE:
-		retval = get_user(value, uptr);
-		break;
-	default:
-		retval = -ENOIOCTLCMD;
-
-	}
-
-	if (retval)
-		return retval;
-	if (cmd == LIRC_SET_REC_MODE) {
-		if (value != LIRC_MODE_MODE2)
-			retval = -ENOSYS;
-	} else if (cmd == LIRC_SET_SEND_MODE) {
-		if (value != LIRC_MODE_PULSE)
-			retval = -ENOSYS;
-	}
 
-	return retval;
+	return count;
 }
 
 static void add_read_queue(int flag, unsigned long val)
 {
-	unsigned int new_rx_tail;
-	int newval;
+	DEFINE_IR_RAW_EVENT(ev);
 
 	pr_debug("add flag %d with val %lu\n", flag, val);
 
-	newval = val & PULSE_MASK;
-
 	/*
 	 * statistically, pulses are ~TIME_CONST/2 too long. we could
 	 * maybe make this more exact, but this is good enough
 	 */
 	if (flag) {
 		/* pulse */
-		if (newval > TIME_CONST/2)
-			newval -= TIME_CONST/2;
+		if (val > TIME_CONST / 2)
+			val -= TIME_CONST / 2;
 		else /* should not ever happen */
-			newval = 1;
-		newval |= PULSE_BIT;
+			val = 1;
+		ev.pulse = true;
 	} else {
-		newval += TIME_CONST/2;
+		val += TIME_CONST / 2;
 	}
-	new_rx_tail = (rx_tail + 1) & (RBUF_LEN - 1);
-	if (new_rx_tail == rx_head) {
-		pr_debug("Buffer overrun.\n");
-		return;
-	}
-	rx_buf[rx_tail] = newval;
-	rx_tail = new_rx_tail;
-	wake_up_interruptible(&lirc_read_queue);
-}
+	ev.duration = US_TO_NS(val);
 
-static const struct file_operations lirc_fops = {
-	.owner		= THIS_MODULE,
-	.read		= lirc_read,
-	.write		= lirc_write,
-	.poll		= lirc_poll,
-	.unlocked_ioctl	= lirc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= lirc_ioctl,
-#endif
-	.open		= lirc_dev_fop_open,
-	.release	= lirc_dev_fop_close,
-	.llseek		= no_llseek,
-};
-
-static int set_use_inc(void *data)
-{
-	return 0;
+	ir_raw_event_store_with_filter(rcdev, &ev);
 }
 
-static void set_use_dec(void *data)
-{
-}
-
-static struct lirc_driver driver = {
-	.name		= LIRC_DRIVER_NAME,
-	.minor		= -1,
-	.code_length	= 1,
-	.sample_rate	= 0,
-	.data		= NULL,
-	.add_to_buf	= NULL,
-	.set_use_inc	= set_use_inc,
-	.set_use_dec	= set_use_dec,
-	.fops		= &lirc_fops,
-	.dev		= NULL,
-	.owner		= THIS_MODULE,
-};
-
-static struct platform_device *lirc_sir_dev;
-
 static int init_chrdev(void)
 {
-	driver.dev = &lirc_sir_dev->dev;
-	driver.minor = lirc_register_driver(&driver);
-	if (driver.minor < 0) {
-		pr_err("init_chrdev() failed.\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-static void drop_chrdev(void)
-{
-	lirc_unregister_driver(driver.minor);
+	rcdev = devm_rc_allocate_device(&sir_ir_dev->dev, RC_DRIVER_IR_RAW);
+	if (!rcdev)
+		return -ENOMEM;
+
+	rcdev->input_phys = KBUILD_MODNAME "/input0";
+	rcdev->input_id.bustype = BUS_HOST;
+	rcdev->input_id.vendor = 0x0001;
+	rcdev->input_id.product = 0x0001;
+	rcdev->input_id.version = 0x0100;
+	rcdev->tx_ir = sir_tx_ir;
+	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rcdev->map_name = RC_MAP_RC6_MCE;
+	rcdev->timeout = IR_DEFAULT_TIMEOUT;
+	rcdev->dev.parent = &sir_ir_dev->dev;
+
+	return devm_rc_register_device(&sir_ir_dev->dev, rcdev);
 }
 
 /* SECTION: Hardware */
@@ -420,14 +262,15 @@ static void sir_timeout(unsigned long data)
 		/* determine 'virtual' pulse end: */
 		pulse_end = min_t(unsigned long,
 				  ktime_us_delta(last, last_intr_time),
-				  PULSE_MASK);
-		dev_dbg(driver.dev, "timeout add %d for %lu usec\n",
-				    last_value, pulse_end);
+				  IR_MAX_DURATION);
+		dev_dbg(&sir_ir_dev->dev, "timeout add %d for %lu usec\n",
+			last_value, pulse_end);
 		add_read_queue(last_value, pulse_end);
 		last_value = 0;
 		last = last_intr_time;
 	}
 	spin_unlock_irqrestore(&timer_lock, flags);
+	ir_raw_event_handle(rcdev);
 }
 
 static irqreturn_t sir_interrupt(int irq, void *dev_id)
@@ -462,20 +305,20 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 				curr_time = ktime_get();
 				delt = min_t(unsigned long,
 					     ktime_us_delta(last, curr_time),
-					     PULSE_MASK);
+					     IR_MAX_DURATION);
 				deltintr = min_t(unsigned long,
 						 ktime_us_delta(last_intr_time,
 								curr_time),
-						 PULSE_MASK);
-				dev_dbg(driver.dev, "t %lu, d %d\n",
-						    deltintr, (int)data);
+						 IR_MAX_DURATION);
+				dev_dbg(&sir_ir_dev->dev, "t %lu, d %d\n",
+					deltintr, (int)data);
 				/*
 				 * if nothing came in last X cycles,
 				 * it was gap
 				 */
 				if (deltintr > TIME_CONST * threshold) {
 					if (last_value) {
-						dev_dbg(driver.dev, "GAP\n");
+						dev_dbg(&sir_ir_dev->dev, "GAP\n");
 						/* simulate signal change */
 						add_read_queue(last_value,
 							       delt -
@@ -517,6 +360,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 			break;
 		}
 	}
+	ir_raw_event_handle(rcdev);
 	return IRQ_RETVAL(IRQ_HANDLED);
 }
 
@@ -655,12 +499,12 @@ static int init_port(void)
 	int retval;
 
 	/* get I/O port access and IRQ line */
-	if (request_region(io, 8, LIRC_DRIVER_NAME) == NULL) {
+	if (!request_region(io, 8, KBUILD_MODNAME)) {
 		pr_err("i/o port 0x%.4x already in use.\n", io);
 		return -EBUSY;
 	}
 	retval = request_irq(irq, sir_interrupt, 0,
-			     LIRC_DRIVER_NAME, NULL);
+			     KBUILD_MODNAME, NULL);
 	if (retval < 0) {
 		release_region(io, 8);
 		pr_err("IRQ %d already in use.\n", irq);
@@ -882,11 +726,10 @@ void init_act220(void)
 }
 #endif
 
-static int init_lirc_sir(void)
+static int init_sir_ir(void)
 {
 	int retval;
 
-	init_waitqueue_head(&lirc_read_queue);
 	retval = init_port();
 	if (retval < 0)
 		return retval;
@@ -895,42 +738,42 @@ static int init_lirc_sir(void)
 	return 0;
 }
 
-static int lirc_sir_probe(struct platform_device *dev)
+static int sir_ir_probe(struct platform_device *dev)
 {
 	return 0;
 }
 
-static int lirc_sir_remove(struct platform_device *dev)
+static int sir_ir_remove(struct platform_device *dev)
 {
 	return 0;
 }
 
-static struct platform_driver lirc_sir_driver = {
-	.probe		= lirc_sir_probe,
-	.remove		= lirc_sir_remove,
+static struct platform_driver sir_ir_driver = {
+	.probe		= sir_ir_probe,
+	.remove		= sir_ir_remove,
 	.driver		= {
-		.name	= "lirc_sir",
+		.name	= "sir_ir",
 	},
 };
 
-static int __init lirc_sir_init(void)
+static int __init sir_ir_init(void)
 {
 	int retval;
 
-	retval = platform_driver_register(&lirc_sir_driver);
+	retval = platform_driver_register(&sir_ir_driver);
 	if (retval) {
 		pr_err("Platform driver register failed!\n");
 		return -ENODEV;
 	}
 
-	lirc_sir_dev = platform_device_alloc("lirc_dev", 0);
-	if (!lirc_sir_dev) {
+	sir_ir_dev = platform_device_alloc("sir_ir", 0);
+	if (!sir_ir_dev) {
 		pr_err("Platform device alloc failed!\n");
 		retval = -ENOMEM;
 		goto pdev_alloc_fail;
 	}
 
-	retval = platform_device_add(lirc_sir_dev);
+	retval = platform_device_add(sir_ir_dev);
 	if (retval) {
 		pr_err("Platform device add failed!\n");
 		retval = -ENODEV;
@@ -941,35 +784,32 @@ static int __init lirc_sir_init(void)
 	if (retval < 0)
 		goto fail;
 
-	retval = init_lirc_sir();
-	if (retval) {
-		drop_chrdev();
+	retval = init_sir_ir();
+	if (retval)
 		goto fail;
-	}
 
 	return 0;
 
 fail:
-	platform_device_del(lirc_sir_dev);
+	platform_device_del(sir_ir_dev);
 pdev_add_fail:
-	platform_device_put(lirc_sir_dev);
+	platform_device_put(sir_ir_dev);
 pdev_alloc_fail:
-	platform_driver_unregister(&lirc_sir_driver);
+	platform_driver_unregister(&sir_ir_driver);
 	return retval;
 }
 
-static void __exit lirc_sir_exit(void)
+static void __exit sir_ir_exit(void)
 {
 	drop_hardware();
-	drop_chrdev();
 	drop_port();
-	platform_device_unregister(lirc_sir_dev);
-	platform_driver_unregister(&lirc_sir_driver);
+	platform_device_unregister(sir_ir_dev);
+	platform_driver_unregister(&sir_ir_driver);
 	pr_info("Uninstalled.\n");
 }
 
-module_init(lirc_sir_init);
-module_exit(lirc_sir_exit);
+module_init(sir_ir_init);
+module_exit(sir_ir_exit);
 
 #ifdef LIRC_SIR_TEKRAM
 MODULE_DESCRIPTION("Infrared receiver driver for Tekram Irmate 210");
-- 
2.9.3

