Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55339
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751130AbdH0MGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 08:06:01 -0400
Date: Sun, 27 Aug 2017 09:05:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: panic <lists@xandea.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [em28xx] add config for em28xx-based board by MAGIX
Message-ID: <20170827090553.5e7ab121@vento.lan>
In-Reply-To: <592d2d47-df0a-2f60-0667-edf776218bd4@xandea.de>
References: <592d2d47-df0a-2f60-0667-edf776218bd4@xandea.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Aug 2017 12:11:00 +0000
panic <lists@xandea.de> escreveu:

> Hi,
> 
> the patch below adds the entries to the config arrays for a capture-only
> board distributed by MAGIX [0]. The hardware itself (EM2860, SAA7113,
> EMP202) is already supported.

> This patch lacks the configuration for the GPIO pin, because I had/have
> no time yet to figure out how it works. Video and audio work fine for me
> in mplayer/mencoder.

You may won't need to touch it. Several capture-only boards just don't
use GPIO at all. That's easy to test: just connect the hardware on your
machine with Linux booted with the driver. If it works as-is, you
won't need to touch GPIOs. If, on the other hand, you need to first
boot it with the original driver and reboot linux, then you'll need
to sniff what the original driver is doing with regards to GPIO.

> The patch works against Linux 4.9.0 from Debian stretch/stable.
> 
> This is my first kernel submission, so tell me if you need more info or
> if something should be changed. Thanks!
> 
> Cheers,
> panic
> 
> [0] contains not much info, but for the record:
>     http://www.magix.com/gb/rescue-your-videotapes/

The patch itself is OK, except that it should be based on upstream
Kernel (although I can easily rebase it, as the enclosed version).

The main issue with it is that you need to follow the
submission rules of the Kernel. In particular, all patches
should contain your real name and a Signed-off-by with it, as
stated at:

	https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

As reference, I enclosed how the patch should like, rebased to
the upstream Kernel version. You'll need to put your real name
on it.

Thanks,
Mauro


-

[em28xx] add config for em28xx-based board by MAGIX

From: your real name <lists@xandea.de>

Adds the entries to the config arrays for a capture-only board 
distributed by MAGIX [0]. The hardware itself (EM2860, SAA7113,
EMP202) is already supported.

[0] contains not much info, but for the record:
    http://www.magix.com/gb/rescue-your-videotapes/

Signed-off-by: your real name <lists@xandea.de>


---
 drivers/media/usb/em28xx/em28xx-cards.c |   20 ++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 2 files changed, 21 insertions(+)

--- patchwork.orig/drivers/media/usb/em28xx/em28xx-cards.c
+++ patchwork/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2421,6 +2421,24 @@ struct em28xx_board em28xx_boards[] = {
 		.ir_codes      = RC_MAP_HAUPPAUGE,
 		.leds          = hauppauge_dualhd_leds,
 	},
+	/*
+	 * 1b80:e349 MAGIX "Rescue your Videotapes!"
+	 * Empia EM2860, Philips SAA7113, Empia EMP202, No Tuner
+	 */
+	[EM2860_BOARD_MAGIX] = {
+		.name         = "MAGIX",
+		.tuner_type   = TUNER_ABSENT,
+		.decoder      = EM28XX_SAA711X,
+		.input        = { {
+			.type     = EM28XX_VMUX_COMPOSITE,
+			.vmux     = SAA7115_COMPOSITE0,
+			.amux     = EM28XX_AMUX_AUX,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = SAA7115_SVIDEO3,
+			.amux     = EM28XX_AMUX_AUX,
+		} },
+	},
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
@@ -2620,6 +2638,8 @@ struct usb_device_id em28xx_id_table[] =
 			.driver_info = EM28178_BOARD_PLEX_PX_BCUD },
 	{ USB_DEVICE(0xeb1a, 0x5051), /* Ion Video 2 PC MKII / Startech svid2usb23 / Raygo R12-41373 */
 			.driver_info = EM2860_BOARD_TVP5150_REFERENCE_DESIGN },
+	{ USB_DEVICE(0x1b80, 0xe349),
+			.driver_info = EM2860_BOARD_MAGIX },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
--- patchwork.orig/drivers/media/usb/em28xx/em28xx.h
+++ patchwork/drivers/media/usb/em28xx/em28xx.h
@@ -149,6 +149,7 @@
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
 #define EM2884_BOARD_TERRATEC_H6		  101
+#define EM2860_BOARD_MAGIX                        102
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
