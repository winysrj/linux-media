Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0H3Iwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 04:52:45 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2/7] IR: make sure we register input device when it safe to do so.
Date: Mon, 30 Aug 2010 11:52:22 +0300
Message-Id: <1283158348-7429-3-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

As soon as input device is registered, it might be accessed (and it is)
This can trigger hardware interrupts for example that in turn
can access not yet initialized ir->raw.
Can be reproduced by holding down a remote button and reloading the module.
And always crashes the systems where hardware decides to send and interrupt
right at the moment it is enabled.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h |    1 +
 drivers/media/IR/ir-keytable.c  |    2 ++
 drivers/media/IR/ir-sysfs.c     |   27 +++++++++++++++++----------
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 761e7f4..5d7e08f 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -116,6 +116,7 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
  * Routines from ir-sysfs.c - Meant to be called only internally inside
  * ir-core
  */
+int ir_register_input(struct input_dev *input_dev);
 
 int ir_register_class(struct input_dev *input_dev);
 void ir_unregister_class(struct input_dev *input_dev);
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 7e82a9d..3f0dd80 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -505,6 +505,8 @@ int __ir_input_register(struct input_dev *input_dev,
 				goto out_event;
 		}
 
+	rc = ir_register_input(input_dev);
+
 	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
 		   driver_name, rc_tab->name,
 		   (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_IR_RAW) ?
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 96dafc4..c0075f1 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -251,8 +251,6 @@ static struct device_type rc_dev_type = {
  */
 int ir_register_class(struct input_dev *input_dev)
 {
-	int rc;
-	const char *path;
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
 	int devno = find_first_zero_bit(&ir_core_dev_number,
 					IRRCV_NUM_DEVICES);
@@ -261,17 +259,28 @@ int ir_register_class(struct input_dev *input_dev)
 		return devno;
 
 	ir_dev->dev.type = &rc_dev_type;
+	ir_dev->devno = devno;
 
 	ir_dev->dev.class = &ir_input_class;
 	ir_dev->dev.parent = input_dev->dev.parent;
+	input_dev->dev.parent = &ir_dev->dev;
 	dev_set_name(&ir_dev->dev, "rc%d", devno);
 	dev_set_drvdata(&ir_dev->dev, ir_dev);
-	rc = device_register(&ir_dev->dev);
-	if (rc)
-		return rc;
+	return  device_register(&ir_dev->dev);
+};
+
+/**
+ * ir_register_input - registers ir input device with input subsystem
+ * @input_dev:	the struct input_dev descriptor of the device
+ */
+
+int ir_register_input(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int rc;
+	const char *path;
 
 
-	input_dev->dev.parent = &ir_dev->dev;
 	rc = input_register_device(input_dev);
 	if (rc < 0) {
 		device_del(&ir_dev->dev);
@@ -287,11 +296,9 @@ int ir_register_class(struct input_dev *input_dev)
 		path ? path : "N/A");
 	kfree(path);
 
-	ir_dev->devno = devno;
-	set_bit(devno, &ir_core_dev_number);
-
+	set_bit(ir_dev->devno, &ir_core_dev_number);
 	return 0;
-};
+}
 
 /**
  * ir_unregister_class() - removes the sysfs for sysfs for
-- 
1.7.0.4

