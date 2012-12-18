Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:60083 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754569Ab2LRVw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 16:52:56 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: AverMedia Satelllite Hybrid+FM A706
Date: Tue, 18 Dec 2012 22:45:50 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212182245.50722.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm trying to add support for AverMedia Satelllite Hybrid+FM A706 card to
saa7134 driver but it does not seem to work :( I did something like this
(also tried .tuner_addr = ADDR_UNSET). It's probably mostly wrong as it's
copied from other cards.

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
+		.tuner_addr     = 0x63,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 2,
+		.gpiomask       = 1 << 21,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
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
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index b209de4..c6f886d 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1070,6 +1070,11 @@ static struct mt312_config zl10313_compro_s350_config = {
 	.demod_address = 0x0e,
 };
 
+static struct mt312_config zl10313_avermedia_a706_config = {
+	.demod_address = 0x0e,
+};
+
+
 static struct lgdt3305_config hcw_lgdt3305_config = {
 	.i2c_addr           = 0x0e,
 	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
@@ -1817,6 +1822,19 @@ static int dvb_init(struct saa7134_dev *dev)
 				   &prohdtv_pro2_tda18271_config);
 		}
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A706:
+		fe0->dvb.frontend = dvb_attach(mt312_attach,
+				&zl10313_avermedia_a706_config, &dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, 0x4b,
+				   &tda829x_no_probe);
+			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
+					0x60, &dev->i2c_adap) == NULL)
+				wprintk("%s: No zl10039 found!\n",
+					__func__);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
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

The result is:
[    3.843111] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    3.843677] saa7133[0]: found at 0000:02:01.0, rev: 209, irq: 9, latency: 32, mmio: 0xf4000000
[    3.843747] saa7133[0]: subsystem: 1461:2055, board: AverMedia AverTV Satellite Hybrid+FM A706 [card=191,autodetected]
[    3.843830] saa7133[0]: board init: gpio is 1835ff
[    4.085202] saa7133[0]: i2c eeprom 00: 61 14 55 20 00 00 00 00 00 00 00 00 00 00 00 00
[    4.085210] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
[    4.085217] saa7133[0]: i2c eeprom 20: 02 40 01 02 02 01 01 04 06 ff 00 57 ff ff ff ff
[    4.085225] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085232] saa7133[0]: i2c eeprom 40: 60 a0 00 c6 96 ff 05 30 8b 05 ff 40 ff ff ff ff
[    4.085240] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085247] saa7133[0]: i2c eeprom 60: ff 89 00 c0 ff 1c 08 19 97 89 ff ff 80 15 0a ff
[    4.085255] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085262] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085270] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085277] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085285] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085292] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085300] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.085307] saa7133[0]: i2c eeprom e0: 00 01 81 b0 65 07 ff ff ff ff ff ff ff ff ff ff
[    4.085315] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    4.108510] tuner 2-0063: Tuner -1 found with type(s) Radio TV.
[    4.247906] tda8290: no gate control were provided!
[    4.247995] tuner 2-0063: Tuner has no way to set tv freq
[    4.248057] tuner 2-0063: Tuner has no way to set tv freq
[    4.248454] saa7133[0]: registered device video0 [v4l2]
[    4.248547] saa7133[0]: registered device vbi0
[    4.248626] saa7133[0]: registered device radio0
[    4.305662] tuner 2-0063: Tuner has no way to set tv freq
[    4.306555] tuner 2-0063: tuner has no way to set radio frequency
[    4.307711] tuner 2-0063: Tuner has no way to set tv freq
[    4.443378] dvb_init() allocating 1 frontend
[    4.462345] mt312_read: ret == -5
[    4.462352] saa7133[0]/dvb: frontend initialization failed
[    4.638148] saa7134 ALSA driver for DMA sound loaded
[    4.638658] saa7133[0]/alsa: saa7133[0] at 0xf4000000 irq 9 registered as card -1
[   12.585084] tuner 2-0063: tuner has no way to set radio frequency
[   12.593909] tuner 2-0063: Tuner has no way to set tv freq
[   12.599760] tuner 2-0063: Tuner has no way to set tv freq


The card should be capable of DVB-S, analog TV and FM radio. No DVB-T.

Main chip:   SAA7131E
EEPROM:      S24CS02A
DVB-S demod: CE6313 (=ZL10303 = MT312)
DVB-S tuner: CE5039 (=ZL10039)
TV/FM tuner: TDA18271HD

I physically verified that all these chips are connected to a single I2C bus
(CE5039 and TDA18271HD through 100-ohm resistors).
There is also some MCU present (EM78P153) but it's not connected to I2C so it
probably does not matter.

i2cdetect output:
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- 41 -- -- -- -- -- -- -- -- -- 4b -- -- -- --
50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: 60 -- -- UU -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --

0x41: wtf is this?
0x4b: TDA8295 (integrated in SAA7131E)
0x50: S24CS02A
0x60: CE5039
0x63: TDA18271HD
But where is CE6313? It should be at 0x0e according to datasheet and pins
35..38 (35 = GND, 36, 37, 38 = VCC).

The tda8290 driver seems to require some i2c gate control but I thinka that
this card has none as all devices are directly on the I2C bus.

Any ideas?

-- 
Ondrej Zary
