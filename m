Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52195 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbbERFJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] m88ds3103: wrap legacy DVBv3 SNR to DVBv5 CNR
Date: Mon, 18 May 2015 08:08:46 +0300
Message-Id: <1431925731-7499-3-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use DVBv5 CNR logic to calculate DVBv3 SNR too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 74 ++-------------------------------
 1 file changed, 4 insertions(+), 70 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 980a89e..381a8ad 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -984,80 +984,14 @@ err:
 
 static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, tmp;
-	u8 buf[3];
-	u16 noise, signal;
-	u32 noise_tot, signal_tot;
-
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-	/* reports SNR in resolution of 0.1 dB */
-
-	/* more iterations for more accurate estimation */
-	#define M88DS3103_SNR_ITERATIONS 3
 
-	switch (c->delivery_system) {
-	case SYS_DVBS:
-		tmp = 0;
-
-		for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
-			ret = m88ds3103_rd_reg(priv, 0xff, &buf[0]);
-			if (ret)
-				goto err;
-
-			tmp += buf[0];
-		}
-
-		/* use of one register limits max value to 15 dB */
-		/* SNR(X) dB = 10 * ln(X) / ln(10) dB */
-		tmp = DIV_ROUND_CLOSEST(tmp, 8 * M88DS3103_SNR_ITERATIONS);
-		if (tmp)
-			*snr = div_u64((u64) 100 * intlog2(tmp), intlog2(10));
-		else
-			*snr = 0;
-		break;
-	case SYS_DVBS2:
-		noise_tot = 0;
-		signal_tot = 0;
-
-		for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
-			ret = m88ds3103_rd_regs(priv, 0x8c, buf, 3);
-			if (ret)
-				goto err;
-
-			noise = buf[1] << 6;    /* [13:6] */
-			noise |= buf[0] & 0x3f; /*  [5:0] */
-			noise >>= 2;
-			signal = buf[2] * buf[2];
-			signal >>= 1;
-
-			noise_tot += noise;
-			signal_tot += signal;
-		}
-
-		noise = noise_tot / M88DS3103_SNR_ITERATIONS;
-		signal = signal_tot / M88DS3103_SNR_ITERATIONS;
-
-		/* SNR(X) dB = 10 * log10(X) dB */
-		if (signal > noise) {
-			tmp = signal / noise;
-			*snr = div_u64((u64) 100 * intlog10(tmp), (1 << 24));
-		} else {
-			*snr = 0;
-		}
-		break;
-	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
-				__func__);
-		ret = -EINVAL;
-		goto err;
-	}
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
+	else
+		*snr = 0;
 
 	return 0;
-err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
 }
 
 static int m88ds3103_read_ber(struct dvb_frontend *fe, u32 *ber)
-- 
http://palosaari.fi/

