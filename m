Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38963 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1EQDZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 23:25:03 -0400
Received: by fxm6 with SMTP id 6so177055fxm.11
        for <linux-media@vger.kernel.org>; Mon, 16 May 2011 20:25:01 -0700 (PDT)
Date: Tue, 17 May 2011 14:21:34 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] saa7134 add new TV cards
Message-ID: <20110517142134.31c07514@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/rO.pexSoCAprg=Jv_JuFbtd"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/rO.pexSoCAprg=Jv_JuFbtd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add new TV cards of Beholder Company. Just for autodetect.

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 61c6007..e98d38e 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5591,6 +5591,64 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_BEHOLD_501] = {
+		/*       Beholder Intl. Ltd. 2010       */
+		/* Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 501",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x00008000,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_503FM] = {
+		/*       Beholder Intl. Ltd. 2010       */
+		/* Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 503 FM",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x00008000,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
 
 };
 
@@ -6796,6 +6854,18 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_M1F,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace,
+		.subdevice    = 0x5030,
+		.driver_data  = SAA7134_BOARD_BEHOLD_503FM,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x5ace,
+		.subdevice    = 0x5010,
+		.driver_data  = SAA7134_BOARD_BEHOLD_501,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index f96cd5d..dbf01aa 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -328,6 +328,8 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG 182
 #define SAA7134_BOARD_VIDEOMATE_M1F         183
 #define SAA7134_BOARD_ENCORE_ENLTV_FM3      184
+#define SAA7134_BOARD_BEHOLD_501            185
+#define SAA7134_BOARD_BEHOLD_503FM          186
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/rO.pexSoCAprg=Jv_JuFbtd
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134_add_behold.diff

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 61c6007..e98d38e 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5591,6 +5591,64 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_BEHOLD_501] = {
+		/*       Beholder Intl. Ltd. 2010       */
+		/* Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 501",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x00008000,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_503FM] = {
+		/*       Beholder Intl. Ltd. 2010       */
+		/* Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 503 FM",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x00008000,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
 
 };
 
@@ -6796,6 +6854,18 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_M1F,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace,
+		.subdevice    = 0x5030,
+		.driver_data  = SAA7134_BOARD_BEHOLD_503FM,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x5ace,
+		.subdevice    = 0x5010,
+		.driver_data  = SAA7134_BOARD_BEHOLD_501,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index f96cd5d..dbf01aa 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -328,6 +328,8 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG 182
 #define SAA7134_BOARD_VIDEOMATE_M1F         183
 #define SAA7134_BOARD_ENCORE_ENLTV_FM3      184
+#define SAA7134_BOARD_BEHOLD_501            185
+#define SAA7134_BOARD_BEHOLD_503FM          186
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/rO.pexSoCAprg=Jv_JuFbtd--
