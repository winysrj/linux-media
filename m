Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40479 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 21/37] it913x: replace udelay polling with jiffies
Date: Thu,  4 Sep 2014 05:36:29 +0300
Message-Id: <1409798205-25645-21-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

udelay based I/O polling loop is a bad idea, especially system
performance point of view. Kernel jiffies are preferred solution
for such situations. Use it instead.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 098e9d5..a076c87 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -39,10 +39,11 @@ struct it913x_dev {
 static int it913x_init(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
-	int ret, i;
+	int ret;
 	unsigned int utmp;
 	u8 iqik_m_cal, nv_val, buf[2];
 	static const u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
+	unsigned long timeout;
 
 	dev_dbg(&dev->client->dev, "role %u\n", dev->role);
 
@@ -85,7 +86,9 @@ static int it913x_init(struct dvb_frontend *fe)
 	else
 		nv_val = 2;
 
-	for (i = 0; i < 50; i++) {
+	#define TIMEOUT 50
+	timeout = jiffies + msecs_to_jiffies(TIMEOUT);
+	while (!time_after(jiffies, timeout)) {
 		ret = regmap_bulk_read(dev->regmap, 0x80ed23, buf, 2);
 		if (ret)
 			goto err;
@@ -93,30 +96,38 @@ static int it913x_init(struct dvb_frontend *fe)
 		utmp = (buf[1] << 8) | (buf[0] << 0);
 		if (utmp)
 			break;
-
-		udelay(2000);
 	}
 
-	dev_dbg(&dev->client->dev, "loop count %d, utmp %d\n", i, utmp);
+	dev_dbg(&dev->client->dev, "r_fbc_m_bdry took %u ms, val %u\n",
+			jiffies_to_msecs(jiffies) -
+			(jiffies_to_msecs(timeout) - TIMEOUT), utmp);
 
 	dev->fn_min = dev->xtal * utmp;
 	dev->fn_min /= (dev->fdiv * nv_val);
 	dev->fn_min *= 1000;
 	dev_dbg(&dev->client->dev, "fn_min %u\n", dev->fn_min);
 
+	/*
+	 * Chip version BX never sets that flag so we just wait 50ms in that
+	 * case. It is possible poll BX similarly than AX and then timeout in
+	 * order to get 50ms delay, but that causes about 120 extra I2C
+	 * messages. As for now, we just wait and reduce IO.
+	 */
 	if (dev->chip_ver == 1) {
-		for (i = 0; i < 50; i++) {
+		#define TIMEOUT 50
+		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
+		while (!time_after(jiffies, timeout)) {
 			ret = regmap_read(dev->regmap, 0x80ec82, &utmp);
 			if (ret)
 				goto err;
 
 			if (utmp)
 				break;
-
-			udelay(2000);
 		}
 
-		dev_dbg(&dev->client->dev, "loop count %d\n", i);
+		dev_dbg(&dev->client->dev, "p_tsm_init_mode took %u ms, val %u\n",
+				jiffies_to_msecs(jiffies) -
+				(jiffies_to_msecs(timeout) - TIMEOUT), utmp);
 	} else {
 		msleep(50);
 	}
-- 
http://palosaari.fi/

