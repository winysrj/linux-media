Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51168 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755371AbeDYS7s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 14:59:48 -0400
Received: by mail-wm0-f66.google.com with SMTP id t11so2022573wmt.0
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 11:59:47 -0700 (PDT)
Received: from toshiba (90-145-46-101.wxdsl.nl. [90.145.46.101])
        by smtp.gmail.com with ESMTPSA id b43sm11279431edc.34.2018.04.25.11.59.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Apr 2018 11:59:46 -0700 (PDT)
Message-ID: <5ae0d022.eea5500a.1d4ec.2415@mx.google.com>
Date: Wed, 25 Apr 2018 20:59:46 +0200
From: mjs <mjstork@gmail.com>
To: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] [2] Add new dvb-t board ":Zolid Hybrid Tv Stick"
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=46rom 911e4ce75588f23ead083fd520a45af5336ee761 Mon Sep 17 00:00:00 2001
From: Marcel Stork <mjstork@gmail.com>
Date: Wed, 25 Apr 2018 19:49:07 +0200
Subject: [PATCH] Add new dvb-t board ":Zolid Hybrid Tv Stick".

Extra code to be able to use this stick, only digital, not analog nor remot=
e-control.

Changes to be committed:
	modified: drivers/media/usb/em28xx/em28xx-cards.c
	modified: drivers/media/usb/em28xx/em28xx-dvb.c
	modified: drivers/media/usb/em28xx/em28xx.h

Signed-off-by: Marcel Stork <mjstork@gmail.com>

---
 drivers/media/usb/em28xx/em28xx-cards.c | 30 +++++++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em=
28xx/em28xx-cards.c
index 6e0e67d2..bc8b099f 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -87,6 +87,21 @@ static const struct em28xx_reg_seq default_digital[] =3D=
 {
 	{	-1,		-1,	-1,		-1},
 };
=20
+/* Board :Zolid Hybrid Tv Stick */
+static struct em28xx_reg_seq zolid_tuner[] =3D {
+	{EM2820_R08_GPIO_CTRL,		0xfd,		0xff,	100},
+	{EM2820_R08_GPIO_CTRL,		0xfe,		0xff,	100},
+	{		-1,					-1,			-1,		 -1},
+};
+
+static struct em28xx_reg_seq zolid_digital[] =3D {
+	{EM2820_R08_GPIO_CTRL,		0x6a,		0xff,	100},
+	{EM2820_R08_GPIO_CTRL,		0x7a,		0xff,	100},
+	{EM2880_R04_GPO,			0x04,		0xff,	100},
+	{EM2880_R04_GPO,			0x0c,		0xff,	100},
+	{	-1,						-1,			-1,		 -1},
+};
+
 /* Board Hauppauge WinTV HVR 900 analog */
 static const struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] =3D {
 	{EM2820_R08_GPIO_CTRL,	0x2d,	~EM_GPIO_4,	10},
@@ -666,6 +681,16 @@ const struct em28xx_board em28xx_boards[] =3D {
 		.tuner_type    =3D TUNER_ABSENT,
 		.is_webcam     =3D 1,	/* To enable sensor probe */
 	},
+	[EM2882_BOARD_ZOLID_HYBRID_TV_STICK] =3D {
+		.name			=3D ":ZOLID HYBRID TV STICK",
+		.tuner_type		=3D TUNER_XC2028,
+		.tuner_gpio		=3D zolid_tuner,
+		.decoder		=3D EM28XX_TVP5150,
+		.xclk			=3D EM28XX_XCLK_FREQUENCY_12MHZ,
+		.mts_firmware	=3D 1,
+		.has_dvb		=3D 1,
+		.dvb_gpio		=3D zolid_digital,
+	},
 	[EM2750_BOARD_DLCW_130] =3D {
 		/* Beijing Huaqi Information Digital Technology Co., Ltd */
 		.name          =3D "Huaqi DLCW-130",
@@ -2487,7 +2512,7 @@ struct usb_device_id em28xx_id_table[] =3D {
 			.driver_info =3D EM2820_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2862),
 			.driver_info =3D EM2820_BOARD_UNKNOWN },
-	{ USB_DEVICE(0xeb1a, 0x2863),
+	{ USB_DEVICE(0xeb1a, 0x2863), /* used by :zolid hybrid tv stick */
 			.driver_info =3D EM2820_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2870),
 			.driver_info =3D EM2820_BOARD_UNKNOWN },
@@ -2688,6 +2713,7 @@ static const struct em28xx_hash_table em28xx_eeprom_h=
ash[] =3D {
 	{0xb8846b20, EM2881_BOARD_PINNACLE_HYBRID_PRO, TUNER_XC2028},
 	{0x63f653bd, EM2870_BOARD_REDDO_DVB_C_USB_BOX, TUNER_ABSENT},
 	{0x4e913442, EM2882_BOARD_DIKOM_DK300, TUNER_XC2028},
+	{0x85dd871e, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
 };
=20
 /* I2C devicelist hash table for devices with generic USB IDs */
@@ -2699,6 +2725,7 @@ static const struct em28xx_hash_table em28xx_i2c_hash=
[] =3D {
 	{0xc51200e3, EM2820_BOARD_GADMEI_TVR200, TUNER_LG_PAL_NEW_TAPC},
 	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
 	{0x6b800080, EM2874_BOARD_LEADERSHIP_ISDBT, TUNER_ABSENT},
+	{0x27e10080, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
 };
=20
 /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
@@ -3187,6 +3214,7 @@ void em28xx_setup_xc3028(struct em28xx *dev, struct x=
c2028_ctrl *ctl)
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
+	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
 		ctl->demod =3D XC3028_FE_ZARLINK456;
 		break;
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28=
xx/em28xx-dvb.c
index a54cb8dc..67b16036 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1488,6 +1488,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
 	case EM2882_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
+	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
 		dvb->fe[0] =3D dvb_attach(zl10353_attach,
 					&em28xx_zl10353_xc3028_no_i2c_gate,
 					&dev->i2c_adap[dev->def_i2c_bus]);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/e=
m28xx.h
index 63c7c612..6e44edd2 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -148,6 +148,7 @@
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
 #define EM2884_BOARD_TERRATEC_H6		  101
+#define EM2882_BOARD_ZOLID_HYBRID_TV_STICK		102
=20
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
--=20
2.11.0
