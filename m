Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44278 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2EWJyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:52 -0400
Subject: [PATCH 26/43] rc-core: do not take mutex on rc_dev registration
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:17 +0200
Message-ID: <20120523094416.14474.67184.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the rc_register_device() code so that it isn't necessary to hold any
mutex. When device_add() is called, the norm is that the device should
actually be ready for use.

Holding the mutex is a recipe for deadlocks as (for example) calling
input_register_device() is quite likely to end up in a call to
input_dev->open() which might take the same mutex (to update the user
count, see later patches).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   95 ++++++++++++++++++--------------------------
 include/media/rc-core.h    |    3 -
 2 files changed, 40 insertions(+), 58 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 83ea507..620cd8d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -214,8 +214,8 @@ static struct {
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * dev->lock is taken to guard against races between store_protocols
+ * and show_protocols.
  */
 static ssize_t show_protocols(struct device *device,
 			      struct device_attribute *mattr, char *buf)
@@ -276,8 +276,8 @@ static ssize_t show_protocols(struct device *device,
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
  *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * dev->lock is taken to guard against races between store_protocols and
+ * show_protocols.
  */
 static ssize_t store_protocols(struct device *device,
 			       struct device_attribute *mattr,
@@ -492,17 +492,14 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		return rc;
 
-	for (i = 0; i < ARRAY_SIZE(rc_dev_table); i++) {
-		if (!rc_dev_table[i]) {
-			rc_dev_table[i] = dev;
+	for (i = 0; i < ARRAY_SIZE(rc_dev_table); i++)
+		if (!rc_dev_table[i])
 			break;
-		}
-	}
-
-	mutex_unlock(&rc_dev_table_mutex);
 
-	if (i >= ARRAY_SIZE(rc_dev_table))
-		return -ENFILE;
+	if (i >= ARRAY_SIZE(rc_dev_table)) {
+		rc = -ENFILE;
+		goto out;
+	}
 
 	dev->minor = i;
 	dev->dev.devt = MKDEV(rc_major, dev->minor);
@@ -512,35 +509,9 @@ int rc_register_device(struct rc_dev *dev)
 	if (dev->tx_ir) {
 		rc = kfifo_alloc(&dev->txfifo, RC_TX_KFIFO_SIZE, GFP_KERNEL);
 		if (rc)
-			goto out_minor;
-	}
-
-	/*
-	 * Take the lock here, as the device sysfs node will appear
-	 * when device_add() is called, which may trigger an ir-keytable udev
-	 * rule, which will in turn call show_protocols and access either
-	 * dev->rc_map.rc_type or dev->raw->enabled_protocols before it has
-	 * been initialized.
-	 */
-	mutex_lock(&dev->lock);
-
-	dev->kt = rc_keytable_create(dev, dev->map_name);
-	if (!dev->kt) {
-		rc = -ENOMEM;
-		goto out_unlock;
+			goto out;
 	}
 
-	rc = device_add(&dev->dev);
-	if (rc)
-		goto out_keytable;
-
-	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "%s: %s as %s\n",
-		dev_name(&dev->dev),
-		dev->input_name ? dev->input_name : "Unspecified device",
-		path ? path : "N/A");
-	kfree(path);
-
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		/* Load raw decoders, if they aren't already */
 		if (!raw_init) {
@@ -550,7 +521,7 @@ int rc_register_device(struct rc_dev *dev)
 		}
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
-			goto out_dev;
+			goto out_kfifo;
 	}
 
 	if (dev->change_protocol) {
@@ -559,29 +530,41 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_raw;
 	}
 
+	rc_dev_table[i] = dev;
 	dev->exist = true;
-	mutex_unlock(&dev->lock);
 
-	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
-		   dev->minor,
-		   dev->driver_name ? dev->driver_name : "unknown",
-		   dev->map_name ? dev->map_name : "unknown",
-		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
+	/* Once device_add is called, userspace might access e.g. sysfs files */
+	rc = device_add(&dev->dev);
+	if (rc)
+		goto out_chardev;
+
+	dev->kt = rc_keytable_create(dev, dev->map_name);
+	if (!dev->kt) {
+		rc = -ENOMEM;
+		goto out_device;
+	}
+
+	mutex_unlock(&rc_dev_table_mutex);
+
+	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
+	printk(KERN_INFO "%s: %s as %s\n",
+		dev_name(&dev->dev),
+		dev->input_name ? dev->input_name : "Unspecified device",
+		path ? path : "N/A");
+	kfree(path);
 
 	return 0;
 
+out_device:
+	device_del(&dev->dev);
+out_chardev:
+	rc_dev_table[dev->minor] = NULL;
 out_raw:
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
-out_dev:
-	device_del(&dev->dev);
-out_keytable:
-	rc_keytable_destroy(dev->kt);
-out_unlock:
-	mutex_unlock(&dev->lock);
-out_minor:
-	mutex_lock(&rc_dev_table_mutex);
-	rc_dev_table[dev->minor] = NULL;
+out_kfifo:
+	kfifo_free(&dev->txfifo);
+out:
 	mutex_unlock(&rc_dev_table_mutex);
 	return rc;
 }
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 20bd1ce..e34815b 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -203,8 +203,7 @@ struct ir_raw_event {
  * @driver_name: name of the hardware driver which registered this device
  * @map_name: name of the default keymap
  * @rc_map: current scan/key table
- * @lock: used to ensure we've filled in all protocol details before
- *	anyone can call show_protocols or store_protocols
+ * @lock: used where a more specific lock/mutex/etc is not available
  * @minor: unique minor remote control device number
  * @exist: used to determine if the device is still valid
  * @client_list: list of clients (processes which have opened the rc chardev)

