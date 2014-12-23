Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58714 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaLWVAL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:00:11 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 51/66] rtl2832: cleanups and minor changes
Date: Tue, 23 Dec 2014 22:49:44 +0200
Message-Id: <1419367799-14263-51-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove all the stuff that is not needed anymore. Rename variable.
Remove extra new lines.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 72 ++++++++----------------------
 drivers/media/dvb-frontends/rtl2832.h      | 32 +------------
 drivers/media/dvb-frontends/rtl2832_priv.h |  9 ++--
 3 files changed, 25 insertions(+), 88 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 649d333..a552b4b 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -19,8 +19,6 @@
  */
 
 #include "rtl2832_priv.h"
-#include "dvb_math.h"
-#include <linux/bitops.h>
 
 #define REG_MASK(b) (BIT(b + 1) - 1)
 
@@ -194,21 +192,14 @@ int rtl2832_bulk_read(struct i2c_client *client, unsigned int reg, void *val,
 static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 {
 	struct i2c_client *client = dev->client;
-	int ret;
-
+	int ret, i;
 	u16 reg_start_addr;
-	u8 msb, lsb;
-	u8 reading[4];
-	u32 reading_tmp;
-	int i;
-
-	u8 len;
-	u32 mask;
+	u8 msb, lsb, reading[4], len;
+	u32 reading_tmp, mask;
 
 	reg_start_addr = registers[reg].start_address;
 	msb = registers[reg].msb;
 	lsb = registers[reg].lsb;
-
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
@@ -222,38 +213,26 @@ static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 
 	*val = (reading_tmp >> lsb) & mask;
 
-	return ret;
-
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
-
 }
 
 static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 {
 	struct i2c_client *client = dev->client;
 	int ret, i;
-	u8 len;
 	u16 reg_start_addr;
-	u8 msb, lsb;
-	u32 mask;
-
-
-	u8 reading[4];
-	u8 writing[4];
-	u32 reading_tmp;
-	u32 writing_tmp;
-
+	u8 msb, lsb, reading[4], writing[4], len;
+	u32 reading_tmp, writing_tmp, mask;
 
 	reg_start_addr = registers[reg].start_address;
 	msb = registers[reg].msb;
 	lsb = registers[reg].lsb;
-
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-
 	ret = rtl2832_bulk_read(client, reg_start_addr, reading, len);
 	if (ret)
 		goto err;
@@ -265,7 +244,6 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	writing_tmp = reading_tmp & ~(mask << lsb);
 	writing_tmp |= ((val & mask) << lsb);
 
-
 	for (i = 0; i < len; i++)
 		writing[i] = (writing_tmp >> ((len - 1 - i) * 8)) & 0xff;
 
@@ -273,12 +251,10 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	if (ret)
 		goto err;
 
-	return ret;
-
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
-
 }
 
 static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
@@ -293,7 +269,6 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 	* PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22)
 	*		/ CrystalFreqHz)
 	*/
-
 	pset_iffreq = if_freq % dev->pdata->clk;
 	pset_iffreq *= 0x400000;
 	pset_iffreq = div_u64(pset_iffreq, dev->pdata->clk);
@@ -304,10 +279,15 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 
 	ret = rtl2832_wr_demod_reg(dev, DVBT_EN_BBIN, en_bbin);
 	if (ret)
-		return ret;
+		goto err;
 
 	ret = rtl2832_wr_demod_reg(dev, DVBT_PSET_IFFREQ, pset_iffreq);
+	if (ret)
+		goto err;
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -419,7 +399,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 	dev->sleeping = false;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -485,7 +465,6 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		},
 	};
 
-
 	dev_dbg(&client->dev, "frequency=%u bandwidth_hz=%u inversion=%u\n",
 		c->frequency, c->bandwidth_hz, c->inversion);
 
@@ -571,7 +550,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -716,7 +695,7 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	}
 
 	dev->fe_status = *status;
-	return ret;
+	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -866,7 +845,6 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	return;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return;
 }
 
 static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
@@ -1052,7 +1030,7 @@ static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
 	return &dev->fe;
 }
 
-static struct i2c_adapter *rtl2832_get_i2c_adapter_(struct i2c_client *client)
+static struct i2c_adapter *rtl2832_get_i2c_adapter(struct i2c_client *client)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 
@@ -1060,14 +1038,6 @@ static struct i2c_adapter *rtl2832_get_i2c_adapter_(struct i2c_client *client)
 	return dev->i2c_adapter_tuner;
 }
 
-static struct i2c_adapter *rtl2832_get_private_i2c_adapter_(struct i2c_client *client)
-{
-	struct rtl2832_dev *dev = i2c_get_clientdata(client);
-
-	dev_dbg(&client->dev, "\n");
-	return dev->i2c_adapter;
-}
-
 static int rtl2832_enable_slave_ts(struct i2c_client *client)
 {
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
@@ -1238,10 +1208,6 @@ static int rtl2832_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, dev);
 	dev->client = client;
 	dev->pdata = client->dev.platform_data;
-	if (pdata->config) {
-		dev->pdata->clk = pdata->config->xtal;
-		dev->pdata->tuner = pdata->config->tuner;
-	}
 	dev->sleeping = true;
 	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
 	INIT_DELAYED_WORK(&dev->stat_work, rtl2832_stat_work);
@@ -1279,8 +1245,7 @@ static int rtl2832_probe(struct i2c_client *client,
 
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2832_get_dvb_frontend;
-	pdata->get_i2c_adapter = rtl2832_get_i2c_adapter_;
-	pdata->get_private_i2c_adapter = rtl2832_get_private_i2c_adapter_;
+	pdata->get_i2c_adapter = rtl2832_get_i2c_adapter;
 	pdata->enable_slave_ts = rtl2832_enable_slave_ts;
 	pdata->pid_filter = rtl2832_pid_filter;
 	pdata->pid_filter_ctrl = rtl2832_pid_filter_ctrl;
@@ -1341,4 +1306,3 @@ module_i2c_driver(rtl2832_driver);
 MODULE_AUTHOR("Thomas Mair <mair.thomas86@gmail.com>");
 MODULE_DESCRIPTION("Realtek RTL2832 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.5");
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index f86af6f..73e2717 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -22,36 +22,9 @@
 #define RTL2832_H
 
 #include <linux/dvb/frontend.h>
-
-struct rtl2832_config {
-	/*
-	 * Demodulator I2C address.
-	 */
-	u8 i2c_addr;
-
-	/*
-	 * Xtal frequency.
-	 * Hz
-	 * 4000000, 16000000, 25000000, 28800000
-	 */
-	u32 xtal;
-
-	/*
-	 * tuner
-	 * XXX: This must be keep sync with dvb_usb_rtl28xxu demod driver.
-	 */
-#define RTL2832_TUNER_TUA9001   0x24
-#define RTL2832_TUNER_FC0012    0x26
-#define RTL2832_TUNER_E4000     0x27
-#define RTL2832_TUNER_FC0013    0x29
-#define RTL2832_TUNER_R820T	0x2a
-#define RTL2832_TUNER_R828D	0x2b
-	u8 tuner;
-};
+#include <linux/i2c-mux.h>
 
 struct rtl2832_platform_data {
-	const struct rtl2832_config *config;
-
 	/*
 	 * Clock frequency.
 	 * Hz
@@ -61,7 +34,7 @@ struct rtl2832_platform_data {
 
 	/*
 	 * Tuner.
-	 * XXX: This must be keep sync with dvb_usb_rtl28xxu USB IF driver.
+	 * XXX: This list must be kept sync with dvb_usb_rtl28xxu USB IF driver.
 	 */
 #define RTL2832_TUNER_TUA9001   0x24
 #define RTL2832_TUNER_FC0012    0x26
@@ -76,7 +49,6 @@ struct rtl2832_platform_data {
 	 */
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
-	struct i2c_adapter* (*get_private_i2c_adapter)(struct i2c_client *);
 	int (*enable_slave_ts)(struct i2c_client *);
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 973892a..9edab5d 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -21,11 +21,13 @@
 #ifndef RTL2832_PRIV_H
 #define RTL2832_PRIV_H
 
-#include "dvb_frontend.h"
-#include "rtl2832.h"
-#include <linux/i2c-mux.h>
 #include <linux/regmap.h>
 #include <linux/math64.h>
+#include <linux/bitops.h>
+
+#include "dvb_frontend.h"
+#include "dvb_math.h"
+#include "rtl2832.h"
 
 struct rtl2832_dev {
 	struct rtl2832_platform_data *pdata;
@@ -55,7 +57,6 @@ struct rtl2832_reg_value {
 	u32 value;
 };
 
-
 /* Demod register bit names */
 enum DVBT_REG_BIT_NAME {
 	DVBT_SOFT_RST,
-- 
http://palosaari.fi/

