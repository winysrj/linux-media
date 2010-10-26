Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62327 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0JZDcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 23:32:45 -0400
Received: by eye27 with SMTP id 27so4894125eye.19
        for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 20:32:44 -0700 (PDT)
Date: Tue, 26 Oct 2010 13:31:40 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Subject: [PATCH] saa7134 behold A7 and H7
Message-ID: <20101026133140.1d4ec6ce@glory.local>
In-Reply-To: <AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
 <AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
 <20100525114939.067404eb@glory.loctelecom.ru>
 <4C32044C.3060007@redhat.com>
 <AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/PN.spnn.XbiQvw2gB=a3hkG"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/PN.spnn.XbiQvw2gB=a3hkG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Fix autodetect for Behold A7 and H7 TV cards.

diff -r abd3aac6644e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jul 02 00:38:54 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Oct 25 09:16:24 2010 +1000
@@ -6700,6 +6700,18 @@
 		.subdevice    = 0x2804,
 		.driver_data  = SAA7134_BOARD_TECHNOTREND_BUDGET_T3000,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7190,
+		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7090,
+		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6737,18 +6749,6 @@
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
 		.driver_data  = SAA7134_BOARD_UNKNOWN,
-	}, {
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
-		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
-		.subdevice    = 0x7190,
-		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
-	}, {
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
-		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
-		.subdevice    = 0x7090,
-		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
 	},{
 		/* --- end of list --- */
 	}

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/PN.spnn.XbiQvw2gB=a3hkG
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_a7_h7_fix.patch

diff -r abd3aac6644e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jul 02 00:38:54 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Oct 25 09:16:24 2010 +1000
@@ -6700,6 +6700,18 @@
 		.subdevice    = 0x2804,
 		.driver_data  = SAA7134_BOARD_TECHNOTREND_BUDGET_T3000,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7190,
+		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7090,
+		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6737,18 +6749,6 @@
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
 		.driver_data  = SAA7134_BOARD_UNKNOWN,
-	}, {
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
-		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
-		.subdevice    = 0x7190,
-		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
-	}, {
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
-		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
-		.subdevice    = 0x7090,
-		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
 	},{
 		/* --- end of list --- */
 	}

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/PN.spnn.XbiQvw2gB=a3hkG--
