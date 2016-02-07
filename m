Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48419 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbcBGTzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 14:55:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] rtl2832: improve slave TS control
Date: Sun,  7 Feb 2016 21:54:49 +0200
Message-Id: <1454874890-10724-4-git-send-email-crope@iki.fi>
In-Reply-To: <1454874890-10724-1-git-send-email-crope@iki.fi>
References: <1454874890-10724-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add callback parameter to select enable / disable slave TS and use
it when slave demod is in use.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c   | 72 ++++++++++++++++++---------------
 drivers/media/dvb-frontends/rtl2832.h   |  4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 24 +++++------
 3 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 10f2119..a9b2646 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -347,6 +347,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
+	if (ret)
+		goto err;
+
 	for (i = 0; i < ARRAY_SIZE(rtl2832_initial_regs); i++) {
 		ret = rtl2832_wr_demod_reg(dev, rtl2832_initial_regs[i].reg,
 			rtl2832_initial_regs[i].value);
@@ -491,11 +495,6 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
-	/* PIP mode related */
-	ret = rtl2832_bulk_write(client, 0x192, "\x00\x0f\xff", 3);
-	if (ret)
-		goto err;
-
 	/* If the frontend has get_if_frequency(), use it */
 	if (fe->ops.tuner_ops.get_if_frequency) {
 		u32 if_freq;
@@ -1081,37 +1080,46 @@ static struct i2c_adapter *rtl2832_get_i2c_adapter(struct i2c_client *client)
 	return dev->i2c_adapter_tuner;
 }
 
-static int rtl2832_enable_slave_ts(struct i2c_client *client)
+static int rtl2832_slave_ts_ctrl(struct i2c_client *client, bool enable)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	dev_dbg(&client->dev, "\n");
-
-	ret = rtl2832_bulk_write(client, 0x10c, "\x5f\xff", 2);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_demod_reg(dev, DVBT_PIP_ON, 0x1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_bulk_write(client, 0x0bc, "\x18", 1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_bulk_write(client, 0x192, "\x7f\xf7\xff", 3);
-	if (ret)
-		goto err;
-
-	/* soft reset */
-	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
-	if (ret)
-		goto err;
+	dev_dbg(&client->dev, "enable=%d\n", enable);
 
-	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
-	if (ret)
-		goto err;
+	if (enable) {
+		ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
+		if (ret)
+			goto err;
+		ret = rtl2832_bulk_write(client, 0x10c, "\x5f\xff", 2);
+		if (ret)
+			goto err;
+		ret = rtl2832_wr_demod_reg(dev, DVBT_PIP_ON, 0x1);
+		if (ret)
+			goto err;
+		ret = rtl2832_bulk_write(client, 0x0bc, "\x18", 1);
+		if (ret)
+			goto err;
+		ret = rtl2832_bulk_write(client, 0x192, "\x7f\xf7\xff", 3);
+		if (ret)
+			goto err;
+	} else {
+		ret = rtl2832_bulk_write(client, 0x192, "\x00\x0f\xff", 3);
+		if (ret)
+			goto err;
+		ret = rtl2832_bulk_write(client, 0x0bc, "\x08", 1);
+		if (ret)
+			goto err;
+		ret = rtl2832_wr_demod_reg(dev, DVBT_PIP_ON, 0x0);
+		if (ret)
+			goto err;
+		ret = rtl2832_bulk_write(client, 0x10c, "\x00\x00", 2);
+		if (ret)
+			goto err;
+		ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 err:
@@ -1267,7 +1275,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2832_get_dvb_frontend;
 	pdata->get_i2c_adapter = rtl2832_get_i2c_adapter;
-	pdata->enable_slave_ts = rtl2832_enable_slave_ts;
+	pdata->slave_ts_ctrl = rtl2832_slave_ts_ctrl;
 	pdata->pid_filter = rtl2832_pid_filter;
 	pdata->pid_filter_ctrl = rtl2832_pid_filter_ctrl;
 	pdata->bulk_read = rtl2832_bulk_read;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index c29a4c2..6390af6 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -31,7 +31,7 @@
  * @tuner: Used tuner model.
  * @get_dvb_frontend: Get DVB frontend.
  * @get_i2c_adapter: Get I2C adapter.
- * @enable_slave_ts: Enable slave TS IF.
+ * @slave_ts_ctrl: Control slave TS interface.
  * @pid_filter: Set PID to PID filter.
  * @pid_filter_ctrl: Control PID filter.
  */
@@ -53,7 +53,7 @@ struct rtl2832_platform_data {
 
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
-	int (*enable_slave_ts)(struct i2c_client *);
+	int (*slave_ts_ctrl)(struct i2c_client *, bool);
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
 /* private: Register access for SDR module use only */
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c4c6e92..fa72642 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1571,19 +1571,19 @@ static int rtl28xxu_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 	if (dev->chip_id == CHIP_ID_RTL2831U)
 		return 0;
 
-	/* control internal demod ADC */
-	if (fe->id == 0 && onoff)
-		val = 0x48; /* enable ADC */
-	else
-		val = 0x00; /* disable ADC */
-
-	ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL, val, 0x48);
-	if (ret)
-		goto err;
+	if (fe->id == 0) {
+		/* control internal demod ADC */
+		if (onoff)
+			val = 0x48; /* enable ADC */
+		else
+			val = 0x00; /* disable ADC */
 
-	/* bypass slave demod TS through master demod */
-	if (fe->id == 1 && onoff) {
-		ret = pdata->enable_slave_ts(dev->i2c_client_demod);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL, val, 0x48);
+		if (ret)
+			goto err;
+	} else if (fe->id == 1) {
+		/* bypass slave demod TS through master demod */
+		ret = pdata->slave_ts_ctrl(dev->i2c_client_demod, onoff);
 		if (ret)
 			goto err;
 	}
-- 
http://palosaari.fi/

