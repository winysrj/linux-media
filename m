Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42593 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751399AbdHGNb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 09:31:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sean Young <sean@mess.org>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] rc-main: support CEC protocol keypress timeout
Date: Mon,  7 Aug 2017 15:31:23 +0200
Message-Id: <20170807133124.30682-2-hverkuil@xs4all.nl>
In-Reply-To: <20170807133124.30682-1-hverkuil@xs4all.nl>
References: <20170807133124.30682-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC protocol has a keypress timeout of 550ms. Add support for this.

Note: this really should be defined in a protocol struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/rc-main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a9eba0013525..073407a78f70 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -33,6 +33,9 @@
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
 
+/* The CEC protocol needs a timeout of 550 */
+#define IR_KEYPRESS_CEC_TIMEOUT 550
+
 /* Used to keep track of known keymaps */
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
@@ -622,7 +625,12 @@ void rc_repeat(struct rc_dev *dev)
 	if (!dev->keypressed)
 		goto out;
 
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	if (dev->last_protocol == RC_TYPE_CEC)
+		dev->keyup_jiffies = jiffies +
+			msecs_to_jiffies(IR_KEYPRESS_CEC_TIMEOUT);
+	else
+		dev->keyup_jiffies = jiffies +
+			msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
 	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 
 out:
@@ -692,7 +700,12 @@ void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 togg
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		if (protocol == RC_TYPE_CEC)
+			dev->keyup_jiffies = jiffies +
+				msecs_to_jiffies(IR_KEYPRESS_CEC_TIMEOUT);
+		else
+			dev->keyup_jiffies = jiffies +
+				msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
 	spin_unlock_irqrestore(&dev->keylock, flags);
-- 
2.13.2
