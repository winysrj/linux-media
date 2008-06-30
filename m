Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UHmVo0029475
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 13:48:31 -0400
Received: from smtp-out113.alice.it (smtp-out113.alice.it [85.37.17.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UHmI2c024062
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 13:48:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by smtp.piccio.org (Postfix) with ESMTP id 5E1091FAD
	for <video4linux-list@redhat.com>;
	Mon, 30 Jun 2008 19:51:14 +0200 (CEST)
Message-ID: <48691C57.7000607@piccio.org>
Date: Mon, 30 Jun 2008 19:48:07 +0200
From: Massimo Piccioni <alsa@piccio.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [PATCH] saa7134 - add support for AVerMedia M103
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

Hi all,

the following patch updates saa7134 driver to add support for AVerMedia 
M103 MiniPCI DVB-T Hybrid card.
Please apply.

Ciao,
Massimo


Signed-off-by: Massimo Piccioni <alsa piccio org>


---
diff -uprN v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c 
v4l-dvb-new/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2008-06-30 
16:11:36.000000000 +0200
+++ v4l-dvb-new/linux/drivers/media/video/saa7134/saa7134-cards.c 
2008-06-30 17:34:43.000000000 +0200
@@ -4399,6 +4399,22 @@ struct saa7134_board saa7134_boards[] =
  		/* no DVB support for now */
  		/* .mpeg           = SAA7134_MPEG_DVB, */
  	},
+	[SAA7134_BOARD_AVERMEDIA_M103] = {
+		/* Massimo Piccioni <dafastidio@libero.it> */
+		.name           = "AVerMedia MiniPCI DVB-T Hybrid M103",
+		.audio_clock    = 0x187de7,
+		.tuner_type     = TUNER_XC2028,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		 .mpeg           = SAA7134_MPEG_DVB,
+		 .inputs         = {{
+			 .name = name_tv,
+			 .vmux = 1,
+			 .amux = TV,
+			 .tv   = 1,
+		 } },
+	},
  };

  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5415,6 +5431,12 @@ struct pci_device_id saa7134_pci_tbl[] =
  		.subvendor    = 0x5ace,
  		.subdevice    = 0x6290,
  		.driver_data  = SAA7134_BOARD_BEHOLD_H6,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xf636,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_M103,
  	}, {
  		/* --- boards without eeprom + subsystem ID --- */
  		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -5517,6 +5539,7 @@ static int saa7134_xc2028_callback(struc
  		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
  		switch (dev->board) {
  		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		case SAA7134_BOARD_AVERMEDIA_M103:
  			saa7134_set_gpio(dev, 23, 0);
  			msleep(10);
  			saa7134_set_gpio(dev, 23, 1);
@@ -5750,6 +5773,7 @@ int saa7134_board_init1(struct saa7134_d
  		msleep(10);
  		break;
  	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+	case SAA7134_BOARD_AVERMEDIA_M103:
  		saa7134_set_gpio(dev, 23, 0);
  		msleep(10);
  		saa7134_set_gpio(dev, 23, 1);
@@ -5877,6 +5901,7 @@ static void saa7134_tuner_setup(struct s
  		switch (dev->board) {
  		case SAA7134_BOARD_AVERMEDIA_A16D:
  		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		case SAA7134_BOARD_AVERMEDIA_M103:
  			ctl.demod = XC3028_FE_ZARLINK456;
  			break;
  		default:
diff -uprN v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c 
v4l-dvb-new/linux/drivers/media/video/saa7134/saa7134-dvb.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c	2008-06-30 
16:11:36.000000000 +0200
+++ v4l-dvb-new/linux/drivers/media/video/saa7134/saa7134-dvb.c 
2008-06-30 17:27:41.000000000 +0200
@@ -1263,6 +1263,7 @@ static int dvb_init(struct saa7134_dev *
  						&avermedia_xc3028_mt352_dev,
  						&dev->i2c_adap);
  		attach_xc3028 = 1;
+		break;
  #if 0
  	/*FIXME: What frontend does Videomate T750 use? */
  	case SAA7134_BOARD_VIDEOMATE_T750:
@@ -1294,6 +1295,15 @@ static int dvb_init(struct saa7134_dev *
  			fe->ops.enable_high_lnb_voltage = md8800_set_high_voltage;
  		}
  		break;
+	case SAA7134_BOARD_AVERMEDIA_M103:
+		saa7134_set_gpio(dev, 25, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 25, 1);
+		dev->dvb.frontend = dvb_attach(mt352_attach,
+						&avermedia_xc3028_mt352_dev,
+						&dev->i2c_adap);
+		attach_xc3028 = 1;
+		break;
  	default:
  		wprintk("Huh? unknown DVB card?\n");
  		break;
diff -uprN v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h 
v4l-dvb-new/linux/drivers/media/video/saa7134/saa7134.h
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h	2008-06-30 
16:11:36.000000000 +0200
+++ v4l-dvb-new/linux/drivers/media/video/saa7134/saa7134.h	2008-06-30 
17:27:16.000000000 +0200
@@ -273,6 +273,7 @@ struct saa7134_format {
  #define SAA7134_BOARD_BEHOLD_H6      142
  #define SAA7134_BOARD_BEHOLD_M63      143
  #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
+#define SAA7134_BOARD_AVERMEDIA_M103    145

  #define SAA7134_MAXBOARDS 8
  #define SAA7134_INPUT_MAX 8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
