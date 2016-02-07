Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58731 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbcBGTzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 14:55:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] rtl2832: move stats polling to read status
Date: Sun,  7 Feb 2016 21:54:50 +0200
Message-Id: <1454874890-10724-5-git-send-email-crope@iki.fi>
In-Reply-To: <1454874890-10724-1-git-send-email-crope@iki.fi>
References: <1454874890-10724-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do statistics polling on read status in order to avoid
unnecessary delayed work.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 79 ++++++++++++------------------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 -
 2 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index a9b2646..cb50488 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -408,8 +408,6 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_count.len = 1;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	/* start statistics polling */
-	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	dev->sleeping = false;
 
 	return 0;
@@ -427,8 +425,6 @@ static int rtl2832_sleep(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	dev->sleeping = true;
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&dev->stat_work);
 	dev->fe_status = 0;
 
 	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
@@ -691,8 +687,11 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u32 uninitialized_var(tmp);
+	u8 u8tmp, buf[2];
+	u16 u16tmp;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -713,45 +712,6 @@ static int rtl2832_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	}
 
 	dev->fe_status = *status;
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
-static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	/* report SNR in resolution of 0.1 dB */
-	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
-		*snr = div_s64(c->cnr.stat[0].svalue, 100);
-	else
-		*snr = 0;
-
-	return 0;
-}
-
-static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct rtl2832_dev *dev = fe->demodulator_priv;
-
-	*ber = (dev->post_bit_error - dev->post_bit_error_prev);
-	dev->post_bit_error_prev = dev->post_bit_error;
-
-	return 0;
-}
-
-static void rtl2832_stat_work(struct work_struct *work)
-{
-	struct rtl2832_dev *dev = container_of(work, struct rtl2832_dev, stat_work.work);
-	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
-	int ret, tmp;
-	u8 u8tmp, buf[2];
-	u16 u16tmp;
-
-	dev_dbg(&client->dev, "\n");
 
 	/* signal strength */
 	if (dev->fe_status & FE_HAS_SIGNAL) {
@@ -788,11 +748,11 @@ static void rtl2832_stat_work(struct work_struct *work)
 
 		constellation = (u8tmp >> 2) & 0x03; /* [3:2] */
 		if (constellation > CONSTELLATION_NUM - 1)
-			goto err_schedule_delayed_work;
+			goto err;
 
 		hierarchy = (u8tmp >> 4) & 0x07; /* [6:4] */
 		if (hierarchy > HIERARCHY_NUM - 1)
-			goto err_schedule_delayed_work;
+			goto err;
 
 		ret = rtl2832_bulk_read(client, 0x40c, buf, 2);
 		if (ret)
@@ -834,11 +794,33 @@ static void rtl2832_stat_work(struct work_struct *work)
 		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
-err_schedule_delayed_work:
-	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
-	return;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	/* report SNR in resolution of 0.1 dB */
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
+	else
+		*snr = 0;
+
+	return 0;
+}
+
+static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct rtl2832_dev *dev = fe->demodulator_priv;
+
+	*ber = (dev->post_bit_error - dev->post_bit_error_prev);
+	dev->post_bit_error_prev = dev->post_bit_error;
+
+	return 0;
 }
 
 /*
@@ -1235,7 +1217,6 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev->pdata = client->dev.platform_data;
 	dev->sleeping = true;
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
-	INIT_DELAYED_WORK(&dev->stat_work, rtl2832_stat_work);
 	/* create regmap */
 	mutex_init(&dev->regmap_mutex);
 	dev->regmap_config.reg_bits =  8,
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 5dcd3a4..6b875f4 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -38,7 +38,6 @@ struct rtl2832_dev {
 	struct regmap *regmap;
 	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
-	struct delayed_work stat_work;
 	enum fe_status fe_status;
 	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
 	u64 post_bit_error;
-- 
http://palosaari.fi/

