Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.aziraphale.net ([213.73.99.133]:39558 "EHLO
	n099h133.rs.de.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbKOVcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 16:32:09 -0500
Received: from [192.168.178.15] (ip5f5aea20.dynamic.kabel-deutschland.de [95.90.234.32])
	by n099h133.rs.de.inter.net (Postfix) with ESMTPSA id 1B4A4A0B7F
	for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 22:24:09 +0100 (CET)
From: =?UTF-8?Q?Arno_Bauern=c3=b6ppel?= <arno@aziraphale.net>
Subject: [PATCH] Add support for dvb usb stick Hauppauge WinTV-soloHD
To: linux-media@vger.kernel.org
Message-ID: <5648F7FA.6020709@aziraphale.net>
Date: Sun, 15 Nov 2015 22:24:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the DVB-T/C/T2 usb stick WinTV-soloHD from Hauppauge.
It adds the usb ID 2040:0264 Hauppauge to the cards of the driver em28xx.

I successfully tested DVB-T/C and the IR remote control with the firmware dvb-demod-si2168-b40-01.fw.

Signed-off-by: Arno Bauernoeppel <arno@aziraphale.net>

---

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 0a46580..1c1c298 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -389,4 +389,5 @@
 #define USB_PID_PCTV_2002E_SE                           0x025d
 #define USB_PID_SVEON_STV27                             0xd3af
 #define USB_PID_TURBOX_DTT_2000                         0xd3a4
+#define USB_PID_WINTV_SOLOHD                            0x0264
 #endif
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 3940046..875f087 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2471,6 +2471,8 @@ struct usb_device_id em28xx_id_table[] = {
                        .driver_info = EM28178_BOARD_PCTV_461E },
        { USB_DEVICE(0x2013, 0x025f),
                        .driver_info = EM28178_BOARD_PCTV_292E },
+       { USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD */
+                       .driver_info = EM28178_BOARD_PCTV_292E },
        { USB_DEVICE(0x0413, 0x6f07),
                        .driver_info = EM2861_BOARD_LEADTEK_VC100 },
        { USB_DEVICE(0xeb1a, 0x8179),

