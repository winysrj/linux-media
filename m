Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48339 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbeDNVpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 17:45:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH 2/2] media: rc: mce_kbd decoder: fix race condition
Date: Sat, 14 Apr 2018 22:45:31 +0100
Message-Id: <20180414214531.1450-2-sean@mess.org>
In-Reply-To: <20180414214531.1450-1-sean@mess.org>
References: <20180414214531.1450-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MCE keyboard sends both key down and key up events. We have a timeout
handler mce_kbd_rx_timeout() in case the keyup event is never received;
however, this may race with new key down events from occurring.

The race is that key down scancode arrives and key down events are
generated. The timeout handler races this and generates key up events
straight afterwards. Since the keyboard generates scancodes every 100ms,
most likely the keys will be repeated 100ms later, and now we have new
key down events and the user sees duplicate key presses.

Reported-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 23 ++++++++++++++++-------
 drivers/media/rc/rc-core-priv.h       |  1 +
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 2fc78710a724..9574c3dd90f2 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -119,19 +119,25 @@ static void mce_kbd_rx_timeout(struct timer_list *t)
 {
 	struct ir_raw_event_ctrl *raw = from_timer(raw, t, mce_kbd.rx_timeout);
 	unsigned char maskcode;
+	unsigned long flags;
 	int i;
 
 	dev_dbg(&raw->dev->dev, "timer callback clearing all keys\n");
 
-	for (i = 0; i < 7; i++) {
-		maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
-		input_report_key(raw->mce_kbd.idev, maskcode, 0);
-	}
+	spin_lock_irqsave(&raw->mce_kbd.keylock, flags);
 
-	for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
-		input_report_key(raw->mce_kbd.idev, kbd_keycodes[i], 0);
+	if (time_is_before_eq_jiffies(raw->mce_kbd.rx_timeout.expires)) {
+		for (i = 0; i < 7; i++) {
+			maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
+			input_report_key(raw->mce_kbd.idev, maskcode, 0);
+		}
 
-	input_sync(raw->mce_kbd.idev);
+		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
+			input_report_key(raw->mce_kbd.idev, kbd_keycodes[i], 0);
+
+		input_sync(raw->mce_kbd.idev);
+	}
+	spin_unlock_irqrestore(&raw->mce_kbd.keylock, flags);
 }
 
 static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
@@ -327,6 +333,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			scancode = data->body & 0xffffff;
 			dev_dbg(&dev->dev, "keyboard data 0x%08x\n",
 				data->body);
+			spin_lock(&data->keylock);
 			if (scancode) {
 				delay = nsecs_to_jiffies(dev->timeout) +
 					msecs_to_jiffies(100);
@@ -336,6 +343,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			}
 			/* Pass data to keyboard buffer parser */
 			ir_mce_kbd_process_keyboard_data(dev, scancode);
+			spin_unlock(&data->keylock);
 			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:
@@ -400,6 +408,7 @@ static int ir_mce_kbd_register(struct rc_dev *dev)
 	set_bit(MSC_SCAN, idev->mscbit);
 
 	timer_setup(&mce_kbd->rx_timeout, mce_kbd_rx_timeout, 0);
+	spin_lock_init(&mce_kbd->keylock);
 
 	input_set_drvdata(idev, mce_kbd);
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index f78551344eca..8f21562ec446 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -106,6 +106,7 @@ struct ir_raw_event_ctrl {
 	struct mce_kbd_dec {
 		struct input_dev *idev;
 		struct timer_list rx_timeout;
+		spinlock_t keylock;
 		char name[64];
 		char phys[64];
 		int state;
-- 
2.14.3
