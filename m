Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33154 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbaBAOYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/17] e4000: add manual gain controls
Date: Sat,  1 Feb 2014 16:24:18 +0200
Message-Id: <1391264674-4395-2-git-send-email-crope@iki.fi>
In-Reply-To: <1391264674-4395-1-git-send-email-crope@iki.fi>
References: <1391264674-4395-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add gain control for LNA, Mixer and IF. Expose controls via DVB
frontend .set_config callback.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 68 +++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/e4000.h      |  6 ++++
 drivers/media/tuners/e4000_priv.h | 63 ++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 0153169..651de11 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -385,6 +385,73 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+static int e4000_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct e4000_priv *priv = fe->tuner_priv;
+	struct e4000_ctrl *ctrl = priv_cfg;
+	int ret;
+	u8 buf[2];
+	u8 u8tmp;
+	dev_dbg(&priv->client->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
+			ctrl->lna_gain, ctrl->mixer_gain, ctrl->if_gain);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (ctrl->lna_gain == INT_MIN && ctrl->if_gain == INT_MIN)
+		u8tmp = 0x17;
+	else if (ctrl->lna_gain == INT_MIN)
+		u8tmp = 0x19;
+	else if (ctrl->if_gain == INT_MIN)
+		u8tmp = 0x16;
+	else
+		u8tmp = 0x10;
+
+	ret = e4000_wr_reg(priv, 0x1a, u8tmp);
+	if (ret)
+		goto err;
+
+	if (ctrl->mixer_gain == INT_MIN)
+		u8tmp = 0x15;
+	else
+		u8tmp = 0x14;
+
+	ret = e4000_wr_reg(priv, 0x20, u8tmp);
+	if (ret)
+		goto err;
+
+	if (ctrl->lna_gain != INT_MIN) {
+		ret = e4000_wr_reg(priv, 0x14, ctrl->lna_gain);
+		if (ret)
+			goto err;
+	}
+
+	if (ctrl->mixer_gain != INT_MIN) {
+		ret = e4000_wr_reg(priv, 0x15, ctrl->mixer_gain);
+		if (ret)
+			goto err;
+	}
+
+	if (ctrl->if_gain != INT_MIN) {
+		buf[0] = e4000_if_gain_lut[ctrl->if_gain].reg16_val;
+		buf[1] = e4000_if_gain_lut[ctrl->if_gain].reg17_val;
+		ret = e4000_wr_regs(priv, 0x16, buf, 2);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dev_dbg(&priv->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.info = {
 		.name           = "Elonics E4000",
@@ -395,6 +462,7 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.init = e4000_init,
 	.sleep = e4000_sleep,
 	.set_params = e4000_set_params,
+	.set_config = e4000_set_config,
 
 	.get_if_frequency = e4000_get_if_frequency,
 };
diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
index e74b8b2..d95c472 100644
--- a/drivers/media/tuners/e4000.h
+++ b/drivers/media/tuners/e4000.h
@@ -40,4 +40,10 @@ struct e4000_config {
 	u32 clock;
 };
 
+struct e4000_ctrl {
+	int lna_gain;
+	int mixer_gain;
+	int if_gain;
+};
+
 #endif
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index 8f45a30..a75a383 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -145,4 +145,67 @@ static const struct e4000_if_filter e4000_if_filter_lut[] = {
 	{ 0xffffffff, 0x00, 0x20 },
 };
 
+struct e4000_if_gain {
+	u8 reg16_val;
+	u8 reg17_val;
+};
+
+static const struct e4000_if_gain e4000_if_gain_lut[] = {
+	{0x00, 0x00},
+	{0x20, 0x00},
+	{0x40, 0x00},
+	{0x02, 0x00},
+	{0x22, 0x00},
+	{0x42, 0x00},
+	{0x04, 0x00},
+	{0x24, 0x00},
+	{0x44, 0x00},
+	{0x01, 0x00},
+	{0x21, 0x00},
+	{0x41, 0x00},
+	{0x03, 0x00},
+	{0x23, 0x00},
+	{0x43, 0x00},
+	{0x05, 0x00},
+	{0x25, 0x00},
+	{0x45, 0x00},
+	{0x07, 0x00},
+	{0x27, 0x00},
+	{0x47, 0x00},
+	{0x0f, 0x00},
+	{0x2f, 0x00},
+	{0x4f, 0x00},
+	{0x17, 0x00},
+	{0x37, 0x00},
+	{0x57, 0x00},
+	{0x1f, 0x00},
+	{0x3f, 0x00},
+	{0x5f, 0x00},
+	{0x1f, 0x01},
+	{0x3f, 0x01},
+	{0x5f, 0x01},
+	{0x1f, 0x02},
+	{0x3f, 0x02},
+	{0x5f, 0x02},
+	{0x1f, 0x03},
+	{0x3f, 0x03},
+	{0x5f, 0x03},
+	{0x1f, 0x04},
+	{0x3f, 0x04},
+	{0x5f, 0x04},
+	{0x1f, 0x0c},
+	{0x3f, 0x0c},
+	{0x5f, 0x0c},
+	{0x1f, 0x14},
+	{0x3f, 0x14},
+	{0x5f, 0x14},
+	{0x1f, 0x1c},
+	{0x3f, 0x1c},
+	{0x5f, 0x1c},
+	{0x1f, 0x24},
+	{0x3f, 0x24},
+	{0x5f, 0x24},
+	{0x7f, 0x24},
+};
+
 #endif
-- 
1.8.5.3

