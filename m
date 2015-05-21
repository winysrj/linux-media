Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36671 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbEUSxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 14:53:10 -0400
Received: by lagv1 with SMTP id v1so110002806lag.3
        for <linux-media@vger.kernel.org>; Thu, 21 May 2015 11:53:08 -0700 (PDT)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] saa7134: add AverMedia AverTV/505 card support
Date: Thu, 21 May 2015 21:53:01 +0300
Message-Id: <1432234381-7698-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add AverMedia AverTV/505 card to saa7134 driver. It is a card bearing
SAA7130HL chip and FQ1216ME/IH-3 tuner.

Working: Composite, TV and IR remote control.
Untested: S-Video.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 Documentation/video4linux/CARDLIST.saa7134 |  1 +
 drivers/media/pci/saa7134/saa7134-cards.c  | 42 +++++++++++++++++++++++++++++-
 drivers/media/pci/saa7134/saa7134-input.c  |  2 ++
 drivers/media/pci/saa7134/saa7134.h        |  1 +
 4 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index a93d864..f4b395b 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -192,3 +192,4 @@
 191 -> Hawell HW-9004V1
 192 -> AverMedia AverTV Satellite Hybrid+FM A706 [1461:2055]
 193 -> WIS Voyager or compatible                [1905:7007]
+194 -> AverMedia AverTV/505                     [1461:a10a]
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 3ca0780..adc3563 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5850,6 +5850,39 @@ struct saa7134_board saa7134_boards[] = {
 		.amux = LINE1,
 		} },
 	},
+	[SAA7134_BOARD_AVERMEDIA_505] = {
+		/* much like the "studio" version but without radio
+		* and another tuner (dbaryshkov@gmail.com) */
+		.name           = "AverMedia AverTV/505",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = LINE2,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		},{
+			.name = name_comp2,
+			.vmux = 3,
+			.amux = LINE2,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		}},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
 
 };
 
@@ -7108,6 +7141,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subvendor    = 0x1905, /* WIS */
 		.subdevice    = 0x7007,
 		.driver_data  = SAA7134_BOARD_WIS_VOYAGER,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xa10a,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_505,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -7448,8 +7487,9 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
 	case SAA7134_BOARD_KWORLD_XPERT:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
-	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
 	case SAA7134_BOARD_AVERMEDIA_305:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
+	case SAA7134_BOARD_AVERMEDIA_505:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
 	case SAA7134_BOARD_AVERMEDIA_307:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index dc3d651..9f7e861 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -481,6 +481,7 @@ static int __saa7134_ir_start(void *priv)
 	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
 	case SAA7134_BOARD_AVERMEDIA_305:
 	case SAA7134_BOARD_AVERMEDIA_307:
+	case SAA7134_BOARD_AVERMEDIA_505:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
@@ -629,6 +630,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
 	case SAA7134_BOARD_AVERMEDIA_305:
 	case SAA7134_BOARD_AVERMEDIA_307:
+	case SAA7134_BOARD_AVERMEDIA_505:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
 	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 8bf0553..583e9f1 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -339,6 +339,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_HAWELL_HW_9004V1      191
 #define SAA7134_BOARD_AVERMEDIA_A706		192
 #define SAA7134_BOARD_WIS_VOYAGER           193
+#define SAA7134_BOARD_AVERMEDIA_505         194
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
2.1.4

