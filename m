Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54723 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3CFUwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 15:52:22 -0500
Subject: [PATCH 2/3] rc-core: rename ir_input_class to rc_class
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, sean@mess.org
Date: Wed, 06 Mar 2013 21:52:10 +0100
Message-ID: <20130306205210.12635.56184.stgit@zeus.hardeman.nu>
In-Reply-To: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
References: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The name is already misleading and will be more so in the future as the
connection to the input subsystem is obscured away further.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3090b40..c56650c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -715,14 +715,14 @@ static void ir_close(struct input_dev *idev)
 }
 
 /* class for /sys/class/rc */
-static char *ir_devnode(struct device *dev, umode_t *mode)
+static char *rc_devnode(struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "rc/%s", dev_name(dev));
 }
 
-static struct class ir_input_class = {
+static struct class rc_class = {
 	.name		= "rc",
-	.devnode	= ir_devnode,
+	.devnode	= rc_devnode,
 };
 
 /*
@@ -1004,7 +1004,7 @@ struct rc_dev *rc_allocate_device(void)
 	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
 
 	dev->dev.type = &rc_dev_type;
-	dev->dev.class = &ir_input_class;
+	dev->dev.class = &rc_class;
 	device_initialize(&dev->dev);
 
 	__module_get(THIS_MODULE);
@@ -1178,7 +1178,7 @@ EXPORT_SYMBOL_GPL(rc_unregister_device);
 
 static int __init rc_core_init(void)
 {
-	int rc = class_register(&ir_input_class);
+	int rc = class_register(&rc_class);
 	if (rc) {
 		printk(KERN_ERR "rc_core: unable to register rc class\n");
 		return rc;
@@ -1191,7 +1191,7 @@ static int __init rc_core_init(void)
 
 static void __exit rc_core_exit(void)
 {
-	class_unregister(&ir_input_class);
+	class_unregister(&rc_class);
 	rc_map_unregister(&empty_map);
 }
 

