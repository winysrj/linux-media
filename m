Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33380 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbcBGUOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2016 15:14:24 -0500
Received: by mail-wm0-f66.google.com with SMTP id r129so12481421wmr.0
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2016 12:14:23 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/3] media: rc: expose most recent raw packet via sysfs
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56B7A592.9060700@gmail.com>
Date: Sun, 7 Feb 2016 21:14:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces a binary read-only sysfs attribute last_raw_packet
to expose the most recent raw packet to userspace.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 include/media/rc-core.h    |  2 +-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1042fa3..1b1ae6d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1246,6 +1246,47 @@ unlock:
 	return (ret < 0) ? ret : len;
 }
 
+/**
+ * last_raw_packet_read() - shows the most recent packet of raw bytes
+ * This is a binary attribute.
+ *
+ * This routine is a callback routine to read the most recent packet of
+ * raw bytes received.
+ * It is triggered by reading /sys/class/rc/rc?/last_raw_packet.
+ * Most recent means up to BUF_SYSFS_LRP_SZ bytes after the last break
+ * of at least RESTART_SYSFS_LRP_MS milliseconds.
+ *
+ * Primary use is assembling a wakeup sequence for chips supporting this
+ * feature (e.g. nuvoton-cir). Apart from that it can be used for
+ * debugging purposes.
+ */
+static ssize_t last_raw_packet_read(struct file *fp, struct kobject *kobj,
+				    struct bin_attribute *attr, char *buf,
+				    loff_t off, size_t count)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct rc_dev *rc_dev = to_rc_dev(dev);
+	unsigned long flags;
+	size_t cnt;
+
+	if (!rc_dev->raw)
+		return 0;
+
+	spin_lock_irqsave(&rc_dev->raw->lock, flags);
+
+	if (off >= rc_dev->raw->buf_sysfs_lrp_cnt) {
+		spin_unlock_irqrestore(&rc_dev->raw->lock, flags);
+		return 0;
+	}
+
+	cnt = min_t(size_t, count, rc_dev->raw->buf_sysfs_lrp_cnt - off);
+	memcpy(buf, rc_dev->raw->buf_sysfs_lrp + off, cnt);
+
+	spin_unlock_irqrestore(&rc_dev->raw->lock, flags);
+
+	return cnt;
+}
+
 static void rc_dev_release(struct device *device)
 {
 }
@@ -1284,6 +1325,7 @@ static RC_FILTER_ATTR(wakeup_filter, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_WAKEUP, false);
 static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
+static BIN_ATTR_RO(last_raw_packet, BUF_SYSFS_LRP_SZ);
 
 static struct attribute *rc_dev_protocol_attrs[] = {
 	&dev_attr_protocols.attr.attr,
@@ -1323,6 +1365,15 @@ static struct attribute_group rc_dev_wakeup_filter_attr_grp = {
 	.attrs	= rc_dev_wakeup_filter_attrs,
 };
 
+static struct bin_attribute *rc_dev_raw_lrp_attrs[] = {
+	&bin_attr_last_raw_packet,
+	NULL,
+};
+
+static struct attribute_group rc_dev_raw_lrp_attr_grp = {
+	.bin_attrs = rc_dev_raw_lrp_attrs,
+};
+
 static struct device_type rc_dev_type = {
 	.release	= rc_dev_release,
 	.uevent		= rc_dev_uevent,
@@ -1417,6 +1468,8 @@ int rc_register_device(struct rc_dev *dev)
 		dev->sysfs_groups[attr++] = &rc_dev_wakeup_filter_attr_grp;
 	if (dev->change_wakeup_protocol)
 		dev->sysfs_groups[attr++] = &rc_dev_wakeup_protocol_attr_grp;
+	if (dev->enable_sysfs_lrp)
+		dev->sysfs_groups[attr++] = &rc_dev_raw_lrp_attr_grp;
 	dev->sysfs_groups[attr++] = NULL;
 
 	/*
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 9542891..e2d89ea 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -122,7 +122,7 @@ enum rc_filter_type {
  */
 struct rc_dev {
 	struct device			dev;
-	const struct attribute_group	*sysfs_groups[5];
+	const struct attribute_group	*sysfs_groups[6];
 	const char			*input_name;
 	const char			*input_phys;
 	struct input_id			input_id;
-- 
2.7.0

