Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49141 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbcLFKTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:24 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4 01/13] [media] rc: change wakeup_protocols to list all protocol variants
Date: Tue,  6 Dec 2016 10:19:09 +0000
Message-Id: <1dfa6f89ca0c5596a8cf8e2dfd7d0a27dfbb1a55.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No driver has ever created a wakeup_protocol sysfs file since no
rc_dev driver implemented change_wakeup_protocol, so we are free to
change it.

For IR wakeup a driver has to program the hardware to wakeup at a
specific IR sequence, so it makes no sense to allow multiple wakeup
protocols to be selected. In the same manner the sysfs interface only
allows one scancode to be provided.

In addition we need to know the specific variant of the protocol.

Note that the ImgTec IR only ever set enabled_wakeup_protocols, it
never used it.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/ABI/testing/sysfs-class-rc       |  14 +-
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst |  13 +-
 drivers/media/rc/img-ir/img-ir-hw.c            |   2 -
 drivers/media/rc/rc-ir-raw.c                   |   1 -
 drivers/media/rc/rc-main.c                     | 266 ++++++++++++++++++++-----
 include/media/rc-core.h                        |   7 +-
 6 files changed, 236 insertions(+), 67 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/ABI/testing/sysfs-class-rc
index b65674d..cd47235 100644
--- a/Documentation/ABI/testing/sysfs-class-rc
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -62,18 +62,18 @@ Description:
 		This value may be reset to 0 if the current protocol is altered.
 
 What:		/sys/class/rc/rcN/wakeup_protocols
-Date:		Feb 2014
-KernelVersion:	3.15
+Date:		Feb 2017
+KernelVersion:	4.12
 Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 Description:
 		Reading this file returns a list of available protocols to use
 		for the wakeup filter, something like:
-		    "rc5 rc6 nec jvc [sony]"
+		    "rc-5 nec nec-x rc-6-0 rc-6-6a-24 [rc-6-6a-32] rc-6-mce"
+		Note that protocol variants are listed, so "nec", "sony",
+		"rc-5", "rc-6" have their different bit length encodings
+		listed if available.
 		The enabled wakeup protocol is shown in [] brackets.
-		Writing "+proto" will add a protocol to the list of enabled
-		wakeup protocols.
-		Writing "-proto" will remove a protocol from the list of enabled
-		wakeup protocols.
+		Only one protocol can be selected at a time.
 		Writing "proto" will use "proto" for wakeup events.
 		Writing "none" will disable wakeup.
 		Write fails with EINVAL if an invalid protocol combination or
diff --git a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
index 6fb944f..3476ae2 100644
--- a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
+++ b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
@@ -92,15 +92,16 @@ This value may be reset to 0 if the current protocol is altered.
 Reading this file returns a list of available protocols to use for the
 wakeup filter, something like:
 
-``rc5 rc6 nec jvc [sony]``
+``rc-5 nec nec-x rc-6-0 rc-6-6a-24 [rc-6-6a-32] rc-6-mce``
 
-The enabled wakeup protocol is shown in [] brackets.
+Note that protocol variants are listed, so "nec", "sony", "rc-5", "rc-6"
+have their different bit length encodings listed if available.
 
-Writing "+proto" will add a protocol to the list of enabled wakeup
-protocols.
+Note that all protocol variants are listed.
 
-Writing "-proto" will remove a protocol from the list of enabled wakeup
-protocols.
+The enabled wakeup protocol is shown in [] brackets.
+
+Only one protocol can be selected at a time.
 
 Writing "proto" will use "proto" for wakeup events.
 
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 7bb71bc..08f7c9b 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -685,7 +685,6 @@ static int img_ir_change_protocol(struct rc_dev *dev, u64 *ir_type)
 	if (!hw->decoder || !hw->decoder->filter)
 		wakeup_protocols = 0;
 	rdev->allowed_wakeup_protocols = wakeup_protocols;
-	rdev->enabled_wakeup_protocols = wakeup_protocols;
 	return 0;
 }
 
@@ -701,7 +700,6 @@ static void img_ir_set_protocol(struct img_ir_priv *priv, u64 proto)
 	mutex_lock(&rdev->lock);
 	rdev->enabled_protocols = proto;
 	rdev->allowed_wakeup_protocols = proto;
-	rdev->enabled_wakeup_protocols = proto;
 	mutex_unlock(&rdev->lock);
 }
 
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 1c42a9f..171bdba 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -246,7 +246,6 @@ static void ir_raw_disable_protocols(struct rc_dev *dev, u64 protocols)
 {
 	mutex_lock(&dev->lock);
 	dev->enabled_protocols &= ~protocols;
-	dev->enabled_wakeup_protocols &= ~protocols;
 	mutex_unlock(&dev->lock);
 }
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dedaf38..60229e9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -830,11 +830,6 @@ struct rc_filter_attribute {
 };
 #define to_rc_filter_attr(a) container_of(a, struct rc_filter_attribute, attr)
 
-#define RC_PROTO_ATTR(_name, _mode, _show, _store, _type)		\
-	struct rc_filter_attribute dev_attr_##_name = {			\
-		.attr = __ATTR(_name, _mode, _show, _store),		\
-		.type = (_type),					\
-	}
 #define RC_FILTER_ATTR(_name, _mode, _show, _store, _type, _mask)	\
 	struct rc_filter_attribute dev_attr_##_name = {			\
 		.attr = __ATTR(_name, _mode, _show, _store),		\
@@ -860,13 +855,13 @@ static bool lirc_is_present(void)
 }
 
 /**
- * show_protocols() - shows the current/wakeup IR protocol(s)
+ * show_protocols() - shows the current IR protocol(s)
  * @device:	the device descriptor
  * @mattr:	the device attribute struct
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type(s).
- * it is trigged by reading /sys/class/rc/rc?/[wakeup_]protocols.
+ * it is trigged by reading /sys/class/rc/rc?/protocols.
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
@@ -877,7 +872,6 @@ static ssize_t show_protocols(struct device *device,
 			      struct device_attribute *mattr, char *buf)
 {
 	struct rc_dev *dev = to_rc_dev(device);
-	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
 	u64 allowed, enabled;
 	char *tmp = buf;
 	int i;
@@ -891,15 +885,10 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	if (fattr->type == RC_FILTER_NORMAL) {
-		enabled = dev->enabled_protocols;
-		allowed = dev->allowed_protocols;
-		if (dev->raw && !allowed)
-			allowed = ir_raw_get_allowed_protocols();
-	} else {
-		enabled = dev->enabled_wakeup_protocols;
-		allowed = dev->allowed_wakeup_protocols;
-	}
+	enabled = dev->enabled_protocols;
+	allowed = dev->allowed_protocols;
+	if (dev->raw && !allowed)
+		allowed = ir_raw_get_allowed_protocols();
 
 	mutex_unlock(&dev->lock);
 
@@ -1058,11 +1047,8 @@ static ssize_t store_protocols(struct device *device,
 			       const char *buf, size_t len)
 {
 	struct rc_dev *dev = to_rc_dev(device);
-	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
 	u64 *current_protocols;
-	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
 	struct rc_scancode_filter *filter;
-	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
 	u64 old_protocols, new_protocols;
 	ssize_t rc;
 
@@ -1073,21 +1059,11 @@ static ssize_t store_protocols(struct device *device,
 	if (!atomic_read(&dev->initialized))
 		return -ERESTARTSYS;
 
-	if (fattr->type == RC_FILTER_NORMAL) {
-		IR_dprintk(1, "Normal protocol change requested\n");
-		current_protocols = &dev->enabled_protocols;
-		change_protocol = dev->change_protocol;
-		filter = &dev->scancode_filter;
-		set_filter = dev->s_filter;
-	} else {
-		IR_dprintk(1, "Wakeup protocol change requested\n");
-		current_protocols = &dev->enabled_wakeup_protocols;
-		change_protocol = dev->change_wakeup_protocol;
-		filter = &dev->scancode_wakeup_filter;
-		set_filter = dev->s_wakeup_filter;
-	}
+	IR_dprintk(1, "Normal protocol change requested\n");
+	current_protocols = &dev->enabled_protocols;
+	filter = &dev->scancode_filter;
 
-	if (!change_protocol) {
+	if (!dev->change_protocol) {
 		IR_dprintk(1, "Protocol switching not supported\n");
 		return -EINVAL;
 	}
@@ -1100,7 +1076,7 @@ static ssize_t store_protocols(struct device *device,
 	if (rc < 0)
 		goto out;
 
-	rc = change_protocol(dev, &new_protocols);
+	rc = dev->change_protocol(dev, &new_protocols);
 	if (rc < 0) {
 		IR_dprintk(1, "Error setting protocols to 0x%llx\n",
 			   (long long)new_protocols);
@@ -1123,16 +1099,16 @@ static ssize_t store_protocols(struct device *device,
 	 * Try setting the same filter with the new protocol (if any).
 	 * Fall back to clearing the filter.
 	 */
-	if (set_filter && filter->mask) {
+	if (dev->s_filter && filter->mask) {
 		if (new_protocols)
-			rc = set_filter(dev, filter);
+			rc = dev->s_filter(dev, filter);
 		else
 			rc = -1;
 
 		if (rc < 0) {
 			filter->data = 0;
 			filter->mask = 0;
-			set_filter(dev, filter);
+			dev->s_filter(dev, filter);
 		}
 	}
 
@@ -1221,7 +1197,6 @@ static ssize_t store_filter(struct device *device,
 	int ret;
 	unsigned long val;
 	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
-	u64 *enabled_protocols;
 
 	/* Device is being removed */
 	if (!dev)
@@ -1236,11 +1211,9 @@ static ssize_t store_filter(struct device *device,
 
 	if (fattr->type == RC_FILTER_NORMAL) {
 		set_filter = dev->s_filter;
-		enabled_protocols = &dev->enabled_protocols;
 		filter = &dev->scancode_filter;
 	} else {
 		set_filter = dev->s_wakeup_filter;
-		enabled_protocols = &dev->enabled_wakeup_protocols;
 		filter = &dev->scancode_wakeup_filter;
 	}
 
@@ -1255,7 +1228,16 @@ static ssize_t store_filter(struct device *device,
 	else
 		new_filter.data = val;
 
-	if (!*enabled_protocols && val) {
+	if (fattr->type == RC_FILTER_WAKEUP) {
+		/* refuse to set a filter unless a protocol is enabled */
+		if (dev->wakeup_protocol == RC_TYPE_UNKNOWN && val) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+	}
+
+	if (fattr->type == RC_FILTER_NORMAL && !dev->enabled_protocols
+								&& val) {
 		/* refuse to set a filter unless a protocol is enabled */
 		ret = -EINVAL;
 		goto unlock;
@@ -1272,6 +1254,195 @@ static ssize_t store_filter(struct device *device,
 	return (ret < 0) ? ret : len;
 }
 
+/*
+ * This is the list of all variants of all protocols, which is used by
+ * the wakeup_protocols sysfs entry. In the protocols sysfs entry some
+ * some protocols are grouped together (e.g. nec = nec + necx + nec32).
+ *
+ * For wakeup we need to know the exact protocol variant so the hardware
+ * can be programmed exactly what to expect.
+ */
+static const char * const proto_variant_names[] = {
+	[RC_TYPE_UNKNOWN] = "unknown",
+	[RC_TYPE_OTHER] = "other",
+	[RC_TYPE_RC5] = "rc-5",
+	[RC_TYPE_RC5X] = "rc-5x",
+	[RC_TYPE_RC5_SZ] = "rc-5-sz",
+	[RC_TYPE_JVC] = "jvc",
+	[RC_TYPE_SONY12] = "sony-12",
+	[RC_TYPE_SONY15] = "sony-15",
+	[RC_TYPE_SONY20] = "sony-20",
+	[RC_TYPE_NEC] = "nec",
+	[RC_TYPE_NECX] = "nec-x",
+	[RC_TYPE_NEC32] = "nec-32",
+	[RC_TYPE_SANYO] = "sanyo",
+	[RC_TYPE_MCE_KBD] = "mce_kbd",
+	[RC_TYPE_RC6_0] = "rc-6-0",
+	[RC_TYPE_RC6_6A_20] = "rc-6-6a-20",
+	[RC_TYPE_RC6_6A_24] = "rc-6-6a-24",
+	[RC_TYPE_RC6_6A_32] = "rc-6-6a-32",
+	[RC_TYPE_RC6_MCE] = "rc-6-mce",
+	[RC_TYPE_SHARP] = "sharp",
+	[RC_TYPE_XMP] = "xmp",
+	[RC_TYPE_CEC] = "cec",
+};
+
+/**
+ * show_wakeup_protocols() - shows the wakeup IR protocol
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct
+ * @buf:	a pointer to the output buffer
+ *
+ * This routine is a callback routine for input read the IR protocol type(s).
+ * it is trigged by reading /sys/class/rc/rc?/wakeup_protocols.
+ * It returns the protocol names of supported protocols.
+ * The enabled protocols are printed in brackets.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_protocols and show_protocols.
+ */
+static ssize_t show_wakeup_protocols(struct device *device,
+				     struct device_attribute *mattr,
+				     char *buf)
+{
+	struct rc_dev *dev = to_rc_dev(device);
+	u64 allowed;
+	enum rc_type enabled;
+	char *tmp = buf;
+	int i;
+
+	/* Device is being removed */
+	if (!dev)
+		return -EINVAL;
+
+	if (!atomic_read(&dev->initialized))
+		return -ERESTARTSYS;
+
+	mutex_lock(&dev->lock);
+
+	allowed = dev->allowed_wakeup_protocols;
+	enabled = dev->wakeup_protocol;
+
+	mutex_unlock(&dev->lock);
+
+	IR_dprintk(1, "%s: allowed - 0x%llx, enabled - %d\n",
+		   __func__, (long long)allowed, enabled);
+
+	for (i = 0; i < ARRAY_SIZE(proto_variant_names); i++) {
+		if (allowed & (1 << i)) {
+			if (i == enabled)
+				tmp += sprintf(tmp, "[%s] ",
+						proto_variant_names[i]);
+			else
+				tmp += sprintf(tmp, "%s ",
+						proto_variant_names[i]);
+		}
+	}
+
+	if (tmp != buf)
+		tmp--;
+	*tmp = '\n';
+
+	return tmp + 1 - buf;
+}
+
+/**
+ * store_wakeup_protocols() - changes the wakeup IR protocol(s)
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is for changing the IR protocol type.
+ * It is trigged by writing to /sys/class/rc/rc?/wakeup_protocols.
+ * Returns @len on success or a negative error code.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_protocols and show_protocols.
+ */
+static ssize_t store_wakeup_protocols(struct device *device,
+			       struct device_attribute *mattr,
+			       const char *buf, size_t len)
+{
+	struct rc_dev *dev = to_rc_dev(device);
+	enum rc_type old_protocol, new_protocol;
+	struct rc_scancode_filter *filter;
+	ssize_t rc;
+	u64 allowed;
+	int i;
+
+	/* Device is being removed */
+	if (!dev)
+		return -EINVAL;
+
+	if (!atomic_read(&dev->initialized))
+		return -ERESTARTSYS;
+
+	filter = &dev->scancode_wakeup_filter;
+
+	if (!dev->change_wakeup_protocol) {
+		IR_dprintk(1, "Protocol switching not supported\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&dev->lock);
+
+	allowed = dev->allowed_wakeup_protocols;
+	old_protocol = dev->wakeup_protocol;
+
+	if (sysfs_streq(buf, "none")) {
+		new_protocol = RC_TYPE_UNKNOWN;
+	} else {
+		for (i = 0; i < ARRAY_SIZE(proto_variant_names); i++) {
+			if ((allowed & (1 << i)) && sysfs_streq(buf,
+						proto_variant_names[i])) {
+				new_protocol = i;
+				break;
+			}
+		}
+
+		if (i == ARRAY_SIZE(proto_variant_names)) {
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (old_protocol != new_protocol) {
+		rc = dev->change_wakeup_protocol(dev, new_protocol);
+		if (rc < 0) {
+			IR_dprintk(1, "Error setting protocols to %d\n",
+				   new_protocol);
+			goto out;
+		}
+
+		dev->wakeup_protocol = new_protocol;
+		IR_dprintk(1, "Protocols changed to %d\n", new_protocol);
+	}
+
+	/*
+	 * If a protocol change was attempted the filter may need updating, even
+	 * if the actual protocol mask hasn't changed (since the driver may have
+	 * cleared the filter).
+	 * Try setting the same filter with the new protocol (if any).
+	 * Fall back to clearing the filter.
+	 */
+	if (dev->s_wakeup_filter && filter->mask) {
+		rc = dev->s_wakeup_filter(dev, filter);
+		if (rc < 0) {
+			filter->data = 0;
+			filter->mask = 0;
+			dev->s_wakeup_filter(dev, filter);
+		}
+	}
+
+	rc = len;
+
+out:
+	mutex_unlock(&dev->lock);
+	return rc;
+}
+
+
 static void rc_dev_release(struct device *device)
 {
 	struct rc_dev *dev = to_rc_dev(device);
@@ -1301,10 +1472,9 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 /*
  * Static device attribute struct with the sysfs attributes for IR's
  */
-static RC_PROTO_ATTR(protocols, S_IRUGO | S_IWUSR,
-		     show_protocols, store_protocols, RC_FILTER_NORMAL);
-static RC_PROTO_ATTR(wakeup_protocols, S_IRUGO | S_IWUSR,
-		     show_protocols, store_protocols, RC_FILTER_WAKEUP);
+static DEVICE_ATTR(protocols, 0644, show_protocols, store_protocols);
+static DEVICE_ATTR(wakeup_protocols, 0644, show_wakeup_protocols,
+		   store_wakeup_protocols);
 static RC_FILTER_ATTR(filter, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_NORMAL, false);
 static RC_FILTER_ATTR(filter_mask, S_IRUGO|S_IWUSR,
@@ -1315,7 +1485,7 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
 
 static struct attribute *rc_dev_protocol_attrs[] = {
-	&dev_attr_protocols.attr.attr,
+	&dev_attr_protocols.attr,
 	NULL,
 };
 
@@ -1324,7 +1494,7 @@ static struct attribute_group rc_dev_protocol_attr_grp = {
 };
 
 static struct attribute *rc_dev_wakeup_protocol_attrs[] = {
-	&dev_attr_wakeup_protocols.attr.attr,
+	&dev_attr_wakeup_protocols.attr,
 	NULL,
 };
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 55281b9..3c34cac 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -86,7 +86,8 @@ enum rc_filter_type {
  * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
  * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
  * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
- * @enabled_wakeup_protocols: bitmask with the enabled RC_BIT_* wakeup protocols
+ * @wakeup_protocol: the enabled RC_TYPE_* wakeup protocol or
+ *	RC_TYPE_UNKNOWN if disabled.
  * @scancode_filter: scancode filter
  * @scancode_wakeup_filter: scancode wakeup filters
  * @scancode_mask: some hardware decoders are not capable of providing the full
@@ -149,7 +150,7 @@ struct rc_dev {
 	u64				allowed_protocols;
 	u64				enabled_protocols;
 	u64				allowed_wakeup_protocols;
-	u64				enabled_wakeup_protocols;
+	enum rc_type			wakeup_protocol;
 	struct rc_scancode_filter	scancode_filter;
 	struct rc_scancode_filter	scancode_wakeup_filter;
 	u32				scancode_mask;
@@ -169,7 +170,7 @@ struct rc_dev {
 	u32				rx_resolution;
 	u32				tx_resolution;
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
-	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int				(*change_wakeup_protocol)(struct rc_dev *dev, enum rc_type protocol);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
 	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
-- 
2.9.3

