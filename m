Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48891 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 31/66] rtl2832: implement DVBv5 CNR statistic
Date: Tue, 23 Dec 2014 22:49:24 +0200
Message-Id: <1419367799-14263-31-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBv5 CNR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 73 +++++++++++++++++++++++++++++-
 drivers/media/dvb-frontends/rtl2832_priv.h |  3 +-
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index c7148c9..7dc4c27 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -367,6 +367,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	const struct rtl2832_reg_value *init;
 	int i, ret, len;
 	/* initialization values for the demodulator registers */
@@ -472,11 +473,14 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 #endif
-
+	/* init stats here in order signal app which stats are supported */
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	/* start statistics polling */
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	dev->sleeping = false;
 
 	return ret;
-
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -489,6 +493,9 @@ static int rtl2832_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 	dev->sleeping = true;
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+	dev->fe_status = 0;
 	return 0;
 }
 
@@ -771,6 +778,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 				FE_HAS_VITERBI;
 	}*/
 
+	dev->fe_status = *status;
 	return ret;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -843,6 +851,66 @@ err:
 	return ret;
 }
 
+static void rtl2832_stat_work(struct work_struct *work)
+{
+	struct rtl2832_dev *dev = container_of(work, struct rtl2832_dev, stat_work.work);
+	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
+	int ret, tmp;
+	u8 u8tmp, buf[2];
+	u16 u16tmp;
+
+	dev_dbg(&client->dev, "\n");
+
+	/* CNR */
+	if (dev->fe_status & FE_HAS_VITERBI) {
+		unsigned hierarchy, constellation;
+		#define CONSTELLATION_NUM 3
+		#define HIERARCHY_NUM 4
+		static const u32 constant[CONSTELLATION_NUM][HIERARCHY_NUM] = {
+			{85387325, 85387325, 85387325, 85387325},
+			{86676178, 86676178, 87167949, 87795660},
+			{87659938, 87659938, 87885178, 88241743},
+		};
+
+		ret = rtl2832_bulk_read(client, 0x33c, &u8tmp, 1);
+		if (ret)
+			goto err;
+
+		constellation = (u8tmp >> 2) & 0x03; /* [3:2] */
+		if (constellation > CONSTELLATION_NUM - 1)
+			goto err_schedule_delayed_work;
+
+		hierarchy = (u8tmp >> 4) & 0x07; /* [6:4] */
+		if (hierarchy > HIERARCHY_NUM - 1)
+			goto err_schedule_delayed_work;
+
+		ret = rtl2832_bulk_read(client, 0x40c, buf, 2);
+		if (ret)
+			goto err;
+
+		u16tmp = buf[0] << 8 | buf[1] << 0;
+		if (u16tmp)
+			tmp = (constant[constellation][hierarchy] -
+			       intlog10(u16tmp)) / ((1 << 24) / 10000);
+		else
+			tmp = 0;
+
+		dev_dbg(&client->dev, "cnr raw=%u\n", u16tmp);
+
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = tmp;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+err_schedule_delayed_work:
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
+	return;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+}
+
 /*
  * I2C gate/mux/repeater logic
  * We must use unlocked __i2c_transfer() here (through regmap) because of I2C
@@ -1167,6 +1235,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 	dev->sleeping = true;
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
+	INIT_DELAYED_WORK(&dev->stat_work, rtl2832_stat_work);
 	/* create regmap */
 	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
 				  &regmap_config);
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index eacd4e4..3c44983 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -33,7 +33,8 @@ struct rtl2832_dev {
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
-
+	struct delayed_work stat_work;
+	fe_status_t fe_status;
 	bool i2c_gate_state;
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
-- 
http://palosaari.fi/

