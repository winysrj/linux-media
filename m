Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54622 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932775AbcKMJ37 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 04:29:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] mn88473: add DVBv5 statistics support
Date: Sun, 13 Nov 2016 11:29:35 +0200
Message-Id: <1479029376-31850-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Implement DVBv5 statistics support for DVB-T, DVB-T2 and DVB-C. All
information was taken from the LinuxTV wiki, where Benjamin Larsson has
documented all registers:
https://www.linuxtv.org/wiki/index.php/Panasonic_MN88472

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c      | 485 ++++++++++++++++++++++++++---
 drivers/media/dvb-frontends/mn88473_priv.h |   1 +
 2 files changed, 445 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 451974a..c8dc9d3 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -234,13 +234,388 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	return ret;
 }
 
+static int mn88473_update_ber_stat_t_c(struct dvb_frontend *fe,
+				       enum fe_status *status)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u64 total;
+	unsigned int uitmp, value, errors;
+
+	if (*status & FE_HAS_LOCK) {
+		ret = regmap_read(dev->regmap[0], 0x5b, &value);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[0], 0xdf, &uitmp);
+		if (ret)
+			goto err;
+
+		value &= uitmp;
+		ret = regmap_write(dev->regmap[0], 0x5b, value);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[0], 0x60, &value);
+		if (ret)
+			goto err;
+
+		value &= 0xf0;
+		value |= 0x5;
+		ret = regmap_write(dev->regmap[0], 0x60, value);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[0], 0x92, &uitmp);
+		if (ret)
+			goto err;
+
+		errors = uitmp << 16;
+
+		ret = regmap_read(dev->regmap[0], 0x93, &uitmp);
+		if (ret)
+			goto err;
+
+		errors |= uitmp << 8;
+
+		ret = regmap_read(dev->regmap[0], 0x94, &uitmp);
+		if (ret)
+			goto err;
+
+		errors |= uitmp;
+
+		ret = regmap_read(dev->regmap[0], 0x95, &uitmp);
+		if (ret)
+			goto err;
+
+		total = uitmp << 8;
+
+		ret = regmap_read(dev->regmap[0], 0x96, &uitmp);
+		if (ret)
+			goto err;
+
+		total |= uitmp;
+
+		/* probably: (bytes -> bit) * (sizeof(TS packet) - 1) */
+		total *= 8 * 203;
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += errors;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += total;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	return 0;
+
+err:
+	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int mn88473_update_ber_stat_t2(struct dvb_frontend *fe,
+				      enum fe_status *status)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u64 total;
+	unsigned int uitmp, value, berlen, fec_type_m, errors;
+	static u16 fec_type_m_tbl0[] = {
+		32400, 38880, 43200, 48600, 51840, 54000, 0
+	};
+	static u16 fec_type_m_tbl1[] = {
+		28800, 38880, 43200, 47520, 50400, 53280, 0
+	};
+
+	if (*status & FE_HAS_LOCK) {
+		ret = regmap_read(dev->regmap[2], 0x82, &value);
+		if (ret)
+			goto err;
+
+		value |= 0x20;
+		value &= 0xef;
+		ret = regmap_write(dev->regmap[2], 0x82, value);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[2], 0xba, &uitmp);
+		if (ret)
+			goto err;
+
+		errors = uitmp << 16;
+
+		ret = regmap_read(dev->regmap[2], 0xbb, &uitmp);
+		if (ret)
+			goto err;
+
+		errors |= uitmp << 8;
+
+		ret = regmap_read(dev->regmap[2], 0xbc, &uitmp);
+		if (ret)
+			goto err;
+
+		errors |= uitmp;
+
+		ret = regmap_read(dev->regmap[2], 0x83, &berlen);
+		if (ret)
+			goto err;
+
+		ret = regmap_write(dev->regmap[2], 0xc0, 0x3);
+		if (ret)
+			goto err;
+
+		/* berlen[4:2] are the index in fec_type_m_tbl */
+		uitmp = (berlen >> 2) & 0x7;
+
+		if (BIT(0) & berlen)
+			fec_type_m = fec_type_m_tbl0[uitmp];
+		else
+			fec_type_m = fec_type_m_tbl1[uitmp];
+
+		total = ((berlen & 0xff) << 1) * fec_type_m;
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += errors;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += total;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	return 0;
+
+err:
+	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static inline u32 log10times1000(u32 value)
+{
+	return (1000L * intlog10(value)) >> 24;
+}
+
+static int mn88473_read_status_t(struct dvb_frontend *fe,
+				 enum fe_status *status)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	s32 cnr;
+	unsigned int uitmp, tmp_upper, tmp_lower;
+
+	ret = regmap_read(dev->regmap[0], 0x62, &uitmp);
+	if (ret)
+		goto err;
+
+	if (!(uitmp & 0xa0)) {
+		if ((uitmp & 0x0f) >= 0x09)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI | FE_HAS_SYNC |
+					FE_HAS_LOCK;
+		else if ((uitmp & 0x0f) >= 0x03)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+	}
+
+	/* CNR */
+	if (*status & FE_HAS_VITERBI) {
+		ret = regmap_read(dev->regmap[0], 0x8f, &tmp_upper);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[0], 0x90, &tmp_lower);
+		if (ret)
+			goto err;
+
+		uitmp = (tmp_upper << 8) | tmp_lower;
+		if (uitmp) {
+			cnr = log10times1000(65536);
+			cnr -= log10times1000(uitmp);
+			cnr += 200;
+		} else
+			cnr = 0;
+
+		if (cnr < 0)
+			cnr = 0;
+
+		c->cnr.stat[0].svalue = cnr * 10;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* BER */
+	ret = mn88473_update_ber_stat_t_c(fe, status);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int mn88473_read_status_t2(struct dvb_frontend *fe,
+				  enum fe_status *status)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	s32 cnr;
+	unsigned int uitmp, tmp_upper, tmp_lower, flag;
+
+	ret = regmap_read(dev->regmap[2], 0x8b, &uitmp);
+	if (ret)
+		goto err;
+
+	if (!(uitmp & 0x40)) {
+		if ((uitmp & 0x0f) >= 0x0d)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI | FE_HAS_SYNC |
+					FE_HAS_LOCK;
+		else if ((uitmp & 0x0f) >= 0x0a)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI;
+		else if ((uitmp & 0x0f) >= 0x07)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+	}
+
+	/* CNR */
+	if (*status & FE_HAS_VITERBI) {
+		ret = regmap_read(dev->regmap[2], 0xb7, &flag);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[2], 0xb8, &tmp_upper);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[2], 0xb9, &tmp_lower);
+		if (ret)
+			goto err;
+
+		uitmp = (tmp_upper << 8) | tmp_lower;
+		if (uitmp) {
+			if (flag & BIT(2)) {
+				/* MISO */
+				cnr = log10times1000(16384);
+				cnr -= log10times1000(uitmp);
+				cnr -= 600;
+			} else {
+				/* SISO */
+				cnr = log10times1000(65536);
+				cnr -= log10times1000(uitmp);
+				cnr += 200;
+			}
+		} else
+			cnr = 0;
+
+		if (cnr < 0)
+			cnr = 0;
+
+		c->cnr.stat[0].svalue = cnr * 10;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* BER */
+	ret = mn88473_update_ber_stat_t2(fe, status);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int mn88473_read_status_c(struct dvb_frontend *fe,
+				 enum fe_status *status)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	unsigned int uitmp, tmp_upper, tmp_lower, signal, noise;
+
+	ret = regmap_read(dev->regmap[1], 0x85, &uitmp);
+	if (ret)
+		goto err;
+
+	if (!(uitmp & 0x40)) {
+		ret = regmap_read(dev->regmap[1], 0x89, &uitmp);
+		if (ret)
+			goto err;
+
+		if (uitmp & 0x01)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI | FE_HAS_SYNC |
+					FE_HAS_LOCK;
+	}
+
+	/* CNR */
+	if (*status & FE_HAS_VITERBI) {
+		ret = regmap_read(dev->regmap[1], 0xa1, &tmp_upper);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[1], 0xa2, &tmp_lower);
+		if (ret)
+			goto err;
+
+		signal = (tmp_upper << 8) | tmp_lower;
+
+		ret = regmap_read(dev->regmap[1], 0xa3, &tmp_upper);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[1], 0xa4, &tmp_lower);
+		if (ret)
+			goto err;
+
+		noise = (tmp_upper << 8) | tmp_lower;
+		if (noise)
+			uitmp = log10times1000(signal * 8 / noise);
+		else
+			uitmp = 0;
+
+		c->cnr.stat[0].svalue = uitmp * 10;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* BER */
+	ret = mn88473_update_ber_stat_t_c(fe, status);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static int mn88473_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	unsigned int uitmp;
+	u16 errors, per_len;
+	unsigned int upper, lower;
 
 	if (!dev->active) {
 		ret = -EAGAIN;
@@ -251,60 +626,73 @@ static int mn88473_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
-		ret = regmap_read(dev->regmap[0], 0x62, &uitmp);
+		ret = mn88473_read_status_t(fe, status);
+		break;
+	case SYS_DVBT2:
+		ret = mn88473_read_status_t2(fe, status);
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = mn88473_read_status_c(fe, status);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret)
+		goto err;
+
+	/* signal strength, derived from AGC */
+	if (*status & FE_HAS_SIGNAL) {
+		ret = regmap_read(dev->regmap[2], 0x86, &upper);
 		if (ret)
 			goto err;
 
-		if (!(uitmp & 0xa0)) {
-			if ((uitmp & 0x0f) >= 0x09)
-				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					  FE_HAS_VITERBI | FE_HAS_SYNC |
-					  FE_HAS_LOCK;
-			else if ((uitmp & 0x0f) >= 0x03)
-				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		}
-		break;
-	case SYS_DVBT2:
-		ret = regmap_read(dev->regmap[2], 0x8b, &uitmp);
+		ret = regmap_read(dev->regmap[2], 0x87, &lower);
 		if (ret)
 			goto err;
 
-		if (!(uitmp & 0x40)) {
-			if ((uitmp & 0x0f) >= 0x0d)
-				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					  FE_HAS_VITERBI | FE_HAS_SYNC |
-					  FE_HAS_LOCK;
-			else if ((uitmp & 0x0f) >= 0x0a)
-				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					  FE_HAS_VITERBI;
-			else if ((uitmp & 0x0f) >= 0x07)
-				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		}
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = regmap_read(dev->regmap[1], 0x85, &uitmp);
+		/* AGCRD[15:6] gives us a 10bit value ([5:0] are always 0) */
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = (upper << 8) | lower;
+	} else {
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* PER */
+	if (*status & FE_HAS_LOCK) {
+		ret = regmap_read(dev->regmap[0], 0xdd, &upper);
 		if (ret)
 			goto err;
 
-		if (!(uitmp & 0x40)) {
-			ret = regmap_read(dev->regmap[1], 0x89, &uitmp);
-			if (ret)
-				goto err;
+		ret = regmap_read(dev->regmap[0], 0xde, &lower);
+		if (ret)
+			goto err;
 
-			if (uitmp & 0x01)
-				*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
-					  FE_HAS_VITERBI | FE_HAS_SYNC |
-					  FE_HAS_LOCK;
-		}
-		break;
-	default:
-		ret = -EINVAL;
-		goto err;
+		errors = (upper << 8) | lower;
+
+		ret = regmap_read(dev->regmap[0], 0xdf, &upper);
+		if (ret)
+			goto err;
+
+		ret = regmap_read(dev->regmap[0], 0xe0, &lower);
+		if (ret)
+			goto err;
+
+		per_len = (upper << 8) | lower;
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue += errors;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue += per_len;
+	} else {
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 	}
 
 	return 0;
 err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "%s failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -312,6 +700,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len, remain;
 	unsigned int uitmp;
 	const struct firmware *fw;
@@ -378,6 +767,20 @@ static int mn88473_init(struct dvb_frontend *fe)
 
 	dev->active = true;
 
+	/* init stats here to indicate which stats are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.len = 1;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_count.len = 1;
+	c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return 0;
 err_release_firmware:
 	release_firmware(fw);
diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
index e6c6589..7cbef7b 100644
--- a/drivers/media/dvb-frontends/mn88473_priv.h
+++ b/drivers/media/dvb-frontends/mn88473_priv.h
@@ -18,6 +18,7 @@
 #define MN88473_PRIV_H
 
 #include "dvb_frontend.h"
+#include "dvb_math.h"
 #include "mn88473.h"
 #include <linux/firmware.h>
 #include <linux/regmap.h>
-- 
http://palosaari.fi/

