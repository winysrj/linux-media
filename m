Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826Ab1E0UBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 16:01:09 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4RK19Or001253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 16:01:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] lirc_dev: store cdev in irctl, up maxdevs
Date: Fri, 27 May 2011 16:01:06 -0400
Message-Id: <1306526466-18717-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Store the cdev pointer in struct irctl, allocated dynamically as needed,
rather than having a static array. At the same time, recycle some of the
saved memory to nudge the maximum number of lirc devices supported up a
ways -- its not that uncommon these days, now that we have the rc-core
lirc bridge driver, to see a system with at least 4 raw IR receivers.
(consider a mythtv backend with several video capture devices and the
possible need for IR transmit hardware).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/lirc_dev.c |   33 ++++++++++++++++++++++++---------
 include/media/lirc_dev.h    |    2 +-
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index fd237ab..9e79692 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -55,6 +55,8 @@ struct irctl {
 	struct lirc_buffer *buf;
 	unsigned int chunk_size;
 
+	struct cdev *cdev;
+
 	struct task_struct *task;
 	long jiffies_to_wait;
 };
@@ -62,7 +64,6 @@ struct irctl {
 static DEFINE_MUTEX(lirc_dev_lock);
 
 static struct irctl *irctls[MAX_IRCTL_DEVICES];
-static struct cdev cdevs[MAX_IRCTL_DEVICES];
 
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
@@ -169,7 +170,9 @@ static int lirc_cdev_add(struct irctl *ir)
 {
 	int retval;
 	struct lirc_driver *d = &ir->d;
-	struct cdev *cdev = &cdevs[d->minor];
+	struct cdev *cdev;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 
 	if (d->fops) {
 		cdev_init(cdev, d->fops);
@@ -180,12 +183,20 @@ static int lirc_cdev_add(struct irctl *ir)
 	}
 	retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
 	if (retval)
-		return retval;
+		goto err_out;
 
 	retval = cdev_add(cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
-	if (retval)
+	if (retval) {
 		kobject_put(&cdev->kobj);
+		goto err_out;
+	}
+
+	ir->cdev = cdev;
+
+	return 0;
 
+err_out:
+	kfree(cdev);
 	return retval;
 }
 
@@ -214,7 +225,7 @@ int lirc_register_driver(struct lirc_driver *d)
 	if (MAX_IRCTL_DEVICES <= d->minor) {
 		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
 			"\"minor\" must be between 0 and %d (%d)!\n",
-			MAX_IRCTL_DEVICES-1, d->minor);
+			MAX_IRCTL_DEVICES - 1, d->minor);
 		err = -EBADRQC;
 		goto out;
 	}
@@ -369,7 +380,7 @@ int lirc_unregister_driver(int minor)
 
 	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
 		printk(KERN_ERR "lirc_dev: %s: minor (%d) must be between "
-		       "0 and %d!\n", __func__, minor, MAX_IRCTL_DEVICES-1);
+		       "0 and %d!\n", __func__, minor, MAX_IRCTL_DEVICES - 1);
 		return -EBADRQC;
 	}
 
@@ -380,7 +391,7 @@ int lirc_unregister_driver(int minor)
 		return -ENOENT;
 	}
 
-	cdev = &cdevs[minor];
+	cdev = ir->cdev;
 
 	mutex_lock(&lirc_dev_lock);
 
@@ -410,6 +421,7 @@ int lirc_unregister_driver(int minor)
 	} else {
 		lirc_irctl_cleanup(ir);
 		cdev_del(cdev);
+		kfree(cdev);
 		kfree(ir);
 		irctls[minor] = NULL;
 	}
@@ -453,7 +465,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 		goto error;
 	}
 
-	cdev = &cdevs[iminor(inode)];
+	cdev = ir->cdev;
 	if (try_module_get(cdev->owner)) {
 		ir->open++;
 		retval = ir->d.set_use_inc(ir->d.data);
@@ -484,13 +496,15 @@ EXPORT_SYMBOL(lirc_dev_fop_open);
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
 	struct irctl *ir = irctls[iminor(inode)];
-	struct cdev *cdev = &cdevs[iminor(inode)];
+	struct cdev *cdev;
 
 	if (!ir) {
 		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
 		return -EINVAL;
 	}
 
+	cdev = ir->cdev;
+
 	dev_dbg(ir->d.dev, LOGHEAD "close called\n", ir->d.name, ir->d.minor);
 
 	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
@@ -503,6 +517,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 		lirc_irctl_cleanup(ir);
 		cdev_del(cdev);
 		irctls[ir->d.minor] = NULL;
+		kfree(cdev);
 		kfree(ir);
 	}
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 630e702..168dd0b 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -9,7 +9,7 @@
 #ifndef _LINUX_LIRC_DEV_H
 #define _LINUX_LIRC_DEV_H
 
-#define MAX_IRCTL_DEVICES 4
+#define MAX_IRCTL_DEVICES 8
 #define BUFLEN            16
 
 #define mod(n, div) ((n) % (div))
-- 
1.7.5.2

