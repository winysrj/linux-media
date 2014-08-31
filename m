Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45361 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHaLfd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:33 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 3/7] [media] cx231xx: Add support for Hauppauge WinTV-HVR-900H (111xxx)
Date: Sun, 31 Aug 2014 13:35:08 +0200
Message-Id: <1409484912-19300-4-git-send-email-zzam@gentoo.org>
In-Reply-To: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for:
	[2040:b138] Hauppauge WinTV HVR-900H (111xxx)

The hardware is similar to [2040:b130] Hauppauge WinTV 930C-HD (model 1113xx)
The only difference is the demod Si2161 instead of Si2165 (but both are
supported by the si2165 driver).

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 8039b76..a03a31a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -705,7 +705,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		},
 	},
 	[CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx] = {
-		.name = "Hauppauge WinTV 930C-HD (1113xx) / PCTV QuatroStick 521e",
+		.name = "Hauppauge WinTV 930C-HD (1113xx) / HVR-900H (111xxx) / PCTV QuatroStick 521e",
 		.tuner_type = TUNER_NXP_TDA18271,
 		.tuner_addr = 0x60,
 		.tuner_gpio = RDE250_XCV_TUNER,
@@ -815,6 +815,9 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
 	{USB_DEVICE(0x2040, 0xb131),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx},
+	/* Hauppauge WinTV-HVR-900-H */
+	{USB_DEVICE(0x2040, 0xb138),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
 	{USB_DEVICE(0x2040, 0xb140),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xc200),
-- 
2.1.0

