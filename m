Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47305 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752114AbdKFKkX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 05:40:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] media: lirc: allow lirc device to opened more than once
Date: Mon,  6 Nov 2017 10:40:18 +0000
Message-Id: <8358e855bc6bbd6eeb54a6b3e32239d292c57be0.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it possible for lircd to read from a lirc chardev, and not
keep it busy.

Note that this changes the default for timeout reports to on.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 280 ++++++++++++++++++++++++--------------------
 include/media/rc-core.h     |  56 +++++----
 2 files changed, 185 insertions(+), 151 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 24e0c56c9892..32beecf103cc 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -28,7 +28,6 @@
 #include "rc-core-priv.h"
 #include <uapi/linux/lirc.h>
 
-#define LOGHEAD		"lirc_dev (%s[%d]): "
 #define LIRCBUF_SIZE	256
 
 static dev_t lirc_base_dev;
@@ -47,6 +46,9 @@ static struct class *lirc_class;
  */
 void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 {
+	unsigned long flags;
+	struct list_head *l;
+	struct lirc_fh *fh;
 	int sample;
 
 	/* Packet start */
@@ -75,9 +77,6 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 		dev->gap = true;
 		dev->gap_duration = ev.duration;
 
-		if (!dev->send_timeout_reports)
-			return;
-
 		sample = LIRC_TIMEOUT(ev.duration / 1000);
 		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
 
@@ -92,7 +91,13 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			dev->gap_duration = min_t(u64, dev->gap_duration,
 						  LIRC_VALUE_MASK);
 
-			kfifo_put(&dev->rawir, LIRC_SPACE(dev->gap_duration));
+			spin_lock_irqsave(&dev->lirc_fh_lock, flags);
+			list_for_each(l, &dev->lirc_fh) {
+				fh = list_entry(l, struct lirc_fh, list);
+				kfifo_put(&fh->rawir,
+					  LIRC_SPACE(dev->gap_duration));
+			}
+			spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
 			dev->gap = false;
 		}
 
@@ -102,22 +107,38 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	kfifo_put(&dev->rawir, sample);
-	wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
+	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
+	list_for_each(l, &dev->lirc_fh) {
+		fh = list_entry(l, struct lirc_fh, list);
+		if (LIRC_IS_TIMEOUT(sample) && !fh->send_timeout_reports)
+			continue;
+		if (kfifo_put(&fh->rawir, sample))
+			wake_up_poll(&fh->wait_poll, POLLIN | POLLRDNORM);
+	}
+	spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
 }
 
 /**
  * ir_lirc_scancode_event() - Send scancode data to lirc to be relayed to
- *		userspace
+ *		userspace. This can be called in atomic context.
  * @dev:	the struct rc_dev descriptor of the device
  * @lsc		the struct lirc_scancode describing the decoded scancode
  */
 void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc)
 {
+	unsigned long flags;
+	struct list_head *l;
+	struct lirc_fh *fh;
+
 	lsc->timestamp = ktime_get_ns();
 
-	if (kfifo_put(&dev->scancodes, *lsc))
-		wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
+	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
+	list_for_each(l, &dev->lirc_fh) {
+		fh = list_entry(l, struct lirc_fh, list);
+		if (kfifo_put(&fh->scancodes, *lsc))
+			wake_up_poll(&fh->wait_poll, POLLIN | POLLRDNORM);
+	}
+	spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ir_lirc_scancode_event);
 
@@ -125,55 +146,89 @@ static int ir_lirc_open(struct inode *inode, struct file *file)
 {
 	struct rc_dev *dev = container_of(inode->i_cdev, struct rc_dev,
 					  lirc_cdev);
+	struct lirc_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	unsigned long flags;
 	int retval;
 
-	retval = rc_open(dev);
-	if (retval)
-		return retval;
-
-	retval = mutex_lock_interruptible(&dev->lock);
-	if (retval)
-		goto out_rc;
+	if (!fh)
+		return -ENOMEM;
 
 	if (!dev->registered) {
 		retval = -ENODEV;
-		goto out_unlock;
+		goto out_fh;
 	}
 
-	if (dev->lirc_open) {
-		retval = -EBUSY;
-		goto out_unlock;
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		if (kfifo_alloc(&fh->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL)) {
+			retval = -ENOMEM;
+			goto out_fh;
+		}
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		kfifo_reset_out(&dev->rawir);
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
-		kfifo_reset_out(&dev->scancodes);
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		if (kfifo_alloc(&fh->scancodes, 32, GFP_KERNEL)) {
+			retval = -ENOMEM;
+			goto out_rawir;
+		}
+	}
 
-	dev->lirc_open++;
-	file->private_data = dev;
+	fh->send_mode = LIRC_MODE_PULSE;
+	fh->rc = dev;
+	fh->send_timeout_reports = true;
+
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		fh->rec_mode = LIRC_MODE_SCANCODE;
+		fh->poll_mode = LIRC_MODE_SCANCODE;
+	} else {
+		fh->rec_mode = LIRC_MODE_MODE2;
+		fh->poll_mode = LIRC_MODE_MODE2;
+	}
+
+	retval = rc_open(dev);
+	if (retval)
+		goto out_kfifo;
+
+	init_waitqueue_head(&fh->wait_poll);
+
+	file->private_data = fh;
+	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
+	list_add(&fh->list, &dev->lirc_fh);
+	spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
+
+	get_device(&dev->dev);
 
 	nonseekable_open(inode, file);
 	mutex_unlock(&dev->lock);
 
 	return 0;
-
-out_unlock:
-	mutex_unlock(&dev->lock);
-out_rc:
-	rc_close(dev);
+out_kfifo:
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		kfifo_free(&fh->scancodes);
+out_rawir:
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		kfifo_free(&fh->rawir);
+out_fh:
+	kfree(fh);
 	return retval;
 }
 
 static int ir_lirc_close(struct inode *inode, struct file *file)
 {
-	struct rc_dev *dev = file->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *dev = fh->rc;
+	unsigned long flags;
 
-	mutex_lock(&dev->lock);
-	dev->lirc_open--;
-	mutex_unlock(&dev->lock);
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		kfifo_free(&fh->rawir);
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		kfifo_free(&fh->scancodes);
 
+	put_device(&dev->dev);
 	rc_close(dev);
+	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
+	list_del(&fh->list);
+	spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
+	kfree(fh);
 
 	return 0;
 }
@@ -181,7 +236,8 @@ static int ir_lirc_close(struct inode *inode, struct file *file)
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
-	struct rc_dev *dev = file->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *dev = fh->rc;
 	unsigned int *txbuf = NULL;
 	struct ir_raw_event *raw = NULL;
 	ssize_t ret = -EINVAL;
@@ -201,7 +257,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	if (dev->send_mode == LIRC_MODE_SCANCODE) {
+	if (fh->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
 		if (n != sizeof(scan))
@@ -276,7 +332,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (ret < 0)
 		goto out;
 
-	if (dev->send_mode == LIRC_MODE_SCANCODE) {
+	if (fh->send_mode == LIRC_MODE_SCANCODE) {
 		ret = n;
 	} else {
 		for (duration = i = 0; i < ret; i++)
@@ -303,10 +359,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	return ret;
 }
 
-static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
+static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
-	struct rc_dev *dev = filep->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *dev = fh->rc;
 	u32 __user *argp = (u32 __user *)(arg);
 	int ret = 0;
 	__u32 val = 0, tmp;
@@ -361,7 +418,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
 			return -ENOTTY;
 
-		val = dev->rec_mode;
+		val = fh->rec_mode;
 		break;
 
 	case LIRC_SET_REC_MODE:
@@ -379,8 +436,8 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			break;
 		}
 
-		dev->rec_mode = val;
-		dev->poll_mode = val;
+		fh->rec_mode = val;
+		fh->poll_mode = val;
 		return 0;
 
 	case LIRC_SET_POLL_MODES:
@@ -397,14 +454,14 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			break;
 		}
 
-		dev->poll_mode = val;
+		fh->poll_mode = val;
 		return 0;
 
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir)
 			return -ENOTTY;
 
-		val = dev->send_mode;
+		val = fh->send_mode;
 		break;
 
 	case LIRC_SET_SEND_MODE:
@@ -414,7 +471,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
 			return -EINVAL;
 
-		dev->send_mode = val;
+		fh->send_mode = val;
 		return 0;
 
 	/* TX settings */
@@ -448,7 +505,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			return -EINVAL;
 
 		return dev->s_rx_carrier_range(dev,
-					       dev->carrier_low,
+					       fh->carrier_low,
 					       val);
 
 	case LIRC_SET_REC_CARRIER_RANGE:
@@ -458,7 +515,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (val <= 0)
 			return -EINVAL;
 
-		dev->carrier_low = val;
+		fh->carrier_low = val;
 		return 0;
 
 	case LIRC_GET_REC_RESOLUTION:
@@ -516,7 +573,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->timeout)
 			return -ENOTTY;
 
-		dev->send_timeout_reports = !!val;
+		fh->send_timeout_reports = !!val;
 		break;
 
 	default:
@@ -532,20 +589,21 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 static unsigned int ir_lirc_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
-	struct rc_dev *rcdev = file->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *rcdev = fh->rc;
 	unsigned int events = 0;
 
-	poll_wait(file, &rcdev->wait_poll, wait);
+	poll_wait(file, &fh->wait_poll, wait);
 
 	if (!rcdev->registered) {
 		events = POLLHUP | POLLERR;
 	} else if (rcdev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		if ((rcdev->poll_mode & LIRC_MODE_SCANCODE) &&
-		    !kfifo_is_empty(&rcdev->scancodes))
+		if ((fh->poll_mode & LIRC_MODE_SCANCODE) &&
+		    !kfifo_is_empty(&fh->scancodes))
 			events |= POLLIN | POLLRDNORM;
 
-		if ((rcdev->poll_mode & LIRC_MODE_MODE2) &&
-		    !kfifo_is_empty(&rcdev->rawir))
+		if ((fh->poll_mode & LIRC_MODE_MODE2) &&
+		    !kfifo_is_empty(&fh->rawir))
 			events |= POLLIN | POLLRDNORM;
 	}
 
@@ -555,7 +613,8 @@ static unsigned int ir_lirc_poll(struct file *file,
 static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
 				  size_t length)
 {
-	struct rc_dev *rcdev = file->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *rcdev = fh->rc;
 	unsigned int copied;
 	int ret;
 
@@ -563,12 +622,12 @@ static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
 		return -EINVAL;
 
 	do {
-		if (kfifo_is_empty(&rcdev->rawir)) {
+		if (kfifo_is_empty(&fh->rawir)) {
 			if (file->f_flags & O_NONBLOCK)
 				return -EAGAIN;
 
-			ret = wait_event_interruptible(rcdev->wait_poll,
-					!kfifo_is_empty(&rcdev->rawir) ||
+			ret = wait_event_interruptible(fh->wait_poll,
+					!kfifo_is_empty(&fh->rawir) ||
 					!rcdev->registered);
 			if (ret)
 				return ret;
@@ -577,8 +636,10 @@ static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
 		if (!rcdev->registered)
 			return -ENODEV;
 
-		mutex_lock(&rcdev->lock);
-		ret = kfifo_to_user(&rcdev->rawir, buffer, length, &copied);
+		ret = mutex_lock_interruptible(&rcdev->lock);
+		if (ret)
+			return ret;
+		ret = kfifo_to_user(&fh->rawir, buffer, length, &copied);
 		mutex_unlock(&rcdev->lock);
 		if (ret)
 			return ret;
@@ -590,7 +651,8 @@ static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
 static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
 				     size_t length)
 {
-	struct rc_dev *rcdev = file->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *rcdev = fh->rc;
 	unsigned int copied;
 	int ret;
 
@@ -599,12 +661,12 @@ static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
 		return -EINVAL;
 
 	do {
-		if (kfifo_is_empty(&rcdev->scancodes)) {
+		if (kfifo_is_empty(&fh->scancodes)) {
 			if (file->f_flags & O_NONBLOCK)
 				return -EAGAIN;
 
-			ret = wait_event_interruptible(rcdev->wait_poll,
-					!kfifo_is_empty(&rcdev->scancodes) ||
+			ret = wait_event_interruptible(fh->wait_poll,
+					!kfifo_is_empty(&fh->scancodes) ||
 					!rcdev->registered);
 			if (ret)
 				return ret;
@@ -613,8 +675,10 @@ static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
 		if (!rcdev->registered)
 			return -ENODEV;
 
-		mutex_lock(&rcdev->lock);
-		ret = kfifo_to_user(&rcdev->scancodes, buffer, length, &copied);
+		ret = mutex_lock_interruptible(&rcdev->lock);
+		if (ret)
+			return ret;
+		ret = kfifo_to_user(&fh->scancodes, buffer, length, &copied);
 		mutex_unlock(&rcdev->lock);
 		if (ret)
 			return ret;
@@ -626,7 +690,8 @@ static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
 static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 			    size_t length, loff_t *ppos)
 {
-	struct rc_dev *rcdev = file->private_data;
+	struct lirc_fh *fh = file->private_data;
+	struct rc_dev *rcdev = fh->rc;
 
 	if (rcdev->driver_type == RC_DRIVER_IR_RAW_TX)
 		return -EINVAL;
@@ -634,7 +699,7 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 	if (!rcdev->registered)
 		return -ENODEV;
 
-	if (rcdev->rec_mode == LIRC_MODE_MODE2)
+	if (fh->rec_mode == LIRC_MODE_MODE2)
 		return ir_lirc_read_mode2(file, buffer, length);
 	else /* LIRC_MODE_SCANCODE */
 		return ir_lirc_read_scancode(file, buffer, length);
@@ -654,67 +719,29 @@ static const struct file_operations lirc_fops = {
 	.llseek		= no_llseek,
 };
 
-static void lirc_release_device(struct device *ld)
-{
-	struct rc_dev *rcdev = container_of(ld, struct rc_dev, lirc_dev);
-
-	if (rcdev->driver_type == RC_DRIVER_IR_RAW)
-		kfifo_free(&rcdev->rawir);
-	if (rcdev->driver_type != RC_DRIVER_IR_RAW_TX)
-		kfifo_free(&rcdev->scancodes);
-
-	put_device(&rcdev->dev);
-}
-
 int ir_lirc_register(struct rc_dev *dev)
 {
 	int err, minor;
 
-	device_initialize(&dev->lirc_dev);
-	dev->lirc_dev.class = lirc_class;
-	dev->lirc_dev.release = lirc_release_device;
-	dev->send_mode = LIRC_MODE_PULSE;
-
-	if (dev->driver_type == RC_DRIVER_SCANCODE) {
-		dev->rec_mode = LIRC_MODE_SCANCODE;
-		dev->poll_mode = LIRC_MODE_SCANCODE;
-	} else {
-		dev->rec_mode = LIRC_MODE_MODE2;
-		dev->poll_mode = LIRC_MODE_MODE2;
-	}
-
-	if (dev->driver_type == RC_DRIVER_IR_RAW) {
-		if (kfifo_alloc(&dev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
-			return -ENOMEM;
-	}
-
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		if (kfifo_alloc(&dev->scancodes, 32, GFP_KERNEL)) {
-			kfifo_free(&dev->rawir);
-			return -ENOMEM;
-		}
-	}
-
-	init_waitqueue_head(&dev->wait_poll);
-
 	minor = ida_simple_get(&lirc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
-	if (minor < 0) {
-		err = minor;
-		goto out_kfifo;
-	}
+	if (minor < 0)
+		return minor;
 
+	device_initialize(&dev->lirc_dev);
+	dev->lirc_dev.class = lirc_class;
 	dev->lirc_dev.parent = &dev->dev;
 	dev->lirc_dev.devt = MKDEV(MAJOR(lirc_base_dev), minor);
 	dev_set_name(&dev->lirc_dev, "lirc%d", minor);
 
+	INIT_LIST_HEAD(&dev->lirc_fh);
+	spin_lock_init(&dev->lirc_fh_lock);
+
 	cdev_init(&dev->lirc_cdev, &lirc_fops);
 
 	err = cdev_device_add(&dev->lirc_cdev, &dev->lirc_dev);
 	if (err)
 		goto out_ida;
 
-	get_device(&dev->dev);
-
 	dev_info(&dev->dev, "lirc_dev: driver %s registered at minor = %d",
 		 dev->driver_name, minor);
 
@@ -722,32 +749,27 @@ int ir_lirc_register(struct rc_dev *dev)
 
 out_ida:
 	ida_simple_remove(&lirc_ida, minor);
-out_kfifo:
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		kfifo_free(&dev->rawir);
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
-		kfifo_free(&dev->scancodes);
 	return err;
 }
 
 void ir_lirc_unregister(struct rc_dev *dev)
 {
+	unsigned long flags;
+	struct list_head *l;
+	struct lirc_fh *fh;
+
 	dev_dbg(&dev->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		dev->driver_name, MINOR(dev->lirc_dev.devt));
 
-	mutex_lock(&dev->lock);
-
-	if (dev->lirc_open) {
-		dev_dbg(&dev->dev, LOGHEAD "releasing opened driver\n",
-			dev->driver_name, MINOR(dev->lirc_dev.devt));
-		wake_up_poll(&dev->wait_poll, POLLHUP);
+	spin_lock_irqsave(&dev->lirc_fh_lock, flags);
+	list_for_each(l, &dev->lirc_fh) {
+		fh = list_entry(l, struct lirc_fh, list);
+		wake_up_poll(&fh->wait_poll, POLLHUP | POLLERR);
 	}
-
-	mutex_unlock(&dev->lock);
+	spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
 
 	cdev_device_del(&dev->lirc_cdev, &dev->lirc_dev);
 	ida_simple_remove(&lirc_ida, MINOR(dev->lirc_dev.devt));
-	put_device(&dev->lirc_dev);
 }
 
 int __init lirc_dev_init(void)
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 9a284365502d..b435c3bb2b6d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -69,6 +69,36 @@ enum rc_filter_type {
 };
 
 /**
+ * struct lirc_fh - represents an open lirc file
+ * @list: list of open file handles
+ * @rc: rcdev for this lirc chardev
+ * @carrier_low: when setting the carrier range, first the low end must be
+ *	set with an ioctl and then the high end with another ioctl
+ * @send_timeout_reports: report timeouts in lirc raw IR.
+ * @rawir: queue for incoming raw IR
+ * @scancodes: queue for incoming decoded scancodes
+ * @wait_poll: poll struct for lirc device
+ * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
+ *	LIRC_MODE_PULSE
+ * @rec_mode: lirc mode for receiving, either LIRC_MODE_SCANCODE or
+ *	LIRC_MODE_MODE2
+ * @poll_mode: lirc mode used for polling, can poll for both LIRC_MODE_SCANCODE
+ *	and LIRC_MODE_MODE2
+ */
+struct lirc_fh {
+	struct list_head list;
+	struct rc_dev *rc;
+	int				carrier_low;
+	bool				send_timeout_reports;
+	DECLARE_KFIFO_PTR(rawir, unsigned int);
+	DECLARE_KFIFO_PTR(scancodes, struct lirc_scancode);
+	wait_queue_head_t		wait_poll;
+	u8				send_mode;
+	u8				rec_mode;
+	u8				poll_mode;
+};
+
+/**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
  * @managed_alloc: devm_rc_allocate_device was used to create rc_dev
@@ -118,22 +148,11 @@ enum rc_filter_type {
  * @tx_resolution: resolution (in ns) of output sampler
  * @lirc_dev: lirc device
  * @lirc_cdev: lirc char cdev
- * @lirc_open: count of the number of times the device has been opened
- * @carrier_low: when setting the carrier range, first the low end must be
- *	set with an ioctl and then the high end with another ioctl
  * @gap_start: time when gap starts
  * @gap_duration: duration of initial gap
  * @gap: true if we're in a gap
- * @send_timeout_reports: report timeouts in lirc raw IR.
- * @rawir: queue for incoming raw IR
- * @scancodes: queue for incoming decoded scancodes
- * @wait_poll: poll struct for lirc device
- * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
- *	LIRC_MODE_PULSE
- * @rec_mode: lirc mode for receiving, either LIRC_MODE_SCANCODE or
- *	LIRC_MODE_MODE2
- * @poll_mode: lirc mode used for polling, can poll for both LIRC_MODE_SCANCODE
- *	and LIRC_MODE_MODE2
+ * @lirc_fh_lock: protects lirc_fh list
+ * @lirc_fh: list of open files
  * @registered: set to true by rc_register_device(), false by
  *	rc_unregister_device
  * @change_protocol: allow changing the protocol used on hardware decoders
@@ -198,18 +217,11 @@ struct rc_dev {
 #ifdef CONFIG_LIRC
 	struct device			lirc_dev;
 	struct cdev			lirc_cdev;
-	int				lirc_open;
-	int				carrier_low;
 	ktime_t				gap_start;
 	u64				gap_duration;
 	bool				gap;
-	bool				send_timeout_reports;
-	DECLARE_KFIFO_PTR(rawir, unsigned int);
-	DECLARE_KFIFO_PTR(scancodes, struct lirc_scancode);
-	wait_queue_head_t		wait_poll;
-	u8				send_mode;
-	u8				rec_mode;
-	u8				poll_mode;
+	spinlock_t			lirc_fh_lock;
+	struct list_head		lirc_fh;
 #endif
 	bool				registered;
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
-- 
2.13.6
