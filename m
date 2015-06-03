Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbbFCLfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 07:35:11 -0400
Subject: [PATCH] ts2020: Allow stats polling to be suppressed
From: David Howells <dhowells@redhat.com>
To: crope@iki.fi
Cc: dhowells@redhat.com, tvboxspy@gmail.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Wed, 03 Jun 2015 12:35:08 +0100
Message-ID: <20150603113508.32135.28906.stgit@warthog.procyon.org.uk>
In-Reply-To: <5564C269.2000003@gmail.com>
References: <5564C269.2000003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Statistics polling can not be done by lmedm04 driver's implementation of
M88RS2000/TS2020 because I2C messages stop the device's demuxer, so allow
polling for statistics to be suppressed in the ts2020 driver by setting
dont_poll in the ts2020_config struct.

Reported-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Malcolm Priestley <tvboxspy@gmail.com>
---

 drivers/media/dvb-frontends/ts2020.c |   18 ++++++++++++++----
 drivers/media/dvb-frontends/ts2020.h |    3 +++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 8c997d0..946d8e950 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -40,6 +40,7 @@ struct ts2020_priv {
 	bool loop_through:1;
 	u8 clk_out:2;
 	u8 clk_out_div:5;
+	bool dont_poll:1;
 	u32 frequency_div; /* LO output divider switch frequency */
 	u32 frequency_khz; /* actual used LO frequency */
 #define TS2020_M88TS2020 0
@@ -52,6 +53,8 @@ struct ts2020_reg_val {
 	u8 val;
 };
 
+static void ts2020_stat_work(struct work_struct *work);
+
 static int ts2020_release(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
@@ -79,7 +82,8 @@ static int ts2020_sleep(struct dvb_frontend *fe)
 		return ret;
 
 	/* stop statistics polling */
-	cancel_delayed_work_sync(&priv->stat_work);
+	if (!priv->dont_poll)
+		cancel_delayed_work_sync(&priv->stat_work);
 	return 0;
 }
 
@@ -152,8 +156,8 @@ static int ts2020_init(struct dvb_frontend *fe)
 	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
 	c->strength.stat[0].uvalue = 0;
 
-	/* Start statistics polling */
-	schedule_delayed_work(&priv->stat_work, 0);
+	/* Start statistics polling by invoking the work function */
+	ts2020_stat_work(&priv->stat_work.work);
 	return 0;
 }
 
@@ -445,7 +449,8 @@ static void ts2020_stat_work(struct work_struct *work)
 
 	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
 
-	schedule_delayed_work(&priv->stat_work, msecs_to_jiffies(2000));
+	if (!priv->dont_poll)
+		schedule_delayed_work(&priv->stat_work, msecs_to_jiffies(2000));
 	return;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -458,9 +463,13 @@ static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 				       u16 *_signal_strength)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct ts2020_priv *priv = fe->tuner_priv;
 	unsigned strength;
 	__s64 gain;
 
+	if (priv->dont_poll)
+		ts2020_stat_work(&priv->stat_work.work);
+
 	if (c->strength.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
 		*_signal_strength = 0;
 		return 0;
@@ -585,6 +594,7 @@ static int ts2020_probe(struct i2c_client *client,
 	dev->loop_through = pdata->loop_through;
 	dev->clk_out = pdata->clk_out;
 	dev->clk_out_div = pdata->clk_out_div;
+	dev->dont_poll = pdata->dont_poll;
 	dev->frequency_div = pdata->frequency_div;
 	dev->fe = fe;
 	dev->get_agc_pwm = pdata->get_agc_pwm;
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index 002bc0a..9220e5c 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -48,6 +48,9 @@ struct ts2020_config {
 	 */
 	u8 clk_out_div:5;
 
+	/* Set to true to suppress stat polling */
+	bool dont_poll:1;
+
 	/*
 	 * pointer to DVB frontend
 	 */

