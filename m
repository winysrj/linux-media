Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570Ab0DAR6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:30 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/15] V4L/DVB: ir-core: rename sysfs remote controller
 class from ir to rc
Message-ID: <20100401145631.60b96318@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IR is an alias for Infrared Remote, while RC is an alias for Remote
Controller.

While currently all implementations are with Infrared Remote Controller,
this subsystem is not meant to be used only by IR type of RC's. So,
as discussed on both linux-media and linux-input, the better is to
rename the subsystem as Remote Controller.

While, currently, the only application that uses the /sys/class/irrcv is
ir-keytable application, and its sysfs support works only with the
current linux-next code, it is still possible to change the userspace API
without the risk of breaking applications. So, better to rename this
sooner than later.

Later patches will be needed to rename the files and to move them away
from drivers/media, but this is not a critical issue. So, for now,
let's just change the name of the sysfs class/nodes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 2dbce59..435d83e 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -21,14 +21,14 @@
 /* bit array to represent IR sysfs device number */
 static unsigned long ir_core_dev_number;
 
-/* class for /sys/class/irrcv */
+/* class for /sys/class/rc */
 static char *ir_devnode(struct device *dev, mode_t *mode)
 {
-	return kasprintf(GFP_KERNEL, "irrcv/%s", dev_name(dev));
+	return kasprintf(GFP_KERNEL, "rc/%s", dev_name(dev));
 }
 
 static struct class ir_input_class = {
-	.name		= "irrcv",
+	.name		= "rc",
 	.devnode	= ir_devnode,
 };
 
@@ -39,7 +39,7 @@ static struct class ir_input_class = {
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type.
- * it is trigged by reading /sys/class/irrcv/irrcv?/current_protocol.
+ * it is trigged by reading /sys/class/rc/rcrcv?/current_protocol.
  * It returns the protocol name, as understood by the driver.
  */
 static ssize_t show_protocol(struct device *d,
@@ -74,7 +74,7 @@ static ssize_t show_protocol(struct device *d,
  * @len:	length of the input buffer
  *
  * This routine is a callback routine for changing the IR protocol type.
- * it is trigged by reading /sys/class/irrcv/irrcv?/current_protocol.
+ * it is trigged by reading /sys/class/rc/rcrcv?/current_protocol.
  * It changes the IR the protocol name, if the IR type is recognized
  * by the driver.
  * If an unknown protocol name is used, returns -EINVAL.
@@ -171,7 +171,7 @@ static struct device_type ir_dev_type = {
 };
 
 /**
- * ir_register_class() - creates the sysfs for /sys/class/irrcv/irrcv?
+ * ir_register_class() - creates the sysfs for /sys/class/rc/rcrcv?
  * @input_dev:	the struct input_dev descriptor of the device
  *
  * This routine is used to register the syfs code for IR class
@@ -191,7 +191,7 @@ int ir_register_class(struct input_dev *input_dev)
 	ir_dev->dev.type = &ir_dev_type;
 	ir_dev->dev.class = &ir_input_class;
 	ir_dev->dev.parent = input_dev->dev.parent;
-	dev_set_name(&ir_dev->dev, "irrcv%d", devno);
+	dev_set_name(&ir_dev->dev, "rcrcv%d", devno);
 	dev_set_drvdata(&ir_dev->dev, ir_dev);
 	rc = device_register(&ir_dev->dev);
 	if (rc)
@@ -222,7 +222,7 @@ int ir_register_class(struct input_dev *input_dev)
 
 /**
  * ir_unregister_class() - removes the sysfs for sysfs for
- *			   /sys/class/irrcv/irrcv?
+ *			   /sys/class/rc/rcrcv?
  * @input_dev:	the struct input_dev descriptor of the device
  *
  * This routine is used to unregister the syfs code for IR class
@@ -239,14 +239,14 @@ void ir_unregister_class(struct input_dev *input_dev)
 }
 
 /*
- * Init/exit code for the module. Basically, creates/removes /sys/class/irrcv
+ * Init/exit code for the module. Basically, creates/removes /sys/class/rc
  */
 
 static int __init ir_core_init(void)
 {
 	int rc = class_register(&ir_input_class);
 	if (rc) {
-		printk(KERN_ERR "ir_core: unable to register irrcv class\n");
+		printk(KERN_ERR "ir_core: unable to register rc class\n");
 		return rc;
 	}
 
-- 
1.6.6.1


