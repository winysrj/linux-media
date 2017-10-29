Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43743 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbdJ2U7T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:59:19 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 17/28] media: lirc: use kfifo rather than lirc_buffer for raw IR
Date: Sun, 29 Oct 2017 20:59:18 +0000
Message-Id: <17044b3787267d4974c206dd0012e46f6cdc60c3.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the only mode lirc devices can handle is raw IR, handle this
in a plain kfifo.

Remove lirc_buffer since this is no longer needed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c |  79 +++++++++++++---
 drivers/media/rc/lirc_dev.c      | 199 ++++-----------------------------------
 include/media/lirc_dev.h         | 109 ---------------------
 include/media/rc-core.h          |   4 +
 4 files changed, 85 insertions(+), 306 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index f933e7617882..1ac7a5aa0437 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -66,8 +66,6 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 	} else {
 
 		if (dev->gap) {
-			int gap_sample;
-
 			dev->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
 							 dev->gap_start));
 
@@ -76,9 +74,7 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			dev->gap_duration = min_t(u64, dev->gap_duration,
 						  LIRC_VALUE_MASK);
 
-			gap_sample = LIRC_SPACE(dev->gap_duration);
-			lirc_buffer_write(dev->lirc_dev->buf,
-					  (unsigned char *)&gap_sample);
+			kfifo_put(&dev->rawir, LIRC_SPACE(dev->gap_duration));
 			dev->gap = false;
 		}
 
@@ -88,10 +84,8 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	lirc_buffer_write(dev->lirc_dev->buf,
-			  (unsigned char *) &sample);
-
-	wake_up(&dev->lirc_dev->buf->wait_poll);
+	kfifo_put(&dev->rawir, sample);
+	wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
 }
 
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
@@ -408,6 +402,66 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
+static unsigned int ir_lirc_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct rc_dev *rcdev = file->private_data;
+	struct lirc_dev *d = rcdev->lirc_dev;
+	unsigned int events = 0;
+
+	poll_wait(file, &rcdev->wait_poll, wait);
+
+	if (!d->attached)
+		events = POLLHUP | POLLERR;
+	else if (rcdev->driver_type == RC_DRIVER_IR_RAW &&
+		 !kfifo_is_empty(&rcdev->rawir))
+		events = POLLIN | POLLRDNORM;
+
+	return events;
+}
+
+static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
+			    size_t length, loff_t *ppos)
+{
+	struct rc_dev *rcdev = file->private_data;
+	struct lirc_dev *d = rcdev->lirc_dev;
+	unsigned int copied;
+	int ret;
+
+	if (rcdev->driver_type == RC_DRIVER_IR_RAW_TX)
+		return -EINVAL;
+
+	if (length < sizeof(unsigned int) || length % sizeof(unsigned int))
+		return -EINVAL;
+
+	if (!d->attached)
+		return -ENODEV;
+
+	do {
+		if (kfifo_is_empty(&rcdev->rawir)) {
+			if (file->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			ret = wait_event_interruptible(rcdev->wait_poll,
+					!kfifo_is_empty(&rcdev->rawir) ||
+					!d->attached);
+			if (ret)
+				return ret;
+		}
+
+		if (!d->attached)
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
 static const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
@@ -415,8 +469,8 @@ static const struct file_operations lirc_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ir_lirc_ioctl,
 #endif
-	.read		= lirc_dev_fop_read,
-	.poll		= lirc_dev_fop_poll,
+	.read		= ir_lirc_read,
+	.poll		= ir_lirc_poll,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
 	.llseek		= no_llseek,
@@ -433,9 +487,6 @@ int ir_lirc_register(struct rc_dev *dev)
 
 	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
 		 dev->driver_name);
-	ldev->buf = NULL;
-	ldev->chunk_size = sizeof(int);
-	ldev->buffer_size = LIRCBUF_SIZE;
 	ldev->fops = &lirc_fops;
 	ldev->dev.parent = &dev->dev;
 	ldev->rdev = dev;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 95058ea01e62..9a0ad8d9a0cb 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -44,40 +44,14 @@ static struct class *lirc_class;
 static void lirc_release_device(struct device *ld)
 {
 	struct lirc_dev *d = container_of(ld, struct lirc_dev, dev);
+	struct rc_dev *rcdev = d->rdev;
 
-	put_device(d->dev.parent);
+	if (rcdev->driver_type == RC_DRIVER_IR_RAW)
+		kfifo_free(&rcdev->rawir);
 
-	if (d->buf_internal) {
-		lirc_buffer_free(d->buf);
-		kfree(d->buf);
-		d->buf = NULL;
-	}
 	kfree(d);
 	module_put(THIS_MODULE);
-}
-
-static int lirc_allocate_buffer(struct lirc_dev *d)
-{
-	int err;
-
-	if (d->buf) {
-		d->buf_internal = false;
-		return 0;
-	}
-
-	d->buf = kmalloc(sizeof(*d->buf), GFP_KERNEL);
-	if (!d->buf)
-		return -ENOMEM;
-
-	err = lirc_buffer_init(d->buf, d->chunk_size, d->buffer_size);
-	if (err) {
-		kfree(d->buf);
-		d->buf = NULL;
-		return err;
-	}
-
-	d->buf_internal = true;
-	return 0;
+	put_device(d->dev.parent);
 }
 
 struct lirc_dev *
@@ -128,31 +102,16 @@ int lirc_register_device(struct lirc_dev *d)
 		return -EINVAL;
 	}
 
-	if (!d->buf && d->chunk_size < 1) {
-		pr_err("chunk_size must be set!\n");
-		return -EINVAL;
-	}
-
-	if (!d->buf && d->buffer_size < 1) {
-		pr_err("buffer_size must be set!\n");
-		return -EINVAL;
-	}
-
-	if (!d->buf && !(d->fops && d->fops->read &&
-			 d->fops->poll && d->fops->unlocked_ioctl)) {
-		dev_err(&d->dev, "undefined read, poll, ioctl\n");
-		return -EBADRQC;
-	}
-
 	/* some safety check 8-) */
 	d->name[sizeof(d->name) - 1] = '\0';
 
 	if (rcdev->driver_type == RC_DRIVER_IR_RAW) {
-		err = lirc_allocate_buffer(d);
-		if (err)
-			return err;
+		if (kfifo_alloc(&rcdev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
+			return -ENOMEM;
 	}
 
+	init_waitqueue_head(&rcdev->wait_poll);
+
 	minor = ida_simple_get(&lirc_ida, 0, LIRC_MAX_DEVICES, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
@@ -182,9 +141,13 @@ EXPORT_SYMBOL(lirc_register_device);
 
 void lirc_unregister_device(struct lirc_dev *d)
 {
+	struct rc_dev *rcdev;
+
 	if (!d)
 		return;
 
+	rcdev = d->rdev;
+
 	dev_dbg(&d->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		d->name, d->minor);
 
@@ -194,7 +157,7 @@ void lirc_unregister_device(struct lirc_dev *d)
 	if (d->open) {
 		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
 			d->name, d->minor);
-		wake_up_interruptible(&d->buf->wait_poll);
+		wake_up_poll(&rcdev->wait_poll, POLLHUP);
 	}
 
 	mutex_unlock(&d->mutex);
@@ -208,6 +171,7 @@ EXPORT_SYMBOL(lirc_unregister_device);
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
 	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
+	struct rc_dev *rcdev = d->rdev;
 	int retval;
 
 	dev_dbg(&d->dev, LOGHEAD "open called\n", d->name, d->minor);
@@ -232,8 +196,8 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 			goto out;
 	}
 
-	if (d->buf)
-		lirc_buffer_clear(d->buf);
+	if (rcdev->driver_type == RC_DRIVER_IR_RAW)
+		kfifo_reset_out(&rcdev->rawir);
 
 	d->open++;
 
@@ -265,137 +229,6 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 }
 EXPORT_SYMBOL(lirc_dev_fop_close);
 
-unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
-{
-	struct rc_dev *rcdev = file->private_data;
-	struct lirc_dev *d = rcdev->lirc_dev;
-	unsigned int ret;
-
-	if (!d->attached)
-		return POLLHUP | POLLERR;
-
-	if (d->buf) {
-		poll_wait(file, &d->buf->wait_poll, wait);
-
-		if (lirc_buffer_empty(d->buf))
-			ret = 0;
-		else
-			ret = POLLIN | POLLRDNORM;
-	} else {
-		ret = POLLERR;
-	}
-
-	dev_dbg(&d->dev, LOGHEAD "poll result = %d\n", d->name, d->minor, ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(lirc_dev_fop_poll);
-
-ssize_t lirc_dev_fop_read(struct file *file,
-			  char __user *buffer,
-			  size_t length,
-			  loff_t *ppos)
-{
-	struct rc_dev *rcdev = file->private_data;
-	struct lirc_dev *d = rcdev->lirc_dev;
-	unsigned char *buf;
-	int ret, written = 0;
-	DECLARE_WAITQUEUE(wait, current);
-
-	buf = kzalloc(d->buf->chunk_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	dev_dbg(&d->dev, LOGHEAD "read called\n", d->name, d->minor);
-
-	ret = mutex_lock_interruptible(&d->mutex);
-	if (ret) {
-		kfree(buf);
-		return ret;
-	}
-
-	if (!d->attached) {
-		ret = -ENODEV;
-		goto out_locked;
-	}
-
-	if (rcdev->driver_type != RC_DRIVER_IR_RAW) {
-		ret = -EINVAL;
-		goto out_locked;
-	}
-
-	if (length % d->buf->chunk_size) {
-		ret = -EINVAL;
-		goto out_locked;
-	}
-
-	/*
-	 * we add ourselves to the task queue before buffer check
-	 * to avoid losing scan code (in case when queue is awaken somewhere
-	 * between while condition checking and scheduling)
-	 */
-	add_wait_queue(&d->buf->wait_poll, &wait);
-
-	/*
-	 * while we didn't provide 'length' bytes, device is opened in blocking
-	 * mode and 'copy_to_user' is happy, wait for data.
-	 */
-	while (written < length && ret == 0) {
-		if (lirc_buffer_empty(d->buf)) {
-			/* According to the read(2) man page, 'written' can be
-			 * returned as less than 'length', instead of blocking
-			 * again, returning -EWOULDBLOCK, or returning
-			 * -ERESTARTSYS
-			 */
-			if (written)
-				break;
-			if (file->f_flags & O_NONBLOCK) {
-				ret = -EWOULDBLOCK;
-				break;
-			}
-			if (signal_pending(current)) {
-				ret = -ERESTARTSYS;
-				break;
-			}
-
-			mutex_unlock(&d->mutex);
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule();
-			set_current_state(TASK_RUNNING);
-
-			ret = mutex_lock_interruptible(&d->mutex);
-			if (ret) {
-				remove_wait_queue(&d->buf->wait_poll, &wait);
-				goto out_unlocked;
-			}
-
-			if (!d->attached) {
-				ret = -ENODEV;
-				goto out_locked;
-			}
-		} else {
-			lirc_buffer_read(d->buf, buf);
-			ret = copy_to_user((void __user *)buffer+written, buf,
-					   d->buf->chunk_size);
-			if (!ret)
-				written += d->buf->chunk_size;
-			else
-				ret = -EFAULT;
-		}
-	}
-
-	remove_wait_queue(&d->buf->wait_poll, &wait);
-
-out_locked:
-	mutex_unlock(&d->mutex);
-
-out_unlocked:
-	kfree(buf);
-
-	return ret ? ret : written;
-}
-EXPORT_SYMBOL(lirc_dev_fop_read);
-
 int __init lirc_dev_init(void)
 {
 	int retval;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 86a3cf798775..14d3eb36672e 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -18,112 +18,11 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
-struct lirc_buffer {
-	wait_queue_head_t wait_poll;
-	spinlock_t fifo_lock;
-	unsigned int chunk_size;
-	unsigned int size; /* in chunks */
-	/* Using chunks instead of bytes pretends to simplify boundary checking
-	 * And should allow for some performance fine tunning later */
-	struct kfifo fifo;
-};
-
-static inline void lirc_buffer_clear(struct lirc_buffer *buf)
-{
-	unsigned long flags;
-
-	if (kfifo_initialized(&buf->fifo)) {
-		spin_lock_irqsave(&buf->fifo_lock, flags);
-		kfifo_reset(&buf->fifo);
-		spin_unlock_irqrestore(&buf->fifo_lock, flags);
-	} else
-		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
-		     __func__);
-}
-
-static inline int lirc_buffer_init(struct lirc_buffer *buf,
-				    unsigned int chunk_size,
-				    unsigned int size)
-{
-	int ret;
-
-	init_waitqueue_head(&buf->wait_poll);
-	spin_lock_init(&buf->fifo_lock);
-	buf->chunk_size = chunk_size;
-	buf->size = size;
-	ret = kfifo_alloc(&buf->fifo, size * chunk_size, GFP_KERNEL);
-
-	return ret;
-}
-
-static inline void lirc_buffer_free(struct lirc_buffer *buf)
-{
-	if (kfifo_initialized(&buf->fifo)) {
-		kfifo_free(&buf->fifo);
-	} else
-		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
-		     __func__);
-}
-
-static inline int lirc_buffer_len(struct lirc_buffer *buf)
-{
-	int len;
-	unsigned long flags;
-
-	spin_lock_irqsave(&buf->fifo_lock, flags);
-	len = kfifo_len(&buf->fifo);
-	spin_unlock_irqrestore(&buf->fifo_lock, flags);
-
-	return len;
-}
-
-static inline int lirc_buffer_full(struct lirc_buffer *buf)
-{
-	return lirc_buffer_len(buf) == buf->size * buf->chunk_size;
-}
-
-static inline int lirc_buffer_empty(struct lirc_buffer *buf)
-{
-	return !lirc_buffer_len(buf);
-}
-
-static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
-					    unsigned char *dest)
-{
-	unsigned int ret = 0;
-
-	if (lirc_buffer_len(buf) >= buf->chunk_size)
-		ret = kfifo_out_locked(&buf->fifo, dest, buf->chunk_size,
-				       &buf->fifo_lock);
-	return ret;
-
-}
-
-static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
-					     unsigned char *orig)
-{
-	unsigned int ret;
-
-	ret = kfifo_in_locked(&buf->fifo, orig, buf->chunk_size,
-			      &buf->fifo_lock);
-
-	return ret;
-}
-
 /**
  * struct lirc_dev - represents a LIRC device
  *
  * @name:		used for logging
  * @minor:		the minor device (/dev/lircX) number for the device
- * @buffer_size:	Number of FIFO buffers with @chunk_size size.
- *			Only used if @rbuf is NULL.
- * @chunk_size:		Size of each FIFO buffer.
- *			Only used if @rbuf is NULL.
- * @buf:		if %NULL, lirc_dev will allocate and manage the buffer,
- *			otherwise allocated by the caller which will
- *			have to write to the buffer by other means, like irq's
- *			(see also lirc_serial.c).
- * @buf_internal:	whether lirc_dev has allocated the read buffer or not
  * @rdev:		&struct rc_dev associated with the device
  * @fops:		&struct file_operations for the device
  * @owner:		the module owning this struct
@@ -137,11 +36,6 @@ struct lirc_dev {
 	char name[40];
 	unsigned int minor;
 
-	unsigned int buffer_size; /* in chunks holding one code each */
-	unsigned int chunk_size;
-	struct lirc_buffer *buf;
-	bool buf_internal;
-
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
 	struct module *owner;
@@ -168,7 +62,4 @@ void lirc_unregister_device(struct lirc_dev *d);
  */
 int lirc_dev_fop_open(struct inode *inode, struct file *file);
 int lirc_dev_fop_close(struct inode *inode, struct file *file);
-unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
-ssize_t lirc_dev_fop_read(struct file *file, char __user *buffer, size_t length,
-			  loff_t *ppos);
 #endif
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5d6e415c7acc..fb91666bf881 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -123,6 +123,8 @@ enum rc_filter_type {
  * @gap_duration: duration of initial gap
  * @gap: true if we're in a gap
  * @send_timeout_reports: report timeouts in lirc raw IR.
+ * @rawir: queue for incoming raw IR
+ * @wait_poll: poll struct for lirc device
  * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
  *	LIRC_MODE_PULSE
  * @change_protocol: allow changing the protocol used on hardware decoders
@@ -191,6 +193,8 @@ struct rc_dev {
 	u64				gap_duration;
 	bool				gap;
 	bool				send_timeout_reports;
+	DECLARE_KFIFO_PTR(rawir, unsigned int);
+	wait_queue_head_t		wait_poll;
 	u8				send_mode;
 #endif
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
-- 
2.13.6
