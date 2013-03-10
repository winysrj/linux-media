Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37114 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 21/41] it913x: use dev_foo() logging
Date: Sun, 10 Mar 2013 04:03:13 +0200
Message-Id: <1362881013-5271-21-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 1cb9709..66e003f 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -175,7 +175,9 @@ static int it913x_init(struct dvb_frontend *fe)
 	default:
 		set_lna = it9135_38;
 	}
-	pr_info("Tuner LNA type :%02x\n", state->tuner_type);
+
+	dev_dbg(&state->i2c_adap->dev, "%s: Tuner LNA type :%02x\n",
+			KBUILD_MODNAME, state->tuner_type);
 
 	ret = it913x_script_loader(state, set_lna);
 	if (ret < 0)
@@ -226,7 +228,8 @@ static int it913x_init(struct dvb_frontend *fe)
 	}
 	state->tun_fn_min = state->tun_xtal * reg;
 	state->tun_fn_min /= (state->tun_fdiv * nv_val);
-	pr_debug("Tuner fn_min %d\n", state->tun_fn_min);
+	dev_dbg(&state->i2c_adap->dev, "%s: Tuner fn_min %d\n", __func__,
+			state->tun_fn_min);
 
 	if (state->chip_ver > 1)
 		msleep(50);
@@ -272,7 +275,8 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	else
 		set_tuner = set_it9137_template;
 
-	pr_debug("Tuner Frequency %d Bandwidth %d\n", frequency, bandwidth);
+	dev_dbg(&state->i2c_adap->dev, "%s: Tuner Frequency %d Bandwidth %d\n",
+			__func__, frequency, bandwidth);
 
 	if (frequency >= 51000 && frequency <= 440000) {
 		l_band = 0;
@@ -387,13 +391,15 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	set_tuner[3].reg[0] =  temp_f & 0xff;
 	set_tuner[4].reg[0] =  (temp_f >> 8) & 0xff;
 
-	pr_debug("High Frequency = %04x\n", temp_f);
+	dev_dbg(&state->i2c_adap->dev, "%s: High Frequency = %04x\n",
+			__func__, temp_f);
 
 	/* Lower frequency */
 	set_tuner[5].reg[0] =  freq & 0xff;
 	set_tuner[6].reg[0] =  (freq >> 8) & 0xff;
 
-	pr_debug("low Frequency = %04x\n", freq);
+	dev_dbg(&state->i2c_adap->dev, "%s: low Frequency = %04x\n",
+			__func__, freq);
 
 	ret = it913x_script_loader(state, set_tuner);
 
-- 
1.7.11.7

