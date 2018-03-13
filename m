Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:51637 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932777AbeCMXkO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/18] af9013: add pid filter support
Date: Wed, 14 Mar 2018 01:39:37 +0200
Message-Id: <20180313233944.7234-11-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9013 demod has pid filter. Add support for it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 52 ++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/af9013.h |  5 ++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 15af3e9482df..482bce49819a 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -1171,6 +1171,56 @@ static const struct dvb_frontend_ops af9013_ops = {
 	.read_ucblocks = af9013_read_ucblocks,
 };
 
+static int af9013_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
+	int ret;
+
+	dev_dbg(&client->dev, "onoff %d\n", onoff);
+
+	ret = regmap_update_bits(state->regmap, 0xd503, 0x01, onoff);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9013_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
+			     int onoff)
+{
+	struct af9013_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
+	int ret;
+	u8 buf[2];
+
+	dev_dbg(&client->dev, "index %d, pid %04x, onoff %d\n",
+		index, pid, onoff);
+
+	if (pid > 0x1fff) {
+		/* 0x2000 is kernel virtual pid for whole ts (all pids) */
+		ret = 0;
+		goto err;
+	}
+
+	buf[0] = (pid >> 0) & 0xff;
+	buf[1] = (pid >> 8) & 0xff;
+	ret = regmap_bulk_write(state->regmap, 0xd505, buf, 2);
+	if (ret)
+		goto err;
+	ret = regmap_write(state->regmap, 0xd504, onoff << 5 | index << 0);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
+}
+
 static struct dvb_frontend *af9013_get_dvb_frontend(struct i2c_client *client)
 {
 	struct af9013_state *state = i2c_get_clientdata(client);
@@ -1473,6 +1523,8 @@ static int af9013_probe(struct i2c_client *client,
 	/* Setup callbacks */
 	pdata->get_dvb_frontend = af9013_get_dvb_frontend;
 	pdata->get_i2c_adapter = af9013_get_i2c_adapter;
+	pdata->pid_filter = af9013_pid_filter;
+	pdata->pid_filter_ctrl = af9013_pid_filter_ctrl;
 
 	/* Init stats to indicate which stats are supported */
 	c = &state->fe.dtv_property_cache;
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index 8144d4270b58..165ae29ccac4 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -38,6 +38,9 @@
  * @api_version: Firmware API version.
  * @gpio: GPIOs.
  * @get_dvb_frontend: Get DVB frontend callback.
+ * @get_i2c_adapter: Get I2C adapter.
+ * @pid_filter_ctrl: Control PID filter.
+ * @pid_filter: Set PID to PID filter.
  */
 struct af9013_platform_data {
 	/*
@@ -78,6 +81,8 @@ struct af9013_platform_data {
 
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
+	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
+	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 };
 
 /*
-- 
2.14.3
