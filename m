Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:54502 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3AJWwY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 17:52:24 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [BAD PATCH] saa7134: Add AverMedia Satelllite Hybrid+FM A706
Date: Thu, 10 Jan 2013 23:52:04 +0100
Cc: Celal =?iso-8859-1?q?Erg=FCn?= <celal@formulsoft.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301102352.05187.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
this is a bad test patch that adds support for AverMedia Satelllite Hybrid+FM
A706 cards to saa7134.

Working: analog video inputs (composite, s-vhs, analog TV), analog sound
inputs (cinch, TV), analog TV tuner, remote control

Partially working: FM radio - it tunes but detunes to noise after a moment
(might be a bug in tda18271 driver?)
GPIO11 controls 74HC4052 MUX - it's enabled for radio and disabled for TV
in Windows - I did the same and it did not change anything

Untested: DVB-S

There is a hack (added "return 0" lines) to disable tda8290 i2c gate.
Is there a way to do this properly?

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
index bc08f1d..8b5025d 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5773,6 +5773,36 @@ struct saa7134_board saa7134_boards[] = {
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
+		.tuner_config   = 0,
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
 
@@ -7020,6 +7050,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
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
@@ -7266,6 +7302,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
 	case SAA7134_BOARD_KWORLD_PC150U:
 	case SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2:
+	case SAA7134_BOARD_AVERMEDIA_A706:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
 		break;
@@ -7568,6 +7605,41 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A706:
+		dev->has_remote = SAA7134_REMOTE_I2C;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0fffffff, 0x02a00e00);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0fffffff, 0x02203980);
+/*		saa7134_set_gpio(dev, 0, 1);
+		saa7134_set_gpio(dev, 1, 1);
+		saa7134_set_gpio(dev, 2, 1);
+		saa7134_set_gpio(dev, 3, 1);
+		saa7134_set_gpio(dev, 4, 1);
+		saa7134_set_gpio(dev, 5, 1);*/
+/*		saa7134_set_gpio(dev, 6, 1);
+		saa7134_set_gpio(dev, 7, 1);
+		saa7134_set_gpio(dev, 8, 1);*/
+//		saa7134_set_gpio(dev, 10, 1);
+//		saa7134_set_gpio(dev, 11, 1);	/////////////////// HC4052
+//		saa7134_set_gpio(dev, 12, 1);
+/*		saa7134_set_gpio(dev, 13, 1);
+		saa7134_set_gpio(dev, 14, 1);
+		saa7134_set_gpio(dev, 15, 1);
+		saa7134_set_gpio(dev, 16, 1);
+		saa7134_set_gpio(dev, 17, 1);
+		saa7134_set_gpio(dev, 18, 1);
+		saa7134_set_gpio(dev, 19, 1);
+		saa7134_set_gpio(dev, 20, 1);
+		saa7134_set_gpio(dev, 21, 1);
+		saa7134_set_gpio(dev, 22, 1);
+		saa7134_set_gpio(dev, 24, 1);
+		saa7134_set_gpio(dev, 26, 1);*/
+
+		/* 
+		 * Disable CE5039 DVB-S tuner now (SLEEP pin high) to prevent
+		 * it from interfering with analog tuner detection
+		 */
+		saa7134_set_gpio(dev, 23, 1);
+		break;
 	case SAA7134_BOARD_VIDEOMATE_S350:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
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
index 8c48521..7234428 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -65,7 +65,7 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
 	unsigned char  enable[2] = { 0x21, 0xC0 };
 	unsigned char disable[2] = { 0x21, 0x00 };
 	unsigned char *msg;
-
+return 0;
 	if (close) {
 		msg = enable;
 		tuner_i2c_xfer_send(&priv->i2c_props, msg, 2);
@@ -87,7 +87,7 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
 	unsigned char disable[2] = { 0x46, 0x00 };
 	unsigned char buf[3] = { 0x45, 0x01, 0x00 };
 	unsigned char *msg;
-
+return 0;
 	if (close) {
 		msg = enable;
 		tuner_i2c_xfer_send(&priv->i2c_props, msg, 2);
@@ -731,7 +731,7 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 {
 	struct tda8290_priv *priv = NULL;
 	char *name;
-
+	printk("%s, fe=%p, i2c_adap=%p, i2c_addr=0x%02x, cfg=%p\n", __FUNCTION__, fe, i2c_adap, i2c_addr, cfg);
 	priv = kzalloc(sizeof(struct tda8290_priv), GFP_KERNEL);
 	if (priv == NULL)
 		return NULL;


-- 
Ondrej Zary
