Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935580Ab0CMAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 19:43:38 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2D0hbtL013533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 19:43:37 -0500
Received: from [10.3.250.145] (vpn-250-145.phx2.redhat.com [10.3.250.145])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2D0hPc2004690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 19:43:34 -0500
Message-Id: <8e45844889fd93e5aea76154464f93e6e354e678.1268440758.git.mchehab@redhat.com>
In-Reply-To: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com>
References: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Fri, 12 Mar 2010 11:50:17 -0300
Subject: [PATCH 3/4] V4L/DVB: ir-core: Export IR name via uevent
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index c9c0a54..31f22ba 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -418,6 +418,7 @@ int ir_input_register(struct input_dev *input_dev,
 
 	spin_lock_init(&ir_dev->rc_tab.lock);
 
+	ir_dev->rc_tab.name = rc_tab->name;
 	ir_dev->rc_tab.size = ir_roundup_tablesize(rc_tab->size);
 	ir_dev->rc_tab.scan = kzalloc(ir_dev->rc_tab.size *
 				    sizeof(struct ir_scancode), GFP_KERNEL);
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 1bb011a..0f4da05 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -125,6 +125,24 @@ static ssize_t store_protocol(struct device *d,
 	return len;
 }
 
+
+#define ADD_HOTPLUG_VAR(fmt, val...)					\
+	do {								\
+		int err = add_uevent_var(env, fmt, val);		\
+		if (err)						\
+			return err;					\
+	} while (0)
+
+static int ir_dev_uevent(struct device *device, struct kobj_uevent_env *env)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
+
+	if (ir_dev->rc_tab.name)
+		ADD_HOTPLUG_VAR("NAME=\"%s\"", ir_dev->rc_tab.name);
+
+	return 0;
+}
+
 /*
  * Static device attribute struct with the sysfs attributes for IR's
  */
@@ -137,7 +155,7 @@ static struct attribute *ir_dev_attrs[] = {
 };
 
 static struct attribute_group ir_dev_attr_grp = {
-	.attrs	=ir_dev_attrs,
+	.attrs	= ir_dev_attrs,
 };
 
 static const struct attribute_group *ir_dev_attr_groups[] = {
@@ -147,9 +165,9 @@ static const struct attribute_group *ir_dev_attr_groups[] = {
 
 static struct device_type ir_dev_type = {
 	.groups		= ir_dev_attr_groups,
+	.uevent		= ir_dev_uevent,
 };
 
-
 /**
  * ir_register_class() - creates the sysfs for /sys/class/irrcv/irrcv?
  * @input_dev:	the struct input_dev descriptor of the device
@@ -172,6 +190,7 @@ int ir_register_class(struct input_dev *input_dev)
 	ir_dev->dev.class = &ir_input_class;
 	ir_dev->dev.parent = input_dev->dev.parent;
 	dev_set_name(&ir_dev->dev, "irrcv%d", devno);
+	dev_set_drvdata(&ir_dev->dev, ir_dev);
 	rc = device_register(&ir_dev->dev);
 	if (rc)
 		return rc;
@@ -186,8 +205,8 @@ int ir_register_class(struct input_dev *input_dev)
 
 	__module_get(THIS_MODULE);
 
-	path = kobject_get_path(&input_dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "%s: %s associated with sysfs %s\n",
+	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
+	printk(KERN_INFO "%s: %s as %s\n",
 		dev_name(&ir_dev->dev),
 		input_dev->name ? input_dev->name : "Unspecified device",
 		path ? path : "N/A");
-- 
1.6.6.1


