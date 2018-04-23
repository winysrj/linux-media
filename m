Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45540 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeDWHSE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:18:04 -0400
Received: by mail-wr0-f196.google.com with SMTP id p5-v6so10337611wre.12
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 00:18:03 -0700 (PDT)
Message-ID: <5add88aa.47de500a.4764d.a537@mx.google.com>
Date: Mon, 23 Apr 2018 09:18:01 +0200
From: mjs <mjstork@gmail.com>
To: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "Stappers (Geert)" <stappers@stappers.nl>
Subject: How to proceed ? => [PATCH ?] EM28xx driver ?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

4 years ago I started to try to make a dvb-t ":ZOLID Hybrid TV Stick" to wo=
rk with linux.

Today there is success at least for the digital part, not the analog or rem=
ote part.

If and how to proceed adding this patch to the global source.

Greatings,
  Marcel Stork


Git result:

=46rom ccea81c2a3c6e937d304a87fad823dd557937968 Mon Sep 17 00:00:00 2001
From: mjs <mjs@toshiba>
Date: Sun, 1 Apr 2018 19:10:33 +0200
Subject: [PATCH]  Committer: mjs <mjs@toshiba>  On branch master
 zolid-em28xx-driver  Changes to be committed: 	modified:   em28xx-cards.c=
=20
 modified:   em28xx-dvb.c 	modified:   em28xx.h

---
 em28xx-cards.c | 32 +++++++++++++++++++++++++++++---
 em28xx-dvb.c   |  1 +
 em28xx.h       |  1 +
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/em28xx-cards.c b/em28xx-cards.c
index e397f54..5024dd7 100644
--- a/em28xx-cards.c
+++ b/em28xx-cards.c
@@ -92,6 +92,20 @@ static struct em28xx_reg_seq default_digital[] =3D {
 	{	-1,		-1,	-1,		-1},
 };
=20
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
 static struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] =3D {
 	{EM2820_R08_GPIO_CTRL,	0x2d,	~EM_GPIO_4,	10},
@@ -629,6 +643,17 @@ static struct em28xx_led hauppauge_dualhd_leds[] =3D {
  *  Board definitions
  */
 struct em28xx_board em28xx_boards[] =3D {
+
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
 	[EM2750_BOARD_UNKNOWN] =3D {
 		.name          =3D "EM2710/EM2750/EM2751 webcam grabber",
 		.xclk          =3D EM28XX_XCLK_FREQUENCY_20MHZ,
@@ -2421,7 +2446,7 @@ struct usb_device_id em28xx_id_table[] =3D {
 	{ USB_DEVICE(0xeb1a, 0x2881),
 			.driver_info =3D EM2820_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2883),
-			.driver_info =3D EM2820_BOARD_UNKNOWN },
+			.driver_info =3D EM2882_BOARD_ZOLID_HYBRID_TV_STICK },
 	{ USB_DEVICE(0xeb1a, 0x2868),
 			.driver_info =3D EM2820_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2875),
@@ -2599,6 +2624,7 @@ static struct em28xx_hash_table em28xx_eeprom_hash[] =
=3D {
 	{0xb8846b20, EM2881_BOARD_PINNACLE_HYBRID_PRO, TUNER_XC2028},
 	{0x63f653bd, EM2870_BOARD_REDDO_DVB_C_USB_BOX, TUNER_ABSENT},
 	{0x4e913442, EM2882_BOARD_DIKOM_DK300, TUNER_XC2028},
+	{0x85dd871e, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
 };
=20
 /* I2C devicelist hash table for devices with generic USB IDs */
@@ -2610,6 +2636,7 @@ static struct em28xx_hash_table em28xx_i2c_hash[] =3D=
 {
 	{0xc51200e3, EM2820_BOARD_GADMEI_TVR200, TUNER_LG_PAL_NEW_TAPC},
 	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
 	{0x6b800080, EM2874_BOARD_LEADERSHIP_ISDBT, TUNER_ABSENT},
+	{0x27e10080, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
 };
=20
 /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
@@ -3063,8 +3090,7 @@ void em28xx_setup_xc3028(struct em28xx *dev, struct x=
c2028_ctrl *ctl)
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
 	case EM2882_BOARD_TERRATEC_HYBRID_XS:
-		ctl->demod =3D XC3028_FE_ZARLINK456;
-		break;
+	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
diff --git a/em28xx-dvb.c b/em28xx-dvb.c
index 1a5c012..e18d048 100644
--- a/em28xx-dvb.c
+++ b/em28xx-dvb.c
@@ -1197,6 +1197,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
 	case EM2882_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
+	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
 		dvb->fe[0] =3D dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,
 					   &dev->i2c_adap[dev->def_i2c_bus]);
diff --git a/em28xx.h b/em28xx.h
index d148463..d786bfa 100644
--- a/em28xx.h
+++ b/em28xx.h
@@ -147,6 +147,7 @@
 #define EM2884_BOARD_ELGATO_EYETV_HYBRID_2008     97
 #define EM28178_BOARD_PLEX_PX_BCUD                98
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
+#define EM2882_BOARD_ZOLID_HYBRID_TV_STICK	  100
=20
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
--=20
2.11.0
