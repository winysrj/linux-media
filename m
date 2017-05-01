Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41240 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757788AbdEAQDs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:03:48 -0400
Subject: [PATCH 02/16] lirc_dev: remove unused set_use_inc/set_use_dec
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:03:46 +0200
Message-ID: <149365462608.12922.6571054209014823717.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since there are no users of this functionality, it can be removed altogether.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |    2 --
 drivers/media/rc/lirc_dev.c      |   24 ++++++------------------
 include/media/lirc_dev.h         |    6 ------
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index fc58745b26b8..a30af91710fe 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -386,8 +386,6 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->features = features;
 	drv->data = &dev->raw->lirc;
 	drv->rbuf = NULL;
-	drv->set_use_inc = NULL;
-	drv->set_use_dec = NULL;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->chunk_size = sizeof(int);
 	drv->buffer_size = LIRCBUF_SIZE;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 42704552b005..05f600bd6c67 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -418,12 +418,6 @@ int lirc_unregister_driver(int minor)
 		wake_up_interruptible(&ir->buf->wait_poll);
 	}
 
-	mutex_lock(&ir->irctl_lock);
-
-	if (ir->d.set_use_dec)
-		ir->d.set_use_dec(ir->d.data);
-
-	mutex_unlock(&ir->irctl_lock);
 	mutex_unlock(&lirc_dev_lock);
 
 	device_del(&ir->dev);
@@ -473,17 +467,13 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 			goto error;
 	}
 
+	if (ir->buf)
+		lirc_buffer_clear(ir->buf);
+
+	if (ir->task)
+		wake_up_process(ir->task);
+
 	ir->open++;
-	if (ir->d.set_use_inc)
-		retval = ir->d.set_use_inc(ir->d.data);
-	if (retval) {
-		ir->open--;
-	} else {
-		if (ir->buf)
-			lirc_buffer_clear(ir->buf);
-		if (ir->task)
-			wake_up_process(ir->task);
-	}
 
 error:
 	nonseekable_open(inode, file);
@@ -508,8 +498,6 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 	rc_close(ir->d.rdev);
 
 	ir->open--;
-	if (ir->d.set_use_dec)
-		ir->d.set_use_dec(ir->d.data);
 	if (!ret)
 		mutex_unlock(&lirc_dev_lock);
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index cec7d35602d1..71c1c11950fe 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -165,10 +165,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *			have to write to the buffer by other means, like irq's
  *			(see also lirc_serial.c).
  *
- * @set_use_inc:	set_use_inc will be called after device is opened
- *
- * @set_use_dec:	set_use_dec will be called after device is closed
- *
  * @rdev:		Pointed to struct rc_dev associated with the LIRC
  *			device.
  *
@@ -198,8 +194,6 @@ struct lirc_driver {
 	int max_timeout;
 	int (*add_to_buf)(void *data, struct lirc_buffer *buf);
 	struct lirc_buffer *rbuf;
-	int (*set_use_inc)(void *data);
-	void (*set_use_dec)(void *data);
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
 	struct device *dev;
