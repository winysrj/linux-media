Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:35616 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbaF0N2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 09:28:25 -0400
Message-ID: <1403870630.2767.3.camel@madomr-fc.comexp.ru>
Subject: [PATCH 1/2] saa7134: add new card BeholdTV H7 (rev. 7191)
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 27 Jun 2014 16:03:50 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New revision of the H7 card has a tuner xc5000C instead of xc5000.

Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>
---
 Documentation/video4linux/CARDLIST.saa7134 |  1 +
 drivers/media/pci/saa7134/saa7134-cards.c  | 37 ++++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-dvb.c    |  1 +
 drivers/media/pci/saa7134/saa7134-input.c  |  1 +
 drivers/media/pci/saa7134/saa7134.h        |  1 +
 5 files changed, 41 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index 8df17d0..1a067d7 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -191,3 +191,4 @@
 190 -> Asus My Cinema PS3-100                   [1043:48cd]
 191 -> Hawell HW-9004V1
 192 -> AverMedia AverTV Satellite Hybrid+FM A706 [1461:2055]
+193 -> Beholder BeholdTV H7 (rev. 7191)          [5ace:7191]
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 6e4bdb9..376feb5 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5827,6 +5827,34 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio = 0x0000800,
 		},
 	},
+	[SAA7134_BOARD_BEHOLD_H7_7191] = {
+		.name           = "Beholder BeholdTV H7 (rev. 7191)",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_XC5000C,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 2,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 9,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+		},
+	},
 
 };
 
@@ -7035,6 +7063,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7191,
+		.driver_data  = SAA7134_BOARD_BEHOLD_H7_7191,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
 		.subdevice    = 0x7090,
 		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
 	}, {
@@ -7176,6 +7210,7 @@ static int saa7134_xc5000_callback(struct saa7134_dev *dev,
 	switch (dev->board) {
 	case SAA7134_BOARD_BEHOLD_X7:
 	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_H7_7191:
 	case SAA7134_BOARD_BEHOLD_A7:
 		if (command == XC5000_TUNER_RESET) {
 		/* Down and UP pheripherial RESET pin for reset all chips */
@@ -7348,6 +7383,7 @@ int saa7134_tuner_callback(void *priv, int component, int command, int arg)
 		case TUNER_XC2028:
 			return saa7134_xc2028_callback(dev, command, arg);
 		case TUNER_XC5000:
+		case TUNER_XC5000C:
 			return saa7134_xc5000_callback(dev, command, arg);
 		}
 	} else {
@@ -7606,6 +7642,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_H6:
 	case SAA7134_BOARD_BEHOLD_X7:
 	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_H7_7191:
 	case SAA7134_BOARD_BEHOLD_A7:
 	case SAA7134_BOARD_KWORLD_PC150U:
 		dev->has_remote = SAA7134_REMOTE_I2C;
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 73ffbab..89d2a66 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1734,6 +1734,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		}
 		break;
 	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_H7_7191:
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 						&behold_x7_config,
 						&dev->i2c_adap);
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 6f43126..1d89a3f 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -986,6 +986,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_H6:
 	case SAA7134_BOARD_BEHOLD_X7:
 	case SAA7134_BOARD_BEHOLD_H7:
+	case SAA7134_BOARD_BEHOLD_H7_7191:
 	case SAA7134_BOARD_BEHOLD_A7:
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index e47edd4..9b61e7e 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -338,6 +338,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_ASUSTeK_PS3_100      190
 #define SAA7134_BOARD_HAWELL_HW_9004V1      191
 #define SAA7134_BOARD_AVERMEDIA_A706		192
+#define SAA7134_BOARD_BEHOLD_H7_7191		193
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
1.9.3



