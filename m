Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38104 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825Ab1FWSkS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 14:40:18 -0400
Received: by pzk9 with SMTP id 9so1340804pzk.19
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 11:40:17 -0700 (PDT)
Date: Thu, 23 Jun 2011 11:40:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jeff Brown <jeffbrown@android.com>
Subject: Re: [PATCH] [media] rc: call input_sync after scancode reports
Message-ID: <20110623183957.GC14950@core.coreip.homeip.net>
References: <1308851886-4607-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308851886-4607-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jarod,

On Thu, Jun 23, 2011 at 01:58:06PM -0400, Jarod Wilson wrote:
> @@ -623,6 +624,7 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
>  			  u32 keycode, u8 toggle)
>  {
>  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
> +	input_sync(dev->input_dev);
>  
>  	/* Repeat event? */
>  	if (dev->keypressed &&

It looks like we would be issuing up to 3 input_sync() for a single
keypress... Order of events is wrong too (we first issue MSC_SCAN for
new key and then release old key). How about we change it a bit like in
the patch below?

-- 
Dmitry


Input: rc - call input_sync after scancode reports

From: Jarod Wilson <jarod@redhat.com>

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
that it never caused any function difference until the referenced change
went into the input layer.

Reported-by: Stephan Raue <sraue@openelec.tv>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jeff Brown <jeffbrown@android.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/media/rc/rc-main.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)


diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f57cd56..237cf84 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -597,6 +597,7 @@ void rc_repeat(struct rc_dev *dev)
 	spin_lock_irqsave(&dev->keylock, flags);
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
+	input_sync(dev->input_dev);
 
 	if (!dev->keypressed)
 		goto out;
@@ -622,29 +623,31 @@ EXPORT_SYMBOL_GPL(rc_repeat);
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
+
+	if (new_event && dev->keypressed) {
+		/* Release old keypress */
+		IR_dprintk(1, "keyup previous key 0x%04x\n", dev->last_keycode);
+		input_report_key(dev->input_dev, dev->last_keycode, 0);
+		dev->keypressed = false;
+	}
 
-	/* Release old keypress */
-	ir_do_keyup(dev);
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
-	dev->last_scancode = scancode;
-	dev->last_toggle = toggle;
-	dev->last_keycode = keycode;
+	if (new_event && keycode != KEY_RESERVED) {
+		/* Register a keypress */
+		dev->keypressed = true;
+		IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
+			   dev->input_name, keycode, scancode);
+		input_report_key(dev->input_dev, dev->last_keycode, 1);
 
-	if (keycode == KEY_RESERVED)
-		return;
+		dev->last_scancode = scancode;
+		dev->last_toggle = toggle;
+		dev->last_keycode = keycode;
+	}
 
-	/* Register a keypress */
-	dev->keypressed = true;
-	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		   dev->input_name, keycode, scancode);
-	input_report_key(dev->input_dev, dev->last_keycode, 1);
 	input_sync(dev->input_dev);
 }
 
