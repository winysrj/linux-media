Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44273 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab2EWJyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:51 -0400
Subject: [PATCH 08/43] rc-core: use a device table rather than an atomic number
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:42 +0200
Message-ID: <20120523094242.14474.68002.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes rc-core to use a device table rather than atomic integers
to assign unique numbers to each rc device. This is in preparation for
introducing rc-core chardevs.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-raw.c  |    2 +-
 drivers/media/rc/rc-main.c |   41 +++++++++++++++++++++++++++++++++++------
 include/media/rc-core.h    |    4 ++--
 3 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 6b3c9e5..7729abe 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -268,7 +268,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	spin_lock_init(&dev->raw->lock);
 	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc%ld", dev->devno);
+				       "rc%u", dev->minor);
 
 	if (IS_ERR(dev->raw->thread)) {
 		rc = PTR_ERR(dev->raw->thread);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6e02314..8da7701 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -24,6 +24,7 @@
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
+#define RC_DEV_MAX	32
 
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
@@ -32,6 +33,10 @@
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 
+/* Various bits and pieces to keep track of rc devices */
+static struct rc_dev *rc_dev_table[RC_DEV_MAX];
+static DEFINE_MUTEX(rc_dev_table_mutex);
+
 static struct rc_map_list *seek_rc_map(const char *name)
 {
 	struct rc_map_list *map = NULL;
@@ -1138,10 +1143,10 @@ EXPORT_SYMBOL_GPL(rc_free_device);
 int rc_register_device(struct rc_dev *dev)
 {
 	static bool raw_init = false; /* raw decoders loaded? */
-	static atomic_t devno = ATOMIC_INIT(0);
 	struct rc_map *rc_map;
 	const char *path;
 	int rc;
+	unsigned int i;
 
 	if (!dev || !dev->map_name)
 		return -EINVAL;
@@ -1161,6 +1166,26 @@ int rc_register_device(struct rc_dev *dev)
 	if (dev->close)
 		dev->input_dev->close = ir_close;
 
+	rc = mutex_lock_interruptible(&rc_dev_table_mutex);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < ARRAY_SIZE(rc_dev_table); i++) {
+		if (!rc_dev_table[i]) {
+			rc_dev_table[i] = dev;
+			break;
+		}
+	}
+
+	mutex_unlock(&rc_dev_table_mutex);
+
+	if (i >= ARRAY_SIZE(rc_dev_table))
+		return -ENFILE;
+
+	dev->minor = i;
+	dev_set_name(&dev->dev, "rc%u", dev->minor);
+	dev_set_drvdata(&dev->dev, dev);
+
 	/*
 	 * Take the lock here, as the device sysfs node will appear
 	 * when device_add() is called, which may trigger an ir-keytable udev
@@ -1170,9 +1195,6 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	mutex_lock(&dev->lock);
 
-	dev->devno = (unsigned long)(atomic_inc_return(&devno) - 1);
-	dev_set_name(&dev->dev, "rc%ld", dev->devno);
-	dev_set_drvdata(&dev->dev, dev);
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_unlock;
@@ -1231,8 +1253,8 @@ int rc_register_device(struct rc_dev *dev)
 
 	mutex_unlock(&dev->lock);
 
-	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode %s)\n",
-		   dev->devno,
+	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
+		   dev->minor,
 		   dev->driver_name ? dev->driver_name : "unknown",
 		   rc_map->name ? rc_map->name : "unknown",
 		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
@@ -1251,6 +1273,9 @@ out_dev:
 	device_del(&dev->dev);
 out_unlock:
 	mutex_unlock(&dev->lock);
+	mutex_lock(&rc_dev_table_mutex);
+	rc_dev_table[dev->minor] = NULL;
+	mutex_unlock(&rc_dev_table_mutex);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(rc_register_device);
@@ -1260,6 +1285,10 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
+	mutex_lock(&rc_dev_table_mutex);
+	rc_dev_table[dev->minor] = NULL;
+	mutex_unlock(&rc_dev_table_mutex);
+
 	del_timer_sync(&dev->timer_keyup);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0045292..1d4f5a0 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -63,7 +63,7 @@ struct rc_keymap_entry {
  * @rc_map: current scan/key table
  * @lock: used to ensure we've filled in all protocol details before
  *	anyone can call show_protocols or store_protocols
- * @devno: unique remote control device number
+ * @minor: unique minor remote control device number
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
@@ -111,7 +111,7 @@ struct rc_dev {
 	const char			*map_name;
 	struct rc_map			rc_map;
 	struct mutex			lock;
-	unsigned long			devno;
+	unsigned int			minor;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;

