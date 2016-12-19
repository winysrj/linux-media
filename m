Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47856 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753669AbcLSRgT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:36:19 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9033: estimate cnr from formula
Date: Mon, 19 Dec 2016 19:36:08 +0200
Message-Id: <1482168968-29898-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use formulas for cnr estimates and get rid of old lut-based estimate.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      | 68 +++++++++++++---------
 drivers/media/dvb-frontends/af9033_priv.h | 97 +------------------------------
 2 files changed, 42 insertions(+), 123 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 7e0d1cf..aaed7cf 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -622,9 +622,9 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, tmp = 0;
+	int ret, tmp = 0;
 	u8 buf[7];
-	unsigned int utmp;
+	unsigned int utmp, utmp1;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -686,15 +686,12 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	/* CNR */
 	if (dev->fe_status & FE_HAS_VITERBI) {
-		u32 snr_val, snr_lut_size;
-		const struct val_snr *snr_lut = NULL;
-
 		/* Read raw SNR value */
 		ret = regmap_bulk_read(dev->regmap, 0x80002c, buf, 3);
 		if (ret)
 			goto err;
 
-		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
+		utmp1 = buf[2] << 16 | buf[1] << 8 | buf[0] << 0;
 
 		/* Read superframe number */
 		ret = regmap_read(dev->regmap, 0x80f78b, &utmp);
@@ -702,7 +699,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			goto err;
 
 		if (utmp)
-			snr_val /= utmp;
+			utmp1 /= utmp;
 
 		/* Read current transmission mode */
 		ret = regmap_read(dev->regmap, 0x80f900, &utmp);
@@ -711,16 +708,19 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 		switch ((utmp >> 0) & 3) {
 		case 0:
-			snr_val *= 4;
+			/* 2k */
+			utmp1 *= 4;
 			break;
 		case 1:
-			snr_val *= 1;
+			/* 8k */
+			utmp1 *= 1;
 			break;
 		case 2:
-			snr_val *= 2;
+			/* 4k */
+			utmp1 *= 2;
 			break;
 		default:
-			snr_val *= 0;
+			utmp1 *= 0;
 			break;
 		}
 
@@ -731,34 +731,48 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 		switch ((utmp >> 0) & 3) {
 		case 0:
-			snr_lut_size = ARRAY_SIZE(qpsk_snr_lut);
-			snr_lut = qpsk_snr_lut;
+			/*
+			 * QPSK
+			 * CNR[dB] 13 * -log10((1690000 - value) / value) + 2.6
+			 * value [653799, 1689999], 2.6 / 13 = 3355443
+			 */
+			utmp1 = clamp(utmp1, 653799U, 1689999U);
+			utmp1 = ((u64)(intlog10(utmp1)
+				 - intlog10(1690000 - utmp1)
+				 + 3355443) * 13 * 1000) >> 24;
 			break;
 		case 1:
-			snr_lut_size = ARRAY_SIZE(qam16_snr_lut);
-			snr_lut = qam16_snr_lut;
+			/*
+			 * QAM-16
+			 * CNR[dB] 6 * log10((value - 370000) / (828000 - value)) + 15.7
+			 * value [371105, 827999], 15.7 / 6 = 43900382
+			 */
+			utmp1 = clamp(utmp1, 371105U, 827999U);
+			utmp1 = ((u64)(intlog10(utmp1 - 370000)
+				 - intlog10(828000 - utmp1)
+				 + 43900382) * 6 * 1000) >> 24;
 			break;
 		case 2:
-			snr_lut_size = ARRAY_SIZE(qam64_snr_lut);
-			snr_lut = qam64_snr_lut;
+			/*
+			 * QAM-64
+			 * CNR[dB] 8 * log10((value - 193000) / (425000 - value)) + 23.8
+			 * value [193246, 424999], 23.8 / 8 = 49912218
+			 */
+			utmp1 = clamp(utmp1, 193246U, 424999U);
+			utmp1 = ((u64)(intlog10(utmp1 - 193000)
+				 - intlog10(425000 - utmp1)
+				 + 49912218) * 8 * 1000) >> 24;
 			break;
 		default:
-			snr_lut_size = 0;
-			tmp = 0;
+			utmp1 = 0;
 			break;
 		}
 
-		for (i = 0; i < snr_lut_size; i++) {
-			tmp = snr_lut[i].snr * 1000;
-			if (snr_val < snr_lut[i].val)
-				break;
-		}
+		dev_dbg(&client->dev, "cnr=%u\n", utmp1);
 
-		c->cnr.len = 1;
 		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		c->cnr.stat[0].svalue = tmp;
+		c->cnr.stat[0].svalue = utmp1;
 	} else {
-		c->cnr.len = 1;
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index ad2e7c9..8799cda 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -23,6 +23,7 @@
 #include <linux/math64.h>
 #include <linux/regmap.h>
 #include <linux/kernel.h>
+#include "dvb_math.h"
 
 struct reg_val {
 	u32 reg;
@@ -89,102 +90,6 @@ static const struct coeff coeff_lut[] = {
 	},
 };
 
-/* QPSK SNR lookup table */
-static const struct val_snr qpsk_snr_lut[] = {
-	{ 0x0b4771,  0 },
-	{ 0x0c1aed,  1 },
-	{ 0x0d0d27,  2 },
-	{ 0x0e4d19,  3 },
-	{ 0x0e5da8,  4 },
-	{ 0x107097,  5 },
-	{ 0x116975,  6 },
-	{ 0x1252d9,  7 },
-	{ 0x131fa4,  8 },
-	{ 0x13d5e1,  9 },
-	{ 0x148e53, 10 },
-	{ 0x15358b, 11 },
-	{ 0x15dd29, 12 },
-	{ 0x168112, 13 },
-	{ 0x170b61, 14 },
-	{ 0x17a532, 15 },
-	{ 0x180f94, 16 },
-	{ 0x186ed2, 17 },
-	{ 0x18b271, 18 },
-	{ 0x18e118, 19 },
-	{ 0x18ff4b, 20 },
-	{ 0x190af1, 21 },
-	{ 0x191451, 22 },
-	{ 0xffffff, 23 },
-};
-
-/* QAM16 SNR lookup table */
-static const struct val_snr qam16_snr_lut[] = {
-	{ 0x04f0d5,  0 },
-	{ 0x05387a,  1 },
-	{ 0x0573a4,  2 },
-	{ 0x05a99e,  3 },
-	{ 0x05cc80,  4 },
-	{ 0x05eb62,  5 },
-	{ 0x05fecf,  6 },
-	{ 0x060b80,  7 },
-	{ 0x062501,  8 },
-	{ 0x064865,  9 },
-	{ 0x069604, 10 },
-	{ 0x06f356, 11 },
-	{ 0x07706a, 12 },
-	{ 0x0804d3, 13 },
-	{ 0x089d1a, 14 },
-	{ 0x093e3d, 15 },
-	{ 0x09e35d, 16 },
-	{ 0x0a7c3c, 17 },
-	{ 0x0afaf8, 18 },
-	{ 0x0b719d, 19 },
-	{ 0x0bda6a, 20 },
-	{ 0x0c0c75, 21 },
-	{ 0x0c3f7d, 22 },
-	{ 0x0c5e62, 23 },
-	{ 0x0c6c31, 24 },
-	{ 0x0c7925, 25 },
-	{ 0xffffff, 26 },
-};
-
-/* QAM64 SNR lookup table */
-static const struct val_snr qam64_snr_lut[] = {
-	{ 0x0256d0,  0 },
-	{ 0x027a65,  1 },
-	{ 0x029873,  2 },
-	{ 0x02b7fe,  3 },
-	{ 0x02cf1e,  4 },
-	{ 0x02e234,  5 },
-	{ 0x02f409,  6 },
-	{ 0x030046,  7 },
-	{ 0x030844,  8 },
-	{ 0x030a02,  9 },
-	{ 0x030cde, 10 },
-	{ 0x031031, 11 },
-	{ 0x03144c, 12 },
-	{ 0x0315dd, 13 },
-	{ 0x031920, 14 },
-	{ 0x0322d0, 15 },
-	{ 0x0339fc, 16 },
-	{ 0x0364a1, 17 },
-	{ 0x038bcc, 18 },
-	{ 0x03c7d3, 19 },
-	{ 0x0408cc, 20 },
-	{ 0x043bed, 21 },
-	{ 0x048061, 22 },
-	{ 0x04be95, 23 },
-	{ 0x04fa7d, 24 },
-	{ 0x052405, 25 },
-	{ 0x05570d, 26 },
-	{ 0x059feb, 27 },
-	{ 0x05bf38, 28 },
-	{ 0x05f78f, 29 },
-	{ 0x0612c3, 30 },
-	{ 0x0626be, 31 },
-	{ 0xffffff, 32 },
-};
-
 /*
  * Afatech AF9033 demod init
  */
-- 
http://palosaari.fi/

