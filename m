Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49897 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbbCXVNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/8] ts2020: implement I2C client bindings
Date: Tue, 24 Mar 2015 23:12:07 +0200
Message-Id: <1427231533-4277-3-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement I2C binding model.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 161 +++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 24c4712..b1d91dc 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -26,6 +26,7 @@
 #define FREQ_OFFSET_LOW_SYM_RATE 3000
 
 struct ts2020_priv {
+	struct dvb_frontend *fe;
 	/* i2c details */
 	int i2c_address;
 	struct i2c_adapter *i2c;
@@ -428,6 +429,7 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 	priv->clk_out = config->clk_out;
 	priv->clk_out_div = config->clk_out_div;
 	priv->frequency_div = config->frequency_div;
+	priv->fe = fe;
 	fe->tuner_priv = priv;
 
 	if (!priv->frequency_div)
@@ -463,6 +465,165 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 }
 EXPORT_SYMBOL(ts2020_attach);
 
+static int ts2020_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct ts2020_config *pdata = client->dev.platform_data;
+	struct dvb_frontend *fe = pdata->fe;
+	struct ts2020_priv *dev;
+	int ret;
+	u8 u8tmp;
+	unsigned int utmp;
+	char *chip_str;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->i2c = client->adapter;
+	dev->i2c_address = client->addr;
+	dev->clk_out = pdata->clk_out;
+	dev->clk_out_div = pdata->clk_out_div;
+	dev->frequency_div = pdata->frequency_div;
+	dev->fe = fe;
+	fe->tuner_priv = dev;
+
+	/* check if the tuner is there */
+	ret = ts2020_readreg(fe, 0x00);
+	if (ret < 0)
+		goto err;
+	utmp = ret;
+
+	if ((utmp & 0x03) == 0x00) {
+		ret = ts2020_writereg(fe, 0x00, 0x01);
+		if (ret)
+			goto err;
+
+		usleep_range(2000, 50000);
+	}
+
+	ret = ts2020_writereg(fe, 0x00, 0x03);
+	if (ret)
+		goto err;
+
+	usleep_range(2000, 50000);
+
+	ret = ts2020_readreg(fe, 0x00);
+	if (ret < 0)
+		goto err;
+	utmp = ret;
+
+	dev_dbg(&client->dev, "chip_id=%02x\n", utmp);
+
+	switch (utmp) {
+	case 0x01:
+	case 0x41:
+	case 0x81:
+		dev->tuner = TS2020_M88TS2020;
+		chip_str = "TS2020";
+		if (!dev->frequency_div)
+			dev->frequency_div = 1060000;
+		break;
+	case 0xc3:
+	case 0x83:
+		dev->tuner = TS2020_M88TS2022;
+		chip_str = "TS2022";
+		if (!dev->frequency_div)
+			dev->frequency_div = 1103000;
+		break;
+	default:
+		ret = -ENODEV;
+		goto err;
+	}
+
+	if (dev->tuner == TS2020_M88TS2022) {
+		switch (dev->clk_out) {
+		case TS2020_CLK_OUT_DISABLED:
+			u8tmp = 0x60;
+			break;
+		case TS2020_CLK_OUT_ENABLED:
+			u8tmp = 0x70;
+			ret = ts2020_writereg(fe, 0x05, dev->clk_out_div);
+			if (ret)
+				goto err;
+			break;
+		case TS2020_CLK_OUT_ENABLED_XTALOUT:
+			u8tmp = 0x6c;
+			break;
+		default:
+			ret = -EINVAL;
+			goto err;
+		}
+
+		ret = ts2020_writereg(fe, 0x42, u8tmp);
+		if (ret)
+			goto err;
+
+		if (dev->loop_through)
+			u8tmp = 0xec;
+		else
+			u8tmp = 0x6c;
+
+		ret = ts2020_writereg(fe, 0x62, u8tmp);
+		if (ret)
+			goto err;
+	}
+
+	/* sleep */
+	ret = ts2020_writereg(fe, 0x00, 0x00);
+	if (ret)
+		goto err;
+
+	dev_info(&client->dev,
+		 "Montage Technology %s successfully identified\n", chip_str);
+
+	memcpy(&fe->ops.tuner_ops, &ts2020_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+	fe->ops.tuner_ops.release = NULL;
+
+	i2c_set_clientdata(client, dev);
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	kfree(dev);
+	return ret;
+}
+
+static int ts2020_remove(struct i2c_client *client)
+{
+	struct ts2020_priv *dev = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = dev->fe;
+
+	dev_dbg(&client->dev, "\n");
+
+	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = NULL;
+	kfree(dev);
+
+	return 0;
+}
+
+static const struct i2c_device_id ts2020_id_table[] = {
+	{"ts2020", 0},
+	{"ts2022", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, ts2020_id_table);
+
+static struct i2c_driver ts2020_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "ts2020",
+	},
+	.probe		= ts2020_probe,
+	.remove		= ts2020_remove,
+	.id_table	= ts2020_id_table,
+};
+
+module_i2c_driver(ts2020_driver);
+
 MODULE_AUTHOR("Konstantin Dimitrov <kosio.dimitrov@gmail.com>");
 MODULE_DESCRIPTION("Montage Technology TS2020 - Silicon tuner driver module");
 MODULE_LICENSE("GPL");
-- 
http://palosaari.fi/

