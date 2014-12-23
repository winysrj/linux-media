Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39175 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbaLWUud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 39/66] rtl2832: implement PID filter
Date: Tue, 23 Dec 2014 22:49:32 +0200
Message-Id: <1419367799-14263-39-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement PID filter. This demod has PID filter size of 32 PIDs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 69 ++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2832.h      |  2 +
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 3 files changed, 72 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index b80e1c0..b8e7971 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1145,6 +1145,73 @@ err:
 	return ret;
 }
 
+static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
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
+	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
+			      int onoff)
+{
+	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
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
+	ret = rtl2832_bulk_write(client, 0x062, buf, 4);
+	if (ret)
+		goto err;
+
+	/* add PID */
+	buf[0] = (pid >> 8) & 0xff;
+	buf[1] = (pid >> 0) & 0xff;
+	ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
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
@@ -1240,6 +1307,8 @@ static int rtl2832_probe(struct i2c_client *client,
 	pdata->get_i2c_adapter = rtl2832_get_i2c_adapter_;
 	pdata->get_private_i2c_adapter = rtl2832_get_private_i2c_adapter_;
 	pdata->enable_slave_ts = rtl2832_enable_slave_ts;
+	pdata->pid_filter = rtl2832_pid_filter;
+	pdata->pid_filter_ctrl = rtl2832_pid_filter_ctrl;
 
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 35e86e6..e79c479 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -78,6 +78,8 @@ struct rtl2832_platform_data {
 	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
 	struct i2c_adapter* (*get_private_i2c_adapter)(struct i2c_client *);
 	int (*enable_slave_ts)(struct i2c_client *);
+	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
+	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
 };
 
 #endif /* RTL2832_H */
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 6f3fe77..216e905 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -41,6 +41,7 @@ struct rtl2832_dev {
 	u64 post_bit_count;
 	bool sleeping;
 	struct delayed_work i2c_gate_work;
+	unsigned long filters; /* PID filter */
 };
 
 struct rtl2832_reg_entry {
-- 
http://palosaari.fi/

