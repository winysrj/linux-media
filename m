Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56430 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:18 -0400
Subject: [PATCH 11/19] lirc_dev: rename struct lirc_driver to struct lirc_dev
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:10 +0200
Message-ID: <149839393066.28811.15700811162289307659.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is in preparation for the later patches which do away with
struct irctl entirely.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c        |   50 ++++++++++++++++---------------
 drivers/media/rc/lirc_dev.c             |   12 ++++---
 drivers/media/rc/rc-core-priv.h         |    2 +
 drivers/staging/media/lirc/lirc_zilog.c |   12 ++++---
 include/media/lirc_dev.h                |   46 ++++++++---------------------
 5 files changed, 51 insertions(+), 71 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 2c1221a61ea1..2349630ed383 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
+	if (!dev->raw->lirc.ldev || !dev->raw->lirc.ldev->rbuf)
 		return -EINVAL;
 
 	/* Packet start */
@@ -84,7 +84,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 							(u64)LIRC_VALUE_MASK);
 
 			gap_sample = LIRC_SPACE(lirc->gap_duration);
-			lirc_buffer_write(dev->raw->lirc.drv->rbuf,
+			lirc_buffer_write(dev->raw->lirc.ldev->rbuf,
 						(unsigned char *) &gap_sample);
 			lirc->gap = false;
 		}
@@ -95,9 +95,9 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
+	lirc_buffer_write(dev->raw->lirc.ldev->rbuf,
 			  (unsigned char *) &sample);
-	wake_up(&dev->raw->lirc.drv->rbuf->wait_poll);
+	wake_up(&dev->raw->lirc.ldev->rbuf->wait_poll);
 
 	return 0;
 }
@@ -343,12 +343,12 @@ static const struct file_operations lirc_fops = {
 
 static int ir_lirc_register(struct rc_dev *dev)
 {
-	struct lirc_driver *drv;
+	struct lirc_dev *ldev;
 	int rc = -ENOMEM;
 	unsigned long features = 0;
 
-	drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!drv)
+	ldev = kzalloc(sizeof(struct lirc_dev), GFP_KERNEL);
+	if (!ldev)
 		return rc;
 
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
@@ -380,29 +380,29 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (dev->max_timeout)
 		features |= LIRC_CAN_SET_REC_TIMEOUT;
 
-	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
+	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
 		 dev->driver_name);
-	drv->features = features;
-	drv->data = &dev->raw->lirc;
-	drv->rbuf = NULL;
-	drv->code_length = sizeof(struct ir_raw_event) * 8;
-	drv->chunk_size = sizeof(int);
-	drv->buffer_size = LIRCBUF_SIZE;
-	drv->fops = &lirc_fops;
-	drv->dev = &dev->dev;
-	drv->rdev = dev;
-	drv->owner = THIS_MODULE;
-
-	rc = lirc_register_driver(drv);
+	ldev->features = features;
+	ldev->data = &dev->raw->lirc;
+	ldev->rbuf = NULL;
+	ldev->code_length = sizeof(struct ir_raw_event) * 8;
+	ldev->chunk_size = sizeof(int);
+	ldev->buffer_size = LIRCBUF_SIZE;
+	ldev->fops = &lirc_fops;
+	ldev->dev = &dev->dev;
+	ldev->rdev = dev;
+	ldev->owner = THIS_MODULE;
+
+	rc = lirc_register_device(ldev);
 	if (rc < 0)
 		goto out;
 
-	dev->raw->lirc.drv = drv;
+	dev->raw->lirc.ldev = ldev;
 	dev->raw->lirc.dev = dev;
 	return 0;
 
 out:
-	kfree(drv);
+	kfree(ldev);
 	return rc;
 }
 
@@ -410,9 +410,9 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
-	lirc_unregister_driver(lirc->drv);
-	kfree(lirc->drv);
-	lirc->drv = NULL;
+	lirc_unregister_device(lirc->ldev);
+	kfree(lirc->ldev);
+	lirc->ldev = NULL;
 
 	return 0;
 }
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 996cb5e778dc..1c2f1a07bdaa 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -35,7 +35,7 @@
 static dev_t lirc_base_dev;
 
 struct irctl {
-	struct lirc_driver d;
+	struct lirc_dev d;
 	bool attached;
 	int open;
 
@@ -74,7 +74,7 @@ static void lirc_release(struct device *ld)
 static int lirc_allocate_buffer(struct irctl *ir)
 {
 	int err = 0;
-	struct lirc_driver *d = &ir->d;
+	struct lirc_dev *d = &ir->d;
 
 	if (d->rbuf) {
 		ir->buf = d->rbuf;
@@ -101,7 +101,7 @@ static int lirc_allocate_buffer(struct irctl *ir)
 	return err;
 }
 
-int lirc_register_driver(struct lirc_driver *d)
+int lirc_register_device(struct lirc_dev *d)
 {
 	struct irctl *ir;
 	int minor;
@@ -199,9 +199,9 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	return 0;
 }
-EXPORT_SYMBOL(lirc_register_driver);
+EXPORT_SYMBOL(lirc_register_device);
 
-void lirc_unregister_driver(struct lirc_driver *d)
+void lirc_unregister_device(struct lirc_dev *d)
 {
 	struct irctl *ir;
 
@@ -229,7 +229,7 @@ void lirc_unregister_driver(struct lirc_driver *d)
 	ida_simple_remove(&lirc_ida, d->minor);
 	put_device(&ir->dev);
 }
-EXPORT_SYMBOL(lirc_unregister_driver);
+EXPORT_SYMBOL(lirc_unregister_device);
 
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b3e7cac2c3ee..f5ececd06e94 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -105,7 +105,7 @@ struct ir_raw_event_ctrl {
 	} mce_kbd;
 	struct lirc_codec {
 		struct rc_dev *dev;
-		struct lirc_driver *drv;
+		struct lirc_dev *ldev;
 		int carrier_low;
 
 		ktime_t gap_start;
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index c6a2fe2ad210..a8aefd033ad9 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -100,7 +100,7 @@ struct IR {
 	struct list_head list;
 
 	/* FIXME spinlock access to l.features */
-	struct lirc_driver l;
+	struct lirc_dev l;
 	struct lirc_buffer rbuf;
 
 	struct mutex ir_lock;
@@ -183,7 +183,7 @@ static void release_ir_device(struct kref *ref)
 	 * ir->open_count ==  0 - happens on final close()
 	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
 	 */
-	lirc_unregister_driver(&ir->l);
+	lirc_unregister_device(&ir->l);
 
 	if (kfifo_initialized(&ir->rbuf.fifo))
 		lirc_buffer_free(&ir->rbuf);
@@ -1345,7 +1345,7 @@ static const struct file_operations lirc_fops = {
 	.release	= close
 };
 
-static struct lirc_driver lirc_template = {
+static struct lirc_dev lirc_template = {
 	.name		= "lirc_zilog",
 	.code_length	= 13,
 	.fops		= &lirc_fops,
@@ -1441,7 +1441,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		spin_lock_init(&ir->rx_ref_lock);
 
 		/* set lirc_dev stuff */
-		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
+		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_dev));
 		/*
 		 * FIXME this is a pointer reference to us, but no refcount.
 		 *
@@ -1559,10 +1559,10 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* register with lirc */
-	ret = lirc_register_driver(&ir->l);
+	ret = lirc_register_device(&ir->l);
 	if (ret < 0) {
 		dev_err(tx->ir->l.dev,
-			"%s: lirc_register_driver() failed: %i\n",
+			"%s: lirc_register_device() failed: %i\n",
 			__func__, ret);
 		goto out_put_xx;
 	}
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 2629c40e8a39..567959e9524f 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -111,48 +111,28 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 }
 
 /**
- * struct lirc_driver - Defines the parameters on a LIRC driver
- *
- * @name:		this string will be used for logs
- *
- * @minor:		the minor device (/dev/lircX) number for a registered
- *			driver.
- *
- * @code_length:	length of the remote control key code expressed in bits.
+ * struct lirc_dev - represents a LIRC device
  *
+ * @name:		used for logging
+ * @minor:		the minor device (/dev/lircX) number for the device
+ * @code_length:	length of a remote control key code expressed in bits
  * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
  *			LIRC_CAN\_\*, as defined at include/media/lirc.h.
- *
  * @buffer_size:	Number of FIFO buffers with @chunk_size size.
  *			Only used if @rbuf is NULL.
- *
  * @chunk_size:		Size of each FIFO buffer.
  *			Only used if @rbuf is NULL.
- *
- * @data:		it may point to any driver data and this pointer will
- *			be passed to all callback functions.
- *
+ * @data:		private per-driver data
  * @rbuf:		if not NULL, it will be used as a read buffer, you will
  *			have to write to the buffer by other means, like irq's
  *			(see also lirc_serial.c).
- *
- * @rdev:		Pointed to struct rc_dev associated with the LIRC
- *			device.
- *
- * @fops:		file_operations for drivers which don't fit the current
- *			driver model.
- *			Some ioctl's can be directly handled by lirc_dev if the
- *			driver's ioctl function is NULL or if it returns
- *			-ENOIOCTLCMD (see also lirc_serial.c).
- *
- * @dev:		pointer to the struct device associated with the LIRC
- *			device.
- *
+ * @rdev:		&struct rc_dev associated with the device
+ * @fops:		&struct file_operations for the device
+ * @dev:		&struct device assigned to the device
  * @owner:		the module owning this struct
- *
- * @irctl:		pointer to the struct irctl assigned to this LIRC device.
+ * @irctl:		&struct irctl assigned to the device
  */
-struct lirc_driver {
+struct lirc_dev {
 	char name[40];
 	unsigned minor;
 	__u32 code_length;
@@ -175,14 +155,14 @@ struct lirc_driver {
  * returns negative value on error or zero
  * contents of the structure pointed by p is copied
  */
-extern int lirc_register_driver(struct lirc_driver *d);
+extern int lirc_register_device(struct lirc_dev *d);
 
-extern void lirc_unregister_driver(struct lirc_driver *d);
+extern void lirc_unregister_device(struct lirc_dev *d);
 
 /* Must be called in the open fop before lirc_get_pdata() can be used */
 void lirc_init_pdata(struct inode *inode, struct file *file);
 
-/* Returns the private data stored in the lirc_driver
+/* Returns the private data stored in the lirc_dev
  * associated with the given device file pointer.
  */
 void *lirc_get_pdata(struct file *file);
