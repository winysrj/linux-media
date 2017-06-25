Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56406 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:27 -0400
Subject: [PATCH 02/19] lirc_dev: remove support for manually specifying
 minor number
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:24 +0200
Message-ID: <149839388491.28811.1868710084314296392.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All users of lirc_register_driver() uses dynamic minor allocation, therefore
we can remove the ability to explicitly request a given number.

This changes the function prototype of lirc_unregister_driver() to also
take a struct lirc_driver pointer as the sole argument.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c        |    9 +---
 drivers/media/rc/lirc_dev.c             |   68 ++++++++-----------------------
 drivers/staging/media/lirc/lirc_zilog.c |   14 ++----
 include/media/lirc_dev.h                |   18 ++++----
 4 files changed, 33 insertions(+), 76 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index a30af91710fe..2c1221a61ea1 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -382,7 +382,6 @@ static int ir_lirc_register(struct rc_dev *dev)
 
 	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
 		 dev->driver_name);
-	drv->minor = -1;
 	drv->features = features;
 	drv->data = &dev->raw->lirc;
 	drv->rbuf = NULL;
@@ -394,11 +393,9 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->rdev = dev;
 	drv->owner = THIS_MODULE;
 
-	drv->minor = lirc_register_driver(drv);
-	if (drv->minor < 0) {
-		rc = -ENODEV;
+	rc = lirc_register_driver(drv);
+	if (rc < 0)
 		goto out;
-	}
 
 	dev->raw->lirc.drv = drv;
 	dev->raw->lirc.dev = dev;
@@ -413,7 +410,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
-	lirc_unregister_driver(lirc->drv->minor);
+	lirc_unregister_driver(lirc->drv);
 	kfree(lirc->drv);
 	lirc->drv = NULL;
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 9c1d55e41e34..c9afaf5e64a9 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -29,7 +29,6 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-#define NOPLUG		-1
 #define LOGHEAD		"lirc_dev (%s[%d]): "
 
 static dev_t lirc_base_dev;
@@ -112,7 +111,7 @@ static int lirc_allocate_buffer(struct irctl *ir)
 int lirc_register_driver(struct lirc_driver *d)
 {
 	struct irctl *ir;
-	int minor;
+	unsigned minor;
 	int err;
 
 	if (!d) {
@@ -130,12 +129,6 @@ int lirc_register_driver(struct lirc_driver *d)
 		return -EINVAL;
 	}
 
-	if (d->minor >= MAX_IRCTL_DEVICES) {
-		dev_err(d->dev, "minor must be between 0 and %d!\n",
-						MAX_IRCTL_DEVICES - 1);
-		return -EBADRQC;
-	}
-
 	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
 		dev_err(d->dev, "code length must be less than %d bits\n",
 								BUFLEN * 8);
@@ -150,21 +143,14 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	mutex_lock(&lirc_dev_lock);
 
-	minor = d->minor;
+	/* find first free slot for driver */
+	for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
+		if (!irctls[minor])
+			break;
 
-	if (minor < 0) {
-		/* find first free slot for driver */
-		for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
-			if (!irctls[minor])
-				break;
-		if (minor == MAX_IRCTL_DEVICES) {
-			dev_err(d->dev, "no free slots for drivers!\n");
-			err = -ENOMEM;
-			goto out_lock;
-		}
-	} else if (irctls[minor]) {
-		dev_err(d->dev, "minor (%d) just registered!\n", minor);
-		err = -EBUSY;
+	if (minor == MAX_IRCTL_DEVICES) {
+		dev_err(d->dev, "no free slots for drivers!\n");
+		err = -ENOMEM;
 		goto out_lock;
 	}
 
@@ -176,6 +162,7 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	mutex_init(&ir->irctl_lock);
 	irctls[minor] = ir;
+	d->irctl = ir;
 	d->minor = minor;
 
 	/* some safety check 8-) */
@@ -221,7 +208,7 @@ int lirc_register_driver(struct lirc_driver *d)
 	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
 		 ir->d.name, ir->d.minor);
 
-	return minor;
+	return 0;
 
 out_cdev:
 	cdev_del(&ir->cdev);
@@ -234,38 +221,24 @@ int lirc_register_driver(struct lirc_driver *d)
 }
 EXPORT_SYMBOL(lirc_register_driver);
 
-int lirc_unregister_driver(int minor)
+void lirc_unregister_driver(struct lirc_driver *d)
 {
 	struct irctl *ir;
 
-	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
-		pr_err("minor (%d) must be between 0 and %d!\n",
-					minor, MAX_IRCTL_DEVICES - 1);
-		return -EBADRQC;
-	}
+	if (!d || !d->irctl)
+		return;
 
-	ir = irctls[minor];
-	if (!ir) {
-		pr_err("failed to get irctl\n");
-		return -ENOENT;
-	}
+	ir = d->irctl;
 
 	mutex_lock(&lirc_dev_lock);
 
-	if (ir->d.minor != minor) {
-		dev_err(ir->d.dev, "lirc_dev: minor %d device not registered\n",
-									minor);
-		mutex_unlock(&lirc_dev_lock);
-		return -ENOENT;
-	}
-
 	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
-		ir->d.name, ir->d.minor);
+		d->name, d->minor);
 
 	ir->attached = 0;
 	if (ir->open) {
 		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
-			ir->d.name, ir->d.minor);
+			d->name, d->minor);
 		wake_up_interruptible(&ir->buf->wait_poll);
 	}
 
@@ -274,8 +247,6 @@ int lirc_unregister_driver(int minor)
 	device_del(&ir->dev);
 	cdev_del(&ir->cdev);
 	put_device(&ir->dev);
-
-	return 0;
 }
 EXPORT_SYMBOL(lirc_unregister_driver);
 
@@ -302,11 +273,6 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
 
-	if (ir->d.minor == NOPLUG) {
-		retval = -ENODEV;
-		goto error;
-	}
-
 	if (ir->open) {
 		retval = -EBUSY;
 		goto error;
@@ -399,7 +365,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
 		ir->d.name, ir->d.minor, cmd);
 
-	if (ir->d.minor == NOPLUG || !ir->attached) {
+	if (!ir->attached) {
 		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
 			ir->d.name, ir->d.minor);
 		return -ENODEV;
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 015e41bd036e..10594aea2a5c 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -183,10 +183,7 @@ static void release_ir_device(struct kref *ref)
 	 * ir->open_count ==  0 - happens on final close()
 	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
 	 */
-	if (ir->l.minor >= 0) {
-		lirc_unregister_driver(ir->l.minor);
-		ir->l.minor = -1;
-	}
+	lirc_unregister_driver(&ir->l);
 
 	if (kfifo_initialized(&ir->rbuf.fifo))
 		lirc_buffer_free(&ir->rbuf);
@@ -1385,7 +1382,6 @@ static const struct file_operations lirc_fops = {
 
 static struct lirc_driver lirc_template = {
 	.name		= "lirc_zilog",
-	.minor		= -1,
 	.code_length	= 13,
 	.buffer_size	= BUFLEN / 2,
 	.chunk_size	= 2,
@@ -1599,14 +1595,14 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* register with lirc */
-	ir->l.minor = lirc_register_driver(&ir->l);
-	if (ir->l.minor < 0) {
+	ret = lirc_register_driver(&ir->l);
+	if (ret < 0) {
 		dev_err(tx->ir->l.dev,
 			"%s: lirc_register_driver() failed: %i\n",
-			__func__, ir->l.minor);
-		ret = -EBADRQC;
+			__func__, ret);
 		goto out_put_xx;
 	}
+
 	dev_info(ir->l.dev,
 		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
 		 adap->name, adap->nr, ir->l.minor);
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 86d15a9b6c01..1419d64e2e59 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -116,10 +116,8 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *
  * @name:		this string will be used for logs
  *
- * @minor:		indicates minor device (/dev/lirc) number for
- *			registered driver if caller fills it with negative
- *			value, then the first free minor number will be used
- *			(if available).
+ * @minor:		the minor device (/dev/lircX) number for a registered
+ *			driver.
  *
  * @code_length:	length of the remote control key code expressed in bits.
  *
@@ -157,10 +155,12 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *			device.
  *
  * @owner:		the module owning this struct
+ *
+ * @irctl:		pointer to the struct irctl assigned to this LIRC device.
  */
 struct lirc_driver {
 	char name[40];
-	int minor;
+	unsigned minor;
 	__u32 code_length;
 	unsigned int buffer_size; /* in chunks holding one code each */
 	__u32 features;
@@ -175,19 +175,17 @@ struct lirc_driver {
 	const struct file_operations *fops;
 	struct device *dev;
 	struct module *owner;
+	struct irctl *irctl;
 };
 
 /* following functions can be called ONLY from user context
  *
- * returns negative value on error or minor number
- * of the registered device if success
+ * returns negative value on error or zero
  * contents of the structure pointed by p is copied
  */
 extern int lirc_register_driver(struct lirc_driver *d);
 
-/* returns negative value on error or 0 if success
-*/
-extern int lirc_unregister_driver(int minor);
+extern void lirc_unregister_driver(struct lirc_driver *d);
 
 /* Returns the private data stored in the lirc_driver
  * associated with the given device file pointer.
