Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36789 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932306AbeBLPCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 10:02:13 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] media: rc: replace IR_dprintk() with dev_dbg in IR decoders
Date: Mon, 12 Feb 2018 15:02:07 +0000
Message-Id: <20180212150211.28355-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_dbg() rather than custom debug function.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-jvc-decoder.c     | 14 ++++----
 drivers/media/rc/ir-mce_kbd-decoder.c | 60 ++++++++++++++++++-----------------
 drivers/media/rc/ir-nec-decoder.c     | 20 ++++++------
 drivers/media/rc/ir-rc5-decoder.c     | 12 +++----
 drivers/media/rc/ir-rc6-decoder.c     | 26 +++++++--------
 drivers/media/rc/ir-sanyo-decoder.c   | 18 +++++------
 drivers/media/rc/ir-sharp-decoder.c   | 17 +++++-----
 drivers/media/rc/ir-sony-decoder.c    | 14 ++++----
 drivers/media/rc/ir-xmp-decoder.c     | 29 +++++++++--------
 9 files changed, 106 insertions(+), 104 deletions(-)

diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index c03c776cfa54..8cb68ae43282 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -56,8 +56,8 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	if (!geq_margin(ev.duration, JVC_UNIT, JVC_UNIT / 2))
 		goto out;
 
-	IR_dprintk(2, "JVC decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "JVC decode started at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 again:
 	switch (data->state) {
@@ -136,15 +136,15 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			u32 scancode;
 			scancode = (bitrev8((data->bits >> 8) & 0xff) << 8) |
 				   (bitrev8((data->bits >> 0) & 0xff) << 0);
-			IR_dprintk(1, "JVC scancode 0x%04x\n", scancode);
+			dev_dbg(&dev->dev, "JVC scancode 0x%04x\n", scancode);
 			rc_keydown(dev, RC_PROTO_JVC, scancode, data->toggle);
 			data->first = false;
 			data->old_bits = data->bits;
 		} else if (data->bits == data->old_bits) {
-			IR_dprintk(1, "JVC repeat\n");
+			dev_dbg(&dev->dev, "JVC repeat\n");
 			rc_repeat(dev);
 		} else {
-			IR_dprintk(1, "JVC invalid repeat msg\n");
+			dev_dbg(&dev->dev, "JVC invalid repeat msg\n");
 			break;
 		}
 
@@ -164,8 +164,8 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 out:
-	IR_dprintk(1, "JVC decode failed at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "JVC decode failed at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index fb318bdd6193..3df7c61c9e6c 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -117,19 +117,19 @@ static unsigned char kbd_keycodes[256] = {
 
 static void mce_kbd_rx_timeout(struct timer_list *t)
 {
-	struct mce_kbd_dec *mce_kbd = from_timer(mce_kbd, t, rx_timeout);
-	int i;
+	struct ir_raw_event_ctrl *raw = from_timer(raw, t, mce_kbd.rx_timeout);
 	unsigned char maskcode;
+	int i;
 
-	IR_dprintk(2, "timer callback clearing all keys\n");
+	dev_dbg(&raw->dev->dev, "timer callback clearing all keys\n");
 
 	for (i = 0; i < 7; i++) {
 		maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
-		input_report_key(mce_kbd->idev, maskcode, 0);
+		input_report_key(raw->mce_kbd.idev, maskcode, 0);
 	}
 
 	for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-		input_report_key(mce_kbd->idev, kbd_keycodes[i], 0);
+		input_report_key(raw->mce_kbd.idev, kbd_keycodes[i], 0);
 }
 
 static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
@@ -144,16 +144,16 @@ static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
 	}
 }
 
-static void ir_mce_kbd_process_keyboard_data(struct input_dev *idev,
-					     u32 scancode)
+static void ir_mce_kbd_process_keyboard_data(struct rc_dev *dev, u32 scancode)
 {
+	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	u8 keydata   = (scancode >> 8) & 0xff;
 	u8 shiftmask = scancode & 0xff;
 	unsigned char keycode, maskcode;
 	int i, keystate;
 
-	IR_dprintk(1, "keyboard: keydata = 0x%02x, shiftmask = 0x%02x\n",
-		   keydata, shiftmask);
+	dev_dbg(&dev->dev, "keyboard: keydata = 0x%02x, shiftmask = 0x%02x\n",
+		keydata, shiftmask);
 
 	for (i = 0; i < 7; i++) {
 		maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
@@ -161,20 +161,21 @@ static void ir_mce_kbd_process_keyboard_data(struct input_dev *idev,
 			keystate = 1;
 		else
 			keystate = 0;
-		input_report_key(idev, maskcode, keystate);
+		input_report_key(data->idev, maskcode, keystate);
 	}
 
 	if (keydata) {
 		keycode = kbd_keycodes[keydata];
-		input_report_key(idev, keycode, 1);
+		input_report_key(data->idev, keycode, 1);
 	} else {
 		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-			input_report_key(idev, kbd_keycodes[i], 0);
+			input_report_key(data->idev, kbd_keycodes[i], 0);
 	}
 }
 
-static void ir_mce_kbd_process_mouse_data(struct input_dev *idev, u32 scancode)
+static void ir_mce_kbd_process_mouse_data(struct rc_dev *dev, u32 scancode)
 {
+	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	/* raw mouse coordinates */
 	u8 xdata = (scancode >> 7) & 0x7f;
 	u8 ydata = (scancode >> 14) & 0x7f;
@@ -193,14 +194,14 @@ static void ir_mce_kbd_process_mouse_data(struct input_dev *idev, u32 scancode)
 	else
 		y = ydata;
 
-	IR_dprintk(1, "mouse: x = %d, y = %d, btns = %s%s\n",
-		   x, y, left ? "L" : "", right ? "R" : "");
+	dev_dbg(&dev->dev, "mouse: x = %d, y = %d, btns = %s%s\n",
+		x, y, left ? "L" : "", right ? "R" : "");
 
-	input_report_rel(idev, REL_X, x);
-	input_report_rel(idev, REL_Y, y);
+	input_report_rel(data->idev, REL_X, x);
+	input_report_rel(data->idev, REL_Y, y);
 
-	input_report_key(idev, BTN_LEFT, left);
-	input_report_key(idev, BTN_RIGHT, right);
+	input_report_key(data->idev, BTN_LEFT, left);
+	input_report_key(data->idev, BTN_RIGHT, right);
 }
 
 /**
@@ -227,8 +228,8 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		goto out;
 
 again:
-	IR_dprintk(2, "started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "started at state %i (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
 		return 0;
@@ -277,7 +278,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->wanted_bits = MCIR2_MOUSE_NBITS;
 			break;
 		default:
-			IR_dprintk(1, "not keyboard or mouse data\n");
+			dev_dbg(&dev->dev, "not keyboard or mouse data\n");
 			goto out;
 		}
 
@@ -313,25 +314,26 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		switch (data->wanted_bits) {
 		case MCIR2_KEYBOARD_NBITS:
 			scancode = data->body & 0xffff;
-			IR_dprintk(1, "keyboard data 0x%08x\n", data->body);
+			dev_dbg(&dev->dev, "keyboard data 0x%08x\n",
+				data->body);
 			if (dev->timeout)
 				delay = usecs_to_jiffies(dev->timeout / 1000);
 			else
 				delay = msecs_to_jiffies(100);
 			mod_timer(&data->rx_timeout, jiffies + delay);
 			/* Pass data to keyboard buffer parser */
-			ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+			ir_mce_kbd_process_keyboard_data(dev, scancode);
 			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:
 			scancode = data->body & 0x1fffff;
-			IR_dprintk(1, "mouse data 0x%06x\n", scancode);
+			dev_dbg(&dev->dev, "mouse data 0x%06x\n", scancode);
 			/* Pass data to mouse buffer parser */
-			ir_mce_kbd_process_mouse_data(data->idev, scancode);
+			ir_mce_kbd_process_mouse_data(dev, scancode);
 			lsc.rc_proto = RC_PROTO_MCIR2_MSE;
 			break;
 		default:
-			IR_dprintk(1, "not keyboard or mouse data\n");
+			dev_dbg(&dev->dev, "not keyboard or mouse data\n");
 			goto out;
 		}
 
@@ -344,8 +346,8 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 out:
-	IR_dprintk(1, "failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "failed at state %i (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	input_sync(data->idev);
 	return -EINVAL;
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 31d7bafe7bda..21647b809e6f 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -49,8 +49,8 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 	}
 
-	IR_dprintk(2, "NEC decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "NEC decode started at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	switch (data->state) {
 
@@ -99,13 +99,11 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		if (data->necx_repeat && data->count == NECX_REPEAT_BITS &&
-			geq_margin(ev.duration,
-			NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
-				IR_dprintk(1, "Repeat last key\n");
-				rc_repeat(dev);
-				data->state = STATE_INACTIVE;
-				return 0;
-
+		    geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
+			dev_dbg(&dev->dev, "Repeat last key\n");
+			rc_repeat(dev);
+			data->state = STATE_INACTIVE;
+			return 0;
 		} else if (data->count > NECX_REPEAT_BITS)
 			data->necx_repeat = false;
 
@@ -164,8 +162,8 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 	}
 
-	IR_dprintk(1, "NEC decode failed at count %d state %d (%uus %s)\n",
-		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "NEC decode failed at count %d state %d (%uus %s)\n",
+		data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index dd41d389f8d2..b305ef20cc11 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -54,8 +54,8 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		goto out;
 
 again:
-	IR_dprintk(2, "RC5(x/sz) decode started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "RC5(x/sz) decode started at state %i (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
 		return 0;
@@ -154,8 +154,8 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		} else
 			break;
 
-		IR_dprintk(1, "RC5(x/sz) scancode 0x%06x (p: %u, t: %u)\n",
-			   scancode, protocol, toggle);
+		dev_dbg(&dev->dev, "RC5(x/sz) scancode 0x%06x (p: %u, t: %u)\n",
+			scancode, protocol, toggle);
 
 		rc_keydown(dev, protocol, scancode, toggle);
 		data->state = STATE_INACTIVE;
@@ -163,8 +163,8 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 out:
-	IR_dprintk(1, "RC5(x/sz) decode failed at state %i count %d (%uus %s)\n",
-		   data->state, data->count, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "RC5(x/sz) decode failed at state %i count %d (%uus %s)\n",
+		data->state, data->count, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 3e3659c0875c..625fa0a008bd 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -100,8 +100,8 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		goto out;
 
 again:
-	IR_dprintk(2, "RC6 decode started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "RC6 decode started at state %i (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
 		return 0;
@@ -166,7 +166,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		if (!(data->header & RC6_STARTBIT_MASK)) {
-			IR_dprintk(1, "RC6 invalid start bit\n");
+			dev_dbg(&dev->dev, "RC6 invalid start bit\n");
 			break;
 		}
 
@@ -183,7 +183,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->wanted_bits = RC6_6A_NBITS;
 			break;
 		default:
-			IR_dprintk(1, "RC6 unknown mode\n");
+			dev_dbg(&dev->dev, "RC6 unknown mode\n");
 			goto out;
 		}
 		goto again;
@@ -223,13 +223,13 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			scancode = data->body;
 			toggle = data->toggle;
 			protocol = RC_PROTO_RC6_0;
-			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
-				   scancode, toggle);
+			dev_dbg(&dev->dev, "RC6(0) scancode 0x%04x (toggle: %u)\n",
+				scancode, toggle);
 			break;
 
 		case RC6_MODE_6A:
 			if (data->count > CHAR_BIT * sizeof data->body) {
-				IR_dprintk(1, "RC6 too many (%u) data bits\n",
+				dev_dbg(&dev->dev, "RC6 too many (%u) data bits\n",
 					data->count);
 				goto out;
 			}
@@ -255,15 +255,15 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 				}
 				break;
 			default:
-				IR_dprintk(1, "RC6(6A) unsupported length\n");
+				dev_dbg(&dev->dev, "RC6(6A) unsupported length\n");
 				goto out;
 			}
 
-			IR_dprintk(1, "RC6(6A) proto 0x%04x, scancode 0x%08x (toggle: %u)\n",
-				   protocol, scancode, toggle);
+			dev_dbg(&dev->dev, "RC6(6A) proto 0x%04x, scancode 0x%08x (toggle: %u)\n",
+				protocol, scancode, toggle);
 			break;
 		default:
-			IR_dprintk(1, "RC6 unknown mode\n");
+			dev_dbg(&dev->dev, "RC6 unknown mode\n");
 			goto out;
 		}
 
@@ -273,8 +273,8 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 out:
-	IR_dprintk(1, "RC6 decode failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "RC6 decode failed at state %i (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index ded39cdfc6ef..4efe6db5376a 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -52,14 +52,14 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset) {
-			IR_dprintk(1, "SANYO event reset received. reset to state 0\n");
+			dev_dbg(&dev->dev, "SANYO event reset received. reset to state 0\n");
 			data->state = STATE_INACTIVE;
 		}
 		return 0;
 	}
 
-	IR_dprintk(2, "SANYO decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "SANYO decode started at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	switch (data->state) {
 
@@ -102,7 +102,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
 			rc_repeat(dev);
-			IR_dprintk(1, "SANYO repeat last key\n");
+			dev_dbg(&dev->dev, "SANYO repeat last key\n");
 			data->state = STATE_INACTIVE;
 			return 0;
 		}
@@ -144,21 +144,21 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
 		if ((command ^ not_command) != 0xff) {
-			IR_dprintk(1, "SANYO checksum error: received 0x%08Lx\n",
-				   data->bits);
+			dev_dbg(&dev->dev, "SANYO checksum error: received 0x%08llx\n",
+				data->bits);
 			data->state = STATE_INACTIVE;
 			return 0;
 		}
 
 		scancode = address << 8 | command;
-		IR_dprintk(1, "SANYO scancode: 0x%06x\n", scancode);
+		dev_dbg(&dev->dev, "SANYO scancode: 0x%06x\n", scancode);
 		rc_keydown(dev, RC_PROTO_SANYO, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	IR_dprintk(1, "SANYO decode failed at count %d state %d (%uus %s)\n",
-		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "SANYO decode failed at count %d state %d (%uus %s)\n",
+		data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index df296991906c..6a38c50566a4 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -54,8 +54,8 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 	}
 
-	IR_dprintk(2, "Sharp decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "Sharp decode started at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	switch (data->state) {
 
@@ -149,9 +149,9 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		msg = (data->bits >> 15) & 0x7fff;
 		echo = data->bits & 0x7fff;
 		if ((msg ^ echo) != 0x3ff) {
-			IR_dprintk(1,
-				   "Sharp checksum error: received 0x%04x, 0x%04x\n",
-				   msg, echo);
+			dev_dbg(&dev->dev,
+				"Sharp checksum error: received 0x%04x, 0x%04x\n",
+				msg, echo);
 			break;
 		}
 
@@ -159,16 +159,15 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		command = bitrev8((msg >> 2) & 0xff);
 
 		scancode = address << 8 | command;
-		IR_dprintk(1, "Sharp scancode 0x%04x\n", scancode);
+		dev_dbg(&dev->dev, "Sharp scancode 0x%04x\n", scancode);
 
 		rc_keydown(dev, RC_PROTO_SHARP, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
 
-	IR_dprintk(1, "Sharp decode failed at count %d state %d (%uus %s)\n",
-		   data->count, data->state, TO_US(ev.duration),
-		   TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "Sharp decode failed at count %d state %d (%uus %s)\n",
+		data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index e4bcff21c025..6764ec9de646 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -55,8 +55,8 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2))
 		goto out;
 
-	IR_dprintk(2, "Sony decode started at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "Sony decode started at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	switch (data->state) {
 
@@ -148,19 +148,21 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			protocol = RC_PROTO_SONY20;
 			break;
 		default:
-			IR_dprintk(1, "Sony invalid bitcount %u\n", data->count);
+			dev_dbg(&dev->dev, "Sony invalid bitcount %u\n",
+				data->count);
 			goto out;
 		}
 
 		scancode = device << 16 | subdevice << 8 | function;
-		IR_dprintk(1, "Sony(%u) scancode 0x%05x\n", data->count, scancode);
+		dev_dbg(&dev->dev, "Sony(%u) scancode 0x%05x\n", data->count,
+			scancode);
 		rc_keydown(dev, protocol, scancode, 0);
 		goto finish_state_machine;
 	}
 
 out:
-	IR_dprintk(1, "Sony decode failed at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "Sony decode failed at state %d (%uus %s)\n",
+		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
index 712bc6d76e92..58b47af1a763 100644
--- a/drivers/media/rc/ir-xmp-decoder.c
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -49,8 +49,8 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 	}
 
-	IR_dprintk(2, "XMP decode started at state %d %d (%uus %s)\n",
-		   data->state, data->count, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "XMP decode started at state %d %d (%uus %s)\n",
+		data->state, data->count, TO_US(ev.duration), TO_STR(ev.pulse));
 
 	switch (data->state) {
 
@@ -85,7 +85,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			u32 scancode;
 
 			if (data->count != 16) {
-				IR_dprintk(2, "received TRAILER period at index %d: %u\n",
+				dev_dbg(&dev->dev, "received TRAILER period at index %d: %u\n",
 					data->count, ev.duration);
 				data->state = STATE_INACTIVE;
 				return -EINVAL;
@@ -99,7 +99,8 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			 */
 			divider = (n[3] - XMP_NIBBLE_PREFIX) / 15 - 2000;
 			if (divider < 50) {
-				IR_dprintk(2, "divider to small %d.\n", divider);
+				dev_dbg(&dev->dev, "divider to small %d.\n",
+					divider);
 				data->state = STATE_INACTIVE;
 				return -EINVAL;
 			}
@@ -113,7 +114,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 				n[12] + n[13] + n[14] + n[15]) % 16;
 
 			if (sum1 != 15 || sum2 != 15) {
-				IR_dprintk(2, "checksum errors sum1=0x%X sum2=0x%X\n",
+				dev_dbg(&dev->dev, "checksum errors sum1=0x%X sum2=0x%X\n",
 					sum1, sum2);
 				data->state = STATE_INACTIVE;
 				return -EINVAL;
@@ -127,24 +128,24 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			obc1 = n[12] << 4 | n[13];
 			obc2 = n[14] << 4 | n[15];
 			if (subaddr != subaddr2) {
-				IR_dprintk(2, "subaddress nibbles mismatch 0x%02X != 0x%02X\n",
+				dev_dbg(&dev->dev, "subaddress nibbles mismatch 0x%02X != 0x%02X\n",
 					subaddr, subaddr2);
 				data->state = STATE_INACTIVE;
 				return -EINVAL;
 			}
 			if (oem != 0x44)
-				IR_dprintk(1, "Warning: OEM nibbles 0x%02X. Expected 0x44\n",
+				dev_dbg(&dev->dev, "Warning: OEM nibbles 0x%02X. Expected 0x44\n",
 					oem);
 
 			scancode = addr << 24 | subaddr << 16 |
 				   obc1 << 8 | obc2;
-			IR_dprintk(1, "XMP scancode 0x%06x\n", scancode);
+			dev_dbg(&dev->dev, "XMP scancode 0x%06x\n", scancode);
 
 			if (toggle == 0) {
 				rc_keydown(dev, RC_PROTO_XMP, scancode, 0);
 			} else {
 				rc_repeat(dev);
-				IR_dprintk(1, "Repeat last key\n");
+				dev_dbg(&dev->dev, "Repeat last key\n");
 			}
 			data->state = STATE_INACTIVE;
 
@@ -153,7 +154,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		} else if (geq_margin(ev.duration, XMP_HALFFRAME_SPACE, XMP_NIBBLE_PREFIX)) {
 			/* Expect 8 or 16 nibble pulses. 16 in case of 'final' frame */
 			if (data->count == 16) {
-				IR_dprintk(2, "received half frame pulse at index %d. Probably a final frame key-up event: %u\n",
+				dev_dbg(&dev->dev, "received half frame pulse at index %d. Probably a final frame key-up event: %u\n",
 					data->count, ev.duration);
 				/*
 				 * TODO: for now go back to half frame position
@@ -164,7 +165,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			}
 
 			else if (data->count != 8)
-				IR_dprintk(2, "received half frame pulse at index %d: %u\n",
+				dev_dbg(&dev->dev, "received half frame pulse at index %d: %u\n",
 					data->count, ev.duration);
 			data->state = STATE_LEADER_PULSE;
 
@@ -173,7 +174,7 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		} else if (geq_margin(ev.duration, XMP_NIBBLE_PREFIX, XMP_UNIT)) {
 			/* store nibble raw data, decode after trailer */
 			if (data->count == 16) {
-				IR_dprintk(2, "to many pulses (%d) ignoring: %u\n",
+				dev_dbg(&dev->dev, "to many pulses (%d) ignoring: %u\n",
 					data->count, ev.duration);
 				data->state = STATE_INACTIVE;
 				return -EINVAL;
@@ -189,8 +190,8 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		break;
 	}
 
-	IR_dprintk(1, "XMP decode failed at count %d state %d (%uus %s)\n",
-		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	dev_dbg(&dev->dev, "XMP decode failed at count %d state %d (%uus %s)\n",
+		data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
-- 
2.14.3
