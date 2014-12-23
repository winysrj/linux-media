Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51009 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 28/66] rtl2832: move all configuration to platform data struct
Date: Tue, 23 Dec 2014 22:49:21 +0200
Message-Id: <1419367799-14263-28-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move all needed configuration values to platform data structure
and remove old configuration code where possible.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 48 +++++++++++++++---------------
 drivers/media/dvb-frontends/rtl2832.h      | 20 +++++++++++++
 drivers/media/dvb-frontends/rtl2832_priv.h |  4 +--
 3 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 943446d..907d8e8 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -164,7 +164,7 @@ static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -198,12 +198,12 @@ static int rtl2832_rd(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
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
@@ -399,9 +399,9 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 	*		/ CrystalFreqHz)
 	*/
 
-	pset_iffreq = if_freq % dev->cfg.xtal;
+	pset_iffreq = if_freq % dev->pdata->clk;
 	pset_iffreq *= 0x400000;
-	pset_iffreq = div_u64(pset_iffreq, dev->cfg.xtal);
+	pset_iffreq = div_u64(pset_iffreq, dev->pdata->clk);
 	pset_iffreq = -pset_iffreq;
 	pset_iffreq = pset_iffreq & 0x3fffff;
 	dev_dbg(&client->dev, "if_frequency=%d pset_iffreq=%08x\n",
@@ -478,8 +478,9 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	dev_dbg(&client->dev, "load settings for tuner=%02x\n", dev->cfg.tuner);
-	switch (dev->cfg.tuner) {
+	dev_dbg(&client->dev, "load settings for tuner=%02x\n",
+		dev->pdata->tuner);
+	switch (dev->pdata->tuner) {
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
 		len = ARRAY_SIZE(rtl2832_tuner_init_fc0012);
@@ -647,7 +648,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	* RSAMP_RATIO = floor(CrystalFreqHz * 7 * pow(2, 22)
 	*	/ ConstWithBandwidthMode)
 	*/
-	num = dev->cfg.xtal * 7;
+	num = dev->pdata->clk * 7;
 	num *= 0x400000;
 	num = div_u64(num, bw_mode);
 	resamp_ratio =  num & 0x3ffffff;
@@ -660,7 +661,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	*	/ (CrystalFreqHz * 7))
 	*/
 	num = bw_mode << 20;
-	num2 = dev->cfg.xtal * 7;
+	num2 = dev->pdata->clk * 7;
 	num = div_u64(num, num2);
 	num = -num;
 	cfreq_off_ratio = num & 0xfffff;
@@ -907,12 +908,11 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	struct rtl2832_dev *dev = container_of(work,
 			struct rtl2832_dev, i2c_gate_work.work);
 	struct i2c_client *client = dev->client;
-	struct i2c_adapter *adap = dev->i2c;
 	int ret;
 	u8 buf[2];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -924,7 +924,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	/* select reg bank 1 */
 	buf[0] = 0x00;
 	buf[1] = 0x01;
-	ret = __i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1)
 		goto err;
 
@@ -933,7 +933,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	/* close I2C repeater gate */
 	buf[0] = 0x01;
 	buf[1] = 0x10;
-	ret = __i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1)
 		goto err;
 
@@ -953,7 +953,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	u8 buf[2], val;
 	struct i2c_msg msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -961,12 +961,12 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	};
 	struct i2c_msg msg_rd[2] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = "\x01",
 		}, {
-			.addr = dev->cfg.i2c_addr,
+			.addr = client->addr,
 			.flags = I2C_M_RD,
 			.len = 1,
 			.buf = &val,
@@ -982,14 +982,14 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	/* select reg bank 1 */
 	buf[0] = 0x00;
 	buf[1] = 0x01;
-	ret = __i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1)
 		goto err;
 
 	dev->page = 1;
 
 	/* we must read that register, otherwise there will be errors */
-	ret = __i2c_transfer(adap, msg_rd, 2);
+	ret = __i2c_transfer(client->adapter, msg_rd, 2);
 	if (ret != 2)
 		goto err;
 
@@ -1000,7 +1000,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	else
 		buf[1] = 0x10; /* close */
 
-	ret = __i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1)
 		goto err;
 
@@ -1138,7 +1138,6 @@ static int rtl2832_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
 	struct rtl2832_platform_data *pdata = client->dev.platform_data;
-	const struct rtl2832_config *config = pdata->config;
 	struct i2c_adapter *i2c = client->adapter;
 	struct rtl2832_dev *dev;
 	int ret;
@@ -1160,12 +1159,13 @@ static int rtl2832_probe(struct i2c_client *client,
 
 	/* setup the state */
 	dev->client = client;
-	dev->i2c = i2c;
-	dev->tuner = config->tuner;
+	dev->pdata = client->dev.platform_data;
+	if (pdata->config) {
+		dev->pdata->clk = pdata->config->xtal;
+		dev->pdata->tuner = pdata->config->tuner;
+	}
 	dev->sleeping = true;
-	memcpy(&dev->cfg, config, sizeof(struct rtl2832_config));
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
-
 	/* create muxed i2c adapter for demod itself */
 	dev->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, dev, 0, 0, 0,
 			rtl2832_select, NULL);
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 983d5a1..35e86e6 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -53,6 +53,26 @@ struct rtl2832_platform_data {
 	const struct rtl2832_config *config;
 
 	/*
+	 * Clock frequency.
+	 * Hz
+	 * 4000000, 16000000, 25000000, 28800000
+	 */
+	u32 clk;
+
+	/*
+	 * Tuner.
+	 * XXX: This must be keep sync with dvb_usb_rtl28xxu USB IF driver.
+	 */
+#define RTL2832_TUNER_TUA9001   0x24
+#define RTL2832_TUNER_FC0012    0x26
+#define RTL2832_TUNER_E4000     0x27
+#define RTL2832_TUNER_FC0013    0x29
+#define RTL2832_TUNER_R820T     0x2a
+#define RTL2832_TUNER_R828D     0x2b
+	u8 tuner;
+
+	/*
+	 * Callbacks.
 	 */
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 58feb27..8995332 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -26,17 +26,15 @@
 #include <linux/i2c-mux.h>
 
 struct rtl2832_dev {
+	struct rtl2832_platform_data *pdata;
 	struct i2c_client *client;
-	struct i2c_adapter *i2c;
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
-	struct rtl2832_config cfg;
 
 	bool i2c_gate_state;
 	bool sleeping;
 
-	u8 tuner;
 	u8 page; /* active register page */
 	struct delayed_work i2c_gate_work;
 };
-- 
http://palosaari.fi/

