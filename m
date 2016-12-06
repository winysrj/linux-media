Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51945 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbcLFKTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:30 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v4 11/13] [media] rc: rc-core: Add support for encode_wakeup drivers
Date: Tue,  6 Dec 2016 10:19:19 +0000
Message-Id: <3deb5b75dd45e084b43bca8bef10c4482b899b3c.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
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
Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |  1 +
 drivers/media/rc/rc-ir-raw.c    | 12 ++++++++++++
 drivers/media/rc/rc-main.c      |  4 +++-
 include/media/rc-core.h         |  3 +++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 0680e10..8527cff 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -246,6 +246,7 @@ int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
  * Routines from rc-raw.c to be used internally and by decoders
  */
 u64 ir_raw_get_allowed_protocols(void);
+u64 ir_raw_get_encode_protocols(void);
 int ir_raw_event_register(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 5d299f6..f44b9e2 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -27,6 +27,7 @@ static LIST_HEAD(ir_raw_client_list);
 static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static atomic64_t available_protocols = ATOMIC64_INIT(0);
+static atomic64_t encode_protocols = ATOMIC64_INIT(0);
 
 static int ir_raw_event_thread(void *data)
 {
@@ -236,6 +237,13 @@ ir_raw_get_allowed_protocols(void)
 	return atomic64_read(&available_protocols);
 }
 
+/* used internally by the sysfs interface */
+u64
+ir_raw_get_encode_protocols(void)
+{
+	return atomic64_read(&encode_protocols);
+}
+
 static int change_protocol(struct rc_dev *dev, u64 *rc_type)
 {
 	/* the caller will update dev->enabled_protocols */
@@ -504,6 +512,8 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
 	atomic64_or(ir_raw_handler->protocols, &available_protocols);
+	if (ir_raw_handler->encode)
+		atomic64_or(ir_raw_handler->protocols, &encode_protocols);
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -523,6 +533,8 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 			ir_raw_handler->raw_unregister(raw->dev);
 	}
 	atomic64_andnot(protocols, &available_protocols);
+	if (ir_raw_handler->encode)
+		atomic64_andnot(protocols, &encode_protocols);
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 4d8a984..0385616 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1750,11 +1750,13 @@ int rc_register_device(struct rc_dev *dev)
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+	if (dev->driver_type == RC_DRIVER_IR_RAW || dev->encode_wakeup) {
+		/* Load raw decoders, if they aren't already */
 		if (!raw_init) {
 			request_module_nowait("ir-lirc-codec");
 			raw_init = true;
 		}
+
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
 			goto out_input;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0a72e17..acfdaf5 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -83,6 +83,8 @@ enum rc_filter_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
+ * @encode_wakeup: wakeup filtering uses IR encode API, therefore the allowed
+ *	wakeup protocols is the set of all raw encoders
  * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
  * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
  * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
@@ -147,6 +149,7 @@ struct rc_dev {
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
+	bool				encode_wakeup;
 	u64				allowed_protocols;
 	u64				enabled_protocols;
 	u64				allowed_wakeup_protocols;
-- 
2.9.3

