Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41220 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932845AbcKMJ37 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 04:29:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] mn88473: refactor and fix statistics
Date: Sun, 13 Nov 2016 11:29:36 +0200
Message-Id: <1479029376-31850-2-git-send-email-crope@iki.fi>
In-Reply-To: <1479029376-31850-1-git-send-email-crope@iki.fi>
References: <1479029376-31850-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove DVB-T2 BER as it does not work at all and I didn't find
how to fix.

Fix DVB-T and DVB-C BER. It seems to return new some realistic
looking values.

Use (1 << 64) base for CNR calculations to keep it in line with
dvb logarithm functions.

Move all statistic logic to mn88473_read_status() function.

Use regmap_bulk_read() for reading multiple registers as a one go.

And many more and less minor changes.

Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c      | 560 +++++++++--------------------
 drivers/media/dvb-frontends/mn88473_priv.h |   1 +
 2 files changed, 161 insertions(+), 400 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index c8dc9d3..f3b59a5 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -234,465 +234,225 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int mn88473_update_ber_stat_t_c(struct dvb_frontend *fe,
-				       enum fe_status *status)
+static int mn88473_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	u64 total;
-	unsigned int uitmp, value, errors;
-
-	if (*status & FE_HAS_LOCK) {
-		ret = regmap_read(dev->regmap[0], 0x5b, &value);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[0], 0xdf, &uitmp);
-		if (ret)
-			goto err;
-
-		value &= uitmp;
-		ret = regmap_write(dev->regmap[0], 0x5b, value);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[0], 0x60, &value);
-		if (ret)
-			goto err;
-
-		value &= 0xf0;
-		value |= 0x5;
-		ret = regmap_write(dev->regmap[0], 0x60, value);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[0], 0x92, &uitmp);
-		if (ret)
-			goto err;
-
-		errors = uitmp << 16;
-
-		ret = regmap_read(dev->regmap[0], 0x93, &uitmp);
-		if (ret)
-			goto err;
-
-		errors |= uitmp << 8;
-
-		ret = regmap_read(dev->regmap[0], 0x94, &uitmp);
-		if (ret)
-			goto err;
-
-		errors |= uitmp;
-
-		ret = regmap_read(dev->regmap[0], 0x95, &uitmp);
-		if (ret)
-			goto err;
-
-		total = uitmp << 8;
+	int ret, i, stmp;
+	unsigned int utmp, utmp1, utmp2;
+	u8 buf[5];
 
-		ret = regmap_read(dev->regmap[0], 0x96, &uitmp);
-		if (ret)
-			goto err;
-
-		total |= uitmp;
-
-		/* probably: (bytes -> bit) * (sizeof(TS packet) - 1) */
-		total *= 8 * 203;
-
-		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[0].uvalue += errors;
-		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[0].uvalue += total;
-	} else {
-		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	if (!dev->active) {
+		ret = -EAGAIN;
+		goto err;
 	}
 
-	return 0;
-
-err:
-	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int mn88473_update_ber_stat_t2(struct dvb_frontend *fe,
-				      enum fe_status *status)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88473_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	u64 total;
-	unsigned int uitmp, value, berlen, fec_type_m, errors;
-	static u16 fec_type_m_tbl0[] = {
-		32400, 38880, 43200, 48600, 51840, 54000, 0
-	};
-	static u16 fec_type_m_tbl1[] = {
-		28800, 38880, 43200, 47520, 50400, 53280, 0
-	};
-
-	if (*status & FE_HAS_LOCK) {
-		ret = regmap_read(dev->regmap[2], 0x82, &value);
-		if (ret)
-			goto err;
-
-		value |= 0x20;
-		value &= 0xef;
-		ret = regmap_write(dev->regmap[2], 0x82, value);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[2], 0xba, &uitmp);
-		if (ret)
-			goto err;
-
-		errors = uitmp << 16;
-
-		ret = regmap_read(dev->regmap[2], 0xbb, &uitmp);
-		if (ret)
-			goto err;
-
-		errors |= uitmp << 8;
-
-		ret = regmap_read(dev->regmap[2], 0xbc, &uitmp);
-		if (ret)
-			goto err;
-
-		errors |= uitmp;
-
-		ret = regmap_read(dev->regmap[2], 0x83, &berlen);
+	/* Lock detection */
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		ret = regmap_read(dev->regmap[0], 0x62, &utmp);
 		if (ret)
 			goto err;
 
-		ret = regmap_write(dev->regmap[2], 0xc0, 0x3);
+		if (!(utmp & 0xa0)) {
+			if ((utmp & 0x0f) >= 0x09)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI | FE_HAS_SYNC |
+					  FE_HAS_LOCK;
+			else if ((utmp & 0x0f) >= 0x03)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		} else {
+			*status = 0;
+		}
+		break;
+	case SYS_DVBT2:
+		ret = regmap_read(dev->regmap[2], 0x8b, &utmp);
+		if (ret)
+			goto err;
+
+		if (!(utmp & 0x40)) {
+			if ((utmp & 0x0f) >= 0x0d)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI | FE_HAS_SYNC |
+					  FE_HAS_LOCK;
+			else if ((utmp & 0x0f) >= 0x0a)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					  FE_HAS_VITERBI;
+			else if ((utmp & 0x0f) >= 0x07)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		} else {
+			*status = 0;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_read(dev->regmap[1], 0x85, &utmp);
 		if (ret)
 			goto err;
 
-		/* berlen[4:2] are the index in fec_type_m_tbl */
-		uitmp = (berlen >> 2) & 0x7;
-
-		if (BIT(0) & berlen)
-			fec_type_m = fec_type_m_tbl0[uitmp];
-		else
-			fec_type_m = fec_type_m_tbl1[uitmp];
-
-		total = ((berlen & 0xff) << 1) * fec_type_m;
-
-		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[0].uvalue += errors;
-		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[0].uvalue += total;
-	} else {
-		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	return 0;
-
-err:
-	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static inline u32 log10times1000(u32 value)
-{
-	return (1000L * intlog10(value)) >> 24;
-}
-
-static int mn88473_read_status_t(struct dvb_frontend *fe,
-				 enum fe_status *status)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88473_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	s32 cnr;
-	unsigned int uitmp, tmp_upper, tmp_lower;
+		if (!(utmp & 0x40)) {
+			ret = regmap_read(dev->regmap[1], 0x89, &utmp);
+			if (ret)
+				goto err;
 
-	ret = regmap_read(dev->regmap[0], 0x62, &uitmp);
-	if (ret)
+			if (utmp & 0x01)
+				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+						FE_HAS_VITERBI | FE_HAS_SYNC |
+						FE_HAS_LOCK;
+		} else {
+			*status = 0;
+		}
+		break;
+	default:
+		ret = -EINVAL;
 		goto err;
-
-	if (!(uitmp & 0xa0)) {
-		if ((uitmp & 0x0f) >= 0x09)
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					FE_HAS_VITERBI | FE_HAS_SYNC |
-					FE_HAS_LOCK;
-		else if ((uitmp & 0x0f) >= 0x03)
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
 	}
 
-	/* CNR */
-	if (*status & FE_HAS_VITERBI) {
-		ret = regmap_read(dev->regmap[0], 0x8f, &tmp_upper);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[0], 0x90, &tmp_lower);
-		if (ret)
-			goto err;
-
-		uitmp = (tmp_upper << 8) | tmp_lower;
-		if (uitmp) {
-			cnr = log10times1000(65536);
-			cnr -= log10times1000(uitmp);
-			cnr += 200;
-		} else
-			cnr = 0;
+	/* Signal strength */
+	if (*status & FE_HAS_SIGNAL) {
+		for (i = 0; i < 2; i++) {
+			ret = regmap_bulk_read(dev->regmap[2], 0x86 + i,
+					       &buf[i], 1);
+			if (ret)
+				goto err;
+		}
 
-		if (cnr < 0)
-			cnr = 0;
+		/* AGCRD[15:6] gives us a 10bit value ([5:0] are always 0) */
+		utmp1 = buf[0] << 8 | buf[1] << 0 | buf[0] >> 2;
+		dev_dbg(&client->dev, "strength=%u\n", utmp1);
 
-		c->cnr.stat[0].svalue = cnr * 10;
-		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = utmp1;
 	} else {
-		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	/* BER */
-	ret = mn88473_update_ber_stat_t_c(fe, status);
-	if (ret)
-		goto err;
-
-	return 0;
-
-err:
-	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int mn88473_read_status_t2(struct dvb_frontend *fe,
-				  enum fe_status *status)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88473_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	s32 cnr;
-	unsigned int uitmp, tmp_upper, tmp_lower, flag;
-
-	ret = regmap_read(dev->regmap[2], 0x8b, &uitmp);
-	if (ret)
-		goto err;
-
-	if (!(uitmp & 0x40)) {
-		if ((uitmp & 0x0f) >= 0x0d)
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					FE_HAS_VITERBI | FE_HAS_SYNC |
-					FE_HAS_LOCK;
-		else if ((uitmp & 0x0f) >= 0x0a)
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					FE_HAS_VITERBI;
-		else if ((uitmp & 0x0f) >= 0x07)
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
 	/* CNR */
-	if (*status & FE_HAS_VITERBI) {
-		ret = regmap_read(dev->regmap[2], 0xb7, &flag);
+	if (*status & FE_HAS_VITERBI && c->delivery_system == SYS_DVBT) {
+		/* DVB-T CNR */
+		ret = regmap_bulk_read(dev->regmap[0], 0x8f, buf, 2);
 		if (ret)
 			goto err;
 
-		ret = regmap_read(dev->regmap[2], 0xb8, &tmp_upper);
-		if (ret)
-			goto err;
+		utmp = buf[0] << 8 | buf[1] << 0;
+		if (utmp) {
+			/* CNR[dB]: 10 * (log10(65536 / value) + 0.2) */
+			/* log10(65536) = 80807124, 0.2 = 3355443 */
+			stmp = div_u64(((u64)80807124 - intlog10(utmp)
+					+ 3355443) * 10000, 1 << 24);
+			dev_dbg(&client->dev, "cnr=%d value=%u\n", stmp, utmp);
+		} else {
+			stmp = 0;
+		}
 
-		ret = regmap_read(dev->regmap[2], 0xb9, &tmp_lower);
-		if (ret)
-			goto err;
+		c->cnr.stat[0].svalue = stmp;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else if (*status & FE_HAS_VITERBI &&
+		   c->delivery_system == SYS_DVBT2) {
+		/* DVB-T2 CNR */
+		for (i = 0; i < 3; i++) {
+			ret = regmap_bulk_read(dev->regmap[2], 0xb7 + i,
+					       &buf[i], 1);
+			if (ret)
+				goto err;
+		}
 
-		uitmp = (tmp_upper << 8) | tmp_lower;
-		if (uitmp) {
-			if (flag & BIT(2)) {
-				/* MISO */
-				cnr = log10times1000(16384);
-				cnr -= log10times1000(uitmp);
-				cnr -= 600;
+		utmp = buf[1] << 8 | buf[2] << 0;
+		utmp1 = (buf[0] >> 2) & 0x01; /* 0=SISO, 1=MISO */
+		if (utmp) {
+			if (utmp1) {
+				/* CNR[dB]: 10 * (log10(16384 / value) - 0.6) */
+				/* log10(16384) = 70706234, 0.6 = 10066330 */
+				stmp = div_u64(((u64)70706234 - intlog10(utmp)
+						- 10066330) * 10000, 1 << 24);
+				dev_dbg(&client->dev, "cnr=%d value=%u MISO\n",
+					stmp, utmp);
 			} else {
-				/* SISO */
-				cnr = log10times1000(65536);
-				cnr -= log10times1000(uitmp);
-				cnr += 200;
+				/* CNR[dB]: 10 * (log10(65536 / value) + 0.2) */
+				/* log10(65536) = 80807124, 0.2 = 3355443 */
+				stmp = div_u64(((u64)80807124 - intlog10(utmp)
+						+ 3355443) * 10000, 1 << 24);
+				dev_dbg(&client->dev, "cnr=%d value=%u SISO\n",
+					stmp, utmp);
 			}
-		} else
-			cnr = 0;
-
-		if (cnr < 0)
-			cnr = 0;
+		} else {
+			stmp = 0;
+		}
 
-		c->cnr.stat[0].svalue = cnr * 10;
+		c->cnr.stat[0].svalue = stmp;
 		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-	} else {
-		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	/* BER */
-	ret = mn88473_update_ber_stat_t2(fe, status);
-	if (ret)
-		goto err;
-
-	return 0;
-
-err:
-	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int mn88473_read_status_c(struct dvb_frontend *fe,
-				 enum fe_status *status)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88473_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	unsigned int uitmp, tmp_upper, tmp_lower, signal, noise;
-
-	ret = regmap_read(dev->regmap[1], 0x85, &uitmp);
-	if (ret)
-		goto err;
-
-	if (!(uitmp & 0x40)) {
-		ret = regmap_read(dev->regmap[1], 0x89, &uitmp);
-		if (ret)
-			goto err;
-
-		if (uitmp & 0x01)
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					FE_HAS_VITERBI | FE_HAS_SYNC |
-					FE_HAS_LOCK;
-	}
-
-	/* CNR */
-	if (*status & FE_HAS_VITERBI) {
-		ret = regmap_read(dev->regmap[1], 0xa1, &tmp_upper);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[1], 0xa2, &tmp_lower);
-		if (ret)
-			goto err;
-
-		signal = (tmp_upper << 8) | tmp_lower;
-
-		ret = regmap_read(dev->regmap[1], 0xa3, &tmp_upper);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[1], 0xa4, &tmp_lower);
-		if (ret)
-			goto err;
-
-		noise = (tmp_upper << 8) | tmp_lower;
-		if (noise)
-			uitmp = log10times1000(signal * 8 / noise);
-		else
-			uitmp = 0;
+	} else if (*status & FE_HAS_VITERBI &&
+		   c->delivery_system == SYS_DVBC_ANNEX_A) {
+		/* DVB-C CNR */
+		ret = regmap_bulk_read(dev->regmap[1], 0xa1, buf, 4);
+		if (ret)
+			goto err;
+
+		utmp1 = buf[0] << 8 | buf[1] << 0; /* signal */
+		utmp2 = buf[2] << 8 | buf[3] << 0; /* noise */
+		if (utmp1 && utmp2) {
+			/* CNR[dB]: 10 * log10(8 * (signal / noise)) */
+			/* log10(8) = 15151336 */
+			stmp = div_u64(((u64)15151336 + intlog10(utmp1)
+					- intlog10(utmp2)) * 10000, 1 << 24);
+			dev_dbg(&client->dev, "cnr=%d signal=%u noise=%u\n",
+				stmp, utmp1, utmp2);
+		} else {
+			stmp = 0;
+		}
 
-		c->cnr.stat[0].svalue = uitmp * 10;
+		c->cnr.stat[0].svalue = stmp;
 		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 	} else {
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
 	/* BER */
-	ret = mn88473_update_ber_stat_t_c(fe, status);
-	if (ret)
-		goto err;
-
-	return 0;
-
-err:
-	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int mn88473_read_status(struct dvb_frontend *fe, enum fe_status *status)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88473_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	u16 errors, per_len;
-	unsigned int upper, lower;
-
-	if (!dev->active) {
-		ret = -EAGAIN;
-		goto err;
-	}
-
-	*status = 0;
-
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-		ret = mn88473_read_status_t(fe, status);
-		break;
-	case SYS_DVBT2:
-		ret = mn88473_read_status_t2(fe, status);
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = mn88473_read_status_c(fe, status);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (ret)
-		goto err;
-
-	/* signal strength, derived from AGC */
-	if (*status & FE_HAS_SIGNAL) {
-		ret = regmap_read(dev->regmap[2], 0x86, &upper);
+	if (*status & FE_HAS_LOCK && (c->delivery_system == SYS_DVBT ||
+				      c->delivery_system == SYS_DVBC_ANNEX_A)) {
+		/* DVB-T & DVB-C BER */
+		ret = regmap_bulk_read(dev->regmap[0], 0x92, buf, 5);
 		if (ret)
 			goto err;
 
-		ret = regmap_read(dev->regmap[2], 0x87, &lower);
-		if (ret)
-			goto err;
+		utmp1 = buf[0] << 16 | buf[1] << 8 | buf[2] << 0;
+		utmp2 = buf[3] << 8 | buf[4] << 0;
+		utmp2 = utmp2 * 8 * 204;
+		dev_dbg(&client->dev, "post_bit_error=%u post_bit_count=%u\n",
+			utmp1, utmp2);
 
-		/* AGCRD[15:6] gives us a 10bit value ([5:0] are always 0) */
-		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
-		c->strength.stat[0].uvalue = (upper << 8) | lower;
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += utmp1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += utmp2;
 	} else {
-		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
 	/* PER */
 	if (*status & FE_HAS_LOCK) {
-		ret = regmap_read(dev->regmap[0], 0xdd, &upper);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[0], 0xde, &lower);
-		if (ret)
-			goto err;
-
-		errors = (upper << 8) | lower;
-
-		ret = regmap_read(dev->regmap[0], 0xdf, &upper);
-		if (ret)
-			goto err;
-
-		ret = regmap_read(dev->regmap[0], 0xe0, &lower);
+		ret = regmap_bulk_read(dev->regmap[0], 0xdd, buf, 4);
 		if (ret)
 			goto err;
 
-		per_len = (upper << 8) | lower;
+		utmp1 = buf[0] << 8 | buf[1] << 0;
+		utmp2 = buf[2] << 8 | buf[3] << 0;
+		dev_dbg(&client->dev, "block_error=%u block_count=%u\n",
+			utmp1, utmp2);
 
 		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[0].uvalue += errors;
+		c->block_error.stat[0].uvalue += utmp1;
 		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_count.stat[0].uvalue += per_len;
+		c->block_count.stat[0].uvalue += utmp2;
 	} else {
-		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
 	return 0;
 err:
-	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
index 7cbef7b..5fc463d 100644
--- a/drivers/media/dvb-frontends/mn88473_priv.h
+++ b/drivers/media/dvb-frontends/mn88473_priv.h
@@ -20,6 +20,7 @@
 #include "dvb_frontend.h"
 #include "dvb_math.h"
 #include "mn88473.h"
+#include <linux/math64.h>
 #include <linux/firmware.h>
 #include <linux/regmap.h>
 
-- 
http://palosaari.fi/

