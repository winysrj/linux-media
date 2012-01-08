Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:33540 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab2AGVBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 16:01:41 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout2.freenet.de with esmtpa (ID saschasommer@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rjd96-0007TM-OU
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:45:44 +0100
Received: from localhost ([::1]:43252 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1Rjd96-0005AR-Ke
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:45:44 +0100
Received: from [195.4.92.18] (port=60524 helo=8.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1Rjd6Y-0004iH-45
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:43:06 +0100
Received: from p5499e75f.dip.t-dialin.net ([84.153.231.95]:41702 helo=madeira.sommer.dynalias.net)
	by 8.mx.freenet.de with esmtpsa (ID saschasommer@freenet.de) (TLSv1:CAMELLIA256-SHA:256) (port 465) (Exim 4.76 #1)
	id 1Rjd6X-0005mo-RQ
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:43:06 +0100
Message-ID: <4F09FF72.1050001@freenet.de>
Date: Sun, 08 Jan 2012 21:41:22 +0100
From: Sascha Sommer <saschasommer@freenet.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: Fix tuner_type for Terratec Cinergy 200 USB
Content-Type: multipart/mixed;
 boundary="------------050704060906090209080505"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050704060906090209080505
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

the card definition of the Terratec Cinergy 200 USB uses the wrong
tuner type. Therefore some channels are currently missing.
Attached patch fixes this problem.

Regards

Sascha

--------------050704060906090209080505
Content-Type: text/x-patch;
 name="em28xx_fix_Terratec_Cinergy_200_USB_tuner.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="em28xx_fix_Terratec_Cinergy_200_USB_tuner.patch"

Fix tuner type for the Terratec Cinergy 200 USB

Signed-off-by: Sascha Sommer <saschasommer@freenet.de>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 897a432..59694e6 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1179,7 +1179,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Terratec Cinergy 200 USB",
 		.is_em2800    = 1,
 		.has_ir_i2c   = 1,
-		.tuner_type   = TUNER_LG_PAL_NEW_TAPC,
+		.tuner_type   = TUNER_LG_TALN,
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_SAA711X,
 		.input        = { {

--------------050704060906090209080505--
