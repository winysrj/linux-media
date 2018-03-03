Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54735 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752306AbeCCUvZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:25 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/11] media: em28xx-cards: fix most coding style issues
Date: Sat,  3 Mar 2018 17:51:07 -0300
Message-Id: <58ce7247f55275a70384f57b1c853f1a3bb5d14d.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of coding style issues, pointed by checkpatch
on strict mode.

Fix the ones that don't require code refactor here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 305 +++++++++++++++++++-------------
 1 file changed, 181 insertions(+), 124 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 474e3effdb88..01675f577008 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -36,7 +36,6 @@
 #include <media/v4l2-common.h>
 #include <sound/ac97_codec.h>
 
-
 #define DRIVER_NAME         "em28xx"
 
 static int tuner = -1;
@@ -116,11 +115,6 @@ static const struct em28xx_reg_seq em2880_msi_digivox_ad_analog[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
-/* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
-
-/* Board  - EM2870 Kworld 355u
-   Analog - No input analog */
-
 /* Board - EM2882 Kworld 315U digital */
 static const struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
 	{EM2820_R08_GPIO_CTRL,	0xff,	0xff,		10},
@@ -151,11 +145,12 @@ static const struct em28xx_reg_seq kworld_330u_digital[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
-/* Evga inDtube
-   GPIO0 - Enable digital power (s5h1409) - low to enable
-   GPIO1 - Enable analog power (tvp5150/emp202) - low to enable
-   GPIO4 - xc3028 reset
-   GOP3  - s5h1409 reset
+/*
+ * Evga inDtube
+ * GPIO0 - Enable digital power (s5h1409) - low to enable
+ * GPIO1 - Enable analog power (tvp5150/emp202) - low to enable
+ * GPIO4 - xc3028 reset
+ * GOP3  - s5h1409 reset
  */
 static const struct em28xx_reg_seq evga_indtube_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0x79,   0xff,		60},
@@ -218,10 +213,12 @@ static const struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
-/* PCTV HD Mini (80e) GPIOs
-   0-5: not used
-   6:   demod reset, active low
-   7:   LED on, active high */
+/*
+ * PCTV HD Mini (80e) GPIOs
+ * 0-5: not used
+ * 6:   demod reset, active low
+ * 7:   LED on, active high
+ */
 static const struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
 	{EM28XX_R06_I2C_CLK,    0x45,   0xff,		  10}, /*400 KHz*/
 	{EM2874_R80_GPIO_P0_CTRL, 0x00,   0xff,		  100},/*Demod reset*/
@@ -229,9 +226,11 @@ static const struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
 	{  -1,			-1,	-1,		  -1},
 };
 
-/* eb1a:2868 Reddo DVB-C USB TV Box
-   GPIO4 - CU1216L NIM
-   Other GPIOs seems to be don't care. */
+/*
+ * eb1a:2868 Reddo DVB-C USB TV Box
+ * GPIO4 - CU1216L NIM
+ * Other GPIOs seems to be don't care.
+ */
 static const struct em28xx_reg_seq reddo_dvb_c_usb_box[] = {
 	{EM2820_R08_GPIO_CTRL,	0xfe,	0xff,		10},
 	{EM2820_R08_GPIO_CTRL,	0xde,	0xff,		10},
@@ -310,7 +309,8 @@ static const struct em28xx_reg_seq leadership_reset[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-/* 2013:024f PCTV nanoStick T2 290e
+/*
+ * 2013:024f PCTV nanoStick T2 290e
  * GPIO_6 - demod reset
  * GPIO_7 - LED
  */
@@ -338,7 +338,8 @@ static const struct em28xx_reg_seq terratec_h5_digital[] = {
 };
 #endif
 
-/* 2013:024f PCTV DVB-S2 Stick 460e
+/*
+ * 2013:024f PCTV DVB-S2 Stick 460e
  * GPIO_0 - POWER_ON
  * GPIO_1 - BOOST
  * GPIO_2 - VUV_LNB (red LED)
@@ -408,7 +409,8 @@ static const struct em28xx_reg_seq hauppauge_930c_digital[] = {
 };
 #endif
 
-/* 1b80:e425 MaxMedia UB425-TC
+/*
+ * 1b80:e425 MaxMedia UB425-TC
  * 1b80:e1cc Delock 61959
  * GPIO_6 - demod reset, 0=active
  * GPIO_7 - LED, 0=active
@@ -420,7 +422,8 @@ static const struct em28xx_reg_seq maxmedia_ub425_tc[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-/* 2304:0242 PCTV QuatroStick (510e)
+/*
+ * 2304:0242 PCTV QuatroStick (510e)
  * GPIO_2: decoder reset, 0=active
  * GPIO_4: decoder suspend, 0=active
  * GPIO_6: demod reset, 0=active
@@ -433,7 +436,8 @@ static const struct em28xx_reg_seq pctv_510e[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-/* 2013:0251 PCTV QuatroStick nano (520e)
+/*
+ * 2013:0251 PCTV QuatroStick nano (520e)
  * GPIO_2: decoder reset, 0=active
  * GPIO_4: decoder suspend, 0=active
  * GPIO_6: demod reset, 0=active
@@ -447,7 +451,8 @@ static const struct em28xx_reg_seq pctv_520e[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
-/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
+/*
+ * 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
  * reg 0x80/0x84:
  * GPIO_0: capturing LED, 0=on, 1=off
  * GPIO_2: AV mute button, 0=pressed, 1=unpressed
@@ -1432,9 +1437,11 @@ const struct em28xx_board em28xx_boards[] = {
 			.gpio     = default_analog,
 		} },
 	},
-	/* maybe there's a reason behind it why Terratec sells the Hybrid XS
-	   as Prodigy XS with a different PID, let's keep it separated for now
-	   maybe we'll need it lateron */
+	/*
+	 * maybe there's a reason behind it why Terratec sells the Hybrid XS
+	 * as Prodigy XS with a different PID, let's keep it separated for now
+	 * maybe we'll need it later on
+	 */
 	[EM2880_BOARD_TERRATEC_PRODIGY_XS] = {
 		.name         = "Terratec Prodigy XS",
 		.tuner_type   = TUNER_XC2028,
@@ -1778,8 +1785,9 @@ const struct em28xx_board em28xx_boards[] = {
 		.ir_codes	= RC_MAP_KWORLD_315U,
 		.xclk		= EM28XX_XCLK_FREQUENCY_12MHZ,
 		.i2c_speed	= EM28XX_I2C_CLK_WAIT_ENABLE,
-		/* Analog mode - still not ready */
-		/*.input        = { {
+#if 0
+		/* FIXME: Analog mode - still not ready */
+		.input        = { {
 			.type = EM28XX_VMUX_TELEVISION,
 			.vmux = SAA7115_COMPOSITE2,
 			.amux = EM28XX_AMUX_VIDEO,
@@ -1797,7 +1805,8 @@ const struct em28xx_board em28xx_boards[] = {
 			.amux = EM28XX_AMUX_LINE_IN,
 			.gpio = em2882_kworld_315u_analog1,
 			.aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
-		} }, */
+		} },
+#endif
 	},
 	[EM2880_BOARD_EMPIRE_DUAL_TV] = {
 		.name = "Empire dual TV",
@@ -2158,17 +2167,21 @@ const struct em28xx_board em28xx_boards[] = {
 			.gpio     = evga_indtube_analog,
 		} },
 	},
-	/* eb1a:2868 Empia EM2870 + Philips CU1216L NIM (Philips TDA10023 +
-	   Infineon TUA6034) */
+	/*
+	 * eb1a:2868 Empia EM2870 + Philips CU1216L NIM
+	 * (Philips TDA10023 + Infineon TUA6034)
+	 */
 	[EM2870_BOARD_REDDO_DVB_C_USB_BOX] = {
 		.name          = "Reddo DVB-C USB TV Box",
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = reddo_dvb_c_usb_box,
 		.has_dvb       = 1,
 	},
-	/* 1b80:a340 - Empia EM2870, NXP TDA18271HD and LG DT3304, sold
+	/*
+	 * 1b80:a340 - Empia EM2870, NXP TDA18271HD and LG DT3304, sold
 	 * initially as the KWorld PlusTV 340U, then as the UB435-Q.
-	 * Early variants have a TDA18271HD/C1, later ones a TDA18271HD/C2 */
+	 * Early variants have a TDA18271HD/C1, later ones a TDA18271HD/C2
+	 */
 	[EM2870_BOARD_KWORLD_A340] = {
 		.name       = "KWorld PlusTV 340U or UB435-Q (ATSC)",
 		.tuner_type = TUNER_ABSENT,	/* Digital-only TDA18271HD */
@@ -2176,30 +2189,38 @@ const struct em28xx_board em28xx_boards[] = {
 		.dvb_gpio   = kworld_a340_digital,
 		.tuner_gpio = default_tuner_gpio,
 	},
-	/* 2013:024f PCTV nanoStick T2 290e.
-	 * Empia EM28174, Sony CXD2820R and NXP TDA18271HD/C2 */
+	/*
+	 * 2013:024f PCTV nanoStick T2 290e.
+	 * Empia EM28174, Sony CXD2820R and NXP TDA18271HD/C2
+	 */
 	[EM28174_BOARD_PCTV_290E] = {
 		.name          = "PCTV nanoStick T2 290e",
 		.def_i2c_bus   = 1,
-		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_100_KHZ,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				 EM28XX_I2C_FREQ_100_KHZ,
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = pctv_290e,
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
-	/* 2013:024f PCTV DVB-S2 Stick 460e
-	 * Empia EM28174, NXP TDA10071, Conexant CX24118A and Allegro A8293 */
+	/*
+	 * 2013:024f PCTV DVB-S2 Stick 460e
+	 * Empia EM28174, NXP TDA10071, Conexant CX24118A and Allegro A8293
+	 */
 	[EM28174_BOARD_PCTV_460E] = {
 		.def_i2c_bus   = 1,
-		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				 EM28XX_I2C_FREQ_400_KHZ,
 		.name          = "PCTV DVB-S2 Stick (460e)",
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = pctv_460e,
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
-	/* eb1a:5006 Honestech VIDBOX NW03
-	 * Empia EM2860, Philips SAA7113, Empia EMP202, No Tuner */
+	/*
+	 * eb1a:5006 Honestech VIDBOX NW03
+	 * Empia EM2860, Philips SAA7113, Empia EMP202, No Tuner
+	 */
 	[EM2860_BOARD_HT_VIDBOX_NW03] = {
 		.name                = "Honestech Vidbox NW03",
 		.tuner_type          = TUNER_ABSENT,
@@ -2210,12 +2231,14 @@ const struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
-			.vmux     = SAA7115_SVIDEO3,  /* S-VIDEO needs confirming */
+			.vmux     = SAA7115_SVIDEO3,  /* S-VIDEO needs check */
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
-	/* 1b80:e425 MaxMedia UB425-TC
-	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2 */
+	/*
+	 * 1b80:e425 MaxMedia UB425-TC
+	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2
+	 */
 	[EM2874_BOARD_MAXMEDIA_UB425_TC] = {
 		.name          = "MaxMedia UB425-TC",
 		.tuner_type    = TUNER_ABSENT,
@@ -2226,8 +2249,10 @@ const struct em28xx_board em28xx_boards[] = {
 		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
-	/* 2304:0242 PCTV QuatroStick (510e)
-	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
+	/*
+	 * 2304:0242 PCTV QuatroStick (510e)
+	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2
+	 */
 	[EM2884_BOARD_PCTV_510E] = {
 		.name          = "PCTV QuatroStick (510e)",
 		.tuner_type    = TUNER_ABSENT,
@@ -2238,8 +2263,10 @@ const struct em28xx_board em28xx_boards[] = {
 		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
-	/* 2013:0251 PCTV QuatroStick nano (520e)
-	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
+	/*
+	 * 2013:0251 PCTV QuatroStick nano (520e)
+	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2
+	 */
 	[EM2884_BOARD_PCTV_520E] = {
 		.name          = "PCTV QuatroStick nano (520e)",
 		.tuner_type    = TUNER_ABSENT,
@@ -2259,9 +2286,11 @@ const struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
-	/* 1b80:e1cc Delock 61959
+	/*
+	 * 1b80:e1cc Delock 61959
 	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2
-	 * mostly the same as MaxMedia UB-425-TC but different remote */
+	 * mostly the same as MaxMedia UB-425-TC but different remote
+	 */
 	[EM2874_BOARD_DELOCK_61959] = {
 		.name          = "Delock 61959",
 		.tuner_type    = TUNER_ABSENT,
@@ -2307,8 +2336,10 @@ const struct em28xx_board em28xx_boards[] = {
 		.ir_codes     = RC_MAP_PINNACLE_PCTV_HD,
 		.leds         = pctv_80e_leds,
 	},
-	/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
-	 * Empia EM2765 + OmniVision OV2640 */
+	/*
+	 * 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
+	 * Empia EM2765 + OmniVision OV2640
+	 */
 	[EM2765_BOARD_SPEEDLINK_VAD_LAPLACE] = {
 		.name         = "SpeedLink Vicious And Devine Laplace webcam",
 		.xclk         = EM28XX_XCLK_FREQUENCY_24MHZ,
@@ -2325,23 +2356,29 @@ const struct em28xx_board em28xx_boards[] = {
 		.buttons = speedlink_vad_laplace_buttons,
 		.leds = speedlink_vad_laplace_leds,
 	},
-	/* 2013:0258 PCTV DVB-S2 Stick (461e)
-	 * Empia EM28178, Montage M88DS3103, Montage M88TS2022, Allegro A8293 */
+	/*
+	 * 2013:0258 PCTV DVB-S2 Stick (461e)
+	 * Empia EM28178, Montage M88DS3103, Montage M88TS2022, Allegro A8293
+	 */
 	[EM28178_BOARD_PCTV_461E] = {
 		.def_i2c_bus   = 1,
-		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				 EM28XX_I2C_FREQ_400_KHZ,
 		.name          = "PCTV DVB-S2 Stick (461e)",
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = pctv_461e,
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
-	/* 2013:025f PCTV tripleStick (292e).
-	 * Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2157 */
+	/*
+	 * 2013:025f PCTV tripleStick (292e).
+	 * Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2157
+	 */
 	[EM28178_BOARD_PCTV_292E] = {
 		.name          = "PCTV tripleStick (292e)",
 		.def_i2c_bus   = 1,
-		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				 EM28XX_I2C_FREQ_400_KHZ,
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = pctv_292e,
 		.has_dvb       = 1,
@@ -2361,12 +2398,15 @@ const struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
-	/* eb1a:8179 Terratec Cinergy T2 Stick HD.
-	 * Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2146 */
+	/*
+	 * eb1a:8179 Terratec Cinergy T2 Stick HD.
+	 * Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2146
+	 */
 	[EM28178_BOARD_TERRATEC_T2_STICK_HD] = {
 		.name          = "Terratec Cinergy T2 Stick HD",
 		.def_i2c_bus   = 1,
-		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				 EM28XX_I2C_FREQ_400_KHZ,
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = terratec_t2_stick_hd,
 		.has_dvb       = 1,
@@ -2481,10 +2521,10 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2870_BOARD_KWORLD_355U },
 	{ USB_DEVICE(0xeb1a, 0xe359),
 			.driver_info = EM2870_BOARD_KWORLD_355U },
-	{ USB_DEVICE(0x1b80, 0xe302),
-			.driver_info = EM2820_BOARD_PINNACLE_DVC_90 }, /* Kaiser Baas Video to DVD maker */
-	{ USB_DEVICE(0x1b80, 0xe304),
-			.driver_info = EM2820_BOARD_PINNACLE_DVC_90 }, /* Kworld DVD Maker 2 */
+	{ USB_DEVICE(0x1b80, 0xe302), /* Kaiser Baas Video to DVD maker */
+			.driver_info = EM2820_BOARD_PINNACLE_DVC_90 },
+	{ USB_DEVICE(0x1b80, 0xe304), /* Kworld DVD Maker 2 */
+			.driver_info = EM2820_BOARD_PINNACLE_DVC_90 },
 	{ USB_DEVICE(0x0ccd, 0x0036),
 			.driver_info = EM2820_BOARD_TERRATEC_CINERGY_250 },
 	{ USB_DEVICE(0x0ccd, 0x004c),
@@ -2670,16 +2710,16 @@ static inline void em28xx_set_xclk_i2c_speed(struct em28xx *dev)
 	const struct em28xx_board *board = &em28xx_boards[dev->model];
 	u8 xclk = board->xclk, i2c_speed = board->i2c_speed;
 
-	/* Those are the default values for the majority of boards
-	   Use those values if not specified otherwise at boards entry
+	/*
+	 * Those are the default values for the majority of boards
+	 * Use those values if not specified otherwise at boards entry
 	 */
 	if (!xclk)
 		xclk = EM28XX_XCLK_IR_RC5_MODE |
-				  EM28XX_XCLK_FREQUENCY_12MHZ;
+		       EM28XX_XCLK_FREQUENCY_12MHZ;
 
 	em28xx_write_reg(dev, EM28XX_R0F_XCLK, xclk);
 
-
 	if (!i2c_speed)
 		i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
 			    EM28XX_I2C_FREQ_100_KHZ;
@@ -2703,7 +2743,8 @@ static inline void em28xx_set_model(struct em28xx *dev)
 	dev->def_i2c_bus = dev->board.def_i2c_bus;
 }
 
-/* Wait until AC97_RESET reports the expected value reliably before proceeding.
+/*
+ * Wait until AC97_RESET reports the expected value reliably before proceeding.
  * We also check that two unrelated registers accesses don't return the same
  * value to avoid premature return.
  * This procedure helps ensuring AC97 register accesses are reliable.
@@ -2733,13 +2774,16 @@ static int em28xx_wait_until_ac97_features_equals(struct em28xx *dev,
 	return -ETIMEDOUT;
 }
 
-/* Since em28xx_pre_card_setup() requires a proper dev->model,
+/*
+ * Since em28xx_pre_card_setup() requires a proper dev->model,
  * this won't work for boards with generic PCI IDs
  */
 static void em28xx_pre_card_setup(struct em28xx *dev)
 {
-	/* Set the initial XCLK and I2C clock values based on the board
-	   definition */
+	/*
+	 * Set the initial XCLK and I2C clock values based on the board
+	 * definition
+	 */
 	em28xx_set_xclk_i2c_speed(dev);
 
 	/* request some modules */
@@ -2751,17 +2795,19 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 	case EM2861_BOARD_KWORLD_PVRTV_300U:
 	case EM2880_BOARD_KWORLD_DVB_305U:
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0x6d);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0x7d);
-		msleep(10);
+		usleep_range(10000, 11000);
 		break;
 	case EM2870_BOARD_COMPRO_VIDEOMATE:
-		/* TODO: someone can do some cleanup here...
-			 not everything's needed */
+		/*
+		 * TODO: someone can do some cleanup here...
+		 *	 not everything's needed
+		 */
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x00);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x01);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
 		mdelay(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfc);
@@ -2772,8 +2818,10 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		mdelay(70);
 		break;
 	case EM2870_BOARD_TERRATEC_XS_MT2060:
-		/* this device needs some gpio writes to get the DVB-T
-		   demod work */
+		/*
+		 * this device needs some gpio writes to get the DVB-T
+		 * demod work
+		 */
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		mdelay(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xde);
@@ -2782,8 +2830,10 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		mdelay(70);
 		break;
 	case EM2870_BOARD_PINNACLE_PCTV_DVB:
-		/* this device needs some gpio writes to get the
-		   DVB-T demod work */
+		/*
+		 * this device needs some gpio writes to get the
+		 * DVB-T demod work
+		 */
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		mdelay(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xde);
@@ -2799,13 +2849,13 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 
 	case EM2882_BOARD_KWORLD_ATSC_315U:
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x00);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x08);
-		msleep(10);
+		usleep_range(10000, 11000);
 		break;
 
 	case EM2860_BOARD_KAIOMY_TVNPC_U2:
@@ -2813,11 +2863,11 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		em28xx_write_regs(dev, EM28XX_R06_I2C_CLK, "\x40", 1);
 		em28xx_write_regs(dev, 0x0d, "\x42", 1);
 		em28xx_write_regs(dev, 0x08, "\xfd", 1);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_regs(dev, 0x08, "\xff", 1);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_regs(dev, 0x08, "\x7f", 1);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_regs(dev, 0x08, "\x6b", 1);
 
 		break;
@@ -2829,7 +2879,7 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
 		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
@@ -2837,7 +2887,8 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		break;
 
 	case EM2860_BOARD_TERRATEC_GRABBY:
-		/* HACK?: Ensure AC97 register reading is reliable before
+		/*
+		 * HACK?: Ensure AC97 register reading is reliable before
 		 * proceeding. In practice, this will wait about 1.6 seconds.
 		 */
 		em28xx_wait_until_ac97_features_equals(dev, 0x6a90);
@@ -2867,7 +2918,8 @@ static int em28xx_hint_board(struct em28xx *dev)
 		return 0;
 	}
 
-	/* HINT method: EEPROM
+	/*
+	 * HINT method: EEPROM
 	 *
 	 * This method works only for boards with eeprom.
 	 * Uses a hash of all eeprom bytes. The hash should be
@@ -2893,7 +2945,8 @@ static int em28xx_hint_board(struct em28xx *dev)
 		}
 	}
 
-	/* HINT method: I2C attached devices
+	/*
+	 * HINT method: I2C attached devices
 	 *
 	 * This method works for all boards.
 	 * Uses a hash of i2c scanned devices.
@@ -2971,9 +3024,9 @@ static void em28xx_card_setup(struct em28xx *dev)
 		 * This solution is only valid if they do not share eeprom
 		 * hash identities which has not been determined as yet.
 		 */
-		if (em28xx_hint_board(dev) < 0)
+		if (em28xx_hint_board(dev) < 0) {
 			dev_err(&dev->intf->dev, "Board not discovered\n");
-		else {
+		} else {
 			em28xx_set_model(dev);
 			em28xx_pre_card_setup(dev);
 		}
@@ -2983,7 +3036,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 	}
 
 	dev_info(&dev->intf->dev, "Identified as %s (card=%d)\n",
-		dev->board.name, dev->model);
+		 dev->board.name, dev->model);
 
 	dev->tuner_type = em28xx_boards[dev->model].tuner_type;
 
@@ -3000,7 +3053,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 	{
 		struct tveeprom tv;
 
-		if (dev->eedata == NULL)
+		if (!dev->eedata)
 			break;
 #if defined(CONFIG_MODULES) && defined(MODULE)
 		request_module("tveeprom");
@@ -3019,9 +3072,9 @@ static void em28xx_card_setup(struct em28xx *dev)
 	}
 	case EM2882_BOARD_KWORLD_ATSC_315U:
 		em28xx_write_reg(dev, 0x0d, 0x42);
-		msleep(10);
+		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
-		msleep(10);
+		usleep_range(10000, 11000);
 		break;
 	case EM2820_BOARD_KWORLD_PVRTV2800RF:
 		/* GPIO enables sound on KWORLD PVR TV 2800RF */
@@ -3046,10 +3099,12 @@ static void em28xx_card_setup(struct em28xx *dev)
 		if (!em28xx_hint_board(dev))
 			em28xx_set_model(dev);
 
-		/* In cases where we had to use a board hint, the call to
-		   em28xx_set_mode() in em28xx_pre_card_setup() was a no-op,
-		   so make the call now so the analog GPIOs are set properly
-		   before probing the i2c bus. */
+		/*
+		 * In cases where we had to use a board hint, the call to
+		 * em28xx_set_mode() in em28xx_pre_card_setup() was a no-op,
+		 * so make the call now so the analog GPIOs are set properly
+		 * before probing the i2c bus.
+		 */
 		em28xx_gpio_set(dev, dev->board.tuner_gpio);
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 		break;
@@ -3071,10 +3126,12 @@ static void em28xx_card_setup(struct em28xx *dev)
 		if (!em28xx_hint_board(dev))
 			em28xx_set_model(dev);
 
-		/* In cases where we had to use a board hint, the call to
-		   em28xx_set_mode() in em28xx_pre_card_setup() was a no-op,
-		   so make the call now so the analog GPIOs are set properly
-		   before probing the i2c bus. */
+		/*
+		 * In cases where we had to use a board hint, the call to
+		 * em28xx_set_mode() in em28xx_pre_card_setup() was a no-op,
+		 * so make the call now so the analog GPIOs are set properly
+		 * before probing the i2c bus.
+		 */
 		em28xx_gpio_set(dev, dev->board.tuner_gpio);
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 		break;
@@ -3159,8 +3216,8 @@ static void request_module_async(struct work_struct *work)
 	 */
 
 	/*
-	 * Devicdes with an audio-only interface also have a V4L/DVB/RC
-	 * interface. Don't register extensions twice on those devices.
+	 * Devices with an audio-only intf also have a V4L/DVB/RC
+	 * intf. Don't register extensions twice on those devices.
 	 */
 	if (dev->is_audio_only) {
 #if defined(CONFIG_MODULES) && defined(MODULE)
@@ -3221,7 +3278,6 @@ static int em28xx_media_device_init(struct em28xx *dev,
 
 static void em28xx_unregister_media_device(struct em28xx *dev)
 {
-
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
 		media_device_unregister(dev->media_dev);
@@ -3236,7 +3292,7 @@ static void em28xx_unregister_media_device(struct em28xx *dev)
  * em28xx_release_resources()
  * unregisters the v4l2,i2c and usb devices
  * called when the device gets disconnected or at module unload
-*/
+ */
 static void em28xx_release_resources(struct em28xx *dev)
 {
 	struct usb_device *udev = interface_to_usbdev(dev->intf);
@@ -3418,8 +3474,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 						     EM28XX_I2C_ALGO_EM28XX);
 		if (retval < 0) {
 			dev_err(&dev->intf->dev,
-			       "%s: em28xx_i2c_register bus 1 - error [%d]!\n",
-			       __func__, retval);
+				"%s: em28xx_i2c_register bus 1 - error [%d]!\n",
+				__func__, retval);
 
 			em28xx_i2c_unregister(dev, 0);
 
@@ -3481,7 +3537,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
+	if (!dev) {
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -3490,7 +3546,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->alt_max_pkt_size_isoc =
 				kmalloc(sizeof(dev->alt_max_pkt_size_isoc[0]) *
 					interface->num_altsetting, GFP_KERNEL);
-	if (dev->alt_max_pkt_size_isoc == NULL) {
+	if (!dev->alt_max_pkt_size_isoc) {
 		kfree(dev);
 		retval = -ENOMEM;
 		goto err;
@@ -3500,7 +3556,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	for (i = 0; i < interface->num_altsetting; i++) {
 		int ep;
 
-		for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
+		for (ep = 0;
+		     ep < interface->altsetting[i].desc.bNumEndpoints;
+		     ep++) {
 			const struct usb_endpoint_descriptor *e;
 			int sizedescr, size;
 
@@ -3554,7 +3612,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 					break;
 				}
 			}
-			/* NOTE:
+			/*
+			 * NOTE:
 			 * Old logic with support for isoc transfers only was:
 			 *  0x82	isoc		=> analog
 			 *  0x83	isoc		=> audio
@@ -3646,7 +3705,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			if (has_vendor_audio)
 				dev_err(&interface->dev,
 					"em28xx: device seems to have vendor AND usb audio class interfaces !\n"
-				       "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
+					"\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
 			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
 			break;
 		}
@@ -3665,7 +3724,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	dev->num_alt = interface->num_altsetting;
 
-	if ((unsigned)card[nr] < em28xx_bcount)
+	if ((unsigned int)card[nr] < em28xx_bcount)
 		dev->model = card[nr];
 
 	/* save our data pointer in this interface device */
@@ -3674,9 +3733,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* allocate device struct and check if the device is a webcam */
 	mutex_init(&dev->lock);
 	retval = em28xx_init_dev(dev, udev, interface, nr);
-	if (retval) {
+	if (retval)
 		goto err_free;
-	}
 
 	if (usb_xfer_mode < 0) {
 		if (dev->is_webcam)
@@ -3691,7 +3749,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_video &&
 	    dev->board.decoder == EM28XX_NODECODER &&
 	    dev->em28xx_sensor == EM28XX_NOSENSOR) {
-
 		dev_err(&interface->dev,
 			"Currently, V4L2 is not supported on this model\n");
 		has_video = false;
-- 
2.14.3
