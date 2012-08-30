Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:36357 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2H3JqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 05:46:17 -0400
From: =?UTF-8?q?R=C3=A9mi=20Cardona?= <remi.cardona@smartjog.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] ds3000: properly report firmware loading issues
Date: Thu, 30 Aug 2012 11:36:31 +0200
Message-Id: <1346319391-19015-3-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com>
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ds3000_readreg() returns negative values in case of i2c failures. The
old code would simply return 0 when failing to read the 0xb2 register,
misleading ds3000_initfe() into believing that the firmware had been
correctly loaded.

Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
---
 drivers/media/dvb/frontends/ds3000.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 066870a..4c774c4 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -391,8 +391,14 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 
 	dprintk("%s()\n", __func__);
 
-	if (ds3000_readreg(state, 0xb2) <= 0)
+	ret = ds3000_readreg(state, 0xb2);
+	if (ret == 0) {
+		printk(KERN_INFO "%s: Firmware already uploaded, skipping\n",
+			__func__);
 		return ret;
+	} else if (ret < 0) {
+		return ret;
+	}
 
 	/* Load firmware */
 	/* request the firmware, this will block until someone uploads it */
-- 
1.7.10.4

