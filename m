Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52887 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0CJPpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 10:45:02 -0500
Received: by bwz1 with SMTP id 1so5058168bwz.21
        for <linux-media@vger.kernel.org>; Wed, 10 Mar 2010 07:45:01 -0800 (PST)
Subject: [PATCH] saa7134: add capture boards Hawell HW-404M7 and HW-808M7
From: Vladimir Ermakov <vooon341@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 18:44:57 +0300
Message-ID: <1268235897.25823.31.camel@desinto.vehq>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds new capture boards Hawell HW-404M7 and HW-808M7.
Those cards have 4 or 8 SAA7130 chips and for the work it only needs initialize registers.
The value of those registers were dumped under Windows using flytest.
But board haven't EEPROM.

For the first chip:

 SAA7130 (0x7130, SubVenID:1131, SubDevID:0000, Rev: 01)

 I2C slave devices found:
 No devices

 GPIO pins:
 Mode : 0x00389C00
 Value: 0x00016C00

 Video input: 3
 Audio input: Analog Line1

For other chips:

 SAA7130 (0x7130, SubVenID:1131, SubDevID:0000, Rev: 01)

 I2C slave devices found:
 No devices

 GPIO pins:
 Mode : 0x00389200
 Value: 0x00010000

 Video input: 3
 Audio input: Analog Line1

Signed-off-by: Vladimir Ermakov <vooon341@gmail.com>

# HG changeset patch
# User Vladimir Ermakov <vooon341@gmail.com>
# Date 1268232221 -10800
# Node ID 072cd67c6aabe0e700a9e4727b50ad6424cb59f5
# Parent  7a58d924fb049ff1d318514939b3a7e416670c13
saa7134: add Hawell HW-404M7 & HW-808M7

diff -r 7a58d924fb04 -r 072cd67c6aab linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Tue Mar 09 23:00:59 2010 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Wed Mar 10 17:43:41 2010 +0300
@@ -175,3 +175,4 @@
 174 -> Asus Europa Hybrid OEM                   [1043:4847]
 175 -> Leadtek Winfast DTV1000S                 [107d:6655]
 176 -> Beholder BeholdTV 505 RDS                [0000:5051]
+177 -> Hawell HW-404M7 / HW-808M7
diff -r 7a58d924fb04 -r 072cd67c6aab linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Mar 09 23:00:59 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Mar 10 17:43:41 2010 +0300
@@ -5394,6 +5394,23 @@
 			.amux = LINE2,
 		},
 	},
+	[SAA7134_BOARD_HAWELL_HW_404M7] = {
+		/* Hawell HW-404M7 & Hawell HW-808M7  */
+		/* Bogoslovskiy Viktor <bogovic@bk.ru> */
+		.name         = "Hawell HW-404M7",
+		.audio_clock   = 0x00200000,
+		.tuner_type    = UNSET,
+		.radio_type    = UNSET,
+		.tuner_addr   = ADDR_UNSET,
+		.radio_addr   = ADDR_UNSET,
+		.gpiomask      = 0x01fc00,
+		.inputs       = {{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x389c00,
+		} },
+	},
 
 };
 
diff -r 7a58d924fb04 -r 072cd67c6aab linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Mar 09 23:00:59 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed Mar 10 17:43:41 2010 +0300
@@ -529,6 +529,7 @@
 	switch (dev->board) {
 	case SAA7134_BOARD_FLYVIDEO2000:
 	case SAA7134_BOARD_FLYVIDEO3000:
+	case SAA7134_BOARD_HAWELL_HW_404M7:
 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
diff -r 7a58d924fb04 -r 072cd67c6aab linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Tue Mar 09 23:00:59 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Mar 10 17:43:41 2010 +0300
@@ -301,6 +301,7 @@
 #define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
 #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
 #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
+#define SAA7134_BOARD_HAWELL_HW_404M7		177
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8


