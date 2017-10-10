Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57567 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbdJJHSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:36 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 20/26] media: rc: ensure lirc device receives nec repeats
Date: Tue, 10 Oct 2017 08:18:35 +0100
Message-Id: <86e613b307bc32901c4154ff14484dbf395ac05e.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc device should get lirc repeats whether there is a keymap
match or not.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index e9d6ce024cd2..dae427e25d71 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -662,19 +662,25 @@ void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
 	unsigned int timeout = protocols[dev->last_protocol].repeat_period;
+	struct lirc_scancode sc = {
+		.scancode = dev->last_scancode, .rc_proto = dev->last_protocol,
+		.keycode = dev->keypressed ? dev->last_keycode : KEY_RESERVED,
+		.flags = LIRC_SCANCODE_FLAG_REPEAT |
+			 (dev->last_toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0)
+	};
 
-	spin_lock_irqsave(&dev->keylock, flags);
+	ir_lirc_scancode_event(dev, &sc);
 
-	if (!dev->keypressed)
-		goto out;
+	spin_lock_irqsave(&dev->keylock, flags);
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 	input_sync(dev->input_dev);
 
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout);
-	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
+	if (dev->keypressed) {
+		dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout);
+		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
+	}
 
-out:
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(rc_repeat);
@@ -710,13 +716,14 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
+	dev->last_protocol = protocol;
+	dev->last_scancode = scancode;
+	dev->last_toggle = toggle;
+	dev->last_keycode = keycode;
+
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
 		dev->keypressed = true;
-		dev->last_protocol = protocol;
-		dev->last_scancode = scancode;
-		dev->last_toggle = toggle;
-		dev->last_keycode = keycode;
 
 		IR_dprintk(1, "%s: key down event, key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
 			   dev->device_name, keycode, protocol, scancode);
-- 
2.13.6
