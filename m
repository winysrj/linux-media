Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56462 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883Ab2AAEbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 23:31:00 -0500
Received: by obcwo16 with SMTP id wo16so11043742obc.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 20:31:00 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 31 Dec 2011 23:30:59 -0500
Message-ID: <CAH3Thv0fRF+LjBkgHjXUnRD_QvYQPrgF4VxcB1qQ_80VXBkzcA@mail.gmail.com>
Subject: [PATCH] em28xx: Add Plextor ConvertX PX-AV100U to em28xx-cards.c
From: Don Kramer <donkramer@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for the Plextor ConvertX PX-AV100U, which uses the
eMPIA EM2820 chip.  The device has a device_id of '0x093b, 0xa003'.  I
am using the existing EM2820_BOARD_PINNACLE_DVC_90 board profile, as
the Pinnacle Dazzle DVC 90/100/101/107, Kaiser Baas Video to DVD
maker, and Kworld DVD Maker 2 were already mapped to it.  Some more
background on the device and my testing can be found at
http://www.donkramer.net/plextor_122710.pdf

Signed-off-by: Don Kramer <donkramer@gmail.com>
---
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em2
index 6cab22d..b30ea94 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1270,7 +1270,7 @@ struct em28xx_board em28xx_boards[] = {
        },
        [EM2820_BOARD_PINNACLE_DVC_90] = {
                .name         = "Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baa
-                               "/ Kworld DVD Maker 2",
+                               "/ Kworld DVD Maker 2 / Plextor ConvertX PX-AV10
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
--
