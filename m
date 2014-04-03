Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40286 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:18 -0400
Subject: [PATCH 12/49] rc-core: simplify sysfs code
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:16 +0200
Message-ID: <20140403233216.27099.79390.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify and cleanup the sysfs code a bit.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-raw.c  |    6 +
 drivers/media/rc/rc-main.c |  265 ++++++++++++++++++++++++--------------------
 2 files changed, 150 insertions(+), 121 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 763c9d1..f38557f 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -240,6 +240,11 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
+static int change_protocol(struct rc_dev *dev, u64 *rc_type) {
+	/* the caller will update dev->enabled_protocols */
+	return 0;
+}
+
 /*
  * Used to (un)register raw event clients
  */
@@ -257,6 +262,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	rc_set_enabled_protocols(dev, ~0);
+	dev->change_protocol = change_protocol;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index ee77ad3..df3175d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -959,7 +959,7 @@ struct rc_filter_attribute {
 /**
  * show_protocols() - shows the current/wakeup IR protocol(s)
  * @device:	the device descriptor
- * @mattr:	the device attribute struct (unused)
+ * @mattr:	the device attribute struct
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type(s).
@@ -985,20 +985,21 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	enabled = dev->enabled_protocols[fattr->type];
-	if (dev->driver_type == RC_DRIVER_SCANCODE ||
-	    fattr->type == RC_FILTER_WAKEUP)
-		allowed = dev->allowed_protocols[fattr->type];
-	else if (dev->raw)
-		allowed = ir_raw_get_allowed_protocols();
-	else {
-		mutex_unlock(&dev->lock);
-		return -ENODEV;
+	if (fattr->type == RC_FILTER_NORMAL) {
+		enabled = dev->enabled_protocols[RC_FILTER_NORMAL];
+		if (dev->raw)
+			allowed = ir_raw_get_allowed_protocols();
+		else
+			allowed = dev->allowed_protocols[RC_FILTER_NORMAL];
+	} else {
+		enabled = dev->enabled_protocols[RC_FILTER_WAKEUP];
+		allowed = dev->allowed_protocols[RC_FILTER_WAKEUP];
 	}
 
-	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
-		   (long long)allowed,
-		   (long long)enabled);
+	mutex_unlock(&dev->lock);
+
+	IR_dprintk(1, "%s: allowed - 0x%llx, enabled - 0x%llx\n",
+		   __func__, (long long)allowed, (long long)enabled);
 
 	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
 		if (allowed & enabled & proto_names[i].type)
@@ -1014,62 +1015,29 @@ static ssize_t show_protocols(struct device *device,
 		tmp--;
 	*tmp = '\n';
 
-	mutex_unlock(&dev->lock);
-
 	return tmp + 1 - buf;
 }
 
 /**
- * store_protocols() - changes the current/wakeup IR protocol(s)
- * @device:	the device descriptor
- * @mattr:	the device attribute struct (unused)
- * @buf:	a pointer to the input buffer
- * @len:	length of the input buffer
+ * parse_protocol_change() - parses a protocol change request
+ * @protocols:	pointer to the bitmask of current protocols
+ * @buf:	pointer to the buffer with a list of changes
  *
- * This routine is for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]protocols.
- * Writing "+proto" will add a protocol to the list of enabled protocols.
- * Writing "-proto" will remove a protocol from the list of enabled protocols.
+ * Writing "+proto" will add a protocol to the protocol mask.
+ * Writing "-proto" will remove a protocol from protocol mask.
  * Writing "proto" will enable only "proto".
  * Writing "none" will disable all protocols.
- * Returns -EINVAL if an invalid protocol combination or unknown protocol name
- * is used, otherwise @len.
- *
- * dev->lock is taken to guard against races between device
- * registration, store_protocols and show_protocols.
+ * Returns the number of changes performed or a negative error code.
  */
-static ssize_t store_protocols(struct device *device,
-			       struct device_attribute *mattr,
-			       const char *data,
-			       size_t len)
+static int parse_protocol_change(u64 *protocols, const char *buf)
 {
-	struct rc_dev *dev = to_rc_dev(device);
-	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
-	bool enable, disable;
 	const char *tmp;
-	u64 old_type, type;
+	unsigned count = 0;
+	bool enable, disable;
 	u64 mask;
-	int rc, i, count = 0;
-	ssize_t ret;
-	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
-	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
-	struct rc_scancode_filter local_filter, *filter;
-
-	/* Device is being removed */
-	if (!dev)
-		return -EINVAL;
-
-	mutex_lock(&dev->lock);
-
-	if (dev->driver_type != RC_DRIVER_SCANCODE && !dev->raw) {
-		IR_dprintk(1, "Protocol switching not supported\n");
-		ret = -EINVAL;
-		goto out;
-	}
-	old_type = dev->enabled_protocols[fattr->type];
-	type = old_type;
+	int i;
 
-	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
+	while ((tmp = strsep((char **)&buf, " \n")) != NULL) {
 		if (!*tmp)
 			break;
 
@@ -1095,76 +1063,124 @@ static ssize_t store_protocols(struct device *device,
 
 		if (i == ARRAY_SIZE(proto_names)) {
 			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		count++;
 
 		if (enable)
-			type |= mask;
+			*protocols |= mask;
 		else if (disable)
-			type &= ~mask;
+			*protocols &= ~mask;
 		else
-			type = mask;
+			*protocols = mask;
 	}
 
 	if (!count) {
 		IR_dprintk(1, "Protocol not specified\n");
-		ret = -EINVAL;
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+/**
+ * store_protocols() - changes the current/wakeup IR protocol(s)
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is for changing the IR protocol type.
+ * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]protocols.
+ * See parse_protocol_change() for the valid commands.
+ * Returns @len on success or a negative error code.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_protocols and show_protocols.
+ */
+static ssize_t store_protocols(struct device *device,
+			       struct device_attribute *mattr,
+			       const char *buf, size_t len)
+{
+	struct rc_dev *dev = to_rc_dev(device);
+	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
+	u64 *current_protocols;
+	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	struct rc_scancode_filter *filter;
+	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
+	u64 old_protocols, new_protocols;
+	ssize_t rc;
+
+	/* Device is being removed */
+	if (!dev)
+		return -EINVAL;
+
+	if (fattr->type == RC_FILTER_NORMAL) {
+		IR_dprintk(1, "Normal protocol change requested\n");
+		current_protocols = &dev->enabled_protocols[RC_FILTER_NORMAL];
+		change_protocol = dev->change_protocol;
+		filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+		set_filter = dev->s_filter;
+	} else {
+		IR_dprintk(1, "Wakeup protocol change requested\n");
+		current_protocols = &dev->enabled_protocols[RC_FILTER_WAKEUP];
+		change_protocol = dev->change_wakeup_protocol;
+		filter = &dev->scancode_filters[RC_FILTER_WAKEUP];
+		set_filter = dev->s_wakeup_filter;
+	}
+
+	if (!change_protocol) {
+		IR_dprintk(1, "Protocol switching not supported\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&dev->lock);
+
+	old_protocols = *current_protocols;
+	new_protocols = old_protocols;
+	rc = parse_protocol_change(&new_protocols, buf);
+	if (rc < 0)
+		goto out;
+
+	rc = change_protocol(dev, &new_protocols);
+	if (rc < 0) {
+		IR_dprintk(1, "Error setting protocols to 0x%llx\n",
+			   (long long)new_protocols);
 		goto out;
 	}
 
-	change_protocol = (fattr->type == RC_FILTER_NORMAL)
-		? dev->change_protocol : dev->change_wakeup_protocol;
-	if (change_protocol) {
-		rc = change_protocol(dev, &type);
-		if (rc < 0) {
-			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
-				   (long long)type);
-			ret = -EINVAL;
-			goto out;
-		}
+	if (new_protocols == old_protocols) {
+		rc = len;
+		goto out;
 	}
 
-	dev->enabled_protocols[fattr->type] = type;
-	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
-		   (long long)type);
+	*current_protocols = new_protocols;
+	IR_dprintk(1, "Protocols changed to 0x%llx\n", (long long)new_protocols);
 
 	/*
 	 * If the protocol is changed the filter needs updating.
 	 * Try setting the same filter with the new protocol (if any).
 	 * Fall back to clearing the filter.
 	 */
-	filter = &dev->scancode_filters[fattr->type];
-	set_filter = (fattr->type == RC_FILTER_NORMAL)
-		? dev->s_filter : dev->s_wakeup_filter;
-
-	if (set_filter && old_type != type && filter->mask) {
-		local_filter = *filter;
-		if (!type) {
-			/* no protocol => clear filter */
-			ret = -1;
-		} else {
-			/* hardware filtering => try setting, otherwise clear */
-			ret = set_filter(dev, &local_filter);
-		}
-		if (ret < 0) {
-			/* clear the filter */
-			local_filter.data = 0;
-			local_filter.mask = 0;
-			set_filter(dev, &local_filter);
-		}
+	if (set_filter && filter->mask) {
+		if (new_protocols)
+			rc = set_filter(dev, filter);
+		else
+			rc = -1;
 
-		/* commit the new filter */
-		*filter = local_filter;
+		if (rc < 0) {
+			filter->data = 0;
+			filter->mask = 0;
+			set_filter(dev, filter);
+		}
 	}
 
-	ret = len;
+	rc = len;
 
 out:
 	mutex_unlock(&dev->lock);
-	return ret;
+	return rc;
 }
 
 /**
@@ -1190,20 +1206,23 @@ static ssize_t show_filter(struct device *device,
 {
 	struct rc_dev *dev = to_rc_dev(device);
 	struct rc_filter_attribute *fattr = to_rc_filter_attr(attr);
+	struct rc_scancode_filter *filter;
 	u32 val;
 
 	/* Device is being removed */
 	if (!dev)
 		return -EINVAL;
 
+	if (fattr->type == RC_FILTER_NORMAL)
+		filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+	else
+		filter = &dev->scancode_filters[RC_FILTER_WAKEUP];
+
 	mutex_lock(&dev->lock);
-	if ((fattr->type == RC_FILTER_NORMAL && !dev->s_filter) ||
-	    (fattr->type == RC_FILTER_WAKEUP && !dev->s_wakeup_filter))
-		val = 0;
-	else if (fattr->mask)
-		val = dev->scancode_filters[fattr->type].mask;
+	if (fattr->mask)
+		val = filter->mask;
 	else
-		val = dev->scancode_filters[fattr->type].data;
+		val = filter->data;
 	mutex_unlock(&dev->lock);
 
 	return sprintf(buf, "%#x\n", val);
@@ -1230,15 +1249,15 @@ static ssize_t show_filter(struct device *device,
  */
 static ssize_t store_filter(struct device *device,
 			    struct device_attribute *attr,
-			    const char *buf,
-			    size_t count)
+			    const char *buf, size_t len)
 {
 	struct rc_dev *dev = to_rc_dev(device);
 	struct rc_filter_attribute *fattr = to_rc_filter_attr(attr);
-	struct rc_scancode_filter local_filter, *filter;
+	struct rc_scancode_filter new_filter, *filter;
 	int ret;
 	unsigned long val;
 	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
+	u64 *enabled_protocols;
 
 	/* Device is being removed */
 	if (!dev)
@@ -1248,38 +1267,42 @@ static ssize_t store_filter(struct device *device,
 	if (ret < 0)
 		return ret;
 
-	/* Can the scancode filter be set? */
-	set_filter = (fattr->type == RC_FILTER_NORMAL)
-		? dev->s_filter : dev->s_wakeup_filter;
+	if (fattr->type == RC_FILTER_NORMAL) {
+		set_filter = dev->s_filter;
+		enabled_protocols = &dev->enabled_protocols[RC_FILTER_NORMAL];
+		filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+	} else {
+		set_filter = dev->s_wakeup_filter;
+		enabled_protocols = &dev->enabled_protocols[RC_FILTER_WAKEUP];
+		filter = &dev->scancode_filters[RC_FILTER_WAKEUP];
+	}
+
 	if (!set_filter)
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
 
-	/* Tell the driver about the new filter */
-	filter = &dev->scancode_filters[fattr->type];
-	local_filter = *filter;
+	new_filter = *filter;
 	if (fattr->mask)
-		local_filter.mask = val;
+		new_filter.mask = val;
 	else
-		local_filter.data = val;
+		new_filter.data = val;
 
-	if (!dev->enabled_protocols[fattr->type] && local_filter.mask) {
+	if (!*enabled_protocols && val) {
 		/* refuse to set a filter unless a protocol is enabled */
 		ret = -EINVAL;
 		goto unlock;
 	}
 
-	ret = set_filter(dev, &local_filter);
+	ret = set_filter(dev, &new_filter);
 	if (ret < 0)
 		goto unlock;
 
-	/* Success, commit the new filter */
-	*filter = local_filter;
+	*filter = new_filter;
 
 unlock:
 	mutex_unlock(&dev->lock);
-	return (ret < 0) ? ret : count;
+	return (ret < 0) ? ret : len;
 }
 
 static void rc_dev_release(struct device *device)

