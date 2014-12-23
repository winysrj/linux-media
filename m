Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43813 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbaLWUub (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:31 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 23/66] rtl2832: add platform data callbacks for exported resources
Date: Tue, 23 Dec 2014 22:49:16 +0200
Message-Id: <1419367799-14263-23-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add callback for all of those functions which are currently
exported using EXPORT_SYMBOL. That allows us convert every user to
callbacks and eventually all exported symbols could be removed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 90 +++++++++++++++++++++++++++++++----
 drivers/media/dvb-frontends/rtl2832.h |  7 +++
 2 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 9597ae1..4e77ef2 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1183,6 +1183,80 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
 
+static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
+{
+	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+	return &dev->fe;
+}
+
+static struct i2c_adapter *rtl2832_get_i2c_adapter_(struct i2c_client *client)
+{
+	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+	return dev->i2c_adapter_tuner;
+}
+
+static struct i2c_adapter *rtl2832_get_private_i2c_adapter_(struct i2c_client *client)
+{
+	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+	return dev->i2c_adapter;
+}
+
+static int rtl2832_enable_slave_ts(struct i2c_client *client)
+{
+	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+	int ret;
+
+	dev_dbg(&client->dev, "setting PIP mode\n");
+
+	ret = rtl2832_wr_regs(dev, 0x0c, 1, "\x5f\xff", 2);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_demod_reg(dev, DVBT_PIP_ON, 0x1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(dev, 0xbc, 0, 0x18);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(dev, 0x22, 0, 0x01);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(dev, 0x26, 0, 0x1f);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(dev, 0x27, 0, 0xff);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_regs(dev, 0x92, 1, "\x7f\xf7\xff", 3);
+	if (ret)
+		goto err;
+
+	/* soft reset */
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
 static int rtl2832_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
@@ -1200,13 +1274,6 @@ static int rtl2832_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	/* Caller really need to provide pointer for frontend we create. */
-	if (pdata->dvb_frontend == NULL) {
-		dev_err(&client->dev, "frontend pointer not defined\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
 	/* allocate memory for the internal state */
 	priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
 	if (priv == NULL) {
@@ -1248,7 +1315,14 @@ static int rtl2832_probe(struct i2c_client *client,
 	priv->fe.ops.release = NULL;
 	priv->fe.demodulator_priv = priv;
 	i2c_set_clientdata(client, priv);
-	*pdata->dvb_frontend = &priv->fe;
+	if (pdata->dvb_frontend)
+		*pdata->dvb_frontend = &priv->fe;
+
+	/* setup callbacks */
+	pdata->get_dvb_frontend = rtl2832_get_dvb_frontend;
+	pdata->get_i2c_adapter = rtl2832_get_i2c_adapter_;
+	pdata->get_private_i2c_adapter = rtl2832_get_private_i2c_adapter_;
+	pdata->enable_slave_ts = rtl2832_enable_slave_ts;
 
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index cfd69d8..dbc4d3c 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -58,6 +58,13 @@ struct rtl2832_platform_data {
 	 * returned by driver
 	 */
 	struct dvb_frontend **dvb_frontend;
+
+	/*
+	 */
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
+	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
+	struct i2c_adapter* (*get_private_i2c_adapter)(struct i2c_client *);
+	int (*enable_slave_ts)(struct i2c_client *);
 };
 
 #if IS_ENABLED(CONFIG_DVB_RTL2832)
-- 
http://palosaari.fi/

