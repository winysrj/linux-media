Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34375 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094AbaIDChF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 32/37] af9033: wrap DVBv3 read SNR to DVBv5 CNR
Date: Thu,  4 Sep 2014 05:36:40 +0300
Message-Id: <1409798205-25645-32-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove 'duplicate' DVBv3 read SNR implementation and return value,
calculated already by DVBv5 CNR, from the cache.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      | 52 ++++---------------------------
 drivers/media/dvb-frontends/af9033_priv.h |  1 +
 2 files changed, 7 insertions(+), 46 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 576e9b5..4c20616 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -832,55 +832,15 @@ err:
 static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret, i, len;
-	u8 buf[3], tmp;
-	u32 snr_val;
-	const struct val_snr *snr_lut;
-
-	/* read value */
-	ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
-	if (ret < 0)
-		goto err;
-
-	snr_val = (buf[2] << 16) | (buf[1] << 8) | buf[0];
-
-	/* read current modulation */
-	ret = af9033_rd_reg(dev, 0x80f903, &tmp);
-	if (ret < 0)
-		goto err;
-
-	switch ((tmp >> 0) & 3) {
-	case 0:
-		len = ARRAY_SIZE(qpsk_snr_lut);
-		snr_lut = qpsk_snr_lut;
-		break;
-	case 1:
-		len = ARRAY_SIZE(qam16_snr_lut);
-		snr_lut = qam16_snr_lut;
-		break;
-	case 2:
-		len = ARRAY_SIZE(qam64_snr_lut);
-		snr_lut = qam64_snr_lut;
-		break;
-	default:
-		goto err;
-	}
-
-	for (i = 0; i < len; i++) {
-		tmp = snr_lut[i].snr;
-
-		if (snr_val < snr_lut[i].val)
-			break;
-	}
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 
-	*snr = tmp * 10; /* dB/10 */
+	/* use DVBv5 CNR */
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100); /* 1000x => 10x */
+	else
+		*snr = 0;
 
 	return 0;
-
-err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-
-	return ret;
 }
 
 static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index ded7b67..c12c92c 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -24,6 +24,7 @@
 
 #include "dvb_frontend.h"
 #include "af9033.h"
+#include <linux/math64.h>
 
 struct reg_val {
 	u32 reg;
-- 
http://palosaari.fi/

