Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56504 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbcGFJn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:43:59 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 04/15] [media] lirc_dev: replace printk with pr_* or dev_*
Date: Wed, 06 Jul 2016 18:01:16 +0900
Message-id: <1467795687-10737-5-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch mutes also all the checkpatch warnings related to
printk.

Reword all the printouts so that the string doesn't need to be
split, which fixes the following checkpatch warning:

  WARNING: quoted string split across lines

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 79 +++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 45 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 9f20f94..59f4c93 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -240,59 +242,51 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	int err;
 
 	if (!d) {
-		printk(KERN_ERR "lirc_dev: lirc_register_driver: "
-		       "driver pointer must be not NULL!\n");
+		pr_err("driver pointer must be not NULL!\n");
 		err = -EBADRQC;
 		goto out;
 	}
 
 	if (!d->dev) {
-		printk(KERN_ERR "%s: dev pointer not filled in!\n", __func__);
+		pr_err("dev pointer not filled in!\n");
 		err = -EINVAL;
 		goto out;
 	}
 
 	if (MAX_IRCTL_DEVICES <= d->minor) {
-		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-			"\"minor\" must be between 0 and %d (%d)!\n",
-			MAX_IRCTL_DEVICES - 1, d->minor);
+		dev_err(d->dev, "minor must be between 0 and %d!\n",
+						MAX_IRCTL_DEVICES - 1);
 		err = -EBADRQC;
 		goto out;
 	}
 
 	if (1 > d->code_length || (BUFLEN * 8) < d->code_length) {
-		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-			"code length in bits for minor (%d) "
-			"must be less than %d!\n",
-			d->minor, BUFLEN * 8);
+		dev_err(d->dev, "code length must be less than %d bits\n",
+								BUFLEN * 8);
 		err = -EBADRQC;
 		goto out;
 	}
 
 	if (d->sample_rate) {
 		if (2 > d->sample_rate || HZ < d->sample_rate) {
-			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-				"sample_rate must be between 2 and %d!\n", HZ);
+			dev_err(d->dev, "invalid %d sample rate\n",
+							d->sample_rate);
 			err = -EBADRQC;
 			goto out;
 		}
 		if (!d->add_to_buf) {
-			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-				"add_to_buf cannot be NULL when "
-				"sample_rate is set\n");
+			dev_err(d->dev, "add_to_buf not set\n");
 			err = -EBADRQC;
 			goto out;
 		}
 	} else if (!(d->fops && d->fops->read) && !d->rbuf) {
-		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-			"fops->read and rbuf cannot all be NULL!\n");
+		dev_err(d->dev, "fops->read and rbuf are NULL!\n");
 		err = -EBADRQC;
 		goto out;
 	} else if (!d->rbuf) {
 		if (!(d->fops && d->fops->read && d->fops->poll &&
 		      d->fops->unlocked_ioctl)) {
-			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-				"neither read, poll nor unlocked_ioctl can be NULL!\n");
+			dev_err(d->dev, "undefined read, poll, ioctl\n");
 			err = -EBADRQC;
 			goto out;
 		}
@@ -308,14 +302,12 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 			if (!irctls[minor])
 				break;
 		if (MAX_IRCTL_DEVICES == minor) {
-			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-				"no free slots for drivers!\n");
+			dev_err(d->dev, "no free slots for drivers!\n");
 			err = -ENOMEM;
 			goto out_lock;
 		}
 	} else if (irctls[minor]) {
-		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-			"minor (%d) just registered!\n", minor);
+		dev_err(d->dev, "minor (%d) just registered!\n", minor);
 		err = -EBUSY;
 		goto out_lock;
 	}
@@ -352,9 +344,8 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		/* try to fire up polling thread */
 		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
 		if (IS_ERR(ir->task)) {
-			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-				"cannot run poll thread for minor = %d\n",
-				d->minor);
+			dev_err(d->dev, "cannot run thread for minor = %d\n",
+								d->minor);
 			err = -ECHILD;
 			goto out_sysfs;
 		}
@@ -403,15 +394,14 @@ int lirc_unregister_driver(int minor)
 	struct cdev *cdev;
 
 	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
-		printk(KERN_ERR "lirc_dev: %s: minor (%d) must be between "
-		       "0 and %d!\n", __func__, minor, MAX_IRCTL_DEVICES - 1);
+		pr_err("minor (%d) must be between 0 and %d!\n",
+					minor, MAX_IRCTL_DEVICES - 1);
 		return -EBADRQC;
 	}
 
 	ir = irctls[minor];
 	if (!ir) {
-		printk(KERN_ERR "lirc_dev: %s: failed to get irctl struct "
-		       "for minor %d!\n", __func__, minor);
+		pr_err("failed to get irctl\n");
 		return -ENOENT;
 	}
 
@@ -420,8 +410,8 @@ int lirc_unregister_driver(int minor)
 	mutex_lock(&lirc_dev_lock);
 
 	if (ir->d.minor != minor) {
-		printk(KERN_ERR "lirc_dev: %s: minor (%d) device not "
-		       "registered!\n", __func__, minor);
+		dev_err(ir->d.dev, "lirc_dev: minor %d device not registered\n",
+									minor);
 		mutex_unlock(&lirc_dev_lock);
 		return -ENOENT;
 	}
@@ -463,8 +453,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	int retval = 0;
 
 	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
-		printk(KERN_WARNING "lirc_dev [%d]: open result = -ENODEV\n",
-		       iminor(inode));
+		pr_err("open result for %d is -ENODEV\n", iminor(inode));
 		return -ENODEV;
 	}
 
@@ -526,7 +515,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 	int ret;
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("called with invalid irctl\n");
 		return -EINVAL;
 	}
 
@@ -562,7 +551,7 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 	unsigned int ret;
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("called with invalid irctl\n");
 		return POLLERR;
 	}
 
@@ -593,7 +582,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct irctl *ir = irctls[iminor(file_inode(file))];
 
 	if (!ir) {
-		printk(KERN_ERR "lirc_dev: %s: no irctl found!\n", __func__);
+		pr_err("no irctl found!\n");
 		return -ENODEV;
 	}
 
@@ -601,7 +590,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		ir->d.name, ir->d.minor, cmd);
 
 	if (ir->d.minor == NOPLUG || !ir->attached) {
-		dev_dbg(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
+		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
 			ir->d.name, ir->d.minor);
 		return -ENODEV;
 	}
@@ -678,7 +667,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("called with invalid irctl\n");
 		return -ENODEV;
 	}
 
@@ -783,7 +772,7 @@ ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
 	struct irctl *ir = irctls[iminor(file_inode(file))];
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("called with invalid irctl\n");
 		return -ENODEV;
 	}
 
@@ -802,7 +791,7 @@ static int __init lirc_dev_init(void)
 	lirc_class = class_create(THIS_MODULE, "lirc");
 	if (IS_ERR(lirc_class)) {
 		retval = PTR_ERR(lirc_class);
-		printk(KERN_ERR "lirc_dev: class_create failed\n");
+		pr_err("class_create failed\n");
 		goto error;
 	}
 
@@ -810,13 +799,13 @@ static int __init lirc_dev_init(void)
 				     IRCTL_DEV_NAME);
 	if (retval) {
 		class_destroy(lirc_class);
-		printk(KERN_ERR "lirc_dev: alloc_chrdev_region failed\n");
+		pr_err("alloc_chrdev_region failed\n");
 		goto error;
 	}
 
 
-	printk(KERN_INFO "lirc_dev: IR Remote Control driver registered, "
-	       "major %d \n", MAJOR(lirc_base_dev));
+	pr_info("IR Remote Control driver registered, major %d\n",
+						MAJOR(lirc_base_dev));
 
 error:
 	return retval;
@@ -828,7 +817,7 @@ static void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
 	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
-	printk(KERN_INFO "lirc_dev: module unloaded\n");
+	pr_info("module unloaded\n");
 }
 
 module_init(lirc_dev_init);
-- 
2.8.1

