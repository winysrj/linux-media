Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49303 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936187AbcLOMuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:14 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v6 16/18] [media] rc: rc-core: Add support for encode_wakeup drivers
Date: Thu, 15 Dec 2016 12:50:09 +0000
Message-Id: <830c5c614f73cc40b299d8103d014fb6a63e6cfe.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add support in rc-core for drivers which implement the wakeup scancode
filter by encoding the scancode using the raw IR encoders. This is by
way of rc_dev::encode_wakeup which should be set to true and
rc_dev::allowed_wakeup_protocols should be set to the raw IR encoders.

We also do not permit the mask to be set as we cannot generate IR
which would match that.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c | 26 +++++++++++++++++++++-----
 include/media/rc-core.h    |  3 +++
 include/media/rc-map.h     |  9 +++++++++
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 62141d6..48824d8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -727,11 +727,11 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 /**
  * rc_validate_filter() - checks that the scancode and mask are valid and
  *			  provides sensible defaults
- * @protocol:	the protocol for the filter
+ * @dev:	the struct rc_dev descriptor of the device
  * @filter:	the scancode and mask
  * @return:	0 or -EINVAL if the filter is not valid
  */
-static int rc_validate_filter(enum rc_type protocol,
+static int rc_validate_filter(struct rc_dev *dev,
 			      struct rc_scancode_filter *filter)
 {
 	static u32 masks[] = {
@@ -754,6 +754,7 @@ static int rc_validate_filter(enum rc_type protocol,
 		[RC_TYPE_SHARP] = 0x1fff,
 	};
 	u32 s = filter->data;
+	enum rc_type protocol = dev->wakeup_protocol;
 
 	switch (protocol) {
 	case RC_TYPE_NECX:
@@ -779,6 +780,13 @@ static int rc_validate_filter(enum rc_type protocol,
 	filter->data &= masks[protocol];
 	filter->mask &= masks[protocol];
 
+	/*
+	 * If we have to raw encode the IR for wakeup, we cannot have a mask
+	 */
+	if (dev->encode_wakeup &&
+	    filter->mask != 0 && filter->mask != masks[protocol])
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -1044,7 +1052,6 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 }
 
 static void ir_raw_load_modules(u64 *protocols)
-
 {
 	u64 available;
 	int i, ret;
@@ -1292,8 +1299,7 @@ static ssize_t store_filter(struct device *device,
 		 * and the filter is valid for that protocol
 		 */
 		if (dev->wakeup_protocol != RC_TYPE_UNKNOWN)
-			ret = rc_validate_filter(dev->wakeup_protocol,
-						 &new_filter);
+			ret = rc_validate_filter(dev, &new_filter);
 		else
 			ret = -EINVAL;
 
@@ -1461,6 +1467,16 @@ static ssize_t store_wakeup_protocols(struct device *device,
 			rc = -EINVAL;
 			goto out;
 		}
+
+		if (dev->encode_wakeup) {
+			u64 mask = 1ULL << protocol;
+
+			ir_raw_load_modules(&mask);
+			if (!mask) {
+				rc = -EINVAL;
+				goto out;
+			}
+		}
 	}
 
 	if (dev->wakeup_protocol != protocol) {
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 62d69b1..cf9fabc 100644
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
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index b2af45d..a1289a4 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -106,6 +106,15 @@ enum rc_type {
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
 			 RC_BIT_XMP)
 
+#define RC_BIT_ALL_IR_ENCODER \
+			(RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
+			 RC_BIT_JVC | \
+			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
+			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
+			 RC_BIT_SANYO | \
+			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
+			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | \
+			 RC_BIT_SHARP)
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
-- 
2.9.3

