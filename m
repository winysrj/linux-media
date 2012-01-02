Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:54603
	"EHLO qmta05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060Ab2ABUV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jan 2012 15:21:27 -0500
Message-ID: <1325535344.20579.33.camel@localhost.localdomain>
Subject: [resend][patch] em28xx: Add Plextor ConvertX PX-AV100U to
 em28xx-cards.c
From: Don Kramer <dgkramer@comcast.net>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Date: Mon, 02 Jan 2012 15:15:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This a followup to my already submitted patch 9280, which has the right
margins truncated (therefore I am resubmitting from my Comcast account
configured with a POP3 client, instead of Gmail's web interface). 

This adds support for the Plextor ConvertX PX-AV100U, which uses the
eMPIA EM2820 chip.  The device has a device_id of '0x093b, 0xa003'.  I
am using the existing EM2820_BOARD_PINNACLE_DVC_90 board profile, as
the Pinnacle Dazzle DVC 90/100/101/107, Kaiser Baas Video to DVD
maker, and Kworld DVD Maker 2 were already mapped to it.  Some more
background on the device and my testing can be found at
http://www.donkramer.net/plextor_122710.pdf

Signed-off-by: Don Kramer <dgkramer@comcast.net>
---
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 6cab22d..b30ea94 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1270,7 +1270,7 @@ struct em28xx_board em28xx_boards[] = {
        },
        [EM2820_BOARD_PINNACLE_DVC_90] = {
                .name         = "Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker "
-                               "/ Kworld DVD Maker 2",
+                               "/ Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U",
                .tuner_type   = TUNER_ABSENT, /* capture only board */
                .decoder      = EM28XX_SAA711X,
                .input        = { {
@@ -2019,6 +2019,8 @@ struct usb_device_id em28xx_id_table[] = {
                        .driver_info = EM2880_BOARD_PINNACLE_PCTV_HD_PRO },
        { USB_DEVICE(0x0413, 0x6023),
                        .driver_info = EM2800_BOARD_LEADTEK_WINFAST_USBII },
+       { USB_DEVICE(0x093b, 0xa003),
+                       .driver_info = EM2820_BOARD_PINNACLE_DVC_90 },
        { USB_DEVICE(0x093b, 0xa005),
                        .driver_info = EM2861_BOARD_PLEXTOR_PX_TV100U },
        { USB_DEVICE(0x04bb, 0x0515),
---


