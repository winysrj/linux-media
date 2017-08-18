Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout00.webspace-verkauf.de ([37.218.254.21]:36273 "EHLO
        mailout00.webspace-verkauf.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750810AbdHRMSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 08:18:41 -0400
Received: from c2.webspace-verkauf.de (c2.webspace-verkauf.de [37.218.254.102])
        by mailout00.webspace-verkauf.de (Postfix) with ESMTPS id 4F989C243B
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 14:11:39 +0200 (CEST)
From: panic <lists@xandea.de>
Subject: [PATCH] [em28xx] add config for em28xx-based board by MAGIX
To: linux-media@vger.kernel.org
Message-ID: <592d2d47-df0a-2f60-0667-edf776218bd4@xandea.de>
Date: Fri, 18 Aug 2017 12:11:00 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------FF7A35BF3E354B78094B42E8"
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------FF7A35BF3E354B78094B42E8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

the patch below adds the entries to the config arrays for a capture-only
board distributed by MAGIX [0]. The hardware itself (EM2860, SAA7113,
EMP202) is already supported.
This patch lacks the configuration for the GPIO pin, because I had/have
no time yet to figure out how it works. Video and audio work fine for me
in mplayer/mencoder.
The patch works against Linux 4.9.0 from Debian stretch/stable.

This is my first kernel submission, so tell me if you need more info or
if something should be changed. Thanks!

Cheers,
panic

[0] contains not much info, but for the record:
    http://www.magix.com/gb/rescue-your-videotapes/

--------------FF7A35BF3E354B78094B42E8
Content-Type: text/x-patch;
 name="0001-add-config-for-em28xx-based-board-by-MAGIX.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-add-config-for-em28xx-based-board-by-MAGIX.patch"

---
 drivers/media/usb/em28xx/em28xx-cards.c | 20 ++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e397f54..96afb46 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2389,6 +2389,24 @@ struct em28xx_board em28xx_boards[] = {
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
 
@@ -2582,6 +2600,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_TERRATEC_T2_STICK_HD },
 	{ USB_DEVICE(0x3275, 0x0085),
 			.driver_info = EM28178_BOARD_PLEX_PX_BCUD },
+	{ USB_DEVICE(0x1b80, 0xe349),
+			.driver_info = EM2860_BOARD_MAGIX },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index d148463..0da7f6a 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -147,6 +147,7 @@
 #define EM2884_BOARD_ELGATO_EYETV_HYBRID_2008     97
 #define EM28178_BOARD_PLEX_PX_BCUD                98
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
+#define EM2860_BOARD_MAGIX                        100
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
2.11.0


--------------FF7A35BF3E354B78094B42E8--
