Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41333 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760315AbdEAQEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:54 -0400
Subject: [PATCH 15/16] lirc_dev: remove name from struct lirc_driver
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:52 +0200
Message-ID: <149365469232.12922.13451178429094271759.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The name is only used for a few debug messages and the name of the parent
device as well as the name of the lirc device (e.g. "lirc0") are sufficient
anyway.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c        |    2 --
 drivers/media/rc/lirc_dev.c             |   25 ++++++++-----------------
 drivers/staging/media/lirc/lirc_zilog.c |    1 -
 include/media/lirc_dev.h                |    3 ---
 4 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 2c1221a61ea1..74ce27f92901 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -380,8 +380,6 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (dev->max_timeout)
 		features |= LIRC_CAN_SET_REC_TIMEOUT;
 
-	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
-		 dev->driver_name);
 	drv->features = features;
 	drv->data = &dev->raw->lirc;
 	drv->rbuf = NULL;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 4ba6c7e2d41b..10783ef75a25 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -28,8 +28,6 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-#define LOGHEAD		"lirc_dev (%s[%d]): "
-
 static dev_t lirc_base_dev;
 
 /**
@@ -160,7 +158,6 @@ lirc_register_driver(struct lirc_driver *d)
 		return -EBADRQC;
 	}
 
-	d->name[sizeof(d->name)-1] = '\0';
 	if (d->features == 0)
 		d->features = LIRC_CAN_REC_LIRCCODE;
 
@@ -207,8 +204,7 @@ lirc_register_driver(struct lirc_driver *d)
 	if (err)
 		goto out_cdev;
 
-	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 ir->d.name, ir->d.minor);
+	dev_info(ir->d.dev, "lirc device registered as lirc%d\n", minor);
 
 	d->lirc_internal = ir;
 	return 0;
@@ -242,13 +238,11 @@ lirc_unregister_driver(struct lirc_driver *d)
 
 	mutex_lock(&ir->mutex);
 
-	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
-		ir->d.name, ir->d.minor);
+	dev_dbg(&ir->dev, "unregistered\n");
 
 	ir->dead = true;
 	if (ir->users) {
-		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
-			ir->d.name, ir->d.minor);
+		dev_dbg(&ir->dev, "releasing opened driver\n");
 		wake_up_interruptible(&ir->buf->wait_poll);
 	}
 
@@ -278,7 +272,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	mutex_unlock(&ir->mutex);
 
-	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
+	dev_dbg(&ir->dev, "open called\n");
 
 	if (ir->d.rdev) {
 		retval = rc_open(ir->d.rdev);
@@ -332,8 +326,7 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 	else
 		ret = POLLIN | POLLRDNORM;
 
-	dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",
-		ir->d.name, ir->d.minor, ret);
+	dev_dbg(&ir->dev, "poll result = %d\n", ret);
 
 	return ret;
 }
@@ -345,12 +338,10 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	__u32 mode;
 	int result = 0;
 
-	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
-		ir->d.name, ir->d.minor, cmd);
+	dev_dbg(&ir->dev, "ioctl called (0x%x)\n", cmd);
 
 	if (ir->dead) {
-		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
-			ir->d.name, ir->d.minor);
+		dev_err(&ir->dev, "ioctl result = -ENODEV\n");
 		return -ENODEV;
 	}
 
@@ -428,7 +419,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	if (!LIRC_CAN_REC(ir->d.features))
 		return -EINVAL;
 
-	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
+	dev_dbg(&ir->dev, "read called\n");
 
 	buf = kzalloc(ir->chunk_size, GFP_KERNEL);
 	if (!buf)
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index ffb70dee4547..131d87a04aab 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1377,7 +1377,6 @@ static const struct file_operations lirc_fops = {
 };
 
 static struct lirc_driver lirc_template = {
-	.name		= "lirc_zilog",
 	.code_length	= 13,
 	.buffer_size	= BUFLEN / 2,
 	.chunk_size	= 2,
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index f7629ff116a9..11f455a34090 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -120,8 +120,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 /**
  * struct lirc_driver - Defines the parameters on a LIRC driver
  *
- * @name:		this string will be used for logs
- *
  * @minor:		indicates minor device (/dev/lirc) number for
  *			registered driver if caller fills it with negative
  *			value, then the first free minor number will be used
@@ -167,7 +165,6 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  * @lirc_internal:	lirc_dev bookkeeping data, don't touch.
  */
 struct lirc_driver {
-	char name[40];
 	int minor;
 	__u32 code_length;
 	unsigned int buffer_size; /* in chunks holding one code each */
