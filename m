Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44175 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbcF2XlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:41:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] rtl2830: move statistics to read_status()
Date: Thu, 30 Jun 2016 02:40:56 +0300
Message-Id: <1467243657-26426-2-git-send-email-crope@iki.fi>
In-Reply-To: <1467243657-26426-1-git-send-email-crope@iki.fi>
References: <1467243657-26426-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move statistics polling to read_status() in order to avoid use of
kernel work. Also replace home made sign extension used for
statistics with kernel sign_extend32().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 200 +++++++++++++----------------
 drivers/media/dvb-frontends/rtl2830_priv.h |   2 +-
 2 files changed, 88 insertions(+), 114 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index ec1e94a..8722605 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -135,8 +135,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_count.len = 1;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	/* start statistics polling */
-	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 
 	dev->sleeping = false;
 
@@ -152,8 +150,6 @@ static int rtl2830_sleep(struct dvb_frontend *fe)
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev->sleeping = true;
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&dev->stat_work);
 	dev->fe_status = 0;
 
 	return 0;
@@ -396,8 +392,10 @@ static int rtl2830_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
-	int ret;
-	u8 u8tmp;
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
+	int ret, stmp;
+	unsigned int utmp;
+	u8 u8tmp, buf[2];
 
 	*status = 0;
 
@@ -419,6 +417,89 @@ static int rtl2830_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	dev->fe_status = *status;
 
+	/* Signal strength */
+	if (dev->fe_status & FE_HAS_SIGNAL) {
+		/* Read IF AGC */
+		ret = rtl2830_bulk_read(client, 0x359, buf, 2);
+		if (ret)
+			goto err;
+
+		stmp = buf[0] << 8 | buf[1] << 0;
+		stmp = sign_extend32(stmp, 13);
+		utmp = clamp_val(-4 * stmp + 32767, 0x0000, 0xffff);
+
+		dev_dbg(&client->dev, "IF AGC=%d\n", stmp);
+
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = utmp;
+	} else {
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* CNR */
+	if (dev->fe_status & FE_HAS_VITERBI) {
+		unsigned int hierarchy, constellation;
+		#define CONSTELLATION_NUM 3
+		#define HIERARCHY_NUM 4
+		static const u32 constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
+			{70705899, 70705899, 70705899, 70705899},
+			{82433173, 82433173, 87483115, 94445660},
+			{92888734, 92888734, 95487525, 99770748},
+		};
+
+		ret = rtl2830_bulk_read(client, 0x33c, &u8tmp, 1);
+		if (ret)
+			goto err;
+
+		constellation = (u8tmp >> 2) & 0x03; /* [3:2] */
+		if (constellation > CONSTELLATION_NUM - 1)
+			goto err;
+
+		hierarchy = (u8tmp >> 4) & 0x07; /* [6:4] */
+		if (hierarchy > HIERARCHY_NUM - 1)
+			goto err;
+
+		ret = rtl2830_bulk_read(client, 0x40c, buf, 2);
+		if (ret)
+			goto err;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		if (utmp)
+			stmp = (constant[constellation][hierarchy] -
+			       intlog10(utmp)) / ((1 << 24) / 10000);
+		else
+			stmp = 0;
+
+		dev_dbg(&client->dev, "CNR raw=%u\n", utmp);
+
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = stmp;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* BER */
+	if (dev->fe_status & FE_HAS_LOCK) {
+		ret = rtl2830_bulk_read(client, 0x34e, buf, 2);
+		if (ret)
+			goto err;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		dev->post_bit_error += utmp;
+		dev->post_bit_count += 1000000;
+
+		dev_dbg(&client->dev, "BER errors=%u total=1000000\n", utmp);
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+
 	return ret;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -503,109 +584,6 @@ static struct dvb_frontend_ops rtl2830_ops = {
 	.read_signal_strength = rtl2830_read_signal_strength,
 };
 
-static void rtl2830_stat_work(struct work_struct *work)
-{
-	struct rtl2830_dev *dev = container_of(work, struct rtl2830_dev, stat_work.work);
-	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
-	int ret, tmp;
-	u8 u8tmp, buf[2];
-	u16 u16tmp;
-
-	dev_dbg(&client->dev, "\n");
-
-	/* signal strength */
-	if (dev->fe_status & FE_HAS_SIGNAL) {
-		struct {signed int x:14; } s;
-
-		/* read IF AGC */
-		ret = rtl2830_bulk_read(client, 0x359, buf, 2);
-		if (ret)
-			goto err;
-
-		u16tmp = buf[0] << 8 | buf[1] << 0;
-		u16tmp &= 0x3fff; /* [13:0] */
-		tmp = s.x = u16tmp; /* 14-bit bin to 2 complement */
-		u16tmp = clamp_val(-4 * tmp + 32767, 0x0000, 0xffff);
-
-		dev_dbg(&client->dev, "IF AGC=%d\n", tmp);
-
-		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
-		c->strength.stat[0].uvalue = u16tmp;
-	} else {
-		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	/* CNR */
-	if (dev->fe_status & FE_HAS_VITERBI) {
-		unsigned hierarchy, constellation;
-		#define CONSTELLATION_NUM 3
-		#define HIERARCHY_NUM 4
-		static const u32 constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
-			{70705899, 70705899, 70705899, 70705899},
-			{82433173, 82433173, 87483115, 94445660},
-			{92888734, 92888734, 95487525, 99770748},
-		};
-
-		ret = rtl2830_bulk_read(client, 0x33c, &u8tmp, 1);
-		if (ret)
-			goto err;
-
-		constellation = (u8tmp >> 2) & 0x03; /* [3:2] */
-		if (constellation > CONSTELLATION_NUM - 1)
-			goto err_schedule_delayed_work;
-
-		hierarchy = (u8tmp >> 4) & 0x07; /* [6:4] */
-		if (hierarchy > HIERARCHY_NUM - 1)
-			goto err_schedule_delayed_work;
-
-		ret = rtl2830_bulk_read(client, 0x40c, buf, 2);
-		if (ret)
-			goto err;
-
-		u16tmp = buf[0] << 8 | buf[1] << 0;
-		if (u16tmp)
-			tmp = (constant[constellation][hierarchy] -
-			       intlog10(u16tmp)) / ((1 << 24) / 10000);
-		else
-			tmp = 0;
-
-		dev_dbg(&client->dev, "CNR raw=%u\n", u16tmp);
-
-		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		c->cnr.stat[0].svalue = tmp;
-	} else {
-		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	/* BER */
-	if (dev->fe_status & FE_HAS_LOCK) {
-		ret = rtl2830_bulk_read(client, 0x34e, buf, 2);
-		if (ret)
-			goto err;
-
-		u16tmp = buf[0] << 8 | buf[1] << 0;
-		dev->post_bit_error += u16tmp;
-		dev->post_bit_count += 1000000;
-
-		dev_dbg(&client->dev, "BER errors=%u total=1000000\n", u16tmp);
-
-		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
-		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
-	} else {
-		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-err_schedule_delayed_work:
-	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
-	return;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-}
-
 static int rtl2830_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct i2c_client *client = fe->demodulator_priv;
@@ -851,7 +829,6 @@ static int rtl2830_probe(struct i2c_client *client,
 	dev->client = client;
 	dev->pdata = client->dev.platform_data;
 	dev->sleeping = true;
-	INIT_DELAYED_WORK(&dev->stat_work, rtl2830_stat_work);
 	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
 				  &regmap_config);
 	if (IS_ERR(dev->regmap)) {
@@ -904,9 +881,6 @@ static int rtl2830_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&dev->stat_work);
-
 	i2c_mux_del_adapters(dev->muxc);
 	regmap_exit(dev->regmap);
 	kfree(dev);
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index da49095..8ec4721 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -24,6 +24,7 @@
 #include <linux/i2c-mux.h>
 #include <linux/math64.h>
 #include <linux/regmap.h>
+#include <linux/bitops.h>
 
 struct rtl2830_dev {
 	struct rtl2830_platform_data *pdata;
@@ -33,7 +34,6 @@ struct rtl2830_dev {
 	struct dvb_frontend fe;
 	bool sleeping;
 	unsigned long filters;
-	struct delayed_work stat_work;
 	enum fe_status fe_status;
 	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
 	u64 post_bit_error;
-- 
http://palosaari.fi/

