Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39898 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaLNI3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/18] rtl2830: implement own I2C locking
Date: Sun, 14 Dec 2014 10:28:42 +0200
Message-Id: <1418545723-9536-17-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Own I2C locking is needed due to two special reasons:
1) Chips uses multiple register pages/banks on single I2C slave.
Page is changed via I2C register access.
2) Chip offers muxed/gated I2C adapter for tuner. Gate/mux is
controlled by I2C register access.

Due to these reasons, I2C locking did not fit very well.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 45 +++++++++++++++++++++++++-----
 drivers/media/dvb-frontends/rtl2830_priv.h |  1 +
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 8abaca6..3a9e4e9 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -43,7 +43,7 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(client->adapter, msg, 1);
+	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
@@ -73,7 +73,7 @@ static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
 		}
 	};
 
-	ret = i2c_transfer(client->adapter, msg, 2);
+	ret = __i2c_transfer(client->adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
@@ -93,16 +93,23 @@ static int rtl2830_wr_regs(struct i2c_client *client, u16 reg, const u8 *val, in
 	u8 reg2 = (reg >> 0) & 0xff;
 	u8 page = (reg >> 8) & 0xff;
 
+	mutex_lock(&dev->i2c_mutex);
+
 	/* switch bank if needed */
 	if (page != dev->page) {
 		ret = rtl2830_wr(client, 0x00, &page, 1);
 		if (ret)
-			return ret;
+			goto err_mutex_unlock;
 
 		dev->page = page;
 	}
 
-	return rtl2830_wr(client, reg2, val, len);
+	ret = rtl2830_wr(client, reg2, val, len);
+
+err_mutex_unlock:
+	mutex_unlock(&dev->i2c_mutex);
+
+	return ret;
 }
 
 /* read multiple registers */
@@ -113,16 +120,23 @@ static int rtl2830_rd_regs(struct i2c_client *client, u16 reg, u8 *val, int len)
 	u8 reg2 = (reg >> 0) & 0xff;
 	u8 page = (reg >> 8) & 0xff;
 
+	mutex_lock(&dev->i2c_mutex);
+
 	/* switch bank if needed */
 	if (page != dev->page) {
 		ret = rtl2830_wr(client, 0x00, &page, 1);
 		if (ret)
-			return ret;
+			goto err_mutex_unlock;
 
 		dev->page = page;
 	}
 
-	return rtl2830_rd(client, reg2, val, len);
+	ret = rtl2830_rd(client, reg2, val, len);
+
+err_mutex_unlock:
+	mutex_unlock(&dev->i2c_mutex);
+
+	return ret;
 }
 
 /* read single register */
@@ -815,6 +829,10 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	};
 	int ret;
 
+	dev_dbg(&client->dev, "\n");
+
+	mutex_lock(&dev->i2c_mutex);
+
 	/* select register page */
 	ret = __i2c_transfer(client->adapter, select_reg_page_msg, 1);
 	if (ret != 1) {
@@ -841,6 +859,18 @@ err:
 	return ret;
 }
 
+static int rtl2830_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+{
+	struct i2c_client *client = mux_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	mutex_unlock(&dev->i2c_mutex);
+
+	return 0;
+}
+
 static struct dvb_frontend *rtl2830_get_dvb_frontend(struct i2c_client *client)
 {
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
@@ -886,6 +916,7 @@ static int rtl2830_probe(struct i2c_client *client,
 	dev->client = client;
 	dev->pdata = client->dev.platform_data;
 	dev->sleeping = true;
+	mutex_init(&dev->i2c_mutex);
 	INIT_DELAYED_WORK(&dev->stat_work, rtl2830_stat_work);
 
 	/* check if the demod is there */
@@ -895,7 +926,7 @@ static int rtl2830_probe(struct i2c_client *client,
 
 	/* create muxed i2c adapter for tuner */
 	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
-			client, 0, 0, 0, rtl2830_select, NULL);
+			client, 0, 0, 0, rtl2830_select, rtl2830_deselect);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
 		goto err_kfree;
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 2931889..517758a 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -30,6 +30,7 @@ struct rtl2830_dev {
 	struct i2c_adapter *adapter;
 	struct dvb_frontend fe;
 	bool sleeping;
+	struct mutex i2c_mutex;
 	u8 page; /* active register page */
 	unsigned long filters;
 	struct delayed_work stat_work;
-- 
http://palosaari.fi/

