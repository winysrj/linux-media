Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:48044 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750983Ab1AWQQM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 11:16:12 -0500
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Date: Sun, 23 Jan 2011 17:16:07 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20110123161607.25900@gmx.net>
MIME-Version: 1.0
Subject: [PATCH] tuner-xc2028: More firmware loading retries
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

My Hauppauge WinTV HVR-1400 needs sometimes more then only one retry to load the firmware successfully.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urNp linux-2.6.37.orig/drivers/media/common/tuners/tuner-xc2028.c linux-2.6.37/drivers/media/common/tuners/tuner-xc2028.c
--- linux-2.6.37.orig/drivers/media/common/tuners/tuner-xc2028.c	2011-01-22 23:46:57.936386804 +0100
+++ linux-2.6.37/drivers/media/common/tuners/tuner-xc2028.c	2011-01-23 13:59:05.402759222 +0100
@@ -685,7 +685,7 @@ static int check_firmware(struct dvb_fro
 {
 	struct xc2028_data         *priv = fe->tuner_priv;
 	struct firmware_properties new_fw;
-	int			   rc = 0, is_retry = 0;
+	int			   rc = 0, retry_count = 0;
 	u16			   version, hwmodel;
 	v4l2_std_id		   std0;
 
@@ -855,9 +855,9 @@ read_not_reliable:
 
 fail:
 	memset(&priv->cur_fw, 0, sizeof(priv->cur_fw));
-	if (!is_retry) {
+	if (retry_count < 8) {
 		msleep(50);
-		is_retry = 1;
+		retry_count++;
 		tuner_dbg("Retrying firmware load\n");
 		goto retry;
 	}

