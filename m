Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54483 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAPW41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 17:56:27 -0500
Received: by mail-we0-f174.google.com with SMTP id x55so3822743wes.19
        for <linux-media@vger.kernel.org>; Thu, 16 Jan 2014 14:56:26 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org
Subject: [PATCH] media: rc: only turn on LED if keypress generated
Date: Thu, 16 Jan 2014 22:56:22 +0000
Message-Id: <1389912982-25956-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since v3.12, specifically 153a60bb0fac ([media] rc: add feedback led
trigger for rc keypresses), an LED trigger is activated on IR keydown
whether or not a keypress is generated (i.e. even if there's no matching
keycode). However the repeat and keyup logic isn't used unless there is
a keypress, which results in non-keypress keydown events turning on the
LED and not turning it off again.

On the assumption that the intent was for the LED only to light up on
valid key presses (you probably don't want it lighting up for the wrong
remote control for example), move the led_trigger_event() call inside
the keycode check.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
Was that the original intent? If not it could be tweaked to set
dev->keypressed in either case instead, so that they LED trigger works
for unmapped scancodes too.
---
 drivers/media/rc/rc-main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 46da365..cff9d53 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -649,9 +649,10 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			   "key 0x%04x, scancode 0x%04x\n",
 			   dev->input_name, keycode, scancode);
 		input_report_key(dev->input_dev, keycode, 1);
+
+		led_trigger_event(led_feedback, LED_FULL);
 	}
 
-	led_trigger_event(led_feedback, LED_FULL);
 	input_sync(dev->input_dev);
 }
 
-- 
1.8.3.2

