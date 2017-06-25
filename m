Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56456 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751380AbdFYMcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:53 -0400
Subject: [PATCH 18/19] ir-lirc-codec: move the remaining fops over from
 lirc_dev
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:46 +0200
Message-ID: <149839396621.28811.5951599925136231229.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir-lirc-codec is the only user of these functions, so instead of exporting them
from lirc_dev, move all of them over to ir-lirc-codec.

This means that all ir-lirc-codec fops can be found next to each other in
ir-lirc-codec.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |  181 ++++++++++++++++++++++++++++++++++++-
 drivers/media/rc/lirc_dev.c      |  187 --------------------------------------
 include/media/lirc_dev.h         |    8 --
 3 files changed, 178 insertions(+), 198 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index f914a3d5a468..05f88401f694 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/wait.h>
 #include <linux/module.h>
 #include <media/lirc.h>
@@ -21,6 +22,7 @@
 #include "rc-core-priv.h"
 
 #define LIRCBUF_SIZE 256
+#define LOGHEAD	"lirc_dev (%s[%d]): "
 
 /**
  * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
@@ -369,6 +371,177 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
+static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
+			    size_t length, loff_t *ppos)
+{
+	struct lirc_dev *d = file->private_data;
+	unsigned char buf[d->buf->chunk_size];
+	int ret, written = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	dev_dbg(&d->dev, LOGHEAD "read called\n", d->name, d->minor);
+
+	ret = mutex_lock_interruptible(&d->mutex);
+	if (ret)
+		return ret;
+
+	if (!d->attached) {
+		ret = -ENODEV;
+		goto out_locked;
+	}
+
+	if (!LIRC_CAN_REC(d->features)) {
+		ret = -EINVAL;
+		goto out_locked;
+	}
+
+	if (length % d->buf->chunk_size) {
+		ret = -EINVAL;
+		goto out_locked;
+	}
+
+	/*
+	 * we add ourselves to the task queue before buffer check
+	 * to avoid losing scan code (in case when queue is awaken somewhere
+	 * between while condition checking and scheduling)
+	 */
+	add_wait_queue(&d->buf->wait_poll, &wait);
+
+	/*
+	 * while we didn't provide 'length' bytes, device is opened in blocking
+	 * mode and 'copy_to_user' is happy, wait for data.
+	 */
+	while (written < length && ret == 0) {
+		if (lirc_buffer_empty(d->buf)) {
+			/* According to the read(2) man page, 'written' can be
+			 * returned as less than 'length', instead of blocking
+			 * again, returning -EWOULDBLOCK, or returning
+			 * -ERESTARTSYS
+			 */
+			if (written)
+				break;
+			if (file->f_flags & O_NONBLOCK) {
+				ret = -EWOULDBLOCK;
+				break;
+			}
+			if (signal_pending(current)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+
+			mutex_unlock(&d->mutex);
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+			set_current_state(TASK_RUNNING);
+
+			ret = mutex_lock_interruptible(&d->mutex);
+			if (ret) {
+				remove_wait_queue(&d->buf->wait_poll, &wait);
+				goto out_unlocked;
+			}
+
+			if (!d->attached) {
+				ret = -ENODEV;
+				goto out_locked;
+			}
+		} else {
+			lirc_buffer_read(d->buf, buf);
+			ret = copy_to_user((void __user *)buffer+written, buf,
+					   d->buf->chunk_size);
+			if (!ret)
+				written += d->buf->chunk_size;
+			else
+				ret = -EFAULT;
+		}
+	}
+
+	remove_wait_queue(&d->buf->wait_poll, &wait);
+
+out_locked:
+	mutex_unlock(&d->mutex);
+
+out_unlocked:
+	return ret ? ret : written;
+}
+
+static unsigned int ir_lirc_poll(struct file *file, poll_table *wait)
+{
+	struct lirc_dev *d = file->private_data;
+	unsigned int ret;
+
+	if (!d->attached)
+		return POLLHUP | POLLERR;
+
+	if (d->buf) {
+		poll_wait(file, &d->buf->wait_poll, wait);
+
+		if (lirc_buffer_empty(d->buf))
+			ret = 0;
+		else
+			ret = POLLIN | POLLRDNORM;
+	} else
+		ret = POLLERR;
+
+	dev_dbg(&d->dev, LOGHEAD "poll result = %d\n", d->name, d->minor, ret);
+
+	return ret;
+}
+
+static int ir_lirc_open(struct inode *inode, struct file *file)
+{
+	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
+	int retval;
+
+	dev_dbg(&d->dev, LOGHEAD "open called\n", d->name, d->minor);
+
+	retval = mutex_lock_interruptible(&d->mutex);
+	if (retval)
+		return retval;
+
+	if (!d->attached) {
+		retval = -ENODEV;
+		goto out;
+	}
+
+	if (d->open) {
+		retval = -EBUSY;
+		goto out;
+	}
+
+	retval = rc_open(d->rdev);
+	if (retval)
+		goto out;
+
+	if (d->buf)
+		lirc_buffer_clear(d->buf);
+
+	d->open++;
+
+	lirc_init_pdata(inode, file);
+	nonseekable_open(inode, file);
+	mutex_unlock(&d->mutex);
+
+	return 0;
+
+out:
+	mutex_unlock(&d->mutex);
+	return retval;
+}
+
+static int ir_lirc_close(struct inode *inode, struct file *file)
+{
+	struct lirc_dev *d = file->private_data;
+
+	mutex_lock(&d->mutex);
+
+	rc_close(d->rdev);
+	d->open--;
+
+	mutex_unlock(&d->mutex);
+
+	return 0;
+}
+
 static const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
@@ -376,10 +549,10 @@ static const struct file_operations lirc_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ir_lirc_ioctl,
 #endif
-	.read		= lirc_dev_fop_read,
-	.poll		= lirc_dev_fop_poll,
-	.open		= lirc_dev_fop_open,
-	.release	= lirc_dev_fop_close,
+	.read		= ir_lirc_read,
+	.poll		= ir_lirc_poll,
+	.open		= ir_lirc_open,
+	.release	= ir_lirc_close,
 	.llseek		= no_llseek,
 };
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 278d9b34d382..c1c917932f7e 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -18,7 +18,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/sched/signal.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
@@ -29,8 +28,6 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-#define LOGHEAD		"lirc_dev (%s[%d]): "
-
 static dev_t lirc_base_dev;
 
 /* Used to keep track of allocated lirc devices */
@@ -192,11 +189,8 @@ void lirc_unregister_device(struct lirc_dev *d)
 	mutex_lock(&d->mutex);
 
 	d->attached = false;
-	if (d->open) {
-		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
-			d->name, d->minor);
+	if (d->open)
 		wake_up_interruptible(&d->buf->wait_poll);
-	}
 
 	mutex_unlock(&d->mutex);
 
@@ -206,185 +200,6 @@ void lirc_unregister_device(struct lirc_dev *d)
 }
 EXPORT_SYMBOL(lirc_unregister_device);
 
-int lirc_dev_fop_open(struct inode *inode, struct file *file)
-{
-	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
-	int retval;
-
-	dev_dbg(&d->dev, LOGHEAD "open called\n", d->name, d->minor);
-
-	retval = mutex_lock_interruptible(&d->mutex);
-	if (retval)
-		return retval;
-
-	if (!d->attached) {
-		retval = -ENODEV;
-		goto out;
-	}
-
-	if (d->open) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	if (d->rdev) {
-		retval = rc_open(d->rdev);
-		if (retval)
-			goto out;
-	}
-
-	if (d->buf)
-		lirc_buffer_clear(d->buf);
-
-	d->open++;
-
-	lirc_init_pdata(inode, file);
-	nonseekable_open(inode, file);
-	mutex_unlock(&d->mutex);
-
-	return 0;
-
-out:
-	mutex_unlock(&d->mutex);
-	return retval;
-}
-EXPORT_SYMBOL(lirc_dev_fop_open);
-
-int lirc_dev_fop_close(struct inode *inode, struct file *file)
-{
-	struct lirc_dev *d = file->private_data;
-
-	mutex_lock(&d->mutex);
-
-	rc_close(d->rdev);
-	d->open--;
-
-	mutex_unlock(&d->mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL(lirc_dev_fop_close);
-
-unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
-{
-	struct lirc_dev *d = file->private_data;
-	unsigned int ret;
-
-	if (!d->attached)
-		return POLLHUP | POLLERR;
-
-	if (d->buf) {
-		poll_wait(file, &d->buf->wait_poll, wait);
-
-		if (lirc_buffer_empty(d->buf))
-			ret = 0;
-		else
-			ret = POLLIN | POLLRDNORM;
-	} else
-		ret = POLLERR;
-
-	dev_dbg(&d->dev, LOGHEAD "poll result = %d\n", d->name, d->minor, ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(lirc_dev_fop_poll);
-
-ssize_t lirc_dev_fop_read(struct file *file,
-			  char __user *buffer,
-			  size_t length,
-			  loff_t *ppos)
-{
-	struct lirc_dev *d = file->private_data;
-	unsigned char buf[d->buf->chunk_size];
-	int ret, written = 0;
-	DECLARE_WAITQUEUE(wait, current);
-
-	dev_dbg(&d->dev, LOGHEAD "read called\n", d->name, d->minor);
-
-	ret = mutex_lock_interruptible(&d->mutex);
-	if (ret)
-		return ret;
-
-	if (!d->attached) {
-		ret = -ENODEV;
-		goto out_locked;
-	}
-
-	if (!LIRC_CAN_REC(d->features)) {
-		ret = -EINVAL;
-		goto out_locked;
-	}
-
-	if (length % d->buf->chunk_size) {
-		ret = -EINVAL;
-		goto out_locked;
-	}
-
-	/*
-	 * we add ourselves to the task queue before buffer check
-	 * to avoid losing scan code (in case when queue is awaken somewhere
-	 * between while condition checking and scheduling)
-	 */
-	add_wait_queue(&d->buf->wait_poll, &wait);
-
-	/*
-	 * while we didn't provide 'length' bytes, device is opened in blocking
-	 * mode and 'copy_to_user' is happy, wait for data.
-	 */
-	while (written < length && ret == 0) {
-		if (lirc_buffer_empty(d->buf)) {
-			/* According to the read(2) man page, 'written' can be
-			 * returned as less than 'length', instead of blocking
-			 * again, returning -EWOULDBLOCK, or returning
-			 * -ERESTARTSYS
-			 */
-			if (written)
-				break;
-			if (file->f_flags & O_NONBLOCK) {
-				ret = -EWOULDBLOCK;
-				break;
-			}
-			if (signal_pending(current)) {
-				ret = -ERESTARTSYS;
-				break;
-			}
-
-			mutex_unlock(&d->mutex);
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule();
-			set_current_state(TASK_RUNNING);
-
-			ret = mutex_lock_interruptible(&d->mutex);
-			if (ret) {
-				remove_wait_queue(&d->buf->wait_poll, &wait);
-				goto out_unlocked;
-			}
-
-			if (!d->attached) {
-				ret = -ENODEV;
-				goto out_locked;
-			}
-		} else {
-			lirc_buffer_read(d->buf, buf);
-			ret = copy_to_user((void __user *)buffer+written, buf,
-					   d->buf->chunk_size);
-			if (!ret)
-				written += d->buf->chunk_size;
-			else
-				ret = -EFAULT;
-		}
-	}
-
-	remove_wait_queue(&d->buf->wait_poll, &wait);
-
-out_locked:
-	mutex_unlock(&d->mutex);
-
-out_unlocked:
-	return ret ? ret : written;
-}
-EXPORT_SYMBOL(lirc_dev_fop_read);
-
 void lirc_init_pdata(struct inode *inode, struct file *file)
 {
 	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index e1bf7ef20fdc..710d8abc9962 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -178,12 +178,4 @@ void lirc_init_pdata(struct inode *inode, struct file *file);
  */
 void *lirc_get_pdata(struct file *file);
 
-/* default file operations
- * used by drivers if they override only some operations
- */
-int lirc_dev_fop_open(struct inode *inode, struct file *file);
-int lirc_dev_fop_close(struct inode *inode, struct file *file);
-unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
-ssize_t lirc_dev_fop_read(struct file *file, char __user *buffer, size_t length,
-			  loff_t *ppos);
 #endif
