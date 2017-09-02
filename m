Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41567 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752297AbdIBLmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:52 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/7] media: rc: if protocols can't be changed, don't be writable
Date: Sat,  2 Sep 2017 12:42:47 +0100
Message-Id: <8c17aeb5970460028478bf25aadf2cf892b01684.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the protocols of an rc device cannot be changed, ensure the sysfs
file is not writable.

This makes it possible to detect this from userspace, so ir-keytable
can deal with case without giving an error.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8781055ee058..cf0c407d8f5b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1487,7 +1487,10 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 /*
  * Static device attribute struct with the sysfs attributes for IR's
  */
-static DEVICE_ATTR(protocols, 0644, show_protocols, store_protocols);
+static struct device_attribute dev_attr_ro_protocols =
+__ATTR(protocols, 0444, show_protocols, store_protocols);
+static struct device_attribute dev_attr_rw_protocols =
+__ATTR(protocols, 0644, show_protocols, NULL);
 static DEVICE_ATTR(wakeup_protocols, 0644, show_wakeup_protocols,
 		   store_wakeup_protocols);
 static RC_FILTER_ATTR(filter, S_IRUGO|S_IWUSR,
@@ -1499,13 +1502,22 @@ static RC_FILTER_ATTR(wakeup_filter, S_IRUGO|S_IWUSR,
 static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 		      show_filter, store_filter, RC_FILTER_WAKEUP, true);
 
-static struct attribute *rc_dev_protocol_attrs[] = {
-	&dev_attr_protocols.attr,
+static struct attribute *rc_dev_rw_protocol_attrs[] = {
+	&dev_attr_rw_protocols.attr,
 	NULL,
 };
 
-static const struct attribute_group rc_dev_protocol_attr_grp = {
-	.attrs	= rc_dev_protocol_attrs,
+static const struct attribute_group rc_dev_rw_protocol_attr_grp = {
+	.attrs	= rc_dev_rw_protocol_attrs,
+};
+
+static struct attribute *rc_dev_ro_protocol_attrs[] = {
+	&dev_attr_ro_protocols.attr,
+	NULL,
+};
+
+static const struct attribute_group rc_dev_ro_protocol_attr_grp = {
+	.attrs	= rc_dev_ro_protocol_attrs,
 };
 
 static struct attribute *rc_dev_filter_attrs[] = {
@@ -1732,8 +1744,10 @@ int rc_register_device(struct rc_dev *dev)
 	dev_set_drvdata(&dev->dev, dev);
 
 	dev->dev.groups = dev->sysfs_groups;
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
-		dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
+	if (dev->driver_type == RC_DRIVER_SCANCODE && !dev->change_protocol)
+		dev->sysfs_groups[attr++] = &rc_dev_ro_protocol_attr_grp;
+	else if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		dev->sysfs_groups[attr++] = &rc_dev_rw_protocol_attr_grp;
 	if (dev->s_filter)
 		dev->sysfs_groups[attr++] = &rc_dev_filter_attr_grp;
 	if (dev->s_wakeup_filter)
-- 
2.13.5
