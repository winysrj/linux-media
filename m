Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:35089 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab1KPPHE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 10:07:04 -0500
Message-ID: <4EC3D18A.1060402@linuxtv.org>
Date: Wed, 16 Nov 2011 16:06:50 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, TerraTux@terratec.de
Subject: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Can receive DVB-C and DVB-T. No analogue television or radio yet.
- For now it's a copy of the Terratec H5 code with a different name.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 linux/drivers/media/video/em28xx/em28xx-cards.c |   15 +++++++++++++++
 linux/drivers/media/video/em28xx/em28xx-dvb.c   |    1 +
 linux/drivers/media/video/em28xx/em28xx.h       |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/linux/drivers/media/video/em28xx/em28xx-cards.c b/linux/drivers/media/video/em28xx/em28xx-cards.c
index 9b747c2..03322d0 100644
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -892,6 +892,19 @@ struct em28xx_board em28xx_boards[] = {
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	[EM2884_BOARD_CINERGY_HTC_STICK] = {
+		.name         = "Terratec Cinergy HTC Stick",
+		.has_dvb      = 1,
+#if 0
+		.tuner_type   = TUNER_PHILIPS_TDA8290,
+		.tuner_addr   = 0x41,
+		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
+		.tuner_gpio   = terratec_h5_gpio,
+#endif
+		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
 		.name         = "Hauppauge WinTV HVR 900",
 		.tda9887_conf = TDA9887_PRESENT,
@@ -1925,6 +1938,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2860_BOARD_TERRATEC_GRABBY },
 	{ USB_DEVICE(0x0ccd, 0x10AF),
 			.driver_info = EM2860_BOARD_TERRATEC_GRABBY },
+	{ USB_DEVICE(0x0ccd, 0x00b2),
+			.driver_info = EM2884_BOARD_CINERGY_HTC_STICK },
 	{ USB_DEVICE(0x0fd9, 0x0033),
 			.driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
 	{ USB_DEVICE(0x185b, 0x2870),
diff --git a/linux/drivers/media/video/em28xx/em28xx-dvb.c b/linux/drivers/media/video/em28xx/em28xx-dvb.c
index cef7a2d..270cb98 100644
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c
@@ -789,6 +789,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	case EM2884_BOARD_TERRATEC_H5:
+	case EM2884_BOARD_CINERGY_HTC_STICK:
 		terratec_h5_init(dev);
 
 		dvb->dont_attach_fe1 = 1;
diff --git a/linux/drivers/media/video/em28xx/em28xx.h b/linux/drivers/media/video/em28xx/em28xx.h
index 2a2cb7e..5d763f7 100644
--- a/linux/drivers/media/video/em28xx/em28xx.h
+++ b/linux/drivers/media/video/em28xx/em28xx.h
@@ -121,6 +121,7 @@
 #define EM28174_BOARD_PCTV_290E                   78
 #define EM2884_BOARD_TERRATEC_H5		  79
 #define EM28174_BOARD_PCTV_460E                   80
+#define EM2884_BOARD_CINERGY_HTC_STICK		  81
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
