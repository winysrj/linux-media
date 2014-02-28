Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:52921 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaB1XRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:44 -0500
Received: by mail-we0-f182.google.com with SMTP id u57so1121270wes.27
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:17:42 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH 4/5] rc: add wakeup_protocols sysfs file
Date: Fri, 28 Feb 2014 23:17:05 +0000
Message-Id: <1393629426-31341-5-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a wakeup_protocols sysfs file which controls the new
rc_dev::enabled_protocols[RC_FILTER_WAKEUP], which is the mask of
protocols that are used for the wakeup filter.

A new RC driver callback change_wakeup_protocol() is called to change
the wakeup protocol mask.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: linux-media@vger.kernel.org
Cc: linux-doc@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-class-rc           | 23 +++++-
 .../DocBook/media/v4l/remote_controllers.xml       | 20 +++++-
 drivers/media/rc/rc-main.c                         | 82 +++++++++++++---------
 include/media/rc-core.h                            |  3 +
 4 files changed, 90 insertions(+), 38 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/ABI/testing/sysfs-class-rc
index c0e1d14..b65674d 100644
--- a/Documentation/ABI/testing/sysfs-class-rc
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -61,6 +61,25 @@ Description:
 		an error.
 		This value may be reset to 0 if the current protocol is altered.
 
+What:		/sys/class/rc/rcN/wakeup_protocols
+Date:		Feb 2014
+KernelVersion:	3.15
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Reading this file returns a list of available protocols to use
+		for the wakeup filter, something like:
+		    "rc5 rc6 nec jvc [sony]"
+		The enabled wakeup protocol is shown in [] brackets.
+		Writing "+proto" will add a protocol to the list of enabled
+		wakeup protocols.
+		Writing "-proto" will remove a protocol from the list of enabled
+		wakeup protocols.
+		Writing "proto" will use "proto" for wakeup events.
+		Writing "none" will disable wakeup.
+		Write fails with EINVAL if an invalid protocol combination or
+		unknown protocol name is used, or if wakeup is not supported by
+		the hardware.
+
 What:		/sys/class/rc/rcN/wakeup_filter
 Date:		Jan 2014
 KernelVersion:	3.15
@@ -74,7 +93,7 @@ Description:
 		scancodes which match the filter will wake the system from e.g.
 		suspend to RAM or power off.
 		Otherwise the write will fail with an error.
-		This value may be reset to 0 if the current protocol is altered.
+		This value may be reset to 0 if the wakeup protocol is altered.
 
 What:		/sys/class/rc/rcN/wakeup_filter_mask
 Date:		Jan 2014
@@ -89,4 +108,4 @@ Description:
 		scancodes which match the filter will wake the system from e.g.
 		suspend to RAM or power off.
 		Otherwise the write will fail with an error.
-		This value may be reset to 0 if the current protocol is altered.
+		This value may be reset to 0 if the wakeup protocol is altered.
diff --git a/Documentation/DocBook/media/v4l/remote_controllers.xml b/Documentation/DocBook/media/v4l/remote_controllers.xml
index c440a81..5124a6c 100644
--- a/Documentation/DocBook/media/v4l/remote_controllers.xml
+++ b/Documentation/DocBook/media/v4l/remote_controllers.xml
@@ -102,6 +102,22 @@ an error.</para>
 <para>This value may be reset to 0 if the current protocol is altered.</para>
 
 </section>
+<section id="sys_class_rc_rcN_wakeup_protocols">
+<title>/sys/class/rc/rcN/wakeup_protocols</title>
+<para>Reading this file returns a list of available protocols to use for the
+wakeup filter, something like:</para>
+<para><constant>rc5 rc6 nec jvc [sony]</constant></para>
+<para>The enabled wakeup protocol is shown in [] brackets.</para>
+<para>Writing "+proto" will add a protocol to the list of enabled wakeup
+protocols.</para>
+<para>Writing "-proto" will remove a protocol from the list of enabled wakeup
+protocols.</para>
+<para>Writing "proto" will use "proto" for wakeup events.</para>
+<para>Writing "none" will disable wakeup.</para>
+<para>Write fails with EINVAL if an invalid protocol combination or unknown
+protocol name is used, or if wakeup is not supported by the hardware.</para>
+
+</section>
 <section id="sys_class_rc_rcN_wakeup_filter">
 <title>/sys/class/rc/rcN/wakeup_filter</title>
 <para>Sets the scancode wakeup filter expected value.
@@ -112,7 +128,7 @@ to trigger a system wake event.</para>
 scancodes which match the filter will wake the system from e.g.
 suspend to RAM or power off.
 Otherwise the write will fail with an error.</para>
-<para>This value may be reset to 0 if the current protocol is altered.</para>
+<para>This value may be reset to 0 if the wakeup protocol is altered.</para>
 
 </section>
 <section id="sys_class_rc_rcN_wakeup_filter_mask">
@@ -125,7 +141,7 @@ expected value to trigger a system wake event.</para>
 scancodes which match the filter will wake the system from e.g.
 suspend to RAM or power off.
 Otherwise the write will fail with an error.</para>
-<para>This value may be reset to 0 if the current protocol is altered.</para>
+<para>This value may be reset to 0 if the wakeup protocol is altered.</para>
 </section>
 </section>
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 309d791..e6e3ec7 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -803,13 +803,38 @@ static struct {
 };
 
 /**
- * show_protocols() - shows the current IR protocol(s)
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
+#define RC_PROTO_ATTR(_name, _mode, _show, _store, _type)		\
+	struct rc_filter_attribute dev_attr_##_name = {			\
+		.attr = __ATTR(_name, _mode, _show, _store),		\
+		.type = (_type),					\
+	}
+#define RC_FILTER_ATTR(_name, _mode, _show, _store, _type, _mask)	\
+	struct rc_filter_attribute dev_attr_##_name = {			\
+		.attr = __ATTR(_name, _mode, _show, _store),		\
+		.type = (_type),					\
+		.mask = (_mask),					\
+	}
+
+/**
+ * show_protocols() - shows the current/wakeup IR protocol(s)
  * @device:	the device descriptor
  * @mattr:	the device attribute struct (unused)
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type(s).
- * it is trigged by reading /sys/class/rc/rc?/protocols.
+ * it is trigged by reading /sys/class/rc/rc?/[wakeup_]protocols.
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
@@ -820,6 +845,7 @@ static ssize_t show_protocols(struct device *device,
 			      struct device_attribute *mattr, char *buf)
 {
 	struct rc_dev *dev = to_rc_dev(device);
+	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
 	u64 allowed, enabled;
 	char *tmp = buf;
 	int i;
@@ -830,9 +856,10 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	enabled = dev->enabled_protocols[RC_FILTER_NORMAL];
-	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		allowed = dev->allowed_protocols[RC_FILTER_NORMAL];
+	enabled = dev->enabled_protocols[fattr->type];
+	if (dev->driver_type == RC_DRIVER_SCANCODE ||
+	    fattr->type == RC_FILTER_WAKEUP)
+		allowed = dev->allowed_protocols[fattr->type];
 	else if (dev->raw)
 		allowed = ir_raw_get_allowed_protocols();
 	else {
@@ -864,14 +891,14 @@ static ssize_t show_protocols(struct device *device,
 }
 
 /**
- * store_protocols() - changes the current IR protocol(s)
+ * store_protocols() - changes the current/wakeup IR protocol(s)
  * @device:	the device descriptor
  * @mattr:	the device attribute struct (unused)
  * @buf:	a pointer to the input buffer
  * @len:	length of the input buffer
  *
  * This routine is for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/protocols.
+ * It is trigged by writing to /sys/class/rc/rc?/[wakeup_]protocols.
  * Writing "+proto" will add a protocol to the list of enabled protocols.
  * Writing "-proto" will remove a protocol from the list of enabled protocols.
  * Writing "proto" will enable only "proto".
@@ -888,12 +915,14 @@ static ssize_t store_protocols(struct device *device,
 			       size_t len)
 {
 	struct rc_dev *dev = to_rc_dev(device);
+	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
 	bool enable, disable;
 	const char *tmp;
 	u64 type;
 	u64 mask;
 	int rc, i, count = 0;
 	ssize_t ret;
+	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
 
 	/* Device is being removed */
 	if (!dev)
@@ -906,7 +935,7 @@ static ssize_t store_protocols(struct device *device,
 		ret = -EINVAL;
 		goto out;
 	}
-	type = dev->enabled_protocols[RC_FILTER_NORMAL];
+	type = dev->enabled_protocols[fattr->type];
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -954,8 +983,10 @@ static ssize_t store_protocols(struct device *device,
 		goto out;
 	}
 
-	if (dev->change_protocol) {
-		rc = dev->change_protocol(dev, &type);
+	change_protocol = (fattr->type == RC_FILTER_NORMAL)
+		? dev->change_protocol : dev->change_wakeup_protocol;
+	if (change_protocol) {
+		rc = change_protocol(dev, &type);
 		if (rc < 0) {
 			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
 				   (long long)type);
@@ -964,7 +995,7 @@ static ssize_t store_protocols(struct device *device,
 		}
 	}
 
-	dev->enabled_protocols[RC_FILTER_NORMAL] = type;
+	dev->enabled_protocols[fattr->type] = type;
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
@@ -976,26 +1007,6 @@ out:
 }
 
 /**
- * struct rc_filter_attribute - Device attribute relating to a filter type.
- * @attr:	Device attribute.
- * @type:	Filter type.
- * @mask:	false for filter value, true for filter mask.
- */
-struct rc_filter_attribute {
-	struct device_attribute		attr;
-	enum rc_filter_type		type;
-	bool				mask;
-};
-#define to_rc_filter_attr(a) container_of(a, struct rc_filter_attribute, attr)
-
-#define RC_FILTER_ATTR(_name, _mode, _show, _store, _type, _mask)	\
-	struct rc_filter_attribute dev_attr_##_name = {			\
-		.attr = __ATTR(_name, _mode, _show, _store),		\
-		.type = (_type),					\
-		.mask = (_mask),					\
-	}
-
-/**
  * show_filter() - shows the current scancode filter value or mask
  * @device:	the device descriptor
  * @attr:	the device attribute struct
@@ -1128,8 +1139,10 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 /*
  * Static device attribute struct with the sysfs attributes for IR's
  */
-static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
-		   show_protocols, store_protocols);
+static RC_PROTO_ATTR(protocols, S_IRUGO | S_IWUSR,
+		     show_protocols, store_protocols, RC_FILTER_NORMAL);
+static RC_PROTO_ATTR(wakeup_protocols, S_IRUGO | S_IWUSR,
+		     show_protocols, store_protocols, RC_FILTER_WAKEUP);
 static RC_FILTER_ATTR(filter, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_NORMAL, false);
 static RC_FILTER_ATTR(filter_mask, S_IRUGO|S_IWUSR,
@@ -1140,7 +1153,8 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
 
 static struct attribute *rc_dev_attrs[] = {
-	&dev_attr_protocols.attr,
+	&dev_attr_protocols.attr.attr,
+	&dev_attr_wakeup_protocols.attr.attr,
 	&dev_attr_filter.attr.attr,
 	&dev_attr_filter_mask.attr.attr,
 	&dev_attr_wakeup_filter.attr.attr,
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f165115..0b9f890 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -97,6 +97,8 @@ enum rc_filter_type {
  * @tx_resolution: resolution (in ns) of output sampler
  * @scancode_filters: scancode filters (indexed by enum rc_filter_type)
  * @change_protocol: allow changing the protocol used on hardware decoders
+ * @change_wakeup_protocol: allow changing the protocol used for wakeup
+ *	filtering
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
  * @close: callback to allow drivers to disable polling/irq when IR input device
@@ -145,6 +147,7 @@ struct rc_dev {
 	u32				tx_resolution;
 	struct rc_scancode_filter	scancode_filters[RC_FILTER_MAX];
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
 	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
-- 
1.8.3.2

