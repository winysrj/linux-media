Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54720 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CFUwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 15:52:18 -0500
Subject: [PATCH 1/3] rc-core: don't treat dev->rc_map.rc_type as a bitmap
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, sean@mess.org
Date: Wed, 06 Mar 2013 21:52:05 +0100
Message-ID: <20130306205205.12635.98328.stgit@zeus.hardeman.nu>
In-Reply-To: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
References: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

store_protocols() treats dev->rc_map.rc_type as a bitmap which is wrong for
two reasons. First of all, it is pretty bogus to change the protocol type of
the keymap just because the hardware has been asked to decode a different
protocol.

Second, dev->rc_map.rc_type is an enum (i.e. a single protocol) as pointed
out by James Hogan <james.hogan@imgtec.com>.

Fix both issues by introducing a separate enabled_protocols member to
struct rc_dev.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/i2c/ir-kbd-i2c.c        |    1 +
 drivers/media/rc/ir-jvc-decoder.c     |    2 +-
 drivers/media/rc/ir-lirc-codec.c      |    2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c |    2 +-
 drivers/media/rc/ir-nec-decoder.c     |    2 +-
 drivers/media/rc/ir-raw.c             |    2 +-
 drivers/media/rc/ir-rc5-decoder.c     |    6 +++---
 drivers/media/rc/ir-rc5-sz-decoder.c  |    2 +-
 drivers/media/rc/ir-rc6-decoder.c     |    2 +-
 drivers/media/rc/ir-sanyo-decoder.c   |    2 +-
 drivers/media/rc/ir-sony-decoder.c    |    8 ++++----
 drivers/media/rc/rc-core-priv.h       |    1 -
 drivers/media/rc/rc-main.c            |   32 ++++++++++----------------------
 include/media/rc-core.h               |    2 ++
 14 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 08ae067..2586e46 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -423,6 +423,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	rc->map_name       = ir->ir_codes;
 	rc->allowed_protos = rc_type;
+	rc->enabled_protocols = rc_type;
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 69edffb..3948138 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_JVC))
+	if (!(dev->enabled_protocols & RC_BIT_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 9945e5e..ff4d93d 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_LIRC))
+	if (!(dev->enabled_protocols & RC_BIT_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 33fafa4..9f3c9b5 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	unsigned long delay;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_MCE_KBD))
+	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index a47ee36..9a90094 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -52,7 +52,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_NEC))
+	if (!(dev->enabled_protocols & RC_BIT_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 17c94be..5c42750 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -256,7 +256,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
-	dev->raw->enabled_protocols = ~0;
+	dev->enabled_protocols = ~0;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 5b4d1dd..4e53a31 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -52,7 +52,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	u32 scancode;
 
-	if (!(dev->raw->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
+	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -128,7 +128,7 @@ again:
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
-			if (!(dev->raw->enabled_protocols & RC_BIT_RC5X)) {
+			if (!(dev->enabled_protocols & RC_BIT_RC5X)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -145,7 +145,7 @@ again:
 		} else {
 			/* RC5 */
 			u8 command, system;
-			if (!(dev->raw->enabled_protocols & RC_BIT_RC5)) {
+			if (!(dev->enabled_protocols & RC_BIT_RC5)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index fd807a8..865fe84 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -48,7 +48,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_RC5_SZ))
+	if (!(dev->enabled_protocols & RC_BIT_RC5_SZ))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index e19072f..7cba7d3 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -89,7 +89,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 toggle;
 
-	if (!(dev->raw->enabled_protocols &
+	if (!(dev->enabled_protocols &
 	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
 	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
 		return 0;
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 7e69a3b..0a06205 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, command, not_command;
 
-	if (!(dev->raw->enabled_protocols & RC_BIT_SANYO))
+	if (!(dev->enabled_protocols & RC_BIT_SANYO))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index fb91434..29ab9c2 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -45,7 +45,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(dev->raw->enabled_protocols &
+	if (!(dev->enabled_protocols &
 	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 		return 0;
 
@@ -124,7 +124,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
-			if (!(dev->raw->enabled_protocols & RC_BIT_SONY12)) {
+			if (!(dev->enabled_protocols & RC_BIT_SONY12)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -133,7 +133,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			function  = bitrev8((data->bits >>  4) & 0xFE);
 			break;
 		case 15:
-			if (!(dev->raw->enabled_protocols & RC_BIT_SONY15)) {
+			if (!(dev->enabled_protocols & RC_BIT_SONY15)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -142,7 +142,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			function  = bitrev8((data->bits >>  7) & 0xFE);
 			break;
 		case 20:
-			if (!(dev->raw->enabled_protocols & RC_BIT_SONY20)) {
+			if (!(dev->enabled_protocols & RC_BIT_SONY20)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 5d87287..70a180b 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -39,7 +39,6 @@ struct ir_raw_event_ctrl {
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
-	u64				enabled_protocols; /* enabled raw protocol decoders */
 
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 759a40a..3090b40 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -783,13 +783,12 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	if (dev->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = dev->rc_map.rc_type;
+	enabled = dev->enabled_protocols;
+	if (dev->driver_type == RC_DRIVER_SCANCODE)
 		allowed = dev->allowed_protos;
-	} else if (dev->raw) {
-		enabled = dev->raw->enabled_protocols;
+	else if (dev->raw)
 		allowed = ir_raw_get_allowed_protocols();
-	} else {
+	else {
 		mutex_unlock(&dev->lock);
 		return -ENODEV;
 	}
@@ -847,7 +846,6 @@ static ssize_t store_protocols(struct device *device,
 	u64 type;
 	u64 mask;
 	int rc, i, count = 0;
-	unsigned long flags;
 	ssize_t ret;
 
 	/* Device is being removed */
@@ -856,15 +854,12 @@ static ssize_t store_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		type = dev->rc_map.rc_type;
-	else if (dev->raw)
-		type = dev->raw->enabled_protocols;
-	else {
+	if (dev->driver_type != RC_DRIVER_SCANCODE && !dev->raw) {
 		IR_dprintk(1, "Protocol switching not supported\n");
 		ret = -EINVAL;
 		goto out;
 	}
+	type = dev->enabled_protocols;
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -922,14 +917,7 @@ static ssize_t store_protocols(struct device *device,
 		}
 	}
 
-	if (dev->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&dev->rc_map.lock, flags);
-		dev->rc_map.rc_type = type;
-		spin_unlock_irqrestore(&dev->rc_map.lock, flags);
-	} else {
-		dev->raw->enabled_protocols = type;
-	}
-
+	dev->enabled_protocols = type;
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
@@ -1068,9 +1056,8 @@ int rc_register_device(struct rc_dev *dev)
 	/*
 	 * Take the lock here, as the device sysfs node will appear
 	 * when device_add() is called, which may trigger an ir-keytable udev
-	 * rule, which will in turn call show_protocols and access either
-	 * dev->rc_map.rc_type or dev->raw->enabled_protocols before it has
-	 * been initialized.
+	 * rule, which will in turn call show_protocols and access
+	 * dev->enabled_protocols before it has been initialized.
 	 */
 	mutex_lock(&dev->lock);
 
@@ -1132,6 +1119,7 @@ int rc_register_device(struct rc_dev *dev)
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
+		dev->enabled_protocols = rc_type;
 	}
 
 	mutex_unlock(&dev->lock);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f03445f..06a75de 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -51,6 +51,7 @@ enum rc_driver_type {
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
  * @allowed_protos: bitmask with the supported RC_BIT_* protocols
+ * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
@@ -99,6 +100,7 @@ struct rc_dev {
 	enum rc_driver_type		driver_type;
 	bool				idle;
 	u64				allowed_protos;
+	u64				enabled_protocols;
 	u32				scanmask;
 	void				*priv;
 	spinlock_t			keylock;

