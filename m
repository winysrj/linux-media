Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:36336 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2H3JqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 05:46:17 -0400
From: =?UTF-8?q?R=C3=A9mi=20Cardona?= <remi.cardona@smartjog.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] ds3000: Remove useless 'locking'
Date: Thu, 30 Aug 2012 11:36:30 +0200
Message-Id: <1346319391-19015-2-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com>
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since b9bf2eafaad9c1ef02fb3db38c74568be601a43a, the function
ds3000_firmware_ondemand() is called only once during init. This
locking scheme may have been useful when the firmware was loaded at
each tune.

Furthermore, it looks like this 'lock' was put in to prevent concurrent
access (and not recursion as the comments suggest). However, this open-
coded mechanism is anything but race-free and should have used a proper
mutex.

Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
---
 drivers/media/dvb/frontends/ds3000.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 4c8ac26..066870a 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -233,7 +233,6 @@ struct ds3000_state {
 	struct i2c_adapter *i2c;
 	const struct ds3000_config *config;
 	struct dvb_frontend frontend;
-	u8 skip_fw_load;
 	/* previous uncorrected block counter for DVB-S2 */
 	u16 prevUCBS2;
 };
@@ -395,8 +394,6 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 	if (ds3000_readreg(state, 0xb2) <= 0)
 		return ret;
 
-	if (state->skip_fw_load)
-		return 0;
 	/* Load firmware */
 	/* request the firmware, this will block until someone uploads it */
 	printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n", __func__,
@@ -410,9 +407,6 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 		return ret;
 	}
 
-	/* Make sure we don't recurse back through here during loading */
-	state->skip_fw_load = 1;
-
 	ret = ds3000_load_firmware(fe, fw);
 	if (ret)
 		printk("%s: Writing firmware to device failed\n", __func__);
@@ -422,9 +416,6 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 	dprintk("%s: Firmware upload %s\n", __func__,
 			ret == 0 ? "complete" : "failed");
 
-	/* Ensure firmware is always loaded if required */
-	state->skip_fw_load = 0;
-
 	return ret;
 }
 
-- 
1.7.10.4

