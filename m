Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m010e.mx.aol.com ([204.29.186.10]:42534 "EHLO
	omr-m010e.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbcD2O1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 10:27:54 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, tskd08@gmail.com,
	linux-media@vger.kernel.org
From: Satoshi Nagahama <sattnag@aim.com>
Subject: [PATCH] [media] em28xx_dvb: add support for PLEX PX-BCUD (ISDB-S usb
 dongle)
Message-ID: <a0564a33-161b-3e2e-d4d3-c6ed896a7b89@aim.com>
Date: Fri, 29 Apr 2016 23:27:47 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Akihiro,

I resend the same patch except that no credit info of mine is added
because of not rewriting a significant amount of the driver.
I got some reports that this patch works well on PX-BCUD and PT3, those are
the all devices can be affected by this patch.

--
I added em28xx_dvb to support for PLEX PX-BCUD (ISDB-S usb dongle).
Please move forward with this patch if there is no problem.
Or something wrong, please advise me what I should do.

PX-BCUD has the following components:
   USB interface: Empia EM28178
   Demodulator: Toshiba TC90532 (works by code for TC90522)
   Tuner: Next version of Sharp QM1D1C0042

em28xx_dvb_init(), add init code for PLEX PX-BCUD with calling
px_bcud_init() that does things like pin configuration.

qm1d1c0042_init(), support the next version of QM1D1C0042, change to
choose an appropriate array of initial registers by reading chip id.

Signed-off-by: Satoshi Nagahama <sattnag@aim.com>
---
  drivers/media/tuners/qm1d1c0042.c       |  34 +++++++---
  drivers/media/usb/em28xx/Kconfig        |   2 +
  drivers/media/usb/em28xx/em28xx-cards.c |  27 ++++++++
  drivers/media/usb/em28xx/em28xx-dvb.c   | 115 ++++++++++++++++++++++++++++++++
  drivers/media/usb/em28xx/em28xx.h       |   1 +
  5 files changed, 168 insertions(+), 11 deletions(-)

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 18bc745..bc2fb74 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -32,14 +32,23 @@
  #include "qm1d1c0042.h"

  #define QM1D1C0042_NUM_REGS 0x20
-
-static const u8 reg_initval[QM1D1C0042_NUM_REGS] = {
-	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
-	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
-	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
-	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
+#define QM1D1C0042_NUM_REG_ROWS 2
+
+static const u8 reg_initval[QM1D1C0042_NUM_REG_ROWS][QM1D1C0042_NUM_REGS] = { {
+		0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
+		0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+		0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
+		0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
+	}, {
+		0x68, 0x1c, 0xc0, 0x10, 0xbc, 0xc1, 0x11, 0x33,
+		0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+		0x00, 0xff, 0xf3, 0x00, 0x3f, 0x25, 0x5c, 0xd6,
+		0x55, 0xcf, 0x95, 0xf6, 0x36, 0xf2, 0x09, 0x00
+	}
  };

+static int reg_index;
+
  static const struct qm1d1c0042_config default_cfg = {
  	.xtal_freq = 16000,
  	.lpf = 1,
@@ -320,7 +329,6 @@ static int qm1d1c0042_init(struct dvb_frontend *fe)
  	int i, ret;

  	state = fe->tuner_priv;
-	memcpy(state->regs, reg_initval, sizeof(reg_initval));

  	reg_write(state, 0x01, 0x0c);
  	reg_write(state, 0x01, 0x0c);
@@ -330,15 +338,19 @@ static int qm1d1c0042_init(struct dvb_frontend *fe)
  		goto failed;
  	usleep_range(2000, 3000);

-	val = state->regs[0x01] | 0x10;
-	ret = reg_write(state, 0x01, val); /* soft reset off */
+	ret = reg_write(state, 0x01, 0x1c); /* soft reset off */
  	if (ret < 0)
  		goto failed;

-	/* check ID */
+	/* check ID and choose initial registers corresponding ID */
  	ret = reg_read(state, 0x00, &val);
-	if (ret < 0 || val != 0x48)
+	if (ret < 0)
+		goto failed;
+	for (reg_index = 0; reg_index < QM1D1C0042_NUM_REG_ROWS; reg_index++)
+		if (val == reg_initval[reg_index][0x00]) break;
+	if (reg_index >= QM1D1C0042_NUM_REG_ROWS)
  		goto failed;
+	memcpy(state->regs, reg_initval[reg_index], QM1D1C0042_NUM_REGS);
  	usleep_range(2000, 3000);

  	state->regs[0x0c] |= 0x40;
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index e382210..d917b0a 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -59,6 +59,8 @@ config VIDEO_EM28XX_DVB
  	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
  	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
  	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
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
index 5d209c7..9f30157 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -58,6 +58,8 @@
  #include "ts2020.h"
  #include "si2168.h"
  #include "si2157.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"

  MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
  MODULE_LICENSE("GPL");
@@ -787,6 +789,65 @@ static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
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
@@ -1762,6 +1823,60 @@ static int em28xx_dvb_init(struct em28xx *dev)
  			dvb->i2c_client_tuner = client;
  		}
  		break;
+	case EM28178_BOARD_PLEX_PX_BCUD:
+		{
+			struct i2c_client *client;
+			struct i2c_board_info info;
+			struct tc90522_config tc90522_config;
+                        struct qm1d1c0042_config qm1d1c0042_config;
+
+			/* attach demod */
+			memset(&tc90522_config, 0 ,sizeof(tc90522_config));
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "tc90522sat", I2C_NAME_SIZE);
+			info.addr = 0x15;
+			info.platform_data = &tc90522_config;
+			request_module("tc90522");
+			client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				result = -ENODEV;
+				goto out_free;
+			}
+			dvb->i2c_client_demod = client;
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			/* attach tuner */
+			memset(&qm1d1c0042_config, 0 ,sizeof(qm1d1c0042_config));
+			qm1d1c0042_config.fe = tc90522_config.fe;
+			qm1d1c0042_config.lpf = 1;
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "qm1d1c0042", I2C_NAME_SIZE);
+			info.addr = 0x61;
+                       	info.platform_data = &qm1d1c0042_config;
+                       	request_module(info.type);
+                       	client = i2c_new_device(tc90522_config.tuner_i2c, &info);
+                        if (client == NULL || client->dev.driver == NULL) {
+                                module_put(dvb->i2c_client_demod->dev.driver->owner);
+                                i2c_unregister_device(dvb->i2c_client_demod);
+                                result = -ENODEV;
+                                goto out_free;
+                        }
+                        dvb->i2c_client_tuner = client;
+                        if (!try_module_get(client->dev.driver->owner)) {
+                                i2c_unregister_device(client);
+                                module_put(dvb->i2c_client_demod->dev.driver->owner);
+                                i2c_unregister_device(dvb->i2c_client_demod);
+                                result = -ENODEV;
+                                goto out_free;
+                        }
+			dvb->fe[0] = tc90522_config.fe;
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
2.8.0

