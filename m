Return-path: <mchehab@pedra>
Received: from smtp22.services.sfr.fr ([93.17.128.10]:9913 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab1DHMuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 08:50:51 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2219.sfr.fr (SMTP Server) with ESMTP id 0BF687000087
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 14:50:47 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (unknown [93.14.171.92])
	by msfrf2219.sfr.fr (SMTP Server) with SMTP id B69C57000086
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 14:50:46 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.14.171.92] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 14:50:46 +0200
Subject: [PATCH] Fix cx88 remote control input
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 14:50:45 +0200
Message-ID: <1302267045.1749.38.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch restores remote control input for cx2388x based boards on
Linux kernels >= 2.6.38.

After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
control input of my Hauppauge Nova-S plus was no longer functioning.  
I posted a question on this newsgroup and Mauro Carvalho Chehab gave
some helpful pointers as to the likely cause.

Turns out that there are 2 problems:

1. In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
overflow which causes IR pulse durations to be incorrectly calculated.

2. The RC5 decoder appends the system code to the scancode and passes
the combination to rc_keydown().  Unfortunately, the combined value is
then forwarded to input_event() which then fails to recognise a valid
scancode and hence no input events are generated.

I note that in commit 2997137be8eba5bf9c07a24d5fda1f4225f9ca7d, which
introduced these changes, David Härdeman changed the IR sample frequency
to a supposed 4kHz.  However, the registers dealing with IR input are
undocumented in the cx2388x datasheets and there's no publicly available
information on them.  I have to ask the question why this change was
made as it is of no apparent benefit and could have unanticipated
consequences.  IMHO that change should also be reverted unless there is
evidence to substantiate it.

Signed off by: Lawrence Rust <lvr at softsystem dot co dot uk>

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index ebdba55..c4052da 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -144,10 +144,15 @@ again:
 			system   = (data->bits & 0x007C0) >> 6;
 			toggle   = (data->bits & 0x00800) ? 1 : 0;
 			command += (data->bits & 0x01000) ? 0 : 0x40;
-			scancode = system << 8 | command;
-
-			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
-				   scancode, toggle);
+            /* Notes
+             * 1. Should filter unknown systems e.g Hauppauge use 0x1e or 0x1f
+             * 2. Don't include system in the scancode otherwise input_event()
+             *    doesn't recognise the scancode
+             */
+			scancode = command;
+
+			IR_dprintk(1, "RC5 scancode 0x%02x (system: 0x%02x toggle: %u)\n",
+				   scancode, system, toggle);
 		}
 
 		rc_keydown(dev, scancode, toggle);
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index c820e2f..7281db4 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -524,7 +524,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	for (todo = 32; todo > 0; todo -= bits) {
 		ev.pulse = samples & 0x80000000 ? false : true;
 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
-		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
+		ev.duration = bits * (NSEC_PER_SEC / (1000 * ir_samplerate)); /* NB avoid 32-bit overflow */
 		ir_raw_event_store_with_filter(ir->dev, &ev);
 		samples <<= bits;
 	}


