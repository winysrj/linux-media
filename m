Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:39353 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751581AbdF3ImB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 04:42:01 -0400
Subject: [PATCH] lirc_dev: sanitize locking (v2)
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Fri, 30 Jun 2017 10:41:57 +0200
Message-ID: <149881211751.7217.15394676781056823580.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the irctl mutex for all device operations and only use lirc_dev_lock to
protect the irctls array. Also, make sure that the device is alive early in
each fops function before doing anything else.

Since this patch touches nearly every line where the irctl mutex is
taken/released, it also renames the mutex at the same time (the name
irctl_lock will be misleading once struct irctl goes away in later
patches).

V2: make sure ir->d.minor is set as well once allocated
(found by Fengguang Wu <fengguang.wu@intel.com>)

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |  165 ++++++++++++++++++++++++-------------------
 1 file changed, 92 insertions(+), 73 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index aece6b619796..55ed65621bbd 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -38,7 +38,7 @@ struct irctl {
 	bool attached;
 	int open;
 
-	struct mutex irctl_lock;
+	struct mutex mutex;
 	struct lirc_buffer *buf;
 	bool buf_internal;
 
@@ -46,6 +46,7 @@ struct irctl {
 	struct cdev cdev;
 };
 
+/* This mutex protects the irctls array */
 static DEFINE_MUTEX(lirc_dev_lock);
 
 static struct irctl *irctls[MAX_IRCTL_DEVICES];
@@ -53,18 +54,23 @@ static struct irctl *irctls[MAX_IRCTL_DEVICES];
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
 
-static void lirc_release(struct device *ld)
+static void lirc_free_buffer(struct irctl *ir)
 {
-	struct irctl *ir = container_of(ld, struct irctl, dev);
-
 	if (ir->buf_internal) {
 		lirc_buffer_free(ir->buf);
 		kfree(ir->buf);
+		ir->buf = NULL;
 	}
+}
+
+static void lirc_release(struct device *ld)
+{
+	struct irctl *ir = container_of(ld, struct irctl, dev);
 
 	mutex_lock(&lirc_dev_lock);
 	irctls[ir->d.minor] = NULL;
 	mutex_unlock(&lirc_dev_lock);
+	lirc_free_buffer(ir);
 	kfree(ir);
 }
 
@@ -141,6 +147,28 @@ int lirc_register_driver(struct lirc_driver *d)
 		return -EBADRQC;
 	}
 
+	/* some safety check 8-) */
+	d->name[sizeof(d->name)-1] = '\0';
+
+	if (d->features == 0)
+		d->features = LIRC_CAN_REC_LIRCCODE;
+
+	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
+
+	mutex_init(&ir->mutex);
+	ir->d = *d;
+
+	if (LIRC_CAN_REC(d->features)) {
+		err = lirc_allocate_buffer(ir);
+		if (err) {
+			kfree(ir);
+			return err;
+		}
+		d->rbuf = ir->buf;
+	}
+
 	mutex_lock(&lirc_dev_lock);
 
 	/* find first free slot for driver */
@@ -150,37 +178,18 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	if (minor == MAX_IRCTL_DEVICES) {
 		dev_err(d->dev, "no free slots for drivers!\n");
-		err = -ENOMEM;
-		goto out_lock;
-	}
-
-	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
-	if (!ir) {
-		err = -ENOMEM;
-		goto out_lock;
+		mutex_unlock(&lirc_dev_lock);
+		lirc_free_buffer(ir);
+		kfree(ir);
+		return -ENOMEM;
 	}
 
-	mutex_init(&ir->irctl_lock);
 	irctls[minor] = ir;
 	d->irctl = ir;
 	d->minor = minor;
+	ir->d.minor = minor;
 
-	/* some safety check 8-) */
-	d->name[sizeof(d->name)-1] = '\0';
-
-	if (d->features == 0)
-		d->features = LIRC_CAN_REC_LIRCCODE;
-
-	ir->d = *d;
-
-	if (LIRC_CAN_REC(d->features)) {
-		err = lirc_allocate_buffer(irctls[minor]);
-		if (err) {
-			kfree(ir);
-			goto out_lock;
-		}
-		d->rbuf = ir->buf;
-	}
+	mutex_unlock(&lirc_dev_lock);
 
 	device_initialize(&ir->dev);
 	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
@@ -194,22 +203,15 @@ int lirc_register_driver(struct lirc_driver *d)
 	ir->attached = true;
 
 	err = cdev_device_add(&ir->cdev, &ir->dev);
-	if (err)
-		goto out_dev;
-
-	mutex_unlock(&lirc_dev_lock);
+	if (err) {
+		put_device(&ir->dev);
+		return err;
+	}
 
 	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
 		 ir->d.name, ir->d.minor);
 
 	return 0;
-
-out_dev:
-	put_device(&ir->dev);
-out_lock:
-	mutex_unlock(&lirc_dev_lock);
-
-	return err;
 }
 EXPORT_SYMBOL(lirc_register_driver);
 
@@ -222,11 +224,13 @@ void lirc_unregister_driver(struct lirc_driver *d)
 
 	ir = d->irctl;
 
-	mutex_lock(&lirc_dev_lock);
-
 	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		d->name, d->minor);
 
+	cdev_device_del(&ir->cdev, &ir->dev);
+
+	mutex_lock(&ir->mutex);
+
 	ir->attached = false;
 	if (ir->open) {
 		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
@@ -234,9 +238,8 @@ void lirc_unregister_driver(struct lirc_driver *d)
 		wake_up_interruptible(&ir->buf->wait_poll);
 	}
 
-	mutex_unlock(&lirc_dev_lock);
+	mutex_unlock(&ir->mutex);
 
-	cdev_device_del(&ir->cdev, &ir->dev);
 	put_device(&ir->dev);
 }
 EXPORT_SYMBOL(lirc_unregister_driver);
@@ -248,13 +251,24 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
 
-	if (ir->open)
-		return -EBUSY;
+	retval = mutex_lock_interruptible(&ir->mutex);
+	if (retval)
+		return retval;
+
+	if (!ir->attached) {
+		retval = -ENODEV;
+		goto out;
+	}
+
+	if (ir->open) {
+		retval = -EBUSY;
+		goto out;
+	}
 
 	if (ir->d.rdev) {
 		retval = rc_open(ir->d.rdev);
 		if (retval)
-			return retval;
+			goto out;
 	}
 
 	if (ir->buf)
@@ -264,24 +278,26 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	lirc_init_pdata(inode, file);
 	nonseekable_open(inode, file);
+	mutex_unlock(&ir->mutex);
 
 	return 0;
+
+out:
+	mutex_unlock(&ir->mutex);
+	return retval;
 }
 EXPORT_SYMBOL(lirc_dev_fop_open);
 
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
 	struct irctl *ir = file->private_data;
-	int ret;
 
-	ret = mutex_lock_killable(&lirc_dev_lock);
-	WARN_ON(ret);
+	mutex_lock(&ir->mutex);
 
 	rc_close(ir->d.rdev);
-
 	ir->open--;
-	if (!ret)
-		mutex_unlock(&lirc_dev_lock);
+
+	mutex_unlock(&ir->mutex);
 
 	return 0;
 }
@@ -316,19 +332,20 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct irctl *ir = file->private_data;
 	__u32 mode;
-	int result = 0;
+	int result;
 
 	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
 		ir->d.name, ir->d.minor, cmd);
 
+	result = mutex_lock_interruptible(&ir->mutex);
+	if (result)
+		return result;
+
 	if (!ir->attached) {
-		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
-			ir->d.name, ir->d.minor);
-		return -ENODEV;
+		result = -ENODEV;
+		goto out;
 	}
 
-	mutex_lock(&ir->irctl_lock);
-
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
 		result = put_user(ir->d.features, (__u32 __user *)arg);
@@ -364,8 +381,8 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		result = -ENOTTY;
 	}
 
-	mutex_unlock(&ir->irctl_lock);
-
+out:
+	mutex_unlock(&ir->mutex);
 	return result;
 }
 EXPORT_SYMBOL(lirc_dev_fop_ioctl);
@@ -377,23 +394,25 @@ ssize_t lirc_dev_fop_read(struct file *file,
 {
 	struct irctl *ir = file->private_data;
 	unsigned char buf[ir->buf->chunk_size];
-	int ret = 0, written = 0;
+	int ret, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	if (!LIRC_CAN_REC(ir->d.features))
-		return -EINVAL;
-
 	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
 
-	if (mutex_lock_interruptible(&ir->irctl_lock)) {
-		ret = -ERESTARTSYS;
-		goto out_unlocked;
-	}
+	ret = mutex_lock_interruptible(&ir->mutex);
+	if (ret)
+		return ret;
+
 	if (!ir->attached) {
 		ret = -ENODEV;
 		goto out_locked;
 	}
 
+	if (!LIRC_CAN_REC(ir->d.features)) {
+		ret = -EINVAL;
+		goto out_locked;
+	}
+
 	if (length % ir->buf->chunk_size) {
 		ret = -EINVAL;
 		goto out_locked;
@@ -428,13 +447,13 @@ ssize_t lirc_dev_fop_read(struct file *file,
 				break;
 			}
 
-			mutex_unlock(&ir->irctl_lock);
+			mutex_unlock(&ir->mutex);
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			set_current_state(TASK_RUNNING);
 
-			if (mutex_lock_interruptible(&ir->irctl_lock)) {
-				ret = -ERESTARTSYS;
+			ret = mutex_lock_interruptible(&ir->mutex);
+			if (ret) {
 				remove_wait_queue(&ir->buf->wait_poll, &wait);
 				goto out_unlocked;
 			}
@@ -457,7 +476,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	remove_wait_queue(&ir->buf->wait_poll, &wait);
 
 out_locked:
-	mutex_unlock(&ir->irctl_lock);
+	mutex_unlock(&ir->mutex);
 
 out_unlocked:
 	return ret ? ret : written;
