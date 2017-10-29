Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47977 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdJ2U65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/28] media: lirc: use the correct carrier for scancode transmit
Date: Sun, 29 Oct 2017 20:58:56 +0000
Message-Id: <3aee168ef643672670f1ceebac945e2f764e80e2.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the lirc device supports it, set the carrier for the protocol.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-jvc-decoder.c     |  1 +
 drivers/media/rc/ir-lirc-codec.c      | 29 ++++++++++++++++++-----------
 drivers/media/rc/ir-mce_kbd-decoder.c |  1 +
 drivers/media/rc/ir-nec-decoder.c     |  1 +
 drivers/media/rc/ir-rc5-decoder.c     |  1 +
 drivers/media/rc/ir-rc6-decoder.c     |  1 +
 drivers/media/rc/ir-sanyo-decoder.c   |  1 +
 drivers/media/rc/ir-sharp-decoder.c   |  1 +
 drivers/media/rc/ir-sony-decoder.c    |  1 +
 drivers/media/rc/rc-core-priv.h       |  1 +
 drivers/media/rc/rc-ir-raw.c          | 30 ++++++++++++++++++++++++++++++
 include/media/rc-core.h               |  1 +
 12 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index e2bd68c42edf..2ae20dfc0e61 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -212,6 +212,7 @@ static struct ir_raw_handler jvc_handler = {
 	.protocols	= RC_PROTO_BIT_JVC,
 	.decode		= ir_jvc_decode,
 	.encode		= ir_jvc_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_jvc_decode_init(void)
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 73e4ff3cb023..d733179e2a94 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -122,6 +122,17 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (!lirc)
 		return -EFAULT;
 
+	dev = lirc->dev;
+	if (!dev) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (!dev->tx_ir) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
@@ -154,6 +165,13 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		for (i = 0; i < count; i++)
 			/* Convert from NS to US */
 			txbuf[i] = DIV_ROUND_UP(raw[i].duration, 1000);
+
+		if (dev->s_tx_carrier) {
+			int carrier = ir_raw_encode_carrier(scan.rc_proto);
+
+			if (carrier > 0)
+				dev->s_tx_carrier(dev, carrier);
+		}
 	} else {
 		if (n < sizeof(unsigned int) || n % sizeof(unsigned int))
 			return -EINVAL;
@@ -167,17 +185,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 			return PTR_ERR(txbuf);
 	}
 
-	dev = lirc->dev;
-	if (!dev) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	if (!dev->tx_ir) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	for (i = 0; i < count; i++) {
 		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
 			ret = -EINVAL;
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 7c572a643656..efa3b735dcc4 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -474,6 +474,7 @@ static struct ir_raw_handler mce_kbd_handler = {
 	.encode		= ir_mce_kbd_encode,
 	.raw_register	= ir_mce_kbd_register,
 	.raw_unregister	= ir_mce_kbd_unregister,
+	.carrier	= 36000,
 };
 
 static int __init ir_mce_kbd_decode_init(void)
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index a95d09acc22a..4ace5648866d 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -264,6 +264,7 @@ static struct ir_raw_handler nec_handler = {
 							RC_PROTO_BIT_NEC32,
 	.decode		= ir_nec_decode,
 	.encode		= ir_nec_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_nec_decode_init(void)
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 1292f534de43..cd1c4ee5fcd4 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -282,6 +282,7 @@ static struct ir_raw_handler rc5_handler = {
 							RC_PROTO_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
 	.encode		= ir_rc5_encode,
+	.carrier	= 36000,
 };
 
 static int __init ir_rc5_decode_init(void)
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 5d0d2fe3b7a7..665025303c28 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -408,6 +408,7 @@ static struct ir_raw_handler rc6_handler = {
 			  RC_PROTO_BIT_RC6_MCE,
 	.decode		= ir_rc6_decode,
 	.encode		= ir_rc6_encode,
+	.carrier	= 36000,
 };
 
 static int __init ir_rc6_decode_init(void)
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 758c60956850..723e7d75a593 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -218,6 +218,7 @@ static struct ir_raw_handler sanyo_handler = {
 	.protocols	= RC_PROTO_BIT_SANYO,
 	.decode		= ir_sanyo_decode,
 	.encode		= ir_sanyo_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_sanyo_decode_init(void)
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 129b558acc92..dbe8be513389 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -226,6 +226,7 @@ static struct ir_raw_handler sharp_handler = {
 	.protocols	= RC_PROTO_BIT_SHARP,
 	.decode		= ir_sharp_decode,
 	.encode		= ir_sharp_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_sharp_decode_init(void)
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index a47ced763031..e4bcff21c025 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -221,6 +221,7 @@ static struct ir_raw_handler sony_handler = {
 							RC_PROTO_BIT_SONY20,
 	.decode		= ir_sony_decode,
 	.encode		= ir_sony_encode,
+	.carrier	= 40000,
 };
 
 static int __init ir_sony_decode_init(void)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 43eabea9f152..3cf09408df6c 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -29,6 +29,7 @@ struct ir_raw_handler {
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
 	int (*encode)(enum rc_proto protocol, u32 scancode,
 		      struct ir_raw_event *events, unsigned int max);
+	u32 carrier;
 
 	/* These two should only be used by the lirc decoder */
 	int (*raw_register)(struct rc_dev *dev);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 503bc425a187..0814e08a280b 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -492,6 +492,36 @@ static void edge_handle(unsigned long arg)
 	ir_raw_event_handle(dev);
 }
 
+/**
+ * ir_raw_encode_carrier() - Get carrier used for protocol
+ *
+ * @protocol:		protocol
+ *
+ * Attempts to find the carrier for the specified protocol
+ *
+ * Returns:	The carrier in Hz
+ *		-EINVAL if the protocol is invalid, or if no
+ *		compatible encoder was found.
+ */
+int ir_raw_encode_carrier(enum rc_proto protocol)
+{
+	struct ir_raw_handler *handler;
+	int ret = -EINVAL;
+	u64 mask = BIT_ULL(protocol);
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_for_each_entry(handler, &ir_raw_handler_list, list) {
+		if (handler->protocols & mask && handler->encode) {
+			ret = handler->carrier;
+			break;
+		}
+	}
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ir_raw_encode_carrier);
+
 /*
  * Used to (un)register raw event clients
  */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 314a1edb6189..ca48632ec8e2 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -309,6 +309,7 @@ int ir_raw_event_store_with_filter(struct rc_dev *dev,
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max);
+int ir_raw_encode_carrier(enum rc_proto protocol);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-- 
2.13.6
