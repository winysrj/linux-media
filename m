Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34696 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbcCaTm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 15:42:57 -0400
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=
	<knightrider@are.ma>, linux-kernel@vger.kernel.org, crope@iki.fi,
	m.chehab@samsung.com, mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 8/8] Support for PLEX PX-BCUD (ISDB-S usb dongle)
Date: Fri,  1 Apr 2016 04:42:32 +0900
Message-Id: <1a8510cd5ed0287b9aa7e4190746846ea987197e.1459450632.git.knightrider@are.ma>
In-Reply-To: <cover.1459450632.git.knightrider@are.ma>
References: <cover.1459450632.git.knightrider@are.ma>
In-Reply-To: <cover.1459450632.git.knightrider@are.ma>
References: <cover.1459450632.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

Support for PLEX PX-BCUD (ISDB-S usb dongle)
Nagahama's patch simplified...

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/usb/em28xx/Kconfig        |  2 +
 drivers/media/usb/em28xx/em28xx-cards.c | 27 +++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 79 ++++++++++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 4 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index e382210..b138939 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -59,6 +59,8 @@ config VIDEO_EM28XX_DVB
 	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1C004X if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 930e3e3..772a8f8 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -492,6 +492,20 @@ static struct em28xx_reg_seq terratec_t2_stick_hd[] = {
 	{-1,                             -1,   -1,     -1},
 };
 
+static struct em28xx_reg_seq plex_px_bcud[] = {
+	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0},
+	{0x0d,				0xff,	0xff,	0},
+	{EM2874_R50_IR_CONFIG,		0x01,	0xff,	0},
+	{EM28XX_R06_I2C_CLK,		0x40,	0xff,	0},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	100},
+	{EM28XX_R12_VINENABLE,		0x20,	0x20,	0},
+	{0x0d,				0x42,	0xff,	1000},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfc,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	10},
+	{0x73,				0xfd,	0xff,	100},
+	{-1,				-1,	-1,	-1},
+};
+
 /*
  *  Button definitions
  */
@@ -2306,6 +2320,17 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_TERRATEC_SLIM_2,
 	},
+	/* 3275:0085 PLEX PX-BCUD.
+	 * Empia EM28178, TOSHIBA TC90532XBG, Sharp QM1D1C0042 */
+	[EM28178_BOARD_PLEX_PX_BCUD] = {
+		.name          = "PLEX PX-BCUD",
+		.xclk          = EM28XX_XCLK_FREQUENCY_4_3MHZ,
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE,
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = plex_px_bcud,
+		.has_dvb       = 1,
+	},
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
@@ -2495,6 +2520,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2861_BOARD_LEADTEK_VC100 },
 	{ USB_DEVICE(0xeb1a, 0x8179),
 			.driver_info = EM28178_BOARD_TERRATEC_T2_STICK_HD },
+	{ USB_DEVICE(0x3275, 0x0085),
+			.driver_info = EM28178_BOARD_PLEX_PX_BCUD },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 5d209c7..e6c5a97 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -12,6 +12,10 @@
 
  (c) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 
+ (c) 2016 Nagahama Satoshi <sattnag@aim.com>
+	   Budi Rachmanto, AreMa Inc. <info@are.ma>
+	- PLEX PX-BCUD support
+
  Based on cx88-dvb, saa7134-dvb and videobuf-dvb originally written by:
 	(c) 2004, 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
 	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
@@ -25,11 +29,10 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 
+#include "ptx_common.h"
 #include "em28xx.h"
 #include <media/v4l2-common.h>
-#include <dvb_demux.h>
 #include <dvb_net.h>
-#include <dmxdev.h>
 #include <media/tuner.h>
 #include "tuner-simple.h"
 #include <linux/gpio.h>
@@ -787,6 +790,65 @@ static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
 	return 0;
 }
 
+static void px_bcud_init(struct em28xx *dev)
+{
+	int i;
+	struct {
+		unsigned char r[4];
+		int len;
+	} regs1[] = {
+		{{ 0x0e, 0x77 }, 2},
+		{{ 0x0f, 0x77 }, 2},
+		{{ 0x03, 0x90 }, 2},
+	}, regs2[] = {
+		{{ 0x07, 0x01 }, 2},
+		{{ 0x08, 0x10 }, 2},
+		{{ 0x13, 0x00 }, 2},
+		{{ 0x17, 0x00 }, 2},
+		{{ 0x03, 0x01 }, 2},
+		{{ 0x10, 0xb1 }, 2},
+		{{ 0x11, 0x40 }, 2},
+		{{ 0x85, 0x7a }, 2},
+		{{ 0x87, 0x04 }, 2},
+	};
+	static struct em28xx_reg_seq gpio[] = {
+		{EM28XX_R06_I2C_CLK,		0x40,	0xff,	300},
+		{EM2874_R80_GPIO_P0_CTRL,	0xfd,	0xff,	60},
+		{EM28XX_R15_RGAIN,		0x20,	0xff,	0},
+		{EM28XX_R16_GGAIN,		0x20,	0xff,	0},
+		{EM28XX_R17_BGAIN,		0x20,	0xff,	0},
+		{EM28XX_R18_ROFFSET,		0x00,	0xff,	0},
+		{EM28XX_R19_GOFFSET,		0x00,	0xff,	0},
+		{EM28XX_R1A_BOFFSET,		0x00,	0xff,	0},
+		{EM28XX_R23_UOFFSET,		0x00,	0xff,	0},
+		{EM28XX_R24_VOFFSET,		0x00,	0xff,	0},
+		{EM28XX_R26_COMPR,		0x00,	0xff,	0},
+		{0x13,				0x08,	0xff,	0},
+		{EM28XX_R12_VINENABLE,		0x27,	0xff,	0},
+		{EM28XX_R0C_USBSUSP,		0x10,	0xff,	0},
+		{EM28XX_R27_OUTFMT,		0x00,	0xff,	0},
+		{EM28XX_R10_VINMODE,		0x00,	0xff,	0},
+		{EM28XX_R11_VINCTRL,		0x11,	0xff,	0},
+		{EM2874_R50_IR_CONFIG,		0x01,	0xff,	0},
+		{EM2874_R5F_TS_ENABLE,		0x80,	0xff,	0},
+		{EM28XX_R06_I2C_CLK,		0x46,	0xff,	0},
+	};
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x46);
+	/* sleeping ISDB-T */
+	dev->dvb->i2c_client_demod->addr = 0x14;
+	for (i = 0; i < ARRAY_SIZE(regs1); i++)
+		i2c_master_send(dev->dvb->i2c_client_demod, regs1[i].r, regs1[i].len);
+	/* sleeping ISDB-S */
+	dev->dvb->i2c_client_demod->addr = 0x15;
+	for (i = 0; i < ARRAY_SIZE(regs2); i++)
+		i2c_master_send(dev->dvb->i2c_client_demod, regs2[i].r, regs2[i].len);
+	for (i = 0; i < ARRAY_SIZE(gpio); i++) {
+		em28xx_write_reg_bits(dev, gpio[i].reg, gpio[i].val, gpio[i].mask);
+		if (gpio[i].sleep > 0)
+			msleep(gpio[i].sleep);
+	}
+};
+
 static struct mt352_config terratec_xs_mt352_cfg = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner = 1,
@@ -1762,6 +1824,19 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb->i2c_client_tuner = client;
 		}
 		break;
+	case EM28178_BOARD_PLEX_PX_BCUD:
+		{
+			struct ptx_subdev_info	pxbcud_subdev_info =
+				{SYS_ISDBS, 0x15, TC90522_MODNAME, 0x61, QM1D1C004X_MODNAME};
+
+			dvb->fe[0] = ptx_register_fe(&dev->i2c_adap[dev->def_i2c_bus], NULL, &pxbcud_subdev_info);
+			if (!dvb->fe[0])
+                                goto out_free;
+			dvb->i2c_client_demod = dvb->fe[0]->demodulator_priv;
+                        dvb->i2c_client_tuner = dvb->fe[0]->tuner_priv;
+			px_bcud_init(dev);
+		}
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 2674449..9ad1240 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -145,6 +145,7 @@
 #define EM2861_BOARD_LEADTEK_VC100                95
 #define EM28178_BOARD_TERRATEC_T2_STICK_HD        96
 #define EM2884_BOARD_ELGATO_EYETV_HYBRID_2008     97
+#define EM28178_BOARD_PLEX_PX_BCUD                98
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
2.7.4

