Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:49855 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117AbZHTX64 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 19:58:56 -0400
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net [151.189.8.85])
	by mx.arcor.de (Postfix) with ESMTP id C9B2E33A739
	for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 01:58:56 +0200 (CEST)
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net [151.189.21.57])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id B5951107D2B
	for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 01:58:56 +0200 (CEST)
Received: from [192.168.178.24] (pD9E110E8.dip0.t-ipconnect.de [217.225.16.232])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-17.arcor-online.net (Postfix) with ESMTPSA id 98C063B269D
	for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 01:58:56 +0200 (CEST)
Subject: [PATCH] saa7134: start to investigate the LNA mess on 310i and
	hvr1110 products
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-szTUAo47VDqMrXZq0Yur"
Date: Fri, 21 Aug 2009 01:49:24 +0200
Message-Id: <1250812164.3249.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-szTUAo47VDqMrXZq0Yur
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


There is a great maintenance mess for those devices currently.

All attempts, to get some further information out of those assumed to be
closest to the above manufactures, failed.

Against any previous advice, newer products with an additional LNA,
which needs to be configured correctly, have been added and we can't
make any difference to previous products without LNA.

Even more, the type of LNA configuration, either over tuner gain or some
on the analog IF demodulator, conflicts within this two devices itself.

Since we never had a chance, to see such devices with all details
reported to our lists, but might still be able to make eventually a
difference, to get out of that mess, we should prefer to start exactly
where it started.

Signed-off-by: hermann pitton <hermann-pitton@arcor.de>

diff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Aug 20
01:30:58 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Aug 21
01:28:37 2009 +0200
@@ -3242,7 +3242,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tuner_config   = 1,
+		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x000200000,
 		.inputs         = {{
@@ -3346,7 +3346,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tuner_config   = 1,
+		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200100,
 		.inputs         = {{
diff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Aug 20
01:30:58 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Aug 21
01:28:37 2009 +0200
@@ -1144,12 +1144,12 @@
 		break;
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
-					 &tda827x_cfg_1) < 0)
+					 &tda827x_cfg_0) < 0)
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
-					 &tda827x_cfg_1) < 0)
+					 &tda827x_cfg_0) < 0)
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:


--=-szTUAo47VDqMrXZq0Yur
Content-Description: 
Content-Disposition: inline; filename*0=saa7134_start-to-investigate-the-lna-mess-on-310i-and-hvr1110; filename*1=.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Aug 20 01:30:58 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Aug 21 01:28:37 2009 +0200
@@ -3242,7 +3242,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tuner_config   = 1,
+		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x000200000,
 		.inputs         = {{
@@ -3346,7 +3346,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tuner_config   = 1,
+		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200100,
 		.inputs         = {{
diff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Aug 20 01:30:58 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Aug 21 01:28:37 2009 +0200
@@ -1144,12 +1144,12 @@
 		break;
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
-					 &tda827x_cfg_1) < 0)
+					 &tda827x_cfg_0) < 0)
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
-					 &tda827x_cfg_1) < 0)
+					 &tda827x_cfg_0) < 0)
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:

--=-szTUAo47VDqMrXZq0Yur--

