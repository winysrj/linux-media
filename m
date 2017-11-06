Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39215 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752116AbdKFKkX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 05:40:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] media: lirc: improve locking
Date: Mon,  6 Nov 2017 10:40:19 +0000
Message-Id: <4389380ed5dc50cfad76db8ccd0803edcbe8f89d.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once rc_unregister_device() has been called, no driver function
should be called.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 255 +++++++++++++++++++++++++-------------------
 1 file changed, 147 insertions(+), 108 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 32beecf103cc..6b0053d4f041 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -240,15 +240,21 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	struct rc_dev *dev = fh->rc;
 	unsigned int *txbuf = NULL;
 	struct ir_raw_event *raw = NULL;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 	size_t count;
 	ktime_t start;
 	s64 towait;
 	unsigned int duration = 0; /* signal duration in us */
 	int i;
 
-	if (!dev->registered)
-		return -ENODEV;
+	ret = mutex_lock_interruptible(&dev->lock);
+	if (ret)
+		return ret;
+
+	if (!dev->registered) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	start = ktime_get();
 
@@ -260,14 +266,20 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (fh->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
-		if (n != sizeof(scan))
-			return -EINVAL;
+		if (n != sizeof(scan)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (copy_from_user(&scan, buf, sizeof(scan)))
-			return -EFAULT;
+		if (copy_from_user(&scan, buf, sizeof(scan))) {
+			ret = -EFAULT;
+			goto out;
+		}
 
-		if (scan.flags || scan.keycode || scan.timestamp)
-			return -EINVAL;
+		if (scan.flags || scan.keycode || scan.timestamp) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		/*
 		 * The scancode field in lirc_scancode is 64-bit simply
@@ -276,12 +288,16 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		 * are supported.
 		 */
 		if (scan.scancode > U32_MAX ||
-		    !rc_validate_scancode(scan.rc_proto, scan.scancode))
-			return -EINVAL;
+		    !rc_validate_scancode(scan.rc_proto, scan.scancode)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		raw = kmalloc_array(LIRCBUF_SIZE, sizeof(*raw), GFP_KERNEL);
-		if (!raw)
-			return -ENOMEM;
+		if (!raw) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
 					     raw, LIRCBUF_SIZE);
@@ -307,16 +323,22 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				dev->s_tx_carrier(dev, carrier);
 		}
 	} else {
-		if (n < sizeof(unsigned int) || n % sizeof(unsigned int))
-			return -EINVAL;
+		if (n < sizeof(unsigned int) || n % sizeof(unsigned int)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		count = n / sizeof(unsigned int);
-		if (count > LIRCBUF_SIZE || count % 2 == 0)
-			return -EINVAL;
+		if (count > LIRCBUF_SIZE || count % 2 == 0) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		txbuf = memdup_user(buf, n);
-		if (IS_ERR(txbuf))
-			return PTR_ERR(txbuf);
+		if (IS_ERR(txbuf)) {
+			ret = PTR_ERR(txbuf);
+			goto out;
+		}
 	}
 
 	for (i = 0; i < count; i++) {
@@ -354,6 +376,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	}
 
 out:
+	mutex_unlock(&dev->lock);
 	kfree(txbuf);
 	kfree(raw);
 	return ret;
@@ -365,8 +388,8 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 	struct lirc_fh *fh = file->private_data;
 	struct rc_dev *dev = fh->rc;
 	u32 __user *argp = (u32 __user *)(arg);
-	int ret = 0;
-	__u32 val = 0, tmp;
+	u32 val = 0;
+	int ret;
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, argp);
@@ -374,8 +397,14 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 			return ret;
 	}
 
-	if (!dev->registered)
-		return -ENODEV;
+	ret = mutex_lock_interruptible(&dev->lock);
+	if (ret)
+		return ret;
+
+	if (!dev->registered) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
@@ -416,173 +445,183 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 	/* mode support */
 	case LIRC_GET_REC_MODE:
 		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
-			return -ENOTTY;
-
-		val = fh->rec_mode;
+			ret = -ENOTTY;
+		else
+			val = fh->rec_mode;
 		break;
 
 	case LIRC_SET_REC_MODE:
 		switch (dev->driver_type) {
 		case RC_DRIVER_IR_RAW_TX:
-			return -ENOTTY;
+			ret = -ENOTTY;
+			break;
 		case RC_DRIVER_SCANCODE:
 			if (val != LIRC_MODE_SCANCODE)
-				return -EINVAL;
+				ret = -EINVAL;
 			break;
 		case RC_DRIVER_IR_RAW:
 			if (!(val == LIRC_MODE_MODE2 ||
 			      val == LIRC_MODE_SCANCODE))
-				return -EINVAL;
+				ret = -EINVAL;
 			break;
 		}
 
-		fh->rec_mode = val;
-		fh->poll_mode = val;
-		return 0;
+		if (!ret) {
+			fh->rec_mode = val;
+			fh->poll_mode = val;
+		}
+		break;
 
 	case LIRC_SET_POLL_MODES:
 		switch (dev->driver_type) {
 		case RC_DRIVER_IR_RAW_TX:
-			return -ENOTTY;
+			ret = -ENOTTY;
+			break;
 		case RC_DRIVER_SCANCODE:
 			if (val != LIRC_MODE_SCANCODE)
-				return -EINVAL;
+				ret = -EINVAL;
 			break;
 		case RC_DRIVER_IR_RAW:
 			if (val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE))
-				return -EINVAL;
+				ret = -EINVAL;
 			break;
 		}
 
-		fh->poll_mode = val;
-		return 0;
+		if (!ret)
+			fh->poll_mode = val;
+
+		break;
 
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir)
-			return -ENOTTY;
-
-		val = fh->send_mode;
+			ret = -ENOTTY;
+		else
+			val = fh->send_mode;
 		break;
 
 	case LIRC_SET_SEND_MODE:
 		if (!dev->tx_ir)
-			return -ENOTTY;
-
-		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
-			return -EINVAL;
-
-		fh->send_mode = val;
-		return 0;
+			ret = -ENOTTY;
+		else if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
+			ret = -EINVAL;
+		else
+			fh->send_mode = val;
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
-					       fh->carrier_low,
-					       val);
+			ret = -ENOTTY;
+		else if (val <= 0)
+			ret = -EINVAL;
+		else
+			ret = dev->s_rx_carrier_range(dev, fh->carrier_low,
+						      val);
+		break;
 
 	case LIRC_SET_REC_CARRIER_RANGE:
 		if (!dev->s_rx_carrier_range)
-			return -ENOTTY;
-
-		if (val <= 0)
-			return -EINVAL;
-
-		fh->carrier_low = val;
-		return 0;
+			ret = -ENOTTY;
+		else if (val <= 0)
+			ret = -EINVAL;
+		else
+			fh->carrier_low = val;
+		break;
 
 	case LIRC_GET_REC_RESOLUTION:
 		if (!dev->rx_resolution)
-			return -ENOTTY;
-
-		val = dev->rx_resolution / 1000;
+			ret = -ENOTTY;
+		else
+			val = dev->rx_resolution / 1000;
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
+		if (!dev->max_timeout) {
+			ret = -ENOTTY;
+		} else if (val > U32_MAX / 1000) {
+			/* Check for multiply overflow */
+			ret = -EINVAL;
+		} else {
+			u32 tmp = val * 1000;
+
+			if (tmp < dev->min_timeout || tmp > dev->max_timeout)
+				ret = -EINVAL;
+			else if (dev->s_timeout)
+				ret = dev->s_timeout(dev, tmp);
+			else if (!ret)
+				dev->timeout = tmp;
+		}
 		break;
 
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
 		if (!dev->timeout)
-			return -ENOTTY;
-
-		fh->send_timeout_reports = !!val;
+			ret = -ENOTTY;
+		else
+			fh->send_timeout_reports = !!val;
 		break;
 
 	default:
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
 
-	if (_IOC_DIR(cmd) & _IOC_READ)
+	if (!ret && _IOC_DIR(cmd) & _IOC_READ)
 		ret = put_user(val, argp);
 
+out:
+	mutex_unlock(&dev->lock);
 	return ret;
 }
 
-- 
2.13.6
