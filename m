Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:41041 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753814AbdBUUnt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:49 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 08/19] [media] lirc: use refcounting for lirc devices
Date: Tue, 21 Feb 2017 20:43:32 +0000
Message-Id: <a9cf90ec83f4be007a0959887a76429c575cf05f.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a lirc device is unplugged, the struct rc_dev is freed even though
userspace can still have a file descriptor open on the lirc chardev. The
rc_dev structure can be used in a subsequent, or even currently executing
ioctl, read or write.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 120 +++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 69 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index ccbdce0..988758b 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -54,7 +54,8 @@ struct irctl {
 	struct lirc_buffer *buf;
 	unsigned int chunk_size;
 
-	struct cdev *cdev;
+	struct device dev;
+	struct cdev cdev;
 
 	struct task_struct *task;
 	long jiffies_to_wait;
@@ -76,15 +77,21 @@ static void lirc_irctl_init(struct irctl *ir)
 	ir->d.minor = NOPLUG;
 }
 
-static void lirc_irctl_cleanup(struct irctl *ir)
+static void lirc_release(struct device *ld)
 {
-	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
+	struct irctl *ir = container_of(ld, struct irctl, dev);
+
+	put_device(ir->dev.parent);
 
 	if (ir->buf != ir->d.rbuf) {
 		lirc_buffer_free(ir->buf);
 		kfree(ir->buf);
 	}
-	ir->buf = NULL;
+
+	mutex_lock(&lirc_dev_lock);
+	irctls[ir->d.minor] = NULL;
+	mutex_unlock(&lirc_dev_lock);
+	kfree(ir);
 }
 
 /*  helper function
@@ -157,32 +164,21 @@ static int lirc_cdev_add(struct irctl *ir)
 	struct cdev *cdev;
 	int retval;
 
-	cdev = cdev_alloc();
-	if (!cdev)
-		return -ENOMEM;
+	cdev = &ir->cdev;
 
 	if (d->fops) {
-		cdev->ops = d->fops;
+		cdev_init(cdev, d->fops);
 		cdev->owner = d->owner;
 	} else {
-		cdev->ops = &lirc_dev_fops;
+		cdev_init(cdev, &lirc_dev_fops);
 		cdev->owner = THIS_MODULE;
 	}
 	retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
 	if (retval)
-		goto err_out;
-
-	retval = cdev_add(cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
-	if (retval)
-		goto err_out;
-
-	ir->cdev = cdev;
-
-	return 0;
+		return retval;
 
-err_out:
-	cdev_del(cdev);
-	return retval;
+	cdev->kobj.parent = &ir->dev.kobj;
+	return cdev_add(cdev, ir->dev.devt, 1);
 }
 
 static int lirc_allocate_buffer(struct irctl *ir)
@@ -304,9 +300,12 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 
 	ir->d = *d;
 
-	device_create(lirc_class, ir->d.dev,
-		      MKDEV(MAJOR(lirc_base_dev), ir->d.minor), NULL,
-		      "lirc%u", ir->d.minor);
+	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
+	ir->dev.class = lirc_class;
+	ir->dev.parent = d->dev;
+	ir->dev.release = lirc_release;
+	dev_set_name(&ir->dev, "lirc%d", ir->d.minor);
+	device_initialize(&ir->dev);
 
 	if (d->sample_rate) {
 		ir->jiffies_to_wait = HZ / d->sample_rate;
@@ -329,14 +328,22 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		goto out_sysfs;
 
 	ir->attached = 1;
+
+	err = device_add(&ir->dev);
+	if (err)
+		goto out_cdev;
+
 	mutex_unlock(&lirc_dev_lock);
 
+	get_device(ir->dev.parent);
+
 	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
 		 ir->d.name, ir->d.minor);
 	return minor;
-
+out_cdev:
+	cdev_del(&ir->cdev);
 out_sysfs:
-	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
+	put_device(&ir->dev);
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
 
@@ -364,7 +371,6 @@ EXPORT_SYMBOL(lirc_register_driver);
 int lirc_unregister_driver(int minor)
 {
 	struct irctl *ir;
-	struct cdev *cdev;
 
 	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
 		pr_err("minor (%d) must be between 0 and %d!\n",
@@ -378,8 +384,6 @@ int lirc_unregister_driver(int minor)
 		return -ENOENT;
 	}
 
-	cdev = ir->cdev;
-
 	mutex_lock(&lirc_dev_lock);
 
 	if (ir->d.minor != minor) {
@@ -401,22 +405,20 @@ int lirc_unregister_driver(int minor)
 		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
 			ir->d.name, ir->d.minor);
 		wake_up_interruptible(&ir->buf->wait_poll);
-		mutex_lock(&ir->irctl_lock);
+	}
 
-		if (ir->d.set_use_dec)
-			ir->d.set_use_dec(ir->d.data);
+	mutex_lock(&ir->irctl_lock);
 
-		module_put(cdev->owner);
-		mutex_unlock(&ir->irctl_lock);
-	} else {
-		lirc_irctl_cleanup(ir);
-		cdev_del(cdev);
-		kfree(ir);
-		irctls[minor] = NULL;
-	}
+	if (ir->d.set_use_dec)
+		ir->d.set_use_dec(ir->d.data);
 
+	mutex_unlock(&ir->irctl_lock);
 	mutex_unlock(&lirc_dev_lock);
 
+	device_del(&ir->dev);
+	cdev_del(&ir->cdev);
+	put_device(&ir->dev);
+
 	return 0;
 }
 EXPORT_SYMBOL(lirc_unregister_driver);
@@ -424,7 +426,6 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
 	struct irctl *ir;
-	struct cdev *cdev;
 	int retval = 0;
 
 	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
@@ -459,18 +460,14 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 			goto error;
 	}
 
-	cdev = ir->cdev;
-	if (try_module_get(cdev->owner)) {
-		ir->open++;
-		if (ir->d.set_use_inc)
-			retval = ir->d.set_use_inc(ir->d.data);
-
-		if (retval) {
-			module_put(cdev->owner);
-			ir->open--;
-		} else if (ir->buf) {
+	ir->open++;
+	if (ir->d.set_use_inc)
+		retval = ir->d.set_use_inc(ir->d.data);
+	if (retval) {
+		ir->open--;
+	} else {
+		if (ir->buf)
 			lirc_buffer_clear(ir->buf);
-		}
 		if (ir->task)
 			wake_up_process(ir->task);
 	}
@@ -487,7 +484,6 @@ EXPORT_SYMBOL(lirc_dev_fop_open);
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
 	struct irctl *ir = irctls[iminor(inode)];
-	struct cdev *cdev;
 	int ret;
 
 	if (!ir) {
@@ -495,25 +491,14 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 		return -EINVAL;
 	}
 
-	cdev = ir->cdev;
-
 	ret = mutex_lock_killable(&lirc_dev_lock);
 	WARN_ON(ret);
 
 	rc_close(ir->d.rdev);
 
 	ir->open--;
-	if (ir->attached) {
-		if (ir->d.set_use_dec)
-			ir->d.set_use_dec(ir->d.data);
-		module_put(cdev->owner);
-	} else {
-		lirc_irctl_cleanup(ir);
-		cdev_del(cdev);
-		irctls[ir->d.minor] = NULL;
-		kfree(ir);
-	}
-
+	if (ir->d.set_use_dec)
+		ir->d.set_use_dec(ir->d.data);
 	if (!ret)
 		mutex_unlock(&lirc_dev_lock);
 
@@ -780,15 +765,12 @@ static int __init lirc_dev_init(void)
 		return retval;
 	}
 
-
 	pr_info("IR Remote Control driver registered, major %d\n",
 						MAJOR(lirc_base_dev));
 
 	return 0;
 }
 
-
-
 static void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
-- 
2.9.3
