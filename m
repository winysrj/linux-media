Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50332 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2DEQr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 12:47:29 -0400
Received: by wgbdr13 with SMTP id dr13so1502771wgb.1
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 09:47:28 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] af9033: implement get_frontend
Date: Thu,  5 Apr 2012 18:47:19 +0200
Message-Id: <1333644439-1875-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the get_frontend function.
The code is derived from the old af9033 driver by Antti Palosaari.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/frontends/af9033.c |  133 ++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9033.c b/drivers/media/dvb/frontends/af9033.c
index 5fadee7..da91155 100644
--- a/drivers/media/dvb/frontends/af9033.c
+++ b/drivers/media/dvb/frontends/af9033.c
@@ -26,6 +26,7 @@ struct af9033_state {
 	struct dvb_frontend fe;
 	struct af9033_config cfg;
 
+	u32 frequency;
 	u32 bandwidth_hz;
 	bool ts_mode_parallel;
 	bool ts_mode_serial;
@@ -406,6 +407,8 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	pr_debug("%s: frequency=%d bandwidth_hz=%d\n", __func__, c->frequency,
 			c->bandwidth_hz);
 
+	state->frequency = c->frequency;
+
 	/* check bandwidth */
 	switch (c->bandwidth_hz) {
 	case 6000000:
@@ -523,6 +526,135 @@ err:
 	return ret;
 }
 
+static int af9033_get_frontend(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct af9033_state *state = fe->demodulator_priv;
+	int ret;
+	u8 buf[8];
+
+	pr_debug("%s\n", __func__);
+
+	/* read all needed registers */
+	ret = af9033_rd_regs(state, 0x80f900, buf, sizeof(buf));
+	if (ret)
+		goto error;
+
+	switch ((buf[0] >> 0) & 3) {
+	case 0:
+		p->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case 1:
+		p->transmission_mode = TRANSMISSION_MODE_8K;
+		break;
+	}
+
+	switch ((buf[1] >> 0) & 3) {
+	case 0:
+		p->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case 1:
+		p->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case 2:
+		p->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case 3:
+		p->guard_interval = GUARD_INTERVAL_1_4;
+		break;
+	}
+
+	switch ((buf[2] >> 0) & 7) {
+	case 0:
+		p->hierarchy = HIERARCHY_NONE;
+		break;
+	case 1:
+		p->hierarchy = HIERARCHY_1;
+		break;
+	case 2:
+		p->hierarchy = HIERARCHY_2;
+		break;
+	case 3:
+		p->hierarchy = HIERARCHY_4;
+		break;
+	}
+
+	switch ((buf[3] >> 0) & 3) {
+	case 0:
+		p->modulation = QPSK;
+		break;
+	case 1:
+		p->modulation = QAM_16;
+		break;
+	case 2:
+		p->modulation = QAM_64;
+		break;
+	}
+
+	switch ((buf[4] >> 0) & 3) {
+	case 0:
+		p->bandwidth_hz = 6000000;
+		break;
+	case 1:
+		p->bandwidth_hz = 7000000;
+		break;
+	case 2:
+		p->bandwidth_hz = 8000000;
+		break;
+	}
+
+	switch ((buf[6] >> 0) & 7) {
+	case 0:
+		p->code_rate_HP = FEC_1_2;
+		break;
+	case 1:
+		p->code_rate_HP = FEC_2_3;
+		break;
+	case 2:
+		p->code_rate_HP = FEC_3_4;
+		break;
+	case 3:
+		p->code_rate_HP = FEC_5_6;
+		break;
+	case 4:
+		p->code_rate_HP = FEC_7_8;
+		break;
+	case 5:
+		p->code_rate_HP = FEC_NONE;
+		break;
+	}
+
+	switch ((buf[7] >> 0) & 7) {
+	case 0:
+		p->code_rate_LP = FEC_1_2;
+		break;
+	case 1:
+		p->code_rate_LP = FEC_2_3;
+		break;
+	case 2:
+		p->code_rate_LP = FEC_3_4;
+		break;
+	case 3:
+		p->code_rate_LP = FEC_5_6;
+		break;
+	case 4:
+		p->code_rate_LP = FEC_7_8;
+		break;
+	case 5:
+		p->code_rate_LP = FEC_NONE;
+		break;
+	}
+
+	p->inversion = INVERSION_AUTO;
+	p->frequency = state->frequency;
+
+error:
+	if (ret)
+		pr_debug("%s: failed:%d\n", __func__, ret);
+
+	return ret;
+}
+
 static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct af9033_state *state = fe->demodulator_priv;
@@ -776,6 +908,7 @@ static struct dvb_frontend_ops af9033_ops = {
 
 	.get_tune_settings = af9033_get_tune_settings,
 	.set_frontend = af9033_set_frontend,
+	.get_frontend = af9033_get_frontend,
 
 	.read_status = af9033_read_status,
 	.read_snr = af9033_read_snr,
-- 
1.7.0.4

