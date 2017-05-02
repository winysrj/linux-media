Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47254
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751785AbdEBTQz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 15:16:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 2/2] em28xx: add support for new of Terratec H6
Date: Tue,  2 May 2017 16:16:49 -0300
Message-Id: <e80fd4519a42f7b11c0127db522da2df1639088b.1493752606.git.mchehab@s-opensource.com>
In-Reply-To: <383deb4911c305a20bfab4c9ea24aa2fb4368599.1493752606.git.mchehab@s-opensource.com>
References: <383deb4911c305a20bfab4c9ea24aa2fb4368599.1493752606.git.mchehab@s-opensource.com>
In-Reply-To: <383deb4911c305a20bfab4c9ea24aa2fb4368599.1493752606.git.mchehab@s-opensource.com>
References: <383deb4911c305a20bfab4c9ea24aa2fb4368599.1493752606.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a new version of Terratec H6 with uses USB ID
0ccd:10b2. This version is similar to the old one (with is
supported via the HTC entry), except that this one has the
eeprom on the second bus.

On this board, one side of this board is labeled with:
	dvbc v2.0
The other side with:
	94V-0, MO2, RK-4221 with huge digits: 1107

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 18 ++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 20 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a12b599a1fa2..25e952b176ae 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1193,6 +1193,22 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	[EM2884_BOARD_TERRATEC_H6] = {
+		.name         = "Terratec Cinergy H6 rev. 2",
+		.has_dvb      = 1,
+		.ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+#if 0
+		.tuner_type   = TUNER_PHILIPS_TDA8290,
+		.tuner_addr   = 0x41,
+		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
+		.tuner_gpio   = terratec_h5_gpio,
+#else
+		.tuner_type   = TUNER_ABSENT,
+#endif
+		.def_i2c_bus  = 1,
+		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 	[EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C] = {
 		.name         = "Hauppauge WinTV HVR 930C",
 		.has_dvb      = 1,
@@ -2496,6 +2512,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0x0ccd, 0x10b6),	/* H5 Rev. 3 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+	{ USB_DEVICE(0x0ccd, 0x10b2),	/* H6 */
+			.driver_info = EM2884_BOARD_TERRATEC_H6 },
 	{ USB_DEVICE(0x0ccd, 0x0084),
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
 	{ USB_DEVICE(0x0ccd, 0x0096),
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 82edd37f0d73..4a7db623fe29 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1522,6 +1522,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2884_BOARD_ELGATO_EYETV_HYBRID_2008:
 	case EM2884_BOARD_CINERGY_HTC_STICK:
+	case EM2884_BOARD_TERRATEC_H6:
 		terratec_htc_stick_init(dev);
 
 		/* attach demodulator */
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e8d97d5ec161..88084f24f033 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -148,6 +148,7 @@
 #define EM28178_BOARD_PLEX_PX_BCUD                98
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
+#define EM2884_BOARD_TERRATEC_H6		  101
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
2.9.3
