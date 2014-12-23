Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45248 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbaLWUu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/66] rtl2830: get rid of internal config data
Date: Tue, 23 Dec 2014 22:49:04 +0200
Message-Id: <1419367799-14263-11-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove internal config and use configuration values directly from
the platform data.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 43 ++++++++++++------------------
 drivers/media/dvb-frontends/rtl2830_priv.h | 15 +----------
 2 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index fa73575..ea68c7e 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -33,12 +33,11 @@
 /* write multiple hardware registers */
 static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 {
-	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -54,7 +53,7 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(dev->i2c, msg, 1);
+	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
@@ -68,23 +67,22 @@ static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 /* read multiple hardware registers */
 static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
 {
-	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct i2c_msg msg[2] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val,
 		}
 	};
 
-	ret = i2c_transfer(dev->i2c, msg, 2);
+	ret = i2c_transfer(client->adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
@@ -207,10 +205,10 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		{ 0x2f1, 0x20, 0xf8 },
 		{ 0x16d, 0x00, 0x01 },
 		{ 0x1a6, 0x00, 0x80 },
-		{ 0x106, dev->cfg.vtop, 0x3f },
-		{ 0x107, dev->cfg.krf, 0x3f },
+		{ 0x106, dev->pdata->vtop, 0x3f },
+		{ 0x107, dev->pdata->krf, 0x3f },
 		{ 0x112, 0x28, 0xff },
-		{ 0x103, dev->cfg.agc_targ_val, 0xff },
+		{ 0x103, dev->pdata->agc_targ_val, 0xff },
 		{ 0x00a, 0x02, 0x07 },
 		{ 0x140, 0x0c, 0x3c },
 		{ 0x140, 0x40, 0xc0 },
@@ -218,7 +216,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		{ 0x15b, 0x28, 0x38 },
 		{ 0x15c, 0x05, 0x07 },
 		{ 0x15c, 0x28, 0x38 },
-		{ 0x115, dev->cfg.spec_inv, 0x01 },
+		{ 0x115, dev->pdata->spec_inv, 0x01 },
 		{ 0x16f, 0x01, 0x07 },
 		{ 0x170, 0x18, 0x38 },
 		{ 0x172, 0x0f, 0x0f },
@@ -349,9 +347,9 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	num = if_frequency % dev->cfg.xtal;
+	num = if_frequency % dev->pdata->clk;
 	num *= 0x400000;
-	num = div_u64(num, dev->cfg.xtal);
+	num = div_u64(num, dev->pdata->clk);
 	num = -num;
 	if_ctl = num & 0x3fffff;
 	dev_dbg(&client->dev, "if_frequency=%d if_ctl=%08x\n",
@@ -506,7 +504,7 @@ err:
 static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 tmp;
 	*status = 0;
@@ -688,7 +686,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	struct i2c_msg select_reg_page_msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 2,
 			.buf = "\x00\x01",
@@ -696,7 +694,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	};
 	struct i2c_msg gate_open_msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 2,
 			.buf = "\x01\x08",
@@ -705,7 +703,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	int ret;
 
 	/* select register page */
-	ret = __i2c_transfer(adap, select_reg_page_msg, 1);
+	ret = __i2c_transfer(client->adapter, select_reg_page_msg, 1);
 	if (ret != 1) {
 		dev_warn(&client->dev, "i2c write failed %d\n", ret);
 		if (ret >= 0)
@@ -716,7 +714,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	dev->page = 1;
 
 	/* open tuner I2C repeater for 1 xfer, closes automatically */
-	ret = __i2c_transfer(adap, gate_open_msg, 1);
+	ret = __i2c_transfer(client->adapter, gate_open_msg, 1);
 	if (ret != 1) {
 		dev_warn(&client->dev, "i2c write failed %d\n", ret);
 		if (ret >= 0)
@@ -753,7 +751,6 @@ static int rtl2830_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
 	struct rtl2830_platform_data *pdata = client->dev.platform_data;
-	struct i2c_adapter *i2c = client->adapter;
 	struct rtl2830_dev *dev;
 	int ret;
 	u8 u8tmp;
@@ -774,14 +771,8 @@ static int rtl2830_probe(struct i2c_client *client,
 
 	/* setup the state */
 	i2c_set_clientdata(client, dev);
-	dev->i2c = i2c;
+	dev->pdata = client->dev.platform_data;
 	dev->sleeping = true;
-	dev->cfg.i2c_addr = client->addr;
-	dev->cfg.xtal = pdata->clk;
-	dev->cfg.spec_inv = pdata->spec_inv;
-	dev->cfg.vtop = pdata->vtop;
-	dev->cfg.krf = pdata->krf;
-	dev->cfg.agc_targ_val = pdata->agc_targ_val;
 
 	/* check if the demod is there */
 	ret = rtl2830_rd_reg(client, 0x000, &u8tmp);
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 9e7bd42..5276fb2 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -26,24 +26,11 @@
 #include "rtl2830.h"
 #include <linux/i2c-mux.h>
 
-struct rtl2830_config {
-	u8 i2c_addr;
-	u32 xtal;
-	bool spec_inv;
-	u8 vtop;
-	u8 krf;
-	u8 agc_targ_val;
-};
-
 struct rtl2830_dev {
+	struct rtl2830_platform_data *pdata;
 	struct i2c_adapter *adapter;
-	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
-	struct rtl2830_config cfg;
-	struct i2c_adapter tuner_i2c_adapter;
-
 	bool sleeping;
-
 	u8 page; /* active register page */
 };
 
-- 
http://palosaari.fi/

