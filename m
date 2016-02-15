Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33376 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbcBOVAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 16:00:19 -0500
Received: by mail-wm0-f45.google.com with SMTP id g62so164780730wme.0
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 13:00:19 -0800 (PST)
From: POJAR GEORGE <geoubuntu@gmail.com>
To: linux-media@vger.kernel.org
Cc: POJAR GEORGE <geoubuntu@gmail.com>
Subject: [PATCH] saa7134: add SnaZio* TVPVR PRO card support
Date: Mon, 15 Feb 2016 23:00:06 +0200
Message-Id: <1455570006-24170-1-git-send-email-geoubuntu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: POJAR GEORGE <geoubuntu@gmail.com>
---
 drivers/media/pci/saa7134/saa7134-cards.c | 37 +++++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-input.c | 19 ++++++++++++++++
 drivers/media/pci/saa7134/saa7134.h       |  1 +
 3 files changed, 57 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 9a2fdc7..612cb89 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5733,6 +5733,36 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio = 0x08,
 		},
 	},
+	[SAA7134_BOARD_SNAZIO_TVPVR_PRO] = {
+		.name           = "SnaZio* TVPVR PRO",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 1 << 21,
+		.inputs         = {{
+			.type = SAA7134_INPUT_TV,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x0000000,
+		},{
+			.type = SAA7134_INPUT_COMPOSITE1,
+			.vmux = 3,
+			.amux = LINE2,
+			.gpio = 0x0000000,
+		},{
+			.type = SAA7134_INPUT_SVIDEO,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x0000000,
+		}},
+		.radio = {
+			.type = SAA7134_INPUT_RADIO,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
+	},
 
 };
 
@@ -7004,6 +7034,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x6f3a,
 		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1779, /* V One Multimedia PTE Ltd */
+		.subdevice    = 0x13cf,
+		.driver_data  = SAA7134_BOARD_SNAZIO_TVPVR_PRO,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7534,6 +7570,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_H7:
 	case SAA7134_BOARD_BEHOLD_A7:
 	case SAA7134_BOARD_KWORLD_PC150U:
+	case SAA7134_BOARD_SNAZIO_TVPVR_PRO:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 69d32d3..04d1dc9 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -990,6 +990,25 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 			msg_msi.addr, dev->i2c_adap.name,
 			(1 == rc) ? "yes" : "no");
 		break;
+	case SAA7134_BOARD_SNAZIO_TVPVR_PRO:
+		dev->init_data.name = "SnaZio* TVPVR PRO";
+		dev->init_data.get_key = get_key_msi_tvanywhere_plus;
+		dev->init_data.ir_codes = RC_MAP_MSI_TVANYWHERE_PLUS;
+		/*
+		 * MSI TV@nyware Plus requires more frequent polling
+		 * otherwise it will miss some keypresses
+		 */
+		dev->init_data.polling_interval = 50;
+		info.addr = 0x30;
+		/* MSI TV@nywhere Plus controller doesn't seem to
+		   respond to probes unless we read something from
+		   an existing device. Weird...
+		   REVISIT: might no longer be needed */
+		rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
+		input_dbg("probe 0x%02x @ %s: %s\n",
+			msg_msi.addr, dev->i2c_adap.name,
+			(1 == rc) ? "yes" : "no");
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		dev->init_data.name = "HVR 1110";
 		dev->init_data.get_key = get_key_hvr1110;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 8936568..69a9bbf 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -343,6 +343,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_WIS_VOYAGER           193
 #define SAA7134_BOARD_AVERMEDIA_505         194
 #define SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM 195
+#define SAA7134_BOARD_SNAZIO_TVPVR_PRO      196
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
2.5.0

