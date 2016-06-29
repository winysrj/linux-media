Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbcF2NVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:00 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 04/15] lirc_dev: replace printk with pr_* or dev_*
Date: Wed, 29 Jun 2016 22:20:33 +0900
Message-id: <1467206444-9935-5-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch mutes also all the checkpatch warnings related to
printk.

Reword all the printouts so that the string doesn't need to be
split, which fixes the following checkpatch warning:

  WARNING: quoted string split across lines

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 76 +++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index ee997ab..b11ab5c 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -240,59 +240,51 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	int err;
 
 	if (!d) {
-		printk(KERN_ERR "lirc_dev: lirc_register_driver: "
-		       "driver pointer must be not NULL!\n");
+		pr_err("lirc_dev: driver pointer must be not NULL!\n");
 		err = -EBADRQC;
 		goto out;
 	}
 
 	if (!d->dev) {
-		printk(KERN_ERR "%s: dev pointer not filled in!\n", __func__);
+		pr_err("%s: dev pointer not filled in!\n", __func__);
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
@@ -308,14 +300,12 @@ static int lirc_allocate_driver(struct lirc_driver *d)
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
@@ -352,9 +342,8 @@ static int lirc_allocate_driver(struct lirc_driver *d)
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
@@ -407,15 +396,14 @@ int lirc_unregister_driver(int minor)
 	struct cdev *cdev;
 
 	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
-		printk(KERN_ERR "lirc_dev: %s: minor (%d) must be between "
-		       "0 and %d!\n", __func__, minor, MAX_IRCTL_DEVICES - 1);
+		pr_err("lirc_dev: %s: minor (%d) must be between 0 and %d!\n",
+				__func__, minor, MAX_IRCTL_DEVICES - 1);
 		return -EBADRQC;
 	}
 
 	ir = irctls[minor];
 	if (!ir) {
-		printk(KERN_ERR "lirc_dev: %s: failed to get irctl struct "
-		       "for minor %d!\n", __func__, minor);
+		pr_err("lirc_dev: %s: failed to get irctl\n", __func__);
 		return -ENOENT;
 	}
 
@@ -424,8 +412,8 @@ int lirc_unregister_driver(int minor)
 	mutex_lock(&lirc_dev_lock);
 
 	if (ir->d.minor != minor) {
-		printk(KERN_ERR "lirc_dev: %s: minor (%d) device not "
-		       "registered!\n", __func__, minor);
+		dev_err(ir->d.dev, "lirc_dev: minor %d device not registered\n",
+									minor);
 		mutex_unlock(&lirc_dev_lock);
 		return -ENOENT;
 	}
@@ -467,7 +455,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	int retval = 0;
 
 	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
-		printk(KERN_WARNING "lirc_dev [%d]: open result = -ENODEV\n",
+		pr_err("lirc_dev [%d]: open result = -ENODEV\n",
 		       iminor(inode));
 		return -ENODEV;
 	}
@@ -530,7 +518,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 	int ret;
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("%s: called with invalid irctl\n", __func__);
 		return -EINVAL;
 	}
 
@@ -566,7 +554,7 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 	unsigned int ret;
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("%s: called with invalid irctl\n", __func__);
 		return POLLERR;
 	}
 
@@ -597,7 +585,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct irctl *ir = irctls[iminor(file_inode(file))];
 
 	if (!ir) {
-		printk(KERN_ERR "lirc_dev: %s: no irctl found!\n", __func__);
+		pr_err("lirc_dev: %s: no irctl found!\n", __func__);
 		return -ENODEV;
 	}
 
@@ -605,7 +593,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		ir->d.name, ir->d.minor, cmd);
 
 	if (ir->d.minor == NOPLUG || !ir->attached) {
-		dev_dbg(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
+		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
 			ir->d.name, ir->d.minor);
 		return -ENODEV;
 	}
@@ -682,7 +670,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("%s: called with invalid irctl\n", __func__);
 		return -ENODEV;
 	}
 
@@ -787,7 +775,7 @@ ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
 	struct irctl *ir = irctls[iminor(file_inode(file))];
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
+		pr_err("%s: called with invalid irctl\n", __func__);
 		return -ENODEV;
 	}
 
@@ -806,7 +794,7 @@ static int __init lirc_dev_init(void)
 	lirc_class = class_create(THIS_MODULE, "lirc");
 	if (IS_ERR(lirc_class)) {
 		retval = PTR_ERR(lirc_class);
-		printk(KERN_ERR "lirc_dev: class_create failed\n");
+		pr_err("lirc_dev: class_create failed\n");
 		goto error;
 	}
 
@@ -814,13 +802,13 @@ static int __init lirc_dev_init(void)
 				     IRCTL_DEV_NAME);
 	if (retval) {
 		class_destroy(lirc_class);
-		printk(KERN_ERR "lirc_dev: alloc_chrdev_region failed\n");
+		pr_err("lirc_dev: alloc_chrdev_region failed\n");
 		goto error;
 	}
 
 
-	printk(KERN_INFO "lirc_dev: IR Remote Control driver registered, "
-	       "major %d \n", MAJOR(lirc_base_dev));
+	pr_info("lirc_dev: IR Remote Control driver registered, major %d\n",
+							MAJOR(lirc_base_dev));
 
 error:
 	return retval;
@@ -832,7 +820,7 @@ static void __exit lirc_dev_exit(void)
 {
 	class_destroy(lirc_class);
 	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
-	printk(KERN_INFO "lirc_dev: module unloaded\n");
+	pr_info("lirc_dev: module unloaded\n");
 }
 
 module_init(lirc_dev_init);
-- 
2.8.1

