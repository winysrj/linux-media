Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab1FWR6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 13:58:34 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jeff Brown <jeffbrown@android.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] [media] rc: call input_sync after scancode reports
Date: Thu, 23 Jun 2011 13:58:06 -0400
Message-Id: <1308851886-4607-1-git-send-email-jarod@redhat.com>
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
that it never caused any function difference until the referenced change
went into the input layer.

Reported-by: Stephan Raue <sraue@openelec.tv>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jeff Brown <jeffbrown@android.com>
CC: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/rc-main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f57cd56..c25c243 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -597,6 +597,7 @@ void rc_repeat(struct rc_dev *dev)
 	spin_lock_irqsave(&dev->keylock, flags);
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
+	input_sync(dev->input_dev);
 
 	if (!dev->keypressed)
 		goto out;
@@ -623,6 +624,7 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			  u32 keycode, u8 toggle)
 {
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
+	input_sync(dev->input_dev);
 
 	/* Repeat event? */
 	if (dev->keypressed &&
-- 
1.7.1

