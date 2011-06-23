Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954Ab1FWVNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 17:13:40 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Stephan Raue <sraue@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jeff Brown <jeffbrown@android.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v2] [media] rc: call input_sync after scancode reports
Date: Thu, 23 Jun 2011 17:13:24 -0400
Message-Id: <1308863604-23798-1-git-send-email-jarod@redhat.com>
In-Reply-To: <20110623183957.GC14950@core.coreip.homeip.net>
References: <20110623183957.GC14950@core.coreip.homeip.net>
In-Reply-To: <20110623183957.GC14950@core.coreip.homeip.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Due to commit cdda911c34006f1089f3c87b1a1f31ab3a4722f2, evdev only
becomes readable when the buffer contains an EV_SYN/SYN_REPORT event. If
we get a repeat or a scancode we don't have a mapping for, we never call
input_sync, and thus those events don't get reported in a timely
fashion.

For example, take an mceusb transceiver with a default rc6 keymap. Press
buttons on an rc5 remote while monitoring with ir-keytable, and you'll
see nothing. Now press a button on the rc6 remote matching the keymap.
You'll suddenly get the rc5 key scancodes, the rc6 scancode and the rc6
key spit out all at the same time.

Pressing and holding a button on a remote we do have a keymap for also
works rather unreliably right now, due to repeat events also happening
without a call to input_sync (we bail from ir_do_keydown before getting
to the point where it calls input_sync).

Easy fix though, just add two strategically placed input_sync calls
right after our input_event calls for EV_MSC, and all is well again.
Technically, we probably should have been doing this all along, its just
that it never caused any functional difference until the referenced
change went into the input layer.

v2: rework code a bit, per Dmitry's example, so that we only call
input_sync once per IR signal. There was another hidden bug in the code
where we were calling input_report_key using last_keycode instead of our
just discovered keycode, which manifested with the reordering of calling
input_report_key and setting last_keycode.

Reported-by: Stephan Raue <sraue@openelec.tv>
CC: Stephan Raue <sraue@openelec.tv>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jeff Brown <jeffbrown@android.com>
CC: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/rc-main.c |   48 ++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f57cd56..3186ac7 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -522,18 +522,20 @@ EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
 /**
  * ir_do_keyup() - internal function to signal the release of a keypress
  * @dev:	the struct rc_dev descriptor of the device
+ * @sync:	whether or not to call input_sync
  *
  * This function is used internally to release a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keyup(struct rc_dev *dev)
+static void ir_do_keyup(struct rc_dev *dev, bool sync)
 {
 	if (!dev->keypressed)
 		return;
 
 	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
 	input_report_key(dev->input_dev, dev->last_keycode, 0);
-	input_sync(dev->input_dev);
+	if (sync)
+		input_sync(dev->input_dev);
 	dev->keypressed = false;
 }
 
@@ -549,7 +551,7 @@ void rc_keyup(struct rc_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keyup(dev);
+	ir_do_keyup(dev, true);
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(rc_keyup);
@@ -578,7 +580,7 @@ static void ir_timer_keyup(unsigned long cookie)
 	 */
 	spin_lock_irqsave(&dev->keylock, flags);
 	if (time_is_before_eq_jiffies(dev->keyup_jiffies))
-		ir_do_keyup(dev);
+		ir_do_keyup(dev, true);
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 
@@ -597,6 +599,7 @@ void rc_repeat(struct rc_dev *dev)
 	spin_lock_irqsave(&dev->keylock, flags);
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
+	input_sync(dev->input_dev);
 
 	if (!dev->keypressed)
 		goto out;
@@ -622,29 +625,28 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			  u32 keycode, u8 toggle)
 {
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
-
-	/* Repeat event? */
-	if (dev->keypressed &&
-	    dev->last_scancode == scancode &&
-	    dev->last_toggle == toggle)
-		return;
+	bool new_event = !dev->keypressed ||
+			 dev->last_scancode != scancode ||
+			 dev->last_toggle != toggle;
 
-	/* Release old keypress */
-	ir_do_keyup(dev);
+	if (new_event && dev->keypressed)
+		ir_do_keyup(dev, false);
 
-	dev->last_scancode = scancode;
-	dev->last_toggle = toggle;
-	dev->last_keycode = keycode;
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
-	if (keycode == KEY_RESERVED)
-		return;
+	if (new_event && keycode != KEY_RESERVED) {
+		/* Register a keypress */
+		dev->keypressed = true;
+		dev->last_scancode = scancode;
+		dev->last_toggle = toggle;
+		dev->last_keycode = keycode;
+
+		IR_dprintk(1, "%s: key down event, "
+			   "key 0x%04x, scancode 0x%04x\n",
+			   dev->input_name, keycode, scancode);
+		input_report_key(dev->input_dev, keycode, 1);
+	}
 
-	/* Register a keypress */
-	dev->keypressed = true;
-	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		   dev->input_name, keycode, scancode);
-	input_report_key(dev->input_dev, dev->last_keycode, 1);
 	input_sync(dev->input_dev);
 }
 
-- 
1.7.5.4

