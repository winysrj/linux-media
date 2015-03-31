Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33322 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbbCaRtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:49:05 -0400
Received: by lajy8 with SMTP id y8so18612569laj.0
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:49:03 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v3 5/7] rc: rc-core: Add support for encode_wakeup drivers
Date: Tue, 31 Mar 2015 20:48:10 +0300
Message-Id: <1427824092-23163-6-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add support in rc-core for drivers which implement the wakeup scancode
filter by encoding the scancode using the raw IR encoders. This is by
way of rc_dev::encode_wakeup which should be set to true to make the
allowed wakeup protocols the same as the set of raw IR encoders.

As well as updating the sysfs interface to know which wakeup protocols
are allowed for encode_wakeup drivers, also ensure that the IR
decoders/encoders are loaded when an encode_wakeup driver is registered.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---

Notes:
    Changes in v3:
     - Ported to apply against latest media-tree
    
    Changes in v2:
     - New patch

 drivers/media/rc/rc-core-priv.h |  1 +
 drivers/media/rc/rc-ir-raw.c    | 17 +++++++++++++++++
 drivers/media/rc/rc-main.c      |  7 ++++++-
 include/media/rc-core.h         |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 5266ecc7..4b994aa 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -189,6 +189,7 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
  * Routines from rc-raw.c to be used internally and by decoders
  */
 u64 ir_raw_get_allowed_protocols(void);
+u64 ir_raw_get_encode_protocols(void);
 int ir_raw_event_register(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 6c9580e..b9e4645 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -30,6 +30,7 @@ static LIST_HEAD(ir_raw_client_list);
 static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static u64 available_protocols;
+static u64 encode_protocols;
 
 static int ir_raw_event_thread(void *data)
 {
@@ -240,6 +241,18 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
+/* used internally by the sysfs interface */
+u64
+ir_raw_get_encode_protocols(void)
+{
+	u64 protocols;
+
+	mutex_lock(&ir_raw_handler_lock);
+	protocols = encode_protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+	return protocols;
+}
+
 static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 {
 	/* the caller will update dev->enabled_protocols */
@@ -450,6 +463,8 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
 	available_protocols |= ir_raw_handler->protocols;
+	if (ir_raw_handler->encode)
+		encode_protocols |= ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -466,6 +481,8 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_unregister(raw->dev);
 	available_protocols &= ~ir_raw_handler->protocols;
+	if (ir_raw_handler->encode)
+		encode_protocols &= ~ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f8c5e47..cb42655 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -865,6 +865,8 @@ static ssize_t show_protocols(struct device *device,
 	} else {
 		enabled = dev->enabled_wakeup_protocols;
 		allowed = dev->allowed_wakeup_protocols;
+		if (dev->encode_wakeup && !allowed)
+			allowed = ir_raw_get_encode_protocols();
 	}
 
 	mutex_unlock(&dev->lock);
@@ -1406,13 +1408,16 @@ int rc_register_device(struct rc_dev *dev)
 		path ? path : "N/A");
 	kfree(path);
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+	if (dev->driver_type == RC_DRIVER_IR_RAW || dev->encode_wakeup) {
 		/* Load raw decoders, if they aren't already */
 		if (!raw_init) {
 			IR_dprintk(1, "Loading raw decoders\n");
 			ir_raw_init();
 			raw_init = true;
 		}
+	}
+
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		/* calls ir_register_device so unlock mutex here*/
 		mutex_unlock(&dev->lock);
 		rc = ir_raw_event_register(dev);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5703c08..9ae433c 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -74,6 +74,8 @@ enum rc_filter_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
+ * @encode_wakeup: wakeup filtering uses IR encode API, therefore the allowed
+ *	wakeup protocols is the set of all raw encoders
  * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
  * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
  * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
@@ -134,6 +136,7 @@ struct rc_dev {
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
+	bool				encode_wakeup;
 	u64				allowed_protocols;
 	u64				enabled_protocols;
 	u64				allowed_wakeup_protocols;
-- 
2.0.5

