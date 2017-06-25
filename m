Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56433 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751339AbdFYMcT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:19 -0400
Subject: [PATCH 10/19] lirc_dev: use an IDA instead of an array to keep
 track of registered devices
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:05 +0200
Message-ID: <149839392557.28811.12182072548739735777.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the kernel-provided IDA simplifies the code and makes it possible
to remove the lirc_dev_lock mutex.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   36 ++++++++++++------------------------
 include/media/lirc_dev.h    |    1 -
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 6bd21609a719..996cb5e778dc 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/idr.h>
 
 #include <media/rc-core.h>
 #include <media/lirc.h>
@@ -46,10 +47,9 @@ struct irctl {
 	struct cdev cdev;
 };
 
-/* This mutex protects the irctls array */
-static DEFINE_MUTEX(lirc_dev_lock);
-
-static struct irctl *irctls[MAX_IRCTL_DEVICES];
+/* Used to keep track of allocated lirc devices */
+#define LIRC_MAX_DEVICES 256
+static DEFINE_IDA(lirc_ida);
 
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
@@ -67,9 +67,6 @@ static void lirc_release(struct device *ld)
 {
 	struct irctl *ir = container_of(ld, struct irctl, dev);
 
-	mutex_lock(&lirc_dev_lock);
-	irctls[ir->d.minor] = NULL;
-	mutex_unlock(&lirc_dev_lock);
 	lirc_free_buffer(ir);
 	kfree(ir);
 }
@@ -107,7 +104,7 @@ static int lirc_allocate_buffer(struct irctl *ir)
 int lirc_register_driver(struct lirc_driver *d)
 {
 	struct irctl *ir;
-	unsigned minor;
+	int minor;
 	int err;
 
 	if (!d) {
@@ -169,27 +166,16 @@ int lirc_register_driver(struct lirc_driver *d)
 		d->rbuf = ir->buf;
 	}
 
-	mutex_lock(&lirc_dev_lock);
-
-	/* find first free slot for driver */
-	for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
-		if (!irctls[minor])
-			break;
-
-	if (minor == MAX_IRCTL_DEVICES) {
-		dev_err(d->dev, "no free slots for drivers!\n");
-		mutex_unlock(&lirc_dev_lock);
+	minor = ida_simple_get(&lirc_ida, 0, LIRC_MAX_DEVICES, GFP_KERNEL);
+	if (minor < 0) {
 		lirc_free_buffer(ir);
 		kfree(ir);
-		return -ENOMEM;
+		return minor;
 	}
 
-	irctls[minor] = ir;
 	d->irctl = ir;
 	d->minor = minor;
 
-	mutex_unlock(&lirc_dev_lock);
-
 	device_initialize(&ir->dev);
 	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
 	ir->dev.class = lirc_class;
@@ -203,6 +189,7 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	err = cdev_device_add(&ir->cdev, &ir->dev);
 	if (err) {
+		ida_simple_remove(&lirc_ida, minor);
 		put_device(&ir->dev);
 		return err;
 	}
@@ -239,6 +226,7 @@ void lirc_unregister_driver(struct lirc_driver *d)
 
 	mutex_unlock(&ir->mutex);
 
+	ida_simple_remove(&lirc_ida, d->minor);
 	put_device(&ir->dev);
 }
 EXPORT_SYMBOL(lirc_unregister_driver);
@@ -509,7 +497,7 @@ static int __init lirc_dev_init(void)
 		return PTR_ERR(lirc_class);
 	}
 
-	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
+	retval = alloc_chrdev_region(&lirc_base_dev, 0, LIRC_MAX_DEVICES,
 				     "BaseRemoteCtl");
 	if (retval) {
 		class_destroy(lirc_class);
@@ -526,7 +514,7 @@ static int __init lirc_dev_init(void)
 static void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
-	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
+	unregister_chrdev_region(lirc_base_dev, LIRC_MAX_DEVICES);
 	pr_info("module unloaded\n");
 }
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index a01fe5433bb7..2629c40e8a39 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_LIRC_DEV_H
 #define _LINUX_LIRC_DEV_H
 
-#define MAX_IRCTL_DEVICES 8
 #define BUFLEN            16
 
 #include <linux/slab.h>
