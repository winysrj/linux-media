Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48399 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1JCWf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 18:35:56 -0400
Received: by wwn22 with SMTP id 22so4074756wwn.1
        for <linux-media@vger.kernel.org>; Mon, 03 Oct 2011 15:35:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Oct 2011 00:35:54 +0200
Message-ID: <CAOFy8xaZzmV=jQnT4E7LqE6WJXMr1bw=+ef+ufnKah_BgZ=LQA@mail.gmail.com>
Subject: [BUG] ir-mce_kbd-decoder keyboard repeat issue
From: Ryan Reading <ryanr23@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I originally fixed some bugs on the original lirc_mod_mce driver that
Jon Davies was hosting, but found myself without a working keyboard
after upgrading to Ubuntu Natty with the new ir-core.  I just quckly
backported the ir-mce_kbd-decoder driver that Jarod Wilson posted a
while back for my Ubuntu box running 2.6.38.

http://git.linuxtv.org/media_tree.git/history/refs/heads/staging/for_v3.1:/drivers/media/rc/ir-mce_kbd-decoder.c

After porting, I discovered the keyboard repeat logic is broken.  The
keyboard repeat delay or interval isn't working properly, which makes
typing on the keyboard about impossible.  The repeat delay isn't being
respected, so you often get double characters when typing if you hold
a key just a bit too long (over 100ms, repeat delay is usually 250ms).
 When you hold a key down to get repeats, however, the repeat is very
slow.

The two changes I made were:

1.  Keep track of the last scancode and only report the event to the
input subsystem if it has changed.  (Not sure if this is actually
necessary as input.c might sort it all out, I'm not sure).
2.  Don't use the rc_dev timeout for the key up timeout.  The timeout
for the IR reciever has nothing to do with the rate at which the MCE
keyboard sends key press events, so this seems to be invalid.  In
fact, the timeout from my rc device was 1000000 ns (1ms) which meant a
key up event was occurring almost immediately. From my testing, the
keyboard will send events every 100ms, so I made the timeout 150ms and
everything seems to work great.

Here's the patch.  It's not clean/final (and is missing a couple
irrelavent lines for my Ubuntu module), but I wanted to get some
feedback to validate this.

@@ -44,6 +45,7 @@
 #define MCIR2_KEYBOARD_HEADER    0x4
 #define MCIR2_MOUSE_HEADER    0x1
 #define MCIR2_MASK_KEYS_START    0xe0
+#define MCIR2_RX_TIMEOUT_MS     150

 enum mce_kbd_mode {
     MCIR2_MODE_KEYBOARD,
@@ -121,6 +123,9 @@
     int i;
     unsigned char maskcode;

+    if( mce_kbd->last_scancode == 0 )
+        return;
+
     IR_dprintk(2, "timer callback clearing all keys\n");

     for (i = 0; i < 7; i++) {

@@ -322,13 +327,28 @@
         case MCIR2_KEYBOARD_NBITS:
             scancode = data->body & 0xffff;
             IR_dprintk(1, "keyboard data 0x%08x\n", data->body);
-            if (dev->timeout)
+            IR_dprintk(1, "keyboard timeout %d us\n", dev->timeout);
+
+            /* The IR device timeout has nothing to do with the
keyboard timing, so
+                           I'm not sure why we would use that here.
>From observation, the keyboard
+                           seems to send events at most once every
100ms.  Let's be optimistic and timeout
+                           after MCIR2_RX_TIMEOUT_MS (150ms) only if
we don't recieve a valid keyup. */
+            /*if (dev->timeout)
                 delay = usecs_to_jiffies(dev->timeout / 1000);
             else
-                delay = msecs_to_jiffies(100);
+                delay = msecs_to_jiffies(100);*/
+            delay = msecs_to_jiffies(MCIR2_RX_TIMEOUT_MS);
+
             mod_timer(&data->rx_timeout, jiffies + delay);
-            /* Pass data to keyboard buffer parser */
-            ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+
+            /* Only process keypress data if it has changed to allow kernel
+               keyboard repeat logic to work */
+            if( scancode != data->last_scancode )
+            {
+                /* Pass data to keyboard buffer parser */
+                ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+                data->last_scancode = scancode;
+            }
             break;
         case MCIR2_MOUSE_NBITS:
             scancode = data->body & 0x1fffff;
@@ -356,7 +376,7 @@
