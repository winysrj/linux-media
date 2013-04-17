Return-path: <linux-media-owner@vger.kernel.org>
Received: from ispconfig2.arios.fr ([176.31.95.19]:58979 "EHLO
	ispconfig2.arios.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966338Ab3DQUvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 16:51:04 -0400
Message-ID: <516F0B33.7060500@chauveau-central.net>
Date: Wed, 17 Apr 2013 22:50:59 +0200
From: Stephane Chauveau <stephane@chauveau-central.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] media:  ir-rc5-decoder: improve responsiveness by 100ms to
 250ms
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here is a patch to improve the responsiveness of the rc5 decoder when 
using the ite-cir driver. Most of the information below should also be 
applicable to other decoders and ir drivers (e.g. rc6 for sure). The 
problem is that the current decoder is subject to a double timeout:

  (a)  200ms in ite-cir (see ITE_IDLE_TIMEOUT)

  (b)  250ms in rc-main (see IR_KEYPRESS_TIMEOUT)

The timeout (a) is causing a delay of up to 200ms on the keypress events 
because STATE_FINISHED is not processed until a blank is received.
The timeout (b) is causing an additional delay of 250ms on the final keyup.

My patch is reducing those delays using two techniques:

  (1) The keypress is sent as soon as the 1st half of the last bit is 
received. This is a bi-phase encoding so the second part is not strictly 
needed to figure out the value of that last bit.

  (2) An explicit keyup in produced when the 200ms blank caused by 
timeout (a) is detected. In practice, timeout (b) never occurs.

reminder: The RC5 protocol specifies that messages shall be be repeated 
every 113ms as long as the key remains pressed.

Here are some real timings measured by adding a few printk:

For a single RC5 message the KEYDOWN and the KEYUP respectively occur 
20ms and 220ms after receiving the first pulse (versus 220ms and 470ms 
with the original decoder)

For a double RC5 message the 2 KEYDOWNs and the KEYUP events 
respectively occur 21ms, 134ms and 334ms after the first pulse (versus 
111ms, 335ms and 584ms)

For a triple RC5 message the 3 KEYDOWNs and the KEYUP events 21ms, 
134ms, 247 and 447ms after the first pulse (versus 111ms, 335ms, 448ms 
and 697ms)

Unfortunately, triple RC5 messages are quite common when using the 
remote in a nomal way and, without my patch, the delay between the first 
keydown and the final keyup is about 590ms. This is enough to cause a 
key-repeat on most systems. For instance, XBMC has an hard-coded 
key-repeat delay of 500ms and so is almost unusable without my patch.

Even with a key repeat delay set to 600ms or above, the original decoder 
feels sluggish and unreliable.

I did not try but in theory the timeout (a) could be reduced to any 
value above 134ms to make the decoder even more responsive.

Stephane.


--- ir-rc5-decoder.c.orig    2013-04-17 20:40:41.939326236 +0200
+++ ir-rc5-decoder.c    2013-04-17 21:51:40.368925128 +0200
@@ -30,11 +30,14 @@
  #define RC5_BIT_START        (1 * RC5_UNIT)
  #define RC5_BIT_END        (1 * RC5_UNIT)
  #define RC5X_SPACE        (4 * RC5_UNIT)
+#define RC5_UP_DELAY        114000000 /* ns */

  enum rc5_state {
      STATE_INACTIVE,
      STATE_BIT_START,
      STATE_BIT_END,
+    STATE_LAST_START,
+    STATE_LAST_END,
      STATE_CHECK_RC5X,
      STATE_FINISHED,
  };
@@ -99,8 +102,8 @@ again:
          if (!is_transition(&ev, &dev->raw->prev_ev))
              break;

-        if (data->count == data->wanted_bits)
-            data->state = STATE_FINISHED;
+        if (data->count == data->wanted_bits-1)
+            data->state = STATE_LAST_START;
          else if (data->count == CHECK_RC5X_NBITS)
              data->state = STATE_CHECK_RC5X;
          else
@@ -109,22 +112,16 @@ again:
          decrease_duration(&ev, RC5_BIT_END);
          goto again;

-    case STATE_CHECK_RC5X:
-        if (!ev.pulse && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT / 
2)) {
-            /* RC5X */
-            data->wanted_bits = RC5X_NBITS;
-            decrease_duration(&ev, RC5X_SPACE);
-        } else {
-            /* RC5 */
-            data->wanted_bits = RC5_NBITS;
-        }
-        data->state = STATE_BIT_START;
-        goto again;
-
-    case STATE_FINISHED:
-        if (ev.pulse)
+    case STATE_LAST_START:
+        if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
              break;

+        data->bits <<= 1;
+        if (!ev.pulse)
+            data->bits |= 1;
+        data->count++;
+        data->state = STATE_LAST_END;
+
          if (data->wanted_bits == RC5X_NBITS) {
              /* RC5X */
              u8 xdata, command, system;
@@ -160,6 +157,42 @@ again:
          }

          rc_keydown(dev, scancode, toggle);
+
+        return 0;
+
+    case STATE_LAST_END:
+        if (!is_transition(&ev, &dev->raw->prev_ev))
+            break;
+
+        data->state = STATE_FINISHED;
+
+        decrease_duration(&ev, RC5_BIT_END);
+        goto again;
+
+    case STATE_CHECK_RC5X:
+        if (!ev.pulse
+            && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT/2)) {
+            /* RC5X */
+            data->wanted_bits = RC5X_NBITS;
+            decrease_duration(&ev, RC5X_SPACE);
+        } else {
+            /* RC5 */
+            data->wanted_bits = RC5_NBITS;
+        }
+        data->state = STATE_BIT_START;
+        goto again;
+
+    case STATE_FINISHED:
+        if (ev.pulse)
+            break;
+
+        /* The message is repeated  RC5_UP_DELAY ns after the 1st pulse
+         * so a blank of RC5_UP_DELAY ns after the last pulse shall be
+         * enough to assume that the message is not repeated.
+         */
+        if (ev.duration > RC5_UP_DELAY)
+            rc_keyup(dev) ;
+
          data->state = STATE_INACTIVE;
          return 0;
      }
Signed-off-by: Stephane Chauveau <stephane@chauveau-central.net>


