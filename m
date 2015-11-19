Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54372 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082AbbKSUFB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:05:01 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 06/10] si2165: Simplify si2165_set_if_freq_shift usage
Date: Thu, 19 Nov 2015 21:03:58 +0100
Message-Id: <1447963442-9764-7-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 0c1f4c4..807a3c9 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -764,12 +764,22 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	return si2165_writereg32(state, 0x00e4, reg_value);
 }
 
-static int si2165_set_if_freq_shift(struct si2165_state *state, u32 IF)
+static int si2165_set_if_freq_shift(struct si2165_state *state)
 {
+	struct dvb_frontend *fe = &state->fe;
 	u64 if_freq_shift;
 	s32 reg_value = 0;
 	u32 fe_clk = si2165_get_fe_clk(state);
+	u32 IF = 0;
 
+	if (!fe->ops.tuner_ops.get_if_frequency) {
+		dev_err(&state->i2c->dev,
+			"%s: Error: get_if_frequency() not defined at tuner. Can't work without it!\n",
+			KBUILD_MODNAME);
+		return -EINVAL;
+	}
+
+	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	if_freq_shift = IF;
 	if_freq_shift <<= 29;
 
@@ -799,19 +809,11 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct si2165_state *state = fe->demodulator_priv;
 	u8 val[3];
-	u32 IF;
 	u32 dvb_rate = 0;
 	u16 bw10k;
 
 	dprintk("%s: called\n", __func__);
 
-	if (!fe->ops.tuner_ops.get_if_frequency) {
-		dev_err(&state->i2c->dev,
-			"%s: Error: get_if_frequency() not defined at tuner. Can't work without it!\n",
-			KBUILD_MODNAME);
-		return -EINVAL;
-	}
-
 	if (!state->has_dvbt)
 		return -EINVAL;
 
@@ -831,8 +833,7 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
-	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
-	ret = si2165_set_if_freq_shift(state, IF);
+	ret = si2165_set_if_freq_shift(state);
 	if (ret < 0)
 		return ret;
 	ret = si2165_writereg8(state, 0x08f8, 0x00);
@@ -896,8 +897,7 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* recalc if_freq_shift if IF might has changed */
-	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
-	ret = si2165_set_if_freq_shift(state, IF);
+	ret = si2165_set_if_freq_shift(state);
 	if (ret < 0)
 		return ret;
 
-- 
2.6.3

