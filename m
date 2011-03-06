Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64064 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1CFQAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 11:00:49 -0500
Received: by bwz15 with SMTP id 15so3276220bwz.19
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2011 08:00:47 -0800 (PST)
From: Vadim Solomin <vadic052@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134-input: key up events not sent after suspend/resume
Date: Sun, 6 Mar 2011 19:00:38 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061900.38144.vadic052@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On my AverMedia AverTV Studio 507, key up events are no longer sent after
a suspend-to-disk/resume cycle, resulting in "stuck" keys.

Apparently, for key up events to be generated, a certain GPIO pin must be set. 
Currently it's set in saa7134_input_init1(), but that function is not called 
on device resume. I suggest that code be moved to __saa7134_ir_start(), which 
is called both on init and resume.

Signed-off-by: Vadim Solomin <vadic052@gmail.com>

diff -r abd3aac6644e linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Fri Jul 02 00:38:54 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Mar 06 02:57:43 2011 +0300
@@ -511,6 +511,41 @@
 	if (ir->running)
 		return 0;
 
+	/* Moved here from saa7134_input_init1() because the latter
+	 * is not called on device resume */
+	switch (dev->board) {
+	case SAA7134_BOARD_MD2819:
+	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
+	case SAA7134_BOARD_AVERMEDIA_305:
+	case SAA7134_BOARD_AVERMEDIA_307:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_507UA:
+	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
+	case SAA7134_BOARD_AVERMEDIA_M102:
+	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
+		/* Without this we won't receive key up events */
+		saa_setb(SAA7134_GPIO_GPMODE0, 0x4);
+		saa_setb(SAA7134_GPIO_GPSTATUS0, 0x4);
+		break;
+	case SAA7134_BOARD_AVERMEDIA_777:
+	case SAA7134_BOARD_AVERMEDIA_A16AR:
+		/* Without this we won't receive key up events */
+		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
+		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
+		break;
+	case SAA7134_BOARD_AVERMEDIA_A16D:
+		/* Without this we won't receive key up events */
+		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
+		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
+		break;
+	case SAA7134_BOARD_GOTVIEW_7135:
+		saa_setb(SAA7134_GPIO_GPMODE1, 0x80);
+		break;
+	}
+
 	ir->running = 1;
 	if (ir->polling) {
 		setup_timer(&ir->timer, saa7134_input_timer,
@@ -709,9 +744,7 @@
 		mask_keycode = 0x0007C8;
 		mask_keydown = 0x000010;
 		polling      = 50; // ms
-		/* Set GPIO pin2 to high to enable the IR controller */
-		saa_setb(SAA7134_GPIO_GPMODE0, 0x4);
-		saa_setb(SAA7134_GPIO_GPSTATUS0, 0x4);
+		/* GPIO stuff moved to __saa7134_ir_start() */
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
 		ir_codes     = RC_MAP_AVERMEDIA_M135A;
@@ -733,18 +766,14 @@
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; // ms
-		/* Without this we won't receive key up events */
-		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
-		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
+		/* GPIO stuff moved to __saa7134_ir_start() */
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
 		ir_codes     = RC_MAP_AVERMEDIA_A16D;
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; /* ms */
-		/* Without this we won't receive key up events */
-		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
-		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
+		/* GPIO stuff moved to __saa7134_ir_start() */
 		break;
 	case SAA7134_BOARD_KWORLD_TERMINATOR:
 		ir_codes     = RC_MAP_PIXELVIEW;
@@ -796,7 +825,7 @@
 		mask_keycode = 0x0003CC;
 		mask_keydown = 0x000010;
 		polling	     = 5; /* ms */
-		saa_setb(SAA7134_GPIO_GPMODE1, 0x80);
+		/* GPIO stuff moved to __saa7134_ir_start() */
 		break;
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:

-- 
Vadim Solomin
