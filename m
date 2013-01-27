Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:60095 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab3A0Vpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 16:45:31 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 4/4 v2] saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
Date: Sun, 27 Jan 2013 22:45:07 +0100
Cc: linux-media@vger.kernel.org
References: <1358716939-2133-1-git-send-email-linux@rainbow-software.org> <1358716939-2133-5-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1358716939-2133-5-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301272245.08516.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add AverMedia AverTV Satellite Hybrid+FM (A706) card to saa7134 driver.
Working: analog inputs, TV, FM radio and IR remote control.
Untested: DVB-S.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
v2: added msleep() to dvb init to allow chips to come out of reset

 drivers/media/i2c/ir-kbd-i2c.c              |   13 ++++++-
 drivers/media/pci/saa7134/saa7134-cards.c   |   53 +++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-dvb.c     |   23 ++++++++++++
 drivers/media/pci/saa7134/saa7134-i2c.c     |    1 +
 drivers/media/pci/saa7134/saa7134-input.c   |    3 ++
 drivers/media/pci/saa7134/saa7134-tvaudio.c |    1 +
 drivers/media/pci/saa7134/saa7134.h         |    1 +
 7 files changed, 94 insertions(+), 1 deletions(-)

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
index fe54f88..c603064 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -50,6 +50,11 @@ static char name_svideo[]  = "S-Video";
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
 
+static struct tda18271_std_map aver_a706_std_map = {
+	.fm_radio = { .if_freq = 5500, .fm_rfn = 0, .agc_mode = 3, .std = 0,
+		      .if_lvl = 0, .rfagc_top = 0x2c, },
+};
+
 /* If radio_type !=UNSET, radio_addr should be specified
  */
 
@@ -5773,6 +5778,37 @@ struct saa7134_board saa7134_boards[] = {
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
+		.tda829x_conf   = { .lna_cfg = 0, .no_i2c_gate = 1,
+				    .tda18271_std_map = &aver_a706_std_map },
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
 
@@ -7020,6 +7056,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
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
@@ -7568,6 +7610,17 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A706:
+		/* radio antenna select: tristate both as in Windows driver */
+		saa7134_set_gpio(dev, 12, 3);	/* TV antenna */
+		saa7134_set_gpio(dev, 13, 3);	/* FM antenna */
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
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index b209de4..547f470 100644
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
@@ -1817,6 +1821,25 @@ static int dvb_init(struct saa7134_dev *dev)
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
+		msleep(1);
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
index a176ec3..c68169d 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -256,6 +256,7 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 				addr |= 1;
 			if (i > 0 && msgs[i].flags &
 			    I2C_M_RD && msgs[i].addr != 0x40 &&
+			    msgs[i].addr != 0x41 &&
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
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index b7a99be..0f34e09 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -796,6 +796,7 @@ static int tvaudio_thread_ddep(void *data)
 			dprintk("FM Radio\n");
 			if (dev->tuner_type == TUNER_PHILIPS_TDA8290) {
 				norms = (0x11 << 2) | 0x01;
+				/* set IF frequency to 5.5 MHz */
 				saa_dsp_writel(dev, 0x42c >> 2, 0x729555);
 			} else {
 				norms = (0x0f << 2) | 0x01;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index ce1b4b5..9059d08 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -333,6 +333,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_SENSORAY811_911       188
 #define SAA7134_BOARD_KWORLD_PC150U         189
 #define SAA7134_BOARD_ASUSTeK_PS3_100      190
+#define SAA7134_BOARD_AVERMEDIA_A706		191
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
Ondrej Zary
