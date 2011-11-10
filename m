Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39871 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab1KJXfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:41 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3521161iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:41 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 23/25] modified em28xx-cards for pctv80e support
Date: Thu, 10 Nov 2011 17:31:43 -0600
Message-Id: <1320967905-7932-24-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/video/em28xx/em28xx-cards.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 9b747c2..550bb8e 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -195,6 +195,17 @@ static struct em28xx_reg_seq pinnacle_hybrid_pro_digital[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
+/* PCTV HD Mini (80e) GPIOs
+   0-5: not used
+   6:   demod reset, active low
+   7:   LED on, active high */
+static struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
+	{EM28XX_R06_I2C_CLK,    0x45,   0xff,		  10}, /*400 KHz*/
+	{EM2874_R80_GPIO,       0x80,   0xff,		  100},/*Demod reset*/
+	{EM2874_R80_GPIO,       0xc0,   0xff,		  10},
+	{  -1,			-1,	-1,		  -1},
+};
+
 static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_analog[] = {
 	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
 	{EM2880_R04_GPO,	0x00,	0xff,		10},
@@ -1808,6 +1819,13 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_gpio    = reddo_dvb_c_usb_box,
 		.has_dvb       = 1,
 	},
+	[EM2874_BOARD_PCTV_HD_MINI_80E] = {
+		.name         = "Pinnacle PCTV HD Mini",
+		.tuner_type   = TUNER_ABSENT,
+		.has_dvb      = 1,
+		.dvb_gpio     = em2874_pctv_80e_digital,
+		.decoder      = EM28XX_NODECODER,
+	},
 	/* 1b80:a340 - Empia EM2870, NXP TDA18271HD and LG DT3304, sold
 	 * initially as the KWorld PlusTV 340U, then as the UB435-Q.
 	 * Early variants have a TDA18271HD/C1, later ones a TDA18271HD/C2 */
@@ -1961,6 +1979,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2882_BOARD_PINNACLE_HYBRID_PRO_330E },
 	{ USB_DEVICE(0x2304, 0x0227),
 			.driver_info = EM2880_BOARD_PINNACLE_PCTV_HD_PRO },
+	{ USB_DEVICE(0x2304, 0x023f),
+			.driver_info = EM2874_BOARD_PCTV_HD_MINI_80E },
 	{ USB_DEVICE(0x0413, 0x6023),
 			.driver_info = EM2800_BOARD_LEADTEK_WINFAST_USBII },
 	{ USB_DEVICE(0x093b, 0xa005),
-- 
1.7.5.4

