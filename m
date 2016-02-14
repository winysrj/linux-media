Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33086 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbcBNVXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 16:23:18 -0500
Received: by mail-wm0-f46.google.com with SMTP id g62so126301875wme.0
        for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 13:23:17 -0800 (PST)
Received: from [192.168.1.100] ([86.123.157.202])
        by smtp.gmail.com with ESMTPSA id 79sm12661599wmo.7.2016.02.14.13.23.15
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 14 Feb 2016 13:23:16 -0800 (PST)
To: linux-media@vger.kernel.org
From: GEORGE <geoubuntu@gmail.com>
Subject: [PATCH] saa7134: Add support for Snazio TvPVR PRO
Message-ID: <56C0F043.7050401@gmail.com>
Date: Sun, 14 Feb 2016 23:23:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: POJAR GEORGE <geoubuntu <at> gmail.com>
---

diff --git a/Documentation/video4linux/CARDLIST.saa7134 
b/Documentation/video4linux/CARDLIST.saa7134
index 2821020..2e11644 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -194,3 +194,4 @@
  193 -> WIS Voyager or compatible                [1905:7007]
  194 -> AverMedia AverTV/505                     [1461:a10a]
  195 -> Leadtek Winfast TV2100 FM                [107d:6f3a]
+196 -> SnaZio* TvPVR PRO                        [1779:13cf]
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c 
b/drivers/media/pci/saa7134/saa7134-cards.c
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
diff --git a/drivers/media/pci/saa7134/saa7134-input.c 
b/drivers/media/pci/saa7134/saa7134-input.c
index 69d32d3..f62cbd9 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -975,6 +975,25 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
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
  	case SAA7134_BOARD_KWORLD_PC150U:
  		/* copied and modified from MSI TV@nywhere Plus */
  		dev->init_data.name = "Kworld PC150-U";
diff --git a/drivers/media/pci/saa7134/saa7134.h 
b/drivers/media/pci/saa7134/saa7134.h
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
