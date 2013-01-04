Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab3ADVQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 16:16:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] em28xx: simplify IR names on I2C devices
Date: Fri,  4 Jan 2013 19:15:51 -0200
Message-Id: <1357334152-3811-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir-i2c-kbd already adds I2C IR before the name. The way it is,
the devices are named as:
	"i2c IR (i2c IR (EM2840 Hauppaug"
With is ugly and incorrect. After this patch, it is now properly
displayed as:
	"i2c IR (WinTV USB2)"

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 2a1b3d2..ebbb0aa 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -472,22 +472,22 @@ static void em28xx_register_i2c_ir(struct em28xx *dev)
 	case EM2820_BOARD_TERRATEC_CINERGY_250:
 		dev->init_data.ir_codes = RC_MAP_EM_TERRATEC;
 		dev->init_data.get_key = em28xx_get_key_terratec;
-		dev->init_data.name = "i2c IR (EM28XX Terratec)";
+		dev->init_data.name = "Terratec Cinergy 200/250";
 		break;
 	case EM2820_BOARD_PINNACLE_USB_2:
 		dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
 		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
-		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
+		dev->init_data.name = "Pinnacle USB2";
 		break;
 	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
 		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 		dev->init_data.get_key = em28xx_get_key_em_haup;
-		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
+		dev->init_data.name = "WinTV USB2";
 		break;
 	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
 		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
 		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
-		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
+		dev->init_data.name = "Winfast TV USBII Deluxe";
 		break;
 	}
 
-- 
1.7.11.7

