Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.13]:29379 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1ISLMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 07:12:07 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2214.sfr.fr (SMTP Server) with ESMTP id 0C8E770000F8
	for <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 13:12:04 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (48.98.30.93.rev.sfr.net [93.30.98.48])
	by msfrf2214.sfr.fr (SMTP Server) with SMTP id B361F70000AA
	for <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 13:12:03 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.98.48] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 13:12:03 +0200
Subject: RC6 decoding
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 13:12:02 +0200
Message-ID: <1316430722.1656.16.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current decoder for the RC6 IR protocol supports mode 0 (16 bit) and
mode 6A.  In mode 6A the decoder supports either 32-bit data (for
Microsoft's MCE RC) or 24 bit.

I would like to support a Sky/Sky+ standard RC which transmits RC6-6-20
i.e. 20 bit data.  The transmitted frame format is identical to the 24
bit form so I'm curious as to what remotes transmit 24 bit data or was
this an error and it should be 20?

RC6-6-20 is explained here:
http://www.guiott.com/wrc/RC6-6.html

If 24-bit mode is in use, is there a way to select between 20 and 24 bit
operation?

I made the following simple mod to ir-rc6-decoder.c and my Sky/Sky+ RCs
decode correctly (with a custom keytable):

--- a/drivers/media/rc/ir-rc6-decoder.c	2011-05-19 06:06:34.000000000 +0200
+++ b/drivers/media/rc/ir-rc6-decoder.c	2011-09-19 13:02:35.000000000 +0200
@@ -17,14 +17,14 @@
 /*
  * This decoder currently supports:
  * RC6-0-16	(standard toggle bit in header)
- * RC6-6A-24	(no toggle bit)
+ * RC6-6A-20	(no toggle bit)
  * RC6-6A-32	(MCE version with toggle bit in body)
  */
 
 #define RC6_UNIT		444444	/* us */
 #define RC6_HEADER_NBITS	4	/* not including toggle bit */
 #define RC6_0_NBITS		16
-#define RC6_6A_SMALL_NBITS	24
+#define RC6_6A_SMALL_NBITS	20
 #define RC6_6A_LARGE_NBITS	32
 #define RC6_PREFIX_PULSE	(6 * RC6_UNIT)
 #define RC6_PREFIX_SPACE	(2 * RC6_UNIT)
@@ -231,7 +231,7 @@ again:
 				scancode = data->body & ~RC6_6A_MCE_TOGGLE_MASK;
 			} else {
 				toggle = 0;
-				scancode = data->body & 0xffffff;
+				scancode = data->body;
 			}
 
 			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",


-- 
Lawrence Rust


