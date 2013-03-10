Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49875 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3CJCEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:39 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 12/41] af9033: IT9135 v2 supported related changes
Date: Sun, 10 Mar 2013 04:03:04 +0200
Message-Id: <1362881013-5271-12-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index dece775..f510228 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -285,10 +285,29 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	/*
+	 * FIXME: These inits are logically property of demodulator driver
+	 * (that driver), but currently in case of IT9135 those are done by
+	 * tuner driver.
+	 */
+
 	/* load OFSM settings */
 	dev_dbg(&state->i2c->dev, "%s: load ofsm settings\n", __func__);
-	len = ARRAY_SIZE(ofsm_init);
-	init = ofsm_init;
+	switch (state->cfg.tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		len = 0;
+		break;
+	default:
+		len = ARRAY_SIZE(ofsm_init);
+		init = ofsm_init;
+		break;
+	}
+
 	for (i = 0; i < len; i++) {
 		ret = af9033_wr_reg(state, init[i].reg, init[i].val);
 		if (ret < 0)
@@ -424,7 +443,8 @@ err:
 static int af9033_get_tune_settings(struct dvb_frontend *fe,
 		struct dvb_frontend_tune_settings *fesettings)
 {
-	fesettings->min_delay_ms = 800;
+	/* 800 => 2000 because IT9135 v2 is slow to gain lock */
+	fesettings->min_delay_ms = 2000;
 	fesettings->step_size = 0;
 	fesettings->max_drift = 0;
 
@@ -513,6 +533,11 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		buf[0] = (freq_cw >>  0) & 0xff;
 		buf[1] = (freq_cw >>  8) & 0xff;
 		buf[2] = (freq_cw >> 16) & 0x7f;
+
+		/* FIXME: there seems to be calculation error here... */
+		if (if_frequency == 0)
+			buf[2] = 0;
+
 		ret = af9033_wr_regs(state, 0x800029, buf, 3);
 		if (ret < 0)
 			goto err;
-- 
1.7.11.7

