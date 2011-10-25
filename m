Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([69.93.154.9]:45328 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753858Ab1JYWTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 18:19:36 -0400
Date: Tue, 25 Oct 2011 15:09:58 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
To: linux-media@vger.kernel.org
cc: mchehab@infradead.org
Message-ID: <tkrat.efd209d71c7588ce@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit cf5886c3dd2f65c817cb6ca5e7202fa3a3bdc872
Author: Dean Anderson <linux-dev@sensoray.com>
Date:   Mon Oct 24 15:46:52 2011 -0700

[media]: saa7134: Adding Sensoray 811 and 911 board models to saa7134 driver

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index 7efae9b..e7ef38a 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -186,3 +186,4 @@
 185 -> MagicPro ProHDTV Pro2 DMB-TH/Hybrid      [17de:d136]
 186 -> Beholder BeholdTV 501                    [5ace:5010]
 187 -> Beholder BeholdTV 503 FM                 [5ace:5030]
+188 -> Sensoray 811/911                         [6000:0811,6000:0911]
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 0f9fb99..065d0f6 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5691,6 +5691,27 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 		},
 	},
+	[SAA7134_BOARD_SENSORAY811_911] = {
+		.name		= "Sensoray 811/911",
+		.audio_clock	= 0x00200000,
+		.tuner_type	= TUNER_ABSENT,
+		.radio_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.inputs		= {{
+			.name   = name_comp1,
+			.vmux   = 0,
+			.amux   = LINE1,
+		}, {
+			.name   = name_comp3,
+			.vmux   = 2,
+			.amux   = LINE1,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+		} },
+	},
 
 };
 
@@ -6914,6 +6935,18 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0xd136,
 		.driver_data  = SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x6000,
+		.subdevice    = 0x0811,
+		.driver_data  = SAA7134_BOARD_SENSORAY811_911,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x6000,
+		.subdevice    = 0x0911,
+		.driver_data  = SAA7134_BOARD_SENSORAY811_911,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index bc8d6bb..b141464 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -330,6 +330,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2 185
 #define SAA7134_BOARD_BEHOLD_501            186
 #define SAA7134_BOARD_BEHOLD_503FM          187
+#define SAA7134_BOARD_SENSORAY811_911       188
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

