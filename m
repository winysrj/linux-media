Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41272 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756827AbdEAQEI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:08 -0400
Subject: [PATCH 06/16] lirc_dev: make fops mandatory
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:06 +0200
Message-ID: <149365464644.12922.14714405352508242791.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every caller of lirc_register_driver() passes their own fops and there are no
users of lirc_dev_fop_write() in the kernel tree. Thus we can make fops
mandatory and remove lirc_dev_fop_write().

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   41 +++++------------------------------------
 include/media/lirc_dev.h    |    3 ---
 2 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index fb487c39b834..29eecddbd371 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -91,17 +91,6 @@ static void lirc_release(struct device *ld)
 	kfree(ir);
 }
 
-static const struct file_operations lirc_dev_fops = {
-	.owner		= THIS_MODULE,
-	.read		= lirc_dev_fop_read,
-	.write		= lirc_dev_fop_write,
-	.poll		= lirc_dev_fop_poll,
-	.unlocked_ioctl	= lirc_dev_fop_ioctl,
-	.open		= lirc_dev_fop_open,
-	.release	= lirc_dev_fop_close,
-	.llseek		= noop_llseek,
-};
-
 static int lirc_cdev_add(struct irctl *ir)
 {
 	struct lirc_driver *d = &ir->d;
@@ -110,13 +99,11 @@ static int lirc_cdev_add(struct irctl *ir)
 
 	cdev = &ir->cdev;
 
-	if (d->fops) {
-		cdev_init(cdev, d->fops);
-		cdev->owner = d->owner;
-	} else {
-		cdev_init(cdev, &lirc_dev_fops);
-		cdev->owner = THIS_MODULE;
-	}
+	if (!d->fops)
+		return -EINVAL;
+
+	cdev_init(cdev, d->fops);
+	cdev->owner = d->owner;
 	retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
 	if (retval)
 		return retval;
@@ -640,24 +627,6 @@ void *lirc_get_pdata(struct file *file)
 EXPORT_SYMBOL(lirc_get_pdata);
 
 
-ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
-			   size_t length, loff_t *ppos)
-{
-	struct irctl *ir = irctls[iminor(file_inode(file))];
-
-	if (!ir) {
-		pr_err("called with invalid irctl\n");
-		return -ENODEV;
-	}
-
-	if (!ir->attached)
-		return -ENODEV;
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL(lirc_dev_fop_write);
-
-
 static int __init lirc_dev_init(void)
 {
 	int retval;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 01649b009922..1f327e25a9be 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -210,7 +210,4 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
 long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 ssize_t lirc_dev_fop_read(struct file *file, char __user *buffer, size_t length,
 			  loff_t *ppos);
-ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
-			   size_t length, loff_t *ppos);
-
 #endif
