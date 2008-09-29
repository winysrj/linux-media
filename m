Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8T2TZf7001719
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 22:29:41 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8T2OpPC012650
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 22:25:26 -0400
Received: by ey-out-2122.google.com with SMTP id 4so460104eyf.39
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 19:24:51 -0700 (PDT)
Date: Mon, 29 Sep 2008 12:25:40 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080929122540.154fcbbc@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/9e4y5kghFZP6eMlcICO1h9O"
Subject: Re: [REGRESSION, PATCH] I2C remote controls on saa7134
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

--MP_/9e4y5kghFZP6eMlcICO1h9O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All.

This is patch for solve this regression. Load ir-kbd-i2c module when remote is i2c type.

diff -r 8e6cda021e0e linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Fri Sep 26 11:29:03 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Mon Sep 29 06:20:59 2008 +1000
@@ -760,6 +760,10 @@
 			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18A;
 	}
 
+	if (dev->has_remote == SAA7134_REMOTE_I2C) {
+		request_module("ir-kbd-i2c");
+	}
+
 	saa_writel(SAA7134_IRQ1, 0);
 	saa_writel(SAA7134_IRQ2, irq2_mask);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/9e4y5kghFZP6eMlcICO1h9O
Content-Type: text/x-patch; name=saa7134_ir-kbd-i2c.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134_ir-kbd-i2c.patch

diff -r 8e6cda021e0e linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Fri Sep 26 11:29:03 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Mon Sep 29 06:20:59 2008 +1000
@@ -760,6 +760,10 @@
 			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18A;
 	}
 
+	if (dev->has_remote == SAA7134_REMOTE_I2C) {
+		request_module("ir-kbd-i2c");
+	}
+
 	saa_writel(SAA7134_IRQ1, 0);
 	saa_writel(SAA7134_IRQ2, irq2_mask);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/9e4y5kghFZP6eMlcICO1h9O
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/9e4y5kghFZP6eMlcICO1h9O--
