Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5AB4QMr021781
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 07:04:26 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5AB3xxu004032
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 07:03:59 -0400
Received: by fg-out-1718.google.com with SMTP id e21so2028013fga.7
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 04:03:58 -0700 (PDT)
Date: Tue, 10 Jun 2008 21:06:05 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
Message-ID: <20080610210605.0973d518@glory.loctelecom.ru>
In-Reply-To: <1211331167.4235.26.camel@pc10.localdom.local>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Tn1Utn7pA1zq/BWH0QZdxgA"
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Beholder`s cards description
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/Tn1Utn7pA1zq/BWH0QZdxgA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Split the Beholder M6 family to different models. Because M6 hasn`t RDS, M63 has chip with AC3 codec, M6 Extra has other type of HF module.
Add correct data for support MPEG encoder.

diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jun 10 20:29:09 2008 +1000
@@ -3979,32 +3979,111 @@ struct saa7134_board saa7134_boards[] = 
 	[SAA7134_BOARD_BEHOLD_M6] = {
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           = "Beholder BeholdTV M6 / BeholdTV M6 Extra",
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 3,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name = name_comp1,
-			.vmux = 1,
-			.amux = LINE1,
-		},{
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		}},
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
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
 		.radio = {
 			.name = name_radio,
 			.amux = LINE2,
 		},
 		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+	},
+	[SAA7134_BOARD_BEHOLD_M63] = {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV M63",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
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
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+	},
+	[SAA7134_BOARD_BEHOLD_M6_EXTRA] = {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV M6 Extra",
+		.audio_clock    = 0x00187de7,
+		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
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
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
 	},
 	[SAA7134_BOARD_TWINHAN_DTV_DVB_3056] = {
 		.name           = "Twinhan Hybrid DTV-DVB 3056 PCI",
@@ -5272,13 +5351,13 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6193,
-		.driver_data  = SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  = SAA7134_BOARD_BEHOLD_M6_EXTRA,
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6191,
-		.driver_data  = SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  = SAA7134_BOARD_BEHOLD_M63,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -5702,6 +5781,8 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Jun 09 15:16:05 2008 +1000
@@ -541,6 +541,8 @@ void saa7134_set_i2c_ir(struct saa7134_d
 		break;
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   = get_key_beholdm6xx;
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Jun 10 20:07:13 2008 +1000
@@ -271,7 +271,8 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
-
+#define SAA7134_BOARD_BEHOLD_M63      143
+#define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/Tn1Utn7pA1zq/BWH0QZdxgA
Content-Type: text/x-patch; name=beholder_cards_01.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=beholder_cards_01.diff

diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jun 10 20:29:09 2008 +1000
@@ -3979,32 +3979,111 @@ struct saa7134_board saa7134_boards[] = 
 	[SAA7134_BOARD_BEHOLD_M6] = {
 		/* Igor Kuznetsov <igk@igk.ru> */
 		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           = "Beholder BeholdTV M6 / BeholdTV M6 Extra",
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 3,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name = name_comp1,
-			.vmux = 1,
-			.amux = LINE1,
-		},{
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		}},
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
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
 		.radio = {
 			.name = name_radio,
 			.amux = LINE2,
 		},
 		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+	},
+	[SAA7134_BOARD_BEHOLD_M63] = {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV M63",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
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
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+	},
+	[SAA7134_BOARD_BEHOLD_M6_EXTRA] = {
+		/* Igor Kuznetsov <igk@igk.ru> */
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV M6 Extra",
+		.audio_clock    = 0x00187de7,
+		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
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
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
 	},
 	[SAA7134_BOARD_TWINHAN_DTV_DVB_3056] = {
 		.name           = "Twinhan Hybrid DTV-DVB 3056 PCI",
@@ -5272,13 +5351,13 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6193,
-		.driver_data  = SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  = SAA7134_BOARD_BEHOLD_M6_EXTRA,
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6191,
-		.driver_data  = SAA7134_BOARD_BEHOLD_M6,
+		.driver_data  = SAA7134_BOARD_BEHOLD_M63,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -5702,6 +5781,8 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Jun 09 15:16:05 2008 +1000
@@ -541,6 +541,8 @@ void saa7134_set_i2c_ir(struct saa7134_d
 		break;
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
 		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
 		ir->get_key   = get_key_beholdm6xx;
diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Jun 10 20:07:13 2008 +1000
@@ -271,7 +271,8 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
-
+#define SAA7134_BOARD_BEHOLD_M63      143
+#define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/Tn1Utn7pA1zq/BWH0QZdxgA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/Tn1Utn7pA1zq/BWH0QZdxgA--
