Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:54091 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932772AbeCMXkK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/18] af9013: dvbv5 signal strength
Date: Wed, 14 Mar 2018 01:39:28 +0200
Message-Id: <20180313233944.7234-2-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement dvbv5 signal strength estimate. We know tuner dependent
-80dBm and -50dBm agc values, construct line equation and use it to
map agc value to signal strength estimate.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 83 +++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 30cf837058da..4cb6371572c5 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -41,8 +41,11 @@ struct af9013_state {
 	u16 snr;
 	u32 bandwidth_hz;
 	enum fe_status fe_status;
+	/* RF and IF AGC limits used for signal strength calc */
+	u8 strength_en, rf_agc_50, rf_agc_80, if_agc_50, if_agc_80;
 	unsigned long set_frontend_jiffies;
 	unsigned long read_status_jiffies;
+	unsigned long strength_jiffies;
 	bool first_tune;
 	bool i2c_gate_state;
 	unsigned int statistics_step:3;
@@ -751,8 +754,12 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
-	int ret;
-	unsigned int utmp, utmp1;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, stmp1;
+	unsigned int utmp, utmp1, utmp2, utmp3, utmp4;
+	u8 buf[2];
+
+	dev_dbg(&client->dev, "\n");
 
 	/*
 	 * Return status from the cache if it is younger than 2000ms with the
@@ -791,6 +798,77 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		*status = utmp1;
 	}
 
+	/* Signal strength */
+	switch (state->strength_en) {
+	case 0:
+		/* Check if we support signal strength */
+		ret = regmap_read(state->regmap, 0x9bee, &utmp);
+		if (ret)
+			goto err;
+
+		if ((utmp >> 0) & 0x01) {
+			/* Read agc values for signal strength estimation */
+			ret = regmap_read(state->regmap, 0x9bbd, &utmp1);
+			if (ret)
+				goto err;
+			ret = regmap_read(state->regmap, 0x9bd0, &utmp2);
+			if (ret)
+				goto err;
+			ret = regmap_read(state->regmap, 0x9be2, &utmp3);
+			if (ret)
+				goto err;
+			ret = regmap_read(state->regmap, 0x9be4, &utmp4);
+			if (ret)
+				goto err;
+
+			state->rf_agc_50 = utmp1;
+			state->rf_agc_80 = utmp2;
+			state->if_agc_50 = utmp3;
+			state->if_agc_80 = utmp4;
+			dev_dbg(&client->dev,
+				"rf_agc_50 %u, rf_agc_80 %u, if_agc_50 %u, if_agc_80 %u\n",
+				utmp1, utmp2, utmp3, utmp4);
+
+			state->strength_en = 1;
+		} else {
+			/* Signal strength is not supported */
+			state->strength_en = 2;
+			break;
+		}
+		/* Fall through */
+	case 1:
+		if (time_is_after_jiffies(state->strength_jiffies + msecs_to_jiffies(2000)))
+			break;
+
+		/* Read value */
+		ret = regmap_bulk_read(state->regmap, 0xd07c, buf, 2);
+		if (ret)
+			goto err;
+
+		/*
+		 * Construct line equation from tuner dependent -80/-50 dBm agc
+		 * limits and use it to map current agc value to dBm estimate
+		 */
+		#define agc_gain (buf[0] + buf[1])
+		#define agc_gain_50dbm (state->rf_agc_50 + state->if_agc_50)
+		#define agc_gain_80dbm (state->rf_agc_80 + state->if_agc_80)
+		stmp1 = 30000 * (agc_gain - agc_gain_80dbm) /
+			(agc_gain_50dbm - agc_gain_80dbm) - 80000;
+
+		dev_dbg(&client->dev,
+			"strength %d, agc_gain %d, agc_gain_50dbm %d, agc_gain_80dbm %d\n",
+			stmp1, agc_gain, agc_gain_50dbm, agc_gain_80dbm);
+
+		state->strength_jiffies = jiffies;
+
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = stmp1;
+		break;
+	default:
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		break;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
@@ -1512,6 +1590,7 @@ static int af9013_probe(struct i2c_client *client,
 
 	/* Init stats to indicate which stats are supported */
 	c = &state->fe.dtv_property_cache;
+	c->strength.len = 1;
 	c->cnr.len = 1;
 
 	dev_info(&client->dev, "Afatech AF9013 successfully attached\n");
-- 
2.14.3
