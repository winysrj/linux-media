Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45366 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaHaLfe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:34 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 4/7] [media] cx231xx: Add support for Hauppauge WinTV-HVR-901H (1114xx)
Date: Sun, 31 Aug 2014 13:35:09 +0200
Message-Id: <1409484912-19300-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for:
	[2040:b139] Hauppauge WinTV HVR-901H (1114xx)

According to the inf file, the hardware is similar to [2040:b131] Hauppauge WinTV 930C-HD (model 1114xx)
The only difference is the demod Si2161 instead of Si2165 (but both are
supported by the si2165 driver).

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index a03a31a..791f00c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -744,7 +744,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		} },
 	},
 	[CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx] = {
-		.name = "Hauppauge WinTV 930C-HD (1114xx) / PCTV QuatroStick 522e",
+		.name = "Hauppauge WinTV 930C-HD (1114xx) / HVR-901H (1114xx) / PCTV QuatroStick 522e",
 		.tuner_type = TUNER_ABSENT,
 		.tuner_addr = 0x60,
 		.tuner_gpio = RDE250_XCV_TUNER,
@@ -818,6 +818,9 @@ struct usb_device_id cx231xx_id_table[] = {
 	/* Hauppauge WinTV-HVR-900-H */
 	{USB_DEVICE(0x2040, 0xb138),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
+	/* Hauppauge WinTV-HVR-901-H */
+	{USB_DEVICE(0x2040, 0xb139),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx},
 	{USB_DEVICE(0x2040, 0xb140),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xc200),
-- 
2.1.0

