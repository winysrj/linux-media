Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603Ab3CSRSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:18:32 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2JHIWQQ008941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 13:18:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: Add ISDB support for c3tech Digital duo
Date: Tue, 19 Mar 2013 14:18:21 -0300
Message-Id: <1363713501-27884-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an hybrid board. However, for analog, it requires
a new driver for saa7136. So, for now, let's just add
support for Digital TV.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/video4linux/CARDLIST.em28xx |  1 +
 drivers/media/usb/em28xx/Kconfig          |  1 +
 drivers/media/usb/em28xx/em28xx-cards.c   | 24 ++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c     | 26 ++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h         |  1 +
 5 files changed, 53 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index 3f12865..c591814 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -85,3 +85,4 @@
  85 -> PCTV QuatroStick (510e)                  (em2884)        [2304:0242]
  86 -> PCTV QuatroStick nano (520e)             (em2884)        [2013:0251]
  87 -> Terratec Cinergy HTC USB XS              (em2884)        [0ccd:008e,0ccd:00ac]
+ 88 -> C3 Tech Digital Duo HDTV/SDTV USB        (em2884)        [1b80:e755]
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index c754a80..ca5ee6a 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -46,6 +46,7 @@ config VIDEO_EM28XX_DVB
 	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6e62b72..46fff5c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -345,6 +345,18 @@ static struct em28xx_reg_seq pctv_460e[] = {
 	{             -1,   -1,   -1,  -1},
 };
 
+static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
+	{EM2874_R80_GPIO,	0xff,	0xff,	10},
+	{EM2874_R80_GPIO,	0xfd,	0xff,	10}, /* xc5000 reset */
+	{EM2874_R80_GPIO,	0xf9,	0xff,	35},
+	{EM2874_R80_GPIO,	0xfd,	0xff,	10},
+	{EM2874_R80_GPIO,	0xff,	0xff,	10},
+	{EM2874_R80_GPIO,	0xfe,	0xff,	10},
+	{EM2874_R80_GPIO,	0xbe,	0xff,	10},
+	{EM2874_R80_GPIO,	0xfe,	0xff,	20},
+	{ -1,			-1,	-1,	-1},
+};
+
 #if 0
 static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
@@ -978,6 +990,16 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	[EM2884_BOARD_C3TECH_DIGITAL_DUO] = {
+		.name         = "C3 Tech Digital Duo HDTV/SDTV USB",
+		.has_dvb      = 1,
+		/* FIXME: Add analog support - need a saa7136 driver */
+		.tuner_type = TUNER_ABSENT,	/* Digital-only TDA18271HD */
+		.ir_codes     = RC_MAP_EMPTY,
+		.def_i2c_bus  = 1,
+		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE,
+		.dvb_gpio     = c3tech_digital_duo_digital,
+	},
 	[EM2884_BOARD_CINERGY_HTC_STICK] = {
 		.name         = "Terratec Cinergy HTC Stick",
 		.has_dvb      = 1,
@@ -2144,6 +2166,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28174_BOARD_PCTV_460E },
 	{ USB_DEVICE(0x2040, 0x1605),
 			.driver_info = EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C },
+	{ USB_DEVICE(0x1b80, 0xe755),
+			.driver_info = EM2884_BOARD_C3TECH_DIGITAL_DUO },
 	{ USB_DEVICE(0xeb1a, 0x5006),
 			.driver_info = EM2860_BOARD_HT_VIDBOX_NW03 },
 	{ USB_DEVICE(0x1b80, 0xe309), /* Sveon STV40 */
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 98b95be..42a6a26 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -50,6 +50,7 @@
 #include "tda10071.h"
 #include "a8293.h"
 #include "qt1010.h"
+#include "mb86a20s.h"
 
 MODULE_DESCRIPTION("driver for em28xx based DVB cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
@@ -766,9 +767,25 @@ static struct zl10353_config em28xx_zl10353_no_i2c_gate_dev = {
 };
 static struct qt1010_config em28xx_qt1010_config = {
 	.i2c_address = 0x62
+};
+
+static const struct mb86a20s_config c3tech_duo_mb86a20s_config = {
+	.demod_address = 0x10,
+	.is_serial = true,
+};
+
+static struct tda18271_std_map mb86a20s_tda18271_config = {
+	.dvbt_6   = { .if_freq = 4000, .agc_mode = 3, .std = 4,
+		      .if_lvl = 1, .rfagc_top = 0x37, },
+};
 
+static struct tda18271_config c3tech_duo_tda18271_config = {
+	.std_map = &mb86a20s_tda18271_config,
+	.gate    = TDA18271_GATE_DIGITAL,
+	.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 };
 
+
 /* ------------------------------------------------------------------ */
 
 static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
@@ -1177,6 +1194,15 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 0);
 
 		break;
+	case EM2884_BOARD_C3TECH_DIGITAL_DUO:
+		dvb->fe[0] = dvb_attach(mb86a20s_attach,
+					   &c3tech_duo_mb86a20s_config,
+					   &dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0] != NULL)
+			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+				   &dev->i2c_adap[dev->def_i2c_bus],
+				   &c3tech_duo_tda18271_config);
+		break;
 	case EM28174_BOARD_PCTV_460E:
 		/* attach demod */
 		dvb->fe[0] = dvb_attach(tda10071_attach,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f6ac1df..4c667fd 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -129,6 +129,7 @@
 #define EM2884_BOARD_PCTV_510E			  85
 #define EM2884_BOARD_PCTV_520E			  86
 #define EM2884_BOARD_TERRATEC_HTC_USB_XS	  87
+#define EM2884_BOARD_C3TECH_DIGITAL_DUO		  88
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.8.1.4

