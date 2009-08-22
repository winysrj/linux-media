Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42383 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZHVRoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 13:44:30 -0400
Received: by ewy3 with SMTP id 3so1389848ewy.18
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 10:44:31 -0700 (PDT)
Message-ID: <4A902E56.9000604@gmail.com>
Date: Sat, 22 Aug 2009 19:43:50 +0200
From: Pablo Castellano <pablog.ubuntu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@infradead.org
Subject: [PATCH] Add remote support to cph03x bttv card
Content-Type: multipart/mixed;
 boundary="------------070000070806020602060604"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070000070806020602060604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello kernel developers.
I found a bug report from an user in launchpad. I just copy it here. It
includes patch.

I don't own the necessary hardware to test it but the patch looks trivial.

I'm not subscribed to this list, so please CC me. Thanks!

Here is the text:


"""
remote control for my tv card doesnt work

I have Askey CPH03x TV Capturer.
When I load bttv module with "card=59" option which is proper for this
tv card,
I can watch tv with sound but my remote control doesnt work. There is no ir
event in /proc/bus/input/device .
When bttv module is loaded with "card=137" option remote control works very
well.

$ cat /proc/bus/input/devices
.......
........
: Bus=0001 Vendor=109e Product=0350 Version=0001
N: Name="bttv IR (card=137)"
P: Phys=pci-0000:00:0d.0/ir0
S: Sysfs=/devices/pci0000:00/0000:00:0d.0/input/input144
U: Uniq=
H: Handlers=kbd event6
B: EV=100003
B: KEY=2c0814 100004 0 0 0 4 2008000 2090 2001 1e0000 4400 0 ffc

Unfortunately there is no sound.
"""

https://bugs.launchpad.net/ubuntu/+bug/239733
http://bugzilla.kernel.org/show_bug.cgi?id=11995

-- 
Regards, Pablo.

--------------070000070806020602060604
Content-Type: text/plain;
 name="kernel_add_remote_support_for_cph03x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel_add_remote_support_for_cph03x.diff"

diff -Nurp linux-source-2.6.27/drivers/media/video/bt8xx.old/bttv-cards.c linux-source-2.6.27/drivers/media/video/bt8xx/bttv-cards.c
--- linux-source-2.6.27/drivers/media/video/bt8xx.old/bttv-cards.c	2008-11-09 18:05:17.000000000 +0100
+++ linux-source-2.6.27/drivers/media/video/bt8xx/bttv-cards.c	2008-11-09 18:05:46.000000000 +0100
@@ -1362,6 +1362,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_type	= TUNER_TEMIC_PAL,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.has_remote	= 1,
 	},
 
 	/* ---- card 0x3c ---------------------------------- */
diff -Nurp linux-source-2.6.27/drivers/media/video/bt8xx.old/bttv-input.c linux-source-2.6.27/drivers/media/video/bt8xx/bttv-input.c
--- linux-source-2.6.27/drivers/media/video/bt8xx.old/bttv-input.c	2008-11-09 18:05:17.000000000 +0100
+++ linux-source-2.6.27/drivers/media/video/bt8xx/bttv-input.c	2008-11-09 18:05:39.000000000 +0100
@@ -260,6 +260,7 @@ int bttv_input_init(struct bttv *btv)
 		ir->mask_keyup   = 0x008000;
 		ir->polling      = 50; // ms
 		break;
+	case BTTV_BOARD_ASKEY_CPH03X:
 	case BTTV_BOARD_CONCEPTRONIC_CTVFMI2:
 	case BTTV_BOARD_CONTVFMI:
 		ir_codes         = ir_codes_pixelview;

--------------070000070806020602060604--
