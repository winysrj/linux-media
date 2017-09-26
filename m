Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40239 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965150AbdIZUOG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:06 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/20] media: lirc: be gone, lirc kernel api!
Date: Tue, 26 Sep 2017 21:13:55 +0100
Message-Id: <38057be1a79b0af466dfc3de8d9e16474ae7e79a.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc kernel api sneaked its way in along with the lirc drivers; it
was terrible, but now the last step can be done to banish it forever.

All future drivers should use the rc-core api.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/kapi/rc-core.rst |   5 --
 drivers/media/rc/ir-lirc-codec.c     |  42 +---------
 drivers/media/rc/lirc_dev.c          | 145 ++++++++++++-----------------------
 drivers/media/rc/rc-core-priv.h      |   3 +
 drivers/media/rc/rc-main.c           |   1 -
 include/media/lirc_dev.h             |  50 ------------
 include/media/rc-core.h              |   8 +-
 7 files changed, 60 insertions(+), 194 deletions(-)
 delete mode 100644 include/media/lirc_dev.h

diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/media/kapi/rc-core.rst
index a45895886257..41c2256dbf6a 100644
--- a/Documentation/media/kapi/rc-core.rst
+++ b/Documentation/media/kapi/rc-core.rst
@@ -7,8 +7,3 @@ Remote Controller core
 .. kernel-doc:: include/media/rc-core.h
 
 .. kernel-doc:: include/media/rc-map.h
-
-LIRC
-~~~~
-
-.. kernel-doc:: include/media/lirc_dev.h
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index b6e20ddcd915..fb5df6c8208f 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -12,10 +12,10 @@
  *  GNU General Public License for more details.
  */
 
+#include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <media/lirc.h>
-#include <media/lirc_dev.h>
 #include <media/rc-core.h>
 #include "rc-core-priv.h"
 
@@ -90,8 +90,8 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 
 static int ir_lirc_open(struct inode *inode, struct file *file)
 {
-	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
-	struct rc_dev *dev = d->rdev;
+	struct rc_dev *dev = container_of(inode->i_cdev, struct rc_dev,
+					  lirc_cdev);
 	int retval;
 
 	retval = rc_open(dev);
@@ -511,7 +511,7 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 	return copied;
 }
 
-static const struct file_operations lirc_fops = {
+const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
 	.unlocked_ioctl	= ir_lirc_ioctl,
@@ -524,37 +524,3 @@ static const struct file_operations lirc_fops = {
 	.release	= ir_lirc_close,
 	.llseek		= no_llseek,
 };
-
-int ir_lirc_register(struct rc_dev *dev)
-{
-	struct lirc_dev *ldev;
-	int rc = -ENOMEM;
-
-	ldev = lirc_allocate_device();
-	if (!ldev)
-		return rc;
-
-	ldev->fops = &lirc_fops;
-	ldev->dev.parent = &dev->dev;
-	ldev->rdev = dev;
-	ldev->owner = THIS_MODULE;
-
-	rc = lirc_register_device(ldev);
-	if (rc < 0)
-		goto out;
-
-	dev->send_mode = LIRC_MODE_PULSE;
-
-	dev->lirc_dev = ldev;
-	return 0;
-
-out:
-	lirc_free_device(ldev);
-	return rc;
-}
-
-void ir_lirc_unregister(struct rc_dev *dev)
-{
-	lirc_unregister_device(dev->lirc_dev);
-	dev->lirc_dev = NULL;
-}
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 4ac74fd86fd4..155a4de249a0 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -18,24 +18,19 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/sched/signal.h>
-#include <linux/ioctl.h>
-#include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
-#include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/poll.h>
 
 #include "rc-core-priv.h"
 #include <media/lirc.h>
-#include <media/lirc_dev.h>
 
 #define LOGHEAD		"lirc_dev (%s[%d]): "
 
 static dev_t lirc_base_dev;
 
 /* Used to keep track of allocated lirc devices */
-#define LIRC_MAX_DEVICES 256
 static DEFINE_IDA(lirc_ida);
 
 /* Only used for sysfs but defined to void otherwise */
@@ -43,124 +38,80 @@ static struct class *lirc_class;
 
 static void lirc_release_device(struct device *ld)
 {
-	struct lirc_dev *d = container_of(ld, struct lirc_dev, dev);
-	struct rc_dev *rcdev = d->rdev;
+	struct rc_dev *rcdev = container_of(ld, struct rc_dev, lirc_dev);
 
 	if (rcdev->driver_type == RC_DRIVER_IR_RAW)
 		kfifo_free(&rcdev->rawir);
 
-	kfree(d);
-	module_put(THIS_MODULE);
-	put_device(d->dev.parent);
-}
-
-struct lirc_dev *
-lirc_allocate_device(void)
-{
-	struct lirc_dev *d;
-
-	d = kzalloc(sizeof(*d), GFP_KERNEL);
-	if (d) {
-		device_initialize(&d->dev);
-		d->dev.class = lirc_class;
-		d->dev.release = lirc_release_device;
-		__module_get(THIS_MODULE);
-	}
-
-	return d;
-}
-EXPORT_SYMBOL(lirc_allocate_device);
-
-void lirc_free_device(struct lirc_dev *d)
-{
-	if (!d)
-		return;
-
-	put_device(&d->dev);
+	put_device(&rcdev->dev);
 }
-EXPORT_SYMBOL(lirc_free_device);
 
-int lirc_register_device(struct lirc_dev *d)
+int ir_lirc_register(struct rc_dev *dev)
 {
-	struct rc_dev *rcdev = d->rdev;
-	int minor;
-	int err;
+	int err, minor;
 
-	if (!d) {
-		pr_err("driver pointer must be not NULL!\n");
-		return -EBADRQC;
-	}
+	device_initialize(&dev->lirc_dev);
+	dev->lirc_dev.class = lirc_class;
+	dev->lirc_dev.release = lirc_release_device;
+	dev->send_mode = LIRC_MODE_PULSE;
 
-	if (!d->dev.parent) {
-		pr_err("dev parent pointer not filled in!\n");
-		return -EINVAL;
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		if (kfifo_alloc(&dev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
+			return -ENOMEM;
 	}
 
-	if (!d->fops) {
-		pr_err("fops pointer not filled in!\n");
-		return -EINVAL;
-	}
+	init_waitqueue_head(&dev->wait_poll);
 
-	if (rcdev->driver_type == RC_DRIVER_IR_RAW) {
-		if (kfifo_alloc(&rcdev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
-			return -ENOMEM;
+	minor = ida_simple_get(&lirc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
+	if (minor < 0) {
+		err = minor;
+		goto out_kfifo;
 	}
 
-	init_waitqueue_head(&rcdev->wait_poll);
-
-	minor = ida_simple_get(&lirc_ida, 0, LIRC_MAX_DEVICES, GFP_KERNEL);
-	if (minor < 0)
-		return minor;
+	dev->lirc_dev.parent = &dev->dev;
+	dev->lirc_dev.devt = MKDEV(MAJOR(lirc_base_dev), minor);
+	dev_set_name(&dev->lirc_dev, "lirc%d", minor);
 
-	d->minor = minor;
-	d->dev.devt = MKDEV(MAJOR(lirc_base_dev), d->minor);
-	dev_set_name(&d->dev, "lirc%d", d->minor);
+	cdev_init(&dev->lirc_cdev, &lirc_fops);
 
-	cdev_init(&d->cdev, d->fops);
-	d->cdev.owner = d->owner;
+	err = cdev_device_add(&dev->lirc_cdev, &dev->lirc_dev);
+	if (err)
+		goto out_ida;
 
-	err = cdev_device_add(&d->cdev, &d->dev);
-	if (err) {
-		ida_simple_remove(&lirc_ida, minor);
-		return err;
-	}
+	get_device(&dev->dev);
 
-	get_device(d->dev.parent);
-
-	dev_info(&d->dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 rcdev->driver_name, d->minor);
+	dev_info(&dev->dev, "lirc_dev: driver %s registered at minor = %d",
+		 dev->driver_name, minor);
 
 	return 0;
+
+out_ida:
+	ida_simple_remove(&lirc_ida, minor);
+out_kfifo:
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		kfifo_free(&dev->rawir);
+	return err;
 }
-EXPORT_SYMBOL(lirc_register_device);
 
-void lirc_unregister_device(struct lirc_dev *d)
+void ir_lirc_unregister(struct rc_dev *dev)
 {
-	struct rc_dev *rcdev;
-
-	if (!d)
-		return;
-
-	rcdev = d->rdev;
-
-	dev_dbg(&d->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
-		rcdev->driver_name, d->minor);
+	dev_dbg(&dev->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
+		dev->driver_name, MINOR(dev->lirc_dev.devt));
 
-	mutex_lock(&rcdev->lock);
+	mutex_lock(&dev->lock);
 
-	if (rcdev->lirc_open) {
-		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
-			rcdev->driver_name, d->minor);
-		wake_up_poll(&rcdev->wait_poll, POLLHUP);
+	if (dev->lirc_open) {
+		dev_dbg(&dev->dev, LOGHEAD "releasing opened driver\n",
+			dev->driver_name, MINOR(dev->lirc_dev.devt));
+		wake_up_poll(&dev->wait_poll, POLLHUP);
 	}
 
-	mutex_unlock(&rcdev->lock);
+	mutex_unlock(&dev->lock);
 
-	cdev_device_del(&d->cdev, &d->dev);
-	ida_simple_remove(&lirc_ida, d->minor);
-	put_device(&d->dev);
+	cdev_device_del(&dev->lirc_cdev, &dev->lirc_dev);
+	ida_simple_remove(&lirc_ida, MINOR(dev->lirc_dev.devt));
+	put_device(&dev->lirc_dev);
 }
-EXPORT_SYMBOL(lirc_unregister_device);
 
 int __init lirc_dev_init(void)
 {
@@ -172,7 +123,7 @@ int __init lirc_dev_init(void)
 		return PTR_ERR(lirc_class);
 	}
 
-	retval = alloc_chrdev_region(&lirc_base_dev, 0, LIRC_MAX_DEVICES,
+	retval = alloc_chrdev_region(&lirc_base_dev, 0, RC_DEV_MAX,
 				     "BaseRemoteCtl");
 	if (retval) {
 		class_destroy(lirc_class);
@@ -189,5 +140,5 @@ int __init lirc_dev_init(void)
 void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
-	unregister_chrdev_region(lirc_base_dev, LIRC_MAX_DEVICES);
+	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 21e515d34f64..10fce47c255d 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -16,6 +16,7 @@
 #ifndef _RC_CORE_PRIV
 #define _RC_CORE_PRIV
 
+#define	RC_DEV_MAX		256
 /* Define the max number of pulse/space transitions to buffer */
 #define	MAX_IR_EVENT_SIZE	512
 
@@ -286,6 +287,8 @@ void lirc_dev_exit(void);
 void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
+
+extern const struct file_operations lirc_fops;
 #else
 static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 247f19efc852..1103930a3a0a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -29,7 +29,6 @@
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
-#define RC_DEV_MAX	256
 
 static const struct {
 	const char *name;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
deleted file mode 100644
index d12e1d1c3d67..000000000000
--- a/include/media/lirc_dev.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * LIRC base driver
- *
- * by Artur Lipowski <alipowski@interia.pl>
- *        This code is licensed under GNU GPL
- *
- */
-
-#ifndef _LINUX_LIRC_DEV_H
-#define _LINUX_LIRC_DEV_H
-
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/ioctl.h>
-#include <linux/poll.h>
-#include <linux/kfifo.h>
-#include <media/lirc.h>
-#include <linux/device.h>
-#include <linux/cdev.h>
-
-/**
- * struct lirc_dev - represents a LIRC device
- *
- * @minor:		the minor device (/dev/lircX) number for the device
- * @rdev:		&struct rc_dev associated with the device
- * @fops:		&struct file_operations for the device
- * @owner:		the module owning this struct
- * @dev:		&struct device assigned to the device
- * @cdev:		&struct cdev assigned to the device
- */
-struct lirc_dev {
-	unsigned int minor;
-
-	struct rc_dev *rdev;
-	const struct file_operations *fops;
-	struct module *owner;
-
-	struct device dev;
-	struct cdev cdev;
-};
-
-struct lirc_dev *lirc_allocate_device(void);
-
-void lirc_free_device(struct lirc_dev *d);
-
-int lirc_register_device(struct lirc_dev *d);
-
-void lirc_unregister_device(struct lirc_dev *d);
-
-#endif
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f0ee1ba01a47..e3db561a9bd7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -17,10 +17,10 @@
 #define _RC_CORE
 
 #include <linux/spinlock.h>
+#include <linux/cdev.h>
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#include <media/lirc_dev.h>
 #include <media/rc-map.h>
 
 extern int rc_core_debug;
@@ -116,7 +116,8 @@ enum rc_filter_type {
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
- * @lirc_dev: lirc char device
+ * @lirc_dev: lirc device
+ * @lirc_cdev: lirc char cdev
  * @lirc_open: count of the number of times the device has been opened
  * @carrier_low: when setting the carrier range, first the low end must be
  *	set with an ioctl and then the high end with another ioctl
@@ -191,7 +192,8 @@ struct rc_dev {
 	u32				rx_resolution;
 	u32				tx_resolution;
 #ifdef CONFIG_LIRC
-	struct lirc_dev			*lirc_dev;
+	struct device			lirc_dev;
+	struct cdev			lirc_cdev;
 	int				lirc_open;
 	int				carrier_low;
 	ktime_t				gap_start;
-- 
2.13.5
