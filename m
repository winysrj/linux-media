Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0IPFXx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 01:23:53 -0400
Date: Thu, 16 Sep 2010 01:23:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH 3/4] IR/imon: protect ictx's kc and last_keycode w/spinlock
Message-ID: <20100916052339.GD23299@redhat.com>
References: <20100916051932.GA23299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916051932.GA23299@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 1fd62121d93ca507ec6f2f692121f853a2c46889 Mon Sep 17 00:00:00 2001
From: Jarod Wilson <jarod@redhat.com>
Date: Wed, 15 Sep 2010 14:56:03 -0400
Subject: [PATCH 3/4] IR/imon: protect ictx's kc and last_keycode w/spinlock

Lest we get our keycodes wrong... Thus far, in practice, I've not found
it to actually matter, but its one of the issues raised in
https://bugzilla.kernel.org/show_bug.cgi?id=16351 that wasn't addressed
by converting to using native IR keydown/up functions.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   52 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index d36fe72..4b73b8e 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1,7 +1,7 @@
 /*
  *   imon.c:	input and display driver for SoundGraph iMON IR/VFD/LCD
  *
- *   Copyright(C) 2009  Jarod Wilson <jarod@wilsonet.com>
+ *   Copyright(C) 2010  Jarod Wilson <jarod@wilsonet.com>
  *   Portions based on the original lirc_imon driver,
  *	Copyright(C) 2004  Venky Raju(dev@venky.ws)
  *
@@ -125,6 +125,7 @@ struct imon_context {
 	struct input_dev *idev;		/* input device for panel & IR mouse */
 	struct input_dev *touch;	/* input device for touchscreen */
 
+	spinlock_t kc_lock;		/* make sure we get keycodes right */
 	u32 kc;				/* current input keycode */
 	u32 last_keycode;		/* last reported input keycode */
 	u32 rc_scancode;		/* the computed remote scancode */
@@ -1210,6 +1211,9 @@ static bool imon_mouse_event(struct imon_context *ictx,
 	u8 right_shift = 1;
 	bool mouse_input = true;
 	int dir = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ictx->kc_lock, flags);
 
 	/* newer iMON device PAD or mouse button */
 	if (ictx->product != 0xffdc && (buf[0] & 0x01) && len == 5) {
@@ -1241,6 +1245,8 @@ static bool imon_mouse_event(struct imon_context *ictx,
 	} else
 		mouse_input = false;
 
+	spin_unlock_irqrestore(&ictx->kc_lock, flags);
+
 	if (mouse_input) {
 		dev_dbg(ictx->dev, "sending mouse data via input subsystem\n");
 
@@ -1255,7 +1261,9 @@ static bool imon_mouse_event(struct imon_context *ictx,
 					 buf[1] >> right_shift & 0x1);
 		}
 		input_sync(ictx->idev);
+		spin_lock_irqsave(&ictx->kc_lock, flags);
 		ictx->last_keycode = ictx->kc;
+		spin_unlock_irqrestore(&ictx->kc_lock, flags);
 	}
 
 	return mouse_input;
@@ -1278,6 +1286,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 	char rel_x = 0x00, rel_y = 0x00;
 	u16 timeout, threshold;
 	u32 scancode = KEY_RESERVED;
+	unsigned long flags;
 
 	/*
 	 * The imon directional pad functions more like a touchpad. Bytes 3 & 4
@@ -1301,7 +1310,11 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
 				if (!dir) {
+					spin_lock_irqsave(&ictx->kc_lock,
+							  flags);
 					ictx->kc = KEY_UNKNOWN;
+					spin_unlock_irqrestore(&ictx->kc_lock,
+							       flags);
 					return;
 				}
 				buf[2] = dir & 0xFF;
@@ -1363,7 +1376,9 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
+				spin_lock_irqsave(&ictx->kc_lock, flags);
 				ictx->kc = KEY_UNKNOWN;
+				spin_unlock_irqrestore(&ictx->kc_lock, flags);
 				return;
 			}
 			buf[2] = dir & 0xFF;
@@ -1392,8 +1407,11 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		}
 	}
 
-	if (scancode)
+	if (scancode) {
+		spin_lock_irqsave(&ictx->kc_lock, flags);
 		ictx->kc = imon_remote_key_lookup(ictx, scancode);
+		spin_unlock_irqrestore(&ictx->kc_lock, flags);
+	}
 }
 
 /**
@@ -1405,6 +1423,9 @@ static int imon_parse_press_type(struct imon_context *ictx,
 				 unsigned char *buf, u8 ktype)
 {
 	int press_type = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ictx->kc_lock, flags);
 
 	/* key release of 0x02XXXXXX key */
 	if (ictx->kc == KEY_RESERVED && buf[0] == 0x02 && buf[3] == 0x00)
@@ -1437,6 +1458,8 @@ static int imon_parse_press_type(struct imon_context *ictx,
 	else
 		press_type = 1;
 
+	spin_unlock_irqrestore(&ictx->kc_lock, flags);
+
 	return press_type;
 }
 
@@ -1449,6 +1472,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	int len = urb->actual_length;
 	unsigned char *buf = urb->transfer_buffer;
 	struct device *dev = ictx->dev;
+	unsigned long flags;
 	u32 kc;
 	bool norelease = false;
 	int i;
@@ -1486,6 +1510,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		}
 	}
 
+	spin_lock_irqsave(&ictx->kc_lock, flags);
 	/* keyboard/mouse mode toggle button */
 	if (kc == KEY_KEYBOARD && !ictx->release_code) {
 		ictx->last_keycode = kc;
@@ -1493,6 +1518,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 			ictx->pad_mouse = ~(ictx->pad_mouse) & 0x1;
 			dev_dbg(dev, "toggling to %s mode\n",
 				ictx->pad_mouse ? "mouse" : "keyboard");
+			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
 		} else {
 			ictx->pad_mouse = 0;
@@ -1501,6 +1527,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	}
 
 	ictx->kc = kc;
+	spin_unlock_irqrestore(&ictx->kc_lock, flags);
 
 	/* send touchscreen events through input subsystem if touchpad data */
 	if (ictx->display_type == IMON_DISPLAY_TYPE_VGA && len == 8 &&
@@ -1534,8 +1561,10 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	if (press_type < 0)
 		goto not_input_data;
 
+	spin_lock_irqsave(&ictx->kc_lock, flags);
 	if (ictx->kc == KEY_UNKNOWN)
 		goto unknown_key;
+	spin_unlock_irqrestore(&ictx->kc_lock, flags);
 
 	if (ktype != IMON_KEY_PANEL) {
 		if (press_type == 0)
@@ -1543,33 +1572,43 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		else {
 			ir_keydown(ictx->rdev, ictx->rc_scancode,
 				   ictx->rc_toggle);
+			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
+			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 		}
 		return;
 	}
 
 	/* Only panel type events left to process now */
+	spin_lock_irqsave(&ictx->kc_lock, flags);
+
 	/* KEY_MUTE repeats from knob need to be suppressed */
 	if (ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode) {
 		do_gettimeofday(&t);
 		msec = tv2int(&t, &prev_time);
 		prev_time = t;
-		if (msec < idev->rep[REP_DELAY])
+		if (msec < idev->rep[REP_DELAY]) {
+			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
+		}
 	}
+	kc = ictx->kc;
+
+	spin_unlock_irqrestore(&ictx->kc_lock, flags);
 
-	input_report_key(idev, ictx->kc, press_type);
+	input_report_key(idev, kc, press_type);
 	input_sync(idev);
 
 	/* panel keys don't generate a release */
-	input_report_key(idev, ictx->kc, 0);
+	input_report_key(idev, kc, 0);
 	input_sync(idev);
 
-	ictx->last_keycode = ictx->kc;
+	ictx->last_keycode = kc;
 
 	return;
 
 unknown_key:
+	spin_unlock_irqrestore(&ictx->kc_lock, flags);
 	dev_info(dev, "%s: unknown keypress, code 0x%llx\n", __func__,
 		 (long long)scancode);
 	return;
@@ -1927,6 +1966,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 	}
 
 	mutex_init(&ictx->lock);
+	spin_lock_init(&ictx->kc_lock);
 
 	mutex_lock(&ictx->lock);
 
-- 
1.7.2.2


-- 
Jarod Wilson
jarod@redhat.com

