Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:9590 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0E0CbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 22:31:17 -0400
Received: by fg-out-1718.google.com with SMTP id d23so3109613fga.1
        for <linux-media@vger.kernel.org>; Wed, 26 May 2010 19:31:16 -0700 (PDT)
To: linux-media@vger.kernel.org
Subject: [PATCH] Bug fix: make IR work again for dm1105.
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Thu, 27 May 2010 05:31:21 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270531.21919.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes IR to work again for dm1105 and, possibly, others.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
diff --git a/linux/drivers/media/IR/ir-keytable.c b/linux/drivers/media/IR/ir-keytable.c
--- a/linux/drivers/media/IR/ir-keytable.c
+++ b/linux/drivers/media/IR/ir-keytable.c
@@ -491,11 +491,12 @@
 	if (rc < 0)
 		goto out_table;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
-		rc = ir_raw_event_register(input_dev);
-		if (rc < 0)
-			goto out_event;
-	}
+	if (ir_dev->props)
+		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
+			rc = ir_raw_event_register(input_dev);
+			if (rc < 0)
+				goto out_event;
+		}
 
 	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
 		   driver_name, rc_tab->name);
@@ -531,8 +532,10 @@
 	IR_dprintk(1, "Freed keycode table\n");
 
 	del_timer_sync(&ir_dev->timer_keyup);
-	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_event_unregister(input_dev);
+	if (ir_dev->props)
+		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
+			ir_raw_event_unregister(input_dev);
+
 	rc_tab = &ir_dev->rc_tab;
 	rc_tab->size = 0;
 	kfree(rc_tab->scan);
diff --git a/linux/drivers/media/IR/ir-sysfs.c b/linux/drivers/media/IR/ir-sysfs.c
--- a/linux/drivers/media/IR/ir-sysfs.c
+++ b/linux/drivers/media/IR/ir-sysfs.c
@@ -222,9 +222,10 @@
 	if (unlikely(devno < 0))
 		return devno;
 
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		ir_dev->dev.type = &rc_dev_type;
-	else
+	if (ir_dev->props) {
+		if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+			ir_dev->dev.type = &rc_dev_type;
+	} else
 		ir_dev->dev.type = &ir_raw_dev_type;
 
 	ir_dev->dev.class = &ir_input_class;
diff --git a/linux/drivers/media/dvb/dm1105/dm1105.c b/linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c
@@ -616,7 +616,7 @@
 int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
 	struct input_dev *input_dev;
-	char *ir_codes = NULL;
+	char *ir_codes = RC_MAP_DM1105_NEC;
 	int err = -ENOMEM;
 
 	input_dev = input_allocate_device();
--

