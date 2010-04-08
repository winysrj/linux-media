Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933541Ab0DHThm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 15:37:42 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/8] V4L/DVB: rename sysfs remote controller devices from
 rcrcv to rc
Message-ID: <20100408163717.1e55c862@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: David Härdeman <david@hardeman.nu>

When the remote controller class is anyway being renamed from ir to rc
this would be a good time to also rename the devices from rcrcvX to rcX.

I know we haven't reached any agreement on whether transmission will
eventually be handled by the same device, but this change will at
least make the device name non-receive-specific which will make it
possible in the future (and if a different approach is finally
agreed upon, the device name still works).

Signed-off-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 0b05c7b..e177140 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -39,7 +39,7 @@ static struct class ir_input_class = {
  * @buf:	a pointer to the output buffer
  *
  * This routine is a callback routine for input read the IR protocol type.
- * it is trigged by reading /sys/class/rc/rcrcv?/current_protocol.
+ * it is trigged by reading /sys/class/rc/rc?/current_protocol.
  * It returns the protocol name, as understood by the driver.
  */
 static ssize_t show_protocol(struct device *d,
@@ -74,7 +74,7 @@ static ssize_t show_protocol(struct device *d,
  * @len:	length of the input buffer
  *
  * This routine is a callback routine for changing the IR protocol type.
- * it is trigged by reading /sys/class/rc/rcrcv?/current_protocol.
+ * it is trigged by reading /sys/class/rc/rc?/current_protocol.
  * It changes the IR the protocol name, if the IR type is recognized
  * by the driver.
  * If an unknown protocol name is used, returns -EINVAL.
@@ -171,7 +171,7 @@ static struct device_type ir_dev_type = {
 };
 
 /**
- * ir_register_class() - creates the sysfs for /sys/class/rc/rcrcv?
+ * ir_register_class() - creates the sysfs for /sys/class/rc/rc?
  * @input_dev:	the struct input_dev descriptor of the device
  *
  * This routine is used to register the syfs code for IR class
@@ -191,7 +191,7 @@ int ir_register_class(struct input_dev *input_dev)
 	ir_dev->dev.type = &ir_dev_type;
 	ir_dev->dev.class = &ir_input_class;
 	ir_dev->dev.parent = input_dev->dev.parent;
-	dev_set_name(&ir_dev->dev, "rcrcv%d", devno);
+	dev_set_name(&ir_dev->dev, "rc%d", devno);
 	dev_set_drvdata(&ir_dev->dev, ir_dev);
 	rc = device_register(&ir_dev->dev);
 	if (rc)
@@ -222,7 +222,7 @@ int ir_register_class(struct input_dev *input_dev)
 
 /**
  * ir_unregister_class() - removes the sysfs for sysfs for
- *			   /sys/class/rc/rcrcv?
+ *			   /sys/class/rc/rc?
  * @input_dev:	the struct input_dev descriptor of the device
  *
  * This routine is used to unregister the syfs code for IR class
-- 
1.6.6.1


