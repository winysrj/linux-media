Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59279 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753103AbeDHVTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:48 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v2 3/7] media: rc: per-protocol repeat period and minimum keyup timer
Date: Sun,  8 Apr 2018 22:19:38 +0100
Message-Id: <e2fd13000586bb0a4e7a2cc07e69ad08319e3519.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each IR protocol has its own repeat period. We can minimise the keyup
timer to be the protocol period + IR timeout. This makes keys less
"sticky" and makes IR more reactive and nicer to use.

This feature was previously attempted in commit d57ea877af38 ("media: rc:
per-protocol repeat period"), but that did not take the IR timeout into
account, and had to be reverted.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/cec/cec-core.c |  2 +-
 drivers/media/rc/lirc_dev.c  |  2 +-
 drivers/media/rc/rc-main.c   | 56 +++++++++++++++++++++++---------------------
 3 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b0c87f9ea08f..b278ab90b387 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -322,7 +322,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->allowed_protocols = RC_PROTO_BIT_CEC;
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
-	adap->rc->timeout = MS_TO_NS(100);
+	adap->rc->timeout = MS_TO_NS(550);
 #endif
 	return adap;
 }
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 6b4755e9fa25..cc58ed78462f 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -583,7 +583,7 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
-		if (!dev->timeout)
+		if (dev->driver_type != RC_DRIVER_IR_RAW)
 			ret = -ENOTTY;
 		else
 			fh->send_timeout_reports = !!val;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6a720e9c7aa8..9f4df60f62e1 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -26,50 +26,50 @@ static const struct {
 	unsigned int repeat_period;
 	unsigned int scancode_bits;
 } protocols[] = {
-	[RC_PROTO_UNKNOWN] = { .name = "unknown", .repeat_period = 250 },
-	[RC_PROTO_OTHER] = { .name = "other", .repeat_period = 250 },
+	[RC_PROTO_UNKNOWN] = { .name = "unknown", .repeat_period = 125 },
+	[RC_PROTO_OTHER] = { .name = "other", .repeat_period = 125 },
 	[RC_PROTO_RC5] = { .name = "rc-5",
-		.scancode_bits = 0x1f7f, .repeat_period = 250 },
+		.scancode_bits = 0x1f7f, .repeat_period = 114 },
 	[RC_PROTO_RC5X_20] = { .name = "rc-5x-20",
-		.scancode_bits = 0x1f7f3f, .repeat_period = 250 },
+		.scancode_bits = 0x1f7f3f, .repeat_period = 114 },
 	[RC_PROTO_RC5_SZ] = { .name = "rc-5-sz",
-		.scancode_bits = 0x2fff, .repeat_period = 250 },
+		.scancode_bits = 0x2fff, .repeat_period = 114 },
 	[RC_PROTO_JVC] = { .name = "jvc",
-		.scancode_bits = 0xffff, .repeat_period = 250 },
+		.scancode_bits = 0xffff, .repeat_period = 125 },
 	[RC_PROTO_SONY12] = { .name = "sony-12",
-		.scancode_bits = 0x1f007f, .repeat_period = 250 },
+		.scancode_bits = 0x1f007f, .repeat_period = 100 },
 	[RC_PROTO_SONY15] = { .name = "sony-15",
-		.scancode_bits = 0xff007f, .repeat_period = 250 },
+		.scancode_bits = 0xff007f, .repeat_period = 100 },
 	[RC_PROTO_SONY20] = { .name = "sony-20",
-		.scancode_bits = 0x1fff7f, .repeat_period = 250 },
+		.scancode_bits = 0x1fff7f, .repeat_period = 100 },
 	[RC_PROTO_NEC] = { .name = "nec",
-		.scancode_bits = 0xffff, .repeat_period = 250 },
+		.scancode_bits = 0xffff, .repeat_period = 110 },
 	[RC_PROTO_NECX] = { .name = "nec-x",
-		.scancode_bits = 0xffffff, .repeat_period = 250 },
+		.scancode_bits = 0xffffff, .repeat_period = 110 },
 	[RC_PROTO_NEC32] = { .name = "nec-32",
-		.scancode_bits = 0xffffffff, .repeat_period = 250 },
+		.scancode_bits = 0xffffffff, .repeat_period = 110 },
 	[RC_PROTO_SANYO] = { .name = "sanyo",
-		.scancode_bits = 0x1fffff, .repeat_period = 250 },
+		.scancode_bits = 0x1fffff, .repeat_period = 125 },
 	[RC_PROTO_MCIR2_KBD] = { .name = "mcir2-kbd",
-		.scancode_bits = 0xffff, .repeat_period = 250 },
+		.scancode_bits = 0xffff, .repeat_period = 100 },
 	[RC_PROTO_MCIR2_MSE] = { .name = "mcir2-mse",
-		.scancode_bits = 0x1fffff, .repeat_period = 250 },
+		.scancode_bits = 0x1fffff, .repeat_period = 100 },
 	[RC_PROTO_RC6_0] = { .name = "rc-6-0",
-		.scancode_bits = 0xffff, .repeat_period = 250 },
+		.scancode_bits = 0xffff, .repeat_period = 114 },
 	[RC_PROTO_RC6_6A_20] = { .name = "rc-6-6a-20",
-		.scancode_bits = 0xfffff, .repeat_period = 250 },
+		.scancode_bits = 0xfffff, .repeat_period = 114 },
 	[RC_PROTO_RC6_6A_24] = { .name = "rc-6-6a-24",
-		.scancode_bits = 0xffffff, .repeat_period = 250 },
+		.scancode_bits = 0xffffff, .repeat_period = 114 },
 	[RC_PROTO_RC6_6A_32] = { .name = "rc-6-6a-32",
-		.scancode_bits = 0xffffffff, .repeat_period = 250 },
+		.scancode_bits = 0xffffffff, .repeat_period = 114 },
 	[RC_PROTO_RC6_MCE] = { .name = "rc-6-mce",
-		.scancode_bits = 0xffff7fff, .repeat_period = 250 },
+		.scancode_bits = 0xffff7fff, .repeat_period = 114 },
 	[RC_PROTO_SHARP] = { .name = "sharp",
-		.scancode_bits = 0x1fff, .repeat_period = 250 },
-	[RC_PROTO_XMP] = { .name = "xmp", .repeat_period = 250 },
-	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 550 },
+		.scancode_bits = 0x1fff, .repeat_period = 125 },
+	[RC_PROTO_XMP] = { .name = "xmp", .repeat_period = 125 },
+	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 0 },
 	[RC_PROTO_IMON] = { .name = "imon",
-		.scancode_bits = 0x7fffffff, .repeat_period = 250 },
+		.scancode_bits = 0x7fffffff, .repeat_period = 114 },
 };
 
 /* Used to keep track of known keymaps */
@@ -690,7 +690,8 @@ static void ir_timer_repeat(struct timer_list *t)
 void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
-	unsigned int timeout = protocols[dev->last_protocol].repeat_period;
+	unsigned int timeout = nsecs_to_jiffies(dev->timeout) +
+		msecs_to_jiffies(protocols[dev->last_protocol].repeat_period);
 	struct lirc_scancode sc = {
 		.scancode = dev->last_scancode, .rc_proto = dev->last_protocol,
 		.keycode = dev->keypressed ? dev->last_keycode : KEY_RESERVED,
@@ -706,7 +707,7 @@ void rc_repeat(struct rc_dev *dev)
 	input_sync(dev->input_dev);
 
 	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout);
+		dev->keyup_jiffies = jiffies + timeout;
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
 
@@ -801,7 +802,7 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies +
+		dev->keyup_jiffies = jiffies + nsecs_to_jiffies(dev->timeout) +
 			msecs_to_jiffies(protocols[protocol].repeat_period);
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
@@ -1647,6 +1648,7 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 		dev->input_dev->setkeycode = ir_setkeycode;
 		input_set_drvdata(dev->input_dev, dev);
 
+		dev->timeout = IR_DEFAULT_TIMEOUT;
 		timer_setup(&dev->timer_keyup, ir_timer_keyup, 0);
 		timer_setup(&dev->timer_repeat, ir_timer_repeat, 0);
 
-- 
2.14.3
