Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:41529 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab3ALUZY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jan 2013 15:25:24 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] saa7134: Add AverMedia Satelllite Hybrid+FM A706 (and FM radio problems)
Date: Sat, 12 Jan 2013 21:24:50 +0100
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301122124.51767.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
this patch adds support for AverMedia Satelllite Hybrid+FM A706 cards to saa7134 driver.

This card needs i2c gate in tda8290 to be disabled (as all I2C devices are 
connected to single bus) so this patch also includes tda8290 driver 
modification to allow this (will be posted separately in final version).

Working: analog video inputs (composite, s-vhs, analog TV), analog sound
inputs (cinch, TV), analog TV tuner, remote control
Untested: DVB-S

Partially working: FM radio
Radio seems to be a long-standing problem with saa7134 cards using silicon 
tuners (according to various mailing lists).

On this card, GPIO11 controls 74HC4052 MUX. It switches two things:
something at TDA18271 V_IFAGC pin and something that goes to SAA7131E.
GPIO11 is enabled for radio and disabled for TV in Windows. I did the same 
thing in this patch.

Windows INF file says:
; Setting FM radio of the Silicon tuner via SIF (GPIO 21 in use/ 5.5MHz)
HKR, "Audio", "FM Radio IF", 0x00010001, 0xDEEAAB

But that seems not to be true. GPIO21 does nothing and RegSpy (from DScaler, 
modified to include 0x42c register) says that the register is 0x80729555.
That matches the value present in saa7134-tvaudio.c (except the first 0x80).

With this value, the radio stations are off by about 4.2-4.3 MHz, e.g.:
station at 97.90 MHz is tuned as 102.20 MHz
station at 101.80 MHz is tuned as 106.0 MHz

I also tried 0xDEEAAB. With this, the offset is different, about 0.4 MHz:
station at 101.80 MHz is tuned as 102.2 MHz

And what's worst, connecting analog TV antenna (cable TV) affects the radio 
tuner! E.g. the radio is tuned to 106.0 MHz (real 101.80 MHz) with nice clean 
sound. Connecting TV antenna adds strong noise to the sound, tuning does not 
help. This problem is not present in Windows.

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 08ae067..c1f6e7c 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -230,7 +230,7 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir,
 		return 0;
 
 	dprintk(1, "read key 0x%02x/0x%02x\n", key, keygroup);
-	if (keygroup < 2 || keygroup > 3) {
+	if (keygroup < 2 || keygroup > 4) {
 		/* Only a warning */
 		dprintk(1, "warning: invalid key group 0x%02x for key 0x%02x\n",
 								keygroup, key);
@@ -239,6 +239,10 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir,
 
 	*ir_key = key;
 	*ir_raw = key;
+	if (!strcmp(ir->ir_codes, RC_MAP_AVERMEDIA_M733A_RM_K6)) {
+		*ir_key |= keygroup << 8;
+		*ir_raw |= keygroup << 8;
+	}
 	return 1;
 }
 
@@ -332,6 +336,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
+	case 0x41:
+		name        = "AVerMedia EM78P153";
+		ir->get_key = get_key_avermedia_cardbus;
+		rc_type     = RC_BIT_OTHER;
+		/* RM-KV remote, seems to be same as RM-K6 */
+		ir_codes    = RC_MAP_AVERMEDIA_M733A_RM_K6;
+		break;
 	case 0x71:
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index bc08f1d..063a17e 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -34,6 +34,7 @@
 #include "tda18271.h"
 #include "xc5000.h"
 #include "s5h1411.h"
+#include "tda8290.h"
 
 /* commly used strings */
 static char name_mute[]    = "mute";
@@ -5773,6 +5774,36 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio	= 0x0000000,
 		},
 	},
+	[SAA7134_BOARD_AVERMEDIA_A706] = {
+		.name           = "AverMedia AverTV Satellite Hybrid+FM A706",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 0 | TDA829X_NO_I2C_GATE,
+		.gpiomask       = 1 << 11,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp,
+			.vmux = 4,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0000800,
+		},
+	},
 
 };
 
@@ -7020,6 +7051,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x0911,
 		.driver_data  = SAA7134_BOARD_SENSORAY811_911,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0x2055, /* AverTV Satellite Hybrid+FM A706 */
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_A706,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7568,6 +7605,14 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A706:
+		dev->has_remote = SAA7134_REMOTE_I2C;
+		/* 
+		 * Disable CE5039 DVB-S tuner now (SLEEP pin high) to prevent
+		 * it from interfering with analog tuner detection
+		 */
+		saa7134_set_gpio(dev, 23, 1);
+		break;
 	case SAA7134_BOARD_VIDEOMATE_S350:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8976d0e..8f420f9 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -947,9 +947,9 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if ((unsigned)card[dev->nr] < saa7134_bcount)
 		dev->board = card[dev->nr];
 	if (SAA7134_BOARD_UNKNOWN == dev->board)
-		must_configure_manually(0);
-	else if (SAA7134_BOARD_NOAUTO == dev->board) {
 		must_configure_manually(1);
+	else if (SAA7134_BOARD_NOAUTO == dev->board) {
+		must_configure_manually(0);
 		dev->board = SAA7134_BOARD_UNKNOWN;
 	}
 	dev->autodetected = card[dev->nr] != dev->board;
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index b209de4..eae7348 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1070,6 +1070,10 @@ static struct mt312_config zl10313_compro_s350_config = {
 	.demod_address = 0x0e,
 };
 
+static struct mt312_config zl10313_avermedia_a706_config = {
+	.demod_address = 0x0e,
+};
+
 static struct lgdt3305_config hcw_lgdt3305_config = {
 	.i2c_addr           = 0x0e,
 	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
@@ -1817,6 +1821,24 @@ static int dvb_init(struct saa7134_dev *dev)
 				   &prohdtv_pro2_tda18271_config);
 		}
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A706:
+		/* Enable all DVB-S devices now */
+		/* CE5039 DVB-S tuner SLEEP pin low */
+		saa7134_set_gpio(dev, 23, 0);
+		/* CE6313 DVB-S demod SLEEP pin low */
+		saa7134_set_gpio(dev, 9, 0);
+		/* CE6313 DVB-S demod RESET# pin high */
+		saa7134_set_gpio(dev, 25, 1);
+		fe0->dvb.frontend = dvb_attach(mt312_attach,
+				&zl10313_avermedia_a706_config, &dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
+					0x60, &dev->i2c_adap) == NULL)
+				wprintk("%s: No zl10039 found!\n",
+					__func__);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index a176ec3..d2f2924 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -255,7 +255,7 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 			if (msgs[i].flags & I2C_M_RD)
 				addr |= 1;
 			if (i > 0 && msgs[i].flags &
-			    I2C_M_RD && msgs[i].addr != 0x40 &&
+			    I2C_M_RD && msgs[i].addr != 0x40 && msgs[i].addr != 0x41 &&
 			    msgs[i].addr != 0x19) {
 				/* workaround for a saa7134 i2c bug
 				 * needed to talk to the mt352 demux
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index e761262..6f43126 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -997,6 +997,9 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 		info.addr = 0x40;
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A706:
+		info.addr = 0x41;
+		break;
 	case SAA7134_BOARD_FLYDVB_TRIO:
 		dev->init_data.name = "FlyDVB Trio";
 		dev->init_data.get_key = get_key_flydvb_trio;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index c24b651..6cef84d 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -332,6 +332,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_SENSORAY811_911       188
 #define SAA7134_BOARD_KWORLD_PC150U         189
 #define SAA7134_BOARD_ASUSTeK_PS3_100      190
+#define SAA7134_BOARD_AVERMEDIA_A706		191
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 8c48521..bf5c7df 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -54,6 +54,7 @@ struct tda8290_priv {
 #define TDA18271 16
 
 	struct tda827x_config cfg;
+	bool no_i2c_gate;
 };
 
 /*---------------------------------------------------------------------*/
@@ -66,6 +67,9 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
 	unsigned char disable[2] = { 0x21, 0x00 };
 	unsigned char *msg;
 
+	if (priv->no_i2c_gate)
+		return 0;
+
 	if (close) {
 		msg = enable;
 		tuner_i2c_xfer_send(&priv->i2c_props, msg, 2);
@@ -88,6 +92,9 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
 	unsigned char buf[3] = { 0x45, 0x01, 0x00 };
 	unsigned char *msg;
 
+	if (priv->no_i2c_gate)
+		return 0;
+
 	if (close) {
 		msg = enable;
 		tuner_i2c_xfer_send(&priv->i2c_props, msg, 2);
@@ -740,8 +747,12 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 	priv->i2c_props.addr     = i2c_addr;
 	priv->i2c_props.adap     = i2c_adap;
 	priv->i2c_props.name     = "tda829x";
-	if (cfg)
-		priv->cfg.config         = cfg->lna_cfg;
+	if (cfg) {
+		if (cfg->lna_cfg & TDA829X_NO_I2C_GATE)
+			priv->no_i2c_gate = true;
+		priv->cfg.config = cfg->lna_cfg & TDA829X_CFG_MASK;
+		printk("cfg.config=%d\n", priv->cfg.config);
+	}
 
 	if (tda8290_probe(&priv->i2c_props) == 0) {
 		priv->ver = TDA8290;
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index 7e288b2..e300f4c 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -20,6 +20,9 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
+#define TDA829X_NO_I2C_GATE	(1 << 7)
+#define TDA829X_CFG_MASK	(~TDA829X_NO_I2C_GATE)
+
 struct tda829x_config {
 	unsigned int lna_cfg;
 


-- 
Ondrej Zary
