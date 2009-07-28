Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:50121 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZG1G4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 02:56:38 -0400
Received: by fxm12 with SMTP id 12so174685fxm.37
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2009 23:56:37 -0700 (PDT)
Date: Tue, 28 Jul 2009 16:48:50 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Fix incorrect type of tuner for the BeholdTV H6 card.
Message-ID: <20090728164850.16328d20@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/uVGqZVMN.OkJK5iFIZM2hae"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/uVGqZVMN.OkJK5iFIZM2hae
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all

Define correct tuner in config. Radio now works fine.

diff -r f8f134705b65 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jul 24 16:19:39 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jul 28 14:54:29 2009 +1000
@@ -4900,7 +4900,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		.name           = "Beholder BeholdTV H6",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.tuner_type     = TUNER_PHILIPS_FMD1216MEX_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
diff -r f8f134705b65 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Jul 24 16:19:39 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Jul 28 14:54:29 2009 +1000
@@ -1461,7 +1461,7 @@
 		if (fe0->dvb.frontend) {
 			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x61,
-				   TUNER_PHILIPS_FMD1216ME_MK3);
+				   TUNER_PHILIPS_FMD1216MEX_MK3);
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A700_PRO:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/uVGqZVMN.OkJK5iFIZM2hae
Content-Type: text/x-patch; name=h6_fix_tuner_type.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=h6_fix_tuner_type.patch

diff -r f8f134705b65 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jul 24 16:19:39 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jul 28 14:54:29 2009 +1000
@@ -4900,7 +4900,7 @@
 		/* Igor Kuznetsov <igk@igk.ru> */
 		.name           = "Beholder BeholdTV H6",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.tuner_type     = TUNER_PHILIPS_FMD1216MEX_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
diff -r f8f134705b65 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Jul 24 16:19:39 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Jul 28 14:54:29 2009 +1000
@@ -1461,7 +1461,7 @@
 		if (fe0->dvb.frontend) {
 			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x61,
-				   TUNER_PHILIPS_FMD1216ME_MK3);
+				   TUNER_PHILIPS_FMD1216MEX_MK3);
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A700_PRO:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
--MP_/uVGqZVMN.OkJK5iFIZM2hae--
