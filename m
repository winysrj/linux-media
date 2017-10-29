Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44113 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbdJ2U7a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:59:30 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 20/28] media: lirc: create rc-core open and close lirc functions
Date: Sun, 29 Oct 2017 20:59:28 +0000
Message-Id: <c0791dcf8c9e1273b4501ccfa6cf682f6f37869d.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the generic kernel lirc api with ones which use rc-core, further
reducing the lirc_dev members.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 59 ++++++++++++++++++++++++++++++++--
 drivers/media/rc/lirc_dev.c      | 68 ++--------------------------------------
 include/media/lirc_dev.h         | 11 -------
 include/media/rc-core.h          |  2 ++
 4 files changed, 62 insertions(+), 78 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 9a780fac207c..94e7b309383b 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -88,6 +88,61 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 	wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
 }
 
+static int ir_lirc_open(struct inode *inode, struct file *file)
+{
+	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
+	struct rc_dev *dev = d->rdev;
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
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
@@ -475,8 +530,8 @@ static const struct file_operations lirc_fops = {
 #endif
 	.read		= ir_lirc_read,
 	.poll		= ir_lirc_poll,
-	.open		= lirc_dev_fop_open,
-	.release	= lirc_dev_fop_close,
+	.open		= ir_lirc_open,
+	.release	= ir_lirc_close,
 	.llseek		= no_llseek,
 };
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 22171267aa90..32124fb5c88e 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -61,7 +61,6 @@ lirc_allocate_device(void)
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (d) {
-		mutex_init(&d->mutex);
 		device_initialize(&d->dev);
 		d->dev.class = lirc_class;
 		d->dev.release = lirc_release_device;
@@ -150,15 +149,15 @@ void lirc_unregister_device(struct lirc_dev *d)
 	dev_dbg(&d->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		d->name, d->minor);
 
-	mutex_lock(&d->mutex);
+	mutex_lock(&rcdev->lock);
 
-	if (d->open) {
+	if (rcdev->lirc_open) {
 		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
 			d->name, d->minor);
 		wake_up_poll(&rcdev->wait_poll, POLLHUP);
 	}
 
-	mutex_unlock(&d->mutex);
+	mutex_unlock(&rcdev->lock);
 
 	cdev_device_del(&d->cdev, &d->dev);
 	ida_simple_remove(&lirc_ida, d->minor);
@@ -166,67 +165,6 @@ void lirc_unregister_device(struct lirc_dev *d)
 }
 EXPORT_SYMBOL(lirc_unregister_device);
 
-int lirc_dev_fop_open(struct inode *inode, struct file *file)
-{
-	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
-	struct rc_dev *rcdev = d->rdev;
-	int retval;
-
-	dev_dbg(&d->dev, LOGHEAD "open called\n", d->name, d->minor);
-
-	retval = mutex_lock_interruptible(&d->mutex);
-	if (retval)
-		return retval;
-
-	if (!rcdev->registered) {
-		retval = -ENODEV;
-		goto out;
-	}
-
-	if (d->open) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	if (d->rdev) {
-		retval = rc_open(d->rdev);
-		if (retval)
-			goto out;
-	}
-
-	if (rcdev->driver_type == RC_DRIVER_IR_RAW)
-		kfifo_reset_out(&rcdev->rawir);
-
-	d->open++;
-
-	file->private_data = d->rdev;
-	nonseekable_open(inode, file);
-	mutex_unlock(&d->mutex);
-
-	return 0;
-
-out:
-	mutex_unlock(&d->mutex);
-	return retval;
-}
-EXPORT_SYMBOL(lirc_dev_fop_open);
-
-int lirc_dev_fop_close(struct inode *inode, struct file *file)
-{
-	struct rc_dev *rcdev = file->private_data;
-	struct lirc_dev *d = rcdev->lirc_dev;
-
-	mutex_lock(&d->mutex);
-
-	rc_close(rcdev);
-	d->open--;
-
-	mutex_unlock(&d->mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL(lirc_dev_fop_close);
-
 int __init lirc_dev_init(void)
 {
 	int retval;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 5782add67edd..b45af81b4633 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -26,8 +26,6 @@
  * @rdev:		&struct rc_dev associated with the device
  * @fops:		&struct file_operations for the device
  * @owner:		the module owning this struct
- * @open:		open count for the device's chardev
- * @mutex:		serialises file_operations calls
  * @dev:		&struct device assigned to the device
  * @cdev:		&struct cdev assigned to the device
  */
@@ -39,10 +37,6 @@ struct lirc_dev {
 	const struct file_operations *fops;
 	struct module *owner;
 
-	int open;
-
-	struct mutex mutex; /* protect from simultaneous accesses */
-
 	struct device dev;
 	struct cdev cdev;
 };
@@ -55,9 +49,4 @@ int lirc_register_device(struct lirc_dev *d);
 
 void lirc_unregister_device(struct lirc_dev *d);
 
-/* default file operations
- * used by drivers if they override only some operations
- */
-int lirc_dev_fop_open(struct inode *inode, struct file *file);
-int lirc_dev_fop_close(struct inode *inode, struct file *file);
 #endif
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b6d719734744..4f585bff1347 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -117,6 +117,7 @@ enum rc_filter_type {
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
  * @lirc_dev: lirc char device
+ * @lirc_open: count of the number of times the device has been opened
  * @carrier_low: when setting the carrier range, first the low end must be
  *	set with an ioctl and then the high end with another ioctl
  * @gap_start: time when gap starts
@@ -190,6 +191,7 @@ struct rc_dev {
 	u32				tx_resolution;
 #ifdef CONFIG_LIRC
 	struct lirc_dev			*lirc_dev;
+	int				lirc_open;
 	int				carrier_low;
 	ktime_t				gap_start;
 	u64				gap_duration;
-- 
2.13.6
