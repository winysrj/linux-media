Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44282 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab2EWJy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:57 -0400
Subject: [PATCH 06/43] rc-core: rename ir_input_class to rc_class
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:32 +0200
Message-ID: <20120523094232.14474.18105.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
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
index 4adaa87..0e50a84 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -815,14 +815,14 @@ static void ir_close(struct input_dev *idev)
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
@@ -1112,7 +1112,7 @@ struct rc_dev *rc_allocate_device(void)
 	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
 
 	dev->dev.type = &rc_dev_type;
-	dev->dev.class = &ir_input_class;
+	dev->dev.class = &rc_class;
 	device_initialize(&dev->dev);
 
 	__module_get(THIS_MODULE);
@@ -1285,7 +1285,7 @@ EXPORT_SYMBOL_GPL(rc_unregister_device);
 
 static int __init rc_core_init(void)
 {
-	int rc = class_register(&ir_input_class);
+	int rc = class_register(&rc_class);
 	if (rc) {
 		printk(KERN_ERR "rc_core: unable to register rc class\n");
 		return rc;
@@ -1298,7 +1298,7 @@ static int __init rc_core_init(void)
 
 static void __exit rc_core_exit(void)
 {
-	class_unregister(&ir_input_class);
+	class_unregister(&rc_class);
 	rc_map_unregister(&empty_map);
 }
 

