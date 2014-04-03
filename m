Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40274 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:31:47 -0400
Subject: [PATCH 06/49] rc-core: remove generic scancode filter
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:31:46 +0200
Message-ID: <20140403233145.27099.78225.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The generic scancode filtering has questionable value and makes it
impossible to determine from userspace if there is an actual
scancode hw filter present or not.

So revert the generic parts.

Based on a patch from James Hogan <james.hogan@imgtec.com>, but this
version also makes sure that only the valid sysfs files are created
in the first place.

v2: correct dev->s_filter check

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   67 +++++++++++++++++++++++++++++---------------
 include/media/rc-core.h    |    2 +
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index ba955ac..26c266b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -634,7 +634,6 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 			  u32 scancode, u32 keycode, u8 toggle)
 {
-	struct rc_scancode_filter *filter;
 	bool new_event = (!dev->keypressed		 ||
 			  dev->last_protocol != protocol ||
 			  dev->last_scancode != scancode ||
@@ -643,11 +642,6 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
 
-	/* Generic scancode filtering */
-	filter = &dev->scancode_filters[RC_FILTER_NORMAL];
-	if (filter->mask && ((scancode ^ filter->data) & filter->mask))
-		return;
-
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
 	if (new_event && keycode != KEY_RESERVED) {
@@ -1017,14 +1011,11 @@ static ssize_t store_protocols(struct device *device,
 	set_filter = (fattr->type == RC_FILTER_NORMAL)
 		? dev->s_filter : dev->s_wakeup_filter;
 
-	if (old_type != type && filter->mask) {
+	if (set_filter && old_type != type && filter->mask) {
 		local_filter = *filter;
 		if (!type) {
 			/* no protocol => clear filter */
 			ret = -1;
-		} else if (!set_filter) {
-			/* generic filtering => accept any filter */
-			ret = 0;
 		} else {
 			/* hardware filtering => try setting, otherwise clear */
 			ret = set_filter(dev, &local_filter);
@@ -1033,8 +1024,7 @@ static ssize_t store_protocols(struct device *device,
 			/* clear the filter */
 			local_filter.data = 0;
 			local_filter.mask = 0;
-			if (set_filter)
-				set_filter(dev, &local_filter);
+			set_filter(dev, &local_filter);
 		}
 
 		/* commit the new filter */
@@ -1078,7 +1068,10 @@ static ssize_t show_filter(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
-	if (fattr->mask)
+	if ((fattr->type == RC_FILTER_NORMAL && !dev->s_filter) ||
+	    (fattr->type == RC_FILTER_WAKEUP && !dev->s_wakeup_filter))
+		val = 0;
+	else if (fattr->mask)
 		val = dev->scancode_filters[fattr->type].mask;
 	else
 		val = dev->scancode_filters[fattr->type].data;
@@ -1202,27 +1195,45 @@ static RC_FILTER_ATTR(wakeup_filter, S_IRUGO|S_IWUSR,
 static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
 
-static struct attribute *rc_dev_attrs[] = {
+static struct attribute *rc_dev_protocol_attrs[] = {
 	&dev_attr_protocols.attr.attr,
+	NULL,
+};
+
+static struct attribute_group rc_dev_protocol_attr_grp = {
+	.attrs	= rc_dev_protocol_attrs,
+};
+
+static struct attribute *rc_dev_wakeup_protocol_attrs[] = {
 	&dev_attr_wakeup_protocols.attr.attr,
+	NULL,
+};
+
+static struct attribute_group rc_dev_wakeup_protocol_attr_grp = {
+	.attrs	= rc_dev_wakeup_protocol_attrs,
+};
+
+static struct attribute *rc_dev_filter_attrs[] = {
 	&dev_attr_filter.attr.attr,
 	&dev_attr_filter_mask.attr.attr,
-	&dev_attr_wakeup_filter.attr.attr,
-	&dev_attr_wakeup_filter_mask.attr.attr,
 	NULL,
 };
 
-static struct attribute_group rc_dev_attr_grp = {
-	.attrs	= rc_dev_attrs,
+static struct attribute_group rc_dev_filter_attr_grp = {
+	.attrs	= rc_dev_filter_attrs,
+};
+
+static struct attribute *rc_dev_wakeup_filter_attrs[] = {
+	&dev_attr_wakeup_filter.attr.attr,
+	&dev_attr_wakeup_filter_mask.attr.attr,
+	NULL,
 };
 
-static const struct attribute_group *rc_dev_attr_groups[] = {
-	&rc_dev_attr_grp,
-	NULL
+static struct attribute_group rc_dev_wakeup_filter_attr_grp = {
+	.attrs	= rc_dev_wakeup_filter_attrs,
 };
 
 static struct device_type rc_dev_type = {
-	.groups		= rc_dev_attr_groups,
 	.release	= rc_dev_release,
 	.uevent		= rc_dev_uevent,
 };
@@ -1279,7 +1290,7 @@ int rc_register_device(struct rc_dev *dev)
 	static bool raw_init = false; /* raw decoders loaded? */
 	struct rc_map *rc_map;
 	const char *path;
-	int rc, devno;
+	int rc, devno, attr = 0;
 
 	if (!dev || !dev->map_name)
 		return -EINVAL;
@@ -1307,6 +1318,16 @@ int rc_register_device(struct rc_dev *dev)
 			return -ENOMEM;
 	} while (test_and_set_bit(devno, ir_core_dev_number));
 
+	dev->dev.groups = dev->sysfs_groups;
+	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
+	if (dev->s_filter)
+		dev->sysfs_groups[attr++] = &rc_dev_filter_attr_grp;	
+	if (dev->s_wakeup_filter)
+		dev->sysfs_groups[attr++] = &rc_dev_wakeup_filter_attr_grp;
+	if (dev->change_wakeup_protocol)
+		dev->sysfs_groups[attr++] = &rc_dev_wakeup_protocol_attr_grp;
+	dev->sysfs_groups[attr++] = NULL;
+
 	/*
 	 * Take the lock here, as the device sysfs node will appear
 	 * when device_add() is called, which may trigger an ir-keytable udev
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 8c31e4a..2e97b98 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -60,6 +60,7 @@ enum rc_filter_type {
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
+ * @sysfs_groups: sysfs attribute groups
  * @input_name: name of the input child device
  * @input_phys: physical path to the input child device
  * @input_id: id of the input child device (struct input_id)
@@ -118,6 +119,7 @@ enum rc_filter_type {
  */
 struct rc_dev {
 	struct device			dev;
+	const struct attribute_group	*sysfs_groups[5];
 	const char			*input_name;
 	const char			*input_phys;
 	struct input_id			input_id;

