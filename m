Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38451 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdBYLwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:52:51 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 15/19] [media] rc: use the correct carrier for scancode transmit
Date: Sat, 25 Feb 2017 11:51:30 +0000
Message-Id: <d316936de7b9b57fb31343e3215302c17adec70c.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the lirc device supports it, set the carrier for the protocol.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-jvc-decoder.c     |  1 +
 drivers/media/rc/ir-lirc-codec.c      | 28 ++++++++++++++++------------
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
 12 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 674bf15..f3a1f6e 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -212,6 +212,7 @@ static struct ir_raw_handler jvc_handler = {
 	.protocols	= RC_BIT_JVC,
 	.decode		= ir_jvc_decode,
 	.encode		= ir_jvc_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_jvc_decode_init(void)
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 85f333d..c57ab6c 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -90,7 +90,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 {
 	struct lirc_node *lirc;
 	struct rc_dev *dev;
-	unsigned int *txbuf; /* buffer with values to transmit */
+	unsigned int *txbuf = NULL; /* buffer with values to transmit */
 	struct ir_raw_event *raw = NULL;
 	ssize_t ret = -EINVAL;
 	size_t count;
@@ -105,6 +105,13 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (!lirc)
 		return -EFAULT;
 
+	dev = lirc->dev;
+	if (!dev)
+		return -EFAULT;
+
+	if (!dev->tx_ir)
+		return -EINVAL;
+
 	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
@@ -135,7 +142,15 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		}
 
 		for (i = 0; i < count; i++)
+			/* Convert from NS to US */
 			txbuf[i] = DIV_ROUND_UP(raw[i].duration, 1000);
+
+		if (dev->s_tx_carrier) {
+			int carrier = ir_raw_encode_carrier(scan.rc_type);
+
+			if (carrier > 0)
+				dev->s_tx_carrier(dev, carrier);
+		}
 	} else {
 		if (n < sizeof(unsigned int) || n % sizeof(unsigned int))
 			return -EINVAL;
@@ -149,17 +164,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
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
index 6a4d58b..79c8f40 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -468,6 +468,7 @@ static struct ir_raw_handler mce_kbd_handler = {
 	.encode		= ir_mce_kbd_encode,
 	.raw_register	= ir_mce_kbd_register,
 	.raw_unregister	= ir_mce_kbd_unregister,
+	.carrier	= 36000,
 };
 
 static int __init ir_mce_kbd_decode_init(void)
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3ce8503..8f9ca71 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -288,6 +288,7 @@ static struct ir_raw_handler nec_handler = {
 	.protocols	= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
 	.decode		= ir_nec_decode,
 	.encode		= ir_nec_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_nec_decode_init(void)
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index fcfedf9..d92e49b 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -281,6 +281,7 @@ static struct ir_raw_handler rc5_handler = {
 	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
 	.encode		= ir_rc5_encode,
+	.carrier	= 36000,
 };
 
 static int __init ir_rc5_decode_init(void)
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 6fe2268..83a36f4 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -408,6 +408,7 @@ static struct ir_raw_handler rc6_handler = {
 			  RC_BIT_RC6_MCE,
 	.decode		= ir_rc6_decode,
 	.encode		= ir_rc6_encode,
+	.carrier	= 36000,
 };
 
 static int __init ir_rc6_decode_init(void)
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 520bb77..7d3bc03 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -222,6 +222,7 @@ static struct ir_raw_handler sanyo_handler = {
 	.protocols	= RC_BIT_SANYO,
 	.decode		= ir_sanyo_decode,
 	.encode		= ir_sanyo_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_sanyo_decode_init(void)
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index b47e89e..2b08da4 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -226,6 +226,7 @@ static struct ir_raw_handler sharp_handler = {
 	.protocols	= RC_BIT_SHARP,
 	.decode		= ir_sharp_decode,
 	.encode		= ir_sharp_encode,
+	.carrier	= 38000,
 };
 
 static int __init ir_sharp_decode_init(void)
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 355fa81..e36e779 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -220,6 +220,7 @@ static struct ir_raw_handler sony_handler = {
 	.protocols	= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
 	.decode		= ir_sony_decode,
 	.encode		= ir_sony_encode,
+	.carrier	= 40000,
 };
 
 static int __init ir_sony_decode_init(void)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 6944d54..5624300 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -33,6 +33,7 @@ struct ir_raw_handler {
 	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
 	int (*encode)(enum rc_type protocol, u32 scancode,
 		      struct ir_raw_event *events, unsigned int max);
+	u32 carrier;
 
 	/* These two should only be used by the mce kbd decoder */
 	int (*raw_register)(struct rc_dev *dev);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 6bfccf8..9ffa5a9 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -484,6 +484,36 @@ int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
 }
 EXPORT_SYMBOL(ir_raw_encode_scancode);
 
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
+int ir_raw_encode_carrier(enum rc_type protocol)
+{
+	struct ir_raw_handler *handler;
+	int ret = -EINVAL;
+	u64 mask = 1ULL << protocol;
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
index 45e8623..6fe0ba8 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -318,6 +318,7 @@ int ir_raw_event_store_with_filter(struct rc_dev *dev,
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max);
+int ir_raw_encode_carrier(enum rc_type protocol);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-- 
2.9.3
