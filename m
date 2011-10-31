Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp25.services.sfr.fr ([93.17.128.118]:56288 "EHLO
	smtp25.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434Ab1JaMjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 08:39:39 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2504.sfr.fr (SMTP Server) with ESMTP id D8D1F70000E7
	for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 13:39:36 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (57.92.30.93.rev.sfr.net [93.30.92.57])
	by msfrf2504.sfr.fr (SMTP Server) with SMTP id 875197000096
	for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 13:39:36 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.92.57] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 13:39:33 +0100
Subject: [PATCH] ir-rc6-decoder: Support RC6-6A variable length data
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Jarod Wilson <jarod@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 13:39:32 +0100
Message-ID: <1320064772.1669.13.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the comments and feedback that you gave concerning this
patch.  In the light of these I have made some small changes.

In particular I would like to address Mauro's comments regarding
changing the size of a scancode to accommodate 128 bits.  I've given
this some thought and believe that leaving it at 32 bits is the best
solution.  Changing it risks breaking all sorts of code with no tangible
benefit since I've not found a RC that uses more than 32 bits.

The code now tracks frames with > 32 data bits, in order to cleanly
detect the end of frame, but now reports an error and discards the data.

Hope this meets with your approval.  The following patch is against 3.0

-- 
Lawrence

>From 2c0c28cbd750db64d7591a1d1998ac3dacc7d4db Mon Sep 17 00:00:00 2001
From: Lawrence Rust <lvr@softsystem.co.uk>
Date: Mon, 26 Sep 2011 15:21:13 +0200
Subject: [PATCH] ir-rc6-decoder: Support RC6-6A variable length body

Add support for variable length mode-6A frames which can range from
8 to 128 data bits.  See: http://slydiman.narod.ru/scr/kb/rc6.htm for
an explanation of RC6 frames.

Remove the assumption that frames are fixed length (currently either 24
or 32 data bits) and actually count the number of bits until an end of
frame marker is seen.

Currently up to 32 data bits are supported, limited by the size of scancodes
reported to userspace.  Frames with excess bits are rejected.

This change adds support for Sky/Sky+ RC's that transmit RC6-6A-24 i.e.
24 bit data.

Signed-off-by: Lawrence Rust <lvr@softsystem.co.uk>
---
 drivers/media/rc/ir-rc6-decoder.c |   67 ++++++++++++++++++++++--------------
 1 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 755dafa..3840179 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -17,24 +17,31 @@
 /*
  * This decoder currently supports:
  * RC6-0-16	(standard toggle bit in header)
+ * RC6-6A-20	(no toggle bit)
  * RC6-6A-24	(no toggle bit)
  * RC6-6A-32	(MCE version with toggle bit in body)
  */
 
-#define RC6_UNIT		444444	/* us */
+#define RC6_UNIT		444444	/* nanosecs */
 #define RC6_HEADER_NBITS	4	/* not including toggle bit */
 #define RC6_0_NBITS		16
-#define RC6_6A_SMALL_NBITS	24
-#define RC6_6A_LARGE_NBITS	32
+#define RC6_6A_32_NBITS		32
+#define RC6_6A_NBITS		128	/* Variable 8..128 */
 #define RC6_PREFIX_PULSE	(6 * RC6_UNIT)
 #define RC6_PREFIX_SPACE	(2 * RC6_UNIT)
 #define RC6_BIT_START		(1 * RC6_UNIT)
 #define RC6_BIT_END		(1 * RC6_UNIT)
 #define RC6_TOGGLE_START	(2 * RC6_UNIT)
 #define RC6_TOGGLE_END		(2 * RC6_UNIT)
+#define RC6_SUFFIX_SPACE	(6 * RC6_UNIT)
 #define RC6_MODE_MASK		0x07	/* for the header bits */
 #define RC6_STARTBIT_MASK	0x08	/* for the header bits */
 #define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */
+#define RC6_6A_LCC_MASK		0xffff0000 /* RC6-6A-32 long customer code mask */
+#define RC6_6A_MCE_CC		0x800f0000 /* MCE customer code */
+#ifndef CHAR_BIT
+#define CHAR_BIT 8	/* Normally in <limits.h> */
+#endif
 
 enum rc6_mode {
 	RC6_MODE_0,
@@ -124,6 +131,7 @@ again:
 			break;
 
 		data->state = STATE_HEADER_BIT_START;
+		data->header = 0;
 		return 0;
 
 	case STATE_HEADER_BIT_START:
@@ -170,20 +178,14 @@ again:
 		data->state = STATE_BODY_BIT_START;
 		decrease_duration(&ev, RC6_TOGGLE_END);
 		data->count = 0;
+		data->body = 0;
 
 		switch (rc6_mode(data)) {
 		case RC6_MODE_0:
 			data->wanted_bits = RC6_0_NBITS;
 			break;
 		case RC6_MODE_6A:
-			/* This might look weird, but we basically
-			   check the value of the first body bit to
-			   determine the number of bits in mode 6A */
-			if ((!ev.pulse && !geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2)) ||
-			    geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
-				data->wanted_bits = RC6_6A_LARGE_NBITS;
-			else
-				data->wanted_bits = RC6_6A_SMALL_NBITS;
+			data->wanted_bits = RC6_6A_NBITS;
 			break;
 		default:
 			IR_dprintk(1, "RC6 unknown mode\n");
@@ -192,15 +194,21 @@ again:
 		goto again;
 
 	case STATE_BODY_BIT_START:
-		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
-			break;
-
-		data->body <<= 1;
-		if (ev.pulse)
-			data->body |= 1;
-		data->count++;
-		data->state = STATE_BODY_BIT_END;
-		return 0;
+		if (eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2)) {
+			/* Discard LSB's that won't fit in data->body */
+			if (data->count++ < CHAR_BIT * sizeof data->body) {
+				data->body <<= 1;
+				if (ev.pulse)
+					data->body |= 1;
+			}
+			data->state = STATE_BODY_BIT_END;
+			return 0;
+		} else if (RC6_MODE_6A == rc6_mode(data) && !ev.pulse &&
+				geq_margin(ev.duration, RC6_SUFFIX_SPACE, RC6_UNIT / 2)) {
+			data->state = STATE_FINISHED;
+			goto again;
+		}
+		break;
 
 	case STATE_BODY_BIT_END:
 		if (!is_transition(&ev, &dev->raw->prev_ev))
@@ -220,20 +228,27 @@ again:
 
 		switch (rc6_mode(data)) {
 		case RC6_MODE_0:
-			scancode = data->body & 0xffff;
+			scancode = data->body;
 			toggle = data->toggle;
 			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
 				   scancode, toggle);
 			break;
 		case RC6_MODE_6A:
-			if (data->wanted_bits == RC6_6A_LARGE_NBITS) {
-				toggle = data->body & RC6_6A_MCE_TOGGLE_MASK ? 1 : 0;
-				scancode = data->body & ~RC6_6A_MCE_TOGGLE_MASK;
+			if (data->count > CHAR_BIT * sizeof data->body) {
+				IR_dprintk(1, "RC6 too many (%u) data bits\n",
+					data->count);
+				goto out;
+			}
+
+			scancode = data->body;
+			if (data->count == RC6_6A_32_NBITS &&
+					(scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
+				/* MCE RC */
+				toggle = (scancode & RC6_6A_MCE_TOGGLE_MASK) ? 1 : 0;
+				scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
 			} else {
 				toggle = 0;
-				scancode = data->body & 0xffffff;
 			}
-
 			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",
 				   scancode, toggle);
 			break;
-- 
1.7.4.1

