Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49863 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754014AbcKBKku (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 06:40:50 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 3/6] [media] rc-core: add support for IR raw transmitters
Date: Wed, 02 Nov 2016 19:40:07 +0900
Message-id: <20161102104010.26959-4-andi.shyti@samsung.com>
In-reply-to: <20161102104010.26959-1-andi.shyti@samsung.com>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IR raw transmitter driver type is specified in the enum
rc_driver_type as RC_DRIVER_IR_RAW_TX which includes all those
devices that transmit raw stream of bit to a receiver.

The data are provided by userspace applications, therefore they
don't need any input device allocation, but still they need to be
registered as raw devices.

Suggested-by: Sean Young <sean@mess.org>
Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/rc-main.c | 42 +++++++++++++++++++++++++-----------------
 include/media/rc-core.h    |  9 ++++++---
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7ab1b32..0d2f440 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1363,20 +1363,24 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 	if (!dev)
 		return NULL;
 
-	dev->input_dev = input_allocate_device();
-	if (!dev->input_dev) {
-		kfree(dev);
-		return NULL;
-	}
+	if (type != RC_DRIVER_IR_RAW_TX) {
+		dev->input_dev = input_allocate_device();
+		if (!dev->input_dev) {
+			kfree(dev);
+			return NULL;
+		}
+
+		dev->input_dev->getkeycode = ir_getkeycode;
+		dev->input_dev->setkeycode = ir_setkeycode;
+		input_set_drvdata(dev->input_dev, dev);
 
-	dev->input_dev->getkeycode = ir_getkeycode;
-	dev->input_dev->setkeycode = ir_setkeycode;
-	input_set_drvdata(dev->input_dev, dev);
+		setup_timer(&dev->timer_keyup, ir_timer_keyup,
+						(unsigned long)dev);
 
-	spin_lock_init(&dev->rc_map.lock);
-	spin_lock_init(&dev->keylock);
+		spin_lock_init(&dev->rc_map.lock);
+		spin_lock_init(&dev->keylock);
+	}
 	mutex_init(&dev->lock);
-	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
 
 	dev->dev.type = &rc_dev_type;
 	dev->dev.class = &rc_class;
@@ -1476,7 +1480,7 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 
 static void rc_free_rx_device(struct rc_dev *dev)
 {
-	if (!dev)
+	if (!dev || dev->driver_type == RC_DRIVER_IR_RAW_TX)
 		return;
 
 	ir_free_table(&dev->rc_map);
@@ -1506,7 +1510,8 @@ int rc_register_device(struct rc_dev *dev)
 	atomic_set(&dev->initialized, 0);
 
 	dev->dev.groups = dev->sysfs_groups;
-	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
 	if (dev->s_filter)
 		dev->sysfs_groups[attr++] = &rc_dev_filter_attr_grp;
 	if (dev->s_wakeup_filter)
@@ -1524,11 +1529,14 @@ int rc_register_device(struct rc_dev *dev)
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	rc = rc_setup_rx_device(dev);
-	if (rc)
-		goto out_dev;
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		rc = rc_setup_rx_device(dev);
+		if (rc)
+			goto out_dev;
+	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+	if (dev->driver_type == RC_DRIVER_IR_RAW ||
+				dev->driver_type == RC_DRIVER_IR_RAW_TX) {
 		if (!raw_init) {
 			request_module_nowait("ir-lirc-codec");
 			raw_init = true;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f8ca557..b6f7419 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -32,13 +32,16 @@ do {								\
 /**
  * enum rc_driver_type - type of the RC output
  *
- * @RC_DRIVER_SCANCODE:	Driver or hardware generates a scancode
- * @RC_DRIVER_IR_RAW:	Driver or hardware generates pulse/space sequences.
- *			It needs a Infra-Red pulse/space decoder
+ * @RC_DRIVER_SCANCODE:	 Driver or hardware generates a scancode
+ * @RC_DRIVER_IR_RAW:	 Driver or hardware generates pulse/space sequences.
+ *			 It needs a Infra-Red pulse/space decoder
+ * @RC_DRIVER_IR_RAW_TX: Device transmitter only,
+			 driver requires pulse/space data sequence.
  */
 enum rc_driver_type {
 	RC_DRIVER_SCANCODE = 0,
 	RC_DRIVER_IR_RAW,
+	RC_DRIVER_IR_RAW_TX,
 };
 
 /**
-- 
2.10.1

