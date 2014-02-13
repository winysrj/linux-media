Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33875 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaBMS6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 13:58:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] af9033: implement PID filter
Date: Thu, 13 Feb 2014 20:58:17 +0200
Message-Id: <1392317898-22040-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement PID filter and export it via symbol.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 53 ++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/af9033.h | 19 +++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 65728c2..5a1c508 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -989,6 +989,59 @@ err:
 	return ret;
 }
 
+int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct af9033_state *state = fe->demodulator_priv;
+	int ret;
+
+	dev_dbg(&state->i2c->dev, "%s: onoff=%d\n", __func__, onoff);
+
+	ret = af9033_wr_reg_mask(state, 0x80f993, onoff, 0x01);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(af9033_pid_filter_ctrl);
+
+int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid, int onoff)
+{
+	struct af9033_state *state = fe->demodulator_priv;
+	int ret;
+	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
+
+	dev_dbg(&state->i2c->dev, "%s: index=%d pid=%04x onoff=%d\n",
+			__func__, index, pid, onoff);
+
+	if (pid > 0x1fff)
+		return 0;
+
+	ret = af9033_wr_regs(state, 0x80f996, wbuf, 2);
+	if (ret < 0)
+		goto err;
+
+	ret = af9033_wr_reg(state, 0x80f994, onoff);
+	if (ret < 0)
+		goto err;
+
+	ret = af9033_wr_reg(state, 0x80f995, index);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(af9033_pid_filter);
+
 static struct dvb_frontend_ops af9033_ops;
 
 struct dvb_frontend *af9033_attach(const struct af9033_config *config,
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index c286e8f..de245f9 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -81,6 +81,11 @@ struct af9033_config {
 #if IS_ENABLED(CONFIG_DVB_AF9033)
 extern struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	struct i2c_adapter *i2c);
+
+extern int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff);
+
+extern int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
+	int onoff);
 #else
 static inline struct dvb_frontend *af9033_attach(
 	const struct af9033_config *config, struct i2c_adapter *i2c)
@@ -88,6 +93,20 @@ static inline struct dvb_frontend *af9033_attach(
 	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+
+static inline int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
+
+static inline int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
+	int onoff)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
+
 #endif
 
 #endif /* AF9033_H */
-- 
1.8.5.3

