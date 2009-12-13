Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45514 "HELO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752911AbZLMMPh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 07:15:37 -0500
Message-ID: <4B24DABA.9040007@redhat.com>
Date: Sun, 13 Dec 2009 10:14:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Jon Smirl <jonsmirl@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc> <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com> <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain> <20091207184153.GD998@core.coreip.homeip.net>
In-Reply-To: <20091207184153.GD998@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Sun, Dec 06, 2009 at 09:34:26PM +0100, Krzysztof Halasa wrote:
>> Jon Smirl <jonsmirl@gmail.com> writes:
>>
>>>> Once again: how about agreement about the LIRC interface
>>>> (kernel-userspace) and merging the actual LIRC code first? In-kernel
>>>> decoding can wait a bit, it doesn't change any kernel-user interface.
>>> I'd like to see a semi-complete design for an in-kernel IR system
>>> before anything is merged from any source.
>> This is a way to nowhere, there is no logical dependency between LIRC
>> and input layer IR.
>>
>> There is only one thing which needs attention before/when merging LIRC:
>> the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
>> actually, making a correct IR core design without the LIRC merged can be
>> only harder.
> 
> This sounds like "merge first, think later"...
> 
> The question is why we need to merge lirc interface right now, before we
> agreed on the sybsystem architecture? Noone _in kernel_ user lirc-dev
> yet and, looking at the way things are shaping, no drivers will be
> _directly_ using it after it is complete. So, even if we merge it right
> away, the code will have to be restructured and reworked. Unfortunately,
> just merging what Jarod posted, will introduce sysfs hierarchy which
> is userspace interface as well (although we not as good maintaining it
> at times) and will add more constraints on us.
> 
> That is why I think we should go the other way around - introduce the
> core which receivers could plug into and decoder framework and once it
> is ready register lirc-dev as one of the available decoders.
> 

I've committed already some IR restruct code on my linux-next -git tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git

The code there basically moves the input/evdev registering code and 
scancode/keycode management code into a separate ir-core module.

To make my life easy, I've moved the code temporarily into drivers/media/IR.
This way, it helps me to move V4L specific code outside ir-core and to later
use it for DVB. After having it done, probably the better is to move it to
be under /drivers or /drivers/input.

The enclosed patch just adds a skeleton for the new sysfs class for remote
controllers and registers an yet unused ir_protocol attribute, creating this
tree:

/sys/class/irrcv/
|-- irrcv0
|   |-- ir_protocol
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../irrcv
|   `-- uevent
`-- irrcv1
    |-- ir_protocol
    |-- power
    |   `-- wakeup
    |-- subsystem -> ../../irrcv
    `-- uevent

While writing the code, it occurred to me that calling it as "IR" is not the better way,
since there's nothing on the code that is related to infra-red, but, instead, is
is related to remote controller.

So, if it is ok for everybudy, IMO, we should use, instead "rc" meaning remote controller,
naming the core module as "rc-core", putting it into drivers/rc.

Also, since the same rc chip can have a receiver and a transmitter, maybe we can create the
class as:
	/sys/class/rc
		rcrcv0/
		rcrcv1/
		...
		rctx0/
		rctx1/
		...

Comments?


---
 linux/drivers/media/IR/Makefile      |    2 
 linux/drivers/media/IR/ir-keytable.c |   17 +++++-
 linux/drivers/media/IR/ir-sysfs.c    |   94 +++++++++++++++++++++++++++++++++++
 linux/include/media/ir-core.h        |   12 +++-
 4 files changed, 119 insertions(+), 6 deletions(-)

--- master.orig/linux/drivers/media/IR/Makefile
+++ master/linux/drivers/media/IR/Makefile
@@ -1,5 +1,5 @@
 ir-common-objs  := ir-functions.o ir-keymaps.o
-ir-core-objs	:= ir-keytable.o
+ir-core-objs	:= ir-keytable.o ir-sysfs.o
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
--- master.orig/linux/drivers/media/IR/ir-keytable.c
+++ master/linux/drivers/media/IR/ir-keytable.c
@@ -448,12 +448,21 @@ int ir_input_register(struct input_dev *
 	input_set_drvdata(input_dev, ir_dev);
 
 	rc = input_register_device(input_dev);
+	if (rc < 0)
+		goto err;
+
+	rc = ir_register_class(input_dev);
 	if (rc < 0) {
-		kfree(rc_tab->scan);
-		kfree(ir_dev);
-		input_set_drvdata(input_dev, NULL);
+		input_unregister_device(input_dev);
+		goto err;
 	}
 
+	return 0;
+
+err:
+	kfree(rc_tab->scan);
+	kfree(ir_dev);
+	input_set_drvdata(input_dev, NULL);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ir_input_register);
@@ -473,6 +482,8 @@ void ir_input_unregister(struct input_de
 	kfree(rc_tab->scan);
 	rc_tab->scan = NULL;
 
+	ir_unregister_class(dev);
+
 	kfree(ir_dev);
 	input_unregister_device(dev);
 }
--- /dev/null
+++ master/linux/drivers/media/IR/ir-sysfs.c
@@ -0,0 +1,94 @@
+/* ir-register.c - handle IR scancode->keycode tables
+ *
+ * Copyright (C) 2009 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/input.h>
+#include <linux/device.h>
+#include <media/ir-core.h>
+
+#define IRRCV_NUM_DEVICES	256
+
+unsigned long ir_core_dev_number;
+
+static struct class *ir_input_class;
+
+static DEVICE_ATTR(ir_protocol, S_IRUGO | S_IWUSR, NULL, NULL);
+
+static struct attribute *ir_dev_attrs[] = {
+	&dev_attr_ir_protocol.attr,
+};
+
+int ir_register_class(struct input_dev *input_dev)
+{
+	int rc;
+	struct kobject *kobj;
+
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int devno = find_first_zero_bit(&ir_core_dev_number,
+				        IRRCV_NUM_DEVICES);
+
+	if (unlikely(devno < 0))
+		return devno;
+
+	ir_dev->attr.attrs = ir_dev_attrs;
+	ir_dev->class_dev = device_create(ir_input_class, NULL,
+					  input_dev->dev.devt, ir_dev,
+					  "irrcv%d", devno);
+	kobj= &ir_dev->class_dev->kobj;
+
+	printk(KERN_WARNING "Creating IR device %s\n", kobject_name(kobj));
+	rc = sysfs_create_group(kobj, &ir_dev->attr);
+	if (unlikely (rc < 0)) {
+		device_destroy(ir_input_class, input_dev->dev.devt);
+		return -ENOMEM;
+	}
+
+	ir_dev->devno = devno;
+	set_bit(devno, &ir_core_dev_number);
+
+	return 0;
+};
+
+void ir_unregister_class(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct kobject *kobj;
+
+	clear_bit(ir_dev->devno, &ir_core_dev_number);
+
+	kobj= &ir_dev->class_dev->kobj;
+
+	sysfs_remove_group(kobj, &ir_dev->attr);
+	device_destroy(ir_input_class, input_dev->dev.devt);
+
+	kfree(ir_dev->attr.name);
+}
+
+static int __init ir_core_init(void)
+{
+	ir_input_class = class_create(THIS_MODULE, "irrcv");
+	if (IS_ERR(ir_input_class)) {
+		printk(KERN_ERR "ir_core: unable to register irrcv class\n");
+		return PTR_ERR(ir_input_class);
+	}
+
+	return 0;
+}
+
+static void __exit ir_core_exit(void)
+{
+	class_destroy(ir_input_class);
+}
+
+module_init(ir_core_init);
+module_exit(ir_core_exit);
--- master.orig/linux/include/media/ir-core.h
+++ master/linux/include/media/ir-core.h
@@ -42,8 +42,11 @@ struct ir_scancode_table {
 };
 
 struct ir_input_dev {
-	struct input_dev		*dev;
-	struct ir_scancode_table	rc_tab;
+	struct input_dev		*dev;		/* Input device*/
+	struct ir_scancode_table	rc_tab;		/* scan/key table */
+	unsigned long			devno;		/* device number */
+	struct attribute_group		attr;		/* IR attributes */
+	struct device			*class_dev;	/* virtual class dev */
 };
 
 /* Routines from ir-keytable.c */
@@ -59,4 +62,9 @@ int ir_input_register(struct input_dev *
 		      struct ir_scancode_table *ir_codes);
 void ir_input_unregister(struct input_dev *input_dev);
 
+/* Routines from ir-sysfs.c */
+
+int ir_register_class(struct input_dev *input_dev);
+void ir_unregister_class(struct input_dev *input_dev);
+
 #endif
