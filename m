Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:51422 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaATTkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 14:40:09 -0500
Received: by mail-la0-f42.google.com with SMTP id hr13so3908551lab.29
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 11:40:08 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 2/4] rc-core: Add support for reading/writing wakeup scancodes via sysfs
Date: Mon, 20 Jan 2014 21:39:45 +0200
Message-Id: <1390246787-15616-3-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
References: <20140115173559.7e53239a@samsung.com>
 <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for /sys/class/rc/rc?/wakeup_scancodes file
which can be used to read/write new wakeup scancodes to/from hardware.

The contents of the scancode file are simply white space separated
bytes.

How to read:
 cat /sys/class/rc/rc?/wakeup_scancodes

How to write:
 echo "0x1 0x2 0x3" > /sys/class/rc/rc?/wakeup_scancodes

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/rc-main.c | 129 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 02e2f38..a2a68f3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -967,6 +967,119 @@ out:
 	return ret;
 }
 
+/**
+ * show_wakeup_scancodes() - shows the current IR wake scancode(s)
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the output buffer
+ *
+ * This routine is a callback routine for input read the IR wake scancode(s).
+ * it is trigged by reading /sys/class/rc/rc?/wakeup_scancodes.
+ * It returns the currently active IR wake scancode or empty buffer if wake
+ * scancode is not active.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_wakeup_scancodes and show_wakeup_scancodes.
+ */
+static ssize_t show_wakeup_scancodes(struct device *device,
+				     struct device_attribute *mattr, char *buf)
+{
+	int ret, pos = 0;
+	struct rc_wakeup_scancode *scancode, *next;
+	LIST_HEAD(scancode_list);
+	struct rc_dev *dev = to_rc_dev(device);
+
+	if (!dev || !dev->s_wakeup_scancodes)
+		return -ENODEV;
+
+	mutex_lock(&dev->lock);
+
+	ret = dev->s_wakeup_scancodes(dev, &scancode_list, 0);
+
+	list_for_each_entry_safe_reverse(scancode, next, &scancode_list,
+					 list_item) {
+		pos += scnprintf(buf + pos, PAGE_SIZE - pos, "0x%x ",
+				 scancode->value);
+		list_del(&scancode->list_item);
+		kfree(scancode);
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
+ * store_wakeup_scancodes() - changes the current IR wake scancode(s)
+ * @device:	the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is for changing the IR wake scancode.
+ * It is trigged by writing to /sys/class/rc/rc?/wakeup_scancodes.
+ * Writing bytes separated by white space will pass them to the hardware.
+ * Writing "" (empty) will clear active wake scancode.
+ * Returns -EINVAL if too many values or invalid values were used
+ * otherwise @len.
+ *
+ * dev->lock is taken to guard against races between device
+ * registration, store_wakeup_scancodes and show_wakeup_scancodes.
+ */
+static ssize_t store_wakeup_scancodes(struct device *device,
+				      struct device_attribute *mattr,
+				      const char *data,
+				      size_t len)
+{
+	int ret = 0, error = 0;
+	char *tmp;
+	u8 value;
+	struct rc_wakeup_scancode *scancode, *next;
+	LIST_HEAD(scancode_list);
+	struct rc_dev *dev = to_rc_dev(device);
+
+	if (!dev || !dev->s_wakeup_scancodes)
+		return -ENODEV;
+
+	mutex_lock(&dev->lock);
+
+	while ((tmp = strsep((char **) &data, " ,\t\n")) != NULL) {
+		if (!*tmp)
+			break;
+
+		if (sscanf(tmp, "0x%2hhx", &value) != 1 &&
+		    sscanf(tmp,   "%2hhx", &value) != 1) {
+			error = 1;
+			break;
+		} else {
+			scancode = kmalloc(sizeof(struct rc_wakeup_scancode),
+					   GFP_KERNEL);
+			scancode->value = value;
+			list_add(&scancode->list_item, &scancode_list);
+		}
+	}
+
+	if (error)
+		IR_dprintk(1, "Error parsing value of %s", tmp);
+	else
+		ret = dev->s_wakeup_scancodes(dev, &scancode_list, 1);
+
+	list_for_each_entry_safe(scancode, next, &scancode_list, list_item) {
+		list_del(&scancode->list_item);
+		kfree(scancode);
+	}
+
+	mutex_unlock(&dev->lock);
+	if (ret < 0)
+		return ret;
+
+	return error ? -EINVAL : len;
+}
+
 static void rc_dev_release(struct device *device)
 {
 }
@@ -1019,6 +1132,15 @@ static struct device_type rc_dev_type = {
 	.uevent		= rc_dev_uevent,
 };
 
+static struct device_attribute dev_attr_wakeup_scancodes = {
+	.attr	= {
+		.name = "wakeup_scancodes",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.show = show_wakeup_scancodes,
+	.store = store_wakeup_scancodes,
+};
+
 struct rc_dev *rc_allocate_device(void)
 {
 	struct rc_dev *dev;
@@ -1175,6 +1297,13 @@ int rc_register_device(struct rc_dev *dev)
 		dev->enabled_protocols = rc_type;
 	}
 
+	/* Create sysfs entry only if device has wake scancode support */
+	if (dev->s_wakeup_scancodes) {
+		rc = device_create_file(&dev->dev, &dev_attr_wakeup_scancodes);
+		if (rc < 0)
+			goto out_raw;
+	}
+
 	mutex_unlock(&dev->lock);
 
 	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode %s)\n",
-- 
1.8.3.2

