Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55359 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753447AbdLNRWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:01 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/10] media: rc: mce_kbd: simplify key up
Date: Thu, 14 Dec 2017 17:21:53 +0000
Message-Id: <13d32d6be866efda78ad92c8f2ee834a91c9dcee.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For key up, rather than iterating over 224 keys, just remember which key
was pressed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 23 ++++++++++++++---------
 drivers/media/rc/rc-core-priv.h       |  1 +
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 8cf4cf358052..b851583d2d94 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -128,8 +128,10 @@ static void mce_kbd_rx_timeout(struct timer_list *t)
 		input_report_key(mce_kbd->idev, maskcode, 0);
 	}
 
-	for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-		input_report_key(mce_kbd->idev, kbd_keycodes[i], 0);
+	if (mce_kbd->last_key != KEY_RESERVED) {
+		input_report_key(mce_kbd->idev, mce_kbd->last_key, 0);
+		mce_kbd->last_key = KEY_RESERVED;
+	}
 }
 
 static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
@@ -144,7 +146,7 @@ static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
 	}
 }
 
-static void ir_mce_kbd_process_keyboard_data(struct input_dev *idev,
+static void ir_mce_kbd_process_keyboard_data(struct mce_kbd_dec *data,
 					     u32 scancode)
 {
 	u8 keydata   = (scancode >> 8) & 0xff;
@@ -161,15 +163,18 @@ static void ir_mce_kbd_process_keyboard_data(struct input_dev *idev,
 			keystate = 1;
 		else
 			keystate = 0;
-		input_report_key(idev, maskcode, keystate);
+		input_report_key(data->idev, maskcode, keystate);
+	}
+
+	if (data->last_key != KEY_RESERVED) {
+		input_report_key(data->idev, data->last_key, 0);
+		data->last_key = KEY_RESERVED;
 	}
 
 	if (keydata) {
 		keycode = kbd_keycodes[keydata];
-		input_report_key(idev, keycode, 1);
-	} else {
-		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-			input_report_key(idev, kbd_keycodes[i], 0);
+		input_report_key(data->idev, keycode, 1);
+		data->last_key = keycode;
 	}
 }
 
@@ -326,7 +331,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 				delay = msecs_to_jiffies(100);
 			mod_timer(&data->rx_timeout, jiffies + delay);
 			/* Pass data to keyboard buffer parser */
-			ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+			ir_mce_kbd_process_keyboard_data(data, scancode);
 			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 915434855a63..035f3ffc19f7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -106,6 +106,7 @@ struct ir_raw_event_ctrl {
 		char phys[64];
 		int state;
 		u8 header;
+		u8 last_key;
 		u32 body;
 		unsigned count;
 		unsigned wanted_bits;
-- 
2.14.3
