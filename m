Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46763 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbcGFJn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:43:57 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 03/15] [media] lirc_dev: remove unnecessary debug prints
Date: Wed, 06 Jul 2016 18:01:15 +0900
Message-id: <1467795687-10737-4-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 154e553..9f20f94 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -80,8 +80,6 @@ static void lirc_irctl_init(struct irctl *ir)
 
 static void lirc_irctl_cleanup(struct irctl *ir)
 {
-	dev_dbg(ir->d.dev, LOGHEAD "cleaning up\n", ir->d.name, ir->d.minor);
-
 	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
 
 	if (ir->buf != ir->d.rbuf) {
@@ -127,9 +125,6 @@ static int lirc_thread(void *irctl)
 {
 	struct irctl *ir = irctl;
 
-	dev_dbg(ir->d.dev, LOGHEAD "poll thread started\n",
-		ir->d.name, ir->d.minor);
-
 	do {
 		if (ir->open) {
 			if (ir->jiffies_to_wait) {
@@ -146,9 +141,6 @@ static int lirc_thread(void *irctl)
 		}
 	} while (!kthread_should_stop());
 
-	dev_dbg(ir->d.dev, LOGHEAD "poll thread ended\n",
-		ir->d.name, ir->d.minor);
-
 	return 0;
 }
 
@@ -277,8 +269,6 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		goto out;
 	}
 
-	dev_dbg(d->dev, "lirc_dev: lirc_register_driver: sample_rate: %d\n",
-		d->sample_rate);
 	if (d->sample_rate) {
 		if (2 > d->sample_rate || HZ < d->sample_rate) {
 			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
@@ -521,10 +511,6 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	}
 
 error:
-	if (ir)
-		dev_dbg(ir->d.dev, LOGHEAD "open result = %d\n",
-			ir->d.name, ir->d.minor, retval);
-
 	mutex_unlock(&lirc_dev_lock);
 
 	nonseekable_open(inode, file);
@@ -546,8 +532,6 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 
 	cdev = ir->cdev;
 
-	dev_dbg(ir->d.dev, LOGHEAD "close called\n", ir->d.name, ir->d.minor);
-
 	ret = mutex_lock_killable(&lirc_dev_lock);
 	WARN_ON(ret);
 
@@ -582,8 +566,6 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 		return POLLERR;
 	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "poll called\n", ir->d.name, ir->d.minor);
-
 	if (!ir->attached)
 		return POLLERR;
 
@@ -679,9 +661,6 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		result = -EINVAL;
 	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "ioctl result = %d\n",
-		ir->d.name, ir->d.minor, result);
-
 	mutex_unlock(&ir->irctl_lock);
 
 	return result;
@@ -786,8 +765,6 @@ out_locked:
 
 out_unlocked:
 	kfree(buf);
-	dev_dbg(ir->d.dev, LOGHEAD "read result = %s (%d)\n",
-		ir->d.name, ir->d.minor, ret ? "<fail>" : "<ok>", ret);
 
 	return ret ? ret : written;
 }
@@ -810,8 +787,6 @@ ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
 		return -ENODEV;
 	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "write called\n", ir->d.name, ir->d.minor);
-
 	if (!ir->attached)
 		return -ENODEV;
 
-- 
2.8.1

