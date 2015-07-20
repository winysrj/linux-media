Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52566 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbbGTTQn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:43 -0400
Subject: [PATCH 3/7] [PATCH FIXES] Revert "[media] rc: rc-core: Add support
 for encode_wakeup drivers"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:41 +0200
Message-ID: <20150720191641.24633.15030.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 0d830b2d1295fee82546d57185da5a6604f11ae2.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    1 -
 drivers/media/rc/rc-ir-raw.c    |   17 -----------------
 drivers/media/rc/rc-main.c      |    7 +------
 include/media/rc-core.h         |    3 ---
 4 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 4b994aa..5266ecc7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -189,7 +189,6 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
  * Routines from rc-raw.c to be used internally and by decoders
  */
 u64 ir_raw_get_allowed_protocols(void);
-u64 ir_raw_get_encode_protocols(void);
 int ir_raw_event_register(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 1068f2b..72dd6b6 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -30,7 +30,6 @@ static LIST_HEAD(ir_raw_client_list);
 static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static u64 available_protocols;
-static u64 encode_protocols;
 
 static int ir_raw_event_thread(void *data)
 {
@@ -241,18 +240,6 @@ ir_raw_get_allowed_protocols(void)
 	return protocols;
 }
 
-/* used internally by the sysfs interface */
-u64
-ir_raw_get_encode_protocols(void)
-{
-	u64 protocols;
-
-	mutex_lock(&ir_raw_handler_lock);
-	protocols = encode_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-	return protocols;
-}
-
 static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 {
 	/* the caller will update dev->enabled_protocols */
@@ -463,8 +450,6 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
 	available_protocols |= ir_raw_handler->protocols;
-	if (ir_raw_handler->encode)
-		encode_protocols |= ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -481,8 +466,6 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_unregister(raw->dev);
 	available_protocols &= ~ir_raw_handler->protocols;
-	if (ir_raw_handler->encode)
-		encode_protocols &= ~ir_raw_handler->protocols;
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c808165..ecaee02 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -865,8 +865,6 @@ static ssize_t show_protocols(struct device *device,
 	} else {
 		enabled = dev->enabled_wakeup_protocols;
 		allowed = dev->allowed_wakeup_protocols;
-		if (dev->encode_wakeup && !allowed)
-			allowed = ir_raw_get_encode_protocols();
 	}
 
 	mutex_unlock(&dev->lock);
@@ -1411,16 +1409,13 @@ int rc_register_device(struct rc_dev *dev)
 		path ? path : "N/A");
 	kfree(path);
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW || dev->encode_wakeup) {
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		/* Load raw decoders, if they aren't already */
 		if (!raw_init) {
 			IR_dprintk(1, "Loading raw decoders\n");
 			ir_raw_init();
 			raw_init = true;
 		}
-	}
-
-	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		/* calls ir_register_device so unlock mutex here*/
 		mutex_unlock(&dev->lock);
 		rc = ir_raw_event_register(dev);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 9a9beb8..93713ca 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -74,8 +74,6 @@ enum rc_filter_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
- * @encode_wakeup: wakeup filtering uses IR encode API, therefore the allowed
- *	wakeup protocols is the set of all raw encoders
  * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
  * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
  * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
@@ -136,7 +134,6 @@ struct rc_dev {
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
-	bool				encode_wakeup;
 	u64				allowed_protocols;
 	u64				enabled_protocols;
 	u64				allowed_wakeup_protocols;

