Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45169 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbdKFKkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 05:40:22 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] media: rc: move ir-lirc-codec.c contents into lirc_dev.c
Date: Mon,  6 Nov 2017 10:40:16 +0000
Message-Id: <f952894bb8f969db4c23de9f7ccf8b2750d80e52.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since removing the lirc kapi, ir-lirc-codec.c only contains lirc fops
so the file name is no longer correct. By moving its content into
lirc_dev.c the ugly extern struct lirc_fops is not longer needed,
and everything lirc related is in one file.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Makefile        |   2 +-
 drivers/media/rc/ir-lirc-codec.c | 637 ---------------------------------------
 drivers/media/rc/lirc_dev.c      | 618 +++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h  |   2 -
 4 files changed, 619 insertions(+), 640 deletions(-)
 delete mode 100644 drivers/media/rc/ir-lirc-codec.c

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index a1ef86767aef..9d487988b78d 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -3,7 +3,7 @@ obj-y += keymaps/
 
 obj-$(CONFIG_RC_CORE) += rc-core.o
 rc-core-y := rc-main.o rc-ir-raw.o
-rc-core-$(CONFIG_LIRC) += lirc_dev.o ir-lirc-codec.o
+rc-core-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
deleted file mode 100644
index 78934479bcff..000000000000
--- a/drivers/media/rc/ir-lirc-codec.c
+++ /dev/null
@@ -1,637 +0,0 @@
-/* ir-lirc-codec.c - rc-core to classic lirc interface bridge
- *
- * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <linux/poll.h>
-#include <linux/sched.h>
-#include <linux/wait.h>
-#include <media/lirc.h>
-#include <media/rc-core.h>
-#include "rc-core-priv.h"
-
-#define LIRCBUF_SIZE 256
-
-/**
- * ir_lirc_raw_event() - Send raw IR data to lirc to be relayed to userspace
- *
- * @dev:	the struct rc_dev descriptor of the device
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
- */
-void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
-{
-	int sample;
-
-	/* Packet start */
-	if (ev.reset) {
-		/* Userspace expects a long space event before the start of
-		 * the signal to use as a sync.  This may be done with repeat
-		 * packets and normal samples.  But if a reset has been sent
-		 * then we assume that a long time has passed, so we send a
-		 * space with the maximum time value. */
-		sample = LIRC_SPACE(LIRC_VALUE_MASK);
-		IR_dprintk(2, "delivering reset sync space to lirc_dev\n");
-
-	/* Carrier reports */
-	} else if (ev.carrier_report) {
-		sample = LIRC_FREQUENCY(ev.carrier);
-		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
-
-	/* Packet end */
-	} else if (ev.timeout) {
-
-		if (dev->gap)
-			return;
-
-		dev->gap_start = ktime_get();
-		dev->gap = true;
-		dev->gap_duration = ev.duration;
-
-		if (!dev->send_timeout_reports)
-			return;
-
-		sample = LIRC_TIMEOUT(ev.duration / 1000);
-		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
-
-	/* Normal sample */
-	} else {
-
-		if (dev->gap) {
-			dev->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
-							 dev->gap_start));
-
-			/* Convert to ms and cap by LIRC_VALUE_MASK */
-			do_div(dev->gap_duration, 1000);
-			dev->gap_duration = min_t(u64, dev->gap_duration,
-						  LIRC_VALUE_MASK);
-
-			kfifo_put(&dev->rawir, LIRC_SPACE(dev->gap_duration));
-			dev->gap = false;
-		}
-
-		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
-					LIRC_SPACE(ev.duration / 1000);
-		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
-			   TO_US(ev.duration), TO_STR(ev.pulse));
-	}
-
-	kfifo_put(&dev->rawir, sample);
-	wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
-}
-
-/**
- * ir_lirc_scancode_event() - Send scancode data to lirc to be relayed to
- *		userspace
- * @dev:	the struct rc_dev descriptor of the device
- * @lsc		the struct lirc_scancode describing the decoded scancode
- */
-void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc)
-{
-	lsc->timestamp = ktime_get_ns();
-
-	if (kfifo_put(&dev->scancodes, *lsc))
-		wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
-}
-EXPORT_SYMBOL_GPL(ir_lirc_scancode_event);
-
-static int ir_lirc_open(struct inode *inode, struct file *file)
-{
-	struct rc_dev *dev = container_of(inode->i_cdev, struct rc_dev,
-					  lirc_cdev);
-	int retval;
-
-	retval = rc_open(dev);
-	if (retval)
-		return retval;
-
-	retval = mutex_lock_interruptible(&dev->lock);
-	if (retval)
-		goto out_rc;
-
-	if (!dev->registered) {
-		retval = -ENODEV;
-		goto out_unlock;
-	}
-
-	if (dev->lirc_open) {
-		retval = -EBUSY;
-		goto out_unlock;
-	}
-
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		kfifo_reset_out(&dev->rawir);
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
-		kfifo_reset_out(&dev->scancodes);
-
-	dev->lirc_open++;
-	file->private_data = dev;
-
-	nonseekable_open(inode, file);
-	mutex_unlock(&dev->lock);
-
-	return 0;
-
-out_unlock:
-	mutex_unlock(&dev->lock);
-out_rc:
-	rc_close(dev);
-	return retval;
-}
-
-static int ir_lirc_close(struct inode *inode, struct file *file)
-{
-	struct rc_dev *dev = file->private_data;
-
-	mutex_lock(&dev->lock);
-	dev->lirc_open--;
-	mutex_unlock(&dev->lock);
-
-	rc_close(dev);
-
-	return 0;
-}
-
-static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
-				   size_t n, loff_t *ppos)
-{
-	struct rc_dev *dev = file->private_data;
-	unsigned int *txbuf = NULL;
-	struct ir_raw_event *raw = NULL;
-	ssize_t ret = -EINVAL;
-	size_t count;
-	ktime_t start;
-	s64 towait;
-	unsigned int duration = 0; /* signal duration in us */
-	int i;
-
-	if (!dev->registered)
-		return -ENODEV;
-
-	start = ktime_get();
-
-	if (!dev->tx_ir) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (dev->send_mode == LIRC_MODE_SCANCODE) {
-		struct lirc_scancode scan;
-
-		if (n != sizeof(scan))
-			return -EINVAL;
-
-		if (copy_from_user(&scan, buf, sizeof(scan)))
-			return -EFAULT;
-
-		if (scan.flags || scan.keycode || scan.timestamp)
-			return -EINVAL;
-
-		/*
-		 * The scancode field in lirc_scancode is 64-bit simply
-		 * to future-proof it, since there are IR protocols encode
-		 * use more than 32 bits. For now only 32-bit protocols
-		 * are supported.
-		 */
-		if (scan.scancode > U32_MAX ||
-		    !rc_validate_scancode(scan.rc_proto, scan.scancode))
-			return -EINVAL;
-
-		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
-		if (!raw)
-			return -ENOMEM;
-
-		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
-					     raw, LIRCBUF_SIZE);
-		if (ret < 0)
-			goto out;
-
-		count = ret;
-
-		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
-		if (!txbuf) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		for (i = 0; i < count; i++)
-			/* Convert from NS to US */
-			txbuf[i] = DIV_ROUND_UP(raw[i].duration, 1000);
-
-		if (dev->s_tx_carrier) {
-			int carrier = ir_raw_encode_carrier(scan.rc_proto);
-
-			if (carrier > 0)
-				dev->s_tx_carrier(dev, carrier);
-		}
-	} else {
-		if (n < sizeof(unsigned int) || n % sizeof(unsigned int))
-			return -EINVAL;
-
-		count = n / sizeof(unsigned int);
-		if (count > LIRCBUF_SIZE || count % 2 == 0)
-			return -EINVAL;
-
-		txbuf = memdup_user(buf, n);
-		if (IS_ERR(txbuf))
-			return PTR_ERR(txbuf);
-	}
-
-	for (i = 0; i < count; i++) {
-		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		duration += txbuf[i];
-	}
-
-	ret = dev->tx_ir(dev, txbuf, count);
-	if (ret < 0)
-		goto out;
-
-	if (dev->send_mode == LIRC_MODE_SCANCODE) {
-		ret = n;
-	} else {
-		for (duration = i = 0; i < ret; i++)
-			duration += txbuf[i];
-
-		ret *= sizeof(unsigned int);
-
-		/*
-		 * The lircd gap calculation expects the write function to
-		 * wait for the actual IR signal to be transmitted before
-		 * returning.
-		 */
-		towait = ktime_us_delta(ktime_add_us(start, duration),
-					ktime_get());
-		if (towait > 0) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(usecs_to_jiffies(towait));
-		}
-	}
-
-out:
-	kfree(txbuf);
-	kfree(raw);
-	return ret;
-}
-
-static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
-			unsigned long arg)
-{
-	struct rc_dev *dev = filep->private_data;
-	u32 __user *argp = (u32 __user *)(arg);
-	int ret = 0;
-	__u32 val = 0, tmp;
-
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		ret = get_user(val, argp);
-		if (ret)
-			return ret;
-	}
-
-	if (!dev->registered)
-		return -ENODEV;
-
-	switch (cmd) {
-	case LIRC_GET_FEATURES:
-		if (dev->driver_type == RC_DRIVER_SCANCODE)
-			val |= LIRC_CAN_REC_SCANCODE;
-
-		if (dev->driver_type == RC_DRIVER_IR_RAW) {
-			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
-			if (dev->rx_resolution)
-				val |= LIRC_CAN_GET_REC_RESOLUTION;
-		}
-
-		if (dev->tx_ir) {
-			val |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
-			if (dev->s_tx_mask)
-				val |= LIRC_CAN_SET_TRANSMITTER_MASK;
-			if (dev->s_tx_carrier)
-				val |= LIRC_CAN_SET_SEND_CARRIER;
-			if (dev->s_tx_duty_cycle)
-				val |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
-		}
-
-		if (dev->s_rx_carrier_range)
-			val |= LIRC_CAN_SET_REC_CARRIER |
-				LIRC_CAN_SET_REC_CARRIER_RANGE;
-
-		if (dev->s_learning_mode)
-			val |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
-
-		if (dev->s_carrier_report)
-			val |= LIRC_CAN_MEASURE_CARRIER;
-
-		if (dev->max_timeout)
-			val |= LIRC_CAN_SET_REC_TIMEOUT;
-
-		break;
-
-	/* mode support */
-	case LIRC_GET_REC_MODE:
-		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
-			return -ENOTTY;
-
-		val = dev->rec_mode;
-		break;
-
-	case LIRC_SET_REC_MODE:
-		switch (dev->driver_type) {
-		case RC_DRIVER_IR_RAW_TX:
-			return -ENOTTY;
-		case RC_DRIVER_SCANCODE:
-			if (val != LIRC_MODE_SCANCODE)
-				return -EINVAL;
-			break;
-		case RC_DRIVER_IR_RAW:
-			if (!(val == LIRC_MODE_MODE2 ||
-			      val == LIRC_MODE_SCANCODE))
-				return -EINVAL;
-			break;
-		}
-
-		dev->rec_mode = val;
-		dev->poll_mode = val;
-		return 0;
-
-	case LIRC_SET_POLL_MODES:
-		switch (dev->driver_type) {
-		case RC_DRIVER_IR_RAW_TX:
-			return -ENOTTY;
-		case RC_DRIVER_SCANCODE:
-			if (val != LIRC_MODE_SCANCODE)
-				return -EINVAL;
-			break;
-		case RC_DRIVER_IR_RAW:
-			if (val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE))
-				return -EINVAL;
-			break;
-		}
-
-		dev->poll_mode = val;
-		return 0;
-
-	case LIRC_GET_SEND_MODE:
-		if (!dev->tx_ir)
-			return -ENOTTY;
-
-		val = dev->send_mode;
-		break;
-
-	case LIRC_SET_SEND_MODE:
-		if (!dev->tx_ir)
-			return -ENOTTY;
-
-		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
-			return -EINVAL;
-
-		dev->send_mode = val;
-		return 0;
-
-	/* TX settings */
-	case LIRC_SET_TRANSMITTER_MASK:
-		if (!dev->s_tx_mask)
-			return -ENOTTY;
-
-		return dev->s_tx_mask(dev, val);
-
-	case LIRC_SET_SEND_CARRIER:
-		if (!dev->s_tx_carrier)
-			return -ENOTTY;
-
-		return dev->s_tx_carrier(dev, val);
-
-	case LIRC_SET_SEND_DUTY_CYCLE:
-		if (!dev->s_tx_duty_cycle)
-			return -ENOTTY;
-
-		if (val <= 0 || val >= 100)
-			return -EINVAL;
-
-		return dev->s_tx_duty_cycle(dev, val);
-
-	/* RX settings */
-	case LIRC_SET_REC_CARRIER:
-		if (!dev->s_rx_carrier_range)
-			return -ENOTTY;
-
-		if (val <= 0)
-			return -EINVAL;
-
-		return dev->s_rx_carrier_range(dev,
-					       dev->carrier_low,
-					       val);
-
-	case LIRC_SET_REC_CARRIER_RANGE:
-		if (!dev->s_rx_carrier_range)
-			return -ENOTTY;
-
-		if (val <= 0)
-			return -EINVAL;
-
-		dev->carrier_low = val;
-		return 0;
-
-	case LIRC_GET_REC_RESOLUTION:
-		if (!dev->rx_resolution)
-			return -ENOTTY;
-
-		val = dev->rx_resolution / 1000;
-		break;
-
-	case LIRC_SET_WIDEBAND_RECEIVER:
-		if (!dev->s_learning_mode)
-			return -ENOTTY;
-
-		return dev->s_learning_mode(dev, !!val);
-
-	case LIRC_SET_MEASURE_CARRIER_MODE:
-		if (!dev->s_carrier_report)
-			return -ENOTTY;
-
-		return dev->s_carrier_report(dev, !!val);
-
-	/* Generic timeout support */
-	case LIRC_GET_MIN_TIMEOUT:
-		if (!dev->max_timeout)
-			return -ENOTTY;
-		val = DIV_ROUND_UP(dev->min_timeout, 1000);
-		break;
-
-	case LIRC_GET_MAX_TIMEOUT:
-		if (!dev->max_timeout)
-			return -ENOTTY;
-		val = dev->max_timeout / 1000;
-		break;
-
-	case LIRC_SET_REC_TIMEOUT:
-		if (!dev->max_timeout)
-			return -ENOTTY;
-
-		/* Check for multiply overflow */
-		if (val > U32_MAX / 1000)
-			return -EINVAL;
-
-		tmp = val * 1000;
-
-		if (tmp < dev->min_timeout || tmp > dev->max_timeout)
-			return -EINVAL;
-
-		if (dev->s_timeout)
-			ret = dev->s_timeout(dev, tmp);
-		if (!ret)
-			dev->timeout = tmp;
-		break;
-
-	case LIRC_SET_REC_TIMEOUT_REPORTS:
-		if (!dev->timeout)
-			return -ENOTTY;
-
-		dev->send_timeout_reports = !!val;
-		break;
-
-	default:
-		return -ENOTTY;
-	}
-
-	if (_IOC_DIR(cmd) & _IOC_READ)
-		ret = put_user(val, argp);
-
-	return ret;
-}
-
-static unsigned int ir_lirc_poll(struct file *file,
-				 struct poll_table_struct *wait)
-{
-	struct rc_dev *rcdev = file->private_data;
-	unsigned int events = 0;
-
-	poll_wait(file, &rcdev->wait_poll, wait);
-
-	if (!rcdev->registered) {
-		events = POLLHUP | POLLERR;
-	} else if (rcdev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		if ((rcdev->poll_mode & LIRC_MODE_SCANCODE) &&
-		    !kfifo_is_empty(&rcdev->scancodes))
-			events |= POLLIN | POLLRDNORM;
-
-		if ((rcdev->poll_mode & LIRC_MODE_MODE2) &&
-		    !kfifo_is_empty(&rcdev->rawir))
-			events |= POLLIN | POLLRDNORM;
-	}
-
-	return events;
-}
-
-static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
-				  size_t length)
-{
-	struct rc_dev *rcdev = file->private_data;
-	unsigned int copied;
-	int ret;
-
-	if (length < sizeof(unsigned int) || length % sizeof(unsigned int))
-		return -EINVAL;
-
-	do {
-		if (kfifo_is_empty(&rcdev->rawir)) {
-			if (file->f_flags & O_NONBLOCK)
-				return -EAGAIN;
-
-			ret = wait_event_interruptible(rcdev->wait_poll,
-					!kfifo_is_empty(&rcdev->rawir) ||
-					!rcdev->registered);
-			if (ret)
-				return ret;
-		}
-
-		if (!rcdev->registered)
-			return -ENODEV;
-
-		mutex_lock(&rcdev->lock);
-		ret = kfifo_to_user(&rcdev->rawir, buffer, length, &copied);
-		mutex_unlock(&rcdev->lock);
-		if (ret)
-			return ret;
-	} while (copied == 0);
-
-	return copied;
-}
-
-static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
-				     size_t length)
-{
-	struct rc_dev *rcdev = file->private_data;
-	unsigned int copied;
-	int ret;
-
-	if (length < sizeof(struct lirc_scancode) ||
-	    length % sizeof(struct lirc_scancode))
-		return -EINVAL;
-
-	do {
-		if (kfifo_is_empty(&rcdev->scancodes)) {
-			if (file->f_flags & O_NONBLOCK)
-				return -EAGAIN;
-
-			ret = wait_event_interruptible(rcdev->wait_poll,
-					!kfifo_is_empty(&rcdev->scancodes) ||
-					!rcdev->registered);
-			if (ret)
-				return ret;
-		}
-
-		if (!rcdev->registered)
-			return -ENODEV;
-
-		mutex_lock(&rcdev->lock);
-		ret = kfifo_to_user(&rcdev->scancodes, buffer, length, &copied);
-		mutex_unlock(&rcdev->lock);
-		if (ret)
-			return ret;
-	} while (copied == 0);
-
-	return copied;
-}
-
-static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
-			    size_t length, loff_t *ppos)
-{
-	struct rc_dev *rcdev = file->private_data;
-
-	if (rcdev->driver_type == RC_DRIVER_IR_RAW_TX)
-		return -EINVAL;
-
-	if (!rcdev->registered)
-		return -ENODEV;
-
-	if (rcdev->rec_mode == LIRC_MODE_MODE2)
-		return ir_lirc_read_mode2(file, buffer, length);
-	else /* LIRC_MODE_SCANCODE */
-		return ir_lirc_read_scancode(file, buffer, length);
-}
-
-const struct file_operations lirc_fops = {
-	.owner		= THIS_MODULE,
-	.write		= ir_lirc_transmit_ir,
-	.unlocked_ioctl	= ir_lirc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ir_lirc_ioctl,
-#endif
-	.read		= ir_lirc_read,
-	.poll		= ir_lirc_poll,
-	.open		= ir_lirc_open,
-	.release	= ir_lirc_close,
-	.llseek		= no_llseek,
-};
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 04a2d521c441..5c0e6a3ea3d4 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -22,11 +22,14 @@
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 
 #include "rc-core-priv.h"
 #include <media/lirc.h>
 
 #define LOGHEAD		"lirc_dev (%s[%d]): "
+#define LIRCBUF_SIZE	256
 
 static dev_t lirc_base_dev;
 
@@ -36,6 +39,621 @@ static DEFINE_IDA(lirc_ida);
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
 
+/**
+ * ir_lirc_raw_event() - Send raw IR data to lirc to be relayed to userspace
+ *
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ */
+void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	int sample;
+
+	/* Packet start */
+	if (ev.reset) {
+		/*
+		 * Userspace expects a long space event before the start of
+		 * the signal to use as a sync.  This may be done with repeat
+		 * packets and normal samples.  But if a reset has been sent
+		 * then we assume that a long time has passed, so we send a
+		 * space with the maximum time value.
+		 */
+		sample = LIRC_SPACE(LIRC_VALUE_MASK);
+		IR_dprintk(2, "delivering reset sync space to lirc_dev\n");
+
+	/* Carrier reports */
+	} else if (ev.carrier_report) {
+		sample = LIRC_FREQUENCY(ev.carrier);
+		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
+
+	/* Packet end */
+	} else if (ev.timeout) {
+		if (dev->gap)
+			return;
+
+		dev->gap_start = ktime_get();
+		dev->gap = true;
+		dev->gap_duration = ev.duration;
+
+		if (!dev->send_timeout_reports)
+			return;
+
+		sample = LIRC_TIMEOUT(ev.duration / 1000);
+		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
+
+	/* Normal sample */
+	} else {
+		if (dev->gap) {
+			dev->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
+							 dev->gap_start));
+
+			/* Convert to ms and cap by LIRC_VALUE_MASK */
+			do_div(dev->gap_duration, 1000);
+			dev->gap_duration = min_t(u64, dev->gap_duration,
+						  LIRC_VALUE_MASK);
+
+			kfifo_put(&dev->rawir, LIRC_SPACE(dev->gap_duration));
+			dev->gap = false;
+		}
+
+		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
+					LIRC_SPACE(ev.duration / 1000);
+		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
+			   TO_US(ev.duration), TO_STR(ev.pulse));
+	}
+
+	kfifo_put(&dev->rawir, sample);
+	wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
+}
+
+/**
+ * ir_lirc_scancode_event() - Send scancode data to lirc to be relayed to
+ *		userspace
+ * @dev:	the struct rc_dev descriptor of the device
+ * @lsc		the struct lirc_scancode describing the decoded scancode
+ */
+void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc)
+{
+	lsc->timestamp = ktime_get_ns();
+
+	if (kfifo_put(&dev->scancodes, *lsc))
+		wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
+}
+EXPORT_SYMBOL_GPL(ir_lirc_scancode_event);
+
+static int ir_lirc_open(struct inode *inode, struct file *file)
+{
+	struct rc_dev *dev = container_of(inode->i_cdev, struct rc_dev,
+					  lirc_cdev);
+	int retval;
+
+	retval = rc_open(dev);
+	if (retval)
+		return retval;
+
+	retval = mutex_lock_interruptible(&dev->lock);
+	if (retval)
+		goto out_rc;
+
+	if (!dev->registered) {
+		retval = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (dev->lirc_open) {
+		retval = -EBUSY;
+		goto out_unlock;
+	}
+
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		kfifo_reset_out(&dev->rawir);
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		kfifo_reset_out(&dev->scancodes);
+
+	dev->lirc_open++;
+	file->private_data = dev;
+
+	nonseekable_open(inode, file);
+	mutex_unlock(&dev->lock);
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&dev->lock);
+out_rc:
+	rc_close(dev);
+	return retval;
+}
+
+static int ir_lirc_close(struct inode *inode, struct file *file)
+{
+	struct rc_dev *dev = file->private_data;
+
+	mutex_lock(&dev->lock);
+	dev->lirc_open--;
+	mutex_unlock(&dev->lock);
+
+	rc_close(dev);
+
+	return 0;
+}
+
+static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
+				   size_t n, loff_t *ppos)
+{
+	struct rc_dev *dev = file->private_data;
+	unsigned int *txbuf = NULL;
+	struct ir_raw_event *raw = NULL;
+	ssize_t ret = -EINVAL;
+	size_t count;
+	ktime_t start;
+	s64 towait;
+	unsigned int duration = 0; /* signal duration in us */
+	int i;
+
+	if (!dev->registered)
+		return -ENODEV;
+
+	start = ktime_get();
+
+	if (!dev->tx_ir) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (dev->send_mode == LIRC_MODE_SCANCODE) {
+		struct lirc_scancode scan;
+
+		if (n != sizeof(scan))
+			return -EINVAL;
+
+		if (copy_from_user(&scan, buf, sizeof(scan)))
+			return -EFAULT;
+
+		if (scan.flags || scan.keycode || scan.timestamp)
+			return -EINVAL;
+
+		/*
+		 * The scancode field in lirc_scancode is 64-bit simply
+		 * to future-proof it, since there are IR protocols encode
+		 * use more than 32 bits. For now only 32-bit protocols
+		 * are supported.
+		 */
+		if (scan.scancode > U32_MAX ||
+		    !rc_validate_scancode(scan.rc_proto, scan.scancode))
+			return -EINVAL;
+
+		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
+		if (!raw)
+			return -ENOMEM;
+
+		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
+					     raw, LIRCBUF_SIZE);
+		if (ret < 0)
+			goto out;
+
+		count = ret;
+
+		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
+		if (!txbuf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < count; i++)
+			/* Convert from NS to US */
+			txbuf[i] = DIV_ROUND_UP(raw[i].duration, 1000);
+
+		if (dev->s_tx_carrier) {
+			int carrier = ir_raw_encode_carrier(scan.rc_proto);
+
+			if (carrier > 0)
+				dev->s_tx_carrier(dev, carrier);
+		}
+	} else {
+		if (n < sizeof(unsigned int) || n % sizeof(unsigned int))
+			return -EINVAL;
+
+		count = n / sizeof(unsigned int);
+		if (count > LIRCBUF_SIZE || count % 2 == 0)
+			return -EINVAL;
+
+		txbuf = memdup_user(buf, n);
+		if (IS_ERR(txbuf))
+			return PTR_ERR(txbuf);
+	}
+
+	for (i = 0; i < count; i++) {
+		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		duration += txbuf[i];
+	}
+
+	ret = dev->tx_ir(dev, txbuf, count);
+	if (ret < 0)
+		goto out;
+
+	if (dev->send_mode == LIRC_MODE_SCANCODE) {
+		ret = n;
+	} else {
+		for (duration = i = 0; i < ret; i++)
+			duration += txbuf[i];
+
+		ret *= sizeof(unsigned int);
+
+		/*
+		 * The lircd gap calculation expects the write function to
+		 * wait for the actual IR signal to be transmitted before
+		 * returning.
+		 */
+		towait = ktime_us_delta(ktime_add_us(start, duration),
+					ktime_get());
+		if (towait > 0) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(usecs_to_jiffies(towait));
+		}
+	}
+
+out:
+	kfree(txbuf);
+	kfree(raw);
+	return ret;
+}
+
+static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct rc_dev *dev = filep->private_data;
+	u32 __user *argp = (u32 __user *)(arg);
+	int ret = 0;
+	__u32 val = 0, tmp;
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE) {
+		ret = get_user(val, argp);
+		if (ret)
+			return ret;
+	}
+
+	if (!dev->registered)
+		return -ENODEV;
+
+	switch (cmd) {
+	case LIRC_GET_FEATURES:
+		if (dev->driver_type == RC_DRIVER_SCANCODE)
+			val |= LIRC_CAN_REC_SCANCODE;
+
+		if (dev->driver_type == RC_DRIVER_IR_RAW) {
+			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
+			if (dev->rx_resolution)
+				val |= LIRC_CAN_GET_REC_RESOLUTION;
+		}
+
+		if (dev->tx_ir) {
+			val |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
+			if (dev->s_tx_mask)
+				val |= LIRC_CAN_SET_TRANSMITTER_MASK;
+			if (dev->s_tx_carrier)
+				val |= LIRC_CAN_SET_SEND_CARRIER;
+			if (dev->s_tx_duty_cycle)
+				val |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
+		}
+
+		if (dev->s_rx_carrier_range)
+			val |= LIRC_CAN_SET_REC_CARRIER |
+				LIRC_CAN_SET_REC_CARRIER_RANGE;
+
+		if (dev->s_learning_mode)
+			val |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
+
+		if (dev->s_carrier_report)
+			val |= LIRC_CAN_MEASURE_CARRIER;
+
+		if (dev->max_timeout)
+			val |= LIRC_CAN_SET_REC_TIMEOUT;
+
+		break;
+
+	/* mode support */
+	case LIRC_GET_REC_MODE:
+		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+			return -ENOTTY;
+
+		val = dev->rec_mode;
+		break;
+
+	case LIRC_SET_REC_MODE:
+		switch (dev->driver_type) {
+		case RC_DRIVER_IR_RAW_TX:
+			return -ENOTTY;
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (!(val == LIRC_MODE_MODE2 ||
+			      val == LIRC_MODE_SCANCODE))
+				return -EINVAL;
+			break;
+		}
+
+		dev->rec_mode = val;
+		dev->poll_mode = val;
+		return 0;
+
+	case LIRC_SET_POLL_MODES:
+		switch (dev->driver_type) {
+		case RC_DRIVER_IR_RAW_TX:
+			return -ENOTTY;
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE))
+				return -EINVAL;
+			break;
+		}
+
+		dev->poll_mode = val;
+		return 0;
+
+	case LIRC_GET_SEND_MODE:
+		if (!dev->tx_ir)
+			return -ENOTTY;
+
+		val = dev->send_mode;
+		break;
+
+	case LIRC_SET_SEND_MODE:
+		if (!dev->tx_ir)
+			return -ENOTTY;
+
+		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
+			return -EINVAL;
+
+		dev->send_mode = val;
+		return 0;
+
+	/* TX settings */
+	case LIRC_SET_TRANSMITTER_MASK:
+		if (!dev->s_tx_mask)
+			return -ENOTTY;
+
+		return dev->s_tx_mask(dev, val);
+
+	case LIRC_SET_SEND_CARRIER:
+		if (!dev->s_tx_carrier)
+			return -ENOTTY;
+
+		return dev->s_tx_carrier(dev, val);
+
+	case LIRC_SET_SEND_DUTY_CYCLE:
+		if (!dev->s_tx_duty_cycle)
+			return -ENOTTY;
+
+		if (val <= 0 || val >= 100)
+			return -EINVAL;
+
+		return dev->s_tx_duty_cycle(dev, val);
+
+	/* RX settings */
+	case LIRC_SET_REC_CARRIER:
+		if (!dev->s_rx_carrier_range)
+			return -ENOTTY;
+
+		if (val <= 0)
+			return -EINVAL;
+
+		return dev->s_rx_carrier_range(dev,
+					       dev->carrier_low,
+					       val);
+
+	case LIRC_SET_REC_CARRIER_RANGE:
+		if (!dev->s_rx_carrier_range)
+			return -ENOTTY;
+
+		if (val <= 0)
+			return -EINVAL;
+
+		dev->carrier_low = val;
+		return 0;
+
+	case LIRC_GET_REC_RESOLUTION:
+		if (!dev->rx_resolution)
+			return -ENOTTY;
+
+		val = dev->rx_resolution / 1000;
+		break;
+
+	case LIRC_SET_WIDEBAND_RECEIVER:
+		if (!dev->s_learning_mode)
+			return -ENOTTY;
+
+		return dev->s_learning_mode(dev, !!val);
+
+	case LIRC_SET_MEASURE_CARRIER_MODE:
+		if (!dev->s_carrier_report)
+			return -ENOTTY;
+
+		return dev->s_carrier_report(dev, !!val);
+
+	/* Generic timeout support */
+	case LIRC_GET_MIN_TIMEOUT:
+		if (!dev->max_timeout)
+			return -ENOTTY;
+		val = DIV_ROUND_UP(dev->min_timeout, 1000);
+		break;
+
+	case LIRC_GET_MAX_TIMEOUT:
+		if (!dev->max_timeout)
+			return -ENOTTY;
+		val = dev->max_timeout / 1000;
+		break;
+
+	case LIRC_SET_REC_TIMEOUT:
+		if (!dev->max_timeout)
+			return -ENOTTY;
+
+		/* Check for multiply overflow */
+		if (val > U32_MAX / 1000)
+			return -EINVAL;
+
+		tmp = val * 1000;
+
+		if (tmp < dev->min_timeout || tmp > dev->max_timeout)
+			return -EINVAL;
+
+		if (dev->s_timeout)
+			ret = dev->s_timeout(dev, tmp);
+		if (!ret)
+			dev->timeout = tmp;
+		break;
+
+	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		if (!dev->timeout)
+			return -ENOTTY;
+
+		dev->send_timeout_reports = !!val;
+		break;
+
+	default:
+		return -ENOTTY;
+	}
+
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		ret = put_user(val, argp);
+
+	return ret;
+}
+
+static unsigned int ir_lirc_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct rc_dev *rcdev = file->private_data;
+	unsigned int events = 0;
+
+	poll_wait(file, &rcdev->wait_poll, wait);
+
+	if (!rcdev->registered) {
+		events = POLLHUP | POLLERR;
+	} else if (rcdev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		if ((rcdev->poll_mode & LIRC_MODE_SCANCODE) &&
+		    !kfifo_is_empty(&rcdev->scancodes))
+			events |= POLLIN | POLLRDNORM;
+
+		if ((rcdev->poll_mode & LIRC_MODE_MODE2) &&
+		    !kfifo_is_empty(&rcdev->rawir))
+			events |= POLLIN | POLLRDNORM;
+	}
+
+	return events;
+}
+
+static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
+				  size_t length)
+{
+	struct rc_dev *rcdev = file->private_data;
+	unsigned int copied;
+	int ret;
+
+	if (length < sizeof(unsigned int) || length % sizeof(unsigned int))
+		return -EINVAL;
+
+	do {
+		if (kfifo_is_empty(&rcdev->rawir)) {
+			if (file->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			ret = wait_event_interruptible(rcdev->wait_poll,
+					!kfifo_is_empty(&rcdev->rawir) ||
+					!rcdev->registered);
+			if (ret)
+				return ret;
+		}
+
+		if (!rcdev->registered)
+			return -ENODEV;
+
+		mutex_lock(&rcdev->lock);
+		ret = kfifo_to_user(&rcdev->rawir, buffer, length, &copied);
+		mutex_unlock(&rcdev->lock);
+		if (ret)
+			return ret;
+	} while (copied == 0);
+
+	return copied;
+}
+
+static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
+				     size_t length)
+{
+	struct rc_dev *rcdev = file->private_data;
+	unsigned int copied;
+	int ret;
+
+	if (length < sizeof(struct lirc_scancode) ||
+	    length % sizeof(struct lirc_scancode))
+		return -EINVAL;
+
+	do {
+		if (kfifo_is_empty(&rcdev->scancodes)) {
+			if (file->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			ret = wait_event_interruptible(rcdev->wait_poll,
+					!kfifo_is_empty(&rcdev->scancodes) ||
+					!rcdev->registered);
+			if (ret)
+				return ret;
+		}
+
+		if (!rcdev->registered)
+			return -ENODEV;
+
+		mutex_lock(&rcdev->lock);
+		ret = kfifo_to_user(&rcdev->scancodes, buffer, length, &copied);
+		mutex_unlock(&rcdev->lock);
+		if (ret)
+			return ret;
+	} while (copied == 0);
+
+	return copied;
+}
+
+static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
+			    size_t length, loff_t *ppos)
+{
+	struct rc_dev *rcdev = file->private_data;
+
+	if (rcdev->driver_type == RC_DRIVER_IR_RAW_TX)
+		return -EINVAL;
+
+	if (!rcdev->registered)
+		return -ENODEV;
+
+	if (rcdev->rec_mode == LIRC_MODE_MODE2)
+		return ir_lirc_read_mode2(file, buffer, length);
+	else /* LIRC_MODE_SCANCODE */
+		return ir_lirc_read_scancode(file, buffer, length);
+}
+
+static const struct file_operations lirc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= ir_lirc_transmit_ir,
+	.unlocked_ioctl	= ir_lirc_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= ir_lirc_ioctl,
+#endif
+	.read		= ir_lirc_read,
+	.poll		= ir_lirc_poll,
+	.open		= ir_lirc_open,
+	.release	= ir_lirc_close,
+	.llseek		= no_llseek,
+};
+
 static void lirc_release_device(struct device *ld)
 {
 	struct rc_dev *rcdev = container_of(ld, struct rc_dev, lirc_dev);
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 950de264666f..063a8c0457bd 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -289,8 +289,6 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
 void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
-
-extern const struct file_operations lirc_fops;
 #else
 static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}
-- 
2.13.6
