Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52189 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755354AbdJJHSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:08 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 12/26] media: lirc: merge lirc_dev_fop_ioctl and ir_lirc_ioctl
Date: Tue, 10 Oct 2017 08:18:06 +0100
Message-Id: <0704ff79fddb2b1aa8969d2bd826df981f841c54.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate lirc features when necessary, and add LIRC_{S,G}ET_REC_MODE
cases to ir_lirc_ioctl.

This makes lirc_dev_fop_ioctl() unnecessary since all cases are
already handled by ir_lirc_ioctl().

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 85 +++++++++++++++++++++++-----------------
 drivers/media/rc/lirc_dev.c      | 62 ++---------------------------
 include/media/lirc_dev.h         |  4 --
 3 files changed, 53 insertions(+), 98 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index d9406fdbc9a3..05b2c1d5c0e6 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -236,8 +236,57 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	}
 
 	switch (cmd) {
+	case LIRC_GET_FEATURES:
+		if (dev->driver_type == RC_DRIVER_IR_RAW) {
+			val |= LIRC_CAN_REC_MODE2;
+			if (dev->rx_resolution)
+				val |= LIRC_CAN_GET_REC_RESOLUTION;
+		}
+
+		if (dev->tx_scancode)
+			val |= LIRC_CAN_SEND_SCANCODE;
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
 
 	/* mode support */
+	case LIRC_GET_REC_MODE:
+		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+			return -ENOTTY;
+
+		val = LIRC_MODE_MODE2;
+		break;
+
+	case LIRC_SET_REC_MODE:
+		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+			return -ENOTTY;
+
+		if (val != LIRC_MODE_MODE2)
+			return -EINVAL;
+		return 0;
+
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir && !dev->tx_scancode)
 			return -ENOTTY;
@@ -361,7 +410,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		break;
 
 	default:
-		return lirc_dev_fop_ioctl(filep, cmd, arg);
+		return -ENOTTY;
 	}
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
@@ -388,47 +437,13 @@ int ir_lirc_register(struct rc_dev *dev)
 {
 	struct lirc_dev *ldev;
 	int rc = -ENOMEM;
-	unsigned long features = 0;
 
 	ldev = lirc_allocate_device();
 	if (!ldev)
 		return rc;
 
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		features |= LIRC_CAN_REC_MODE2;
-		if (dev->rx_resolution)
-			features |= LIRC_CAN_GET_REC_RESOLUTION;
-	}
-
-	if (dev->tx_scancode)
-		features |= LIRC_CAN_SEND_SCANCODE;
-
-	if (dev->tx_ir) {
-		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
-		if (dev->s_tx_mask)
-			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
-		if (dev->s_tx_carrier)
-			features |= LIRC_CAN_SET_SEND_CARRIER;
-		if (dev->s_tx_duty_cycle)
-			features |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
-	}
-
-	if (dev->s_rx_carrier_range)
-		features |= LIRC_CAN_SET_REC_CARRIER |
-			LIRC_CAN_SET_REC_CARRIER_RANGE;
-
-	if (dev->s_learning_mode)
-		features |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
-
-	if (dev->s_carrier_report)
-		features |= LIRC_CAN_MEASURE_CARRIER;
-
-	if (dev->max_timeout)
-		features |= LIRC_CAN_SET_REC_TIMEOUT;
-
 	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
 		 dev->driver_name);
-	ldev->features = features;
 	ldev->buf = NULL;
 	ldev->chunk_size = sizeof(int);
 	ldev->buffer_size = LIRCBUF_SIZE;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 3cc95deaa84e..95058ea01e62 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -109,6 +109,7 @@ EXPORT_SYMBOL(lirc_free_device);
 
 int lirc_register_device(struct lirc_dev *d)
 {
+	struct rc_dev *rcdev = d->rdev;
 	int minor;
 	int err;
 
@@ -146,7 +147,7 @@ int lirc_register_device(struct lirc_dev *d)
 	/* some safety check 8-) */
 	d->name[sizeof(d->name) - 1] = '\0';
 
-	if (LIRC_CAN_REC(d->features)) {
+	if (rcdev->driver_type == RC_DRIVER_IR_RAW) {
 		err = lirc_allocate_buffer(d);
 		if (err)
 			return err;
@@ -290,63 +291,6 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 }
 EXPORT_SYMBOL(lirc_dev_fop_poll);
 
-long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct rc_dev *rcdev = file->private_data;
-	struct lirc_dev *d = rcdev->lirc_dev;
-	__u32 mode;
-	int result;
-
-	dev_dbg(&d->dev, LOGHEAD "ioctl called (0x%x)\n",
-		d->name, d->minor, cmd);
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
@@ -375,7 +319,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 		goto out_locked;
 	}
 
-	if (!LIRC_CAN_REC(d->features)) {
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW) {
 		ret = -EINVAL;
 		goto out_locked;
 	}
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index dd0c078796e8..86a3cf798775 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -115,8 +115,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *
  * @name:		used for logging
  * @minor:		the minor device (/dev/lircX) number for the device
- * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
- *			LIRC_CAN\_\*, as defined at include/media/lirc.h.
  * @buffer_size:	Number of FIFO buffers with @chunk_size size.
  *			Only used if @rbuf is NULL.
  * @chunk_size:		Size of each FIFO buffer.
@@ -138,7 +136,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 struct lirc_dev {
 	char name[40];
 	unsigned int minor;
-	__u32 features;
 
 	unsigned int buffer_size; /* in chunks holding one code each */
 	unsigned int chunk_size;
@@ -172,7 +169,6 @@ void lirc_unregister_device(struct lirc_dev *d);
 int lirc_dev_fop_open(struct inode *inode, struct file *file);
 int lirc_dev_fop_close(struct inode *inode, struct file *file);
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
-long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 ssize_t lirc_dev_fop_read(struct file *file, char __user *buffer, size_t length,
 			  loff_t *ppos);
 #endif
-- 
2.13.6
