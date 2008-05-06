Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m463KjwB022899
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 23:20:45 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net
	(elasmtp-scoter.atl.sa.earthlink.net [209.86.89.67])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m463KXx2020011
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 23:20:33 -0400
Received: from [209.86.224.50] (helo=mswamui-swiss.atl.sa.earthlink.net)
	by elasmtp-scoter.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <aglover.v4l@mindspring.com>) id 1JtDjA-0000UB-1I
	for video4linux-list@redhat.com; Mon, 05 May 2008 23:20:28 -0400
Message-ID: <12116144.1210044027983.JavaMail.root@mswamui-swiss.atl.sa.earthlink.net>
Date: Mon, 5 May 2008 20:20:27 -0700 (GMT-07:00)
From: Adam Glover <aglover.v4l@mindspring.com>
To: video4linux-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: edit patch - ADS Tech Instant HDTV PCI support
Reply-To: Adam Glover <aglover.v4l@mindspring.com>
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

I messed up (it was late at night...)  I apologize.
vmux for composite should be 4

Also, I changed the audio clock value.  The value was one
I obtained from regspy in Windows, however when displaying
the properties of the card, I saw weird numbers for some
attribs...  So I changed it to match several of the
other cards (changed a 3 to a zero) and things look more normal

The corrections are made in the patch below.

Adam Glover

-----Original Message-----
>From: Adam Glover <aglover.v4l@mindspring.com>
>Sent: May 5, 2008 4:15 PM
>To: video4linux-list@redhat.com
>Subject: patch - ADS Tech Instant HDTV PCI support
>
>
>This patch is against the hg snapshot downloaded at around
>04:00 UTC 2008-05-04.
>
>Adam Glover

--- saa7134.h.orig	2008-05-03 22:12:38.000000000 -0700
+++ saa7134.h	2008-05-03 22:15:15.000000000 -0700
@@ -271,6 +271,7 @@
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
+#define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  143
 
 
 #define SAA7134_MAXBOARDS 8

--- saa7134-cards.c.orig	2008-05-03 22:12:20.000000000 -0700
+++ saa7134-cards.c	2008-05-03 22:26:00.000000000 -0700
@@ -4323,6 +4323,30 @@
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
 	},
+	[SAA7134_BOARD_ADS_INSTANT_HDTV_PCI] = {
+		.name           = "ADS Tech Instant HDTV",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TUV1236D,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp,
+                       .vmux = 4,
+                       .amux = LINE1,
+               },{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5327,6 +5351,12 @@
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_T750,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133, /* SAA7135HL */
+		.subvendor    = 0x1421,
+		.subdevice    = 0x0380,
+		.driver_data  = SAA7134_BOARD_ADS_INSTANT_HDTV_PCI,
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -5970,6 +6000,7 @@
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_ADS_INSTANT_HDTV_PCI:
 	case SAA7134_BOARD_KWORLD_ATSC110:
 	{
 		/* enable tuner */
--- saa7134-dvb.c.orig	2008-05-03 22:12:08.000000000 -0700
+++ saa7134-dvb.c	2008-05-03 22:16:35.000000000 -0700
@@ -1155,6 +1155,7 @@
 			dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x61,
 				   NULL, DVB_PLL_TDHU2);
 		break;
+	case SAA7134_BOARD_ADS_INSTANT_HDTV_PCI:
 	case SAA7134_BOARD_KWORLD_ATSC110:
 		dev->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
 					       &dev->i2c_adap);


--
>video4linux-list mailing list
>Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
