Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56189 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZBKJeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 04:34:11 -0500
Received: by ewy14 with SMTP id 14so80049ewy.13
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2009 01:34:08 -0800 (PST)
Message-ID: <49929B93.8010702@gmail.com>
Date: Wed, 11 Feb 2009 10:34:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@redhat.com
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] V4L/DVB: calibration still  successful at 10
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With while (i++ < 10) { ... } i can reach 11, so callibration still
succeeds at i == 10.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/common/tuners/mt2060.c b/drivers/media/common/tuners/mt2060.c
index 12206d7..c7abe3d 100644
--- a/drivers/media/common/tuners/mt2060.c
+++ b/drivers/media/common/tuners/mt2060.c
@@ -278,7 +278,7 @@ static void mt2060_calibrate(struct mt2060_priv *priv)
 	while (i++ < 10 && mt2060_readreg(priv, REG_MISC_STAT, &b) == 0 && (b & (1 << 6)) == 0)
 		msleep(20);
 
-	if (i < 10) {
+	if (i <= 10) {
 		mt2060_readreg(priv, REG_FM_FREQ, &priv->fmfreq); // now find out, what is fmreq used for :)
 		dprintk("calibration was successful: %d", (int)priv->fmfreq);
 	} else
