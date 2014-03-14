Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41408 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaCNXHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:05 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so167086wiw.6
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:07:03 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 7/9] rc: rc-core: Add support for encode_wakeup drivers
Date: Fri, 14 Mar 2014 23:04:17 +0000
Message-Id: <1394838259-14260-8-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support in rc-core for drivers which implement the wakeup scancode
filter by encoding the scancode using the raw IR encoders. This is by
way of rc_dev::encode_wakeup which should be set to true to make the
allowed wakeup protocols the same as the set of raw IR encoders.

As well as updating the sysfs interface to know which wakeup protocols
are allowed for encode_wakeup drivers, also ensure that the IR
decoders/encoders are loaded when an encode_wakeup driver is registered.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
Changes in v2:
 - New patch
---
 drivers/media/rc/ir-raw.c       | 15 +++++++++++++++
 drivers/media/rc/rc-core-priv.h |  1 +
 drivers/media/rc/rc-main.c      | 11 ++++++++---
 include/media/rc-core.h         |  3 +++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 4310e82..d8ad81c 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -30,6 +30,7 @@ static LIST_HEAD(ir_raw_client_list);
 static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static u64 available_protocols;
+static u64 encode_protocols;
 
 static int ir_raw_event_thread(void *data)
 {
@@ -240,6 +241,16 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
+/* used internally by the sysfs interface */
+u64 ir_raw_get_encode_protocols(void)
+{
+	u64 protocols;
+	mutex_lock(&ir_raw_handler_lock);
+	protocols = encode_protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+	return protocols;
+}
+
 /**
  * ir_raw_gen_manchester() - Encode data with Manchester (bi-phase) modulation.
  * @ev:		Pointer to pointer to next free event. *@ev is incremented for
@@ -498,6 +509,8 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
 	available_protocols |= ir_raw_handler->protocols;
+	if (ir_raw_handler->encode)
+		encode_protocols |= ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -514,6 +527,8 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_unregister(raw->dev);
 	available_protocols &= ~ir_raw_handler->protocols;
+	if (ir_raw_handler->encode)
+		encode_protocols &= ~ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c45b797..767ef69 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -239,6 +239,7 @@ int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
  * Routines from rc-raw.c to be used internally and by decoders
  */
 u64 ir_raw_get_allowed_protocols(void);
+u64 ir_raw_get_encode_protocols(void);
 int ir_raw_event_register(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 99697aa..712a2d7 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -857,8 +857,10 @@ static ssize_t show_protocols(struct device *device,
 	mutex_lock(&dev->lock);
 
 	enabled = dev->enabled_protocols[fattr->type];
-	if (dev->driver_type == RC_DRIVER_SCANCODE ||
-	    fattr->type == RC_FILTER_WAKEUP)
+	if (dev->encode_wakeup && fattr->type == RC_FILTER_WAKEUP)
+		allowed = ir_raw_get_encode_protocols();
+	else if (dev->driver_type == RC_DRIVER_SCANCODE ||
+		 fattr->type == RC_FILTER_WAKEUP)
 		allowed = dev->allowed_protocols[fattr->type];
 	else if (dev->raw)
 		allowed = ir_raw_get_allowed_protocols();
@@ -1350,13 +1352,16 @@ int rc_register_device(struct rc_dev *dev)
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
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
 			goto out_input;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 8c64f9e..2d81d6c 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -73,6 +73,8 @@ enum rc_filter_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
+ * @encode_wakeup: wakeup filtering uses IR encode API, therefore the allowed
+ *	wakeup protocols is the set of all raw encoders
  * @allowed_protocols: bitmask with the supported RC_BIT_* protocols for each
  *	filter type
  * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols for each
@@ -128,6 +130,7 @@ struct rc_dev {
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
+	bool				encode_wakeup;
 	u64				allowed_protocols[RC_FILTER_MAX];
 	u64				enabled_protocols[RC_FILTER_MAX];
 	u32				users;
-- 
1.8.3.2

