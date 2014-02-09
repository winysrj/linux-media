Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40949 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaBIIuD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:50:03 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 42/86] r820t: add manual gain controls
Date: Sun,  9 Feb 2014 10:48:47 +0200
Message-Id: <1391935771-18670-43-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add gain control for LNA, Mixer and IF. Expose controls via DVB
frontend .set_config callback.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/r820t.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/r820t.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 319adc4..231c614 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1251,6 +1251,43 @@ static int r820t_set_gain_mode(struct r820t_priv *priv,
 }
 #endif
 
+static int r820t_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	struct r820t_ctrl *ctrl = priv_cfg;
+	int rc;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (ctrl->lna_gain == INT_MIN)
+		rc = r820t_write_reg_mask(priv, 0x05, 0x00, 0x10);
+	else
+		rc = r820t_write_reg_mask(priv, 0x05,
+				0x10 | ctrl->lna_gain, 0x1f);
+	if (rc < 0)
+		goto err;
+
+	if (ctrl->mixer_gain == INT_MIN)
+		rc = r820t_write_reg_mask(priv, 0x07, 0x10, 0x10);
+	else
+		rc = r820t_write_reg_mask(priv, 0x07,
+				0x00 | ctrl->mixer_gain, 0x1f);
+	if (rc < 0)
+		goto err;
+
+	if (ctrl->if_gain == INT_MIN)
+		rc = r820t_write_reg_mask(priv, 0x0c, 0x10, 0x10);
+	else
+		rc = r820t_write_reg_mask(priv, 0x0c,
+				0x00 | ctrl->if_gain, 0x1f);
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return rc;
+}
+
 static int generic_set_freq(struct dvb_frontend *fe,
 			    u32 freq /* in HZ */,
 			    unsigned bw,
@@ -2275,6 +2312,7 @@ static const struct dvb_tuner_ops r820t_tuner_ops = {
 	.release = r820t_release,
 	.sleep = r820t_sleep,
 	.set_params = r820t_set_params,
+	.set_config = r820t_set_config,
 	.set_analog_params = r820t_set_analog_freq,
 	.get_if_frequency = r820t_get_if_frequency,
 	.get_rf_strength = r820t_signal,
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
index 48af354..42c0d8e 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -42,6 +42,13 @@ struct r820t_config {
 	bool use_predetect;
 };
 
+/* set INT_MIN for automode */
+struct r820t_ctrl {
+	int lna_gain;
+	int mixer_gain;
+	int if_gain;
+};
+
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_R820T)
 struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 				  struct i2c_adapter *i2c,
-- 
1.8.5.3

