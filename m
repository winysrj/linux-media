Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35660 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbbERFJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/8] m88ds3103: implement DVBv5 CNR statistics
Date: Mon, 18 May 2015 08:08:45 +0300
Message-Id: <1431925731-7499-2-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 CNR statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 80 ++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 03dceb5..980a89e 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -190,8 +190,9 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
+	int ret, i, itmp;
 	u8 u8tmp;
+	u8 buf[3];
 
 	*status = 0;
 
@@ -233,6 +234,77 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	dev_dbg(&priv->i2c->dev, "%s: lock=%02x status=%02x\n",
 			__func__, u8tmp, *status);
 
+	/* CNR */
+	if (priv->fe_status & FE_HAS_VITERBI) {
+		unsigned int cnr, noise, signal, noise_tot, signal_tot;
+
+		cnr = 0;
+		/* more iterations for more accurate estimation */
+		#define M88DS3103_SNR_ITERATIONS 3
+
+		switch (c->delivery_system) {
+		case SYS_DVBS:
+			itmp = 0;
+
+			for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
+				ret = m88ds3103_rd_reg(priv, 0xff, &buf[0]);
+				if (ret)
+					goto err;
+
+				itmp += buf[0];
+			}
+
+			/* use of single register limits max value to 15 dB */
+			/* SNR(X) dB = 10 * ln(X) / ln(10) dB */
+			itmp = DIV_ROUND_CLOSEST(itmp, 8 * M88DS3103_SNR_ITERATIONS);
+			if (itmp)
+				cnr = div_u64((u64) 10000 * intlog2(itmp), intlog2(10));
+			break;
+		case SYS_DVBS2:
+			noise_tot = 0;
+			signal_tot = 0;
+
+			for (i = 0; i < M88DS3103_SNR_ITERATIONS; i++) {
+				ret = m88ds3103_rd_regs(priv, 0x8c, buf, 3);
+				if (ret)
+					goto err;
+
+				noise = buf[1] << 6;    /* [13:6] */
+				noise |= buf[0] & 0x3f; /*  [5:0] */
+				noise >>= 2;
+				signal = buf[2] * buf[2];
+				signal >>= 1;
+
+				noise_tot += noise;
+				signal_tot += signal;
+			}
+
+			noise = noise_tot / M88DS3103_SNR_ITERATIONS;
+			signal = signal_tot / M88DS3103_SNR_ITERATIONS;
+
+			/* SNR(X) dB = 10 * log10(X) dB */
+			if (signal > noise) {
+				itmp = signal / noise;
+				cnr = div_u64((u64) 10000 * intlog10(itmp), (1 << 24));
+			}
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev,
+				"%s: invalid delivery_system\n", __func__);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		if (cnr) {
+			c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+			c->cnr.stat[0].svalue = cnr;
+		} else {
+			c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		}
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
@@ -577,6 +649,7 @@ err:
 static int m88ds3103_init(struct dvb_frontend *fe)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
@@ -684,7 +757,9 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 skip_fw_download:
 	/* warm state */
 	priv->warm = true;
-
+	/* init stats here in order signal app which stats are supported */
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	return 0;
 
 error_fw_release:
@@ -702,6 +777,7 @@ static int m88ds3103_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
+	priv->fe_status = 0;
 	priv->delivery_system = SYS_UNDEFINED;
 
 	/* TS Hi-Z */
-- 
http://palosaari.fi/

