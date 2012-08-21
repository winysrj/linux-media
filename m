Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46684 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2HUX5F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 19:57:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 3/5] rtl2832: implement .get_frontend()
Date: Wed, 22 Aug 2012 02:56:20 +0300
Message-Id: <1345593382-11367-3-git-send-email-crope@iki.fi>
In-Reply-To: <1345593382-11367-1-git-send-email-crope@iki.fi>
References: <1345593382-11367-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copied from rtl2830.

Cc: Thomas Mair <thomas.mair86@googlemail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 113 ++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 18e1ae3..6e28444 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -636,6 +636,118 @@ err:
 	return ret;
 }
 
+static int rtl2832_get_frontend(struct dvb_frontend *fe)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u8 buf[3];
+
+	if (priv->sleeping)
+		return 0;
+
+	ret = rtl2832_rd_regs(priv, 0x3c, 3, buf, 2);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_rd_reg(priv, 0x51, 3, &buf[2]);
+	if (ret)
+		goto err;
+
+	dbg("%s: TPS=%*ph", __func__, 3, buf);
+
+	switch ((buf[0] >> 2) & 3) {
+	case 0:
+		c->modulation = QPSK;
+		break;
+	case 1:
+		c->modulation = QAM_16;
+		break;
+	case 2:
+		c->modulation = QAM_64;
+		break;
+	}
+
+	switch ((buf[2] >> 2) & 1) {
+	case 0:
+		c->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case 1:
+		c->transmission_mode = TRANSMISSION_MODE_8K;
+	}
+
+	switch ((buf[2] >> 0) & 3) {
+	case 0:
+		c->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case 1:
+		c->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case 2:
+		c->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case 3:
+		c->guard_interval = GUARD_INTERVAL_1_4;
+		break;
+	}
+
+	switch ((buf[0] >> 4) & 7) {
+	case 0:
+		c->hierarchy = HIERARCHY_NONE;
+		break;
+	case 1:
+		c->hierarchy = HIERARCHY_1;
+		break;
+	case 2:
+		c->hierarchy = HIERARCHY_2;
+		break;
+	case 3:
+		c->hierarchy = HIERARCHY_4;
+		break;
+	}
+
+	switch ((buf[1] >> 3) & 7) {
+	case 0:
+		c->code_rate_HP = FEC_1_2;
+		break;
+	case 1:
+		c->code_rate_HP = FEC_2_3;
+		break;
+	case 2:
+		c->code_rate_HP = FEC_3_4;
+		break;
+	case 3:
+		c->code_rate_HP = FEC_5_6;
+		break;
+	case 4:
+		c->code_rate_HP = FEC_7_8;
+		break;
+	}
+
+	switch ((buf[1] >> 0) & 7) {
+	case 0:
+		c->code_rate_LP = FEC_1_2;
+		break;
+	case 1:
+		c->code_rate_LP = FEC_2_3;
+		break;
+	case 2:
+		c->code_rate_LP = FEC_3_4;
+		break;
+	case 3:
+		c->code_rate_LP = FEC_5_6;
+		break;
+	case 4:
+		c->code_rate_LP = FEC_7_8;
+		break;
+	}
+
+	return 0;
+err:
+	dbg("%s: failed=%d", __func__, ret);
+	return ret;
+}
+
 static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
@@ -749,6 +861,7 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.get_tune_settings = rtl2832_get_tune_settings,
 
 	.set_frontend = rtl2832_set_frontend,
+	.get_frontend = rtl2832_get_frontend,
 
 	.read_status = rtl2832_read_status,
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
-- 
1.7.11.4

