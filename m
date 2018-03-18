Return-path: <linux-media-owner@vger.kernel.org>
Received: from www242.your-server.de ([188.40.28.22]:51697 "EHLO
        www242.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbeCRNEN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Mar 2018 09:04:13 -0400
From: Rainer Keller <mail@rainerkeller.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Rainer Keller <mail@rainerkeller.de>
Subject: [PATCH] media: dvb: add alternative USB PID for Hauppauge WinTV-soloHD
Date: Sun, 18 Mar 2018 13:40:16 +0100
Message-Id: <20180318124016.2229-1-mail@rainerkeller.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer DVB receivers of this type have a different USB PID.

Signed-off-by: Rainer Keller <mail@rainerkeller.de>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 ++
 include/media/dvb-usb-ids.h             | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 34e16f6ab4ac..adb0d6b2e8a3 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2611,6 +2611,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD */
 			.driver_info = EM28178_BOARD_PCTV_292E },
+	{ USB_DEVICE(0x2040, 0x8268), /* Hauppauge WinTV-soloHD alt. PID */
+			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x0413, 0x6f07),
 			.driver_info = EM2861_BOARD_LEADTEK_VC100 },
 	{ USB_DEVICE(0xeb1a, 0x8179),
diff --git a/include/media/dvb-usb-ids.h b/include/media/dvb-usb-ids.h
index 28e2be5c8a98..f9e73b4a6e89 100644
--- a/include/media/dvb-usb-ids.h
+++ b/include/media/dvb-usb-ids.h
@@ -418,6 +418,7 @@
 #define USB_PID_SVEON_STV27                             0xd3af
 #define USB_PID_TURBOX_DTT_2000                         0xd3a4
 #define USB_PID_WINTV_SOLOHD                            0x0264
+#define USB_PID_WINTV_SOLOHD_2                          0x8268
 #define USB_PID_EVOLVEO_XTRATV_STICK			0xa115
 #define USB_PID_HAMA_DVBT_HYBRID			0x2758
 #define USB_PID_XBOX_ONE_TUNER                          0x02d5
-- 
2.16.1
