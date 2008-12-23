Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBN3oYjf022313
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 22:50:34 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBN3oGNC020703
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 22:50:17 -0500
Received: by ewy14 with SMTP id 14so2410797ewy.3
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 19:50:16 -0800 (PST)
Date: Tue, 23 Dec 2008 12:53:03 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Message-ID: <20081223125303.2ddc0623@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/St+ERre_Yi+TN6IsuJQDtiO"
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

--MP_/St+ERre_Yi+TN6IsuJQDtiO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all

Add the Beholder H6 card to DVB-T part of sources.

diff -r 6032ecd6ad7e linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Oct 07 09:06:25 2008 +1000
@@ -48,6 +48,8 @@
 #include "isl6405.h"
 #include "lnbp21.h"
 #include "tuner-simple.h"
+
+#include "zl10353.h"
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
@@ -838,6 +840,12 @@
 	.if_freq       = TDA10046_FREQ_045,
 	.tuner_address = 0x61,
 	.request_firmware = philips_tda1004x_request_firmware
+};
+
+static struct zl10353_config behold_h6_config = {
+	.demod_address = 0x1e>>1,
+	.no_tuner      = 1,
+	.parallel_ts   = 1,
 };
 
 /* ==================================================================
@@ -1304,6 +1312,16 @@
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
+	case SAA7134_BOARD_BEHOLD_H6:
+		dev->dvb.frontend = dvb_attach(zl10353_attach,
+						&behold_h6_config,
+						&dev->i2c_adap);
+		if (dev->dvb.frontend) {
+			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+				   &dev->i2c_adap, 0x61,
+				   TUNER_PHILIPS_FMD1216ME_MK3);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/St+ERre_Yi+TN6IsuJQDtiO
Content-Type: text/x-patch; name=saa7134_dvb-t_h6.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134_dvb-t_h6.patch

diff -r 6032ecd6ad7e linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Oct 07 09:06:25 2008 +1000
@@ -48,6 +48,8 @@
 #include "isl6405.h"
 #include "lnbp21.h"
 #include "tuner-simple.h"
+
+#include "zl10353.h"
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
@@ -838,6 +840,12 @@
 	.if_freq       = TDA10046_FREQ_045,
 	.tuner_address = 0x61,
 	.request_firmware = philips_tda1004x_request_firmware
+};
+
+static struct zl10353_config behold_h6_config = {
+	.demod_address = 0x1e>>1,
+	.no_tuner      = 1,
+	.parallel_ts   = 1,
 };
 
 /* ==================================================================
@@ -1304,6 +1312,16 @@
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
+	case SAA7134_BOARD_BEHOLD_H6:
+		dev->dvb.frontend = dvb_attach(zl10353_attach,
+						&behold_h6_config,
+						&dev->i2c_adap);
+		if (dev->dvb.frontend) {
+			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+				   &dev->i2c_adap, 0x61,
+				   TUNER_PHILIPS_FMD1216ME_MK3);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/St+ERre_Yi+TN6IsuJQDtiO
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/St+ERre_Yi+TN6IsuJQDtiO--
