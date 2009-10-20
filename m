Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:33960 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZJTGuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 02:50:11 -0400
Received: by pxi1 with SMTP id 1so1096267pxi.33
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 23:50:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Oct 2009 17:50:15 +1100
Message-ID: <ef52a95d0910192350t457ba959x8d2f1cce82585a3b@mail.gmail.com>
Subject: Leadtek Winfast DTV-1000S remote control support
From: Michael Obst <m.obst@ugrad.unimelb.edu.au>
To: mkrufky@kernellabs.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    I've been using the testing drivers for the dtv 1000s and they
have been working great, there was no remote control support however
so after a bit of messing around I managed to patch the files and get
my remote working. The patch is below, but i'm new to the mailing list
and patches and the like so not sure if this is useful or correct, but
it works for me so I thought I would contribute it.

Cheers

diff -Naur dtv1000s-orig/linux/drivers/media/common/ir-keymaps.c
dtv1000s-remote/linux/drivers/media/common/ir-keymaps.c
--- dtv1000s-orig/linux/drivers/media/common/ir-keymaps.c	2009-10-07
21:27:39.315700245 +1100
+++ dtv1000s-remote/linux/drivers/media/common/ir-keymaps.c	2009-10-07
21:27:59.727200476 +1100
@@ -1630,6 +1630,7 @@
 	[ 0x37 ] = KEY_RADIO,         /* FM */
 	[ 0x38 ] = KEY_DVD,

+	[ 0x1a ] = KEY_MODE,		/* change to MCE mode on Y04G0051*/
 	[ 0x3e ] = KEY_F21,           /* MCE +VOL, on Y04G0033 */
 	[ 0x3a ] = KEY_F22,           /* MCE -VOL, on Y04G0033 */
 	[ 0x3b ] = KEY_F23,           /* MCE +CH,  on Y04G0033 */
diff -Naur dtv1000s-orig/linux/drivers/media/video/saa7134/saa7134-cards.c
dtv1000s-remote/linux/drivers/media/video/saa7134/saa7134-cards.c
--- dtv1000s-orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-06-20
05:22:30.000000000 +1000
+++ dtv1000s-remote/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-10-07
21:23:23.243700429 +1100
@@ -6638,6 +6638,7 @@
 	case SAA7134_BOARD_REAL_ANGEL_220:
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
+	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
diff -Naur dtv1000s-orig/linux/drivers/media/video/saa7134/saa7134-input.c
dtv1000s-remote/linux/drivers/media/video/saa7134/saa7134-input.c
--- dtv1000s-orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-06-20
05:22:30.000000000 +1000
+++ dtv1000s-remote/linux/drivers/media/video/saa7134/saa7134-input.c	2009-10-07
21:24:32.555700167 +1100
@@ -605,6 +605,12 @@
 		mask_keycode = 0x7f;
 		polling = 40; /* ms */
 		break;
+	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
+		ir_codes     = ir_codes_winfast;
+		mask_keycode = 0x5f00;
+		mask_keyup = 0x020000;
+		polling      = 50; // ms
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
