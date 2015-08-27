Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33414 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbbH0WTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 18:19:25 -0400
Received: by lbbsx3 with SMTP id sx3so20091869lbb.0
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2015 15:19:23 -0700 (PDT)
From: Darek Zielski <dz1125tor@gmail.com>
To: linux-media@vger.kernel.org
Cc: Darek Zielski <dz1125tor@gmail.com>
Subject: [PATCH] saa7134: add Leadtek Winfast TV2100 FM card support
Date: Fri, 28 Aug 2015 00:18:54 +0200
Message-Id: <1440713934-13062-1-git-send-email-dz1125tor@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Leadtek Winfast TV2100 FM card to saa7134 driver. It is a card bearing
SAA7130HL chip.

Signed-off-by: Darek Zielski <dz1125tor@gmail.com>
---
 Documentation/video4linux/CARDLIST.saa7134 |  1 +
 drivers/media/pci/saa7134/saa7134-cards.c  | 43 ++++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-input.c  |  7 +++++
 drivers/media/pci/saa7134/saa7134.h        |  1 +
 4 files changed, 52 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index f4b395b..2821020 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -193,3 +193,4 @@
 192 -> AverMedia AverTV Satellite Hybrid+FM A706 [1461:2055]
 193 -> WIS Voyager or compatible                [1905:7007]
 194 -> AverMedia AverTV/505                     [1461:a10a]
+195 -> Leadtek Winfast TV2100 FM                [107d:6f3a]
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index c740576..29d2094 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5884,6 +5884,42 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 		},
 	},
+	[SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM] = {
+		.name           = "Leadtek Winfast TV2100 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_TNF_5335MF,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.gpiomask       = 0x0d,
+		.inputs         = {{
+			.name = name_tv_mono,
+			.vmux = 1,
+			.amux = LINE1,
+			.gpio = 0x00,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+			.gpio = 0x08,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x08,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = LINE1,
+			.gpio = 0x04,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+			.gpio = 0x08,
+		},
+	},
 
 };
 
@@ -7149,6 +7185,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0xa10a,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_505,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x107d,
+		.subdevice    = 0x6f3a,
+		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7545,6 +7587,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
 	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
+	case SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 11a1720..69d32d3 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -835,6 +835,13 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keycode = 0xffff;
 		raw_decode   = true;
 		break;
+	case SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM:
+		ir_codes     = RC_MAP_LEADTEK_Y04G0051;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = true;
+		break;
 	}
 	if (NULL == ir_codes) {
 		pr_err("Oops: IR config error [card=%d]\n", dev->board);
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 6b5f6f4..14c2b4e 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -342,6 +342,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_AVERMEDIA_A706		192
 #define SAA7134_BOARD_WIS_VOYAGER           193
 #define SAA7134_BOARD_AVERMEDIA_505         194
+#define SAA7134_BOARD_LEADTEK_WINFAST_TV2100_FM 195
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
2.5.0

