Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBN3nAZu021537
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 22:49:10 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBN3mqJv019917
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 22:48:53 -0500
Received: by ey-out-2122.google.com with SMTP id 4so231520eyf.39
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 19:48:52 -0800 (PST)
Date: Tue, 23 Dec 2008 12:51:38 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Message-ID: <20081223125138.4b2c16de@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ndqVF=p1wNmYMpdjp41A503"
Cc: 
Subject: [PATCH 2/3] Add support DVB-T for the Beholder H6 card.
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

--MP_/ndqVF=p1wNmYMpdjp41A503
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all

Change configuration of the Beholder H6 card.

diff -r 6032ecd6ad7e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Oct 07 09:06:25 2008 +1000
@@ -4427,26 +4427,25 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 3,
-			.amux = TV,
-			.tv   = 1,
-		}, {
-			.name = name_comp1,
-			.vmux = 1,
-			.amux = LINE1,
-		}, {
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
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
 	},
 };
 
@@ -5853,6 +5852,7 @@
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
+	case SAA7134_BOARD_BEHOLD_H6:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/ndqVF=p1wNmYMpdjp41A503
Content-Type: text/x-patch; name=saa7134_cards_h6.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134_cards_h6.patch

diff -r 6032ecd6ad7e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Oct 07 09:06:25 2008 +1000
@@ -4427,26 +4427,25 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 3,
-			.amux = TV,
-			.tv   = 1,
-		}, {
-			.name = name_comp1,
-			.vmux = 1,
-			.amux = LINE1,
-		}, {
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
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
 	},
 };
 
@@ -5853,6 +5852,7 @@
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
+	case SAA7134_BOARD_BEHOLD_H6:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/ndqVF=p1wNmYMpdjp41A503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/ndqVF=p1wNmYMpdjp41A503--
