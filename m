Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43947 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZVvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 16:51:05 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so3989717lbj.3
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:51:03 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 2/5] rc-core: Add support for reading/writing wakeup codes via sysfs
Date: Sun, 26 Jan 2014 23:50:23 +0200
Message-Id: <1390773026-567-3-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
References: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for two files in sysfs controlling the wakeup
(scan)codes that are written to hardware.

* /sys/class/rc/rc?/wakeup_protocols:

This file has the same syntax as rc protocols file
(/sys/class/rc/rc?/protocols). When read it displays the wakeup
protocols the underlying IR driver supports. Protocol can be changed by
writing it to the file. The active protocol defines how actual
wakeup_code is to be interpreted.

Note: Only one protocol can be active at a time.

* /sys/class/rc/rc?/wakeup_codes:

This file contains the currently active wakeup (scan)code(s).
New values can be written to activate a new wakeup code.

The contents of the wakeup_code file are simply white space separated
values.

Note: Protocol "other" has a special meaning: if activated then
wakeup_codes file will contain raw IR samples. Positive values
represent pulses and negative values spaces.

How to read:
 cat /sys/class/rc/rc?/wakeup_codes

How to write:
 echo "rc-6" > /sys/class/rc/rc?/wakeup_protocols
 echo "0xd1ab" > /sys/class/rc/rc?/wakeup_codes

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/rc-main.c | 179 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 165 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 02e2f38..cde17e2 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -797,7 +797,7 @@ static struct {
 /**
  * show_protocols() - shows the current IR protocol(s)
  * @device:	the device descriptor
- * @mattr:	the device attribute struct (unused)
+ * @mattr:	the device attribute struct
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type(s).
@@ -822,14 +822,19 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	enabled = dev->enabled_protocols;
-	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		allowed = dev->allowed_protos;
-	else if (dev->raw)
-		allowed = ir_raw_get_allowed_protocols();
-	else {
-		mutex_unlock(&dev->lock);
-		return -ENODEV;
+	if (strcmp(mattr->attr.name, "wakeup_protocols") == 0) {
+		enabled = dev->enabled_wake_protos;
+		allowed = dev->allowed_wake_protos;
+	} else {
+		enabled = dev->enabled_protocols;
+		if (dev->driver_type == RC_DRIVER_SCANCODE)
+			allowed = dev->allowed_protos;
+		else if (dev->raw)
+			allowed = ir_raw_get_allowed_protocols();
+		else {
+			mutex_unlock(&dev->lock);
+			return -ENODEV;
+		}
 	}
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
@@ -858,7 +863,7 @@ static ssize_t show_protocols(struct device *device,
 /**
  * store_protocols() - changes the current IR protocol(s)
  * @device:	the device descriptor
- * @mattr:	the device attribute struct (unused)
+ * @mattr:	the device attribute struct
  * @buf:	a pointer to the input buffer
  * @len:	length of the input buffer
  *
@@ -884,7 +889,7 @@ static ssize_t store_protocols(struct device *device,
 	const char *tmp;
 	u64 type;
 	u64 mask;
-	int rc, i, count = 0;
+	int rc, i, wake = 0, count = 0, enablecount = 0;
 	ssize_t ret;
 
 	/* Device is being removed */
@@ -898,7 +903,13 @@ static ssize_t store_protocols(struct device *device,
 		ret = -EINVAL;
 		goto out;
 	}
-	type = dev->enabled_protocols;
+
+	if (strcmp(mattr->attr.name, "wakeup_protocols") == 0) {
+		wake = 1;
+		type = dev->enabled_wake_protos;
+	} else {
+		type = dev->enabled_protocols;
+	}
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -920,6 +931,8 @@ static ssize_t store_protocols(struct device *device,
 		for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
 			if (!strcasecmp(tmp, proto_names[i].name)) {
 				mask = proto_names[i].type;
+				if (wake && (enable || (!enable && !disable)))
+					enablecount++;
 				break;
 			}
 		}
@@ -946,7 +959,7 @@ static ssize_t store_protocols(struct device *device,
 		goto out;
 	}
 
-	if (dev->change_protocol) {
+	if (dev->change_protocol && !wake) {
 		rc = dev->change_protocol(dev, &type);
 		if (rc < 0) {
 			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
@@ -956,7 +969,16 @@ static ssize_t store_protocols(struct device *device,
 		}
 	}
 
-	dev->enabled_protocols = type;
+	if (wake && enablecount > 1) {
+		IR_dprintk(1, "Only one wake protocol can be enabled "
+			   "at a time\n");
+		ret = -EINVAL;
+		goto out;
+	} else if (wake) {
+		dev->enabled_wake_protos = type;
+	} else {
+		dev->enabled_protocols = type;
+	}
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
@@ -967,6 +989,121 @@ out:
 	return ret;
 }
 
+/**
+ * show_wakeup_codes() - shows the current IR wake code(s)
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the output buffer
+ *
+ * This routine is a callback routine for input read the IR wake code(s).
+ * it is trigged by reading /sys/class/rc/rc?/wakeup_codes.
+ * It returns the currently active IR wake code or empty buffer if wake
+ * code is not active.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_wakeup_codes and show_wakeup_codes.
+ */
+static ssize_t show_wakeup_codes(struct device *device,
+				     struct device_attribute *mattr, char *buf)
+{
+	int ret, pos = 0;
+	struct rc_wakeup_code *code, *next;
+	LIST_HEAD(wakeup_code_list);
+	struct rc_dev *dev = to_rc_dev(device);
+
+	if (!dev || !dev->s_wakeup_codes)
+		return -ENODEV;
+
+	mutex_lock(&dev->lock);
+
+	ret = dev->s_wakeup_codes(dev, &wakeup_code_list, 0);
+
+	list_for_each_entry_safe(code, next, &wakeup_code_list, list_item) {
+		if (dev->enabled_wake_protos & RC_BIT_OTHER)
+			pos += scnprintf(buf + pos, PAGE_SIZE - pos, "%d ",
+					 code->value);
+		else
+			pos += scnprintf(buf + pos, PAGE_SIZE - pos, "0x%x ",
+					 code->value);
+		list_del(&code->list_item);
+		kfree(code);
+	}
+	pos += scnprintf(buf + pos, PAGE_SIZE - pos, "\n");
+
+	mutex_unlock(&dev->lock);
+
+	if (ret < 0)
+		return ret;
+
+	return pos;
+}
+
+/**
+ * store_wakeup_codes() - changes the current IR wake code(s)
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is for changing the IR wake code.
+ * It is trigged by writing to /sys/class/rc/rc?/wakeup_codes.
+ * Writing bytes separated by white space will pass them to the hardware.
+ * Writing "" (empty) will clear active wake code.
+ * Returns -EINVAL if too many values or invalid values were used
+ * otherwise @len.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_wakeup_codes and show_wakeup_codes.
+ */
+static ssize_t store_wakeup_codes(struct device *device,
+				      struct device_attribute *mattr,
+				      const char *data,
+				      size_t len)
+{
+	int ret = 0;
+	char *tmp;
+	long value;
+	struct rc_wakeup_code *code, *next;
+	LIST_HEAD(wakeup_code_list);
+	struct rc_dev *dev = to_rc_dev(device);
+
+	if (!dev || !dev->s_wakeup_codes)
+		return -ENODEV;
+
+	mutex_lock(&dev->lock);
+
+	while ((tmp = strsep((char **) &data, " ,\t\n")) != NULL) {
+		if (!*tmp)
+			break;
+
+		ret = kstrtol(tmp, 0, &value);
+		if (ret < 0) {
+			IR_dprintk(1, "Error parsing value of %s", tmp);
+			break;
+		}
+
+		code = kmalloc(sizeof(struct rc_wakeup_code), GFP_KERNEL);
+		if (!code) {
+			ret = -ENOMEM;
+			break;
+		}
+		code->value = value;
+		list_add_tail(&code->list_item, &wakeup_code_list);
+	}
+
+	if (!ret)
+		ret = dev->s_wakeup_codes(dev, &wakeup_code_list, 1);
+
+	list_for_each_entry_safe(code, next, &wakeup_code_list, list_item) {
+		list_del(&code->list_item);
+		kfree(code);
+	}
+
+	mutex_unlock(&dev->lock);
+
+	return ret ? ret : len;
+}
+
 static void rc_dev_release(struct device *device)
 {
 }
@@ -998,6 +1135,10 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
  */
 static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
 		   show_protocols, store_protocols);
+static DEVICE_ATTR(wakeup_protocols, S_IRUGO | S_IWUSR,
+		   show_protocols, store_protocols);
+static DEVICE_ATTR(wakeup_codes, S_IRUGO | S_IWUSR,
+		   show_wakeup_codes, store_wakeup_codes);
 
 static struct attribute *rc_dev_attrs[] = {
 	&dev_attr_protocols.attr,
@@ -1175,6 +1316,16 @@ int rc_register_device(struct rc_dev *dev)
 		dev->enabled_protocols = rc_type;
 	}
 
+	/* Create sysfs entry only if device has wake code support */
+	if (dev->s_wakeup_codes) {
+		rc = device_create_file(&dev->dev, &dev_attr_wakeup_codes);
+		if (rc < 0)
+			goto out_raw;
+		rc = device_create_file(&dev->dev, &dev_attr_wakeup_protocols);
+		if (rc < 0)
+			goto out_raw;
+	}
+
 	mutex_unlock(&dev->lock);
 
 	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode %s)\n",
-- 
1.8.3.2

