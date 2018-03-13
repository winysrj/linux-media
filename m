Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:39345 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932777AbeCMXkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/18] af9013: dvbv5 cnr
Date: Wed, 14 Mar 2018 01:39:29 +0200
Message-Id: <20180313233944.7234-3-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement dvbv5 cnr.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c      | 88 +++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/af9013_priv.h |  1 +
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 4cb6371572c5..b3d08e437478 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -46,6 +46,7 @@ struct af9013_state {
 	unsigned long set_frontend_jiffies;
 	unsigned long read_status_jiffies;
 	unsigned long strength_jiffies;
+	unsigned long cnr_jiffies;
 	bool first_tune;
 	bool i2c_gate_state;
 	unsigned int statistics_step:3;
@@ -179,7 +180,6 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, len;
 	unsigned int utmp;
 	u8 buf[3];
@@ -235,9 +235,6 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	}
 	state->snr = utmp * 10; /* dB/10 */
 
-	c->cnr.stat[0].svalue = 1000 * utmp;
-	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
@@ -757,7 +754,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, stmp1;
 	unsigned int utmp, utmp1, utmp2, utmp3, utmp4;
-	u8 buf[2];
+	u8 buf[3];
 
 	dev_dbg(&client->dev, "\n");
 
@@ -869,6 +866,87 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		break;
 	}
 
+	/* CNR */
+	switch (state->fe_status & FE_HAS_VITERBI) {
+	case FE_HAS_VITERBI:
+		if (time_is_after_jiffies(state->cnr_jiffies + msecs_to_jiffies(2000)))
+			break;
+
+		/* Check if cnr ready */
+		ret = regmap_read(state->regmap, 0xd2e1, &utmp);
+		if (ret)
+			goto err;
+
+		if (!((utmp >> 3) & 0x01)) {
+			dev_dbg(&client->dev, "cnr not ready\n");
+			break;
+		}
+
+		/* Read value */
+		ret = regmap_bulk_read(state->regmap, 0xd2e3, buf, 3);
+		if (ret)
+			goto err;
+
+		utmp1 = buf[2] << 16 | buf[1] << 8 | buf[0] << 0;
+
+		/* Read current modulation */
+		ret = regmap_read(state->regmap, 0xd3c1, &utmp);
+		if (ret)
+			goto err;
+
+		switch ((utmp >> 6) & 3) {
+		case 0:
+			/*
+			 * QPSK
+			 * CNR[dB] 13 * -log10((1690000 - value) / value) + 2.6
+			 * value [653799, 1689999], 2.6 / 13 = 3355443
+			 */
+			utmp1 = clamp(utmp1, 653799U, 1689999U);
+			utmp1 = ((u64)(intlog10(utmp1)
+				- intlog10(1690000 - utmp1)
+				+ 3355443) * 13 * 1000) >> 24;
+			break;
+		case 1:
+			/*
+			 * QAM-16
+			 * CNR[dB] 6 * log10((value - 370000) / (828000 - value)) + 15.7
+			 * value [371105, 827999], 15.7 / 6 = 43900382
+			 */
+			utmp1 = clamp(utmp1, 371105U, 827999U);
+			utmp1 = ((u64)(intlog10(utmp1 - 370000)
+				- intlog10(828000 - utmp1)
+				+ 43900382) * 6 * 1000) >> 24;
+			break;
+		case 2:
+			/*
+			 * QAM-64
+			 * CNR[dB] 8 * log10((value - 193000) / (425000 - value)) + 23.8
+			 * value [193246, 424999], 23.8 / 8 = 49912218
+			 */
+			utmp1 = clamp(utmp1, 193246U, 424999U);
+			utmp1 = ((u64)(intlog10(utmp1 - 193000)
+				- intlog10(425000 - utmp1)
+				+ 49912218) * 8 * 1000) >> 24;
+			break;
+		default:
+			dev_dbg(&client->dev, "invalid modulation %u\n",
+				(utmp >> 6) & 3);
+			utmp1 = 0;
+			break;
+		}
+
+		dev_dbg(&client->dev, "cnr %u\n", utmp1);
+
+		state->cnr_jiffies = jiffies;
+
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = utmp1;
+		break;
+	default:
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		break;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index 688fc3472cf6..9c3cb04e3494 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -22,6 +22,7 @@
 #define AF9013_PRIV_H
 
 #include <media/dvb_frontend.h>
+#include <media/dvb_math.h>
 #include "af9013.h"
 #include <linux/firmware.h>
 #include <linux/math64.h>
-- 
2.14.3
