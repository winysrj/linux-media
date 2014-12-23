Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51091 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbaLWUua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:30 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 19/66] rtl2830: implement PID filter
Date: Tue, 23 Dec 2014 22:49:12 +0200
Message-Id: <1419367799-14263-19-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement PID filter.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 67 ++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2830.h      |  2 +
 drivers/media/dvb-frontends/rtl2830_priv.h |  1 +
 3 files changed, 70 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index f1f1cfb..8abaca6 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -723,6 +723,71 @@ err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 }
 
+static int rtl2830_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	int ret;
+	u8 u8tmp;
+
+	dev_dbg(&client->dev, "onoff=%d\n", onoff);
+
+	/* enable / disable PID filter */
+	if (onoff)
+		u8tmp = 0x80;
+	else
+		u8tmp = 0x00;
+
+	ret = rtl2830_wr_reg_mask(client, 0x061, u8tmp, 0x80);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int rtl2830_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid, int onoff)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
+	int ret;
+	u8 buf[4];
+
+	dev_dbg(&client->dev, "index=%d pid=%04x onoff=%d\n",
+		index, pid, onoff);
+
+	/* skip invalid PIDs (0x2000) */
+	if (pid > 0x1fff || index > 32)
+		return 0;
+
+	if (onoff)
+		set_bit(index, &dev->filters);
+	else
+		clear_bit(index, &dev->filters);
+
+	/* enable / disable PIDs */
+	buf[0] = (dev->filters >>  0) & 0xff;
+	buf[1] = (dev->filters >>  8) & 0xff;
+	buf[2] = (dev->filters >> 16) & 0xff;
+	buf[3] = (dev->filters >> 24) & 0xff;
+	ret = rtl2830_wr_regs(client, 0x062, buf, 4);
+	if (ret)
+		goto err;
+
+	/* add PID */
+	buf[0] = (pid >> 8) & 0xff;
+	buf[1] = (pid >> 0) & 0xff;
+	ret = rtl2830_wr_regs(client, 0x066 + 2 * index, buf, 2);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
 /*
  * I2C gate/repeater logic
  * We must use unlocked i2c_transfer() here because I2C lock is already taken
@@ -843,6 +908,8 @@ static int rtl2830_probe(struct i2c_client *client,
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2830_get_dvb_frontend;
 	pdata->get_i2c_adapter = rtl2830_get_i2c_adapter;
+	pdata->pid_filter = rtl2830_pid_filter;
+	pdata->pid_filter_ctrl = rtl2830_pid_filter_ctrl;
 
 	dev_info(&client->dev, "Realtek RTL2830 successfully attached\n");
 
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index 61f784c..156edf7 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -49,6 +49,8 @@ struct rtl2830_platform_data {
 	 */
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
+	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
+	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
 };
 
 #endif /* RTL2830_H */
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 6a0e982..2931889 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -31,6 +31,7 @@ struct rtl2830_dev {
 	struct dvb_frontend fe;
 	bool sleeping;
 	u8 page; /* active register page */
+	unsigned long filters;
 	struct delayed_work stat_work;
 	fe_status_t fe_status;
 	u64 post_bit_error_prev; /* for old DVBv3 read_ber() calculation */
-- 
http://palosaari.fi/

