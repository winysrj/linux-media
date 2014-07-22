Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43285 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbaGVUMp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 16:12:45 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, m.chehab@samsung.com, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 8/8] cx231xx: Add [2013:025e] PCTV QuatroStick 522e
Date: Tue, 22 Jul 2014 22:12:18 +0200
Message-Id: <1406059938-21141-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware is identical to Hauppauge WinTV 930C-HD (model 1114xx)

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 0085ccd..b2fa05d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -744,7 +744,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		} },
 	},
 	[CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx] = {
-		.name = "Hauppauge WinTV 930C-HD (1114xx)",
+		.name = "Hauppauge WinTV 930C-HD (1114xx) / PCTV QuatroStick 522e",
 		.tuner_type = TUNER_ABSENT,
 		.tuner_addr = 0x60,
 		.tuner_gpio = RDE250_XCV_TUNER,
@@ -822,6 +822,9 @@ struct usb_device_id cx231xx_id_table[] = {
 	/* PCTV QuatroStick 521e */
 	{USB_DEVICE(0x2013, 0x0259),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
+	/* PCTV QuatroStick 522e */
+	{USB_DEVICE(0x2013, 0x025e),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx},
 	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
 	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
 	{USB_DEVICE(USB_VID_PIXELVIEW, 0x5014),
-- 
2.0.0

