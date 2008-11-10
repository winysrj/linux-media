Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAMnIFP011928
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 17:49:18 -0500
Received: from mail11d.verio-web.com (mail11d.verio-web.com [204.202.242.86])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAAMn1vg020617
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 17:49:02 -0500
Received: from mx103.stngva01.us.mxservers.net (198.173.112.40)
	by mail11d.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-0725957341
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 17:49:01 -0500 (EST)
From: Pete Eberlein <pete@sensoray.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Mon, 10 Nov 2008 14:52:19 -0800
Message-Id: <1226357539.8035.20.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Gerd Knorr <kraxel@bytesex.org>
Subject: [PATCH] saa7134: Add new cards
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

Added new hybrid cards using saa7134 and go7007 chip.
- WIS Voyager or compatible
- Sensoray model 314
- Sensoray model 614
For these boards, module saa7134-go7007 (in staging) is loaded to
interface with the go7007 MPEG encoder chip.

Signed-off-by: Pete Eberlein <pete@sensoray.com>


diff -r bb00cb692462 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Mon Nov 10 19:56:20 2008 -0200
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Mon Nov 10 14:42:19 2008 -0800
@@ -151,3 +151,6 @@ 150 -> Zogis Real Angel 220
 150 -> Zogis Real Angel 220
 151 -> ADS Tech Instant HDTV                    [1421:0380]
 152 -> Asus Tiger Rev:1.00                      [1043:4857]
+153 -> WIS Voyager or compatible                [1905:7007]
+154 -> Sensoray model 314                       [6000:0314]
+155 -> Sensoray model 614                       [6000:0614]
diff -r bb00cb692462 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Nov 10 19:56:20 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Nov 10 14:42:19 2008 -0800
@@ -4645,6 +4645,76 @@ struct saa7134_board saa7134_boards[] = 
 			.gpio   = 0x0200000,
 		},
 	},
+	[SAA7134_BOARD_WIS_VOYAGER] = {
+		.name           = "WIS Voyager or compatible",
+		.audio_clock    = 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.inputs		= { {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+		.amux = LINE1,
+		} },
+		.mpeg		= SAA7134_MPEG_GO7007,
+	},
+	[SAA7134_BOARD_SENSORAY_314] = {
+		.name		= "Sensoray 314 board",
+		.audio_clock	= 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.inputs		= { {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 7,
+			.amux = LINE2,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_comp2,
+			.vmux = 1,
+			.amux = LINE2,
+		}, {
+			.name = name_comp3,
+			.vmux = 2,
+			.amux = LINE2,
+		}, {
+			.name = name_comp4,
+			.vmux = 3,
+			.amux = LINE2,
+		} },
+		.mpeg		= SAA7134_MPEG_GO7007,
+	},
+	[SAA7134_BOARD_SENSORAY_614] = {
+		.name		= "Sensoray 614 board",
+		.audio_clock	= 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.inputs		= { {
+			.name = name_comp,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+			.amux = LINE2,
+		} },
+		.mpeg		= SAA7134_MPEG_GO7007,
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5691,6 +5761,24 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subvendor    = 0x1043,
 		.subdevice    = 0x4878, /* REV:1.02G */
 		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1905, /* WIS */
+		.subdevice    = 0x7007,
+		.driver_data  = SAA7134_BOARD_WIS_VOYAGER,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x6000,
+		.subdevice    = 0x0314,
+		.driver_data  = SAA7134_BOARD_SENSORAY_314,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x6000,
+		.subdevice    = 0x0614,
+		.driver_data  = SAA7134_BOARD_SENSORAY_614,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
diff -r bb00cb692462 linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Mon Nov 10 19:56:20 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Mon Nov 10 14:42:19 2008 -0800
@@ -201,6 +201,8 @@ static void request_module_async(struct 
 		request_module("saa7134-empress");
 	if (card_is_dvb(dev))
 		request_module("saa7134-dvb");
+	if (card_is_go7007(dev))
+		request_module("saa7134-go7007");
 	if (alsa)
 		request_module("saa7134-alsa");
 	if (oss)
@@ -601,15 +603,19 @@ static irqreturn_t saa7134_irq(int irq, 
 
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA0) &&
 		    (status & 0x60) == 0)
-			saa7134_irq_video_done(dev,status);
+			saa7134_irq_video_done(dev, status);
 
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA0) &&
 		    (status & 0x40) == 0x40)
-			saa7134_irq_vbi_done(dev,status);
+			saa7134_irq_vbi_done(dev, status);
 
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA2) &&
-		    card_has_mpeg(dev))
-			saa7134_irq_ts_done(dev,status);
+		    card_has_mpeg(dev)) {
+			if (dev->mops->irq_ts_done != NULL)
+				dev->mops->irq_ts_done(dev, status);
+			else
+				saa7134_irq_ts_done(dev, status);
+		}
 
 		if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			switch (dev->has_remote) {
diff -r bb00cb692462 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Mon Nov 10 19:56:20 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Nov 10 14:42:19 2008 -0800
@@ -276,6 +276,9 @@ struct saa7134_format {
 #define SAA7134_BOARD_REAL_ANGEL_220     150
 #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
 #define SAA7134_BOARD_ASUSTeK_TIGER         152
+#define SAA7134_BOARD_WIS_VOYAGER 153
+#define SAA7134_BOARD_SENSORAY_314 154
+#define SAA7134_BOARD_SENSORAY_614 155
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
@@ -306,6 +309,7 @@ enum saa7134_mpeg_type {
 	SAA7134_MPEG_UNUSED,
 	SAA7134_MPEG_EMPRESS,
 	SAA7134_MPEG_DVB,
+	SAA7134_MPEG_GO7007,
 };
 
 struct saa7134_board {
@@ -336,6 +340,7 @@ struct saa7134_board {
 #define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
 #define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS == saa7134_boards[dev->board].mpeg)
 #define card_is_dvb(dev)      (SAA7134_MPEG_DVB     == saa7134_boards[dev->board].mpeg)
+#define card_is_go7007(dev)   (SAA7134_MPEG_GO7007  == saa7134_boards[dev->board].mpeg)
 #define card_has_mpeg(dev)    (SAA7134_MPEG_UNUSED  != saa7134_boards[dev->board].mpeg)
 #define card(dev)             (saa7134_boards[dev->board])
 #define card_in(dev,n)        (saa7134_boards[dev->board].inputs[n])
@@ -470,6 +475,8 @@ struct saa7134_mpeg_ops {
 	struct list_head           next;
 	int                        (*init)(struct saa7134_dev *dev);
 	int                        (*fini)(struct saa7134_dev *dev);
+	void                       (*irq_ts_done)(struct saa7134_dev *dev,
+						  unsigned long status);
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
