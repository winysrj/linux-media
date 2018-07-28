Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54931 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbeG1KhE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 06:37:04 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH] media: rc: read out of bounds if bpf reports high protocol number
Date: Sat, 28 Jul 2018 10:11:15 +0100
Message-Id: <20180728091115.16971-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The repeat period is read from a static array. If a keydown event is
reported from bpf with a high protocol number, we read out of bounds. This
is unlikely to end up with a reasonable repeat period at the best of times,
in which case no timely key up event is generated.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2e222d9ee01f..a24850be1f4f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -679,6 +679,14 @@ static void ir_timer_repeat(struct timer_list *t)
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 
+unsigned int repeat_period(int protocol)
+{
+	if (protocol >= ARRAY_SIZE(protocols))
+		return 100;
+
+	return protocols[protocol].repeat_period;
+}
+
 /**
  * rc_repeat() - signals that a key is still pressed
  * @dev:	the struct rc_dev descriptor of the device
@@ -691,7 +699,7 @@ void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
 	unsigned int timeout = nsecs_to_jiffies(dev->timeout) +
-		msecs_to_jiffies(protocols[dev->last_protocol].repeat_period);
+		msecs_to_jiffies(repeat_period(dev->last_protocol));
 	struct lirc_scancode sc = {
 		.scancode = dev->last_scancode, .rc_proto = dev->last_protocol,
 		.keycode = dev->keypressed ? dev->last_keycode : KEY_RESERVED,
@@ -803,7 +811,7 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
 
 	if (dev->keypressed) {
 		dev->keyup_jiffies = jiffies + nsecs_to_jiffies(dev->timeout) +
-			msecs_to_jiffies(protocols[protocol].repeat_period);
+			msecs_to_jiffies(repeat_period(protocol));
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
 	spin_unlock_irqrestore(&dev->keylock, flags);
-- 
2.17.1
