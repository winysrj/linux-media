Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42206 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaLNI3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/18] rtl2830: implement DVBv5 CNR statistic
Date: Sun, 14 Dec 2014 10:28:34 +0200
Message-Id: <1418545723-9536-9-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBv5 CNR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 74 ++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2830_priv.h |  3 ++
 2 files changed, 77 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 8025b19..c484634 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -177,6 +177,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
 	int ret, i;
 	struct rtl2830_reg_val_mask tab[] = {
 		{0x00d, 0x01, 0x03},
@@ -244,6 +245,12 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* init stats here in order signal app which stats are supported */
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	/* start statistics polling */
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
+
 	dev->sleeping = false;
 
 	return ret;
@@ -258,6 +265,9 @@ static int rtl2830_sleep(struct dvb_frontend *fe)
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev->sleeping = true;
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+	dev->fe_status = 0;
 
 	return 0;
 }
@@ -518,6 +528,8 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 			FE_HAS_VITERBI;
 	}
 
+	dev->fe_status = *status;
+
 	return ret;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -670,6 +682,66 @@ static struct dvb_frontend_ops rtl2830_ops = {
 	.read_signal_strength = rtl2830_read_signal_strength,
 };
 
+static void rtl2830_stat_work(struct work_struct *work)
+{
+	struct rtl2830_dev *dev = container_of(work, struct rtl2830_dev, stat_work.work);
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
+			{70705899, 70705899, 70705899, 70705899},
+			{82433173, 82433173, 87483115, 94445660},
+			{92888734, 92888734, 95487525, 99770748},
+		};
+
+		ret = rtl2830_rd_reg(client, 0x33c, &u8tmp);
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
+		ret = rtl2830_rd_regs(client, 0x40c, buf, 2);
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
+		dev_dbg(&client->dev, "CNR raw=%u\n", u16tmp);
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
  * I2C gate/repeater logic
  * We must use unlocked i2c_transfer() here because I2C lock is already taken
@@ -765,8 +837,10 @@ static int rtl2830_probe(struct i2c_client *client,
 
 	/* setup the state */
 	i2c_set_clientdata(client, dev);
+	dev->client = client;
 	dev->pdata = client->dev.platform_data;
 	dev->sleeping = true;
+	INIT_DELAYED_WORK(&dev->stat_work, rtl2830_stat_work);
 
 	/* check if the demod is there */
 	ret = rtl2830_rd_reg(client, 0x000, &u8tmp);
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 5f9973a..7cf316d 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -25,10 +25,13 @@
 
 struct rtl2830_dev {
 	struct rtl2830_platform_data *pdata;
+	struct i2c_client *client;
 	struct i2c_adapter *adapter;
 	struct dvb_frontend fe;
 	bool sleeping;
 	u8 page; /* active register page */
+	struct delayed_work stat_work;
+	fe_status_t fe_status;
 };
 
 struct rtl2830_reg_val_mask {
-- 
http://palosaari.fi/

