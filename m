Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0CLEcj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 23:32:39 -0500
Message-ID: <4B99C3D7.7000301@redhat.com>
Date: Fri, 12 Mar 2010 01:32:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
References: <4B99104B.3090307@redhat.com> <20100311175214.GB7467@core.coreip.homeip.net>
In-Reply-To: <20100311175214.GB7467@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> Hi Mauro,
> 
> On Thu, Mar 11, 2010 at 12:46:19PM -0300, Mauro Carvalho Chehab wrote:
>> In order to allow userspace programs to autoload an IR table, a link is
>> needed to point to the corresponding input device.
>>
>> $ tree /sys/class/irrcv/irrcv0
>> /sys/class/irrcv/irrcv0
>> |-- current_protocol
>> |-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
>> |-- power
>> |   `-- wakeup
>> |-- subsystem -> ../../../../class/irrcv
>> `-- uevent
>>
>> It is now easy to associate an irrcv device with the corresponding
>> device node, at the input interface.
>>
> 
> I guess the question is why don't you make input device a child of your
> irrcvX device? Then I believe driver core will link them properly. It
> will also ensure proper power management hierarchy.
> 
> That probably will require you changing from class_dev into device but
> that's the direction kernel is going to anyway.

Done, see enclosed. It is now using class_register/device_register. The
newly created device for irrcv is used as the parent for input_dev->dev.

The resulting code looked cleaner after the change ;)

Cheers,
Mauro

---

V4L/DVB: ir: use a real device instead of a virtual class
    
Change the ir-sysfs approach to create irrcv0 as a device, instead of
using class_dev. Also, change the way input is registered, in order
to make its parent to be the irrcv device.

Due to this change, now the event device is created under
/sys/class/ir/irrcv class:

/sys/class/irrcv/irrcv0/
|-- current_protocol
|-- device -> ../../../1-3
|-- input9
|   |-- capabilities
|   |   |-- abs
...

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 0903f53..c9c0a54 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -448,22 +448,15 @@ int ir_input_register(struct input_dev *input_dev,
 	input_dev->setkeycode = ir_setkeycode;
 	input_set_drvdata(input_dev, ir_dev);
 
-	rc = input_register_device(input_dev);
-	if (rc < 0)
-		goto err;
-
 	rc = ir_register_class(input_dev);
-	if (rc < 0) {
-		input_unregister_device(input_dev);
+	if (rc < 0)
 		goto err;
-	}
 
 	return 0;
 
 err:
 	kfree(rc_tab->scan);
 	kfree(ir_dev);
-	input_set_drvdata(input_dev, NULL);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ir_input_register);
@@ -492,7 +485,6 @@ void ir_input_unregister(struct input_dev *dev)
 	ir_unregister_class(dev);
 
 	kfree(ir_dev);
-	input_unregister_device(dev);
 }
 EXPORT_SYMBOL_GPL(ir_input_unregister);
 
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index bf5fbcd..1bb011a 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -22,7 +22,15 @@
 static unsigned long ir_core_dev_number;
 
 /* class for /sys/class/irrcv */
-static struct class *ir_input_class;
+static char *ir_devnode(struct device *dev, mode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "irrcv/%s", dev_name(dev));
+}
+
+struct class ir_input_class = {
+	.name		= "irrcv",
+	.devnode	= ir_devnode,
+};
 
 /**
  * show_protocol() - shows the current IR protocol
@@ -128,6 +136,20 @@ static struct attribute *ir_dev_attrs[] = {
 	NULL,
 };
 
+static struct attribute_group ir_dev_attr_grp = {
+	.attrs	=ir_dev_attrs,
+};
+
+static const struct attribute_group *ir_dev_attr_groups[] = {
+	&ir_dev_attr_grp,
+	NULL
+};
+
+static struct device_type ir_dev_type = {
+	.groups		= ir_dev_attr_groups,
+};
+
+
 /**
  * ir_register_class() - creates the sysfs for /sys/class/irrcv/irrcv?
  * @input_dev:	the struct input_dev descriptor of the device
@@ -137,7 +159,7 @@ static struct attribute *ir_dev_attrs[] = {
 int ir_register_class(struct input_dev *input_dev)
 {
 	int rc;
-	struct kobject *kobj;
+	const char *path;
 
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	int devno = find_first_zero_bit(&ir_core_dev_number,
@@ -146,19 +168,31 @@ int ir_register_class(struct input_dev *input_dev)
 	if (unlikely(devno < 0))
 		return devno;
 
-	ir_dev->attr.attrs = ir_dev_attrs;
-	ir_dev->class_dev = device_create(ir_input_class, NULL,
-					  input_dev->dev.devt, ir_dev,
-					  "irrcv%d", devno);
-	kobj = &ir_dev->class_dev->kobj;
-
-	printk(KERN_WARNING "Creating IR device %s\n", kobject_name(kobj));
-	rc = sysfs_create_group(kobj, &ir_dev->attr);
-	if (unlikely(rc < 0)) {
-		device_destroy(ir_input_class, input_dev->dev.devt);
-		return -ENOMEM;
+	ir_dev->dev.type = &ir_dev_type;
+	ir_dev->dev.class = &ir_input_class;
+	ir_dev->dev.parent = input_dev->dev.parent;
+	dev_set_name(&ir_dev->dev, "irrcv%d", devno);
+	rc = device_register(&ir_dev->dev);
+	if (rc)
+		return rc;
+
+
+	input_dev->dev.parent = &ir_dev->dev;
+	rc = input_register_device(input_dev);
+	if (rc < 0) {
+		device_del(&ir_dev->dev);
+		return rc;
 	}
 
+	__module_get(THIS_MODULE);
+
+	path = kobject_get_path(&input_dev->dev.kobj, GFP_KERNEL);
+	printk(KERN_INFO "%s: %s associated with sysfs %s\n",
+		dev_name(&ir_dev->dev),
+		input_dev->name ? input_dev->name : "Unspecified device",
+		path ? path : "N/A");
+	kfree(path);
+
 	ir_dev->devno = devno;
 	set_bit(devno, &ir_core_dev_number);
 
@@ -175,16 +209,12 @@ int ir_register_class(struct input_dev *input_dev)
 void ir_unregister_class(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct kobject *kobj;
 
 	clear_bit(ir_dev->devno, &ir_core_dev_number);
+	input_unregister_device(input_dev);
+	device_del(&ir_dev->dev);
 
-	kobj = &ir_dev->class_dev->kobj;
-
-	sysfs_remove_group(kobj, &ir_dev->attr);
-	device_destroy(ir_input_class, input_dev->dev.devt);
-
-	kfree(ir_dev->attr.name);
+	module_put(THIS_MODULE);
 }
 
 /*
@@ -193,10 +223,10 @@ void ir_unregister_class(struct input_dev *input_dev)
 
 static int __init ir_core_init(void)
 {
-	ir_input_class = class_create(THIS_MODULE, "irrcv");
-	if (IS_ERR(ir_input_class)) {
+	int rc = class_register(&ir_input_class);
+	if (rc) {
 		printk(KERN_ERR "ir_core: unable to register irrcv class\n");
-		return PTR_ERR(ir_input_class);
+		return rc;
 	}
 
 	return 0;
@@ -204,7 +234,7 @@ static int __init ir_core_init(void)
 
 static void __exit ir_core_exit(void)
 {
-	class_destroy(ir_input_class);
+	class_unregister(&ir_input_class);
 }
 
 module_init(ir_core_init);
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 61c223b..ce9f347 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -47,11 +47,9 @@ struct ir_dev_props {
 
 
 struct ir_input_dev {
-	struct input_dev		*dev;		/* Input device*/
+	struct device			dev;		/* device */
 	struct ir_scancode_table	rc_tab;		/* scan/key table */
 	unsigned long			devno;		/* device number */
-	struct attribute_group		attr;		/* IR attributes */
-	struct device			*class_dev;	/* virtual class dev */
 	const struct ir_dev_props	*props;		/* Device properties */
 };
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
