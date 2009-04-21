Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3L7Parn017209
	for <video4linux-list@redhat.com>; Tue, 21 Apr 2009 03:25:36 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3L7PLkp009152
	for <video4linux-list@redhat.com>; Tue, 21 Apr 2009 03:25:21 -0400
Received: by fk-out-0910.google.com with SMTP id e30so1225144fke.3
	for <video4linux-list@redhat.com>; Tue, 21 Apr 2009 00:25:21 -0700 (PDT)
Date: Tue, 21 Apr 2009 17:27:04 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20090421172704.4abddb29@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/UPe0uj_6FZ37fDkG5XJxz2Y"
Subject: [PATCH] Behold`s card patch
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

--MP_/UPe0uj_6FZ37fDkG5XJxz2Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Split Beholdr`s cards to correct models.

diff -r 2a6d95947fa1 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Apr 19 20:21:03 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 21 11:21:03 2009 +1000
@@ -4078,9 +4078,43 @@
 	[SAA7134_BOARD_BEHOLD_505FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV 505 FM/RDS",
-		.audio_clock    = 0x00200000,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.name           = "Beholder BeholdTV 505 FM",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
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
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_505RDS] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 505 RDS",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4112,7 +4146,7 @@
 	[SAA7134_BOARD_BEHOLD_507_9FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV 507 FM/RDS / BeholdTV 509 FM",
+		.name           = "Beholder BeholdTV 507 FM / BeholdTV 509 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
@@ -4139,6 +4173,66 @@
 			.amux = LINE2,
 		},
 	},
+	[SAA7134_BOARD_BEHOLD_507RDS_MK5] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 507 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
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
+			.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_507RDS_MK3] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 507 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
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
+			.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
 	[SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
@@ -4173,11 +4267,207 @@
 			.gpio = 0x000A8000,
 		},
 	},
-	[SAA7134_BOARD_BEHOLD_607_9FM] = {
-		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           = "Beholder BeholdTV 607 / BeholdTV 609",
-		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+	[SAA7134_BOARD_BEHOLD_607FM_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609FM_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_607FM_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609FM_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_607RDS_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609RDS_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_607RDS_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609RDS_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4281,8 +4571,7 @@
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
-		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -5770,14 +6059,8 @@
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x0000,
-		.subdevice    = 0x5051,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505FM,
-	},{
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
-		.subvendor    = 0x0000,
 		.subdevice    = 0x505B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -5789,13 +6072,13 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x5071,
-		.driver_data  = SAA7134_BOARD_BEHOLD_507_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_507RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x507B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_507_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_507RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -5819,49 +6102,49 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6070,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607FM_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6071,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607FM_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6072,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6073,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6090,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609FM_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6091,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609FM_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6092,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6093,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -6325,7 +6608,10 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
+	case SAA7134_BOARD_BEHOLD_505RDS:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
 	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
 	case SAA7134_BOARD_REAL_ANGEL_220:
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
@@ -6450,7 +6736,14 @@
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_607FM_MK3:
+	case SAA7134_BOARD_BEHOLD_607FM_MK5:
+	case SAA7134_BOARD_BEHOLD_609FM_MK3:
+	case SAA7134_BOARD_BEHOLD_609FM_MK5:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK5:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
diff -r 2a6d95947fa1 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Apr 19 20:21:03 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Apr 21 11:21:03 2009 +1000
@@ -507,7 +507,10 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
+	case SAA7134_BOARD_BEHOLD_505RDS:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
 		ir_codes     = ir_codes_manli;
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
@@ -718,7 +721,14 @@
 		ir->get_key   = get_key_hvr1110;
 		ir->ir_codes  = ir_codes_hauppauge_new;
 		break;
-	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_607FM_MK3:
+	case SAA7134_BOARD_BEHOLD_607FM_MK5:
+	case SAA7134_BOARD_BEHOLD_609FM_MK3:
+	case SAA7134_BOARD_BEHOLD_609FM_MK5:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK5:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
diff -r 2a6d95947fa1 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Apr 19 20:21:03 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 21 11:21:03 2009 +1000
@@ -253,7 +253,7 @@
 #define SAA7134_BOARD_BEHOLD_505FM	126
 #define SAA7134_BOARD_BEHOLD_507_9FM	127
 #define SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM 128
-#define SAA7134_BOARD_BEHOLD_607_9FM	129
+#define SAA7134_BOARD_BEHOLD_607FM_MK3	129
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE   132
@@ -283,6 +283,16 @@
 #define SAA7134_BOARD_HAUPPAUGE_HVR1110R3   156
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_507UA 157
 #define SAA7134_BOARD_AVERMEDIA_CARDBUS_501 158
+#define SAA7134_BOARD_BEHOLD_505RDS         159
+#define SAA7134_BOARD_BEHOLD_507RDS_MK3     160
+#define SAA7134_BOARD_BEHOLD_507RDS_MK5     161
+#define SAA7134_BOARD_BEHOLD_607FM_MK5      162
+#define SAA7134_BOARD_BEHOLD_609FM_MK3      163
+#define SAA7134_BOARD_BEHOLD_609FM_MK5      164
+#define SAA7134_BOARD_BEHOLD_607RDS_MK3     165
+#define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
+#define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
+#define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/UPe0uj_6FZ37fDkG5XJxz2Y
Content-Type: text/x-patch; name=behold_card_split.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_card_split.patch

diff -r 2a6d95947fa1 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Apr 19 20:21:03 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 21 11:21:03 2009 +1000
@@ -4078,9 +4078,43 @@
 	[SAA7134_BOARD_BEHOLD_505FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV 505 FM/RDS",
-		.audio_clock    = 0x00200000,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.name           = "Beholder BeholdTV 505 FM",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
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
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_505RDS] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 505 RDS",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4112,7 +4146,7 @@
 	[SAA7134_BOARD_BEHOLD_507_9FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV 507 FM/RDS / BeholdTV 509 FM",
+		.name           = "Beholder BeholdTV 507 FM / BeholdTV 509 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
@@ -4139,6 +4173,66 @@
 			.amux = LINE2,
 		},
 	},
+	[SAA7134_BOARD_BEHOLD_507RDS_MK5] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 507 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
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
+			.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_507RDS_MK3] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 507 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
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
+			.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
 	[SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
@@ -4173,11 +4267,207 @@
 			.gpio = 0x000A8000,
 		},
 	},
-	[SAA7134_BOARD_BEHOLD_607_9FM] = {
-		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           = "Beholder BeholdTV 607 / BeholdTV 609",
-		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+	[SAA7134_BOARD_BEHOLD_607FM_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609FM_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_607FM_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609FM_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_607RDS_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609RDS_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_607RDS_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
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
+	},
+	[SAA7134_BOARD_BEHOLD_609RDS_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4281,8 +4571,7 @@
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
-		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -5770,14 +6059,8 @@
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x0000,
-		.subdevice    = 0x5051,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505FM,
-	},{
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
-		.subvendor    = 0x0000,
 		.subdevice    = 0x505B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -5789,13 +6072,13 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x5071,
-		.driver_data  = SAA7134_BOARD_BEHOLD_507_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_507RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x507B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_507_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_507RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -5819,49 +6102,49 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6070,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607FM_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6071,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607FM_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6072,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6073,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6090,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609FM_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6091,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609FM_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6092,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6093,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -6325,7 +6608,10 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
+	case SAA7134_BOARD_BEHOLD_505RDS:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
 	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
 	case SAA7134_BOARD_REAL_ANGEL_220:
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
@@ -6450,7 +6736,14 @@
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_607FM_MK3:
+	case SAA7134_BOARD_BEHOLD_607FM_MK5:
+	case SAA7134_BOARD_BEHOLD_609FM_MK3:
+	case SAA7134_BOARD_BEHOLD_609FM_MK5:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK5:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
diff -r 2a6d95947fa1 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Apr 19 20:21:03 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Apr 21 11:21:03 2009 +1000
@@ -507,7 +507,10 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
+	case SAA7134_BOARD_BEHOLD_505RDS:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
 		ir_codes     = ir_codes_manli;
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
@@ -718,7 +721,14 @@
 		ir->get_key   = get_key_hvr1110;
 		ir->ir_codes  = ir_codes_hauppauge_new;
 		break;
-	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_607FM_MK3:
+	case SAA7134_BOARD_BEHOLD_607FM_MK5:
+	case SAA7134_BOARD_BEHOLD_609FM_MK3:
+	case SAA7134_BOARD_BEHOLD_609FM_MK5:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK5:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
diff -r 2a6d95947fa1 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Apr 19 20:21:03 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 21 11:21:03 2009 +1000
@@ -253,7 +253,7 @@
 #define SAA7134_BOARD_BEHOLD_505FM	126
 #define SAA7134_BOARD_BEHOLD_507_9FM	127
 #define SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM 128
-#define SAA7134_BOARD_BEHOLD_607_9FM	129
+#define SAA7134_BOARD_BEHOLD_607FM_MK3	129
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE   132
@@ -283,6 +283,16 @@
 #define SAA7134_BOARD_HAUPPAUGE_HVR1110R3   156
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_507UA 157
 #define SAA7134_BOARD_AVERMEDIA_CARDBUS_501 158
+#define SAA7134_BOARD_BEHOLD_505RDS         159
+#define SAA7134_BOARD_BEHOLD_507RDS_MK3     160
+#define SAA7134_BOARD_BEHOLD_507RDS_MK5     161
+#define SAA7134_BOARD_BEHOLD_607FM_MK5      162
+#define SAA7134_BOARD_BEHOLD_609FM_MK3      163
+#define SAA7134_BOARD_BEHOLD_609FM_MK5      164
+#define SAA7134_BOARD_BEHOLD_607RDS_MK3     165
+#define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
+#define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
+#define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
--MP_/UPe0uj_6FZ37fDkG5XJxz2Y
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/UPe0uj_6FZ37fDkG5XJxz2Y--
