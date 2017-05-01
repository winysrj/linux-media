Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41261 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932455AbdEAQD6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:03:58 -0400
Subject: [PATCH 04/16] lirc_dev: remove sampling kthread
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:03:56 +0200
Message-ID: <149365463626.12922.6836791204953833705.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no drivers which use this functionality.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c             |   94 +------------------------------
 drivers/staging/media/lirc/lirc_zilog.c |    1 
 include/media/lirc_dev.h                |   16 -----
 3 files changed, 2 insertions(+), 109 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 7f13ed479e1c..5c2b009b6d50 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -28,7 +28,6 @@
 #include <linux/mutex.h>
 #include <linux/wait.h>
 #include <linux/unistd.h>
-#include <linux/kthread.h>
 #include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
@@ -57,9 +56,6 @@ struct irctl {
 
 	struct device dev;
 	struct cdev cdev;
-
-	struct task_struct *task;
-	long jiffies_to_wait;
 };
 
 static DEFINE_MUTEX(lirc_dev_lock);
@@ -95,59 +91,6 @@ static void lirc_release(struct device *ld)
 	kfree(ir);
 }
 
-/*  helper function
- *  reads key codes from driver and puts them into buffer
- *  returns 0 on success
- */
-static int lirc_add_to_buf(struct irctl *ir)
-{
-	int res;
-	int got_data = -1;
-
-	if (!ir->d.add_to_buf)
-		return 0;
-
-	/*
-	 * service the device as long as it is returning
-	 * data and we have space
-	 */
-	do {
-		got_data++;
-		res = ir->d.add_to_buf(ir->d.data, ir->buf);
-	} while (!res);
-
-	if (res == -ENODEV)
-		kthread_stop(ir->task);
-
-	return got_data ? 0 : res;
-}
-
-/* main function of the polling thread
- */
-static int lirc_thread(void *irctl)
-{
-	struct irctl *ir = irctl;
-
-	do {
-		if (ir->open) {
-			if (ir->jiffies_to_wait) {
-				set_current_state(TASK_INTERRUPTIBLE);
-				schedule_timeout(ir->jiffies_to_wait);
-			}
-			if (kthread_should_stop())
-				break;
-			if (!lirc_add_to_buf(ir))
-				wake_up_interruptible(&ir->buf->wait_poll);
-		} else {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule();
-		}
-	} while (!kthread_should_stop());
-
-	return 0;
-}
-
-
 static const struct file_operations lirc_dev_fops = {
 	.owner		= THIS_MODULE,
 	.read		= lirc_dev_fop_read,
@@ -252,18 +195,8 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		return -EBADRQC;
 	}
 
-	if (d->sample_rate) {
-		if (2 > d->sample_rate || HZ < d->sample_rate) {
-			dev_err(d->dev, "invalid %d sample rate\n",
-							d->sample_rate);
-			return -EBADRQC;
-		}
-		if (!d->add_to_buf) {
-			dev_err(d->dev, "add_to_buf not set\n");
-			return -EBADRQC;
-		}
-	} else if (!d->rbuf && !(d->fops && d->fops->read &&
-				d->fops->poll && d->fops->unlocked_ioctl)) {
+	if (!d->rbuf && !(d->fops && d->fops->read &&
+			  d->fops->poll && d->fops->unlocked_ioctl)) {
 		dev_err(d->dev, "undefined read, poll, ioctl\n");
 		return -EBADRQC;
 	}
@@ -312,22 +245,6 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	dev_set_name(&ir->dev, "lirc%d", ir->d.minor);
 	device_initialize(&ir->dev);
 
-	if (d->sample_rate) {
-		ir->jiffies_to_wait = HZ / d->sample_rate;
-
-		/* try to fire up polling thread */
-		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
-		if (IS_ERR(ir->task)) {
-			dev_err(d->dev, "cannot run thread for minor = %d\n",
-								d->minor);
-			err = -ECHILD;
-			goto out_sysfs;
-		}
-	} else {
-		/* it means - wait for external event in task queue */
-		ir->jiffies_to_wait = 0;
-	}
-
 	err = lirc_cdev_add(ir);
 	if (err)
 		goto out_sysfs;
@@ -404,10 +321,6 @@ int lirc_unregister_driver(int minor)
 		return -ENOENT;
 	}
 
-	/* end up polling thread */
-	if (ir->task)
-		kthread_stop(ir->task);
-
 	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		ir->d.name, ir->d.minor);
 
@@ -470,9 +383,6 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	if (ir->buf)
 		lirc_buffer_clear(ir->buf);
 
-	if (ir->task)
-		wake_up_process(ir->task);
-
 	ir->open++;
 
 	nonseekable_open(inode, file);
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 436cf1b6a70a..8d8fd8b164e2 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1385,7 +1385,6 @@ static struct lirc_driver lirc_template = {
 	.minor		= -1,
 	.code_length	= 13,
 	.buffer_size	= BUFLEN / 2,
-	.sample_rate	= 0, /* tell lirc_dev to not start its own kthread */
 	.chunk_size	= 2,
 	.fops		= &lirc_fops,
 	.owner		= THIS_MODULE,
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 71c1c11950fe..01649b009922 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -133,12 +133,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  * @buffer_size:	Number of FIFO buffers with @chunk_size size. If zero,
  *			creates a buffer with BUFLEN size (16 bytes).
  *
- * @sample_rate:	if zero, the device will wait for an event with a new
- *			code to be parsed. Otherwise, specifies the sample
- *			rate for polling. Value should be between 0
- *			and HZ. If equal to HZ, it would mean one polling per
- *			second.
- *
  * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
  *			LIRC_CAN\_\*, as defined at include/media/lirc.h.
  *
@@ -153,14 +147,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  * @max_timeout:	Maximum timeout for record. Valid only if
  *			LIRC_CAN_SET_REC_TIMEOUT is defined.
  *
- * @add_to_buf:		add_to_buf will be called after specified period of the
- *			time or triggered by the external event, this behavior
- *			depends on value of the sample_rate this function will
- *			be called in user context. This routine should return
- *			0 if data was added to the buffer and -ENODATA if none
- *			was available. This should add some number of bits
- *			evenly divisible by code_length to the buffer.
- *
  * @rbuf:		if not NULL, it will be used as a read buffer, you will
  *			have to write to the buffer by other means, like irq's
  *			(see also lirc_serial.c).
@@ -184,7 +170,6 @@ struct lirc_driver {
 	int minor;
 	__u32 code_length;
 	unsigned int buffer_size; /* in chunks holding one code each */
-	int sample_rate;
 	__u32 features;
 
 	unsigned int chunk_size;
@@ -192,7 +177,6 @@ struct lirc_driver {
 	void *data;
 	int min_timeout;
 	int max_timeout;
-	int (*add_to_buf)(void *data, struct lirc_buffer *buf);
 	struct lirc_buffer *rbuf;
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
