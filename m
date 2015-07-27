Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57528 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbbG0LWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:22:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/6] mt2060: add param to split long i2c writes
Date: Mon, 27 Jul 2015 14:22:06 +0300
Message-Id: <1437996130-23735-3-git-send-email-crope@iki.fi>
In-Reply-To: <1437996130-23735-1-git-send-email-crope@iki.fi>
References: <1437996130-23735-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add configuration parameter to split long i2c writes as some I2C
adapters cannot write 10 bytes used as a one go.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/mt2060.c      | 21 +++++++++++++++++----
 drivers/media/tuners/mt2060.h      |  3 +++
 drivers/media/tuners/mt2060_priv.h |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index aa8280a..207fd6b 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -71,13 +71,24 @@ static int mt2060_writereg(struct mt2060_priv *priv, u8 reg, u8 val)
 // Writes a set of consecutive registers
 static int mt2060_writeregs(struct mt2060_priv *priv,u8 *buf, u8 len)
 {
+	int remain, val_len;
+	u8 xfer_buf[16];
 	struct i2c_msg msg = {
-		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = len
+		.addr = priv->cfg->i2c_address, .flags = 0, .buf = xfer_buf
 	};
-	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
-		printk(KERN_WARNING "mt2060 I2C write failed (len=%i)\n",(int)len);
-		return -EREMOTEIO;
+
+	for (remain = len - 1; remain > 0; remain -= priv->i2c_max_regs) {
+		val_len = min_t(int, remain, priv->i2c_max_regs);
+		msg.len = 1 + val_len;
+		xfer_buf[0] = buf[0] + len - 1 - remain;
+		memcpy(&xfer_buf[1], &buf[1 + len - 1 - remain], val_len);
+
+		if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
+			printk(KERN_WARNING "mt2060 I2C write failed (len=%i)\n", val_len);
+			return -EREMOTEIO;
+		}
 	}
+
 	return 0;
 }
 
@@ -370,6 +381,7 @@ struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter
 	priv->cfg      = cfg;
 	priv->i2c      = i2c;
 	priv->if1_freq = if1;
+	priv->i2c_max_regs = ~0;
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
@@ -427,6 +439,7 @@ static int mt2060_probe(struct i2c_client *client,
 	dev->i2c = client->adapter;
 	dev->if1_freq = pdata->if1 ? pdata->if1 : 1220;
 	dev->client = client;
+	dev->i2c_max_regs = pdata->i2c_wr_max ? pdata->i2c_wr_max - 1 : ~0;
 
 	ret = mt2060_readreg(dev, REG_PART_REV, &chip_id);
 	if (ret) {
diff --git a/drivers/media/tuners/mt2060.h b/drivers/media/tuners/mt2060.h
index 05c0d55..21b7f91 100644
--- a/drivers/media/tuners/mt2060.h
+++ b/drivers/media/tuners/mt2060.h
@@ -34,12 +34,15 @@ struct i2c_adapter;
  * struct mt2060_platform_data - Platform data for the mt2060 driver
  * @clock_out: Clock output setting. 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1.
  * @if1: First IF used [MHz]. 0 defaults to 1220.
+ * @i2c_wr_max: Maximum number of bytes I2C adapter can write at once.
+ *  0 defaults to maximum.
  * @dvb_frontend: DVB frontend.
  */
 
 struct mt2060_platform_data {
 	u8 clock_out;
 	u16 if1;
+	unsigned int i2c_wr_max:5;
 	struct dvb_frontend *dvb_frontend;
 };
 
diff --git a/drivers/media/tuners/mt2060_priv.h b/drivers/media/tuners/mt2060_priv.h
index dfc4a06..f0fdb83 100644
--- a/drivers/media/tuners/mt2060_priv.h
+++ b/drivers/media/tuners/mt2060_priv.h
@@ -98,6 +98,7 @@ struct mt2060_priv {
 	struct i2c_client *client;
 	struct mt2060_config config;
 
+	u8 i2c_max_regs;
 	u32 frequency;
 	u16 if1_freq;
 	u8  fmfreq;
-- 
http://palosaari.fi/

