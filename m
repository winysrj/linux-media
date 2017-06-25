Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56453 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdFYMcs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:48 -0400
Subject: [PATCH 17/19] ir-lirc-codec: merge lirc_dev_fop_ioctl into
 ir_lirc_ioctl
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:41 +0200
Message-ID: <149839396115.28811.5850743398715927848.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir_lirc_ioctl() is the only caller of lirc_dev_fop_ioctl() so merging the
latter into the former makes the code more readable. At the same time, this
allows the locking situation in ir_lirc_ioctl() to be fixed by holding
the lirc_dev mutex during the whole ioctl call.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |  168 ++++++++++++++++++++++++--------------
 drivers/media/rc/lirc_dev.c      |   59 -------------
 include/media/lirc_dev.h         |    1 
 3 files changed, 105 insertions(+), 123 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index ba20a4ce9cbc..f914a3d5a468 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -178,12 +178,13 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 }
 
 static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
-			unsigned long arg)
+			  unsigned long arg)
 {
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
+	struct lirc_dev *d;
 	u32 __user *argp = (u32 __user *)(arg);
-	int ret = 0;
+	int ret;
 	__u32 val = 0, tmp;
 
 	lirc = lirc_get_pdata(filep);
@@ -194,10 +195,23 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	if (!dev)
 		return -EFAULT;
 
+	d = lirc->ldev;
+	if (!d)
+		return -EFAULT;
+
+	ret = mutex_lock_interruptible(&d->mutex);
+	if (ret)
+		return ret;
+
+	if (!d->attached) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, argp);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	switch (cmd) {
@@ -205,125 +219,153 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	/* legacy support */
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir)
-			return -ENOTTY;
-
-		val = LIRC_MODE_PULSE;
+			ret = -ENOTTY;
+		else
+			val = LIRC_MODE_PULSE;
 		break;
 
 	case LIRC_SET_SEND_MODE:
 		if (!dev->tx_ir)
-			return -ENOTTY;
-
-		if (val != LIRC_MODE_PULSE)
-			return -EINVAL;
-		return 0;
+			ret = -ENOTTY;
+		else if (val != LIRC_MODE_PULSE)
+			ret = -EINVAL;
+		break;
 
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
 		if (!dev->s_tx_mask)
-			return -ENOTTY;
-
-		return dev->s_tx_mask(dev, val);
+			ret = -ENOTTY;
+		else
+			ret = dev->s_tx_mask(dev, val);
+		break;
 
 	case LIRC_SET_SEND_CARRIER:
 		if (!dev->s_tx_carrier)
-			return -ENOTTY;
-
-		return dev->s_tx_carrier(dev, val);
+			ret = -ENOTTY;
+		else
+			ret = dev->s_tx_carrier(dev, val);
+		break;
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
 		if (!dev->s_tx_duty_cycle)
-			return -ENOTTY;
-
-		if (val <= 0 || val >= 100)
-			return -EINVAL;
-
-		return dev->s_tx_duty_cycle(dev, val);
+			ret = -ENOTTY;
+		else if (val <= 0 || val >= 100)
+			ret = -EINVAL;
+		else
+			ret = dev->s_tx_duty_cycle(dev, val);
+		break;
 
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
 		if (!dev->s_rx_carrier_range)
-			return -ENOTTY;
-
-		if (val <= 0)
-			return -EINVAL;
-
-		return dev->s_rx_carrier_range(dev,
-					       dev->raw->lirc.carrier_low,
-					       val);
+			ret = -ENOTTY;
+		else if (val <= 0)
+			ret = -EINVAL;
+		else
+			ret = dev->s_rx_carrier_range(dev,
+						      dev->raw->lirc.carrier_low,
+						      val);
+		break;
 
 	case LIRC_SET_REC_CARRIER_RANGE:
 		if (!dev->s_rx_carrier_range)
-			return -ENOTTY;
-
-		if (val <= 0)
-			return -EINVAL;
-
-		dev->raw->lirc.carrier_low = val;
-		return 0;
+			ret = -ENOTTY;
+		else if (val <= 0)
+			ret = -EINVAL;
+		else
+			dev->raw->lirc.carrier_low = val;
+		break;
 
 	case LIRC_GET_REC_RESOLUTION:
 		if (!dev->rx_resolution)
-			return -ENOTTY;
-
-		val = dev->rx_resolution;
+			ret = -ENOTTY;
+		else
+			val = dev->rx_resolution;
 		break;
 
 	case LIRC_SET_WIDEBAND_RECEIVER:
 		if (!dev->s_learning_mode)
-			return -ENOTTY;
-
-		return dev->s_learning_mode(dev, !!val);
+			ret = -ENOTTY;
+		else
+			ret = dev->s_learning_mode(dev, !!val);
+		break;
 
 	case LIRC_SET_MEASURE_CARRIER_MODE:
 		if (!dev->s_carrier_report)
-			return -ENOTTY;
-
-		return dev->s_carrier_report(dev, !!val);
+			ret = -ENOTTY;
+		else
+			ret = dev->s_carrier_report(dev, !!val);
+		break;
 
 	/* Generic timeout support */
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!dev->max_timeout)
-			return -ENOTTY;
-		val = DIV_ROUND_UP(dev->min_timeout, 1000);
+			ret = -ENOTTY;
+		else
+			val = DIV_ROUND_UP(dev->min_timeout, 1000);
 		break;
 
 	case LIRC_GET_MAX_TIMEOUT:
 		if (!dev->max_timeout)
-			return -ENOTTY;
-		val = dev->max_timeout / 1000;
+			ret = -ENOTTY;
+		else
+			val = dev->max_timeout / 1000;
 		break;
 
 	case LIRC_SET_REC_TIMEOUT:
-		if (!dev->max_timeout)
-			return -ENOTTY;
-
 		tmp = val * 1000;
 
-		if (tmp < dev->min_timeout ||
-		    tmp > dev->max_timeout)
-				return -EINVAL;
-
-		if (dev->s_timeout)
+		if (!dev->max_timeout)
+			ret = -ENOTTY;
+		else if (tmp < dev->min_timeout)
+			ret = -EINVAL;
+		else if (tmp > dev->max_timeout)
+			ret = -EINVAL;
+		else if (dev->s_timeout)
 			ret = dev->s_timeout(dev, tmp);
+
 		if (!ret)
 			dev->timeout = tmp;
 		break;
 
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
 		if (!dev->timeout)
-			return -ENOTTY;
+			ret = -ENOTTY;
+		else
+			lirc->send_timeout_reports = !!val;
+		break;
+
+	case LIRC_GET_FEATURES:
+		val = d->features;
+		break;
 
-		lirc->send_timeout_reports = !!val;
+	case LIRC_GET_REC_MODE:
+		if (!LIRC_CAN_REC(d->features))
+			ret = -ENOTTY;
+		else
+			val = LIRC_REC2MODE(d->features & LIRC_CAN_REC_MASK);
+		break;
+
+	case LIRC_SET_REC_MODE:
+		if (!LIRC_CAN_REC(d->features))
+			ret = -ENOTTY;
+		else if (!(LIRC_MODE2REC(val) & d->features))
+			ret = -EINVAL;
+		break;
+
+	case LIRC_GET_LENGTH:
+		val = d->code_length;
 		break;
 
 	default:
-		return lirc_dev_fop_ioctl(filep, cmd, arg);
+		ret = -ENOTTY;
 	}
 
-	if (_IOC_DIR(cmd) & _IOC_READ)
+	if (!ret && (_IOC_DIR(cmd) & _IOC_READ))
 		ret = put_user(val, argp);
 
+out:
+	mutex_unlock(&d->mutex);
 	return ret;
 }
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 4ad08d3d4e2f..278d9b34d382 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/sched/signal.h>
-#include <linux/ioctl.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
@@ -290,64 +289,6 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 }
 EXPORT_SYMBOL(lirc_dev_fop_poll);
 
-long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct lirc_dev *d = file->private_data;
-	__u32 mode;
-	int result;
-
-	dev_dbg(&d->dev, LOGHEAD "ioctl called (0x%x)\n", d->name, d->minor, cmd);
-
-	result = mutex_lock_interruptible(&d->mutex);
-	if (result)
-		return result;
-
-	if (!d->attached) {
-		result = -ENODEV;
-		goto out;
-	}
-
-	switch (cmd) {
-	case LIRC_GET_FEATURES:
-		result = put_user(d->features, (__u32 __user *)arg);
-		break;
-	case LIRC_GET_REC_MODE:
-		if (!LIRC_CAN_REC(d->features)) {
-			result = -ENOTTY;
-			break;
-		}
-
-		result = put_user(LIRC_REC2MODE
-				  (d->features & LIRC_CAN_REC_MASK),
-				  (__u32 __user *)arg);
-		break;
-	case LIRC_SET_REC_MODE:
-		if (!LIRC_CAN_REC(d->features)) {
-			result = -ENOTTY;
-			break;
-		}
-
-		result = get_user(mode, (__u32 __user *)arg);
-		if (!result && !(LIRC_MODE2REC(mode) & d->features))
-			result = -EINVAL;
-		/*
-		 * FIXME: We should actually set the mode somehow but
-		 * for now, lirc_serial doesn't support mode changing either
-		 */
-		break;
-	case LIRC_GET_LENGTH:
-		result = put_user(d->code_length, (__u32 __user *)arg);
-		break;
-	default:
-		result = -ENOTTY;
-	}
-
-out:
-	mutex_unlock(&d->mutex);
-	return result;
-}
-EXPORT_SYMBOL(lirc_dev_fop_ioctl);
-
 ssize_t lirc_dev_fop_read(struct file *file,
 			  char __user *buffer,
 			  size_t length,
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 63dd88b02479..e1bf7ef20fdc 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -184,7 +184,6 @@ void *lirc_get_pdata(struct file *file);
 int lirc_dev_fop_open(struct inode *inode, struct file *file);
 int lirc_dev_fop_close(struct inode *inode, struct file *file);
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
-long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 ssize_t lirc_dev_fop_read(struct file *file, char __user *buffer, size_t length,
 			  loff_t *ppos);
 #endif
