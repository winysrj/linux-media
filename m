Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:55235 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755330AbdD0UeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 16:34:10 -0400
Subject: [PATCH 3/6] rc-core: cleanup rc_register_device pt2
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 27 Apr 2017 22:34:08 +0200
Message-ID: <149332524815.32431.5170785656122222096.stgit@zeus.hardeman.nu>
In-Reply-To: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that rc_register_device() is reorganised, the dev->initialized
hack can be removed. Any driver which calls rc_register_device()
must be prepared for the device to go live immediately.

The dev->initialized commits that are relevant are:
c73bbaa4ec3eb225ffe468f80d45724d0496bf03
08aeb7c9a42ab7aa8b53c8f7779ec58f860a565c

The original problem was that show_protocols() would access
dev->rc_map.* and various other bits which are now properly
initialized before device_add() is called.

At the same time, remove  the bogus "device is being removed"
check (quiz: when would container_of give a NULL value???).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   67 +++++++-------------------------------------
 include/media/rc-core.h    |    2 -
 2 files changed, 10 insertions(+), 59 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 44189366f232..0acc8f27abeb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -15,7 +15,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <media/rc-core.h>
-#include <linux/atomic.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/input.h>
@@ -934,8 +933,8 @@ static bool lirc_is_present(void)
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * dev->lock is taken to guard against races between
+ * store_protocols and show_protocols.
  */
 static ssize_t show_protocols(struct device *device,
 			      struct device_attribute *mattr, char *buf)
@@ -945,13 +944,6 @@ static ssize_t show_protocols(struct device *device,
 	char *tmp = buf;
 	int i;
 
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	if (!atomic_read(&dev->initialized))
-		return -ERESTARTSYS;
-
 	mutex_lock(&dev->lock);
 
 	enabled = dev->enabled_protocols;
@@ -1106,8 +1098,8 @@ static void ir_raw_load_modules(u64 *protocols)
  * See parse_protocol_change() for the valid commands.
  * Returns @len on success or a negative error code.
  *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * dev->lock is taken to guard against races between
+ * store_protocols and show_protocols.
  */
 static ssize_t store_protocols(struct device *device,
 			       struct device_attribute *mattr,
@@ -1119,13 +1111,6 @@ static ssize_t store_protocols(struct device *device,
 	u64 old_protocols, new_protocols;
 	ssize_t rc;
 
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	if (!atomic_read(&dev->initialized))
-		return -ERESTARTSYS;
-
 	IR_dprintk(1, "Normal protocol change requested\n");
 	current_protocols = &dev->enabled_protocols;
 	filter = &dev->scancode_filter;
@@ -1200,7 +1185,7 @@ static ssize_t store_protocols(struct device *device,
  * Bits of the filter value corresponding to set bits in the filter mask are
  * compared against input scancodes and non-matching scancodes are discarded.
  *
- * dev->lock is taken to guard against races between device registration,
+ * dev->lock is taken to guard against races between
  * store_filter and show_filter.
  */
 static ssize_t show_filter(struct device *device,
@@ -1212,13 +1197,6 @@ static ssize_t show_filter(struct device *device,
 	struct rc_scancode_filter *filter;
 	u32 val;
 
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	if (!atomic_read(&dev->initialized))
-		return -ERESTARTSYS;
-
 	mutex_lock(&dev->lock);
 
 	if (fattr->type == RC_FILTER_NORMAL)
@@ -1251,7 +1229,7 @@ static ssize_t show_filter(struct device *device,
  * Bits of the filter value corresponding to set bits in the filter mask are
  * compared against input scancodes and non-matching scancodes are discarded.
  *
- * dev->lock is taken to guard against races between device registration,
+ * dev->lock is taken to guard against races between
  * store_filter and show_filter.
  */
 static ssize_t store_filter(struct device *device,
@@ -1265,13 +1243,6 @@ static ssize_t store_filter(struct device *device,
 	unsigned long val;
 	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
 
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	if (!atomic_read(&dev->initialized))
-		return -ERESTARTSYS;
-
 	ret = kstrtoul(buf, 0, &val);
 	if (ret < 0)
 		return ret;
@@ -1372,8 +1343,8 @@ static const char * const proto_variant_names[] = {
  * It returns the protocol names of supported protocols.
  * The enabled protocols are printed in brackets.
  *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * dev->lock is taken to guard against races between
+ * store_wakeup_protocols and show_wakeup_protocols.
  */
 static ssize_t show_wakeup_protocols(struct device *device,
 				     struct device_attribute *mattr,
@@ -1385,13 +1356,6 @@ static ssize_t show_wakeup_protocols(struct device *device,
 	char *tmp = buf;
 	int i;
 
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	if (!atomic_read(&dev->initialized))
-		return -ERESTARTSYS;
-
 	mutex_lock(&dev->lock);
 
 	allowed = dev->allowed_wakeup_protocols;
@@ -1431,8 +1395,8 @@ static ssize_t show_wakeup_protocols(struct device *device,
  * It is trigged by writing to /sys/class/rc/rc?/wakeup_protocols.
  * Returns @len on success or a negative error code.
  *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * dev->lock is taken to guard against races between
+ * store_wakeup_protocols and show_wakeup_protocols.
  */
 static ssize_t store_wakeup_protocols(struct device *device,
 				      struct device_attribute *mattr,
@@ -1444,13 +1408,6 @@ static ssize_t store_wakeup_protocols(struct device *device,
 	u64 allowed;
 	int i;
 
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	if (!atomic_read(&dev->initialized))
-		return -ERESTARTSYS;
-
 	mutex_lock(&dev->lock);
 
 	allowed = dev->allowed_wakeup_protocols;
@@ -1773,7 +1730,6 @@ int rc_register_device(struct rc_dev *dev)
 	dev->minor = minor;
 	dev_set_name(&dev->dev, "rc%u", dev->minor);
 	dev_set_drvdata(&dev->dev, dev);
-	atomic_set(&dev->initialized, 0);
 
 	dev->dev.groups = dev->sysfs_groups;
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
@@ -1819,9 +1775,6 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_rx;
 	}
 
-	/* Allow the RC sysfs nodes to be accessible */
-	atomic_set(&dev->initialized, 1);
-
 	IR_dprintk(1, "Registered rc%u (driver: %s)\n",
 		   dev->minor,
 		   dev->driver_name ? dev->driver_name : "unknown");
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 73ddd721d7ba..78dea39a9b39 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -70,7 +70,6 @@ enum rc_filter_type {
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
- * @initialized: 1 if the device init has completed, 0 otherwise
  * @managed_alloc: devm_rc_allocate_device was used to create rc_dev
  * @sysfs_groups: sysfs attribute groups
  * @input_name: name of the input child device
@@ -137,7 +136,6 @@ enum rc_filter_type {
  */
 struct rc_dev {
 	struct device			dev;
-	atomic_t			initialized;
 	bool				managed_alloc;
 	const struct attribute_group	*sysfs_groups[5];
 	const char			*input_name;
