Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5JrkMU029401
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 14:53:46 -0500
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5JrfL1022521
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 14:53:41 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org
Content-Type: multipart/mixed; boundary="=-FaPlB22E05og3T+Ptjem"
Date: Fri, 05 Dec 2008 20:49:34 +0100
Message-Id: <1228506574.2891.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: [PATCH] saa7134: add analog and DVB-T support for Medion/Creatix
	CTX946
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


--=-FaPlB22E05og3T+Ptjem
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Hermann Pitton <hermann-pitton@arcor.de>
# Date 1228504664 -3600
# Node ID 011294745fd95f6ee40ae5480f7ca30322a667af
# Parent  6a9d064fe0ee266926ada3e5a57057a07df1d73d
saa7134: add analog and DVB-T support for Medion/Creatix CTX946

From: Hermann Pitton <hermann-pitton@arcor.de>

How to enable the mpeg encoder is not found yet.
The card comes up with gpio 0x0820000 for DVB-T.

Priority: normal

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r 6a9d064fe0ee -r 011294745fd9 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Dec 05 11:49:53 2008 -0200
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Dec 05 20:17:44 2008 +0100
@@ -10,7 +10,7 @@
   9 -> Medion 5044
  10 -> Kworld/KuroutoShikou SAA7130-TVPCI
  11 -> Terratec Cinergy 600 TV                  [153b:1143]
- 12 -> Medion 7134                              [16be:0003]
+ 12 -> Medion 7134                              [16be:0003,16be:5000]
  13 -> Typhoon TV+Radio 90031
  14 -> ELSA EX-VISION 300TV                     [1048:226b]
  15 -> ELSA EX-VISION 500TV                     [1048:226a]
diff -r 6a9d064fe0ee -r 011294745fd9 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Dec 05 11:49:53 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Dec 05 20:17:44 2008 +0100
@@ -4774,6 +4774,12 @@
 		.subdevice    = 0x0003,
 		.driver_data  = SAA7134_BOARD_MD7134,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x16be, /* CTX946 analog TV, HW mpeg, DVB-T */
+		.subdevice    = 0x5000, /* only analog TV and DVB-T for now */
+		.driver_data  = SAA7134_BOARD_MD7134,
+	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x1048,


--=-FaPlB22E05og3T+Ptjem
Content-Disposition: inline;
	filename*0=saa7134_add_analog_and_DVB-T_support_for_Medion-Creatix_CTX94;
	filename*1=6.patch
Content-Type: text/x-patch;
	name*0=saa7134_add_analog_and_DVB-T_support_for_Medion-Creatix_CTX946.pa;
	name*1=tch; charset=UTF-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Hermann Pitton <hermann-pitton@arcor.de>
# Date 1228504664 -3600
# Node ID 011294745fd95f6ee40ae5480f7ca30322a667af
# Parent  6a9d064fe0ee266926ada3e5a57057a07df1d73d
saa7134: add analog and DVB-T support for Medion/Creatix CTX946

From: Hermann Pitton <hermann-pitton@arcor.de>

How to enable the mpeg encoder is not found yet.
The card comes up with gpio 0x0820000 for DVB-T.

Priority: normal

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r 6a9d064fe0ee -r 011294745fd9 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Dec 05 11:49:53 2008 -0200
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Dec 05 20:17:44 2008 +0100
@@ -10,7 +10,7 @@
   9 -> Medion 5044
  10 -> Kworld/KuroutoShikou SAA7130-TVPCI
  11 -> Terratec Cinergy 600 TV                  [153b:1143]
- 12 -> Medion 7134                              [16be:0003]
+ 12 -> Medion 7134                              [16be:0003,16be:5000]
  13 -> Typhoon TV+Radio 90031
  14 -> ELSA EX-VISION 300TV                     [1048:226b]
  15 -> ELSA EX-VISION 500TV                     [1048:226a]
diff -r 6a9d064fe0ee -r 011294745fd9 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Dec 05 11:49:53 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Dec 05 20:17:44 2008 +0100
@@ -4774,6 +4774,12 @@
 		.subdevice    = 0x0003,
 		.driver_data  = SAA7134_BOARD_MD7134,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x16be, /* CTX946 analog TV, HW mpeg, DVB-T */
+		.subdevice    = 0x5000, /* only analog TV and DVB-T for now */
+		.driver_data  = SAA7134_BOARD_MD7134,
+	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x1048,

--=-FaPlB22E05og3T+Ptjem
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-FaPlB22E05og3T+Ptjem--
