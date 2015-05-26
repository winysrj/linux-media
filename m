Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbbEZPEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 11:04:22 -0400
Subject: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
From: David Howells <dhowells@redhat.com>
To: crope@iki.fi
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Tue, 26 May 2015 16:04:07 +0100
Message-ID: <20150526150407.10241.89123.stgit@warthog.procyon.org.uk>
In-Reply-To: <20150526150400.10241.25444.stgit@warthog.procyon.org.uk>
References: <20150526150400.10241.25444.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a DVBv5 API signal strength.  This is in units of 0.001 dBm rather
than a percentage.

>From Antti Palosaari's testing with a signal generator, it appears that the
gain calculated according to Montage's specification if negated is a
reasonable representation of the signal strength of the generator.

To this end:

 (1) Polled statistic gathering needed to be implemented in the TS2020 driver.
     This is done in the ts2020_stat_work() function.

 (2) The calculated gain is placed as the signal strength in the
     dtv_property_cache associated with the front end with the scale set to
     FE_SCALE_DECIBEL.

 (3) The DVBv3 format signal strength then needed to be calculated from the
     signal strength stored in the dtv_property_cache rather than accessing
     the value when ts2020_read_signal_strength() is called.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/dvb-frontends/ts2020.c |   62 +++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 277e1cf..80ae039 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -32,10 +32,11 @@ struct ts2020_priv {
 	struct regmap_config regmap_config;
 	struct regmap *regmap;
 	struct dvb_frontend *fe;
+	struct delayed_work stat_work;
 	int (*get_agc_pwm)(struct dvb_frontend *fe, u8 *_agc_pwm);
 	/* i2c details */
-	int i2c_address;
 	struct i2c_adapter *i2c;
+	int i2c_address;
 	u8 clk_out:2;
 	u8 clk_out_div:5;
 	u32 frequency_div; /* LO output divider switch frequency */
@@ -65,6 +66,7 @@ static int ts2020_release(struct dvb_frontend *fe)
 static int ts2020_sleep(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
+	int ret;
 	u8 u8tmp;
 
 	if (priv->tuner == TS2020_M88TS2020)
@@ -72,11 +74,18 @@ static int ts2020_sleep(struct dvb_frontend *fe)
 	else
 		u8tmp = 0x00;
 
-	return regmap_write(priv->regmap, u8tmp, 0x00);
+	ret = regmap_write(priv->regmap, u8tmp, 0x00);
+	if (ret < 0)
+		return ret;
+
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&priv->stat_work);
+	return 0;
 }
 
 static int ts2020_init(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct ts2020_priv *priv = fe->tuner_priv;
 	int i;
 	u8 u8tmp;
@@ -138,6 +147,13 @@ static int ts2020_init(struct dvb_frontend *fe)
 				     reg_vals[i].val);
 	}
 
+	/* Initialise v5 stats here */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->strength.stat[0].uvalue = 0;
+
+	/* Start statistics polling */
+	schedule_delayed_work(&priv->stat_work, 0);
 	return 0;
 }
 
@@ -411,19 +427,46 @@ static int ts2020_get_tuner_gain(struct dvb_frontend *fe, __s64 *_gain)
 }
 
 /*
+ * Gather statistics on a regular basis
+ */
+static void ts2020_stat_work(struct work_struct *work)
+{
+	struct ts2020_priv *priv = container_of(work, struct ts2020_priv,
+					       stat_work.work);
+	struct i2c_client *client = priv->client;
+	struct dtv_frontend_properties *c = &priv->fe->dtv_property_cache;
+	int ret;
+
+	dev_dbg(&client->dev, "\n");
+
+	ret = ts2020_get_tuner_gain(priv->fe, &c->strength.stat[0].svalue);
+	if (ret < 0)
+		goto err;
+
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+
+	schedule_delayed_work(&priv->stat_work, msecs_to_jiffies(2000));
+	return;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+}
+
+/*
  * Read TS2020 signal strength in v3 format.
  */
 static int ts2020_read_signal_strength(struct dvb_frontend *fe,
-						u16 *signal_strength)
+				       u16 *_signal_strength)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	unsigned strength;
 	__s64 gain;
-	int ret;
 
-	/* Determine the total gain of the tuner */
-	ret = ts2020_get_tuner_gain(fe, &gain);
-	if (ret < 0)
-		return ret;
+	if (c->strength.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
+		*_signal_strength = 0;
+		return 0;
+	}
+
+	gain = c->strength.stat[0].svalue;
 
 	/* Calculate the signal strength based on the total gain of the tuner */
 	if (gain < -85000)
@@ -439,7 +482,7 @@ static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 		/* 90% - 99%: strong signal */
 		strength = 90 + (45000 + gain) / 5000;
 
-	*signal_strength = strength * 65535 / 100;
+	*_signal_strength = strength * 65535 / 100;
 	return 0;
 }
 
@@ -546,6 +589,7 @@ static int ts2020_probe(struct i2c_client *client,
 	dev->get_agc_pwm = pdata->get_agc_pwm;
 	fe->tuner_priv = dev;
 	dev->client = client;
+	INIT_DELAYED_WORK(&dev->stat_work, ts2020_stat_work);
 
 	/* check if the tuner is there */
 	ret = regmap_read(dev->regmap, 0x00, &utmp);

