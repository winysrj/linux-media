Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:33007 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbdJMUXw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 16:23:52 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, david@hardeman.nu,
        jasmin@anw.at
Subject: [PATCH] build: Remove IDA from lirc_dev
Date: Fri, 13 Oct 2017 22:23:29 +0200
Message-Id: <1507926209-9654-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Compiling for Kernel 2.6.x failed in "lirc_dev.c" with
  implicit declaration of function 'ida_simple_get'

This will in principle revert commit
46c8f4771154eb0dc21f5f2bc2640a33e8fe1d02 .

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt                  |   1 +
 backports/v3.0_remove_ida_lird_dev.patch | 111 +++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)
 create mode 100644 backports/v3.0_remove_ida_lird_dev.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index b245e3b..618c4e8 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -126,6 +126,7 @@ add v3.1_no_pm_qos.patch
 add no_atomic_include.patch
 add v4l2-compat-timespec.patch
 add v3.0_ida2bit.patch
+add v3.0_remove_ida_lird_dev.patch
 
 [2.6.39]
 add v2.6_rc_main_bsearch_h.patch
diff --git a/backports/v3.0_remove_ida_lird_dev.patch b/backports/v3.0_remove_ida_lird_dev.patch
new file mode 100644
index 0000000..8fafa6a
--- /dev/null
+++ b/backports/v3.0_remove_ida_lird_dev.patch
@@ -0,0 +1,111 @@
+diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
+index e16d113..67f1f7d 100644
+--- a/drivers/media/rc/lirc_dev.c
++++ b/drivers/media/rc/lirc_dev.c
+@@ -24,7 +24,6 @@
+ #include <linux/mutex.h>
+ #include <linux/device.h>
+ #include <linux/cdev.h>
+-#include <linux/idr.h>
+ 
+ #include <media/rc-core.h>
+ #include <media/lirc.h>
+@@ -34,9 +33,10 @@
+ 
+ static dev_t lirc_base_dev;
+ 
+-/* Used to keep track of allocated lirc devices */
+-#define LIRC_MAX_DEVICES 256
+-static DEFINE_IDA(lirc_ida);
++/* This mutex protects the irctls array */
++static DEFINE_MUTEX(lirc_dev_lock);
++
++static struct lirc_dev *irctls[MAX_IRCTL_DEVICES];
+ 
+ /* Only used for sysfs but defined to void otherwise */
+ static struct class *lirc_class;
+@@ -45,6 +45,10 @@ static void lirc_release_device(struct device *ld)
+ {
+ 	struct lirc_dev *d = container_of(ld, struct lirc_dev, dev);
+ 
++	mutex_lock(&lirc_dev_lock);
++	irctls[d->minor] = NULL;
++	mutex_unlock(&lirc_dev_lock);
++
+ 	put_device(d->dev.parent);
+ 
+ 	if (d->buf_internal) {
+@@ -161,9 +165,20 @@ int lirc_register_device(struct lirc_dev *d)
+ 			return err;
+ 	}
+ 
+-	minor = ida_simple_get(&lirc_ida, 0, LIRC_MAX_DEVICES, GFP_KERNEL);
+-	if (minor < 0)
+-		return minor;
++	mutex_lock(&lirc_dev_lock);
++
++	/* find first free slot for driver */
++	for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
++		if (!irctls[minor])
++			break;
++
++	if (minor == MAX_IRCTL_DEVICES) {
++		dev_err(&d->dev, "no free slots for drivers!\n");
++		mutex_unlock(&lirc_dev_lock);
++		return -ENOMEM;
++	}
++	irctls[minor] = d;
++	mutex_unlock(&lirc_dev_lock);
+ 
+ 	d->minor = minor;
+ 	d->dev.devt = MKDEV(MAJOR(lirc_base_dev), d->minor);
+@@ -175,7 +190,10 @@ int lirc_register_device(struct lirc_dev *d)
+ 
+ 	err = cdev_device_add(&d->cdev, &d->dev);
+ 	if (err) {
+-		ida_simple_remove(&lirc_ida, minor);
++		mutex_lock(&lirc_dev_lock);
++		irctls[minor] = NULL;
++		mutex_unlock(&lirc_dev_lock);
++
+ 		return err;
+ 	}
+ 
+@@ -208,7 +226,6 @@ void lirc_unregister_device(struct lirc_dev *d)
+ 	mutex_unlock(&d->mutex);
+ 
+ 	cdev_device_del(&d->cdev, &d->dev);
+-	ida_simple_remove(&lirc_ida, d->minor);
+ 	put_device(&d->dev);
+ }
+ EXPORT_SYMBOL(lirc_unregister_device);
+@@ -487,7 +504,7 @@ static int __init lirc_dev_init(void)
+ 		return PTR_ERR(lirc_class);
+ 	}
+ 
+-	retval = alloc_chrdev_region(&lirc_base_dev, 0, LIRC_MAX_DEVICES,
++	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
+ 				     "BaseRemoteCtl");
+ 	if (retval) {
+ 		class_destroy(lirc_class);
+@@ -504,7 +521,7 @@ static int __init lirc_dev_init(void)
+ static void __exit lirc_dev_exit(void)
+ {
+ 	class_destroy(lirc_class);
+-	unregister_chrdev_region(lirc_base_dev, LIRC_MAX_DEVICES);
++	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
+ 	pr_info("module unloaded\n");
+ }
+ 
+diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
+index 857da67..47bcd39 100644
+--- a/include/media/lirc_dev.h
++++ b/include/media/lirc_dev.h
+@@ -9,6 +9,7 @@
+ #ifndef _LINUX_LIRC_DEV_H
+ #define _LINUX_LIRC_DEV_H
+ 
++#define MAX_IRCTL_DEVICES 8
+ #define BUFLEN            16
+ 
+ #include <linux/slab.h>
-- 
2.7.4
