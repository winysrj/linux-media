Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:57213 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaBGOZa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 09:25:30 -0500
Message-Id: <E1WBmMy-0005WS-Lb@www.linuxtv.org>
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Thu, 06 Feb 2014 12:18:57 +0100
Subject: [git:media_tree/master] [media] media: rc: add sysfs scancode filtering interface
To: linuxtv-commits@linuxtv.org
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] media: rc: add sysfs scancode filtering interface
Author:  James Hogan <james.hogan@imgtec.com>
Date:    Fri Jan 17 10:58:49 2014 -0300

Add and document a generic sysfs based scancode filtering interface for
making use of IR data matching hardware to filter out uninteresting
scancodes. Two filters exist, one for normal operation and one for
filtering scancodes which are permitted to wake the system from suspend.

The following files are added to /sys/class/rc/rc?/:
 - filter: normal scancode filter value
 - filter_mask: normal scancode filter mask
 - wakeup_filter: wakeup scancode filter value
 - wakeup_filter_mask: wakeup scancode filter mask

A new s_filter() driver callback is added which must arrange for the
specified filter to be applied at the right time. Drivers can convert
the scancode filter into a raw IR data filter, which can be applied
immediately or later (for wake up filters).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

 Documentation/ABI/testing/sysfs-class-rc |   58 +++++++++++++
 drivers/media/rc/rc-main.c               |  136 ++++++++++++++++++++++++++++++
 include/media/rc-core.h                  |   29 +++++++
 3 files changed, 223 insertions(+), 0 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=00942d1a1bd93ac108c1b92d504c568a37be1833

diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/ABI/testing/sysfs-class-rc
index 52bc057..c0e1d14 100644
--- a/Documentation/ABI/testing/sysfs-class-rc
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -32,3 +32,61 @@ Description:
 		Writing "none" will disable all protocols.
 		Write fails with EINVAL if an invalid protocol combination or
 		unknown protocol name is used.
+
+What:		/sys/class/rc/rcN/filter
+Date:		Jan 2014
+KernelVersion:	3.15
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Sets the scancode filter expected value.
+		Use in combination with /sys/class/rc/rcN/filter_mask to set the
+		expected value of the bits set in the filter mask.
+		If the hardware supports it then scancodes which do not match
+		the filter will be ignored. Otherwise the write will fail with
+		an error.
+		This value may be reset to 0 if the current protocol is altered.
+
+What:		/sys/class/rc/rcN/filter_mask
+Date:		Jan 2014
+KernelVersion:	3.15
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Sets the scancode filter mask of bits to compare.
+		Use in combination with /sys/class/rc/rcN/filter to set the bits
+		of the scancode which should be compared against the expected
+		value. A value of 0 disables the filter to allow all valid
+		scancodes to be processed.
+		If the hardware supports it then scancodes which do not match
+		the filter will be ignored. Otherwise the write will fail with
+		an error.
+		This value may be reset to 0 if the current protocol is altered.
+
+What:		/sys/class/rc/rcN/wakeup_filter
+Date:		Jan 2014
+KernelVersion:	3.15
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Sets the scancode wakeup filter expected value.
+		Use in combination with /sys/class/rc/rcN/wakeup_filter_mask to
+		set the expected value of the bits set in the wakeup filter mask
+		to trigger a system wake event.
+		If the hardware supports it and wakeup_filter_mask is not 0 then
+		scancodes which match the filter will wake the system from e.g.
+		suspend to RAM or power off.
+		Otherwise the write will fail with an error.
+		This value may be reset to 0 if the current protocol is altered.
+
+What:		/sys/class/rc/rcN/wakeup_filter_mask
+Date:		Jan 2014
+KernelVersion:	3.15
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Sets the scancode wakeup filter mask of bits to compare.
+		Use in combination with /sys/class/rc/rcN/wakeup_filter to set
+		the bits of the scancode which should be compared against the
+		expected value to trigger a system wake event.
+		If the hardware supports it and wakeup_filter_mask is not 0 then
+		scancodes which match the filter will wake the system from e.g.
+		suspend to RAM or power off.
+		Otherwise the write will fail with an error.
+		This value may be reset to 0 if the current protocol is altered.
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f1b67db..fa8b957 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -969,6 +969,130 @@ out:
 	return ret;
 }
 
+/**
+ * struct rc_filter_attribute - Device attribute relating to a filter type.
+ * @attr:	Device attribute.
+ * @type:	Filter type.
+ * @mask:	false for filter value, true for filter mask.
+ */
+struct rc_filter_attribute {
+	struct device_attribute		attr;
+	enum rc_filter_type		type;
+	bool				mask;
+};
+#define to_rc_filter_attr(a) container_of(a, struct rc_filter_attribute, attr)
+
+#define RC_FILTER_ATTR(_name, _mode, _show, _store, _type, _mask)	\
+	struct rc_filter_attribute dev_attr_##_name = {			\
+		.attr = __ATTR(_name, _mode, _show, _store),		\
+		.type = (_type),					\
+		.mask = (_mask),					\
+	}
+
+/**
+ * show_filter() - shows the current scancode filter value or mask
+ * @device:	the device descriptor
+ * @attr:	the device attribute struct
+ * @buf:	a pointer to the output buffer
+ *
+ * This routine is a callback routine to read a scancode filter value or mask.
+ * It is trigged by reading /sys/class/rc/rc?/[wakeup_]filter[_mask].
+ * It prints the current scancode filter value or mask of the appropriate filter
+ * type in hexadecimal into @buf and returns the size of the buffer.
+ *
+ * Bits of the filter value corresponding to set bits in the filter mask are
+ * compared against input scancodes and non-matching scancodes are discarded.
+ *
+ * dev->lock is taken to guard against races between device registration,
+ * store_filter and show_filter.
+ */
+static ssize_t show_filter(struct device *device,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct rc_dev *dev = to_rc_dev(device);
+	struct rc_filter_attribute *fattr = to_rc_filter_attr(attr);
+	u32 val;
+
+	/* Device is being removed */
+	if (!dev)
+		return -EINVAL;
+
+	mutex_lock(&dev->lock);
+	if (!dev->s_filter)
+		val = 0;
+	else if (fattr->mask)
+		val = dev->scancode_filters[fattr->type].mask;
+	else
+		val = dev->scancode_filters[fattr->type].data;
+	mutex_unlock(&dev->lock);
+
+	return sprintf(buf, "%#x\n", val);
+}
+
+/**
+ * store_filter() - changes the scancode filter value
+ * @device:	the device descriptor
+ * @attr:	the device attribute struct
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is for changing a scancode filter value or mask.
+ * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]filter[_mask].
+ * Returns -EINVAL if an invalid filter value for the current protocol was
+ * specified or if scancode filtering is not supported by the driver, otherwise
+ * returns @len.
+ *
+ * Bits of the filter value corresponding to set bits in the filter mask are
+ * compared against input scancodes and non-matching scancodes are discarded.
+ *
+ * dev->lock is taken to guard against races between device registration,
+ * store_filter and show_filter.
+ */
+static ssize_t store_filter(struct device *device,
+			    struct device_attribute *attr,
+			    const char *buf,
+			    size_t count)
+{
+	struct rc_dev *dev = to_rc_dev(device);
+	struct rc_filter_attribute *fattr = to_rc_filter_attr(attr);
+	struct rc_scancode_filter local_filter, *filter;
+	int ret;
+	unsigned long val;
+
+	/* Device is being removed */
+	if (!dev)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	/* Scancode filter not supported (but still accept 0) */
+	if (!dev->s_filter)
+		return val ? -EINVAL : count;
+
+	mutex_lock(&dev->lock);
+
+	/* Tell the driver about the new filter */
+	filter = &dev->scancode_filters[fattr->type];
+	local_filter = *filter;
+	if (fattr->mask)
+		local_filter.mask = val;
+	else
+		local_filter.data = val;
+	ret = dev->s_filter(dev, fattr->type, &local_filter);
+	if (ret < 0)
+		goto unlock;
+
+	/* Success, commit the new filter */
+	*filter = local_filter;
+
+unlock:
+	mutex_unlock(&dev->lock);
+	return count;
+}
+
 static void rc_dev_release(struct device *device)
 {
 }
@@ -1000,9 +1124,21 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
  */
 static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
 		   show_protocols, store_protocols);
+static RC_FILTER_ATTR(filter, S_IRUGO|S_IWUSR,
+		      show_filter, store_filter, RC_FILTER_NORMAL, false);
+static RC_FILTER_ATTR(filter_mask, S_IRUGO|S_IWUSR,
+		      show_filter, store_filter, RC_FILTER_NORMAL, true);
+static RC_FILTER_ATTR(wakeup_filter, S_IRUGO|S_IWUSR,
+		      show_filter, store_filter, RC_FILTER_WAKEUP, false);
+static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
+		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
 
 static struct attribute *rc_dev_attrs[] = {
 	&dev_attr_protocols.attr,
+	&dev_attr_filter.attr.attr,
+	&dev_attr_filter_mask.attr.attr,
+	&dev_attr_wakeup_filter.attr.attr,
+	&dev_attr_wakeup_filter_mask.attr.attr,
 	NULL,
 };
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 2f6f1f7..4a72176 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -35,6 +35,29 @@ enum rc_driver_type {
 };
 
 /**
+ * struct rc_scancode_filter - Filter scan codes.
+ * @data:	Scancode data to match.
+ * @mask:	Mask of bits of scancode to compare.
+ */
+struct rc_scancode_filter {
+	u32 data;
+	u32 mask;
+};
+
+/**
+ * enum rc_filter_type - Filter type constants.
+ * @RC_FILTER_NORMAL:	Filter for normal operation.
+ * @RC_FILTER_WAKEUP:	Filter for waking from suspend.
+ * @RC_FILTER_MAX:	Number of filter types.
+ */
+enum rc_filter_type {
+	RC_FILTER_NORMAL = 0,
+	RC_FILTER_WAKEUP,
+
+	RC_FILTER_MAX
+};
+
+/**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
  * @input_name: name of the input child device
@@ -70,6 +93,7 @@ enum rc_driver_type {
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
+ * @scancode_filters: scancode filters (indexed by enum rc_filter_type)
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
@@ -84,6 +108,7 @@ enum rc_driver_type {
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  * @s_carrier_report: enable carrier reports
+ * @s_filter: set the scancode filter of a given type
  */
 struct rc_dev {
 	struct device			dev;
@@ -116,6 +141,7 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
+	struct rc_scancode_filter	scancode_filters[RC_FILTER_MAX];
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
@@ -127,6 +153,9 @@ struct rc_dev {
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
+	int				(*s_filter)(struct rc_dev *dev,
+						    enum rc_filter_type type,
+						    struct rc_scancode_filter *filter);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
