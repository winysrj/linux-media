Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109Ab0CKPq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 10:46:28 -0500
Message-ID: <4B99104B.3090307@redhat.com>
Date: Thu, 11 Mar 2010 12:46:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org
Subject: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to allow userspace programs to autoload an IR table, a link is
needed to point to the corresponding input device.

$ tree /sys/class/irrcv/irrcv0
/sys/class/irrcv/irrcv0
|-- current_protocol
|-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
|-- power
|   `-- wakeup
|-- subsystem -> ../../../../class/irrcv
`-- uevent

It is now easy to associate an irrcv device with the corresponding
device node, at the input interface.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index bf5fbcd..7de32e7 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -138,6 +138,7 @@ int ir_register_class(struct input_dev *input_dev)
 {
 	int rc;
 	struct kobject *kobj;
+	const char *path;
 
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	int devno = find_first_zero_bit(&ir_core_dev_number,
@@ -152,13 +153,26 @@ int ir_register_class(struct input_dev *input_dev)
 					  "irrcv%d", devno);
 	kobj = &ir_dev->class_dev->kobj;
 
-	printk(KERN_WARNING "Creating IR device %s\n", kobject_name(kobj));
 	rc = sysfs_create_group(kobj, &ir_dev->attr);
 	if (unlikely(rc < 0)) {
 		device_destroy(ir_input_class, input_dev->dev.devt);
 		return -ENOMEM;
 	}
 
+	rc = sysfs_create_link(kobj, &input_dev->dev.kobj, "input");
+	if (unlikely(rc < 0)) {
+		sysfs_remove_group(kobj, &ir_dev->attr);
+		device_destroy(ir_input_class, input_dev->dev.devt);
+		return -ENOMEM;
+	}
+
+	path = kobject_get_path(&input_dev->dev.kobj, GFP_KERNEL);
+	printk(KERN_INFO "%s: %s associated with sysfs %s\n",
+		kobject_name(kobj),
+		input_dev->name ? input_dev->name : "Unspecified device",
+		path ? path : "N/A");
+	kfree(path);
+
 	ir_dev->devno = devno;
 	set_bit(devno, &ir_core_dev_number);
 
@@ -181,6 +195,8 @@ void ir_unregister_class(struct input_dev *input_dev)
 
 	kobj = &ir_dev->class_dev->kobj;
 
+	sysfs_remove_link(kobj, "input");
+
 	sysfs_remove_group(kobj, &ir_dev->attr);
 	device_destroy(ir_input_class, input_dev->dev.devt);
 
-- 
1.6.6.1

