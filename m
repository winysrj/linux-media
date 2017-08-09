Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56573 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbdHIRTU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 13:19:20 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] rc: per-protocol repeat period
Date: Wed,  9 Aug 2017 18:19:16 +0100
Message-Id: <20170809171916.16198-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC needs a keypress timeout of 550ms, which is too high for the IR
protocols. Also fill in known repeat times, with 50ms error margin.

Also, combine all protocol data into one structure.

Signed-off-by: Sean Young <sean@mess.org>
Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/rc-main.c | 138 +++++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 73 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c494a4ddc138..981cccd6b988 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -30,8 +30,54 @@
 #define IR_TAB_MAX_SIZE	8192
 #define RC_DEV_MAX	256
 
-/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
-#define IR_KEYPRESS_TIMEOUT 250
+static const struct {
+	const char *name;
+	unsigned int repeat_period;
+	unsigned int scancode_bits;
+} protocols[] = {
+	[RC_PROTO_UNKNOWN] = { .name = "unknown", .repeat_period = 250 },
+	[RC_PROTO_OTHER] = { .name = "other", .repeat_period = 250 },
+	[RC_PROTO_RC5] = { .name = "rc-5",
+		.scancode_bits = 0x1f7f, .repeat_period = 164 },
+	[RC_PROTO_RC5X_20] = { .name = "rc-5x-20",
+		.scancode_bits = 0x1f7f3f, .repeat_period = 164 },
+	[RC_PROTO_RC5_SZ] = { .name = "rc-5-sz",
+		.scancode_bits = 0x2fff, .repeat_period = 164 },
+	[RC_PROTO_JVC] = { .name = "jvc",
+		.scancode_bits = 0xffff, .repeat_period = 250 },
+	[RC_PROTO_SONY12] = { .name = "sony-12",
+		.scancode_bits = 0x1f007f, .repeat_period = 100 },
+	[RC_PROTO_SONY15] = { .name = "sony-15",
+		.scancode_bits = 0xff007f, .repeat_period = 100 },
+	[RC_PROTO_SONY20] = { .name = "sony-20",
+		.scancode_bits = 0x1fff7f, .repeat_period = 100 },
+	[RC_PROTO_NEC] = { .name = "nec",
+		.scancode_bits = 0xffff, .repeat_period = 160 },
+	[RC_PROTO_NECX] = { .name = "nec-x",
+		.scancode_bits = 0xffffff, .repeat_period = 160 },
+	[RC_PROTO_NEC32] = { .name = "nec-32",
+		.scancode_bits = 0xffffffff, .repeat_period = 160 },
+	[RC_PROTO_SANYO] = { .name = "sanyo",
+		.scancode_bits = 0x1fffff, .repeat_period = 250 },
+	[RC_PROTO_MCIR2_KBD] = { .name = "mcir2-kbd",
+		.scancode_bits = 0xffff, .repeat_period = 150 },
+	[RC_PROTO_MCIR2_MSE] = { .name = "mcir2-mse",
+		.scancode_bits = 0x1fffff, .repeat_period = 150 },
+	[RC_PROTO_RC6_0] = { .name = "rc-6-0",
+		.scancode_bits = 0xffff, .repeat_period = 164 },
+	[RC_PROTO_RC6_6A_20] = { .name = "rc-6-6a-20",
+		.scancode_bits = 0xfffff, .repeat_period = 164 },
+	[RC_PROTO_RC6_6A_24] = { .name = "rc-6-6a-24",
+		.scancode_bits = 0xffffff, .repeat_period = 164 },
+	[RC_PROTO_RC6_6A_32] = { .name = "rc-6-6a-32",
+		.scancode_bits = 0xffffffff, .repeat_period = 164 },
+	[RC_PROTO_RC6_MCE] = { .name = "rc-6-mce",
+		.scancode_bits = 0xffff7fff, .repeat_period = 164 },
+	[RC_PROTO_SHARP] = { .name = "sharp",
+		.scancode_bits = 0x1fff, .repeat_period = 250 },
+	[RC_PROTO_XMP] = { .name = "xmp", .repeat_period = 250 },
+	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 550 },
+};
 
 /* Used to keep track of known keymaps */
 static LIST_HEAD(rc_map_list);
@@ -613,6 +659,7 @@ static void ir_timer_keyup(unsigned long cookie)
 void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
+	unsigned int timeout = protocols[dev->last_protocol].repeat_period;
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
@@ -622,7 +669,7 @@ void rc_repeat(struct rc_dev *dev)
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 	input_sync(dev->input_dev);
 
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout);
 	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 
 out:
@@ -693,7 +740,8 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		dev->keyup_jiffies = jiffies +
+			msecs_to_jiffies(protocols[protocol].repeat_period);
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
 	spin_unlock_irqrestore(&dev->keylock, flags);
@@ -734,33 +782,14 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 static int rc_validate_filter(struct rc_dev *dev,
 			      struct rc_scancode_filter *filter)
 {
-	static const u32 masks[] = {
-		[RC_PROTO_RC5] = 0x1f7f,
-		[RC_PROTO_RC5X_20] = 0x1f7f3f,
-		[RC_PROTO_RC5_SZ] = 0x2fff,
-		[RC_PROTO_SONY12] = 0x1f007f,
-		[RC_PROTO_SONY15] = 0xff007f,
-		[RC_PROTO_SONY20] = 0x1fff7f,
-		[RC_PROTO_JVC] = 0xffff,
-		[RC_PROTO_NEC] = 0xffff,
-		[RC_PROTO_NECX] = 0xffffff,
-		[RC_PROTO_NEC32] = 0xffffffff,
-		[RC_PROTO_SANYO] = 0x1fffff,
-		[RC_PROTO_MCIR2_KBD] = 0xffff,
-		[RC_PROTO_MCIR2_MSE] = 0x1fffff,
-		[RC_PROTO_RC6_0] = 0xffff,
-		[RC_PROTO_RC6_6A_20] = 0xfffff,
-		[RC_PROTO_RC6_6A_24] = 0xffffff,
-		[RC_PROTO_RC6_6A_32] = 0xffffffff,
-		[RC_PROTO_RC6_MCE] = 0xffff7fff,
-		[RC_PROTO_SHARP] = 0x1fff,
-	};
-	u32 s = filter->data;
+	u32 mask, s = filter->data;
 	enum rc_proto protocol = dev->wakeup_protocol;
 
-	if (protocol >= ARRAY_SIZE(masks))
+	if (protocol >= ARRAY_SIZE(protocols))
 		return -EINVAL;
 
+	mask = protocols[protocol].scancode_bits;
+
 	switch (protocol) {
 	case RC_PROTO_NECX:
 		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
@@ -782,14 +811,13 @@ static int rc_validate_filter(struct rc_dev *dev,
 		break;
 	}
 
-	filter->data &= masks[protocol];
-	filter->mask &= masks[protocol];
+	filter->data &= mask;
+	filter->mask &= mask;
 
 	/*
 	 * If we have to raw encode the IR for wakeup, we cannot have a mask
 	 */
-	if (dev->encode_wakeup &&
-	    filter->mask != 0 && filter->mask != masks[protocol])
+	if (dev->encode_wakeup && filter->mask != 0 && filter->mask != mask)
 		return -EINVAL;
 
 	return 0;
@@ -1303,40 +1331,6 @@ static ssize_t store_filter(struct device *device,
 	return (ret < 0) ? ret : len;
 }
 
-/*
- * This is the list of all variants of all protocols, which is used by
- * the wakeup_protocols sysfs entry. In the protocols sysfs entry some
- * some protocols are grouped together (e.g. nec = nec + necx + nec32).
- *
- * For wakeup we need to know the exact protocol variant so the hardware
- * can be programmed exactly what to expect.
- */
-static const char * const proto_variant_names[] = {
-	[RC_PROTO_UNKNOWN] = "unknown",
-	[RC_PROTO_OTHER] = "other",
-	[RC_PROTO_RC5] = "rc-5",
-	[RC_PROTO_RC5X_20] = "rc-5x-20",
-	[RC_PROTO_RC5_SZ] = "rc-5-sz",
-	[RC_PROTO_JVC] = "jvc",
-	[RC_PROTO_SONY12] = "sony-12",
-	[RC_PROTO_SONY15] = "sony-15",
-	[RC_PROTO_SONY20] = "sony-20",
-	[RC_PROTO_NEC] = "nec",
-	[RC_PROTO_NECX] = "nec-x",
-	[RC_PROTO_NEC32] = "nec-32",
-	[RC_PROTO_SANYO] = "sanyo",
-	[RC_PROTO_MCIR2_KBD] = "mcir2-kbd",
-	[RC_PROTO_MCIR2_MSE] = "mcir2-mse",
-	[RC_PROTO_RC6_0] = "rc-6-0",
-	[RC_PROTO_RC6_6A_20] = "rc-6-6a-20",
-	[RC_PROTO_RC6_6A_24] = "rc-6-6a-24",
-	[RC_PROTO_RC6_6A_32] = "rc-6-6a-32",
-	[RC_PROTO_RC6_MCE] = "rc-6-mce",
-	[RC_PROTO_SHARP] = "sharp",
-	[RC_PROTO_XMP] = "xmp",
-	[RC_PROTO_CEC] = "cec",
-};
-
 /**
  * show_wakeup_protocols() - shows the wakeup IR protocol
  * @device:	the device descriptor
@@ -1371,14 +1365,12 @@ static ssize_t show_wakeup_protocols(struct device *device,
 	IR_dprintk(1, "%s: allowed - 0x%llx, enabled - %d\n",
 		   __func__, (long long)allowed, enabled);
 
-	for (i = 0; i < ARRAY_SIZE(proto_variant_names); i++) {
+	for (i = 0; i < ARRAY_SIZE(protocols); i++) {
 		if (allowed & (1ULL << i)) {
 			if (i == enabled)
-				tmp += sprintf(tmp, "[%s] ",
-						proto_variant_names[i]);
+				tmp += sprintf(tmp, "[%s] ", protocols[i].name);
 			else
-				tmp += sprintf(tmp, "%s ",
-						proto_variant_names[i]);
+				tmp += sprintf(tmp, "%s ", protocols[i].name);
 		}
 	}
 
@@ -1420,15 +1412,15 @@ static ssize_t store_wakeup_protocols(struct device *device,
 	if (sysfs_streq(buf, "none")) {
 		protocol = RC_PROTO_UNKNOWN;
 	} else {
-		for (i = 0; i < ARRAY_SIZE(proto_variant_names); i++) {
+		for (i = 0; i < ARRAY_SIZE(protocols); i++) {
 			if ((allowed & (1ULL << i)) &&
-			    sysfs_streq(buf, proto_variant_names[i])) {
+			    sysfs_streq(buf, protocols[i].name)) {
 				protocol = i;
 				break;
 			}
 		}
 
-		if (i == ARRAY_SIZE(proto_variant_names)) {
+		if (i == ARRAY_SIZE(protocols)) {
 			rc = -EINVAL;
 			goto out;
 		}
-- 
2.13.4
