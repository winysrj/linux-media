Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41610 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbKMWzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 17:55:48 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 3/4] si2165: cleanup logic
Date: Fri, 13 Nov 2015 23:54:57 +0100
Message-Id: <1447455298-5562-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
References: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make si2165_set_if_freq_shift query IF frequency itself.
create function to write a set of registers
Always write adc registers after reset.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 173 ++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 86 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index c5d7c0d..c87d927 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -243,6 +243,27 @@ err:
 	return ret;
 }
 
+#define REG16(reg, val) { (reg), (val) & 0xff }, { (reg)+1, (val)>>8 & 0xff }
+struct si2165_reg_value_pair {
+	u16 reg;
+	u8 val;
+};
+
+static int si2165_write_reg_list(struct si2165_state *state,
+				 const struct si2165_reg_value_pair *regs,
+				 int count)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < count; i++) {
+		ret = si2165_writereg8(state, regs[i].reg, regs[i].val);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 static int si2165_get_tune_settings(struct dvb_frontend *fe,
 				    struct dvb_frontend_tune_settings *s)
 {
@@ -669,22 +690,19 @@ static int si2165_init(struct dvb_frontend *fe)
 			goto error;
 	}
 
-	/* write adc values after each reset*/
-	ret = si2165_writereg8(state, 0x012a, 0x46);
-	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x012c, 0x00);
+	/* ts output config */
+	ret = si2165_writereg8(state, 0x04e4, 0x20);
 	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x012e, 0x0a);
+		return ret;
+	ret = si2165_writereg16(state, 0x04ef, 0x00fe);
 	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x012f, 0xff);
+		return ret;
+	ret = si2165_writereg24(state, 0x04f4, 0x555555);
 	if (ret < 0)
-		goto error;
-	ret = si2165_writereg8(state, 0x0123, 0x70);
+		return ret;
+	ret = si2165_writereg8(state, 0x04e5, 0x01);
 	if (ret < 0)
-		goto error;
+		return ret;
 
 	return 0;
 error:
@@ -746,12 +764,22 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	return si2165_writereg32(state, 0x00e4, reg_value);
 }
 
-static int si2165_set_if_freq_shift(struct si2165_state *state, u32 IF)
+static int si2165_set_if_freq_shift(struct si2165_state *state)
 {
+	struct dvb_frontend *fe = &(state->frontend);
 	u64 if_freq_shift;
 	s32 reg_value = 0;
 	u32 fe_clk = si2165_get_fe_clk(state);
+	u32 IF = 0;
+
+	if (!fe->ops.tuner_ops.get_if_frequency) {
+		dev_err(&state->i2c->dev,
+			"%s: Error: get_if_frequency() not defined at tuner. Can't work without it!\n",
+			KBUILD_MODNAME);
+		return -EINVAL;
+	}
 
+	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	if_freq_shift = IF;
 	if_freq_shift <<= 29;
 
@@ -767,35 +795,53 @@ static int si2165_set_if_freq_shift(struct si2165_state *state, u32 IF)
 	return si2165_writereg32(state, 0x00e8, reg_value);
 }
 
+static const struct si2165_reg_value_pair agc_rewrite[] = {
+	{ 0x012a, 0x46 },
+	{ 0x012c, 0x00 },
+	{ 0x012e, 0x0a },
+	{ 0x012f, 0xff },
+	{ 0x0123, 0x70 }
+};
+
+static const struct si2165_reg_value_pair dvbt_regs[] = {
+	/* impulsive_noise_remover */
+	{ 0x031c, 0x01 },
+	{ 0x00cb, 0x00 },
+	/* agc2 */
+	{ 0x016e, 0x41 },
+	{ 0x016c, 0x0e },
+	{ 0x016d, 0x10 },
+	/* agc */
+	{ 0x015b, 0x03 },
+	{ 0x0150, 0x78 },
+	/* agc */
+	{ 0x01a0, 0x78 },
+	{ 0x01c8, 0x68 },
+	/* freq_sync_range */
+	REG16(0x030c, 0x0064),
+	/* gp_reg0 */
+	{ 0x0387, 0x00 }
+};
+
 static int si2165_set_parameters(struct dvb_frontend *fe)
 {
 	int ret;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct si2165_state *state = fe->demodulator_priv;
-	u8 val[3];
-	u32 IF;
 	u32 dvb_rate = 0;
 	u16 bw10k;
+	u32 bw_hz = p->bandwidth_hz;
 
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
 
-	if (p->bandwidth_hz > 0) {
-		dvb_rate = p->bandwidth_hz * 8 / 7;
-		bw10k = p->bandwidth_hz / 10000;
-	} else {
-		dvb_rate = 8 * 8 / 7;
-		bw10k = 800;
-	}
+	if (bw_hz == 0)
+		bw_hz = 8000000;
+
+	dvb_rate = bw_hz * 8 / 7;
+	bw10k = bw_hz / 10000;
 
 	/* standard = DVB-T */
 	ret = si2165_writereg8(state, 0x00ec, 0x01);
@@ -805,26 +851,12 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
-	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
-	ret = si2165_set_if_freq_shift(state, IF);
+	ret = si2165_set_if_freq_shift(state);
 	if (ret < 0)
 		return ret;
 	ret = si2165_writereg8(state, 0x08f8, 0x00);
 	if (ret < 0)
 		return ret;
-	/* ts output config */
-	ret = si2165_writereg8(state, 0x04e4, 0x20);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg16(state, 0x04ef, 0x00fe);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg24(state, 0x04f4, 0x555555);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x04e5, 0x01);
-	if (ret < 0)
-		return ret;
 	/* bandwidth in 10KHz steps */
 	ret = si2165_writereg16(state, 0x0308, bw10k);
 	if (ret < 0)
@@ -832,48 +864,11 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
 	ret = si2165_set_oversamp(state, dvb_rate);
 	if (ret < 0)
 		return ret;
-	/* impulsive_noise_remover */
-	ret = si2165_writereg8(state, 0x031c, 0x01);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x00cb, 0x00);
-	if (ret < 0)
-		return ret;
-	/* agc2 */
-	ret = si2165_writereg8(state, 0x016e, 0x41);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x016c, 0x0e);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x016d, 0x10);
-	if (ret < 0)
-		return ret;
-	/* agc */
-	ret = si2165_writereg8(state, 0x015b, 0x03);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x0150, 0x78);
-	if (ret < 0)
-		return ret;
-	/* agc */
-	ret = si2165_writereg8(state, 0x01a0, 0x78);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x01c8, 0x68);
-	if (ret < 0)
-		return ret;
-	/* freq_sync_range */
-	ret = si2165_writereg16(state, 0x030c, 0x0064);
-	if (ret < 0)
-		return ret;
-	/* gp_reg0 */
-	ret = si2165_readreg8(state, 0x0387, val);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x0387, 0x00);
+
+	ret = si2165_write_reg_list(state, dvbt_regs, ARRAY_SIZE(dvbt_regs));
 	if (ret < 0)
 		return ret;
+
 	/* dsp_addr_jump */
 	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
 	if (ret < 0)
@@ -883,8 +878,7 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* recalc if_freq_shift if IF might has changed */
-	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
-	ret = si2165_set_if_freq_shift(state, IF);
+	ret = si2165_set_if_freq_shift(state);
 	if (ret < 0)
 		return ret;
 
@@ -903,6 +897,13 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
 	ret = si2165_writereg32(state, 0x0384, 0x00000000);
 	if (ret < 0)
 		return ret;
+
+	/* write adc values after each reset*/
+	ret = si2165_write_reg_list(state, agc_rewrite,
+				    ARRAY_SIZE(agc_rewrite));
+	if (ret < 0)
+		goto error;
+
 	/* start_synchro */
 	ret = si2165_writereg8(state, 0x02e0, 0x01);
 	if (ret < 0)
-- 
2.6.3

